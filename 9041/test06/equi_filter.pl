#!/usr/bin/perl -w


while (my $line = <STDIN>) {
	my @words = split(/\s/, $line);
	foreach my $word (@words) {
		my $sts = 1;
		my %dict = ();
		foreach my $char (split(//, $word)) {
			if ($dict{lc $char}) {
				$dict{lc $char}++;
			} else {
				$dict{lc $char} = 1;
			}
		}
		my $a = lc substr($word, 0, 1);
		my $value = $dict{$a};
		foreach my $key (keys %dict) {
			if ($dict{$key} != $value) {
				$sts = 0;
				last;
			}
		}
		if ($sts == 1) {
			print "$word ";
		}
	}
	print "\n";
	
}
			
			
		
