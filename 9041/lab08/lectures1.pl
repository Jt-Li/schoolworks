#!/usr/bin/perl -w

if ($#ARGV == 0) {
	my %dict = ();
	foreach my $ar (@ARGV) {
		my $url = "http://timetable.unsw.edu.au/current/$ar.html";
		open F, "wget -q -O- $url|" or die;
		my @lines = <F>;
		for my $i (0..$#lines) {
    			if ($lines[$i] =~ /<a href=.*?>Lecture<\/a>/) {
        			if ($lines[$i + 3] =~ /<a href=.*?>WEB.*?<\/a>/) {
					next;
				} else {
	     				$lines[$i + 1] =~ /<a href=.*?>(.*?)<\/a>/;
	     				my $s = $1;
	     				$s =~ s/T/S/;
	     				$lines[$i + 6] =~ /<td.*?>(.*?)<\/td>/;
					if ($dict{$ar.$s.$1}) {
						next;
					} else {
						$dict{$ar.$s.$1} = 1;
						print "$ar: $s $1\n";
					}
				}
    			}
	
		}
	}
} 

if ($ARGV[0] eq "-d") {
	my %dict = ();
	my %dict2 = ();
	shift @ARGV;
	foreach $ar (@ARGV) {
		my $url = "http://timetable.unsw.edu.au/current/$ar.html";
		open F, "wget -q -O- $url|" or die;
		my @lines = <F>;
		for my $i (0..$#lines) {
    			if ($lines[$i] =~ /<a href=.*?>Lecture<\/a>/) {
        			if ($lines[$i + 3] =~ /<a href=.*?>WEB.*?<\/a>/) {
					next;
				} else {
	     				$lines[$i + 1] =~ /<a href=.*?>(.*?)<\/a>/;
	     				my $s = $1;
	     				$s =~ s/T/S/;
	     				$lines[$i + 6] =~ /<td.*?>(.*?)<\/td>/;
					if ($dict{$ar.$s.$1}) {
						next;
					} else {
						$dict{$ar.$s.$1} = 1;
						my @times = split(/, /, $1);
						foreach $time (@times) {
							my $date = substr $time, 0, 3;
							my $start = substr $time, 4, 2;
							$start += 0;
							my $end = substr $time, 12, 2;
							$end += 0;
							if ($end - $start == 1) {
								$dict2{$s.$ar.$date.$start} = 1;
								print "$s $ar $date $start\n";
							} else {
								for (my $j = $start; $j < $end; $j++) {
									if ($dict2{$s.$ar.$date.$j}) {
										next;
									} else {
										print "$s $ar $date $j\n";
										$dict2{$s.$ar.$date.$j} = 1;
									}
								}
							}
						}
					}
				}
    			}
	
		}
	}
	
}



