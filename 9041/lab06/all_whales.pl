#!/usr/bin/perl -w

while ($line = <STDIN>) {
     chomp $line;
     @content = split / /, $line, 2;
     $indi = $content[0];
     @content_2 = split / /, $content[1];
     $whale = "";
     foreach $name (@content_2) {
          $whale = "$whale$name" ;
     }
     $whale = lc $whale;
     $check = substr $whale, -1;
     if ( $check eq "s" ) {
         chop $whale;
     } 
     if ( $pods{$whale} ) {
         $pods{$whale}++;
         $indis{$whale} += $indi;
     } else {
         $pods{$whale} = 1;
         $indis{$whale} = $indi;
     }
}
@keys = keys %pods;
@keys = sort @keys;
foreach $key (@keys) {
    print $key, " observations: ", $pods{$key}, " pods, ", $indis{$key}, " individuals\n";
} 

