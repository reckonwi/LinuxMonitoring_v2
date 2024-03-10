#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "ERROR: Invalid number of parameters (must be 1)" >&2; exit 1
fi
if [[ ! "$1" =~ ^[123]$ ]]; then
  echo "ERROR: Parapetr must consist of 1, 2 or 3" >&2; exit 1
fi

case $1 in
1)
  bash delete_by_log.sh
  ;;
2)
  bash delete_by_date.sh
  ;;
3)
  bash delete_by_mask.sh
  ;;
esac