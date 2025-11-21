Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  
  # Celeron-optimized settings - ultra minimal
  config.vm.disk :disk, size: "6GB", primary: true
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  # Disable automatic box update checking for faster startup on Celeron
  config.vm.box_check_update = false

  # Master Desktop Linux - Slade
  config.vm.define "slade" do |slade|
    slade.vm.hostname = "slade-master"
    slade.vm.network "public_network", bridge: "auto"
    slade.vm.network "private_network", ip: "192.168.56.10"
    
    slade.vm.provider "virtualbox" do |vb|
      vb.name = "Slade-Master-Desktop"
      vb.memory = 512
      vb.cpus = 1
      vb.gui = true
      # Celeron optimization - minimal resources
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
      vb.customize ["modifyvm", :id, "--vram", "12"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--nestedpaging", "on"]
      vb.customize ["modifyvm", :id, "--largepages", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    
    slade.vm.provision "shell", inline: <<-SHELL
      # Ultra-minimal system for Celeron compatibility
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      
      # Install bare minimum desktop (LXDE instead of full Ubuntu desktop)
      sudo apt-get install -y --no-install-recommends lxde-core lxde-common
      sudo apt-get install -y --no-install-recommends git curl wget vim htop neofetch figlet lolcat openssh-server
      
      # Remove heavy packages that come with Ubuntu
      sudo apt-get remove -y --purge snapd firefox thunderbird libreoffice* 2>/dev/null || true
      
      # Ultra-aggressive cleanup for Celeron
      sudo apt-get autoremove -y
      sudo apt-get autoclean
      sudo rm -rf /var/lib/apt/lists/*
      sudo rm -rf /tmp/*
      sudo rm -rf /var/tmp/*
      sudo rm -rf /var/cache/*
      sudo rm -rf /usr/share/doc/*
      sudo rm -rf /usr/share/man/*
      
      # Limit journal to minimal size for Celeron
      sudo journalctl --vacuum-size=10M
      
      # Optimize swappiness for low RAM
      echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
      
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
echo "║  Connected Nodes: ubuntu1, goldenfish                               ║" | lolcat
echo "║  Control Panel: Available via SSH and Desktop                       ║" | lolcat
echo "╚══════════════════════════════════════════════════════════════════════╝" | lolcat
echo ""
neofetch
echo ""
echo "Available Commands:" | lolcat
echo "  • connect-ubuntu1   : SSH to Ubuntu Node 1" | lolcat
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
      
      sudo tee /usr/local/bin/connect-goldenfish > /dev/null << 'EOF'
#!/bin/bash
ssh vagrant@192.168.56.14
EOF
      
      sudo tee /usr/local/bin/cluster-status > /dev/null << 'EOF'
#!/bin/bash
echo "Checking cluster status..." | lolcat
if ping -c 1 192.168.56.11 &> /dev/null; then
  echo "✅ Ubuntu1 (192.168.56.11) - ONLINE" | lolcat
else
  echo "❌ Ubuntu1 (192.168.56.11) - OFFLINE" | lolcat
fi
if ping -c 1 192.168.56.14 &> /dev/null; then
  echo "✅ GoldenFish (192.168.56.14) - ONLINE" | lolcat
else
  echo "❌ GoldenFish (192.168.56.14) - OFFLINE" | lolcat
fi
EOF
      
      sudo tee /usr/local/bin/deploy-all > /dev/null << 'EOF'
#!/bin/bash
echo "Deploying to all nodes..." | lolcat
echo "Deploying to Ubuntu1..." | lolcat
# Add your deployment commands here for ubuntu1
echo "Deploying to GoldenFish..." | lolcat
# Add your deployment commands here for goldenfish
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
      vb.memory = 256
      vb.cpus = 1
      # Ultra-minimal for Celeron processors
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
      vb.customize ["modifyvm", :id, "--vram", "8"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--nestedpaging", "on"]
      vb.customize ["modifyvm", :id, "--largepages", "on"]
    end
    
    worker.vm.provision "shell", inline: <<-SHELL
      # Ultra-minimal installation for Celeron compatibility
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends curl wget vim neofetch figlet lolcat openssh-server
      
      # Remove unnecessary packages
      sudo apt-get remove -y --purge snapd 2>/dev/null || true
      
      # Aggressive cleanup for Celeron systems
      sudo apt-get autoremove -y
      sudo apt-get autoclean
      sudo rm -rf /var/lib/apt/lists/*
      sudo rm -rf /tmp/*
      sudo rm -rf /var/tmp/*
      sudo rm -rf /usr/share/doc/*
      sudo rm -rf /usr/share/man/*
      sudo journalctl --vacuum-size=5M
      
      # Optimize for low memory
      echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf
      
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



  # Golden Fish Node
  config.vm.define "goldenfish" do |worker|
    worker.vm.hostname = "goldenfish"
    worker.vm.network "public_network", bridge: "auto"
    worker.vm.network "private_network", ip: "192.168.56.14"
    
    worker.vm.provider "virtualbox" do |vb|
      vb.name = "Golden-Fish-Node"
      vb.memory = 256
      vb.cpus = 1
      # Ultra-minimal for Celeron with amnesia optimization
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
      vb.customize ["modifyvm", :id, "--vram", "8"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--nestedpaging", "on"]
    end
    
    worker.vm.provision "shell", inline: <<-SHELL
      # Ultra-minimal package installation
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends git curl wget vim htop neofetch figlet lolcat openssh-server cowsay fortune-mod
      
      # Aggressive cleanup for amnesia node
      sudo apt-get autoremove -y
      sudo apt-get autoclean
      sudo rm -rf /var/lib/apt/lists/*
      sudo rm -rf /tmp/*
      sudo rm -rf /var/tmp/*
      sudo rm -rf /var/log/*
      sudo journalctl --vacuum-size=1M
      
      # Create goldenfish user with default password
      sudo useradd -m -s /bin/bash goldenfish
      echo "goldenfish:vagrant" | sudo chpasswd
      sudo usermod -aG sudo goldenfish
      echo "goldenfish ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
      
      # EXTREME AMNESIA CONFIGURATION - Ultra volatile
      # Mount tmpfs for maximum volatility (smaller sizes)
      echo "tmpfs /home/goldenfish tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777,size=50M 0 0" >> /etc/fstab
      echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777,size=100M 0 0" >> /etc/fstab
      echo "tmpfs /var/log tmpfs defaults,noatime,nosuid,nodev,noexec,mode=0755,size=10M 0 0" >> /etc/fstab
      
      # Disable all logging and history
      echo "unset HISTFILE" >> /home/goldenfish/.bashrc
      echo "export HISTSIZE=0" >> /home/goldenfish/.bashrc
      echo "export HISTFILESIZE=0" >> /home/goldenfish/.bashrc
      echo "set +o history" >> /home/goldenfish/.bashrc
      
      # Ultra-aggressive cleanup script
      sudo tee /usr/local/bin/amnesia-cleanup > /dev/null << 'CLEANUP'
#!/bin/bash
# Nuclear cleanup - leave no trace
> /var/log/auth.log 2>/dev/null || true
> /var/log/syslog 2>/dev/null || true
> /var/log/kern.log 2>/dev/null || true
rm -rf /home/goldenfish/.* 2>/dev/null || true
rm -rf /home/goldenfish/* 2>/dev/null || true
rm -rf /tmp/* 2>/dev/null || true
rm -rf /var/tmp/* 2>/dev/null || true
sync
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
