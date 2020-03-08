#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

mkdir /etc/etcd /var/lib/etcd
cd /root && wget https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz && tar xvzf etcd-v3.3.9-linux-amd64.tar.gz
mv /root/etcd-v3.3.9-linux-amd64/etcd* /usr/local/bin/

