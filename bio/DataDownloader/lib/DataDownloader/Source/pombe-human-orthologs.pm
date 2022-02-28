package DataDownloader::Source::pombe-human-orthologs;

use Moose;
extends 'DataDownloader::Source::ABC';

# Human orthologs 


use constant {
    TITLE       => 
        'Human orthologs',
    DESCRIPTION => 
        "Human orthologs",
    SOURCE_LINK => 
        "https://www.pombase.org/",
    SOURCE_DIR => "data/orthologs/",
    SOURCES => [{
        FILE   => 'human-orthologs.txt.gz',
        SERVER => 'https://www.pombase.org/data/orthologs/',
	EXTRACT => 1,
    }],
};

1;
