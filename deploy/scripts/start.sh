#!/bin/bash
echo "Starting httpd..." >> /home/ec2-user/deploy.log
systemctl start httpd
