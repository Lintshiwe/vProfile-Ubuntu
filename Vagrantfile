Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # Master Desktop Linux - Slade
  config.vm.define "slade" do |slade|
    slade.vm.hostname = "slade-master"
    slade.vm.network "public_network", bridge: "auto"
    slade.vm.network "private_network", ip: "192.168.56.10"
    
    slade.vm.provider "virtualbox" do |vb|
      vb.name = "Slade-Master-Desktop"
      vb.memory = 4096
      vb.cpus = 2
      vb.gui = true
    end
    
    slade.vm.provision "shell", inline: <<-SHELL
      # Update system
      sudo apt-get update
      sudo apt-get install -y ubuntu-desktop-minimal
      sudo apt-get install -y build-essential git curl wget vim htop neofetch figlet lolcat
      sudo apt-get install -y openssh-server ansible
      
      # Enable SSH
      sudo systemctl enable ssh
      sudo systemctl start ssh
      
      # Create welcome script with animation
      sudo tee /etc/profile.d/welcome.sh > /dev/null << 'EOF'
#!/bin/bash
clear
echo ""
figlet -f big "SLADE MASTER" | lolcat
echo ""
echo "╔══════════════════════════════════════════════════════════════════════╗" | lolcat
echo "║                    🚀 WELCOME TO SLADE MASTER SYSTEM 🚀              ║" | lolcat
echo "║                                                                      ║" | lolcat
echo "║  Master Desktop Linux Controller                                    ║" | lolcat
echo "║  Hostname: $(hostname)                                               ║" | lolcat
echo "║  User: $(whoami)                                                     ║" | lolcat
echo "║  Date: $(date)                                                       ║" | lolcat
echo "║                                                                      ║" | lolcat
echo "║  Connected Nodes: ubuntu1, ubuntu2, ubuntu3, goldenfish             ║" | lolcat
echo "║  Control Panel: Available via SSH and Desktop                       ║" | lolcat
echo "╚══════════════════════════════════════════════════════════════════════╝" | lolcat
echo ""
neofetch
echo ""
echo "Available Commands:" | lolcat
echo "  • connect-ubuntu1   : SSH to Ubuntu Node 1" | lolcat
echo "  • connect-ubuntu2   : SSH to Ubuntu Node 2" | lolcat
echo "  • connect-ubuntu3   : SSH to Ubuntu Node 3" | lolcat
echo "  • connect-goldenfish: SSH to Golden Fish Node" | lolcat
echo "  • cluster-status    : Check all nodes status" | lolcat
echo "  • deploy-all        : Deploy to all nodes" | lolcat
echo ""
EOF
      
      # Create connection scripts
      sudo tee /usr/local/bin/connect-ubuntu1 > /dev/null << 'EOF'
#!/bin/bash
ssh vagrant@192.168.56.11
EOF
      
      sudo tee /usr/local/bin/connect-ubuntu2 > /dev/null << 'EOF'
#!/bin/bash
ssh vagrant@192.168.56.12
EOF
      
      sudo tee /usr/local/bin/connect-ubuntu3 > /dev/null << 'EOF'
#!/bin/bash
ssh vagrant@192.168.56.13
EOF
      
      sudo tee /usr/local/bin/connect-goldenfish > /dev/null << 'EOF'
#!/bin/bash
ssh vagrant@192.168.56.14
EOF
      
      sudo tee /usr/local/bin/cluster-status > /dev/null << 'EOF'
#!/bin/bash
echo "Checking cluster status..." | lolcat
for i in {11..14}; do
  case $i in
    11) name="Ubuntu1" ;;
    12) name="Ubuntu2" ;;
    13) name="Ubuntu3" ;;
    14) name="GoldenFish" ;;
  esac
  if ping -c 1 192.168.56.$i &> /dev/null; then
    echo "✅ $name (192.168.56.$i) - ONLINE" | lolcat
  else
    echo "❌ $name (192.168.56.$i) - OFFLINE" | lolcat
  fi
done
EOF
      
      sudo tee /usr/local/bin/deploy-all > /dev/null << 'EOF'
#!/bin/bash
echo "Deploying to all nodes..." | lolcat
for i in {11..14}; do
  case $i in
    11) name="Ubuntu1" ;;
    12) name="Ubuntu2" ;;
    13) name="Ubuntu3" ;;
    14) name="GoldenFish" ;;
  esac
  echo "Deploying to $name..." | lolcat
  # Add your deployment commands here
done
echo "Deployment completed!" | lolcat
EOF
      
      # Make scripts executable
      sudo chmod +x /usr/local/bin/connect-ubuntu*
      sudo chmod +x /usr/local/bin/connect-goldenfish
      sudo chmod +x /usr/local/bin/cluster-status
      sudo chmod +x /usr/local/bin/deploy-all
      sudo chmod +x /etc/profile.d/welcome.sh
      
      # Generate SSH key for cluster management
      sudo -u vagrant ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -N ""
      
      # Set custom password for vagrant user
      echo "vagrant:Slade@1452" | sudo chpasswd
      
      # Create Slade user with custom password
      sudo useradd -m -s /bin/bash slade
      echo "slade:Slade@1452" | sudo chpasswd
      sudo usermod -aG sudo slade
      
      # Copy SSH keys and configuration to slade user
      sudo cp -r /home/vagrant/.ssh /home/slade/
      sudo chown -R slade:slade /home/slade/.ssh
      
      # Add slade user to sudoers for passwordless sudo
      echo "slade ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
      
      # Interactive bash configuration
      echo 'export PS1="\\[\\033[01;32m\\]slade-master\\[\\033[00m\\]@\\[\\033[01;34m\\]\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/vagrant/.bashrc
      echo "alias ll='ls -alF'" >> /home/vagrant/.bashrc
      echo "alias la='ls -A'" >> /home/vagrant/.bashrc
      echo "alias l='ls -CF'" >> /home/vagrant/.bashrc
      echo "alias status='cluster-status'" >> /home/vagrant/.bashrc
    SHELL
  end

  # Ubuntu Node 1
  config.vm.define "ubuntu1" do |worker|
    worker.vm.hostname = "ubuntu1"
    worker.vm.network "public_network", bridge: "auto"
    worker.vm.network "private_network", ip: "192.168.56.11"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "Ubuntu-Node-1"
      vb.memory = 4096
      vb.cpus = 1
    end
    
    worker.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y build-essential git curl wget vim htop neofetch figlet lolcat openssh-server
      
      # Create ubuntu1 user with default password
      sudo useradd -m -s /bin/bash ubuntu1
      echo "ubuntu1:vagrant" | sudo chpasswd
      sudo usermod -aG sudo ubuntu1
      echo "ubuntu1 ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
      
      # Worker welcome script
      sudo tee /etc/profile.d/welcome.sh > /dev/null << 'EOF'
#!/bin/bash
clear
echo ""
figlet -f small "UBUNTU NODE 1" | lolcat
echo ""
echo "🔧 Controlled by Slade Master (192.168.56.10)" | lolcat
echo "📊 Status: Ready for tasks" | lolcat
echo "🌐 IP: $(hostname -I | awk '{print $1}')" | lolcat
echo "👤 User: ubuntu1 | Password: vagrant" | lolcat
echo ""
neofetch --ascii_distro ubuntu_small
echo ""
EOF
      
      sudo chmod +x /etc/profile.d/welcome.sh
      echo 'export PS1="\\[\\033[01;33m\\]ubuntu1\\[\\033[00m\\]@\\[\\033[01;34m\\]\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/vagrant/.bashrc
      echo 'export PS1="\\[\\033[01;33m\\]ubuntu1\\[\\033[00m\\]@\\[\\033[01;34m\\]\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/ubuntu1/.bashrc
    SHELL
  end

  # Ubuntu Node 2
  config.vm.define "ubuntu2" do |worker|
    worker.vm.hostname = "ubuntu2"
    worker.vm.network "public_network", bridge: "auto"
    worker.vm.network "private_network", ip: "192.168.56.12"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "Ubuntu-Node-2"
      vb.memory = 4096
      vb.cpus = 1
    end
    
    worker.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y build-essential git curl wget vim htop neofetch figlet lolcat openssh-server
      
      # Create ubuntu2 user with default password
      sudo useradd -m -s /bin/bash ubuntu2
      echo "ubuntu2:vagrant" | sudo chpasswd
      sudo usermod -aG sudo ubuntu2
      echo "ubuntu2 ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
      
      # Worker welcome script
      sudo tee /etc/profile.d/welcome.sh > /dev/null << 'EOF'
#!/bin/bash
clear
echo ""
figlet -f small "UBUNTU NODE 2" | lolcat
echo ""
echo "🔧 Controlled by Slade Master (192.168.56.10)" | lolcat
echo "📊 Status: Ready for tasks" | lolcat
echo "🌐 IP: $(hostname -I | awk '{print $1}')" | lolcat
echo "👤 User: ubuntu2 | Password: vagrant" | lolcat
echo ""
neofetch --ascii_distro ubuntu_small
echo ""
EOF
      
      sudo chmod +x /etc/profile.d/welcome.sh
      echo 'export PS1="\\[\\033[01;36m\\]ubuntu2\\[\\033[00m\\]@\\[\\033[01;34m\\]\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/vagrant/.bashrc
      echo 'export PS1="\\[\\033[01;36m\\]ubuntu2\\[\\033[00m\\]@\\[\\033[01;34m\\]\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/ubuntu2/.bashrc
    SHELL
  end

  # Ubuntu Node 3
  config.vm.define "ubuntu3" do |worker|
    worker.vm.hostname = "ubuntu3"
    worker.vm.network "public_network", bridge: "auto"
    worker.vm.network "private_network", ip: "192.168.56.13"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "Ubuntu-Node-3"
      vb.memory = 4096
      vb.cpus = 1
    end
    
    worker.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y build-essential git curl wget vim htop neofetch figlet lolcat openssh-server
      
      # Create ubuntu3 user with default password
      sudo useradd -m -s /bin/bash ubuntu3
      echo "ubuntu3:vagrant" | sudo chpasswd
      sudo usermod -aG sudo ubuntu3
      echo "ubuntu3 ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
      
      # Worker welcome script
      sudo tee /etc/profile.d/welcome.sh > /dev/null << 'EOF'
#!/bin/bash
clear
echo ""
figlet -f small "UBUNTU NODE 3" | lolcat
echo ""
echo "🔧 Controlled by Slade Master (192.168.56.10)" | lolcat
echo "📊 Status: Ready for tasks" | lolcat
echo "🌐 IP: $(hostname -I | awk '{print $1}')" | lolcat
echo "👤 User: ubuntu3 | Password: vagrant" | lolcat
echo ""
neofetch --ascii_distro ubuntu_small
echo ""
EOF
      
      sudo chmod +x /etc/profile.d/welcome.sh
      echo 'export PS1="\\[\\033[01;35m\\]ubuntu3\\[\\033[00m\\]@\\[\\033[01;34m\\]\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/vagrant/.bashrc
      echo 'export PS1="\\[\\033[01;35m\\]ubuntu3\\[\\033[00m\\]@\\[\\033[01;34m\\]\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/ubuntu3/.bashrc
    SHELL
  end

  # Golden Fish Node
  config.vm.define "goldenfish" do |worker|
    worker.vm.hostname = "goldenfish"
    worker.vm.network "public_network", bridge: "auto"
    worker.vm.network "private_network", ip: "192.168.56.14"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "Golden-Fish-Node"
      vb.memory = 4096
      vb.cpus = 1
    end
    
    worker.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y build-essential git curl wget vim htop neofetch figlet lolcat openssh-server cowsay fortune
      
      # Create goldenfish user with default password
      sudo useradd -m -s /bin/bash goldenfish
      echo "goldenfish:vagrant" | sudo chpasswd
      sudo usermod -aG sudo goldenfish
      echo "goldenfish ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
      
      # AMNESIA CONFIGURATION - No persistent storage
      # Mount tmpfs for user directories to make them volatile
      echo "tmpfs /home/goldenfish tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777,size=100M 0 0" >> /etc/fstab
      echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777,size=200M 0 0" >> /etc/fstab
      
      # Disable bash history permanently
      echo "unset HISTFILE" >> /home/goldenfish/.bashrc
      echo "export HISTSIZE=0" >> /home/goldenfish/.bashrc
      echo "export HISTFILESIZE=0" >> /home/goldenfish/.bashrc
      echo "set +o history" >> /home/goldenfish/.bashrc
      
      # Disable system logging for this user
      echo "goldenfish ALL=(ALL) NOPASSWD:ALL, !/usr/bin/logger, !/bin/logger" >> /etc/sudoers
      
      # Clear logs on startup script
      sudo tee /usr/local/bin/amnesia-cleanup > /dev/null << 'CLEANUP'
#!/bin/bash
# Clear all traces
> /var/log/auth.log
> /var/log/syslog
> /var/log/kern.log
> /home/goldenfish/.bash_history 2>/dev/null || true
rm -rf /home/goldenfish/.cache/* 2>/dev/null || true
rm -rf /home/goldenfish/.local/* 2>/dev/null || true
echo "🧠💭 Amnesia activated - Memory wiped clean!" | logger
CLEANUP
      
      sudo chmod +x /usr/local/bin/amnesia-cleanup
      
      # Add cleanup to startup
      echo "@reboot root /usr/local/bin/amnesia-cleanup" >> /etc/crontab
      
      # Golden Fish welcome script with amnesia warnings
      sudo tee /etc/profile.d/welcome.sh > /dev/null << 'EOF'
#!/bin/bash
clear
echo ""
echo "🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨" | lolcat
figlet -f big "GOLDEN FISH" | lolcat
echo "🐠🐟🐡🦈🐠🐟🐡🦈🐠🐟🐡🦈🐠🐟🐡🦈🐠🐟🐡🦈" | lolcat
echo ""
echo "🏆 Special Golden Node - Premium Status" | lolcat
echo "🧠 AMNESIA MODE: No persistent memory!" | lolcat
echo "🚫 Files & history vanish on shutdown/reboot" | lolcat
echo "🕵️  Untraceable operations - Leave no trace" | lolcat
echo "🔧 Controlled by Slade Master (192.168.56.10)" | lolcat
echo "📊 Status: Golden and Volatile!" | lolcat
echo "🌐 IP: $(hostname -I | awk '{print $1}')" | lolcat
echo "👤 User: goldenfish | Password: vagrant" | lolcat
echo ""
neofetch --ascii_distro ubuntu_small
echo ""
fortune | cowsay -f tux | lolcat
echo ""
echo "⚠️  WARNING: This session is VOLATILE - Nothing persists!" | lolcat
echo "🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨🌟✨" | lolcat
EOF
      
      sudo chmod +x /etc/profile.d/welcome.sh
      echo 'export PS1="\\[\\033[01;33m\\]🐠goldenfish\\[\\033[00m\\]@\\[\\033[01;93m\\]\\h\\[\\033[00m\\]:\\[\\033[01;93m\\]\\w\\[\\033[00m\\]✨\\$ "' >> /home/vagrant/.bashrc
      echo 'export PS1="\\[\\033[01;33m\\]🐠goldenfish\\[\\033[00m\\]@\\[\\033[01;93m\\]\\h\\[\\033[00m\\]:\\[\\033[01;93m\\]\\w\\[\\033[00m\\]✨\\$ "' >> /home/goldenfish/.bashrc
    SHELL
  end
end
