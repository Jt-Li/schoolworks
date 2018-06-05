#!/usr/bin/perl -w



$num = $ARGV[0];
$count = 0;
%dict = ();

while (my $line = <STDIN>) {
	chomp $line;
	$line =~ s/\s//g;
	$line = lc $line;
	if ($num <= 0) {
		next;
	}
	if ($dict{$line}) {
		$count++;
		next;
	} else {
		$dict{$line} = 1;
		$num--;
		$count ++;
	}
	
}

if ($num <= 0) {
	print "$ARGV[0] distinct lines seen after $count lines read.\n";
} else {
	print "End of input reached after $count lines read - $ARGV[0] different lines not seen.\n";
}
	
