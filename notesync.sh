#!/bin/bash
# script to push my notes to my gh repo
base="$HOME/Documents/MSc"
dest="$HOME/Documents/MSc/msc-notes"

declare -A notes

hname="PC"

notes["$base/FORSYTE/forsyte.pdf"]="FORSYTE/forsyte.pdf"
notes["$base/FORSYTE/forsyte.tex"]="FORSYTE/forsyte.tex"

# notes["$base/LoCo/LoCo.pdf"]="LOCO/LoCo.pdf"
# notes["$base/LoCo/LoCo.tex"]="LOCO/LoCo.tex"
#
# notes["$base/LoCo/cav.tex"]="CAV/CAV.tex"
# notes["$base/LoCo/cav.pdf"]="CAV/CAV.pdf"

for file in "${!notes[@]}"; do
    cp "$file" "$dest/${notes[$file]}" || { echo "$file failed"; exit 1; }
done

echo "updating notes repo"

cd "$dest" && git pull

if [ $? -eq 0 ] && [[ $(git status --porcelain) ]]; then

    # while read -r reads line by line from stdin and stores in 'f'
    # basename strips
    # paste -sd ',' - pastes lines with ',' delimiter
    # (just having fun w/bash)
    #pdf_list=$(git diff --name-only -- '*.pdf' | while read -r f; do
    #    basename "$f" .pdf
    #done | paste -sd '/' -)

    pdf_list=$(git -c core.quotepath=false diff --name-only -- '*.pdf' | while read -r f; do
    basename "$f" .pdf
done | paste -sd '/' -)

git add . && git commit -m "sync $(date +'%d-%m'): $pdf_list [$hname]" && git push
else
    echo "no changes in the notes!"
fi

echo "updating latex repo"

cd "$latex" && git pull

if [ $? -eq 0 ] && [[ $(git status --porcelain) ]]; then
    git add . && git commit -m "sync: $(date +'%d-%m'), $hname, $pdf_list" && git push
else
    echo "no changes in the .tex files!"
fi


