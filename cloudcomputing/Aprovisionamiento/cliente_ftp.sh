#!/bin/bash
echo "configurando el resolv.conf con cat"
cat <<TEST> /etc/resolv.conf
nameserver 8.8.8.8
TEST
echo "instalando un servidor vsftpd"
sudo apt-get install vsftpd -y
echo “Modificando vsftpd.conf con sed”
sed -i 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf
echo "configurando ip forwarding con echo"
sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo sed -i 's/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to FTP Puppet./g' /etc/vsftpd.conf
sudo sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" /etc/vsftpd.conf

sudo useradd -m ftpuser
echo -e "password\npassword" | passwd ftpuser