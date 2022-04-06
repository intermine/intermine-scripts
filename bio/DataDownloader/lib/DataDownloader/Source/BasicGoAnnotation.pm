package DataDownloader::Source::BasicGoAnnotation;

use Moose;
extends 'DataDownloader::Source::ABC';

# Gene ontology anotation

use constant {
    TITLE => "GO Annotation",
    DESCRIPTION => "Gene Ontology Assignments from Uniprot and the Gene Ontology Site",
    SOURCE_LINK => "http://www.geneontology.org",
    SOURCE_DIR => "pombemine/go-annotation",
    SOURCES => [{
        SERVER     => "http://purl.obolibrary.org/obo/go",
        FILE       => "go-basic.obo",
    }],
};

1;
