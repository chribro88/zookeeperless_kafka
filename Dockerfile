FROM openjdk:11.0.10-jre-buster

RUN apt-get update && \
    apt-get install -y curl

RUN if [ "$DEBUG" = "1" ]; then \
    apt-get install -y \
        net-tools \
        && apt-get clean; \
    fi
         
ENV KAFKA_VERSION 3.5.1
ENV SCALA_VERSION 2.13 

RUN  mkdir /tmp/kafka && \
    curl "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    -o /tmp/kafka/kafka.tgz && \
    mkdir /kafka && cd /kafka && \
    tar -xvzf /tmp/kafka/kafka.tgz --strip 1

RUN mkdir -p /data/kafka

COPY start-kafka.sh  /usr/bin
COPY ./config/server.properties.template /kafka/config/server.properties.template

RUN chmod +x  /usr/bin/start-kafka.sh

EXPOSE 9092 9093

CMD ["start-kafka.sh"]

