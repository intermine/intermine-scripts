package DataDownloader::Source::FlyAnatomyOntology;

use Moose;
extends 'DataDownloader::Source::ABC';

use constant {
    TITLE  => 'Fly Anatomy Ontology',
    DESCRIPTION => "Drosophila Anatomy ontology from FlyBase",
    SOURCE_LINK => "http://www.flybase.net/",
    SOURCE_DIR => 'ontologies/fly-anatomy',
    SOURCES => [{
        FILE   => 'fly_anatomy.obo.gz',
        HOST => 'ftp.flybase.net',
        REMOTE_DIR => "releases/current/precomputed_files/ontologies",
        EXTRACT => 1,
    }],
};

1;
