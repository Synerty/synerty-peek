FROM peek-linux:master
ENV RELEASE_BRANCH="master"

WORKDIR /root

# Download and install the pinned packages for this release
#
RUN wget "https://gitlab.synerty.com/peek/synerty-peek/-/raw/${RELEASE_BRANCH}/gitlab/${RELEASE_BRANCH}/linux/pinned-deps-py"
RUN pip install -r pinned-deps-py

