LAST_VERSION=master
RELEASE_VERSION="${1:?You must pass a release branch of format v#.#.x, eg v3.1.x as the only argument}"
PEEK_SERVER=peek@devops-peek-master

# Duplicate the last release folder
cd /Users/peek/dev-peek/synerty-peek/gitlab/${LAST_VERSION} || exit
cp -a ./ ../${RELEASE_VERSION}
echo "Version ${RELEASE_VERSION} Duplicated from: ${LAST_VERSION}"
SYSTEMS=("centos" "debian" "macos")

# Update all versions to be the new release version

for OS in "${SYSTEMS[@]}"
do
    cd /Users/peek/dev-peek/synerty-peek/gitlab/${RELEASE_VERSION}/${OS} || exit
    for filename in ./*
    do
        echo ${filename}
        sed -i "s/${LAST_VERSION}/${RELEASE_VERSION}/g" ${filename}
        mv "$filename" "$(echo $filename | sed "s/${LAST_VERSION}/${RELEASE_VERSION}/")"
    done
done
echo "Dockerfiles for ${RELEASE_VERSION} forked and  from: ${LAST_VERSION}"

# Update the release branch variable for the GitLab CI pipeline
cd /Users/peek/dev-peek/synerty-peek || exit
sed -i "s/RELEASE_BRANCH: \(.*\)/RELEASE_BRANCH: ${RELEASE_VERSION}/g" .gitlab-release-branch.yml
echo "Release branch updated"

# Connect to a peek server and copy the Python depedency list
for OS in "${SYSTEMS[@]}"
do
    cd /Users/peek/dev-peek/synerty-peek/gitlab/${RELEASE_VERSION}/${OS} || exit
    ssh ${PEEK_SERVER} 'pip freeze | grep -v peek' >pinned-deps-py
done
echo "Dependencies copied from ${PEEK_SERVER}"

# Build the Docker images and upload them to Nexus
./build_docker_containers.sh
echo "Docker containers built"

# Commit and push the changes to the new release branch
git checkout ${RELEASE_VERSION}
git add .
git commit -m "Branched Version ${RELEASE_VERSION}"
git push
echo "Peek ${RELEASE_VERSION} pushed."

echo "DONE!"
