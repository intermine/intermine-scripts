package DataDownloader::Source::EcoAnnotation;

use Moose;
extends 'DataDownloader::Source::ABC';

# Gene ontology anotation

use constant {
    TITLE => "ECO Annotation",
    DESCRIPTION => "Evidence & Conclusion Ontology (ECO) ",
    SOURCE_LINK => "https://evidenceontology.org/",
    SOURCE_DIR => "eco",
    SOURCES => [{
        SERVER     => "https://raw.githubusercontent.com/evidenceontology/evidenceontology/master",
        FILE       => "eco.obo",
    }],
};

1;
