FROM peek-centos:master
ENV RELEASE_BRANCH="master"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the CI dependencies for the builds

# Install pbzip2 to accelerate tar compression
RUN dnf install -y jq

RUN git config --global user.name "GitLab CI"
RUN git config --global user.email "gitlab-ci@synerty.com"


# Install pbzip2 to accelerate tar compression
RUN dnf install -y pbzip2

# Cleanup the downloaded packages:
RUN dnf clean all

# PEEK-1135 Install RUST for pip wheel --no-binary=:all: cryptography
RUN #yum install -y curl
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

