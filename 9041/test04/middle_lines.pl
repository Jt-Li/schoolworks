#!/usr/bin/perl -w

$file = $ARGV[0];

open F, '<', $file or die;

@total_line = <F>;
if ($#total_line >= 0) {
	$total = $#total_line + 1;
	if (($total%2) == 0) {
		my $out = $total / 2;
		print "$total_line[$out-1]";
		print "$total_line[$out]";
	} else {
		my $out = $total / 2;
		print "$total_line[$out]";
	}
}
	
