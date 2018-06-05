#!/usr/bin/perl -w

foreach my $file (glob "lyrics/*.txt") {
		my @file_name_1 = split /.txt/, $file;
		my @file_name_2 = split /\//, $file_name_1[0]; 
		$file_name_2[1] =~ s/_/ /g;
		$name = $file_name_2[1];
		open my $f, '<', $file or die;
		while (my $line = <$f>) {
			chomp $line;
 			my @content = split /[^a-zA-Z]/, $line;
			foreach my $str (@content){
				if ($str ne "") {
		   			push @lyrics, $str;		
				}
			}
		}
		$artist_ly{$name} = [@lyrics];
		$artist_word{$name} = @lyrics;
		@lyrics = ();
		
}

foreach my $txt (@ARGV) {
	my @line_array = ();
	open my $ff, '<', $txt or die;
	while (my $line1 = <$ff>) {
		chomp $line1;
		my @content1 = split /[^a-zA-Z]/,$line1;
		foreach my $str1 (@content1){
			if ($str1 ne "") {
				push @line_array, $str1;		
			}
		}
	}
	foreach my $word (@line_array) {
		for my $artist (sort keys %artist_ly) {
			my $occur = 0;
			foreach my $ly (@{$artist_ly{$artist}}) {
				if (lc $word eq lc $ly) {
					$occur++;
				}
			}
			$final_w{$artist} += log(($occur + 1) / $artist_word{$artist});
		}
	}
	my @o = sort values %final_w;
	for my $r (keys %final_w) {
		if ($final_w{$r} == $o[0]) {
			printf "%s most resembles the work of %s (log-probability=%.1f)\n", ($txt, $r, $o[0]);
		}
	}
	@o = ();
	%final_w = ();
	
}


	
	





