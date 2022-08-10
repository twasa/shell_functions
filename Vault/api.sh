source ${SHARE_LIB_PATH}/HTTP/common.sh
source ${SHARE_LIB_PATH}/LOG/json_log.sh

function kv2_read(){
    local kv2_api_path="/v1/${KV_NAME}/data${KV_PATH}"
    local kv2_api_header="X-Vault-Token: ${VAULT_TOKEN}"
    local kv2_uri="${VAULT_ADDR}${kv2_api_path}"
    results=$(request -m get -h ${kv2_api_header} -u "${kv2_uri}")
    response_code=$(echo $results | jq -r '.meta.http_code')
    content_type=$(echo $results | jq -r '.meta.content_type')
    data=$(echo $results | jq -r '.data')
    if [[ "${response_code}" == '200' ]] && [[ "${content_type}" == 'application/json' ]]; then
        cat $data | jq -r '.data.data.config_content'
    else
        echo $results
        error_message=$(echo $results | jq -r '.meta.errormsg')
        request_url=$(echo $results | jq -r '.meta.url')
        json_logger 'ERROR' "${response_code} ${request_url} ${error_message}"
        return 1
    fi
}