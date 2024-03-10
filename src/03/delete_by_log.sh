#!/bin/bash

echo "Enter path to log file:"
read log_path
if [ ! -f $log_path ]; then
  echo "ERROR: can't open file "$log_path
  exit 1
fi
sudo rm -rf $(cat $log_path | awk '{print $1}')