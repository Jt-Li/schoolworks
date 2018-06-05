#!/usr/bin/perl -w


%dict=();
foreach my $word (@ARGV) {
	if ($dict{$word}) {
		next;
	} else {
		$dict{$word} = 1;
		push @result, $word;
     	}
	
}
foreach my $word (@result) {
	print "$word ";
}
print"\n";
