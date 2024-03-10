#!/bin/bash

# изменить название переменных - скрипт универсальный

dir_name_input_lenght=$(expr length "$1") # узнать количество введенных символов для имени папки

if [ -z "$2" ]; then
    dir_name_min_value=2
    dir_name_max_value=6
else
    dir_name_min_value=4
    dir_name_max_value=12
fi

if (( $dir_name_min_value<$dir_name_input_lenght )); then
    let dir_name_min_value=$dir_name_input_lenght
fi

dir_name_buf=()
dir_name_lenght=$(shuf -i $dir_name_min_value-$dir_name_max_value -n1) # генерация длины буквенной части имени папки
dir_name_buf_elem=0
dir_name_input_number=1

for item in $(echo -n $1 | sed 's/./&\n/g'); do 

    if(( $dir_name_input_number==$dir_name_input_lenght )); then # дозаполнение имени файла до нужного количества элементов
        let a=$dir_name_lenght-$dir_name_buf_elem
        for((x=0;x<a;x++))
        do
            dir_name_buf[$dir_name_buf_elem]=$item
            let dir_name_buf_elem++
        done
        break
    fi

    let quantity_use_max_value=$dir_name_lenght-$dir_name_buf_elem-$dir_name_input_lenght+$dir_name_input_number # максимально возможное количество использований данного символа
    quantity_use=$(shuf -i 1-$quantity_use_max_value -n1) # генерация количества использования данного символа
    for((x=0;x<quantity_use;x++))
    do
        dir_name_buf[$dir_name_buf_elem]=$item
        let dir_name_buf_elem++
    done
    let dir_name_input_number++
done

if [ ! -z "$2" ]; then
    date=$(date +"%d%m%y")
    dir_name_buf+=( "_"$date )
fi
output=$( echo ${dir_name_buf[@]} )
output=$( echo ${output//' '} )
echo $output