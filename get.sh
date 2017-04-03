usage (){
cat << EOF
Download stuff with wget

-s URL copy a single webpage
EOF
    exit 0
}

# print help with no arguments
[[ $# -eq 0 ]] && usage


retrieve-single-page (){
    # -E corrects the extension, so I get a *.html output
    wget -E $1
}


while getopts "hs:" opt; do
    case $opt in
        h)
            usage ;;
        s) 
            retrieve-single-page $OPTARG ;;
    esac 
done
