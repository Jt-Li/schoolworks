#!/usr/bin/perl -w

open F, '<', $ARGV[0] or die;

@lines = <F>;

foreach my $line (@lines) {
	chomp $line;
	$line =~ s/[aeiou]//g;
	$line =~ s/[AEIOU]//g;
	push @result, "$line\n";
}
close(F);
open F, '>', $ARGV[0] or die; 
print F @result;



