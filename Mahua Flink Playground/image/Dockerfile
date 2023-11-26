FROM openjdk:8-jre

# Install python and dependencies
RUN set -ex; \
  apt-get update; \
  apt-get -y install python3 python3-pip python3-dev libsnappy1v5; \
  ln -s /usr/bin/python3 /usr/bin/python; \
  ln -s /usr/bin/pip3 /usr/bin/pip; \
  rm -rf /var/lib/apt/lists/*; \
  python -m pip install --upgrade pip

# Install pyflink
COPY ./requirements.txt /opt
RUN pip install -r /opt/requirements.txt

COPY ./apache-flink-libraries-1.13.0.tar.gz /opt
RUN pip install /opt/apache-flink-libraries-1.13.0.tar.gz && \
    rm -f /opt/apache-flink-libraries-1.13.0.tar.gz

COPY ./apache-flink-1.13.0.tar.gz /opt
RUN pip install /opt/apache-flink-1.13.0.tar.gz && \
    rm -f /opt/apache-flink-1.13.0.tar.gz

# Prepare environment
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
RUN groupadd --system --gid=9999 flink && \
    useradd --system --home-dir $FLINK_HOME --uid=9999 --gid=flink flink
WORKDIR $FLINK_HOME

ADD ./flink-1.13.0 /opt/flink

# Configure container
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 6123 8081
CMD ["help"]
