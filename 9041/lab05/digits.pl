#!/usr/bin/perl -w


while($line = <STDIN>){
	chomp $line;
	$line =~ s/[0-4]/</g;
	$line =~ s/[6-9]/>/g;
	print "$line \n";
}
