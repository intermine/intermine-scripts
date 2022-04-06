package DataDownloader::Source::BioGRID;

use Moose;
extends 'DataDownloader::Source::ABC';
use LWP;
use LWP::Simple;

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
    "Saccharomyces_cerevisiae_S288c",
    "Schizosaccharomyces_pombe"
);

sub BUILD {
    my $self = shift;
    my $version = $self->get_version;
    my @files_to_extract = 
        map { 'BIOGRID-ORGANISM-' . $_ . '-' . $version . '.psi25.xml'} 
        ORGANISMS;

    $self->set_sources([
        {
            SERVER => 'https://downloads.thebiogrid.org/BioGRID/Release-Archive/BIOGRID-' . $version,
            FILE => 'BIOGRID-ORGANISM-' . $version . '.psi25.zip',

            CLEANER => sub {
                my $self = shift;
                my $file = $self->get_destination;
                my @args = ('unzip', $file, @files_to_extract, '-d', 
                    $self->get_destination_dir);
                $self->execute_system_command(@args);
                $self->debug("Removing original file: $file");
                unlink($file);
            },
        },
    ]);
}

sub generate_version {
    my $updated_version = get("https://webservice.thebiogrid.org/version/?accessKey=40a4a9dbb368884a0ce9041c64c121de");
    return $updated_version;
}
