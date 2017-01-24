#!/bin/bash

# start mysql
service mysql start

# create a database for testing purposes
mysql -h localhost -u root -proot -e "CREATE DATABASE pipelines;"

# php must be started in the foreground
php
