#!/bin/bash

echo "Provisioning virtual machine..."

echo "Updating apt sources"
sudo apt-get update
sudo apt-get dist-upgrade -y

echo "Installing Git"
sudo apt-get install git -y

echo "Installing Nginx"
sudo apt-get install nginx -y

echo "Installing PHP7.0"
sudo apt-get install php7.0 php7.0-common php7.0-fpm php7.0-cli php7.0-opcache php7.0-memcached php7.0-redis \
php7.0-gnupg php7.0-calendar php7.0-fileinfo php7.0-bcmath php7.0-xml php7.0-uploadprogress php7.0-tokenizer \
php7.0-imagick php7.0-gettext php7.0-mbstring php7.0-gd php7.0-uuid php7.0-mysql php7.0-sqlite3 php7.0-pgsql \
php-xdebug php7.0-json php7.0-phar php7.0-curl php7.0-zip php7.0-mcrypt php7.0-geoip php-yaml -y

sudo apt-get install debconf-utils -y

echo "Installing MySQL"
# MySQL root password
debconf-set-selections <<< "mysql-server mysql-server/root_password password vagrant"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password vagrant"
sudo apt-get install mysql-server -y

echo "Configuring Nginx"
CURRENTDIR=$(pwd)
sudo cp "${CURRENTDIR}/vagrant_nginx_conf" /etc/nginx/sites-available/nginx_vhost
sudo ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-available/default
sudo systemctl restart nginx.service

echo "Installing Redis"
sudo apt-get install redis-server -y

echo "Installing OctoberCMS"
# OctoberCMS database name, user, password
mysql -uroot -pvagrant -e "CREATE DATABASE october"
mysql -uroot -pvagrant -e "CREATE USER 'october'@'localhost' IDENTIFIED BY 'october'"
mysql -uroot -pvagrant -e "GRANT ALL PRIVILEGES ON october.* TO 'october'@'localhost'"
mysql -uroot -pvagrant -e "FLUSH PRIVILEGES"

# Install OctoberCMS to this directory
pushd /var/www
php artisan october:up
popd
