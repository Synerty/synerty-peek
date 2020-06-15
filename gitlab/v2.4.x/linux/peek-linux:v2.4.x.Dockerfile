FROM debian:9
ENV RELEASE_BRANCH="v2.4.x"

WORKDIR /root

ENV PEEK_PY_VER="3.6.8"
ENV PEEK_NODE_PACKAGE_VERSION="10.16.0"
ENV PATH="/root/cpython-${PEEK_PY_VER}/bin:$PATH"

# -----------------------------------------------------------------------------
# Setup the dependencies from
# https://synerty-peek.readthedocs.io/en/latest/setup_os_requirements
#   /setup_os_requirements_debian/SetupOSRequirementsDebian.html
#   #compile-and-install-python-3-6

RUN apt update
# Install the C Compiler package, used for compiling python or VMWare tools, etc:
RUN apt install -y gcc make linux-headers-amd64
# Install some utility packages:
RUN apt install -y rsync unzip wget
# Install the Python build dependencies:
RUN apt install -y build-essential m4 ruby texinfo libbz2-dev libcurl4-openssl-dev
RUN apt install -y libexpat-dev libncurses-dev zlib1g-dev libgmp-dev libssl-dev
# Install C libraries that some python packages link to when they install:
RUN apt install -y libffi-dev
# Install C libraries required for LDAP:
RUN apt install -y libsasl2-dev libldap-common libldap2-dev
# Install C libraries that database access python packages link to when they install
RUN apt install -y libgeos-dev libgeos-c1v5 libpq-dev libsqlite3-dev
# Install C libraries that the oracle client requires:
RUN apt install -y libxml2 libxml2-dev libxslt1.1 libxslt1-dev libaio1 libaio-dev

RUN wget "https://www.python.org/ftp/python/${PEEK_PY_VER}/Python-${PEEK_PY_VER}.tgz"
RUN tar xzf Python-${PEEK_PY_VER}.tgz
RUN cd Python-${PEEK_PY_VER} \
    && ./configure --prefix=/root/cpython-${PEEK_PY_VER}/ --enable-optimizations \
    && make install
RUN rm -fR Python-${PEEK_PY_VER}* \
    && cd /root/cpython-${PEEK_PY_VER}/bin \
    && ln -s pip3 pip \
    && ln -s python3 python
RUN pip install --upgrade pip
RUN pip install virtualenv
RUN pip install wheel
RUN pip install twine
