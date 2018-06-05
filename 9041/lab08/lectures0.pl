#!/usr/bin/perl -w


%dict = ();
foreach $ar (@ARGV) {
	$url = "http://timetable.unsw.edu.au/current/$ar.html";
	open F, "wget -q -O- $url|" or die;
	@lines = <F>;
	for $i (0..$#lines) {
    		if ($lines[$i] =~ /<a href=.*?>Lecture<\/a>/) {
        		if ($lines[$i + 3] =~ /<a href=.*?>WEB.*?<\/a>/) {
				next;
			} else {
	     			$lines[$i + 1] =~ /<a href=.*?>(.*?)<\/a>/;
	     			$s = $1;
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
