# docker-kafka-manager
[Kafka Manager](https://github.com/yahoo/kafka-manager) in a Docker container

## Usage
To run, simply
```
docker run -p 9000:9000 --name kafka-manager --env ZK_HOSTS="my.zookeeper.host.com:2181" frontporch/docker-kafka-manager
```

## TODO
This isn't the best way to create this container.  It results in a huge container.  A better way would be to use a openjdk:8-jre container and just download a prebuilt kafka-manager release.
Unfortunately Kafka Manager doesn't include pre-build binaries in it's releases.  This would result in a _drastically_ smaller image.  Right now it looks like the Kafka
Manager makefile includes the ability to create a `.deb`.  We should probably make the `.deb`, install it, and remove the entire /opt/kafka-manager directory to save about 100 MB.