# Practice Ubuntu VM with Vagrant

Follow these steps to get a lightweight Ubuntu practice environment running on a Celeron-class computer.

## 1. Install Prerequisites

- **VirtualBox** (hypervisor): https://www.virtualbox.org/wiki/Downloads
- **Vagrant** (VM automation): https://developer.hashicorp.com/vagrant/downloads

Install VirtualBox first, then Vagrant. Reboot if either installer asks you to.

## 2. Start the VM

1. Download or clone this project folder.
2. Open a terminal and change into the project directory:
   ```bash
   cd /path/to/vProfile-Ubuntu
   ```
3. Launch the virtual machine (first run downloads the Ubuntu box):
   ```bash
   vagrant up
   ```
4. Connect to the VM once provisioning completes:
   ```bash
   vagrant ssh
   ```

## 3. Shut Down or Remove the VM

- Stop the VM when you are done:
  ```bash
  vagrant halt
  ```
- Remove the VM completely to free disk space:
  ```bash
  vagrant destroy
  ```

## VM Details

- Base box: `ubuntu/jammy64`
- Hostname: `ORS21D`
- Private network IP: `192.168.56.10`
- VirtualBox resources: 1 vCPU, 1024 MB RAM
- Provisioned packages: `build-essential`, `git`
