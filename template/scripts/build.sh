#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

jfrog='jfrog-cli'

echo 
echo "Installing ${jfrog}..."
brew install "${jfrog}"
echo "${jfrog} installation complete."
echo
jfrog c show
echo
echo "Configuring ${jfrog}..."
jfrog c add artifactory \
    --url="${artifactory_base_url}" \
    --user="${artifactory_username}" \
    --access-token="${artifactory_password}" \
    --artifactory-url="${artifactory_base_url}/artifactory" \
    --interactive=false
echo "${jfrog} configured."
echo
echo "Building with ${jfrog}..."
jfrog rt \
    gradle clean \
    artifactoryPublish -b build.gradle \
    --build-name={{cookiecutter.component_id}} \
    --build-number=1 \
    -Pversion=1.1.0
echo "Build complete."
echo
