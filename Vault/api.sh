#!/usr/bin/env bash

source ${SHARE_LIB_PATH}/HTTP/common.sh
source ${SHARE_LIB_PATH}/LOG/logger.sh

function kv2_read() {
    local response_code=''
    local results=''
    local content_type=''
    local kv2_key_path="/v1/${KV_NAME}/data${KV_PATH}"
    local kv2_api_header="X-Vault-Token: ${VAULT_TOKEN}"
    local kv2_uri="${VAULT_ADDR}${kv2_key_path}"
    results=$(request -m get -h ${kv2_api_header} -u "${kv2_uri}")
    if [[ "$?" != 0 ]]; then
        logger 'ERROR' "${results}"
        exit 1
    fi
    response_code=$(echo $results | jq -r '.meta.http_code')
    content_type=$(echo $results | jq -r '.meta.content_type')
    data=$(echo $results | jq -r '.data')
    if [[ "${response_code}" == '200' ]] && [[ "${content_type}" == 'application/json' ]]; then
        cat $data | jq -r '.data.data.config_content'
    else
        error_message=$(echo $results | jq -r '.meta.errormsg')
        request_url=$(echo $results | jq -r '.meta.url')
        logger 'ERROR' "code: ${response_code} url: ${request_url} message: ${error_message}"
        return 1
    fi
    rm -f $data
}
