#!/usr/bin/perl -w

$url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/$ARGV[0].html";
open F, "wget -q -O- $url|" or die;
$result = "";
while ($line = <F>) {
    if ($line =~ /<p>Prerequisite.?:.*?<\/p>$/) {
        @content = split /<\/p>/, $line, 2;
        @classes = split /: /, $content[0], 2;
        $result = "$result $classes[1]";
        
    }
	
}
$url2 = "http://www.handbook.unsw.edu.au/undergraduate/courses/2017/$ARGV[0].html";
open F2, "wget -q -O- $url2|" or die;
while ($line = <F2>) {
    if ($line =~ /<p>Prerequisite.?:.*?<\/p>$/) {
        @content = split /<\/p>/, $line, 2;
        @classes = split /: /, $content[0], 2;
        $result = "$result $classes[1]";
        
        
    }
	
}
@print = split / /, $result; 

foreach $class (@print) {
   if ($class =~ /[A-Z]{4}[0-9]{4}/) {
        $len = length $class;
        if ($len > 8) {
           $class =~ s/\W//g;
        }
        push @output, $class;

  }
    
}
@output = sort @output;
foreach $out (@output) {
  print "$out\n";
}
