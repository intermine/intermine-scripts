package DataDownloader::Source::InterProGO;

use Moose;
extends 'DataDownloader::Source::ABC';

use constant {
    TITLE => "InterPro GO",
    DESCRIPTION => "Gene Annotation from InterPro",
    SOURCE_LINK => "http://www.geneontology.org",
    SOURCE_DIR => "interpro/ontology",
    SOURCES => [
        {
            URI => "ftp://ftp.ebi.ac.uk/pub/databases/interpro/current/",
            FILE => "interpro2go",
        },
    ],
};

1;


