package DataDownloader::Source::PombeFasta;

use Moose;
extends 'DataDownloader::Source::ABC';

# Pombe fasta sequences


use constant {
    TITLE       => 
        'Pombe fasta',
    DESCRIPTION => 
        "Pombe fasta",
    SOURCE_LINK => 
        "https://www.pombase.org/",
    SOURCE_DIR => "data/genome_sequence_and_features/genome_sequence/",
    SOURCES => [{
        FILE   => 'Schizosaccharomyces_pombe_all_chromosomes.fa.gz',
        SERVER => 'https://www.pombase.org/data/genome_sequence_and_features/genome_sequence/',
	EXTRACT => 1,
    }],
};

1;
