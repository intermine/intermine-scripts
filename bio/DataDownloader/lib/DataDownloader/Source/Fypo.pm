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
    SOURCE_DIR => "pombemine/phenotypes/ontologies",
    SOURCES => [{
        FILE   => 'fypo-simple-pombase.obo',
        SERVER => 'https://raw.githubusercontent.com/pombase/fypo/master',
		},
		{	
        FILE   => 'fyeco.obo',
        SERVER => 'https://raw.githubusercontent.com/pombase/fypo/master',
		},
		{
        FILE   => 'fypo_extension.obo',
        SERVER => 'https://curation.pombase.org/dumps/latest_build/pombe-embl/mini-ontologies/',
		},

	],
};

1;
