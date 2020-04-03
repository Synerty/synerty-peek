FROM debian:9

WORKDIR /root

ENV PEEK_PY_VER="3.6.8"
ENV PEEK_NODE_PACKAGE_VERSION="10.16.0"
ENV PATH="/root/cpython-${PEEK_PY_VER}/bin:$PATH"

ENV NVM_DIR="/usr/local/nvm"
ENV SONAR_NODE_VERSION="12.16.1"

RUN apt update
# Install the C Compiler package, used for compiling python
RUN apt install -y gcc make zlib1g zlib1g-dev curl git wget jq vim zip unzip wget net-tools rsync
# Install the Python build dependencies:
RUN apt install -y build-essential m4 ruby texinfo libbz2-dev libcurl4-openssl-dev
RUN apt install -y libexpat-dev libncurses-dev zlib1g-dev libgmp-dev libssl-dev
# Install C libraries that some python packages link to when they install:
RUN apt install -y libffi-dev
# Install C libraries that database access python packages link to when they install
RUN apt install -y libgeos-dev libgeos-c1v5 libpq-dev libsqlite3-dev
# Install C libraries that the oracle client requires:
RUN apt install -y libxml2 libxml2-dev libxslt1.1 libxslt1-dev libaio1 libaio-dev
# Install libraries for LDAP
RUN apt install -y libsasl2-dev libldap-common libldap2-dev

RUN git config --global user.name "GitLab CI"
RUN git config --global user.email "gitlab-ci@synerty.com"

RUN wget "https://www.python.org/ftp/python/${PEEK_PY_VER}/Python-${PEEK_PY_VER}.tgz"
RUN tar xzf Python-${PEEK_PY_VER}.tgz
RUN cd Python-${PEEK_PY_VER} && ./configure --prefix=/root/cpython-${PEEK_PY_VER}/ --enable-optimizations && make install
RUN rm -fR Python-${PEEK_PY_VER}* && cd /root/cpython-${PEEK_PY_VER}/bin && ln -s pip3 pip && ln -s python3 python
RUN pip install --upgrade pip
RUN pip install virtualenv
RUN pip install wheel
RUN pip install twine

# Setup sonar dependencies
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN . $NVM_DIR/nvm.sh \
    && nvm install $SONAR_NODE_VERSION

RUN . $NVM_DIR/nvm.sh && npm config set user 0
RUN . $NVM_DIR/nvm.sh && npm config set unsafe-perm true


RUN mkdir -p /opt && cd /opt && curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip --output sonar-scanner.zip \
    && unzip sonar-scanner.zip && mv sonar-scanner-4.2.0.1873-linux sonar-scanner && rm -fR sonar-scanner.zip
ENV PATH="${PATH}:/opt/sonar-scanner/bin"
