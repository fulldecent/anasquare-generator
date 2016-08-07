#!/usr/bin/perl

#
# GOAL: Find words from STDIN that are an anagram of words
#       given on the command line
#
# EXAMPLE: ./findanagram.pl [-q] hello world ilike penta words < DICTIONARY
#

use List::Util qw[sum shuffle min];
use Getopt::Std;
die "usage: $0 words ...\n" unless $#ARGV > 0;

getopts( 'q', \%opt );

@dict = shuffle map lc, map split, <STDIN>;
@dict = grep {$d=$_; !grep {$d eq lc $_} @ARGV} @dict;

# Count number of each letter a..z from words on command line
@ARGV = map {scalar (()=(join'',@ARGV)=~/$_/gi)} ("a".."z");

$size = sqrt sum @ARGV;
die "error: need a perfect square number of letters\n" unless $size == int $size;
@words=();
@pword=();
$next=0;

# Put impossible items first, they will get skipped in the first pass, avoiding wasted recursion
# Reduces complexity from O(g_n) to O(n^SIZE/2)
# Yes, that's graham's number
sub mySort() {
	@atarget = @btarget = @ARGV;
	$atarget[ord()-97]-- for split //, $a;
	$btarget[ord()-97]-- for split //, $b;
	min (@atarget) <=> min (@btarget);
}

splice @dict, $next, $#dict-$next+1, sort mySort @dict[$next..$#dict];

while (1) {
	$ARGV[ord()-97]-- for split //, $dict[$next];

	if (grep {$_<0} @ARGV) {
		$ARGV[ord()-97]++ for split //, $dict[$next];
	} else {
		push @pwords, $next;
		push @words, $dict[$next];
		unless ($opt{q}) {
			print "remain\t= ";
			print chr(97+$_) x @ARGV[$_] for 0..25;

			print "\npwords \t= ";
			printf "%${size}s ", $_ for @pwords;
			print "\nwords ".scalar(@pwords)."\t= @words\n\n";
		}
		last if @words == $size;
		splice @dict, $next+1, $#dict-$next, sort mySort @dict[$next+1..$#dict];
	}
	$next++;
	while ($next > $#dict) { # went off the deep end
		if (!@pwords) {
			print "No anagram exists\n";
			exit 1;
		}
		$next = 1 + pop @pwords;
		$ARGV[ord()-97]++ for split //, pop @words;
	}
}

print "@words\n";
