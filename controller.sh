#!/usr/bin/env bash

ACTION=$1

if [[ $ACTION == "stop" ]];then
	systemctl stop docker-registry &> /dev/null
	systemctl stop docker-registry-webadmin &> /dev/null
	echo "INFO - Stop docker-registry and docker-registry-webadmin"
elif [[ $ACTION == "start" ]];then
	systemctl start docker-registry &> /dev/null
	systemctl start docker-registry-webadmin &> /dev/null
	echo "INFO - Start docker-registry and docker-registry-webadmin"
elif [[ $ACTION == "destroy" ]];then
	docker rm -f registry registry-webadmin &> /dev/null
	rm -f /etc/systemd/system/docker-registry-webadmin.service &> /dev/null
	rm -f /etc/systemd/system/docker-registry.service &> /dev/null
	echo "INFO - Destroy docker-registry project"
else
	echo "ERROR - $ACTION is a invalid option. Choose 'start' or 'stop'"
fi
