function kv2_read {
    param(
        $KV_NAME,
        $KV_PATH
    )
    $VAULT_ADDR = "https://vault.v16cp.me"
    $VAULT_TOKEN = ([System.Environment]::GetEnvironmentVariable('VAULT_TOKEN'))
    $kv2_key_path = "/v1/$KV_NAME/data$KV_PATH"
    $kv2_api_header = @{
        'Content-Type'  = 'application/json'
        'X-Vault-Token' = $VAULT_TOKEN
    }
    $kv2_uri = "${VAULT_ADDR}${kv2_key_path}"
    try {
        $result = Invoke-WebRequest -UseBasicParsing -Method 'GET' -Headers $kv2_api_header -MaximumRedirection 0 -Uri $kv2_uri
        if ($result.StatusCode -eq 200) {
            $json_data = $result.Content | Convertfrom-Json
            $data = $json_data.data.data.config_content
            return $data
        }
        else {
            throw "KV2 read error, uri: $kv2_uri, status_code: $result.StatusCode"
        }
    }
    catch {
        throw "$_.Exception, uri: $kv2_uri"
    }
}