#!/usr/bin/bash

usage (){
cat << EOF
Commands for looking at fonts in Arch linux
Portability: dubious
USAGE: show-fonts <COMMAND> [OPTIONS]
COMMANDS:
  names   list all font names
  files   list all font files
  style   list all styles
  all     TAB-delimited [file | name | style]
OPTIONAL ARGUMENTS
  -o LANG restrict output to this language (e.g. en)
EOF
    exit 0
}

# print help with no arguments
[[ $# -eq 0 ]] && usage

show-all-names () {
    fc-list $1 |
        sed -r 's/.*: (.*):.*/\1/' |
        sort |
        uniq -c
}

show-all-files () {
    fc-list $lang |
        sed -r 's/(.*):.*/\1/' |
        sort -u
}

show-all-styles () {
    fc-list $lang |
        sed -r 's/.*style=(.*)/\1/' |
        sort |
        uniq -c
}

show-all () {
    fc-list $lang |
        sed -r 's/(.*):(.*):style=(.*)/\1\t\2\t\3/' |
        sort -u
}

cmd=$1
shift

lang=""
while getopts "ho:" opt; do
    case $opt in
        h)
            usage ;;
        o)
            lang=":lang=$OPTARG" ;;
        ?)
            echo "Illegal argument"
            exit 1 ;;
    esac 
done


if   [[ $cmd =~ "names" ]]; then

    show-all-names $lang

elif [[ $cmd =~ "files" ]]; then

    show-all-files $lang

elif [[ $cmd =~ "styles" ]]; then

    show-all-styles $lang

elif [[ $cmd =~ "all" ]]; then

    show-all $lang

fi
