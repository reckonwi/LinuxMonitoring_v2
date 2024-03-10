#!/bin/bash

free_space=`df -k / | awk '{print $4}' | grep [0-9]`
let "free_space=$free_space/1048576"
if (( $free_space<1 )); then
    exit 1
fi