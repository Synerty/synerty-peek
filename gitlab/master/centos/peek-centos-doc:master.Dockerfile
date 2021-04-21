FROM peek-centos:master
ENV RELEASE_BRANCH="master"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the dependency for building PDFs from Sphinx
RUN apt-get install -y texlive
RUN apt-get install -y texlive-latex
