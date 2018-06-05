#!/usr/bin/perl -w

# Starting point for COMP[29]041 assignment 1
# http://www.cse.unsw.edu.au/~cs2041/assignments/pypl
# written by Jiongtian Li September 2017

# record indent as global variable
$indent = 0;

while ($line = <>) {
    if ($line =~ /^#!/ && $. == 1) {
	# translate #! line
	print "#!/usr/bin/perl -w\n";
        next;
    } elsif ($line =~ /^\s*(#|$)/) {
    	# Blank & comment lines can be passed unchanged
    	print $line;
        next;
    } elsif ($line =~ /import.*/) {
    	# pass import line
    	print "\n";
    } 
    # check indent part and close loop if necessary
    $line =~ /^(\s*)(.*)/;
    $spaces = length($1);
    $xxx = $2;
    $check_indent = "";
    for my $i (0..$indent - 1) {
    	$check_indent = $check_indent."    ";
    }
    $check_indent = $check_indent.$xxx;
    chomp $line;
    $line =~ s/\s+$//;
   	if ($check_indent eq $line) {
    	# indent match
    	for my $i (0..$indent - 1) {
    		print"    ";
    	}
    } else {
    	my $new_check = "";
    	# indent doesn't match
    	if (not($line =~ /^\s*(elif.*)/ or $line =~ /^\s*(else.*)/)) {
    		# continue decrease indent and close loop by } until match 
    		# use 4 spaces as indentation 
    		while ($indent*4 != $spaces) {
    			$indent--;
    			for my $i (0..$indent - 1) {
    				print"    ";
    			}
    			print "}\n";
    		}
    		for my $i (0..$indent - 1) {
    			print"    ";
    		}
    	} else {
    		$indent--;
    		for my $i (0..$indent - 1) {
    			print"    ";
    		}
    	}
    	
    }
    
    # trim line
    $line =~ s/\s+$//;
    $line =~ s/^\s+//;
    
    # translate "continue, break, append
    if ($line =~ /continue/) {
    	print "next;\n";
    	next;
    } elsif ($line =~ /break/) {
    	print "last;\n";
    	next;
    } elsif ($line =~ /^\s*(\w*)\.append\((.*)\)/) {
    		my $new = "\@".$1;
    		
    		print "push $new, \$", $2, "\n";
    		next;
    }
    
    
    if ($line =~ /^\s*print\("(.*)"\)$/) {

        # Python's print outputs a new-line character by default
        # so we need to add it explicitly to the Perl print statement
        # deal with print when there is " "
        
        print "print \"$1\\n\";\n";
        
        # " useless comment line to fix the stupid display bug in editor gedit

    } elsif ($line =~ /sys.stdout.write\((.*)\)$/) {
    	print "print $1\; \n"; 
    } elsif ($line =~ /^\s*print\((.*)\)$/) {
    	# when print don't have only one " " inside
        Print($line);
    
    } elsif ($line =~ /^\s*([a-zA-Z]+[0-9]*?) =/) {
    	# add dollar singn in front of variables
    	
    	Add_dollar($line);
	
    } elsif ($line =~ /^\s*(if.*)/ || $line =~ /^\s*(while.*)/) {
    	# call "while loop and if" translate function
    	While_if($1);
    } elsif ($line =~ /^\s*(for.*)/) {
    	# call for loop transalte function 
    	For_loop($1);
    } elsif ($line =~ /^\s*(elif.*)/) {
    	print "} ";
    	my $temp = $1;
    	$temp =~ s/elif/elsif/;
    	While_if($temp);
    } elsif ($line =~ /^\s*(else.*)/) {
    	print "} ";
    	print "else {\n";
    	$indent++;
    }
    	
    	
}
# close the loop if necessary
if ($indent > 0) {
	print "}\n";
}

# print translate function
sub Print{
	my $line = $_[0];
	# loop every thing inside the print () then print out seperately
        my $temp = $1;
        my $new_lines = "true";
        my @check = split(/,/, $temp);
        foreach my $part (@check) {
        	if ($part =~ /"(.*)"/) {
        		my $temp = $1;
        		print "print \"$temp\"\;";
        		print "print \" \"\;";
        	} elsif ($part =~ /end=''/) {
        		$new_lines = "false";
        	} elsif ($part =~ /(^[0-9]+)/) {
        		my $temp = $1;
        		print "print \"$temp\"\;";
        		print "print \" \"\;";
        	} elsif ($part =~ /(.+)\[(.+)\]/) {
        		my $temp1 = $1;
        		my $temp2 = $2;
        		$part =~ s/$temp1/\$$temp1/;
        		$part =~ s/\[$temp2\]/\[\$$temp2\]/;
        		print "print \"$part\"\;";
        		print "print \" \"\;";
        	} elsif ($part =~ /len/) {
     			$part =~ /len\((.*)\)/;
			my $new = "\@".$1;
			$part = $new;
			print "print $part\;";
        		print "print \" \"\;";
		} else {
        		my @vars = $part =~ /([A-Za-z]+[0-9]*)/g;
        		foreach my $var (@vars) {
        			if (not($var eq "or" or $var eq "and" or $var eq "not" or lc $var eq "True" or lc $var eq "False" or $var=~ /len/)) {
        				$part =~ s/$var/\$$var/;
        			} 
			} 
			print "print $part \;";
        		print "print \" \"\;"; 
        	}
        		
        }
        if ($new_lines eq "true") {
        	print "print \"\\n\"\;\n";
        } else {
        	print "\n";
        }
}

sub Add_dollar {
    my $line = $_[0];
    chomp $line;
   
    # add $ in front of the varible which been assigned value
    my $nnn = $1;
    my $new = "\$".$nnn;
	$line =~ s/$nnn =/$new =/;
	
	# translate the assign value
	if ($line =~ /= (.*?) (.*?) (.*)/) {
		my $temp1 = $1;
		my $temp2 = $2;
		my $temp3 = $3;
		if ($temp1 =~ /[a-zA-Z]+[0-9]*/ or $temp1 =~ /~[a-zA-Z]+[0-9]*/) {
			if (not($temp1 eq "and" or $temp1 eq "or" or $temp1 eq "not" or $temp1 eq "True" or $temp1 eq "False" or $temp1=~ /len/)) {
				if ($temp1 =~ /~[a-zA-Z]+[0-9]*/) {
					$temp1 =~ /~([a-zA-Z]+[0-9]*)/;
					my $new_temp = $1;
					my $new = "\$".$new_temp;
					$temp1 =~ s/$new_temp/$new/;
				} else {
					$temp1 = "\$".$temp1;
				}
			} elsif ($temp1 =~ /len/) {
				$temp1 =~ /len\((.*)\)/;
				$temp1 = "\@".$1;
			}
				
		}
		if ($temp3 =~ /[a-zA-Z]+[0-9]*/ or $temp3 =~ /~[a-zA-Z]+[0-9]*/) {
			if (not($temp3 eq "and" or $temp3 eq "or" or $temp3 eq "not" or lc$temp3 eq "true" or lc $temp3 eq "false" or $temp3 =~ /len/ )) {
				if ($temp3 =~ /~[a-zA-Z]+[0-9]*/) {
					$temp3 =~ /~([a-zA-Z]+[0-9]*)/;
					my $new_temp = $1;
					my $new = "\$".$new_temp;
					$temp3 =~ s/$new_temp/$new/;
				} else {
					$temp3 = "\$".$temp3;
				}
			} elsif ($temp3 =~ /len/) {
				$temp3 =~ /len\((.*)\)/;
				$temp3 = "\@".$1;
			} 
		} 
		# translate // to / use int method
		$line =~ s/=.*//;
		if ($temp2 =~ /\/\//) {
			$temp2 = "\/";
			$line = $line."= "."int"."\( $temp1 $temp2 $temp3 \)";
			$line = $line.";";
			print "$line\n";
		} else {
			$line = $line."= $temp1 $temp2 $temp3";
			$line = $line.";";
			print "$line\n";
		}
	} elsif ($line =~ /sys.stdin.readline\(\)/) {
		$line =~ s/=.*//;
		$line = $line."= <STDIN>;";
		print "$line\n";
	} elsif ($line =~ /sys.stdin.readlines\(\)/) {
		print "while my \$line (<STDIN>) { \n";
		for my $i (0..$indent) {
    			print"    ";
    		}
    		$line =~ /(.+) =/;
    		my $new = $1;
    		$new =~ s/\$/\@/;
    		print "push $new,", "\$line", "\n"; 
    		for my $i (0..$indent - 1) {
    			print"    ";
    		}
    		print "}\n";
    	} elsif ($line =~ /len\((.*)\)/) {
		my $new = "\@".$1;
		$line =~ s/=.*//;
		$line = $line."= $new;";
		print "$line\n";
	} elsif ($line =~ /= \[\]/) {
		print "\n";
	} else {
		if ($line =~ /= ([a-zA-Z]+[0-9]*)/ or $line =~ /~([a-zA-Z]+[0-9]*)/) {
			my $temp1 = $1;
			if (not($temp1 eq "and" or $temp1 eq "or" or $temp1 eq "not" or lc$temp1 eq "true" or lc $temp1 eq "false" )) {
				my $new = "\$".$temp1;
				if ($line =~ /~[a-zA-Z]+[0-9]*/) {
					$line =~ s/= ~$temp1/= ~$new/;
				} else {
					$line =~ s/= $temp1/= $new/;
				}
				$line = $line.";";
				print "$line\n";
			} else {
				$line = $line.";";
				print "$line\n";
			}
				
		} else {
			
			$line = $line.";";
			print "$line\n";
		}
	}
}

sub For_loop {
	my $line = $_[0];
	# translate if or while or for loop by seperate two parts: con and do
    	my $out = "";
    	my @total = split(/:/, $line, 2);
    	my $con = $total[0];
    	my $do = $total[1];
    	my @con_part = split(/ /, $con, 4);
    	if ($con_part[3] =~ /range\((.*), (.*)\)/) {
    		my $begin = $1;
    		my $end = $2;
    		if ($begin =~ / /) {
    			my @parts = split(/ /, $begin);
    			foreach my $part (@parts) {
    				if ($part =~ /[a-zA-Z]+[0-9]*/) {
    					my $new = "\$".$part;
    					$begin =~ s/$part/$new/;
    				}
    			}
    		} elsif ($begin =~ /^[a-zA-Z]+[0-9]*/) {
    			$begin = "\$".$begin;
    		}
    		if ($end =~ / /) {
    			my @parts = split(/ /, $end);
    			foreach my $part (@parts) {
    				if ($part =~ /[a-zA-Z]+[0-9]*/) {
    					my $new = "\$".$part;
    					$end =~ s/$part/$new/;
    				}
    			}
    		} elsif ($end =~ /^[a-zA-Z]+[0-9]*/) {
    			$end = "\$".$end;
    		}
    		$end = $end." - 1";
    		$con_part[3] = "($begin..$end) {";
    	} elsif ($con_part[3] =~ /range\(([0-9]+)\)/) {
    		my $temp = $1 - 1;
    		$con_part[3] = "(0..$temp) {";
    	} elsif ($con_part[3] =~ /range\(([a-zA-Z]+[0-9]*)\)/) {
    		my $temp = "\$".$1." - 1";
    		$con_part[3] = "(0..$temp) {";
    	} elsif ($con_part[3] =~ /sys.stdin/) {
    		$con_part[3] = "(<STDIN>) {";
    	}
    		
    	$con_part[1] = "\$".$con_part[1];
    	print "foreach $con_part[1] $con_part[3]\n";
    	
    	# done with condition part
    	# begin for do part
    	
    	if ($do =~ /\S+/ ) {
    		if ($do =~ /\;/) {
    			my @parts = split(/;/, $do);
    			foreach my $part (@parts) {
    				if ($part =~ /^\s*print\((.*)\)$/) {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					Print($part);
    				} elsif ($part =~ /^\s*([a-zA-Z]+[0-9]*?) =/) {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					Add_dollar($part);
    				} else {
    					if ($part eq " break") {
    						for my $i (0..$indent) {
    							print"    ";
    						}
    						print "last\;\n"
    					}
    					if ($part eq " continue") {
    						for my $i (0..$indent) {
    							print"    ";
    						}
    						print "next\;\n"
    					}
    				}
    			}
    		} else {
    			if ($do =~ /^\s*print\((.*)\)$/) {
    				for my $i (0..$indent) {
    					print"    ";
    				}
    				Print($do);
    			} elsif ($do =~ /^\s*([a-zA-Z]+[0-9]*?) =/) {
    				for my $i (0..$indent) {
    					print"    ";
    				}
    				Add_dollar($do);
    			} elsif ($do =~ /(\w*)\.append\((.*)\)/) {
    				for my $i (0..$indent) {
    					print"    ";
    				}
    				my $new = "\@".$1;
    				print "push $new, \$", $2, "\n";
    			}
    				 
    			else {
    				if ($part eq " break") {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					print "last\;\n"
    				}
    				if ($part eq " continue") {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					print "next\;\n"
    				}
    			}
    		}
    		# close the while/for loop
    		for my $i (0..$indent - 1) {
    			print"    ";
    		}
    		print "}\n";
    	} else  {
    		$indent++;
    	}
}

sub While_if {
    my $line = $_[0];
    # translate if or while loop by seperate two parts: con and do
    my $out = "";
    my @total = split(/:/, $line, 2);
    my $con = $total[0];
    my $do = $total[1];
    my @con_part = split(/ /, $con, 2);
    $out = $out.$con_part[0]." \(";
    my $con_2 = $con_part[1];
    my @loop_con = split(/ /, $con_2);
    foreach my $char (@loop_con) {
    	if ($char =~ /[a-zA-Z]+[0-9]*?/) {
    		$out = $out." "."\$".$char;
    	} else {
    		$out = $out." ".$char;
    	}
    }
    $out = $out." ) { ";
    print "$out\n";
    # done with condition part
    # begin for do part
    if ($do =~ /\S+/ ) {
    	if ($do =~ /\;/) {
    		my @parts = split(/;/, $do);
    		foreach my $part (@parts) {
    			if ($part =~ /^\s*print\((.*)\)$/) {
    				for my $i (0..$indent) {
    					print"    ";
    				}
    				Print($part);
    			} elsif ($part =~ /^\s*([a-zA-Z]+[0-9]*?) =/) {
    				for my $i (0..$indent) {
    					print"    ";
    				}
    				Add_dollar($part);
    			} else {
    				if ($part eq " break") {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					print "last\;\n"
    				}
    				if ($part eq " continue") {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					print "next\;\n"
    				}
    			}
    		}
    	} else {
    		if ($do =~ /^\s*print\((.*)\)$/) {
    			for my $i (0..$indent) {
    					print"    ";
    			}
    			Print($do);
    		} elsif ($do =~ /^\s*([a-zA-Z]+[0-9]*?) =/) {
    			for my $i (0..$indent) {
    					print"    ";
    			}
    			Add_dollar($do);
    		} else {
    				if ($part eq " break") {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					print "last\;\n"
    				}
    				if ($part eq " continue") {
    					for my $i (0..$indent) {
    						print"    ";
    					}
    					print "next\;\n"
    				}
    		}
    	}
    	# close the while/for loop
    	print "}\n";
    } else {
    	# multiple lines loop add indent
    	$indent++;
    }
}
	
	
	
	
	
	
	
	
        	
	
