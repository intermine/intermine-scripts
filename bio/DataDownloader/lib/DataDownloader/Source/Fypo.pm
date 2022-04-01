package DataDownloader::Source::Fypo;

use Moose;
extends 'DataDownloader::Source::ABC';

# ontologies for the phenotype source


use constant {
    TITLE       => 
        'Phenotype ontologies',
    DESCRIPTION => 
        "Phenotype ontologies",
    SOURCE_LINK => 
        "https://github.com/pombase/",
    SOURCE_DIR => "fypo",
    SOURCES => [{
        FILE   => 'fypo-simple-pombase.obo',
        SERVER => 'https://github.com/pombase/fypo',
		},
	{	
        FILE   => 'fyeco.obo',
        SERVER => 'https://github.com/pombase/fypo',
		},

	],
};

1;
