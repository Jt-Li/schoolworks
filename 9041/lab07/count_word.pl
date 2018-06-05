#!/usr/bin/perl -w


$word = $ARGV[0];

while ($line = <STDIN>) {
	chomp $line;
 	@content = split /[^a-zA-Z]/,$line;
	foreach $str (@content){
		if (lc $str eq lc $word) {
		   
		   push @result, $str;		
		}
	}
	
}
$out = $#result + 1; 
print "$word occurred $out times\n"; 
