#!/bin/bash
sudo snap install lxd --channel=4.0/stable
sudo newgrp lxd
sudo lxd init --auto
sudo lxc launch ubuntu:20.04 web1
sudo lxc launch ubuntu:20.04 web2

sudo lxc exec web1 -- sudo apt-get update -y
sudo lxc exec web1 -- sudo apt-get upgrade -y
sudo lxc exec web1 -- sudo apt-get install apache2 -y
sudo lxc exec web1 -- sudo systemctl enable apache2
sudo lxc exec web2 -- sudo apt-get update -y
sudo lxc exec web2 -- sudo apt-get upgrade -y
sudo lxc exec web2 -- sudo apt-get install apache2 -y
sudo lxc exec web2 -- sudo systemctl enable apache2

sudo lxc config device add web1 p4081 proxy listen=tcp:192.168.2.11:4081 connect=tcp:127.0.0.1:80
sudo lxc config device add web2 p4082 proxy listen=tcp:192.168.2.11:4082 connect=tcp:127.0.0.1:80

sudo lxc file push /vagrant/vistas/index_c1.html web1/var/www/html/index.html
sudo lxc file push /vagrant/vistas/index_c3.html web2/var/www/html/index.html

sudo lxc exec web1 -- sudo systemctl restart apache2
sudo lxc exec web2 -- sudo systemctl restart apache2





