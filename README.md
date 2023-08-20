# zookeeperless_kafka
- create named volumes
- build iamge & push to repo
- either deploy (not work on lxc/d) or run on each

docker build -t erkansirin78/kafka:3.2.0 https://github.com/chribro88/zookeeperless_kafka.git#master --build-arg NODE=kafka1
REG=
docker tag erkansirin78/kafka:3.2.0 $REG/cb/kafka:3.2.0
docker push  $REG/cb/kafka:3.2.0

