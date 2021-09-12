#!/bin/bash
sudo adduser --disabled-password ansible
#add ssh key
sudo mkdir /home/ansible/.ssh
sudo cp /home/ubuntu/.ssh/authorized_keys /home/ansible/.ssh/authorized_keys
sudo chown -R ansible:ansible /home/ansible
sudo chmod 700 /home/ansible/.ssh
sudo chmod 600 /home/ansible/.ssh/authorized_keys
#add passwordless sudo privileges
echo "ansible  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible