#!/bin/bash
src=last_tuples
dest=../submitted/experiments
mkdir -p $dest

cp -a $src/var*.eps $dest
cp -a $src/*correlation*.eps $dest
cp -a $src/lstraight_res*.eps $dest
cp -a $src/*.tex $dest

for a in $dest/*.eps; do
	echo "epstopdf $a"
	epstopdf $a;
done
