
# https://hub.docker.com/r/sheepkiller/kafka-manager/
# https://github.com/sheepkiller/kafka-manager-docker
# kafka manager Dockerfile
# kafka manager is a tool from Yahoo Inc. for managing Apache Kafka.
# Base Docker Image centos:7

# https://segmentfault.com/a/1190000011446369
docker run -it --rm\
 --link kafkadocker_zookeeper_1:zookeeper\
 --link kafkadocker_kafka_1:kafka\
 -p 9000:9000\
 -e ZK_HOSTS=zookeeper:2181\
 dockerkafka/kafka-manager

# Quick Start
docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="your-zk.domain:2181" -e APPLICATION_SECRET=letmein sheepkiller/kafka-manager
docker run -it --rm  -p 9000:9000\
 -e ZK_HOSTS="zookeeper:2181"\
 -e APPLICATION_SECRET=letmein\
 --link zookeeper:zookeeper\
 sheepkiller/kafka-manager
docker run -d --restart=always --name kafka-manager\
 -p 9000:9000\
 -e ZK_HOSTS="zookeeper:2181"\
 -e APPLICATION_SECRET=letmein\
 --link zookeeper:zookeeper\
 sheepkiller/kafka-manager
# (if you don't define ZK_HOSTS, default value has been set to "localhost:2181")

# Use your own configuration file
## Until 1.3.0.4, you were able to override default configuration file via a docker volume to overi:
docker run [...] -v /path/to/confdir:/kafka-manager-${KM_VERSION}/conf [...]
## From > 1.3.0.4, you can specify a configuration file via an environment variable.
docker run [...] -v /path/to/confdir:/opt -e KM_CONFIG=/opt/my_shiny.conf sheepkiller/kafka-manager
## Pass arguments to kafka-manager
## For release <= 1.3.0.4, you can pass options via command/args.
docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="your-zk.domain:2181" -e APPLICATION_SECRET=letmein sheepkiller/kafka-manager -Djava.net.preferIPv4Stack=true
## For release > 1.3.0.4, you can use env variable KM_ARGS.
docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="your-zk.domain:2181" -e APPLICATION_SECRET=letmein -e KM_ARGS=-Djava.net.preferIPv4Stack=true sheepkiller/kafka-manager