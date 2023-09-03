topics_file="topics.txt"
while IFS= read -r topic; do
    echo "Creating Kafka topic: $topic"
    ./kafka/bin/kafka-topics.sh --create --topic "$topic" --partitions 9 --replication-factor 3 --bootstrap-server kafka1:9192,kafka2:9192,kafka3:9192 --config min.insync.replicas=2 --config compression.type=lz4
done < "$topics_file"
