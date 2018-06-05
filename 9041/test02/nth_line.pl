#!/usr/bin/perl -w

open F, $ARGV[1] or die;
$num = $ARGV[0];
$line_num = 0;
while ($line =  <F>) {
   $line_num++;
   if ($line_num == $num) {
       print $line;

   }

   



}

