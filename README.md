# october_vagrant
Vagrant files for OctoberCMS.
Assumes your current path is an OctoberCMS root directory, and links it to /var/www in vagrant.

##### Installs the following in vagrant
Debian, Nginx, PHP7, MySQL, Redis, Git

## Vagrantfile
You may want to edit:
- IP address (192.168.100.101)
- location of shared files (./ -> /var/www)

## vagrant_bootstrap.sh
You may want to edit:
- MySQL root password ('vagrant')
- OctoberCMS database, username, password (all are 'october')
- location of OctoberCMS installation (/var/www)

## vagrant_nginx_conf
You may want to edit:
- root dir (/var/www)
