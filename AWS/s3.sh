#!/usr/bin/env bash

source ${SHARE_LIB_PATH}/LOG/logger.sh

function deploy_to_s3() {
    local source_path=$1
    local dest_path=$2
    json_logger 'INFO' "Uploading to S3://${BUCKET_NAME} ..."
    aws s3 sync "${source_path}" s3://${BUCKET_NAME}${dest_path} \
        --exclude ".git*" \
        --exclude "*.md" \
        --exclude "functions/*" \
        --delete \
        --only-show-errors
}

function list_bucket_content() {
    logger INFO "-------------- ${CI_PROJECT_NAME} Download URL --------------"
    for OBJECT in $(aws s3api list-objects --bucket ${BUCKET_NAME} --output text | grep ${CI_PROJECT_NAME} | awk '{print $3}'); do
        echo -e "${DOMAIN_NAME}/${OBJECT}"
    done
    logger INFO "-------------- ${CI_PROJECT_NAME} Download URL --------------"
}
