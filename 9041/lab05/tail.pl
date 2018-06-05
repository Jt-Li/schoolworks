#!/usr/bin/perl -w
if (@ARGV < 1) {
 while ($line=<STDIN>) {
    push @z, $line;
 } 
} else {
       foreach $arg (@ARGV) {
    		if ($arg eq "--version") {
        		print "$0: version 0.1\n";
        		exit 0;
    		} elsif ($arg =~ /^-[0-9]+$/) {
        		$arg =~ s/-//;
        		$num = $arg;
       		} else {
        		push @files, $arg;
    		}
        }
}


if (!defined $num) {
        $num=10;
}
$num--;
if (defined @z) {
	if ($#z + 1 == 1 && $num >= 0) {
        	print $z[0]; 
    	} else {  
    		foreach $i (0..$num) {
  		print $z[$#z - $num + $i];
    		}
    	  }
}

if (defined @files) { 
    $size = $#files + 1;
}

foreach $f (@files) {
    if ( $size > 1 ) {
    	print "==> $f <==\n";
    } 
    open $F, '<', $f or die "$0: Can't open $f: $!\n";
    @result = <$F>;
    if ($#result + 1 == 1 && $num >= 0) {
        print $result[0]; 
    } else {  
    	foreach $i (0..$num) {
  		print $result[$#result - $num + $i];
    	}
    }
    close $F;
}

