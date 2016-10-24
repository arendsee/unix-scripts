usage (){
cat << EOF
Do things with pdfs
  -x N N IN OUT  extract pages from a pdf
Examples
  pdf.sh -x 5 7 in.pdf out.pdf 
EOF
    exit 0
}

# print help with no arguments
[[ $# -eq 0 ]] && usage

extract (){
   gs                   \
      -sDEVICE=pdfwrite \
      -dNOPAUSE         \
      -dBATCH           \
      -dSAFER           \
      -dFirstPage=$1    \
      -dLastPage=$2     \
      -sOutputFile=$4   \
      $3
}

err (){
    echo $1
    exit 1
}

x=0
while getopts "hx" opt; do
    case $opt in
        h)
            usage ;;
        x) 
            x=1
            shift ;;
        ?)
            err "Unrecognized argument"
            ;;
    esac 
done

if [[ $x -eq 1 ]]
then
    [[ -r $3 ]] || err "Cannot read input file $3"
    extract $1 $2 $3 $4
fi
