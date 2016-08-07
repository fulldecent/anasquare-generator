Anasquare Generator
===================

**What is an Anasquare puzzle?**

To solve this puzzle, first answer the Across and Down clues. Then anagram each
answer and enter the result into the grid in the correspondingly numbered row or
column, using the given letters as a guide.

![](https://i.imgur.com/rlfcrNM.png)

Across clues:

-   of great significance or value

-   of governing

-   preparation for life

-   three dots in logic

-   of grammatical arrangement

-   recall the past

-   diseases of widening arteries

-   of offending good taste

-   vibration at natural frequency

Down clues:

-   group convened to decide a matter

-   surely

-   jurisdiction over a subject

-   absolutely essential

-   institutions of business

-   institutions of statehood

-   involving capital

-   executive officer

-   worried

Getting the Words
=================

The word dictionary is NOT included in this repository, you will need to find or
make your own.

`    alias shuf=gshuf`

\>\> Pick X words you like, each having X letters, or choose randomly:

`    shuf Dictionary/6.txt | head -n6`

\>\> Find another set of words with these same letters:

`    ./findanagram.pl cereal waffle coffee muffin butter pepper <
Dictionary/6.txt`

Making the Puzzle
=================

\>\> Run the solver

`    ./compose 6`

\>\> If multiple solutions are found, add a letter to your puzzle to
disambiguate, then try again

`    echo -e "hello\nnasty" | perl -e
'$a=<>;$b=<>;$a=~s/[^a-z]//g;$b=~s/[^a-z]//g;$l=length($a);$c="."x$l;for($d=0;substr($a,$d,1)
eq substr($b,$d,1);$d++){};substr($c,$d,1)=substr($a,$d,1);print $c;'`

\>\> If unique solution is found you are done

 

\>\> Do cluing -- see http://www.cruciverb.com/index.php?topic=3111.0

\>\> http://en.wikipedia.org/wiki/Crossword\#Types\_of\_clues

Batch Mode
==========

`for A in $(seq 100); do`

`bash ./auto.bash 6 Dictionary/6.txt`

`done >> out.tmp`

\#\#\#\#\#\#\#\#

`for A in $(seq 100); do bash ./auto.bash 6 Dictionary/6.txt; done >>
tmpresults`

\#\#\#\#\#\#\#\#

`SIZE=4`

`cp Dictionary/${SIZE}.txt tmpdict`

`seq 10 | parallel -n1 --sshlogin root@camera.phor.net --eta --basefile tmpdict
--basefile auto.bash --basefile findanagram.pl --cleanup bash ./auto.bash
${SIZE} tmpdict`

\#\#\#\#\#\#\#\#\#\#

`perl -pe 's/^(\w+)\W.*/\1/g'`

**How to strip clues from answers**

`perl -pe '$i || s/^(\w+)\W.*/\1/g || $i++' < Puzzles/Puzzle\ 2\
easy/attempt_5_18397_60.txt`
