#!/usr/bin/perl -w

$ar = $ARGV[0].KENS;




$url = "http://www.timetable.unsw.edu.au/current/$ar.html";


open F, "wget -q -O- $url|" or die;
%dict = ();

while ($line = <F>) {
    
    if ($line =~ /<td class="data"><a href="([A-Z]{4}[0-9]{4})\.html/) {
        if ($dict{$1}) {
	    next;
	}else {
	   $dict{$1} = 1;
	   print"$1\n";
	}
        
    }
	
}
