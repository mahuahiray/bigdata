# Base image: Java 8 JRE
FROM openjdk:8-jre

# Python installation and setup
RUN set -ex; \
    apt-get update; \
    apt-get install -y python3 python3-pip python3-dev libsnappy1v5; \
    ln -sf /usr/bin/python3 /usr/bin/python; \
    ln -sf /usr/bin/pip3 /usr/bin/pip; \
    rm -rf /var/lib/apt/lists/*; \
    python -m pip install --upgrade pip

# PyFlink installation
COPY ./requirements.txt /opt
RUN pip install -r /opt/requirements.txt

# Installing Apache Flink libraries
COPY ./apache-flink-libraries-1.13.0.tar.gz /opt
RUN pip install /opt/apache-flink-libraries-1.13.0.tar.gz && \
    rm /opt/apache-flink-libraries-1.13.0.tar.gz

# Installing Apache Flink
COPY ./apache-flink-1.13.0.tar.gz /opt
RUN pip install /opt/apache-flink-1.13.0.tar.gz && \
    rm /opt/apache-flink-1.13.0.tar.gz

# Setting up the environment
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
RUN groupadd --system --gid=9999 flink && \
    useradd --system --home-dir $FLINK_HOME --uid=9999 --gid=flink flink
WORKDIR $FLINK_HOME

# Adding Flink files
ADD ./flink-1.13.0 /opt/flink

# Container configuration
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 6123 8081
CMD ["help"]

# Maintainer information
LABEL maintainer="Mahua Nitin Hiray"
