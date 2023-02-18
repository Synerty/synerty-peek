FROM peek-centos:v3.4.x
ENV RELEASE_BRANCH="v3.4.x"

WORKDIR /root

RUN yum install -y epel-release

# -----------------------------------------------------------------------------
# Install the CI dependencies for the builds

# Install pbzip2 to accelerate tar compression
RUN yum install -y jq

RUN git config --global user.name "GitLab CI"
RUN git config --global user.email "gitlab-ci@synerty.com"


# Install pbzip2 to accelerate tar compression
RUN yum install -y pbzip2

# PEEK-1135 Install RUST for pip wheel --no-binary=:all: cryptography
RUN yum install -y curl
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

