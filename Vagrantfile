Vagrant.configure("2") do |config|
    # Image
    config.vm.box = "debian/contrib-jessie64"  # Has vboxsf installed
    
    # IP address
    config.vm.network :private_network, ip: "192.168.100.101"
    
    # Folder to sync from/to, and set owner/group
    config.vm.synced_folder "./", "/var/www", owner: "www-data", group: "www-data"
    
    # Run provisioning script
    config.vm.provision "shell", path: "vagrant_bootstrap.sh"
end
