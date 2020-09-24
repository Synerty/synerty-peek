FROM peek-linux:v2.5.x
ENV RELEASE_BRANCH="v2.5.x"

WORKDIR /root

# -----------------------------------------------------------------------------
# Install the CI dependencies for the builds

RUN apt install -y jq git curl

RUN git config --global user.name "GitLab CI"
RUN git config --global user.email "gitlab-ci@synerty.com"

