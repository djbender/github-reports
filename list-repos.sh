#!/usr/bin/env bash

set -eu -o pipefail

username=$1
org=$2

url () {
  echo "https://api.github.com/orgs/${org}/repos?sort=created&per_page=100"
}

auth_arg () {
  echo "-u ${username}:${GITHUB_TOKEN}"
}

get () {
  curl -s "$(auth_arg)" "$1"
}

get_link_header () {
  curl -s -I "$(auth_arg)" "$1" | grep "^link:"
}

parse_output () {
  echo "$1" | jq --raw-output '.[] | .name ' >> output.txt
}

next_regex="s/.*<\(.*\)>; rel=\"next\",.*/\1/"
last_regex="s/.*, <\(.*\)>; *rel=\"last\".*/\1/"

next=$(get_link_header "$(url)" | sed "$next_regex")
last=$(get_link_header "$(url)" | sed "$last_regex")

url
parse_output "$(get "$(url)")"

until [ "$next" = "$last" ]
  parse_output "$(get "$next")"
  echo "$next"
  next=$(get_link_header "$next" | sed "$next_regex")
do true; done
