# docker-kafka-manager
[Kafka Manager](https://github.com/yahoo/kafka-manager) in a Docker container

## Usage
To run, simply
```
docker run -p 9000:9000 --name kafka-manager --env ZK_HOSTS="my.zookeeper.host.com:2181" frontporch/docker-kafka-manager
```

## TODO
This is the wrong way to create this container.  It results in a huge container.  A better way would be to use a java
container and just download a [prebuilt kafka-manager release](https://github.com/yahoo/kafka-manager/releases) and extract
it.  This would result in a _drastically_ smaller image.