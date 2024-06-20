#!/bin/bash

source ./common-script.sh

root_script

echo "Please Enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "Installing Mysql Server"

systemctl enable mysqld &>>LOGFILE
VALIDATE $? "Enabling Mysql Server"

systemctl start mysqld &>>LOGFILE
VALIDATE $? "Starting Mysql Server"

#mysql_secure_installation --set-root-pass ExpenseApp@1
#VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.daws78s.online -uroot -pExpenseApp@1 -e 'show databases:' &>>LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
    VALIDATE $? "MYSql Root Password setting up"
else
    echo -e "MySql root password is already setup...$Y SKIPPING $N"
fi




