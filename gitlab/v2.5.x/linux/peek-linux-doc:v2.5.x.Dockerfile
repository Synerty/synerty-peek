FROM peek-linux:v2.5.x
ENV RELEASE_BRANCH="v2.5.x"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the dependency for building PDFs from Sphinx
RUN apt-get install -y texlive
RUN apt-get install -y texlive-latex-extra
