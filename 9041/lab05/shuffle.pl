#!/usr/bin/perl -w

while ($element=<STDIN>) {
     
     push @a, $element;
}
$size = $#a + 1;
$temp = $a[rand($size)];
push @b, $temp;
print $temp;
while ( $#b < $#a ) {
     $temp = $a[rand($size)];
     if (!($temp  ~~ @b)) {
       	push @b, $temp;
        print $temp;
     }
}



