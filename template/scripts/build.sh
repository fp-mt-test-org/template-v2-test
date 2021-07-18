#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

brew install jfrog-cli

echo
echo "artifactory_base_url: ${artifactory_base_url}"
echo "artifactory_username: ${artifactory_username}"
echo "artifactory_password: ${artifactory_password}"
echo

jfrog c add artifactory \
    --url="${artifactory_base_url}" \
    --user="${artifactory_username}" \
    --apikey="${artifactory_password}" \
    --artifactory-url="${artifactory_base_url}/artifactory" \
    --interactive=false

jfrog rt \
    gradle clean \
    artifactoryPublish -b build.gradle \
    --build-name={{cookiecutter.component_id}} \
    --build-number=1 \
    -Pversion=1.1.0-SNAPSHOT
