#!/bin/bash
echo "Stopping httpd..." >> /home/ec2-user/deploy.log
sudo systemctl stop httpd
