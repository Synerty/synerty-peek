FROM centos:7
ENV RELEASE_BRANCH="v3.1.x"

WORKDIR /root

ENV PEEK_PY_VER="3.9.1"
ENV PEEK_NODE_PACKAGE_VERSION="14.15.3"
ENV PATH="/root/cpython-${PEEK_PY_VER}/bin:$PATH"

# -----------------------------------------------------------------------------
# Setup the dependencies from
# https://synerty-peek.readthedocs.io/en/latest/setup_os_requirements
#   /setup_os_requirements_debian/SetupOSRequirementsDebian.html
#   #compile-and-install-python-3-6

RUN yum update -y

# Install the C Compiler package, used for compiling python or VMWare tools, etc:
RUN yum install -y gcc gcc-c++ kernel-devel make

# Install some utility packages:
RUN yum install -y rsync unzip wget git bzip2

# Install the Python build dependencies:
RUN yum install -y curl git m4 ruby texinfo bzip2-devel libcurl-devel
RUN yum install -y expat-devel ncurses-libs zlib-devel gmp-devel
RUN yum install -y openssl openssl-devel

# Install the Postgres build dependencies:
RUN yum install -y bison flex
RUN yum install -y readline-devel openssl-devel python-devel

# Install C libraries that some python packages link to when they install:
RUN yum install -y libffi-devel

# Install C libraries required for LDAP:
RUN yum install -y openldap-devel

# For Shapely and GEOAlchemy
ENV FEDORA_PACKAGES="https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages"
RUN yum install -y \
    ${FEDORA_PACKAGES}/g/geos-3.4.2-2.el7.x86_64.rpm \
    ${FEDORA_PACKAGES}/g/geos-devel-3.4.2-2.el7.x86_64.rpm \
    ${FEDORA_PACKAGES}/l/libsqlite3x-20071018-20.el7.x86_64.rpm \
    ${FEDORA_PACKAGES}/l/libsqlite3x-devel-20071018-20.el7.x86_64.rpm

# Install C libraries that the oracle client requires:
# For LXML and the Oracle client
RUN yum install -y libxml2 libxml2-devel
RUN yum install -y libxslt libxslt-devel
RUN yum install -y libaio libaio-devel


# Install FreeTDS (Optional)
ENV FEDORA_PACKAGES="https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages"
RUN yum install -y \
    ${FEDORA_PACKAGES}/f/freetds-libs-1.1.20-1.el7.x86_64.rpm \
    ${FEDORA_PACKAGES}/f/freetds-1.1.20-1.el7.x86_64.rpm \
    ${FEDORA_PACKAGES}/f/freetds-devel-1.1.20-1.el7.x86_64.rpm

# Cleanup the downloaded packages:
RUN yum clean all

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