#!/bin/bash
sudo snap install lxd --channel=4.0/stable
sudo newgrp lxd
sudo lxd init --auto
sudo lxc launch ubuntu:20.04 LoadBalancer

sudo lxc exec LoadBalancer -- sudo apt-get update -y
sudo lxc exec LoadBalancer -- sudo apt-get upgrade -y
sudo lxc exec LoadBalancer -- sudo apt install haproxy -y
sudo lxc exec LoadBalancer -- sudo systemctl enable haproxy

sudo lxc config device add LoadBalancer p80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80
sudo lxc file push /vagrant/haproxy.cfg LoadBalancer/etc/haproxy/haproxy.cfg

sudo lxc exec LoadBalancer -- sudo systemctl restart haproxy