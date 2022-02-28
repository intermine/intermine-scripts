package DataDownloader::Source::pombe-cerevisae-orthologs;

use Moose;
extends 'DataDownloader::Source::ABC';

# S. cerevisiae orthologs 


use constant {
    TITLE       => 
        'S. cerevisiae orthologs',
    DESCRIPTION => 
        "S. cerevisiae orthologs",
    SOURCE_LINK => 
        "https://www.pombase.org/",
    SOURCE_DIR => "data/orthologs/",
    SOURCES => [{
        FILE   => 'cerevisiae-orthologs.txt',
        SERVER => 'https://www.pombase.org/data/orthologs/',
    }],
};

1;
