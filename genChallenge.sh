#!bin/bash
if [ "$#" -ne 3 ]; then
	echo "Usage: $0 \"challenge name\" urlnumber points"
	exit
fi
NAME=$(echo "$1" | tr ' ' '_' | tr '[:upper:]' '[:lower:]' | tr -d '?') 
SUBDIR=challenges/$NAME
mkdir "$SUBDIR"
echo "# [$1](https://ctflearn.com/challenge/$2) ($3)" | tee "$SUBDIR/challenge.md" "$SUBDIR/solution.md" > /dev/null 2>&1
