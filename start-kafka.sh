#!/bin/bash

IP=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $1}')

cat /kafka/config/server.properties.template | sed \
  -e "s|{{KAFKA_NODE_ID}}|${KAFKA_NODE_ID:-0}|g" \
  -e "s|{{KAFKA_QUORUM_VOTERS}}|${KAFKA_QUORUM_VOTERS:-1@kafka1:9093,2@kafka2:9093,3@kafka3:9093}|g" \
  -e "s|{{KAFKA_LISTENERS}}|${KAFKA_LISTENERS:-PLAINTEXT://$HOSTNAME:9192,CONTROLLER://$HOSTNAME:9093,LISTENER_DOCKER_EXTERNAL://0.0.0.0:9092}|g" \
  -e "s|{{KAFKA_ADVERTISED_LISTENERS}}|${KAFKA_ADVERTISED_LISTENERS:-PLAINTEXT://$HOSTNAME:9192,LISTENER_DOCKER_EXTERNAL://$IP:9092}|g" \
  -e "s|{{KAFKA_AUTO_TOPIC_CREATION_ENABLE}}|${KAFKA_AUTO_TOPIC_CREATION_ENABLE:-false}|g" \
  -e "s|{{KAFKA_NUM_PARTITIONS}}|${KAFKA_NUM_PARTITIONS:-18}|g" \
   > /kafka/config/server.properties
   
/kafka/bin/kafka-storage.sh format --config /kafka/config/server.properties --cluster-id "$KAFKA_CLUSTER_ID" --ignore-formatted

/kafka/bin/kafka-server-start.sh /kafka/config/server.properties
