@echo off
setlocal enabledelayedexpansion

:: Slade Cluster Manager for Windows
:: Easy management of the Slade master and worker nodes

cd /d "%~dp0"

:header
echo.
echo ╔══════════════════════════════════════════════════════════════════════╗
echo ║                    🚀 SLADE CLUSTER MANAGER 🚀                      ║
echo ║                                                                      ║
echo ║  Master: Slade (192.168.56.10)                                      ║
echo ║  Workers: Node1-4 (192.168.56.11-14)                               ║
echo ╚══════════════════════════════════════════════════════════════════════╝
echo.

:menu
echo Available Commands:
echo   1) Start Slade Master Only
echo   2) Start All Worker Nodes
echo   3) Start Entire Cluster
echo   4) Show Cluster Status
echo   5) Connect to Slade Master
echo   6) Connect to Worker Node
echo   7) Stop Entire Cluster
echo   8) Destroy Entire Cluster
echo   9) Restart Cluster
echo  10) Quick Setup (Start Master + Connect)
echo  11) Help
echo  12) Exit
echo.

set /p choice="Enter your choice (1-12): "
echo.

if "%choice%"=="1" goto start_master
if "%choice%"=="2" goto start_workers
if "%choice%"=="3" goto start_all
if "%choice%"=="4" goto show_status
if "%choice%"=="5" goto connect_master
if "%choice%"=="6" goto connect_worker
if "%choice%"=="7" goto stop_all
if "%choice%"=="8" goto destroy_all
if "%choice%"=="9" goto restart_cluster
if "%choice%"=="10" goto quick_setup
if "%choice%"=="11" goto show_help
if "%choice%"=="12" goto exit_script

echo Invalid choice! Please select 1-12.
goto continue

:start_master
echo Starting Slade Master...
vagrant up slade
echo Slade Master started successfully!
goto continue

:start_workers
echo Starting Worker Nodes...
vagrant up worker1 worker2 worker3 worker4
echo All Worker Nodes started successfully!
goto continue

:start_all
echo Starting Entire Cluster...
vagrant up
echo Entire Cluster started successfully!
goto continue

:show_status
echo Cluster Status:
vagrant status
goto continue

:connect_master
echo Connecting to Slade Master...
vagrant ssh slade
goto continue

:connect_worker
echo Available Workers:
echo 1) worker1 (192.168.56.11)
echo 2) worker2 (192.168.56.12)
echo 3) worker3 (192.168.56.13)
echo 4) worker4 (192.168.56.14)
echo.
set /p worker_choice="Select worker (1-4): "

if "%worker_choice%"=="1" (
    echo Connecting to Worker 1...
    vagrant ssh worker1
)
if "%worker_choice%"=="2" (
    echo Connecting to Worker 2...
    vagrant ssh worker2
)
if "%worker_choice%"=="3" (
    echo Connecting to Worker 3...
    vagrant ssh worker3
)
if "%worker_choice%"=="4" (
    echo Connecting to Worker 4...
    vagrant ssh worker4
)
if not "%worker_choice%"=="1" if not "%worker_choice%"=="2" if not "%worker_choice%"=="3" if not "%worker_choice%"=="4" (
    echo Invalid selection!
)
goto continue

:stop_all
echo Stopping Entire Cluster...
vagrant halt
echo Cluster stopped successfully!
goto continue

:destroy_all
echo WARNING: This will completely destroy the cluster!
set /p confirm="Are you sure? (yes/no): "
if /i "%confirm%"=="yes" (
    vagrant destroy -f
    echo Cluster destroyed!
) else (
    echo Operation cancelled.
)
goto continue

:restart_cluster
echo Restarting Cluster...
vagrant reload
echo Cluster restarted successfully!
goto continue

:quick_setup
echo Quick Setup: Starting Master and connecting...
vagrant up slade
echo Master started! Connecting in 5 seconds...
timeout /t 5 /nobreak
vagrant ssh slade
goto continue

:show_help
echo.
echo ═══════════════════════ HELP ═══════════════════════
echo.
echo This script manages your Slade cluster environment.
echo.
echo Prerequisites:
echo - VirtualBox: https://www.virtualbox.org/wiki/Downloads
echo - Vagrant: https://developer.hashicorp.com/vagrant/downloads
echo.
echo Cluster Architecture:
echo - Slade Master: Desktop Linux with GUI controller
echo - 4 Worker Nodes: Headless servers controlled by Slade
echo - Real IP networking through bridge adapter
echo - Private network for internal cluster communication
echo.
echo Quick Start:
echo 1. Choose option 1 to start the master node
echo 2. Choose option 5 to connect to the master
echo 3. Use master's built-in commands to control workers
echo.
echo System Requirements:
echo - Minimum 8GB RAM for full cluster
echo - 4+ CPU cores recommended
echo - 20GB free disk space
echo.
echo Troubleshooting:
echo - If VMs fail to start, check VirtualBox Host-Only Networks
echo - For SSH issues between nodes, use setup-ssh-keys option
echo - On slow systems, start nodes one by one instead of all at once
echo.
goto continue

:continue
echo.
pause
cls
goto header

:exit_script
echo.
echo Thanks for using Slade Cluster Manager!
echo.
pause
exit /b 0