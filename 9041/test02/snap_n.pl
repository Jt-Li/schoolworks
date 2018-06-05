#!/usr/bin/perl -w

$num = $ARGV[0];

while ($line = <STDIN>) {
  if ( $appear{$line} ) {
     $appear{$line}++;  
     if ($appear{$line} == $num ) {
         print "Snap: $line"; 
         last;     
      }
  } else {
      $appear{$line} = 1;
      if ($appear{$line} == $num ) {
         print "Snap: $line";
         last;      
      }
  }


}
