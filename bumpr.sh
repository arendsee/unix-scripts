#!/usr/bin/env bash

usage (){
cat << EOF
Bump the version within an R package

If you are in a dev branch, given version x.y.z.dev, dev is bumped.

If you are on master y, or z is bumped, depending on whether you specify
'major' or 'minor'.

Examples:

master-$ bumpr.sh major
0.1.2 -> 0.2.0

master-$ bumpr.sh minor
0.1.2 -> 0.1.3

dev-$ bumpr.sh dev
0.1.2.9000 -> 0.1.2.9001

dev-$ bumpr.sh dev
0.1.2 -> 0.1.2.9000
EOF
    exit 0
}

# print help with no arguments
[[ $# -eq 0 ]] && usage

while getopts "h" opt; do
    case $opt in
        h)
            usage ;;
    esac 
done

level=$1

if [[ ! -r DESCRIPTION ]]
then
    echo "No DESCRIPTION file found"
    exit 1
fi

git reset DESCRIPTION
git diff DESCRIPTION | grep -P '^Version: ' > /dev/null
if [[ $? -eq 0 ]]
then
    echo "Version has been modified, cannot bump" 
    exit 1
fi

grep -P '^Version: \d+\.\d+\.\d+\.?\d*$' DESCRIPTION > /dev/null
if [[ $? -ne 0 ]]
then
    echo "DESCRIPTION does not contain a valid version"
    exit 1
fi

version=$(sed -nr 's/^Version: ([0-9]+\.[0-9]+\.[0-9]+\.?[0-9]*)$/\1/p' DESCRIPTION)

git status | grep -P '^On branch dev$' > /dev/null
if [[ $? -eq 0 ]]
then
    # we are on the dev branch
    grep -P '^Version: \d+\.\d+\.\d+\.9\d{3}$' DESCRIPTION
    if [[ $? -eq 0 ]]
    then
        # the development version already exists, we need to increment it
    else
        # no development version exists, we need to make one
        perl -pe 's/^(Version: \d+\.\d+\.\d+)/\1.9000/' DESCRIPTION > NEW_DESCRIPTION
    fi
else
    # we are on master
fi
