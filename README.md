create a network
```
docker network create   --driver overlay    phototankswarm
```

Start the mysql service:
```
docker service create --replicas 1 --name db -p 3306:3306 --network phototankswarm --env-file .env.prod hypriot/rpi-mysql
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
--mount type=volume,source=my-volume,destination=/path/in/container \
-p 8080:80 \
drakerin/rpi-alpine-nginx
```
docker service create --replicas 1 \
--name fileserver \
--network phototankswarm \
hypriot/rpi-alpine-scratch

