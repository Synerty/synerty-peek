FROM peek-centos:master
ENV RELEASE_BRANCH="master"

WORKDIR /root

# Download and install the pinned packages for this release
#
RUN wget "https://gitlab.synerty.com/peek/synerty-peek/-/raw/${RELEASE_BRANCH}/gitlab/${RELEASE_BRANCH}/requirements/release_pinned_peek_requirements.txt"
RUN pip install -r release_pinned_peek_requirements.txt

# Install the unit test report converters
RUN pip install subunitreporter junitxml ddt
