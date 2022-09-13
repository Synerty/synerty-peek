FROM peek-debian:v3.2.x
ENV RELEASE_BRANCH="v3.2.x"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the dependency for building PDFs from Sphinx
RUN apt-get install -y texlive
RUN apt-get install -y texlive-latex-extra
