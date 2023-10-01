#!/bin/bash

if [[ $(basename $(pwd)) != "oracle" ]]; then
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}Error: Please run this from the oracle directory\n${NC}"
    exit 1
fi


INSTANCE_IP=$(terraform output | grep "football_ip" |  awk -F'"' '{print $2}')

#update alias
echo ".BASHRC ALIAS: Updating ssh-oracle-dev alias in /home/peter/.bashrc"
if grep -q "ssh-oracle-dev" /home/peter/.bashrc
then
    sed -i "s/alias ssh-oracle-dev.*/alias ssh-oracle-dev='ssh ubuntu@$INSTANCE_IP'/" /home/peter/.bashrc
else
    echo "alias ssh-oracle-dev='ssh ubuntu@$INSTANCE_IP'" >> /home/peter/.bashrc
fi
echo ".BASHRC ALIAS: Updating oracle-proxy alias in /home/peter/.bashrc"
if grep -q "oracle-proxy" /home/peter/.bashrc
then
alias oracle-proxy='ssh -D 31288 -f -C -q -N ubuntu@$INSTANCE_IP'

    sed -i "s/alias oracle-proxy.*/alias oracle-proxy='ssh -D 31288 -f -C -q -N ubuntu@$INSTANCE_IP'/" /home/peter/.bashrc
else
    echo "alias oracle-proxy=alias oracle-proxy='ssh -D 31288 -f -C -q -N ubuntu@$INSTANCE_IP'" >> /home/peter/.bashrc
fi
source /home/peter/.bashrc

#update ip for ansible
if grep -q "[compute_instance]" /home/peter/.bashrc
then
    LINE_NO_OF_GROUP=$(grep -n "compute_instance" /etc/ansible/hosts | cut -f1 -d:)
    LINE_NO_OF_IP=$(($LINE_NO_OF_GROUP+1))
    echo "ANSIBLE HOSTS FILE: Replacing old IP $(head -n${LINE_NO_OF_IP} /etc/ansible/hosts | tail -n1) with new IP $INSTANCE_IP"
    sudo sed -i "${LINE_NO_OF_IP}s/.*/$INSTANCE_IP/" /etc/ansible/hosts
else
    echo "ANSIBLE HOSTS FILE: Adding new IP $INSTANCE_IP"
    echo "[compute_instance]" | sudo tee -a /etc/ansible/hosts
    echo "$INSTANCE_IP" | sudo tee -a /etc/ansible/hosts
fi