#!/usr/bin/perl -w


$whale = $ARGV[0];

$pod = 0;
$indi = 0;

while ($line = <STDIN>) {
     chomp $line;
     @content = split / /, $line, 2;
     if ( $whale eq $content[1]) {
         $pod ++;
         $indi += $content[0];
     }
}
print $whale, " observations: ", $pod, " pods, ", $indi, " individuals\n";
