#!/usr/bin/perl -w




foreach $file (glob "lyrics/*.txt") {
	
	@file_name_1 = split /.txt/, $file;
	@file_name_2 = split /\//, $file_name_1[0]; 
	$file_name_2[1] =~ s/_/ /g;
	$name = $file_name_2[1];
	
	open my $f, '<', $file or die;
	while ($line = <$f>) {
	chomp $line;
 	@content = split /[^a-zA-Z]/,$line;
		foreach $str (@content){
			foreach $word (@ARGV) {
				if (lc $str eq lc $word) {
		   			push @result, $str;		
				}
			}
			
			if ($str ne "") {
		   		push @result2, $str;		
			}
		}
	}
	$result_count{$name} = $#result + 1;
	$result_word{$name} = $#result2 + 1;
	@result = ();
	@result2 = ();

}
foreach my $key (sort keys %result_count) {
	$fren = log(($result_count{$key} + 1) / $result_word{$key});
	printf "log((%d+1)/%6d) = %8.4f %s\n", ($result_count{$key}, $result_word{$key}, $fren, $key);

}
