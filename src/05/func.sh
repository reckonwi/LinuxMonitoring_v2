#!/bin/bash

function get_unique_ip {
  awk '{print $1}' "$@" | sort -u
}

function get_error_responses {
  awk '{if ($9 >= 400 && $9 < 600) print $0}' "$@"
}

function unique_error_ip {
  awk '{if ($9 >= 400 && $9 < 600) print $1}' "$@" | sort -u
}

function sort_by_response_code {
  awk '{print $9 "\t" $0}' "$@" | sort | cut -f 2
}