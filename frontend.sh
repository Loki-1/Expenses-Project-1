#!/bin/bash

source ./common-script.sh

root_script

dnf install nginx -y &>>LOGFILE
VALIDATE $? "Installing ngix"

systemctl enable nginx &>>LOGFILE
VALIDATE $? "Enabling ngix"

systemctl start nginx &>>LOGFILE
VALIDATE $? "Strating nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "Removing defult contant"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip
VALIDATE $? "extracting frontend" &>>LOGFILE

cp /home/ec2-user/Expenses-Project/expense.conf /etc/nginx/default.d/expense.conf &>>LOGFILE

systemctl restart nginx
VALIDATE $? "Restartign ngix"





