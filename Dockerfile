# Build args for architecture-specific base images
ARG TARGETARCH

FROM ubuntu:20.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    wget \
    ssh \
    pdsh \
    python3 \
    python3-pip \
    sudo \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment variables based on architecture
ARG TARGETARCH
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-${TARGETARCH:-amd64}
ENV PATH=$PATH:$JAVA_HOME/bin

# Create Hadoop user and group
RUN groupadd -r hadoop && \
    useradd -r -g hadoop -d /home/hadoop -m hadoop && \
    chown hadoop:hadoop /home/hadoop

# Set HDFS users
ENV HDFS_NAMENODE_USER=hadoop
ENV HDFS_DATANODE_USER=hadoop
ENV HDFS_SECONDARYNAMENODE_USER=hadoop
ENV YARN_RESOURCEMANAGER_USER=hadoop
ENV YARN_NODEMANAGER_USER=hadoop

# Install Hadoop with architecture-specific download
ENV HADOOP_VERSION=3.4.0
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Download and install Hadoop based on architecture
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        HADOOP_PACKAGE="hadoop-${HADOOP_VERSION}-aarch64.tar.gz"; \
    else \
        HADOOP_PACKAGE="hadoop-${HADOOP_VERSION}.tar.gz"; \
    fi && \
    wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/${HADOOP_PACKAGE} && \
    tar -xzf ${HADOOP_PACKAGE} && \
    mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
    rm ${HADOOP_PACKAGE}

# Configure SSH
RUN mkdir -p /run/sshd && \
    mkdir -p /home/hadoop/.ssh && \
    ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa && \
    cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys && \
    chmod 0600 /home/hadoop/.ssh/authorized_keys && \
    chown -R hadoop:hadoop /home/hadoop/.ssh && \
    echo "Host *" > /home/hadoop/.ssh/config && \
    echo "    UserKnownHostsFile /dev/null" >> /home/hadoop/.ssh/config && \
    echo "    StrictHostKeyChecking no" >> /home/hadoop/.ssh/config && \
    chmod 600 /home/hadoop/.ssh/config && \
    chown hadoop:hadoop /home/hadoop/.ssh/config

# Copy Hadoop configuration files
COPY config/core-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY config/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY config/mapred-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY config/yarn-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY config/ssh_config /home/hadoop/.ssh/ssh_config

# Create necessary directories and set permissions
RUN mkdir -p /opt/hadoop/logs /opt/hadoop/data/namenode /opt/hadoop/data/datanode && \
    chown -R hadoop:hadoop ${HADOOP_HOME} && \
    chmod -R 755 ${HADOOP_HOME}

# Set working directory
WORKDIR /home/hadoop

# Copy Python MapReduce example
COPY scripts/* /home/hadoop/

RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV PDSH_RCMD_TYPE=ssh
RUN echo ssh | sudo tee /etc/pdsh/rcmd_default
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64 >> /opt/hadoop/etc/hadoop/hadoop-env.sh

USER hadoop
RUN /opt/hadoop/bin/hdfs namenode -format

RUN sudo service ssh start
RUN bash

EXPOSE 9870 9864 9866 8088
