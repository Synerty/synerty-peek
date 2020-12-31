FROM peek-linux:v3.0.x
ENV RELEASE_BRANCH="v3.0.x"

WORKDIR /root

# Download and install the pinned packages for this release
#
RUN wget "https://gitlab.synerty.com/peek/synerty-peek/-/raw/${RELEASE_BRANCH}/gitlab/${RELEASE_BRANCH}/linux/pinned-deps-py"
RUN pip install -r pinned-deps-py

# Install the unit test report converters
RUN pip install subunitreporter junitxml ddt
