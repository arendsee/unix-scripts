usage (){
cat << EOF
Do things with pdfs
  -x N N IN OUT  extract pages from a pdf
  -j             join many pdfs together
  -i             join many images together
Examples
  pdf.sh -x 5 7 in.pdf out.pdf 
  pdf.sh -j in1.pdf in2.pdf 
  pdf.sh -i *.jpg out.pdf
EOF
    exit 0
}

# print help with no arguments
[[ $# -eq 0 ]] && usage

p_extract (){
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

p_join (){
    pdfjoin $@
}

err (){
    echo $1
    exit 1
}

x=0 j=0 i=0
while getopts "hxji" opt; do
    case $opt in
        h)
            usage ;;
        x) 
            x=1
            shift ;;
        j)
            j=1
            shift ;;
        i)
            i=1
            shift ;;
        ?)
            err "Unrecognized argument"
            ;;
    esac 
done

if [[ $x -eq 1 ]]
then
    [[ -r $3 ]] || err "Cannot read input file $3"
    p_extract $1 $2 $3 $4
elif [[ $j -eq 1 ]]
then
    p_join $@
elif [[ $i -eq 1 ]]
then
    convert $@
fi
