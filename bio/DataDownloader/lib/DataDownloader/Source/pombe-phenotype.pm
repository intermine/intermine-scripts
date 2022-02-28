package DataDownloader::Source::pombe-phenotype;

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
    SOURCE_DIR => "downloads/phenotype-annotations",
    SOURCES => [{
        FILE   => 'phenotype_annotations.pombase.phaf.gz',
        SERVER => 'https://www.pombase.org/downloads/phenotype-annotations',
	EXTRACT => 1,
    }],
};

1;
