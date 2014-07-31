#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Std;
require LWP::UserAgent;

use feature ':5.12';

# Print unicode to standard out
binmode(STDOUT, 'utf8');
# Silence warnings when printing null fields
no warnings ('uninitialized');

=head1 NAME

kegg_org_pathway.pl - Service for retrieving organism-specific gene to pathway mappings 
from the KEGG PATHWAY database using the KEGG's web service

=head1 SYNOPSIS

  usage: kegg_org_pathway [-v|-h] file_of_organism_codes [optional: output_directory_path]

  options: 
    -v (verbose) : helpful messaging for debug purposes
    -h (help)    : shows usage

  input: file_of_organism_codes (plain text - one code per line): 

      KEGG organism_codes: 3-4 letter organism codes used by KEGG e.g. 
      eco
      bsu
      hsa

  [optional: output dir    If not specified, defaults to current dir]

  output: writes a file of gene to pathway mappings for each organism
  specified in the input file. Filename is [code]_gene_map.tab.
  File format is:
    gene_id\tpathway1, p2, p3 etc.

  B<NOTE:> KEGG imposes restrictions on download and use by non-academic groups: 
    I<KEGG API is provided for academic use by academic users belonging to>
    I<academic institutions. This service should not be used for bulk data downloads.> 

    For more information, see: http://www.kegg.jp/kegg/rest/

=head1 AUTHOR

Mike Lyne C<< <dev@intermine.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<dev@intermine.org>.

=head1 SUPPORT

You can find documentation for this script with the perldoc command.

    perldoc kegg_org_pathway.pl

=head1 COPYRIGHT AND LICENSE

Copyright 2006 - 2014 FlyMine, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 FUNCTIONS

=cut

my $usage = "usage: $0 file_of_organism_codes output_directory_path

organism_codes:\t3-4 letter organism codes used by KEGG
e.g.
  eco
  bsu
  hsa

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
    say OUT_FILE $key, "\t", join(" ",  @{ $gene2path{$key} } );
  }
  say "Finished $org\n" if ($verbose);
  close (OUT_FILE);

}

__END__
