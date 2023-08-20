#!/bin/bash

/kafka/bin/kafka-storage.sh format --config /kafka/config/server.properties --override node.id=$KAFKA_NODE_ID --override advertised.listeners=PLAINTEXT://$KAFKA_NODE_NAME:9192,LISTENER_DOCKER_EXTERNAL://$KAFKA_NODE_IP:9092 --cluster-id "$KAFKA_CLUSTER_ID" --ignore-formatted

/kafka/bin/kafka-server-start.sh /kafka/config/server.properties --override node.id=$KAFKA_NODE_ID --override advertised.listeners=PLAINTEXT://$KAFKA_NODE_NAME:9192,LISTENER_DOCKER_EXTERNAL://$KAFKA_NODE_IP:9092
