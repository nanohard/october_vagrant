# Download OctoberCMS if index.php is not found
system('.vagrantfiles/october.sh')

Vagrant.configure("2") do |config|
    # Image
    config.vm.box = "debian/contrib-jessie64"  # Has vboxsf installed
    
    # IP address
    config.vm.network :private_network, ip: "192.168.100.101"
    
    # Folder to sync from/to, and set owner/group
    config.vm.synced_folder ".vagrantfiles/", "/home/vagrant/.vagrantfiles/"
    config.vm.synced_folder "october/", "/var/www", owner: "www-data", group: "www-data"
    
    # Run provisioning script
    config.vm.provision "shell", path: ".vagrantfiles/vagrant_bootstrap.sh"
end