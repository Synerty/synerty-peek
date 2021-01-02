FROM debian:10

WORKDIR /root

ENV NVM_DIR="/usr/local/nvm"
ENV NODE_VER="14.15.3"
ENV NVM_VER="0.37.2"
ENV TYPESCRIPT_VER="3.8.3"
ENV BINARIES_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli"
ENV SONAR_VER="4.2.0.1873"

RUN apt update
RUN apt install -y curl unzip

# Setup sonar dependencies
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v${NVM_VER}/install.sh | bash

RUN . $NVM_DIR/nvm.sh && nvm install $NODE_VER
RUN . $NVM_DIR/nvm.sh && nvm alias default $NODE_VER

RUN . $NVM_DIR/nvm.sh && npm config set user 0
RUN . $NVM_DIR/nvm.sh && npm config set unsafe-perm true

ENV NODE_PATH="`npm root -g`"
RUN npm install -g typescript@${TYPESCRIPT_VER}


RUN mkdir -p /opt && cd /opt
RUN cd /opt && curl ${BINARIES_URL}/sonar-scanner-cli-${SONAR_VER}-linux.zip --output sonar-scanner.zip
RUN cd /opt && unzip sonar-scanner.zip && mv sonar-scanner-${SONAR_VER}-linux sonar-scanner
RUN cd /opt && rm -fR sonar-scanner.zip

ENV PATH="${PATH}:/opt/sonar-scanner/bin"
