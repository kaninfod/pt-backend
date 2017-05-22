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
--mount type=volume,volume-opt=o=addr=pizero.local,volume-opt=device=:/mnt/nfsserver/nginx,volume-opt=type=nfs,source=phototank,target=/tmp/conf_override \
-p 8080:80 \
drakerin/rpi-alpine-nginx
```
--mount type=volume,volume-opt=o=addr=pizero.local,volume-opt=device=:/mnt/nfsserver,volume-opt=type=nfs,source=pluto,target=/pluto

docker service create --replicas 1 \
--name fileserver \
--network phototankswarm \
hypriot/rpi-alpine-scratch

