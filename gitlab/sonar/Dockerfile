FROM debian:9

WORKDIR /root

ENV NVM_DIR="/usr/local/nvm"
ENV NODE_VERSION="12.16.1"
ENV BINARIES_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli"
ENV VER="4.2.0.1873"

RUN apt update
RUN apt install -y curl unzip

# Setup sonar dependencies
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN . $NVM_DIR/nvm.sh && nvm install $NODE_VERSION

RUN . $NVM_DIR/nvm.sh && npm config set user 0
RUN . $NVM_DIR/nvm.sh && npm config set unsafe-perm true

RUN mkdir -p /opt && cd /opt
RUN cd /opt && curl ${BINARIES_URL}/sonar-scanner-cli-${VER}-linux.zip --output sonar-scanner.zip
RUN cd /opt && unzip sonar-scanner.zip && mv sonar-scanner-${VER}-linux sonar-scanner
RUN cd /opt && rm -fR sonar-scanner.zip

ENV PATH="${PATH}:/opt/sonar-scanner/bin"
