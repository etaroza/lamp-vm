#!/bin/sh
ansiblesetupfile=../ansible/hacking/env-setup

if [ -f $ansiblesetupfile ];
then
	if [ -f $vagrantsetupfile ];
	then
		echo "=> Running Ansible environment setup from: $ansiblesetupfile"
		source $ansiblesetupfile
		echo "=> Executing: vagrant provision"
		vagrant provision
	fi
else
   echo "Ansible environment setup file not found at: $ansiblesetupfile"
fi
