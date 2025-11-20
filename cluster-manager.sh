#!/bin/bash

# Slade Cluster Manager Script
# Easy management of the Slade master and worker nodes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display header
show_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 SLADE CLUSTER MANAGER 🚀                      ║"
    echo "║                                                                      ║"
    echo "║  Master: Slade (192.168.56.10)                                      ║"
    echo "║  Workers: Node1-4 (192.168.56.11-14)                               ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to show menu
show_menu() {
    echo -e "${CYAN}Available Commands:${NC}"
    echo "  1) start-master     - Start Slade master node only"
    echo "  2) start-workers    - Start all worker nodes"
    echo "  3) start-all        - Start entire cluster"
    echo "  4) status          - Show cluster status"
    echo "  5) connect-master   - SSH to Slade master"
    echo "  6) connect-worker   - SSH to specific worker"
    echo "  7) stop-all        - Stop entire cluster"
    echo "  8) destroy-all     - Destroy entire cluster"
    echo "  9) restart-cluster - Restart entire cluster"
    echo " 10) setup-ssh-keys  - Setup SSH keys for cluster"
    echo " 11) help           - Show this menu"
    echo " 12) quit           - Exit"
    echo
}

# Function to start master
start_master() {
    echo -e "${GREEN}Starting Slade Master...${NC}"
    vagrant up slade
    echo -e "${GREEN}Slade Master started successfully!${NC}"
}

# Function to start workers
start_workers() {
    echo -e "${GREEN}Starting Worker Nodes...${NC}"
    vagrant up worker1 worker2 worker3 worker4
    echo -e "${GREEN}All Worker Nodes started successfully!${NC}"
}

# Function to start all
start_all() {
    echo -e "${GREEN}Starting Entire Cluster...${NC}"
    vagrant up
    echo -e "${GREEN}Entire Cluster started successfully!${NC}"
}

# Function to show status
show_status() {
    echo -e "${CYAN}Cluster Status:${NC}"
    vagrant status
}

# Function to connect to master
connect_master() {
    echo -e "${GREEN}Connecting to Slade Master...${NC}"
    vagrant ssh slade
}

# Function to connect to worker
connect_worker() {
    echo -e "${YELLOW}Available Workers:${NC}"
    echo "1) worker1 (192.168.56.11)"
    echo "2) worker2 (192.168.56.12)"
    echo "3) worker3 (192.168.56.13)"
    echo "4) worker4 (192.168.56.14)"
    echo
    read -p "Select worker (1-4): " worker_choice
    
    case $worker_choice in
        1) echo -e "${GREEN}Connecting to Worker 1...${NC}"; vagrant ssh worker1 ;;
        2) echo -e "${GREEN}Connecting to Worker 2...${NC}"; vagrant ssh worker2 ;;
        3) echo -e "${GREEN}Connecting to Worker 3...${NC}"; vagrant ssh worker3 ;;
        4) echo -e "${GREEN}Connecting to Worker 4...${NC}"; vagrant ssh worker4 ;;
        *) echo -e "${RED}Invalid selection!${NC}" ;;
    esac
}

# Function to stop all
stop_all() {
    echo -e "${YELLOW}Stopping Entire Cluster...${NC}"
    vagrant halt
    echo -e "${YELLOW}Cluster stopped successfully!${NC}"
}

# Function to destroy all
destroy_all() {
    echo -e "${RED}WARNING: This will completely destroy the cluster!${NC}"
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        vagrant destroy -f
        echo -e "${RED}Cluster destroyed!${NC}"
    else
        echo -e "${GREEN}Operation cancelled.${NC}"
    fi
}

# Function to restart cluster
restart_cluster() {
    echo -e "${YELLOW}Restarting Cluster...${NC}"
    vagrant reload
    echo -e "${GREEN}Cluster restarted successfully!${NC}"
}

# Function to setup SSH keys
setup_ssh_keys() {
    echo -e "${CYAN}Setting up SSH keys for cluster management...${NC}"
    
    # Start master if not running
    if ! vagrant status slade | grep -q "running"; then
        echo -e "${YELLOW}Starting master node first...${NC}"
        vagrant up slade
    fi
    
    # Generate and distribute SSH keys
    vagrant ssh slade -c "
        # Generate SSH key if not exists
        if [ ! -f ~/.ssh/id_rsa ]; then
            ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''
        fi
        
        # Copy public key to each worker
        for i in {11..14}; do
            echo 'Setting up SSH key for 192.168.56.\$i'
            ssh-keyscan -H 192.168.56.\$i >> ~/.ssh/known_hosts 2>/dev/null || true
            sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.56.\$i 2>/dev/null || true
        done
    "
    
    echo -e "${GREEN}SSH keys setup completed!${NC}"
}

# Main script logic
main() {
    show_header
    
    # If argument provided, execute directly
    if [ $# -gt 0 ]; then
        case $1 in
            start-master) start_master ;;
            start-workers) start_workers ;;
            start-all) start_all ;;
            status) show_status ;;
            connect-master) connect_master ;;
            connect-worker) connect_worker ;;
            stop-all) stop_all ;;
            destroy-all) destroy_all ;;
            restart-cluster) restart_cluster ;;
            setup-ssh-keys) setup_ssh_keys ;;
            help) show_menu ;;
            *) echo -e "${RED}Unknown command: $1${NC}"; show_menu ;;
        esac
        exit 0
    fi
    
    # Interactive mode
    while true; do
        show_menu
        read -p "Enter your choice (1-12): " choice
        echo
        
        case $choice in
            1) start_master ;;
            2) start_workers ;;
            3) start_all ;;
            4) show_status ;;
            5) connect_master ;;
            6) connect_worker ;;
            7) stop_all ;;
            8) destroy_all ;;
            9) restart_cluster ;;
            10) setup_ssh_keys ;;
            11) show_menu ;;
            12) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid choice! Please select 1-12.${NC}" ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
        echo
    done
}

# Run main function
main "$@"