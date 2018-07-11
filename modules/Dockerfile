FROM ubuntu:16.04

ENV CONSUL_VERSION=1.2.0
RUN apt update -y 
RUN apt install -y curl unzip jq 
RUN apt install -y iproute2

# Create consul install paths
RUN mkdir -p /opt/consul && \
    mkdir -p /opt/consul/bin && \
    mkdir -p /opt/consul/config && \
    mkdir -p /opt/consul/data && \
    mkdir -p /opt/consul/log

# Install binaries
RUN curl -o /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip -d /tmp /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    mv /tmp/consul /opt/consul/bin/consul && \
    chmod a+x /opt/consul/bin/consul && \
    ln -s /opt/consul/bin/consul /usr/local/bin/consul

COPY run-consul/run-consul-docker /opt/consul/bin/run-consul
RUN chmod a+x /opt/consul/bin/run-consul

WORKDIR /opt/consul/bin
ENTRYPOINT [ "./run-consul" ]
CMD ["--server"]