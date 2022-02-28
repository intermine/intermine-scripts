package DataDownloader::Source::mondo-ontology;

use Moose;
extends 'DataDownloader::Source::ABC';

# mondo ontology


use constant {
    TITLE       => 
        'mondo ontology',
    DESCRIPTION => 
        "mondo ontology",
    SOURCE_LINK => 
        "http://purl.obolibrary.org/",
    SOURCE_DIR => "obo",
    SOURCES => [{
        FILE   => 'mondo.obo',
        SERVER => 'http://purl.obolibrary.org/obo/mondo.obo',
                },

        ],
};

1;
