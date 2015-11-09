#!/usr/bin/perl

use strict;
use warnings;
#use XML::Twig;
use Getopt::Std;

# we want to use say instead of print
use feature ':5.12';

# need to tell it where to find the modules
use lib "/local-homes/julie/scripts";

# Load module dependencies
use SynbioRegionSearch qw(regionSearch);

# Use IM items modules
use InterMine::Item::Document;
use InterMine::Model;

my ($gene_DBTBS, $region);
my ($synbioRef, @identifiers);
my $debug;

my $usage = "usage: $0 filename_containing_regions\n";

unless ( $ARGV[0] ) { die $usage };

my ($regions_file) = @ARGV;

open(REGIONS_FILE, "< $regions_file") || die "cannot open $regions_file: $!\n";

while (<REGIONS_FILE>) {
	chomp;
    my $extend_region = $_;
	say "Processing region: $extend_region";

# # call a module to query synbiomine regioSearch for gene id
	my ($org_short, $geneRef) = regionSearch($extend_region);
	my @genes_synbio = $geneRef;

	foreach my $synbio_gene (@genes_synbio) {
	  my $symbol = $synbio_gene->[0];
	  my $identifier = $synbio_gene->[1];
	  print "$identifier\n";
	  print "$symbol\n";
	}
}
