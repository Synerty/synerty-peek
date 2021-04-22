FROM peek-centos:master
ENV RELEASE_BRANCH="master"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the dependency for building PDFs from Sphinx
RUN yum install -y texlive
RUN yum install -y texlive-*
