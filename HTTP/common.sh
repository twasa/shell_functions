#!/bin/bash

# Function: Print a help message.
function usage(){
  echo "Usage: requests [ -m GET|PATCH|POST|DELETE ] -u URL [ -h HEADERS ]" 1>&2 
}

# Function: Exit with error.
function exit_abnormal(){
  usage
  exit 1
}

function request {
    local METHOD
    local URL
    local HEADERS
    local OPTIND
    local DATA
    local tempfile=$(mktemp)
    while getopts ":m:u:h:d:" opts; do
        case "${opts}" in
            m)
                METHOD=$(echo ${OPTARG} | tr '[:lower:]' '[:upper:]')
                if [[ ! $METHOD =~ ^('GET'|'POST'|'PATCH'|'DELETE')$ ]]; then
                    exit_abnormal
                fi
                ;;
            u)
                URL=$OPTARG
                ;;
            h)
                HEADERS=$OPTARG
                ;;
            d)
                DATA=$OPTARG
                ;;
            :) # If expected argument omitted:
                echo "Error: -$OPTARG requires an argument."
                exit_abnormal
                ;;
        esac
    done
    shift $((OPTIND-1))
    # set defaults if command not supplied
    if [ -z "$URL" ] ; then exit_abnormal ; fi
    if [ -z "$METHOD" ] ; then METHOD='GET' ; fi
    response=$(curl --silent --write-out '%{json}' -L -X ${METHOD} -H ${HEADERS} -o $tempfile $URL)
    echo "{\"meta\":${response}, \"data\":\"${tempfile}\"}"
}
