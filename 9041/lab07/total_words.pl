#!/usr/bin/perl -w



while ($line = <STDIN>) {
	chomp $line;
 	@content = split /[^a-zA-Z]/,$line;
	foreach $str (@content){
		if ($str ne "") {
		   
		   push @result, $str;		
		}
	}
	
}
$out = $#result + 1;
print "$out words \n";
	
