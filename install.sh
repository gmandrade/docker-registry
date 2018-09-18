#!/usr/bin/env bash

create_func(){
	echo "Creating network"
	docker network create registry-net

	echo "Creating registry container"
	docker run --name registry -d --net registry-net --restart=always -v /mnt/volume/registry:/var/lib/registry registry:2

	echo "Creating registry web admin container"
	docker run --name registry-webadmin -d --net registry-net -p 80:80 -e REGISTRY_URL=http://registry:5000 -e DELETE_IMAGES=true -e REGISTRY_TITLE="Personal Registry" joxit/docker-registry-ui:static
}


with_systemd_call(){
	cat <<EOF | tee /etc/systemd/system/docker-registry.service
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

	cat <<EOF | tee /etc/systemd/system/docker-registry-webadmin.service
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

	systemctl daemon-reload

	systemctl enable docker-registry 
	systemctl enable docker-registry-webadmin

	systemctl start docker-registry 
	systemctl start docker-registry-webadmin
}

with_systemd_help() { echo "./install.sh [--with_systemd]" 1>&2; exit; }

if [[ -z $1 ]];then
	create_func
elif [[ $1 != "--with_systemd" ]];then
	with_systemd_help
else
	create_func
	with_systemd_call
fi