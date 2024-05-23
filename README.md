# Ubuntu-Server-Machine-Terraform-Ansible
Automate the deployment and hardening process for a Ubuntu Server Machine, using Terraform and Ansible.

# Task 1: Automate the deployment process for a Ubuntu Server Machine, using Terraform

1. Configure the vsphere provider.
2. Define variables for vsphere credentials and server details.
3. Create a resource to spin up an Ubuntu VM with two interfaces.
4. Assign VLAN ID 150 to the internal interface.
5. Set the external interface to obtain an IP from DHCP or use a static IP.

To achieve that there are 4 Terraform files:
 1. variables.tf
 2. provider.tf
 3. data.tf
 4. main.tf

Prerequisites

1. Terraform installed on your local machine.
2. Access to your vSphere environment with appropriate permissions.

In our Local Machine where Terraform is installed:
1. create a directory:
     -mkdir ubuntu_on_vsphere /* Or whatever name you can give to it
2. change the dircetory to that newly created directory:
    -cd ubuntu_on_vsphere  /*Hier you should Copy/Paste the below files: 
 
 variables.tf
 provider.tf
 data.tf
 main.tf


3. Than we can initialize the terraform process:
    - terraform init
    - terraform plan
    - terraform apply -var 'vsphere_user=your_user' -var 'vsphere_password=your_password' -var 'vsphere_server=your_server' -var 'vsphere_datacenter=your_datacenter' -var 'vsphere_datastore=your_datastore' -       var 'vsphere_cluster=your_cluster' -var 'vsphere_network=your_network' -var 'vsphere_internal_network=your_internal_network' -var 'vm_static_ip=your_static_ip'

At the end we should have a new Ubuntu VM created from a Template the default name would be "ubuntu-server", the VM will have an internal network interface wich will be member of VLAN with ID 150 and an External Interface.
------------------------
Task 2: Automate hardening process ov the above VM using Ansible
-----------------------------------------------------------------
This Ansible playbook: 'playbook.yml' automates the setup and configuration of an Ubuntu server with Nginx, SSH, and UFW. The tasks include updating the system, 
installing necessary packages, configuring Nginx and SSH to listen on a specific external IP address, hardening SSH configuration, and setting up a firewall with UFW.

Prerequisites:

Ansible installed on your local machine.
SSH access to the Ubuntu VM
The external IP address we want Nginx and SSH to listen on.

In the machine where ansible is installed we do that:
 mkdir ubuntu_hardening /** or whatever name we can give to it
 cd ubuntu_hardening //** hier we can clone the files "playbook.yml" and "hosts.ini"

Playbook Details:

ubuntu: The playbook is designed to run on hosts listed under the ubuntu group in your Ansible inventory

Privilege Escalation:
The playbook uses 'become: yes' to execute tasks with SUDO privileges.

1. Update and Upgrade apt Packages:

   Updates the local apt cache and upgrades all installed packages to the latest version.

2. Install Nginx and SSH

   Installs the Nginx web server and OpenSSH server packages.

3. Configure Nginx to Listen Only on External Interface

   Updates the Nginx configuration to make it listen on the specified external IP address.

4. Configure SSH to Listen Only on External Interface

    Modifies the SSH configuration to listen on the specified external IP address.
    Triggers a restart of the SSH service to apply the changes.

5. Harden SSH Configuration

   Disables root login via SSH for enhanced security.
   Triggers a restart of the SSH service to apply the changes.

6. Ensure UFW is Installed

   Installs the UFW firewall package.

7. Configure UFW to Allow Necessary Ports

    Configures UFW to allow incoming connections on ports 22 (SSH), 80 (HTTP), and 9000 (custom application port).
    Triggers the enabling of UFW to apply the changes.

8. Handlers:
   - Restarts the SSH service to apply configuration changes.

9. Enable UFW:
  - Enables UFW, ignoring any errors that might occur if UFW is already enabled.
  
Before runing the Ansible code # Generate an SSH key pair on your local machine (if you don't have one already):
 - ssh-keygen -t rsa -b 4096 -C "your_username"

Copy your public SSH key to the Ubuntu Server:
 - ssh-copy-id your_username@ubuntu_server_ip
 - 
- to run the playbook we use that script:
   - ansible-playbook -i hosts.ini playbook.yml --ask-become-pass
