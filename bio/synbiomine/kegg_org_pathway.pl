#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
require LWP::UserAgent;

use feature ':5.12';

# Print unicode to standard out
binmode(STDOUT, 'utf8');
# Silence warnings when printing null fields
no warnings ('uninitialized');

my $usage = "usage: $0 file_of_organism_code output_directory_path

organism_codes:\t3-4 letter organism codes used by KEGG
e.g. eco\te. coli

-v\tverbose output

\n";

### command line options ###
my (%opts, $verbose);

getopts('hv', \%opts);
defined $opts{"h"} and die $usage;
defined $opts{"v"} and $verbose++;

unless ( $ARGV[0] ) { die $usage };

my ($org_file, $out_dir) = @ARGV;
$out_dir = ($out_dir) ? $out_dir : "\.";

open(ORG_FILE, "< $org_file") || die "cannot open $org_file: $!\n";

say "Executing KEGG pathways script" if ($verbose);

while (<ORG_FILE>) {
  chomp;
  my $org = $_;
  say "Processing organism: $org" if ($verbose);

  my $content = &kegg_ws($org);
  sleep(3);
  &process_kegg($org, $out_dir, $content);

}

say "All done - enjoy your results" if ($verbose);
exit(1);

## sub routines ##
sub kegg_ws {

  my $org = shift;
  my $base = "http://rest.kegg.jp/link/pathway/";
  my $url = "$base$org";

  my $agent = LWP::UserAgent->new;

  my $request  = HTTP::Request->new(GET => $url);
  my $response = $agent->request($request);

  $response->is_success or say "$org - Error: " . 
  $response->code . " " . $response->message;

  return $response->content;

}

sub process_kegg {

  my ($org, $out_dir, $content) = @_;

  my %gene2path;

  my $out_file = $org . "_gene_map.tab";
  open (OUT_FILE, ">$out_dir/$out_file") or die $!;
  say "Writing to $out_dir/$out_file" if ($verbose);

  open my ($str_fh), '+<', \$content; # process 

  while (<$str_fh>) {
    chomp;
    $_ =~ s/path:$org//;
    $_ =~ s/$org://;
    my ($gene, $path) = split("\t", $_);
    push( @{ $gene2path{$gene} }, $path );
    say "line $gene - $path" if ($verbose);
  }

  close ($str_fh);

  my @sorted = map  { $_->[0] }
               sort { $a->[1] <=> $b->[1] }
               map  { /[A-Za-z_-]+(\d+)/ and [$_, $1] }
               keys %gene2path;

  for my $key (@sorted) {

#  for my $key (sort { $gene2path {$a} <=> $gene2path {$b} } keys %gene2path) {
    say OUT_FILE $key, "\t", join(" ",  @{ $gene2path{$key} } );
  }
  say "Finished $org\n" if ($verbose);
  close (OUT_FILE);

}
