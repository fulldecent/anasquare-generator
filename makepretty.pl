#!/usr/bin/perl

$name = $ARGV[0];
$name =~ s/\..*//;
@words = ();
@clues = ();
@board = ();
@solved = ();

push(@words, $1), push(@clues, $2) while <> =~ /(\w+)\s*(.*)/;
$size = (scalar @words) / 2;

@solved = split /\W*/, <> until scalar @solved == $size*$size;
@board = map {$_ eq uc $_ ? uc $_ : ""} @solved;
@solved = map {uc} @solved;

###############################

print <<HERE;
<!doctype html>
<html>
<head><title>Anasquare</title>
<style>

* {
  font-family: Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;
}

div.intro {
  background: #fd0064;
  color: white;
  padding: 0.5em;
  margin: 1em 0 2em;
}

div.intro h1 {
  margin: 0;
  padding: 6pt
}

div.intro p {
  background: white;
  color: black;
  margin: 0;
  padding: 6pt;
}

h1 {
}

body {width: 800px; margin: 5em auto; padding: 0}
dl {
 overflow:hidden;
 margin: 0.25em;
 margin-bottom: 1em;
}
dt {
 float:left;
 clear: left;
 width:4em; /* adjust the width; make sure the total of both is 100% */
 text-align: right;
 font-weight: bold;
}
dd {
 float:left;
 width:70%; /* adjust the width; make sure the total of both is 100% */
 margin: 0 0.5em;
}

table {
  border: 2px solid black;
  border-collapse: collapse
}

td {
  border: 1px solid black;
  width: 1.7em; height: 1.7em;
  text-align: center;
  font-size: 20; font-weight: bold;
  position: relative;
}

td span {
  position: absolute; top: 0; left: 0;
  font-size: x-small;
  font-weight: normal;
}

h2 {
 margin: 0 0 0.25em 4.5em;
 font-weight: bold;
 font-size: medium;
 text-transform: uppercase;
}

hr {
 clear: both;
 margin: 1em 0;
}

</style>
</head>
<body>

<p style="text-align: right">$name</p>
<div class="intro">
  <h1 style="float:right"><small>By William Entriken</small></h1>
  <h1>Anasquare</h1>
  <p><em>To solve this puzzle, first answer the Across and Down clues. Then anagram each answer into the grid in the correspondingly numbered row or column, using the given letters as a guide.
</div>

<div style="width:400px; float: left">
<h2>Across</h2>
<dl>
HERE
#########################

print "<dt>1</dt><dd>$clues[0]</dd>\n";
print "<dt>".($_+$size)."</dt><dd>$clues[$_]</dd>\n" for (1..$size-1);

print <<HERE;
</dl>

<h2>Down</h2>
<dl>
HERE
#########################

print "<dt>".($_)."</dt><dd>$clues[$_+$size-1]</dd>\n" for (1..$size);

print <<HERE;
</dl>
</div>

<div style="width:400px; float: right">
<table>
HERE
#########################

print "<tr>\n";
print "  <td><span>".($_+1)."</span>$board[$_]</td>\n" for (0..$size-1);

for ($size..$#board) {
  print "<tr>" if $_ % $size == 0;
  $insert = $_ % $size == 0 ? "<span>".(($_)/$size+$size)."</span>" : "";
  print "  <td>$insert$board[$_]</td>\n";
}

print <<HERE;
</table>
</div>

<div class="intro" style="clear: both; page-break-before: always">
  <h1>Answers</h1>
</div>


<div style="width:400px; float: left">
<dl>
HERE
#########################

print <<HERE;

<h2>Across</h2>
<dl>
HERE
#########################

print "<dt>1</dt><dd>$words[0]</dd>\n";
print "<dt>".($_+$size)."</dt><dd>$words[$_]</dd>\n" for (1..$size-1);

print <<HERE;
</dl>

<h2>Down</h2>
<dl>
HERE
#########################

print "<dt>".($_)."</dt><dd>$words[$_+$size-1]</dd>\n" for (1..$size);

print <<HERE;
</dl>
</div>

<div style="width:400px; float: right">
<table>
HERE
#########################

for (0..$#board) {
  print "<tr>" if $_ % $size == 0;
  print "  <td>$solved[$_]</td>\n";
}

print <<HERE;
</table>
</div>

</body>
</html>

HERE
