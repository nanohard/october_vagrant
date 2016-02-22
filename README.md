### october_vagrant, version: Install
Vagrant files for OctoberCMS.
Installs OctoberCMS to "october/" and links it to /var/www in vagrant.

##### Installs the following in vagrant
Debian, Nginx, PHP7, MySQL, phpMyAdmin, Redis, Git

##### Values of note
- IP address: 192.168.100.101
- Location of shared files: ./ -> /var/www
- MySQL root password: vagrant
- OctoberCMS database, username, password: october
- Location of OctoberCMS installation:
    - Local: ./october
    - Vagrant: /var/www
