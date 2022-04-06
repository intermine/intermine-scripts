package DataDownloader::Source::PombePhenotype;

use Moose;
extends 'DataDownloader::Source::ABC';

# Allele and phenotype data


use constant {
    TITLE       => 
        'Phenotypes',
    DESCRIPTION => 
        "Alleles and phenotypes",
    SOURCE_LINK => 
        "https://www.pombase.org/",
    SOURCE_DIR => "pombemine/phenotypes",
    SOURCES => [{
        FILE   => 'phenotype_annotations.pombase.phaf.gz',
        SERVER => 'https://www.pombase.org/data/annotations/Phenotype_annotations',
	EXTRACT => 1,
    }],
};

1;
