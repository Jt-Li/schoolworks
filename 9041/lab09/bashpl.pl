#!/usr/bin/perl -w

open F, '<', $ARGV[0] or die;
$out = "";

while (my $line = <F>) {
	chomp $line;
	$line =~ s/^\s+//;
	if ($line eq "" or $line eq "do" or $line eq "then") {
		$out = $out."\n";
		next;
	}
	if ($line eq "done" or $line eq "fi") {
		$out = $out."\}\n";
		next;
	}
	if ($line eq "else") {
		$out = $out."\} else \{\n";
		next;
	}
	if ($line eq "#!/bin/bash") {
		$out = $out."#!/usr/bin/perl -w\n";
		next;
	}
	my $begin = substr $line, 0, 1;
	if ($begin eq "#") {
		$out = $out.$line."\n";
		next;
	}
	if ($line =~ /(echo )/) {
		$line =~ s/$1/print \"/;
		$line = $line."\\n\"\;";
		$out = $out.$line."\n";
		next;
	}
	if ($line =~ /\(\((.*?)\)\)/) {
		my $new_double = "";
		my @double = split(/ /, $1);
		foreach my $char (@double) {
			if ($char =~ /^[a-zA-Z]/) {
				$new_double = $new_double." "."\$".$char;
			} else {
				$new_double = $new_double." ".$char;
			}
		}
		$new_double = $new_double." ";
		my $while = substr $line, 0, 5;
		my $if = substr $line, 0, 2;
		if ($while eq "while") {
			$line =~ s/\(\((.*?)\)\)/\($new_double\) \{/;
			$line =~ s/\=\$/\=/;
			$out = $out.$line."\n";
			next;
		} elsif ($if eq "if") {
			$line =~ s/\(\((.*?)\)\)/\($new_double\) \{/;
			$line =~ s/\=\$/\=/;
			$out = $out.$line."\n";
			next;
		} else {
			$line =~ s/\(\((.*?)\)\)/$new_double/;
			
		}
		$line =~ s/\=\$/\=/;
	}
	if ($line =~ /([a-zA-Z]*?)=/) {
		my $new = "\$".$1." ";
		$line =~ s/$1/$new/;
	}
	$line = $line."\;";
	$out = $out.$line."\n";
}

print "$out\n";


		
		
