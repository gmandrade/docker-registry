# Docker Registry with Docker and Systemd 
## Automation script
```
# Without systemd configurations
$ sudo ./install.sh
or
# With systemd configurations
$ sudo ./install.sh --with-systemd
```

> Access http://localhost to see webadmin application

## Push your images
```
$ docker push localhost/registry:stable
$ docker push localhost/registry-webadmin:stable
```

# Step by step
## Build
```
$ docker build -t localhost/registry:stable registry/
$ docker build -t localhost/registry-webadmin:stable registry-webadmin/
```
## Network
```
$ docker network create registry-net
```

## Registry
> OBS: Take a look with your volume bind it's correct. In this case I mount /mnt/volume/registry
```
$ docker run --name registry -d --net registry-net --restart=always -v /mnt/volume/registry:/var/lib/registry registry:2
```

## Registry Web Admin
```
$ docker run --name registry-webadmin -d --net registry-net -p 80:80 -e REGISTRY_URL=http://registry:5000 -e DELETE_IMAGES=true -e REGISTRY_TITLE="Personal Registry" joxit/docker-registry-ui:static
```

# Systemd files
## Registry container
```
$ cat <<EOF | tee /etc/systemd/system/docker-registry.service
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
```

## Registry web admin container
```
$ cat <<EOF | tee /etc/systemd/system/docker-registry-webadmin.service
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
```

## Daemon Reload for apply changes
```
$ systemctl daemon-reload
```

## Enable registry
```
$ systemctl enable docker-registry 
$ systemctl enable docker-registry-webadmin
```

## Start
```
$ systemctl start docker-registry 
$ systemctl start docker-registry-webadmin
```

## Stop
```
$ systemctl stop docker-registry 
$ systemctl stop docker-registry-webadmin
```

## Check
```
$ systemctl status docker-registry 
$ systemctl status docker-registry-webadmin
```

# Using ./controller.sh
## Start
```
$ sudo ./controller.sh start
```

## Stop
```
$ sudo ./controller.sh stop
```

## Destroy
```
$ sudo ./controller.sh destroy
```
