#!/bin/bash
sudo apt update
sudo apt install -y wget unzip tar 
mkdir /tmp/maven
mkdir /opt/maven
cd /tmp/maven
wget https://downloads.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
sudo tar -xvzf apache-maven-*.tar.gz -C 
cp -r apache-maven-3.9.6/* /opt/maven