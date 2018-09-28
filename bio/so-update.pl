#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
require LWP::UserAgent;
use Tie::File;
use feature ':5.12';

# Print unicode to standard out
binmode(STDOUT, 'utf8');
# Silence warnings when printing null fields
no warnings ('uninitialized');

my @term_names;
my $so_file = "/local-homes/julie/git/gradle/bio/sources/so/data/so.obo";
my %term_hash;

open(SO_FILE, "< $so_file") || die "cannot open $so_file: $!\n";

while (<SO_FILE>) {
  chomp;

  my $line = $_;

  # if this line eq name: and the line is NOT in the 
  # other map, then this is a new term!
  if ($line =~ /^name/) {      
      # get rid of prefix to leave only the term name
      my @values = split(' ', $line);
      foreach my $val (@values) {
        if ($val !~ "name:") {
          my $java_name = get_java_type_name($val);
          $term_hash{$java_name} = $val; 
        }
      }
  }
}

my $filename = "/local-homes/julie/git/gradle/bio/core/src/main/resources/soClassName.properties";

open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

#print "Done reading in new file\n";

#say $fh "# Added with InterMine 2.0.0 update\n";

foreach my $name (sort keys %term_hash) {
  say $fh "$name $term_hash{$name}";
}

close $fh;

sub get_java_type_name
{
  if (@_ != 1) {
    die "get_java_type_name() needs exactly one argument\n";
  }

  my $name = shift;

  $name =~ s/([^\-\s_]+)[\-\s_]*/\u$1/g;

  return $name;
}

exit(1);
