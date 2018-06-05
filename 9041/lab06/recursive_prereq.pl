#!/usr/bin/perl -w

if (@ARGV < 2) {
  $Ar = $ARGV[0];
} else {
  $Ar = $ARGV[1];
}
$url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/$Ar.html";
open F, "wget -q -O- $url|" or die;
$result = "";
while ($line = <F>) {
    if ($line =~ /<p>Prerequisite.?:.*?<\/p>$/) {
        @content = split /<\/p>/, $line, 2;
        @classes = split /: /, $content[0], 2;
        $result = "$result $classes[1]";
        
    }
	
}
$url2 = "http://www.handbook.unsw.edu.au/undergraduate/courses/2017/$Ar.html";
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
           $class =~ s/\W//g;;
        }
        push @output, $class;
        push @final, $class;
        $set{$class} = 1;
    }
    
}
@output = sort @output;



if (@ARGV == 2) {
while ($shift = shift @output) {
  $url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/$shift.html";
  open F, "wget -q -O- $url|" or die;
  $result = "";
  while ($line = <F>) {
    if ($line =~ /<p>Prerequisite.?:.*?<\/p>$/) {
        @content = split /<\/p>/, $line, 2;
        @classes = split /: /, $content[0], 2;
        $result = "$result $classes[1]";
        
    }
	
  }
  $url2 = "http://www.handbook.unsw.edu.au/undergraduate/courses/2017/$shift.html";
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
        if (! $set{$class} ) {
           push @output, $class;
           push @final, $class;
           $set{$class} = 1;
        }
        
        

   }
    
   }
}}

@final = sort @final;
foreach $fin (@final) {
  print "$fin\n";
}
