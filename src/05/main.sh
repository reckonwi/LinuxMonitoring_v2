#!/bin/bash

source func.sh

if [ "$#" -ne 1 ]; then
	echo "ERROR: Invalid number of parameters" >&2; exit 1
fi
if [[ ! "$1" =~ ^[1234]$ ]]; then
  echo "ERROR: Invalid parametr" >&2; exit 1
fi

FUNCTIONS=("" "sort_by_response_code" "get_unique_ip" "get_error_responses" "unique_error_ip")

${FUNCTIONS[$1]} $(find ../04/ -name "*.log")
