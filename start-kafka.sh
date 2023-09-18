#!/bin/bash

IP=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $1}')

LISTEN_NAME="${HOSTNAME}"

for var in $(env | grep '^SWARM_NODE_ID_'); do
    echo "$var"
    # Split the variable into name and value
    IFS='=' read -r name value <<< "$var"
    # Check if the value equals the hostname
    if [ "$value" == "$SWARM_NODE_ID" ]; then
        # Set NODE_ID
        suffix=$(echo "$name" | sed 's/SWARM_NODE_ID_//')
        export KAFKA_NODE_ID="$suffix"

        # Print the result (optional)
        echo "NODE_ID set to $KAFKA_NODE_ID"
        
        # Exit the loop
        break
    fi
done

if [ "$KAFKA_PROCESS_ROLES" = "controller" ]; then
  KAFKA_ADVERTISED_LISTENERS_COMMENT="#"
  ADVERTISED_LISTENERS=""
else
  KAFKA_ADVERTISED_LISTENERS_COMMENT=""
  ADVERTISED_LISTENERS="PLAINTEXT://$LISTEN_NAME:9192,LISTENER_DOCKER_EXTERNAL://$IP:9092"
fi

cat /kafka/config/server.properties.template | sed \
  -e "s|{{KAFKA_NODE_ID}}|${KAFKA_NODE_ID:-0}|g" \
  -e "s|{{KAFKA_QUORUM_VOTERS}}|${KAFKA_QUORUM_VOTERS:-1@kafka1:9093,2@kafka2:9093,3@kafka3:9093}|g" \
  -e "s|{{KAFKA_LISTENERS}}|${KAFKA_LISTENERS:-PLAINTEXT://$LISTEN_NAME:9192,CONTROLLER://$LISTEN_NAME:9093,LISTENER_DOCKER_EXTERNAL://0.0.0.0:9092}|g" \
  -e "s|{{KAFKA_ADVERTISED_LISTENERS_COMMENT}}|${KAFKA_ADVERTISED_LISTENERS_COMMENT}|g" \
  -e "s|{{KAFKA_ADVERTISED_LISTENERS}}|${KAFKA_ADVERTISED_LISTENERS:-$ADVERTISED_LISTENERS}|g" \
  -e "s|{{KAFKA_AUTO_TOPIC_CREATION_ENABLE}}|${KAFKA_AUTO_TOPIC_CREATION_ENABLE:-false}|g" \
  -e "s|{{KAFKA_NUM_PARTITIONS}}|${KAFKA_NUM_PARTITIONS:-1}|g" \
  -e "s|{{KAFKA_PROCESS_ROLES}}|${KAFKA_PROCESS_ROLES:-broker,controller}|g" \
  -e "s|{{KAFKA_METADATA_LOG_DIR}}|${KAFKA_METADATA_LOG_DIR:-/data/kafka}|g" \
   > /kafka/config/server.properties
   
/kafka/bin/kafka-storage.sh format --config /kafka/config/server.properties --cluster-id "$KAFKA_CLUSTER_ID" --ignore-formatted
