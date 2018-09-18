#!/usr/bin/env bash

docker_build(){
	echo "`date` INFO Build containers"
	docker build -t localhost/registry:stable registry/ &> /dev/null
	docker build -t localhost/registry-webadmin:stable registry-webadmin/ &> /dev/null
}

create_func(){
	echo "`date` INFO - Create netowrk 'registry-net'"
	docker network create registry-net &> /dev/null
	echo "`date` INFO - Run containers"
	docker run --name registry -d --net registry-net --restart=always -v /mnt/volume/registry:/var/lib/registry localhost/registry:stable &> /dev/null 
	docker run --name registry-webadmin -d --net registry-net -p 80:80 -e REGISTRY_URL=http://registry:5000 -e DELETE_IMAGES=true -e REGISTRY_TITLE="Personal Registry" localhost/registry-webadmin:stable &> /dev/null
}


with_systemd_call(){
	echo "`date` INFO - Creating systemd files"

	cat <<EOF | tee /etc/systemd/system/docker-registry.service &> /dev/null
[Unit]
Description=Registry Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a registry
ExecStop=/usr/bin/docker stop registry

[Install]
WantedBy=local.target
EOF

	cat <<EOF | tee /etc/systemd/system/docker-registry-webadmin.service &> /dev/null 
[Unit]
Description=Registry Container Web Admin
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a registry-webadmin
ExecStop=/usr/bin/docker stop registry-webadmin

[Install]
WantedBy=local.target
EOF
	echo "`date` INFO - Sytemd daemon reload"
	systemctl daemon-reload &> /dev/null 

	echo "`date` INFO - Force status 'started'"
	systemctl start docker-registry &> /dev/null 
	systemctl start docker-registry-webadmin &> /dev/null 
}

with_systemd_help() { echo "`date` ERROR - Usage: sudo ./install.sh [--with-systemd]" 1>&2; exit; }

if [[ -z $1 ]];then
	docker_build
	create_func
elif [[ $1 != "--with-systemd" ]];then
	with_systemd_help
else
	docker_build
	create_func
	with_systemd_call
fi