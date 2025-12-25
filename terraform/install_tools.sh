#!/bin/bash

<<INFO
THIS SCRIPT IS USED TO INSTALL DOCKER & JENKINS
INFO

sudo apt-get update -y
sudo apt-get upgrade -y

#FOR INSTALLING DOCKER
sudo apt-get install docker.io -y

#FOR INSTALLING JENKINS
sudo apt install fontconfig openjdk-21-jre -y
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y 
sudo apt install jenkins -y

sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
sudo newgrp docker

sudo systemctl restart docker
sudo systemctl restart jenkins

