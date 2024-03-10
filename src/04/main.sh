#!/bin/bash

source func.sh

DAYS=5
TOTAL_SECONDS=86399
TIMEZONE=$(date +%z)
RESPONSE_CODE=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
METHOD_BUF=("GET" "POST" "PUT" "PATCH" "DELETE")
DATE=($(date_generate $DAYS))
USER_AGENT_BUF=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
DOMAIN_BUF=("drom.ru" "ozon.ru" "21-school.ru" "yandex.ru" "aviasales.ru" "gismeteo.ru")
PAGE_BUF=("/home" "/main" "/search" "/contacts" "/lk/entry" "/news" "/lk/basket")

for (( i=0;i<$DAYS;i++ )); do
    TIME=0
    LOG_NAME=("nginx_$(awk -F'/' '{printf("%d_%s_%d", $1, $2, $3)}' <<< ${DATE[i]}).log")
    touch $LOG_NAME
    LOG_LINE_NUMBER=$(shuf -i 100-1000 -n1)
    TIME_INTERVAL=$(($TOTAL_SECONDS/$LOG_LINE_NUMBER))
    for (( j=0;j<$LOG_LINE_NUMBER;j++ )); do
        IP_ADRESS=$(ip_generate)
        METHOD_INDEX=$(shuf -i 0-$((${#METHOD_BUF[@]} - 1)) -n 1)
        DOMAIN_INDEX=$(shuf -i 0-$((${#DOMAIN_BUF[@]} - 1)) -n 1)
        PAGE_INDEX=$(shuf -i 0-$((${#PAGE_BUF[@]} - 1)) -n 1)
        RESPONSE_INDEX=$(shuf -i 0-$((${#RESPONSE_CODE[@]} - 1)) -n 1)
        USER_AGENT_INDEX=$(shuf -i 0-$((${#USER_AGENT_BUF[@]} - 1)) -n 1)
        BYTES_SEND=$(shuf -i 100-10000 -n 1)
        ADRESS=(https://${DOMAIN_BUF[$DOMAIN_INDEX]}${PAGE_BUF[PAGE_INDEX]})
        echo "$(ip_generate) - - [${DATE[i]}:$(convert_time $TIME) $TIMEZONE] \"${METHOD_BUF[$METHOD_INDEX]} $ADRESS HTTP/2\" ${RESPONSE_CODE[$RESPONSE_INDEX]} $BYTES_SEND \"-\" \"${USER_AGENT_BUF[$USER_AGENT_INDEX]}\"" >> $LOG_NAME
        TIME=$((TIME+TIME_INTERVAL))
    done
done

# МЕТОДЫ
# GET - Используется для запроса содержимого указанного ресурса.
# POST - Применяется для передачи пользовательских данных заданному ресурсу.
# PUT - Применяется для загрузки содержимого запроса на указанный в запросе URI
# PATCH - Аналогично PUT, но применяется только к фрагменту ресурса.
# DELETE - Удаляет указанный ресурс.