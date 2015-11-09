package SynbioRegionSearch;

use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(regionSearch);

sub regionSearch {
  my $region = shift;

  # get the chromosome from the region, so chr5:100809296..100814296
  $region =~ m/ (.*?):(.*?) /gx;
  my $chromosome = $1; 
  
  if (!defined $chromosome) { 
    die "chromosome not found in $region\n";
  }

  print "Processing chromosome $chromosome\n";

  my $org_short = &fetch_organism($chromosome);

  if (!defined $org_short) { 
    die "organism not found for $chromosome\n";
  }

  print "Processing organism $org_short\n";

  &region_search($region, $org_short);

}


sub fetch_organism {
  use Webservice::InterMine 1.0405 'http://humanmine.org/humanmine';

  my $thisChromosome = shift;

  my $chrom_query = new_query(class => 'Chromosome');

  # The view specifies the output columns
  $chrom_query->add_view(qw/
      primaryIdentifier
      organism.shortName
  /);

  $chrom_query->add_constraint(
      path  => 'Chromosome.primaryIdentifier',
      op    => '=',
      value => "$thisChromosome",
      code  => 'A',
  );

  # Use an iterator to avoid having all rows in memory at once.
  my $organism_short_name;
  my $it = $chrom_query->iterator();

  while (my $row = <$it>) {
    $organism_short_name = $row->{'organism.shortName'};
  }
  return $organism_short_name;
}

sub region_search {

  use Webservice::InterMine 1.0405;

  my ($region_coordinates, $organism_name) = @_;

  print "INPUT: $region_coordinates, $organism_name\n";

  my $query = Webservice::InterMine->new_query(class => 'Gene')
				   ->select(qw/symbol primaryIdentifier/)
                                   ->where('chromosomeLocation' => {'OVERLAPS' => [$region_coordinates]});
#  print $query->to_xml, "\n";
  my ($symbol, $identifier, @genes);
  for my $gene ($query->results()) {
    $symbol = ($gene =~ m/symbol: (.+?)\t/) ? $1 : '';
    $identifier = ($gene =~ m/primaryIdentifier: (.+?)$/) ? $1 : '';
    push (@genes, [$symbol, $identifier]);
#    print "S: $symbol\tID: $identifier\n";
  }
  return ($organism_name, \@genes);

}
1;
