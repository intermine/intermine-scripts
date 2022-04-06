package DataDownloader::Source::PombeGoAnnotation;

use Moose;
extends 'DataDownloader::Source::ABC';

# Gene ontology anotation


use constant {
    TITLE       => 
        'Gene Ontology annotation',
    DESCRIPTION => 
        "Gene Ontology anotation",
    SOURCE_LINK => 
        "https://curation.pombase.org/",
    SOURCE_DIR => "pombemine/pombe-go-annotation",
    SOURCES => [{
        FILE   => 'pombase-latest.gaf.gz',
        SERVER => 'https://curation.pombase.org/dumps/latest_build/',
		EXTRACT => 1,
    }],
};

1;
