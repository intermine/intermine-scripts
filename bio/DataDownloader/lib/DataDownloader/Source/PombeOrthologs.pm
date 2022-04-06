package DataDownloader::Source::PombeOrthologs;

use Moose;
extends 'DataDownloader::Source::ABC';

# S. cerevisiae and Human orthologs 


use constant {
    TITLE       => 
        'S. cerevisiae and Human orthologs',
    DESCRIPTION => 
        "S. cerevisiae and Human orthologs",
    SOURCE_LINK => 
        "https://www.pombase.org/",
    SOURCE_DIR => "pombemine/orthologues",
    SOURCES => [{
        FILE   => 'cerevisiae-orthologs.txt',
        SERVER => 'https://www.pombase.org/data/orthologs/',
    },
	{
        FILE   => 'human-orthologs.txt.gz',
        SERVER => 'https://www.pombase.org/data/orthologs/',
		EXTRACT => 1,
    }],
};

1;
