# About The Project

It's a prepared VM for developing Magento shops. Should be used only on local machine - the project is not intended to be a full-blown Magento virtualization solution.

Dependencies:

* Vagrant
* Ansible

# Setup DEV environment

## Prepare Vagrant instance
1. clone git@github.com:etaroza/magento-vm.git
1. cd magento-vm
1. `put "magento" folder or symlink into magento-vm/magento or symlink there`
1. vagrant up

If you get the error:

`The executable 'ansible-playbook' Vagrant is trying to run was not found in the PATH variable. This is an error. Please verify this software is installed and on the path.`

Then make sure that on the ansible is setup. Normally would be enough to run:

`$ source ../ansible/hacking/env-setup`

Then vagrant provision again.

## Accessing Magento inside Vagrant
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
    proxy_pass http://<%= @server_name %>:10080;
    proxy_read_timeout 20m;
    proxy_connect_timeout 20m;
  }
}
```

So in Vagrantfile there's port mapping defined:

* 10080 => 80 (to access the web server inside Vagrant)
* 13306 => 3306 (to access MySQL inside Vagrant)
