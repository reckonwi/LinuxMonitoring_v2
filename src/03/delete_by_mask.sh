#!/bin/bash

echo "Type characters using for directories:"
read dir_char
echo "Type characters using for file names:"
read file_char
echo "Type characters using for file extension:"
read ext_char
echo "Type date of creation in format \"ddmmyy\""
read date_char
full_file_mask=$(echo $file_char"_"$date_char"."$ext_char)
full_dir_mask=$(echo $dir_char"_"$date_char)
find ../02/new_files02.log -name "*$full_file_mask*" -delete
find ../02/new_files02.log -path "*$full_dir_mask*" -delete