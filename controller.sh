#!/usr/bin/env bash

ACTION=$1

if [[ $ACTION == "stop" ]];then
	systemctl stop docker-registry
	systemctl stop docker-registry-webadmin
	echo "INFO - Stop docker-registry and docker-registry-webadmin"
elif [[ $ACTION == "start" ]];then
	systemctl start docker-registry
	systemctl start docker-registry-webadmin
	echo "INFO - Start docker-registry and docker-registry-webadmin"
else
	echo "ERROR - $ACTION is a invalid option. Choose 'start' or 'stop'"
fi
