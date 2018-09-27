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

my @old_term_names;

my $new_so_file = "/tmp/so/so.obo.new";
my $old_so_file = "/tmp/so/so.obo";


# takes two SO files, does a DIFF, java-ises the new terms and prints them out

#################### OLD file ######################################

open(OLD_SO_FILE, "< $old_so_file") || die "cannot open $old_so_file: $!\n";

#print "reading in so file from $old_so_file\n";

while (<OLD_SO_FILE>) {
  chomp;

  my $line = $_;

  if ($line  =~ /^name/) {
      push @old_term_names, $line;
  }
}

#print "Done reading old file\n";

#################### NEW file ######################################

# turn into a hash
my %terms_hash = map { $_ => 1 } @old_term_names;

# newly added terms
my @new_term_names;

open(NEW_SO_FILE, "< $new_so_file") || die "cannot open $new_so_file: $!\n";

#print "reading in so file from $new_so_file\n";

my %added_term_hash;

while (<NEW_SO_FILE>) {
  chomp;

  my $line = $_;

  # if this line eq name: and the line is NOT in the 
  # other map, then this is a new term!
  if ($line  =~ /^name/ && !exists($terms_hash{$line})) {      
      # get rid of prefix to leave only the term name
      my @values = split(' ', $line);
      foreach my $val (@values) {
        if ($val !~ "name:") {
          my $java_name = get_java_type_name($val);
          $added_term_hash{$java_name} = $val; 
        }
      }
  }
}

#print "Done reading in new file\n";

foreach my $name (sort keys %added_term_hash) {
  print "$name $added_term_hash{$name}\n";
}

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
