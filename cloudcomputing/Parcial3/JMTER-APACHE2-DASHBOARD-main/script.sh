#!/bin/bash

sudo apt install apache2 -y
sudo mkdir /var/www/html/metricas

sudo apt-get update
sudo apt-get install default-jdk

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

sudo wget http://apache.rediris.es//jmeter/binaries/apache-jmeter-5.4.1.tgz
sudo wget http://apache.rediris.es//jmeter/binaries/apache-jmeter-5.4.1.tgz.asc
sudo wget http://www.apache.org/dist/jmeter/KEYS

sudo gpg --import KEYS
sudo gpg --verify apache-jmeter-2.6.tgz.asc

sudo tar -xzvf apache-jmeter-2.6.tgz
sudo mv apache-jmeter-2.6 /usr/local/jmeter
sudo cd /usr/local/jmeter/


sudo mkdir /usr/local/jmeter/pruebas

sudo mkdir /usr/local/jmeter/pruebas/logs

sudo cp /vagrant/parcial1.jmx /usr/local/jmeter/pruebas/

sudo cp /vagrant/api.py /usr/local/jmeter/pruebas/

sudo cp /vagrant/index.html /var/www/html/index.html