package DataDownloader::Source::MondoOntology;

use Moose;
extends 'DataDownloader::Source::ABC';

# mondo ontology


use constant {
    TITLE       => 
        'Mondo Ontology',
    DESCRIPTION => 
        "Mondo Ontology",
    SOURCE_LINK => 
        "http://purl.obolibrary.org/",
    SOURCE_DIR => "pombemine/mondo",
    SOURCES => [{
        FILE   => 'mondo.obo',
        SERVER => 'http://purl.obolibrary.org/obo',
                },

        ],
};

1;
