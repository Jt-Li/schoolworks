#!/usr/bin/perl -w

while (my $line = <STDIN>) {
	chomp $line;
	@content = split ' ', $line;
	@out = sort @content;
	print "@out\n";
}
