#!/bin/bash
# USAGE: auto.bash SIZE DICT
# Will print out one puzzle, or fail

SIZE=$1
DICT=$2
ACROSS=$(perl -MList::Util -e "print List::Util::shuffle <>" $DICT | head -n ${SIZE})
DOWN=$(./findanagram.pl -q $ACROSS < $DICT) || (echo "No anagram exists" && exit 8)
BOARD=$(yes . | head -n 400)
TMPFILE=`mktemp /tmp/tmpanasquare.XXXXXX` || exit 9

echo $ACROSS $DOWN $BOARD | ./compose_easy $SIZE 2>/dev/null > $TMPFILE
RESULT=$?

while ((RESULT==1))
do
  BOARD=$(
    tail -n 4 $TMPFILE |·
    perl -e '@a=grep/[a-z]/,(split//,<>);@b=grep/[a-z]/,(split//,<>);@d=map{$a[$_] ne $b[$_]?$_:()}(0..$#a);$c="."x(@a+0);substr($c,$d[0],1)=$a[$d[0]];print $c;'
  )
  echo $ACROSS $DOWN $BOARD | ./compose_easy $SIZE 2>/dev/null > $TMPFILE
  RESULT=$?
done

((RESULT==0)) && echo $(cat $TMPFILE)
((RESULT==255)) && echo "No puzzle solution exists"
rm $TMPFILE
exit $RESULT
