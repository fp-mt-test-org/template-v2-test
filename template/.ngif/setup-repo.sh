#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo
echo "Determining if the template has been initialized..."
echo
template_branch_name='template'
git_branches=$(git branch)
default_branch="${default_branch:=unspecified}"

echo "Checking if ${template_branch_name} exists..."
echo

if ! [[ "${git_branches}" =~ ${template_branch_name} ]]; then
    echo "${template_branch_name} branch doesn't exist."
    checkout_output=$(git checkout ${template_branch_name} 2>&1 || true)
    error_pattern="error: pathspec '${template_branch_name}' did not match any file(s) known to git"

    if [[ ${checkout_output} =~ ${error_pattern} ]]; then
        echo "Template needs to be initialized, initializing..."
        ./.ngif/initialize-template.sh
    else
        echo "${template_branch_name} branch exists, switching to it."
        git checkout "${default_branch}"
    fi
else
    echo "Template has been previously initialized."
fi
