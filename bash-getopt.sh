#!/usr/bin/env bash

set -o errexit -o pipefail

declare -A args

argv=$(getopt --unquoted --options 'abc:' --longoptions longa,longb,longc: -- "$@")

# the first of $argv may start with - or + thus
# the -- here prevents set from taking that as
# its option
set -- $argv

while true; do
    case $1 in
        -a|--longa) args[a]=true; shift ;;
        -b|--longb) args[b]=true; shift ;;
        -c|--longc) args[c]=$2; shift 2 ;;
        --) shift; break ;;
        *) echo "unknown argument: $1"; exit 1 ;;
    esac
done

echo -n "options: "
for x in a b c; do
    if [ "${args[$x]}" ]; then
        echo -n "$x=${args[$x]} "
    fi
done
echo

echo "non-option arguments: $@"
