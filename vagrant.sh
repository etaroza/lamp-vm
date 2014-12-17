#!/bin/sh
ansiblesetupfile=../ansible/hacking/env-setup
vagrantsetupfile=./env-setup

if [ -f $ansiblesetupfile ];
then
	if [ -f $vagrantsetupfile ];
	then
		echo "=> Running Ansible environment setup from: $ansiblesetupfile"
		source $ansiblesetupfile
		echo "=> Running Vagrant environment setup from: $vagrantsetupfile"
		source $vagrantsetupfile
		cat $vagrantsetupfile
		echo "\n"
		echo "=> Executing: vagrant $@"
		vagrant "$@"
	else
	   echo "Vagrant environment setup file not found at: $vagrantsetupfile"
	fi
else
   echo "Ansible environment setup file not found at: $ansiblesetupfile"
fi
