FROM hseeberger/scala-sbt
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 \
    KM_VERSION=1.3.0.8 \
    KM_REVISION=f388612377aedc93c0d97238449f3aa0e6b0c3ed

#RUN mkdir -p /tmp && cd /tmp && \
RUN apt-get update > /dev/null &&  \

    # Install Node.js since that makes compilation go faster
    apt-get install -qq nodejs && \
    export SBT_OPTS="${SBT_OPTS} -Dsbt.jse.engineType=Node -Dsbt.jse.command=$(which nodejs)" && \
    
    # Get sources
    cd /tmp && \
    git clone -q https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout -q ${KM_REVISION} && \
    
    # Remove path too long error when run in Docker container
    echo "scalacOptions ++= Seq(\"-Xmax-classfile-name\",\"72\")" >> /tmp/kafka-manager/build.sbt && \

    # Make sbt builds quiet    
    mkdir ~/.sbt/0.13/plugins && \
    touch ~/.sbt/0.13/plugins/build.sbt && \
    echo "logLevel in Global := Level.Error" >> ~/.sbt/0.13/plugins/build.sbt && \

    # Build
    sbt --error -sbt-version 0.13.11 clean dist && \
    
    # Install
    unzip -d /opt /tmp/kafka-manager/target/universal/kafka-manager-${KM_VERSION}.zip && \

    # Remove scala
    rm -rf ~/scala-$SCALA_VERSION && \

    # Cleanup .bashrc
    sed -i.bak '/export PATH=~\/scala-$SCALA_VERSION\/bin:$PATH/d' /root/.bashrc && \

    # Remove Scala environmental variables
    unset SCALA_VERSION && \

    # Remove SBT
    dpkg -P sbt && \

    # Cleanup after SBT
    rm -rf ~/.sbt ~/.ivy2 && \

    # Remove SBT environmental variables
    unset SBT_VERSION && \

    # Clean
    apt-get clean && rm -fr /tmp/* && echo "Build Complete"

EXPOSE 9000
WORKDIR /opt/kafka-manager-${KM_VERSION}
ENTRYPOINT ["./bin/kafka-manager","-Dconfig.file=conf/application.conf"]
