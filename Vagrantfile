# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.7.1"

unless Vagrant.has_plugin?("vagrant-hostsupdater")
    raise 'vagrant-hostsupdater is not installed, you must run "vagrant plugin install vagrant-hostsupdater"'
end

unless Vagrant.has_plugin?("vagrant-env")
    raise 'vagrant-env is not installed, you must run "vagrant plugin install vagrant-env"'
end

Vagrant.configure("2") do |config|
    config.env.enable

    # Every Vagrant virtual environment requires a box to build off of.
    # see https://vagrantcloud.com/discover/featured
    config.vm.box = "puppetlabs/ubuntu-12.04-64-puppet"

    config.vm.guest = :ubuntu

    # NETWORK

    hostPortPrefixParam = (ENV['vagrant_host_port_prefix'] || 1).to_i
    hostnameParam =  ENV['vagrant_hostname'] || "magento.dev"
    webserver = ENV['webserver'] || "nginx"
    hostnames = hostnameParam.split(',')

    config.vm.network :private_network, ip: "10.20.30.4"+(hostPortPrefixParam).to_s, netmask: "255.255.255.0"
    config.vm.hostname = hostnames.first

    config.hostsupdater.aliases = hostnames

    webserverPort = hostPortPrefixParam * 10000 + 80
    mysqlPort = hostPortPrefixParam * 10000 + 3306
    mailcatcherPort = hostPortPrefixParam * 10000 + 1080

    config.vm.network :forwarded_port, guest:   80, host: webserverPort
    config.vm.network :forwarded_port, guest: 3306, host: mysqlPort
    config.vm.network :forwarded_port, guest: 1080, host: mailcatcherPort


    config.vm.synced_folder "magento", "/magento", type: "nfs"

    # PROVIDERS

    config.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", "3072"]
    end

    config.vm.provider "vmware_fusion" do |v|
        v.vmx["memsize"] = "3072"
        v.vmx["numvcpus"] = "2"
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    # PROVISIONING

    config.vm.provision :ansible do |ansible|
        ansible.playbook = "./site-vagrant.yml"
        ansible.sudo = true
        ansible.verbose = true
    end
end
