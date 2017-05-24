create a network
```
docker network create   --driver overlay    phototankswarm
```

Start the mysql service:
```
docker service create --replicas 1 \
--name db -p 3306:3306 \
--network phototankswarm \
--env-file /home/pi/apps/phototank/phototank.backend/.env.prod \
--mount type=volume,volume-opt=o=addr=pizero.local,volume-opt=device=:/mnt/nfsserver/data/sql,volume-opt=type=nfs,source=db,target=/var/lib/mysql \
hypriot/rpi-mysql
```

Start the redis service:
```
docker service create --replicas 1 \
--name redis \
--network phototankswarm \
-p 6379:6379 \
armhf/redis
```

Start the nginx service:
```
docker service create --replicas 1 \
--name nginx \
--network phototankswarm \
--mount type=volume,volume-opt=o=addr=pizero.local,volume-opt=device=:/mnt/nfsserver/nginx,volume-opt=type=nfs,source=ngx,target=/tmp/conf_override \
-p 8080:80 \
drakerin/rpi-alpine-nginx
```

```
docker service create --replicas 1 \
--name nginx \
--network phototankswarm \
--mount type=volume,source=nfsshare,target=/pluto \
-e constraint:node==piuno \
-p 8080:80 \
drakerin/rpi-alpine-nginx
```
--mount type=volume,volume-opt=o=addr=pizero.local,volume-opt=device=:/mnt/nfsserver,volume-opt=type=nfs,source=pluto,target=/pluto

docker service create --replicas 1 \
--name fileserver \
--network phototankswarm \
hypriot/rpi-alpine-scratch

Launch portainer:

```
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock hypriot/rpi-portainer --swarm
```


Fix NFS on pimanager:

```
showmount -e
showmount -a
rpcinfo -p

sudo systemctl restart nfs-kernel-server
```
