# zookeeperless_kafka
- create named volumes
- build iamge & push to repo
- either deploy (not work on lxc/d) or run on each
```
docker build -t chribro88/kafka:3.5.1 https://github.com/chribro88/zookeeperless_kafka.git#master --build-arg DEBUG=1
REG=
docker tag chribro88/kafka:3.5.1 $REG/cb/kafka:3.5.1
docker push  $REG/cb/kafka:3.5.1
```
