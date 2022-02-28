package DataDownloader::Source::pombe-gene;

use Moose;
extends 'DataDownloader::Source::ABC';

# Pombe gene details


use constant {
    TITLE       => 
        'Pombe gene details',
    DESCRIPTION => 
        "Pombe gene details",
    SOURCE_LINK => 
        "https://curation.pombase.org/",
    SOURCE_DIR => "dumps/latest_build/intermine_data",
    SOURCES => [{
        FILE   => 'pombemine_gene_details.gz',
        SERVER => 'https://curation.pombase.org/dumps/latest_build/intermine_data/',
	EXTRACT => 1,
    }],
};

1;
