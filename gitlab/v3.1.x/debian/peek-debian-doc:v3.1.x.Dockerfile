FROM peek-debian:v3.1.x
ENV RELEASE_BRANCH="v3.1.x"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the dependency for building PDFs from Sphinx
RUN apt-get install -y texlive
RUN apt-get install -y texlive-latex-extra
