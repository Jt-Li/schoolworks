#!/usr/bin/perl -w


foreach my $num (@ARGV) {
	push @nums, $num;
}
@sort = sort { $a <=> $b } @nums;
print $sort[$#nums/2], "\n";




