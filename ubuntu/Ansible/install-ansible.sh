#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update \
   && apt-get install -y software-properties-common

apt-add-repository -y ppa:ansible/ansible
apt-add-repository -y --update ppa:ansible/ansible-2.7

apt-get update \
   && apt-get install -y ansible git sshpass python-netaddr libssl-dev

yes "/root/.ssh/id_rsa" | sudo ssh-keygen -t rsa -N ""

HOSTS="master-1 master-2 master-3 worker-1 worker-2 lb"
for host in ${HOSTS}; do
    sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo mkdir -p /root/.ssh"
    sudo cat /root/.ssh/id_rsa.pub | \
         sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo tee /root/.ssh/authorized_keys"
done
