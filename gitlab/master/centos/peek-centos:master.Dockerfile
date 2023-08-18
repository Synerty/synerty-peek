# base image for Peek
FROM almalinux:9.2
ENV RELEASE_BRANCH="master"

WORKDIR /root

ENV PEEK_PY_VER="3.11.4"
ENV PEEK_NODE_PACKAGE_VERSION="18.16.1"
ENV PATH="/root/cpython-${PEEK_PY_VER}/bin:$PATH"

# -----------------------------------------------------------------------------
# Setup the dependencies from
# https://synerty-peek.readthedocs.io/en/latest/setup_os_requirements
#   /setup_os_requirements_debian/SetupOSRequirementsDebian.html
#   #compile-and-install-python-3-6

RUN dnf update -y

RUN dnf install -y dnf-plugins-core
RUN dnf config-manager --set-enabled crb
RUN dnf install -y epel-release

# Install the C Compiler package, used for compiling python or VMWare tools, etc:
RUN dnf install -y gcc gcc-c++ kernel-devel make

# Install some utility packages:
RUN dnf install -y rsync unzip wget git bzip2

# Install the Python build dependencies:
RUN dnf install -y git m4 ruby texinfo bzip2-devel libcurl-devel
RUN dnf install -y expat-devel ncurses-libs zlib-devel gmp-devel
RUN dnf install -y openssl openssl-devel

# Install the Postgres build dependencies:
RUN dnf install -y bison flex
RUN dnf install -y readline-devel openssl-devel python3-devel

# Install C libraries that some python packages link to when they install:
RUN dnf install -y libffi-devel

# Install C libraries required for LDAP:
RUN dnf install -y openldap-devel

# For Shapely and GEOAlchemy
RUN dnf install -y geos geos-devel libsqlite3x libsqlite3x-devel

# Install C libraries that the oracle client requires:
# For LXML and the Oracle client
RUN dnf install -y libxml2 libxml2-devel
RUN dnf install -y libxslt libxslt-devel
RUN dnf install -y libaio libaio-devel


# Install FreeTDS (Optional)
RUN dnf install -y freetds-libs freetds freetds-devel

# Cleanup the downloaded packages:
RUN dnf clean all

# compile with openssl 3 on macos
#RUN mkdir -p /usr/local/openssl3
#RUN ln -s /usr/lib64/openssl3 /usr/local/openssl3/lib
#RUN ln -s /usr/include/openssl3 /usr/local/openssl3/include
# ./configure --with-openssl=/usr/local/openssl3

RUN wget "https://www.python.org/ftp/python/${PEEK_PY_VER}/Python-${PEEK_PY_VER}.tgz"
RUN tar xzf Python-${PEEK_PY_VER}.tgz
RUN cd Python-${PEEK_PY_VER} && ./configure \
      --prefix=/root/cpython-${PEEK_PY_VER}/ \
      --enable-optimizations \
    && make install && rm -fR Python-${PEEK_PY_VER}* \
    && cd /root/cpython-${PEEK_PY_VER}/bin \
    && ln -s pip3 pip \
    && ln -s python3 python
RUN mkdir -p /root/opt/bin
RUN ln -s /root/cpython-${PEEK_PY_VER}/bin/python /root/opt/bin/python
RUN ln -s /root/cpython-${PEEK_PY_VER}/bin/pip /root/opt/bin/pip
RUN pip install --upgrade pip
RUN pip install virtualenv
RUN pip install wheel
RUN pip install twine