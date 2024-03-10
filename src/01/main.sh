#!/bin/bash

# добавить в проверку на уникальность макс количество итераций, чтобы не впал в бесконечный цикл
./check_input.sh $1 $2 $3 $4 $5 $6

if [[ `echo $?` > 0 ]]; then
    exit 1
fi

dir_name_history=()

for((i=0;i<$2;i++))
do
    file_name_history=()
    dir_name=$( ./name_gen.sh $3 1 )
    check_uniq_dir_code=0
    
    for y in "${dir_name_history[@]}"
    do
        if [[ "$dir_name" == "$y" ]]; then
            check_uniq_dir_code=1
            break
        fi
    done

    if (( $check_uniq_dir_code==1 )); then
        let i--
    else
        dir_name_history+=( $dir_name )
        mkdir $1${dir_name}
        echo $1${dir_name} $(date +"%d.%m.%Y %H:%M:%S") >> new_files.log

        IFS='.' read -ra file_name_buf <<< "$5"

        for((j=0;j<$4;j++))
        do
            ./check_free_space.sh # проверка свободного места на диске
            if [[ `echo $?` > 0 ]]; then
                echo "Free space is less 1Gb"
                exit 1
            fi
            file_name=$( ./name_gen.sh ${file_name_buf[0]} 1 )
            file_extansion=$( ./name_gen.sh ${file_name_buf[1]} )
            file_full_name="$file_name.$file_extansion"
            check_uniq_file_code=0
            for x in "${file_name_history[@]}"
            do
                if [[ "$file_full_name" == "$x" ]]; then
                    check_uniq_file_code=1
                    break
                fi
            done
            if (( $check_uniq_file_code==1 )); then
                let j--
            else
                file_name_history+=( $file_full_name )                
                file_size=$( echo $6 | tr [:lower:] [:upper:] )
                fallocate -l $file_size $1${dir_name}/$file_full_name
                echo $1${dir_name}/$file_full_name $(date +"%d.%m.%Y %H:%M:%S") $file_size >> new_files.log
            fi
        done
    fi
done
