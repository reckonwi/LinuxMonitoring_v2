#!/bin/bash

exit_code=0

if grep -oq [^A-Za-z] <<<"$1"; then
   echo "ERROR: Invalid letters used in folder names"
   exit_code=1
fi

if (("$(expr length "$1")" > 7)); then
    echo "ERROR: Invalid quantity of letters used in folder names"
    exit_code=1
fi

if grep -oq ".\.." <<<"$2"; then
    IFS='.' read -ra my_array <<< "$2"
    count=`echo ${#my_array[@]}`
    if [ $count -gt 2 ]; then
        echo "ERROR: Invalid entering characters"
        exit_code=1
    fi
    for i in "${my_array[@]}"
    do
        if [[ $i =~ [^A-Za-z] ]]; then
            echo "ERROR: Invalid entering characters"
            exit_code=1
        fi
    done
    if (("$(expr length "${my_array[0]}")" > 7 || "$(expr length "${my_array[1]}")" > 3)); then
        echo "ERROR: Invalid entering characters"
        exit_code=1
    fi
else
    echo "ERROR: Invalid entering characters"
    exit_code=1
fi

if [[ $3 =~ .Mb$ ]]; then
    IFS='M' read -ra my_array2 <<< "$3"
    file_size=`echo ${my_array2[0]}`
    if (( $file_size > 100 )); then
        echo "ERROR: File size is too big"
        exit_code=1
    fi
else
    echo "ERROR: Invalid file size"
    exit_code=1
fi

exit $exit_code