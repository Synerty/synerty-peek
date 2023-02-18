FROM centos:7
ENV RELEASE_BRANCH="v3.4.x"

WORKDIR /root

ENV NVM_DIR="/root/.nvm"
ENV NODE_VER="14.15.3"
ENV NVM_VER="0.37.2"
ENV TYPESCRIPT_VER="3.8.3"
ENV SONAR_VER="4.2.0.1873"
ENV SONAR_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli"
ENV NVM_URL="https://raw.githubusercontent.com/creationix/nvm"

RUN yum install -y unzip

# Install NVM
RUN curl --silent -o- ${NVM_URL}/v${NVM_VER}/install.sh | bash

RUN . $NVM_DIR/nvm.sh && nvm install $NODE_VER
RUN . $NVM_DIR/nvm.sh && nvm alias default $NODE_VER

# Display the path that should be setup, and setup the path
RUN . $NVM_DIR/nvm.sh && echo $PATH
ENV PATH="/root/.nvm/versions/node/v${NODE_VER}/bin:${PATH}"

# Setup NPM
RUN npm config set user 0
RUN npm config set unsafe-perm true
RUN npm install -g typescript@${TYPESCRIPT_VER}

# Install Sonar
RUN mkdir -p /opt && cd /opt
RUN cd /opt \
    && curl ${SONAR_URL}/sonar-scanner-cli-${SONAR_VER}-linux.zip --output sonar.zip
RUN cd /opt \
    && unzip sonar.zip \
    && mv sonar-scanner-${SONAR_VER}-linux sonar-scanner
RUN cd /opt && rm -fR sonar.zip

ENV PATH="${PATH}:/opt/sonar-scanner/bin"
