#!/bin/bash/

LOGFILES=$(find ../04/ -name "*.log")
LOG_FORMAT="--log-format=COMBINED"

goaccess -o report.html $LOGFILES  $LOG_FORMAT --4xx-to-unique-count --ignore-panel=OS --ignore-panel=REFERRERS --ignore-panel=REFERRING_SITES