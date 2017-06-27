#!/usr/bin/env bash

# If these values are changed config/dev/database.php settings also need to be changed.
DBNAME=october
DBUSER=october
DBPASSWD=october
DBROOTPASSWD=vagrant

echo "Provisioning virtual machine..."

echo -e "\n--- Updating apt sources ---\n"
sudo apt-get update > /dev/null 2>&1
sudo apt-get dist-upgrade -y > /dev/null 2>&1

echo -e "\n--- Installing Git ---\n"
sudo apt-get install git snmp -y > /dev/null 2>&1

echo -e "\n--- Installing Nginx ---\n"
sudo apt-get install nginx -y > /dev/null 2>&1

echo -e "\n--- Installing PHP7.0 ---\n"
sudo apt-get install php7.0 php7.0-common php7.0-fpm php7.0-cli php7.0-opcache php7.0-memcached php7.0-redis \
php7.0-gnupg php7.0-calendar php7.0-fileinfo php7.0-bcmath php7.0-xml php7.0-uploadprogress php7.0-tokenizer \
php7.0-imagick php7.0-gettext php7.0-mbstring php7.0-gd php7.0-uuid php7.0-mysql php7.0-sqlite3 php7.0-pgsql \
php-xdebug php7.0-json php7.0-phar php7.0-curl php7.0-zip php7.0-mcrypt php7.0-geoip php-yaml -y > /dev/null 2>&1

sudo apt-get install debconf-utils -y > /dev/null 2>&1

echo -e "\n--- Installing MySQL, phpMyAdmin, and settings ---\n"
echo "mysql-server mysql-server/root_password password $DBROOTPASSWD" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBROOTPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBROOTPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBROOTPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBROOTPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | sudo debconf-set-selections
sudo apt-get install mysql-server phpmyadmin -y > /dev/null 2>&1

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBROOTPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBROOTPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"

echo -e "\n--- Configuring Nginx ---\n"
sudo cp /home/vagrant/.vagrantfiles/vagrant_nginx_conf /etc/nginx/sites-available/nginx_vhost
sudo ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-available/default
sudo ln -s /usr/share/phpmyadmin /var/www/
sudo systemctl restart php7.0-fpm.service
sudo systemctl restart nginx.service

echo -e "\n--- Installing Redis ---\n"
sudo apt-get install redis-server -y > /dev/null 2>&1

echo -e "\n--- Migrating OctoberCMS database ---\n"
sudo cp /home/vagrant/.vagrantfiles/october/.env /var/www/
sudo cp /home/vagrant/.vagrantfiles/october/config/dev/database.php /var/www/config/dev/
pushd /var/www
php artisan october:up
popd
