#!/bin/bash

echo "Provisioning virtual machine..."

echo "Updating apt sources"
echo 'deb http://packages.dotdeb.org jessie all' | sudo tee --append /etc/apt/sources.list.d/dotdeb.list
echo 'deb-src http://packages.dotdeb.org jessie all' | sudo tee --append /etc/apt/sources.list.d/dotdeb.list
wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
sudo apt-get update
sudo apt-get dist-upgrade -y

echo "Installing Git"
sudo apt-get install git -y

echo "Installing Nginx"
sudo apt-get install nginx -y

echo "Installing PHP7.0"
sudo apt-get install php7.0 php7.0-* -y

sudo apt-get install debconf-utils -y

echo "Installing MySQL"
# MySQL root password
debconf-set-selections <<< "mysql-server mysql-server/root_password password vagrant"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password vagrant"
sudo apt-get install mysql-server -y

echo "Configuring Nginx"
sudo cp /var/www/pos/vagrant_nginx_conf /etc/nginx/sites-available/nginx_vhost
sudo ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-available/default
sudo systemctl restart nginx.service

echo "Installing Redis"
sudo apt-get install redis-server -y

"Installing OctoberCMS"
# OctoberCMS database name, user, password
mysql -uroot -pvagrant -e "CREATE DATABASE october"
mysql -uroot -pvagrant -e "CREATE USER 'october'@'localhost' IDENTIFIED BY 'october'"
mysql -uroot -pvagrant -e "GRANT ALL PRIVILEGES ON october.* TO 'october'@'localhost'"
mysql -uroot -pvagrant -e "FLUSH PRIVILEGES"

# Install OctoberCMS to this directory
pushd /var/www
php artisan october:up
popd
