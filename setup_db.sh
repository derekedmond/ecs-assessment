#!/bin/bash

# set up database and initialise for testing
/etc/init.d/mysqld start
mysql -e "CREATE DATABASE ecs;"
mysql -e "CREATE TABLE ecs.versionTable (version int(3));"
mysql -e "INSERT INTO ecs.versionTable (version) VALUES (044);"

# create user: admin
mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Pai8ooyaize6we1e';"
mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost';"
