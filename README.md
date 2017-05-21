
Start the mysql service:
```
docker service create --replicas 1 \
--name db \
-p 3306:3306 \
--network phototank \
-env-file .env.prod \
hypriot/rpi-mysql
```
