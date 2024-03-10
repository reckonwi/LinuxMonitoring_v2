#!/bin/bash

echo "Enter start time (in format \"YYYY-MM-DD HH:MM\"):"
read start_date start_time
if [[ ! $start_date =~ ^([0-9]{4})-((0[1-9])||(1[0-2]))-((0[1-9])||([1-2][0-9])||(3[0-1]))$ ]]; then
  echo "ERROR: Invalid format of date" >&2; exit 1
fi
if [[ ! $start_time =~ ^(([0-1][0-9])||(2[0-3])):([0-5][0-9])$ ]]; then
  echo "ERROR: Invalid format of time" >&2; exit 1
fi
echo "Enter end time (in format \"YYYY-MM-DD HH:MM\"):"
read end_date end_time
if [[ ! $end_date =~ ^([0-9]{4})-((0[1-9])||(1[0-2]))-((0[1-9])||([1-2][0-9])||(3[0-1]))$ ]]; then
  echo "ERROR: Invalid format of date" >&2; exit 1
fi
if [[ ! $end_time =~ ^(([0-1][0-9])||(2[0-3])):([0-5][0-9])$ ]]; then
  echo "ERROR: Invalid format of time" >&2; exit 1
fi
start_date_time=$(echo $start_date $start_time)
end_date_time=$(echo $end_date $end_time)
MODIFIED_FILES=($(sudo find / -uid $UID -newermt "$start_date_time" ! -newermt "$end_date_time"))
fool_protect=0 # защита удаления. 0 - проверка лога, 1 - удаление всего
  for file in ${MODIFIED_FILES[@]}
  do
    if (( $fool_protect==0 )); then
      while IFS= read -r line
      do
          dir=`echo "$line" | awk '{print $1}'`
          if [[ $file == $dir ]]; then
              rm -rf $file
          fi
      done < ../new_files.log
    else
      sudo rm -rf $file
    fi
  done

