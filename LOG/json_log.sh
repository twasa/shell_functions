__timestamp(){
    date +'%Y/%m/%d %H:%M:%S'
}

__json_formatter(){
    local log_level="${1:-NULL}"
    local log_message="${2:-NO MESSAGE DEFINED}"
    echo '{}' | jq \
        --arg timestamp "$(__timestamp)" \
        --arg log_level "${log_level}" \
        --arg message "${log_message}" \
        '.timestamp=$timestamp|.log_level=$log_level|.message=$message'
}

json_logger() {
    local log_level="${1:-NULL}"
    local log_message="${2:-NO MESSAGE DEFINED}"
    local color_reset='\033[0m'
    local color_red='\033[91m';
    local color_blue='\033[96m';
    local color_white='\033[97m';
    local color_green='\033[92m';
    local color_yellow='\033[93m';
    case $1 in
        INFO)
            color_code="${color_blue}"
            ;;
        WARN)
            color_code="${color_yellow}"
            ;;
        ERROR)
            color_code="${color_red}"
            ;;
        PASS)
            color_code="${color_green}"
            ;;
        *)
            color_code="${color_white}"
            ;;
    esac
    json_log=$(__json_formatter ${log_level} ${log_message})
    log="${color_code}${json_log}${color_reset}"
    echo -e "$log"
}