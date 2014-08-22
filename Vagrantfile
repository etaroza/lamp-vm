# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.3"

unless Vagrant.has_plugin?("vagrant-hostsupdater")
	raise 'vagrant-hostsupdater is not installed, you must run "vagrant plugin install vagrant-hostsupdater"'
end

Vagrant.configure("2") do |config|

	# Every Vagrant virtual environment requires a box to build off of.
	# see https://vagrantcloud.com/discover/featured
	config.vm.box = "puppetlabs/ubuntu-12.04-64-puppet"

	config.vm.guest = :ubuntu

	# NETWORK

	config.vm.network :private_network, ip: "10.20.30.40", netmask: "255.255.255.0"
	config.vm.hostname = "magento.dev"

	config.vm.network :forwarded_port, guest:   80, host: 10080 # nginx
	config.vm.network :forwarded_port, guest: 3306, host: 13306 # mysql

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
