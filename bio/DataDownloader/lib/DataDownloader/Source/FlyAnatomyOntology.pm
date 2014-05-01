package DataDownloader::Source::FlyAnatomyOntology;

use Moose;
extends 'DataDownloader::Source::FtpBase';

use constant {
    TITLE  => 'Fly Anatomy Ontology',
    DESCRIPTION => "Drosophila Anatomy ontology from FlyBase",
    SOURCE_LINK => "http://www.flybase.net/",
    SOURCE_DIR => 'ontologies/fly-anatomy',
    SOURCES => [{
        SUBTITLE => 'Fly Anatomy',
        FILE   => 'fly_anatomy.obo.gz',
        HOST => 'ftp.flybase.net',
        REMOTE_DIR => "releases/current/precomputed_files/ontologies",
        EXTRACT => 1,
    }],
};

1;



