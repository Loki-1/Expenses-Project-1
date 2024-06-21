#!/bin/bash

source ./common-script.sh

root_script

echo "Please Enter DB password:"
read -s mysql_root_password

dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "Disabling defult nodejs"

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "Enabling nodejs 20 version"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "Installing Nodejs"

id expense &>>LOGFILE
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "Adding user"
else
    echo -e "Expense user already created...$Y Skipping $N"
fi

mkdir -p /app
VALIDATE $? "Creating App directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
VALIDATE $? "Downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip
VALIDATE $? "Extrated backend code"

cd /app #downloading dependencies
npm install
VALIDATE $? "Dependencies downloading"

chmod 777 /home/ec2-user/Expenses-Project-1/backend.service   

cp sudo /home/ec2-user/Expenses-Project-1/backend.service /etc/systemd/system/backend.service &>>LOGFILE
VALIDATE $? "Copied backedend service"

cd /etc/systemd/system
chmod 777 backend.service

systemctl daemon-reload &>>LOGFILE
VALIDATE $? "Reloading daemon"

systemctl start backend &>>LOGFILE
VALIDATE $? "Starting backend"
systemctl enable backend &>>LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>LOGFILE
VALIDATE $? "Installing MYSQL Client"

mysql -h 172.31.19.151 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>LOGFILE
VALIDATE $? "Shema Loading"

systemctl restart backend &>>LOGFILE
VALIDATE $? "Restarting Backend"








