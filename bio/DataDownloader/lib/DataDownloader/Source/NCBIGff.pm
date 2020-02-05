package DataDownloader::Source::NCBIGff;

use Moose;
extends 'DataDownloader::Source::FtpBase';


use constant {
    TITLE => "NCBI Gene ",
    DESCRIPTION => "GFF from NCBI",
    SOURCE_LINK => "ftp.ncbi.nih.gov",
    SOURCE_DIR => "human/gff",
    SOURCES => [{
        FILE => "GCF_000001405.39_GRCh38.p13_genomic.gff.gz", 
        HOST => "ftp.ncbi.nih.gov",
        REMOTE_DIR => "genomes/H_sapiens/current/GCF_000001405.39_GRCh38.p13",
        EXTRACT => 1,
    }],
};

1;
