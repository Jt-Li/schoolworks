#!/usr/bin/perl -w

if (@ARGV != 2) {
   print "Usage: ./echon.pl <number of lines> <string>\n";
   exit 0;
}
if ($ARGV[0] =~ /^\d+$/) {
	foreach (1..$ARGV[0]) {
    		print "$ARGV[1]\n"
	} 

} else {
  print "./echon.pl: argument 1 must be a non-negative integer\n";
  exit 0;
}




