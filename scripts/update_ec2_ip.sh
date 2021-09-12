#!/bin/bash

if [[ $(basename $(pwd)) != "TerraformFootball" ]]; then
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}Error: Please run this from the TerraformFootball directory\n${NC}"
    exit 1
fi


INSTANCE_IP=$(terraform output | awk -F'"' '{print $2}')

#update alias
echo ".BASHRC ALIAS: Updating ssh-aws-dev alias in /home/peter/.bashrc"
sed -i "s/alias ssh-aws-dev.*/alias ssh-aws-dev='ssh ubuntu@$INSTANCE_IP'/" /home/peter/.bashrc
source /home/peter/.bashrc

#update ip for ansible
LINE_NO_OF_GROUP=$(grep -n "aws_instance" /etc/ansible/hosts | cut -f1 -d:)
LINE_NO_OF_IP=$(($LINE_NO_OF_GROUP+1))
echo "ANSIBLE HOSTS FILE: Replacing old IP $(head -n${LINE_NO_OF_IP} /etc/ansible/hosts | tail -n1) with new IP $INSTANCE_IP"
sudo sed -i "${LINE_NO_OF_IP}s/.*/$INSTANCE_IP/" /etc/ansible/hosts