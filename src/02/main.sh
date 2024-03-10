#!/bin/bash


../01/check_free_space.sh
if [[ `echo $?` > 0 ]]; then
    echo "Free space is less 1Gb"
    exit 1
fi


./check_input.sh $1 $2 $3
if [[ `echo $?` > 0 ]]; then
    exit 1
fi

START_TIME=$(date +%s)
START_TIME_2=$(date +"%H:%M:%S")

sudo ls -R / 2> /dev/null | grep -e '^\/' | sed s/[\:]//g | grep -v -E '/s?bin/?$?' >> all_direct.txt
all_numbers_of_direct=`wc -l all_direct.txt | awk '{print $1}'`
IFS='.' read -ra file_name_buf <<< "$2"

number_dir_target_history=()



while true; do

    ../01/check_free_space.sh
    if [[ `echo $?` > 0 ]]; then
        break
    fi

    number_dir_target=$(shuf -i 1-$all_numbers_of_direct -n1) # случайный выбор номера директории для засорения
    new_folder_count=$(shuf -i 1-100 -n1) # случайный выбор количества создаваемых папок
    check_uniq_dir_target_code=0
    for z in "${number_dir_target_history[@]}"; do
        if [[ "$number_dir_target" == "$z" ]]; then
            check_uniqcheck_uniq_dir_target_code_dir_code=1
            break
        fi
    done

    if (( $check_uniq_dir_target_code==1 )); then
        continue
    fi
    number_dir_target_history+=( $number_dir_target )
    
    dir_name_history=()

    # создание новых папок
    for (( i=1;i<$new_folder_count;i++ )); do

        ../01/check_free_space.sh
        if [[ `echo $?` > 0 ]]; then
            break
        fi

        stop_create=0
        new_folder_name=$( ../01/name_gen.sh $1 1 ) # генерация имени папки
        check_uniq_dir_code=0
    
        for y in "${dir_name_history[@]}"
        do
            if [[ "$new_folder_name" == "$y" ]]; then
                check_uniq_dir_code=1
                break
            fi
        done

        if (( $check_uniq_dir_code==1 )); then
            let i--
        else
            dir_name_history+=( $new_folder_name )
            dir_target=`cat all_direct.txt | head -n$number_dir_target | tail -n1` # получение адреса директории для засорения
            new_folder_dir="$dir_target/$new_folder_name" # директория новой папки
            sudo mkdir $new_folder_dir 2>/dev/null

            if ! [ -d $new_folder_dir ]; then # проверка создания директории
                continue
            fi

            echo $new_folder_dir $(date +"%d.%m.%Y %H:%M:%S") >> new_files02.log
        
        # создание новых файлов
            new_file_count=$(shuf -i 1-500 -n1) # генерация количества новых файлов
            file_name_history=()
            y=0
            while true; do

                ../01/check_free_space.sh
                if [[ `echo $?` > 0 ]]; then
                    break
                fi

                if (( $y == $new_file_count )); then
                    let stop_create++
                    break
                fi
                let y++
                file_name=$( ../01/name_gen.sh ${file_name_buf[0]} 1 )
                file_extansion=$( ../01/name_gen.sh ${file_name_buf[1]} )
                file_full_name="$file_name.$file_extansion"
            
                check_uniq_file_code=0 # проверка файла на уникальность
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
                    file_size=$( echo $3 | tr [:lower:] [:upper:] )
                    sudo fallocate -l $file_size ${new_folder_dir}/$file_full_name
                    echo ${new_folder_dir}/$file_full_name $(date +"%d.%m.%Y %H:%M:%S") $file_size >> new_files02.log
                fi        
            done
        fi
        if (( $stop_create > 0 )); then
            break
        fi
    done
done

echo "Free space is less 1Gb"
rm -rf all_direct.txt


END_TIME=$(date +%s)
END_TIME_2=$(date +"%H:%M:%S")
difference=$(( $END_TIME - $START_TIME ))
echo "Start time: $START_TIME_2"
echo "Start time: $START_TIME_2" >> new_files02.log
echo "End time: $END_TIME_2"
echo "End time: $END_TIME_2" >> new_files02.log
echo "Lead time: $difference seconds"
echo "Lead time: $difference seconds" >> new_files02.log