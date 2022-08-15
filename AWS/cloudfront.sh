#!/usr/bin/env bash

source ${SHARE_LIB_PATH}/LOG/logger.sh

function get_distribution_id() {
    local origin_domain=$1
    distribution_id=$(aws cloudfront list-distributions | jq -r ".DistributionList.Items[] | select(.Comment==\"${origin_domain}\") | .Id")
    if [[ $? == 0 ]]; then
        echo $distribution_id
        return 0
    fi
    return 1
}

function purge_cdn_cache() {
    local origin_domain="${1}"
    local paths="${2:-/}"
    local distribution_id
    logger "INFO" "purge cloudfront cache for ${origin_domain} with paths: ${paths}"
    distribution_id=$(get_distribution_id ${origin_domain})
    if [[ -z $distribution_id ]]; then
        logger "ERROR" "AWS cloudfront distributions id not exist with domain: ${origin_domain}"
        exit 1
    fi
    logger INFO "distribution id: ${distribution_id}"
    invalidation_result=$(aws cloudfront create-invalidation --output json --distribution-id ${distribution_id} --paths "${paths}")
    if [[ "$?" == 0 ]]; then
        echo $invalidation_result
        logger "INFO" "Invalidated CloudFront cache"
    else
        logger "ERROR" "Failed to invalidate CloudFront cache ,Please contact DevOps team"
        exit 1
    fi
}
