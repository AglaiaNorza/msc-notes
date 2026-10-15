#!/bin/bash
# script to push my notes to my gh repo
base="$HOME/Documents/MSc"
dest="$HOME/Documents/MSc/msc-notes"

declare -A notes

hname="PC"

notes["$base/FORSYTE/forsyte.pdf"]="FORSYTE/forsyte.pdf"
notes["$base/FORSYTE/forsyte.tex"]="FORSYTE/forsyte.tex"

notes["$base/CAV/cav.tex"]="CAV/CAV.tex"
notes["$base/CAV/cav.pdf"]="CAV/CAV.pdf"

# notes["$base/LoCo/LoCo.pdf"]="LOCO/LoCo.pdf"
# notes["$base/LoCo/LoCo.tex"]="LOCO/LoCo.tex"
#


for file in "${!notes[@]}"; do
    cp "$file" "$dest/${notes[$file]}" || { echo "$file failed"; exit 1; }
done

echo "updating notes repo"

cd "$dest" && git pull

git add .

if ! git diff --cached --quiet; then
    changed=$(git diff --cached --name-only | while read -r f; do
        basename "$f" | sed 's/\.[^.]*$//'
    done | sort -u | paste -sd '/' -)

    git commit -m "sync $(date +'%d-%m'): $changed [$hname]"
    git push
else
    echo "no changes in the notes!"
fi
