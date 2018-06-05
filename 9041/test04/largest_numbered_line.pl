#!/usr/bin/perl -w


$max = -99999;
while (my $line = <STDIN>) {
	chomp $line;
	@nums = $line =~ /(-?\d+\.?\d*)/g;
	foreach my $num (@nums) {
		if ($num > $max) {
			$max = $num;
			@print = ();
			push @print, $line;
			last;
		} 
		if ($num == $max) {
			push @print, $line;
			last;
		}
	}
}

foreach my $line (@print) {
	print "$line\n";
}
			
