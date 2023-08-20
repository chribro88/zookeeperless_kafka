#!/bin/bash

/kafka/bin/kafka-storage.sh format --config /kafka/config/server.properties --cluster-id "$KAFKA_CLUSTER_ID" --ignore-formatted

/kafka/bin/kafka-server-start.sh /kafka/config/server.properties
