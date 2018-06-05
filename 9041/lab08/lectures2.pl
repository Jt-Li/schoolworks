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

if ($ARGV[0] eq "-t") {
	my %dict = ();
	my %dict2 = ();
	my %table = ();
	my $s1 = 0;
	my $s2 = 0;
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
	     				if ($s eq "S1") {
	     					$s1 = 1;
	     				} else {
	     					$s2 = 1;
	     				}
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
								if ($table{$s.$date.$start}) {
									$table{$s.$date.$start}++;
								} else {
									$table{$s.$date.$start} = 1;
								}
							} else {
								for (my $j = $start; $j < $end; $j++) {
									if ($dict2{$s.$ar.$date.$j}) {
										next;
									} else {
										
										$dict2{$s.$ar.$date.$j} = 1;
										if ($table{$s.$date.$j}) {
											$table{$s.$date.$j}++;
										} else {
											$table{$s.$date.$j} = 1;
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
	if ($s1 == 1) {
		print "S1\tMon\tTue\tWed\tThu\tFri\t\n";
		foreach my $i (9..20) {
			if ($i == 9) {
				print "0$i:00\t";
			} else {
				print "$i:00\t";
			}
			foreach my $d ("Mon", "Tue", "Wed", "Thu", "Fri") {
				if ($table{S1.$d.$i}) {
					print "$table{S1.$d.$i}\t";
				} else {
					print " \t";
				}
			}
			print"\n";
		
		}
	}
	if ($s2 == 1) {
		print "S2\tMon\tTue\tWed\tThu\tFri\t\n";
		foreach my $i (9..20) {
			if ($i == 9) {
				print "0$i:00\t";
			} else {
				print "$i:00\t";
			}
		
			foreach my $d ("Mon", "Tue", "Wed", "Thu", "Fri") {
				if ($table{S2.$d.$i}) {
					print "$table{S2.$d.$i}\t";
				} else {
					print " \t";
				}
			}
			print"\n";
		
		}
	}
	
	
}



