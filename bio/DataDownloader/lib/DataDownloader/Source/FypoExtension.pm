package DataDownloader::Source::FypoExtension;

use Moose;
extends 'DataDownloader::Source::ABC';

# fypo extension ontology


use constant {
    TITLE       => 
        'fypo extension ontology',
    DESCRIPTION => 
        "fypo extension ontology",
    SOURCE_LINK => 
        "https://curation.pombase.org/",
    SOURCE_DIR => "dumps/latest_build/pombe-embl/mini-ontologies",
    SOURCES => [{
        FILE   => 'fypo_extension.obo',
        SERVER => 'https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/',
		},

	],
};

1;
