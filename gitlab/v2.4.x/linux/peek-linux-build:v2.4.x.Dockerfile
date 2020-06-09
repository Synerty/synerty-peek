FROM peek-linux:v2.4.x
ENV RELEASE_BRANCH="v2.4.x"

WORKDIR /root

# -----------------------------------------------------------------------------
# Download and install the pinned packages for this release

RUN wget "https://gitlab.synerty.com/peek/synerty-peek/-/raw/gitlab/${RELEASE_BRANCH}/linux/pinned-deps-py"
RUN pip install -r pinned-deps-py

# -----------------------------------------------------------------------------
# Install the CI dependencies for the builds

RUN apt install -y jq git curl

RUN git config --global user.name "GitLab CI"
RUN git config --global user.email "gitlab-ci@synerty.com"
