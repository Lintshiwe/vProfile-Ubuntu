# Slade Master Control System - Multi-VM Environment

A complete Linux cluster setup with Slade as the master desktop controller and 4 worker nodes, featuring animated welcome screens and real IP connectivity.

## 🎯 Architecture

- **Slade Master**: Desktop Linux with GUI, controls all worker nodes
- **Worker Nodes 1-4**: Headless servers controlled by Slade
- **Real IP**: Public network bridge for internet access
- **Private Network**: Internal cluster communication

## 📋 Prerequisites

- **VirtualBox** (hypervisor): https://www.virtualbox.org/wiki/Downloads
- **Vagrant** (VM automation): https://developer.hashicorp.com/vagrant/downloads
- **Minimum System**: 8GB RAM, 4 CPU cores (for full cluster)
- **Network**: Bridged adapter capability for real IP

Install VirtualBox first, then Vagrant. Reboot if either installer asks you to.

## 🚀 Quick Start

### Start the Master Node (Slade)

```bash
cd /path/to/vProfile-Ubuntu
vagrant up slade
```

### Connect to Slade Master

```bash
vagrant ssh slade
```

### Start All Worker Nodes

```bash
vagrant up worker1 worker2 worker3 worker4
```

### Start Everything at Once

```bash
vagrant up
```

## 🎮 Master Control Commands

Once connected to Slade master, use these commands:

```bash
# Connect to worker nodes
connect-worker1    # SSH to Worker Node 1
connect-worker2    # SSH to Worker Node 2
connect-worker3    # SSH to Worker Node 3
connect-worker4    # SSH to Worker Node 4

# Cluster management
cluster-status     # Check all nodes status
status            # Same as cluster-status (alias)
deploy-all        # Deploy to all worker nodes
```

## 🌐 Network Configuration

### IP Addresses:

- **Slade Master**: 192.168.56.10 + Real IP (DHCP)
- **Worker 1**: 192.168.56.11 + Real IP (DHCP)
- **Worker 2**: 192.168.56.12 + Real IP (DHCP)
- **Worker 3**: 192.168.56.13 + Real IP (DHCP)
- **Worker 4**: 192.168.56.14 + Real IP (DHCP)

### Network Types:

- **Public Network**: Bridged for real internet IP
- **Private Network**: Internal cluster communication

## 🎨 Features

### ✨ Animated Welcome Screens

- Colorful ASCII art with figlet and lolcat
- System information display with neofetch
- Role-specific welcome messages
- Interactive command suggestions

### 🖥️ Interactive Terminal

- Color-coded prompts for each node
- Custom aliases and shortcuts
- Enhanced bash experience
- Command history and completion

### 🔧 Master Control

- SSH key-based authentication
- Cluster status monitoring
- Centralized deployment scripts
- Desktop GUI for visual management

## 📱 Individual VM Management

```bash
# Start specific VMs
vagrant up slade          # Start master only
vagrant up worker1        # Start worker 1 only
vagrant up worker2 worker3 # Start workers 2 & 3

# Connect to specific VMs
vagrant ssh slade         # Connect to master
vagrant ssh worker1       # Connect to worker 1

# Halt specific VMs
vagrant halt worker1      # Stop worker 1
vagrant halt slade        # Stop master

# Status check
vagrant status            # Show all VM status
```

## 🛠️ Troubleshooting

### If VMs fail to get real IP:

1. Check VirtualBox Host-Only Network settings
2. Ensure bridged adapter is selected correctly
3. Try different network interface in bridge settings

### If SSH connections fail between nodes:

```bash
# From Slade master, regenerate SSH keys
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Copy keys to workers (replace X with worker number)
ssh-copy-id vagrant@192.168.56.1X
```

### Performance optimization for Celeron systems:

- Start VMs one by one instead of all together
- Reduce worker memory if needed (edit Vagrantfile)
- Use `vagrant halt` when not using specific nodes

## 🔄 Complete Shutdown

```bash
# Graceful shutdown
vagrant halt

# Complete removal (frees disk space)
vagrant destroy

# Remove specific VMs
vagrant destroy slade worker1
```

## 📊 Resource Usage

| VM           | Memory  | CPU         | Purpose                     |
| ------------ | ------- | ----------- | --------------------------- |
| Slade Master | 2048MB  | 2           | Desktop controller with GUI |
| Worker 1-4   | 1024MB  | 1           | Headless worker nodes       |
| **Total**    | **6GB** | **6 cores** | **Full cluster**            |

## 🔐 Security Features

- SSH key-based authentication between nodes
- Isolated private network for cluster communication
- Real IP access for internet connectivity
- User-based access control
