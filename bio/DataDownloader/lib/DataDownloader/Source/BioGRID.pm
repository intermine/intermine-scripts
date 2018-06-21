package DataDownloader::Source::BioGRID;

use Moose;
extends 'DataDownloader::Source::ABC';
use LWP;
use Web::Scraper;

use constant {
    TITLE => 'BioGRID',
    DESCRIPTION => 'Biological General Repository for Interaction Datasets',
    SOURCE_LINK => 'https://thebiogrid.org',
    SOURCE_DIR => 'biogrid',
};
use constant ORGANISMS => (
    "Drosophila_melanogaster",
    "Caenorhabditis_elegans", 
    "Mus_musculus",
    "Homo_sapiens",
    "Saccharomyces_cerevisiae_S288c"
);

sub BUILD {
    my $self = shift;

    $self->set_sources([
        {
            SERVER => 'https://downloads.thebiogrid.org/BioGRID/Latest-Release/',
            FILE => 'BIOGRID-ORGANISM-LATEST.psi25.zip',

            CLEANER => sub {
                my $self = shift;
                my $file = $self->get_destination;
                my @args = ('unzip', $file, '-d', 
                    $self->get_destination_dir);
                $self->execute_system_command(@args);
                $self->debug("Removing original file: $file");
                unlink($file);
            },
        },
    ]);
}
