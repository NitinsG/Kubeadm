#!/bin/bash

yum update

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y yum-utils device-mapper-persistent-data lvm2 
yum install -y docker-ce docker-ce-cli containerd.io
yum install -y kubelet kubeadm kubectl

systemctl start docker
systemctl enable docker
systemctl enable --now kubelet
systemctl stop firewalld
setenforce 0

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF > /etc/sysctl.conf 
net.ipv4.ip_forward = 1
EOF

sysctl -p
