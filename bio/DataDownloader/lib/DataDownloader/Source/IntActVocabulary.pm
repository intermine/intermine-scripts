package DataDownloader::Source::IntActVocabulary;

use Moose;
extends 'DataDownloader::Source::ABC';

use constant {
    TITLE => 
        "IntAct Vocabulary",
    DESCRIPTION => 
        "A structured controlled vocabulary for the annotation of experiments concerned with protein-protein interactions.",
    SOURCE_LINK => 
        "http://obofoundry.org/cgi-bin/detail.cgi?id=psi-mi&title=Protein-protein%20interaction",
    SOURCE_DIR => "psi/ontology",
    SOURCES => [
        {
            FILE   => "psi-mi.obo",
            SERVER =>  "https://raw.githubusercontent.com/HUPO-PSI/psi-mi-CV/master/",
        }
    ],
};

1;
