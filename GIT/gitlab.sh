#!/usr/bin/env bash

function show_cicd_variables() {
    echo "Project Name: ${CI_PROJECT_NAME}"
    echo "CI/CD WORK DIR: ${CI_PROJECT_DIR}"
    echo "CI_COMMIT_REF_NAME: ${CI_COMMIT_REF_NAME}"
}
