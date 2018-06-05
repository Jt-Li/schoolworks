#!/usr/bin/perl -w

while ($line = <STDIN>) {
    chomp $line;
    $line =~ s/\d//g;
    push @result, $line;
}

foreach $line (@result) {
  print "$line\n";

}
