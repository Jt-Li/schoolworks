#!/usr/bin/perl -w

$pass=`cat accounts/andrewt/password`;
chomp $pass;
print"$pass\n";

@files = <accounts/*>;
%dict = ();
foreach $file (@files) {
  my @split = split(/\//, $file);
  my $usr = $split[1];
  my $path = $file."/password";
  my $pass = `cat $path`;
  $dict{$usr} = $pass;
}
foreach my $key (keys %dict) {
	print "$key, pass: $dict{$key} \n";
}
