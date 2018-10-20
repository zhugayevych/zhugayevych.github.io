#!/bin/bash
filename=$1
echo $1
nlines=`grep "NBANDS=" $filename | awk '{{print $NF + 2}}'`;
echo $nlines
sed -e "/ band No. /I,+${nlines}d" $filename
