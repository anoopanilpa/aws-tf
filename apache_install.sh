#! /bin/bash

sudo yum -y update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo “Hello from TF example” > /var/www/html/index.html