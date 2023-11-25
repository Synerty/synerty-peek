FROM peek-centos:master
ENV RELEASE_BRANCH="master"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the dependency for building PDFs from Sphinx
RUN dnf install -y texlive
RUN dnf install -y texlive-*
RUN dnf install -y which

# Cleanup the downloaded packages:
RUN dnf clean all