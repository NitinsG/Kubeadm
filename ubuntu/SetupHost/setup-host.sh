#!/bin/bash
set -e
IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.5.11  master-1
192.168.5.12  master-2
192.168.5.13  master-3
192.168.5.21  worker-1
192.168.5.22  worker-2
192.168.5.30  lb
192.168.5.40  ansible-1
EOF

sed --in-place=.bak -r 's/^#?(PermitRootLogin|PermitEmptyPasswords|PasswordAuthentication|X11Forwarding) no/\1 yes/' /etc/ssh/sshd_config
systemctl restart sshd
echo 'vagrant:vagrant' | chpasswd
