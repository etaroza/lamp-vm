# About The Project

Initially it was created as a ready-to-go VM for developing Magento shops.
Should be used only on local machine - the project is not intended to be a full-blown virtualization solution.

Dependencies:

* Vagrant
* Ansible

# Setup DEV environment (Mac)

## Prepare Vagrant instance
1. clone git@github.com:etaroza/lamp-vm.git
1. cd `lamp-vm`
1. put `magento` or any other webapp folder or symlink into `lamp-vm/webapp` or symlink there. Any php webapp is ok
1. create a `.env` file for local configuration of how Vagrant should be executed
    * It has to have the following two lines:
      * __vagrant_host_port_adjust=X__, where X will define the port mapping on host, it's a one digit number 0-9. For examle 2 would make the mapping of nginx 80 to 20080, MySQL 3306 to 3308, Mailcatcher 1080 to 21080
      * __vagrant_hostname=X,Y,Z__, where X, Y, Z are the hosts the vagrant instance is responsible for. __config.vm.hostname__ will be set with X, and if there are Y, Z specified the hostupdater will be configured as __config.hostsupdater.aliases__ = [X,Y,Z].
1. when provisioning you might want to use provision.sh wrapper script


## Accessing the Web app inside Vagrant
On the localhost make sure to setup proxying into Vagrant. Here's my boxen nginx config:

```
server {
  listen 80;
  server_name .<%= @server_name %>;

  location / {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_redirect off;
    proxy_pass http://<%= @server_name %>:20080;
    proxy_read_timeout 20m;
    proxy_connect_timeout 20m;
  }
}
```

Here's my .env:

```
vagrant_host_port_adjust=2
vagrant_hostname=multishop.dev,myshop1.dev,myshop2.dev
```

So in Vagrantfile there's port mapping defined:

* 20080 => 80 (to access the web server inside Vagrant)
* 3308 => 3306 (to access MySQL inside Vagrant)
* 21080 => 1080 (to access Mailcatcher inside Vagrant)

## Swapping between nginx and apache2 webservers inside the box

* Change "webserver" variable in group_vars/all
* run ./provision.sh

## Troubleshooting
* Make sure you cleanup /etc/hosts so that it doesn't have stale Vagrant host mappings.
* Make sure Ansible env-setup and Vagrant env-setup are present as defined in ./vagrant.sh


