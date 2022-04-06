package DataDownloader::Source::Mondo;

use Moose;
extends 'DataDownloader::Source::ABC';

# Mondo disease anotation


use constant {
    TITLE       => 
        'Mondo disease annotation',
    DESCRIPTION => 
        "Mondo disease anotation",
    SOURCE_LINK => 
        "https://curation.pombase.org/",
    SOURCE_DIR => "pombemine/disease",
    SOURCES => [{
        FILE   => 'disease_association.tsv',
        SERVER => 'https://curation.pombase.org/dumps/latest_build/misc/',
    }],
};

1;
