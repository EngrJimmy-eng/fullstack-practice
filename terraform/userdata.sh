#!/bin/bash

yum update -y

# Install packages
yum install -y git nodejs npm mysql nginx

# Start nginx
systemctl start nginx
systemctl enable nginx

# Clone repo
cd /home/ec2-user
git clone https://github.com/YOUR_USERNAME/fullstack-practice.git
cd fullstack-practice

# Backend setup
cd backend
npm install

# Start backend
npm install -g pm2
pm2 start server.js

# Frontend setup
cd ../frontend
npm install
npm run build

# Serve frontend
rm -rf /usr/share/nginx/html/*
cp -r build/* /usr/share/nginx/html/

systemctl restart nginx
