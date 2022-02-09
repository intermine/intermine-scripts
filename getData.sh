#!/bin/bash
#
# usage: getData.sh          batch mode updates
#        getData.sh -F       batch mode, only Flybase
#        getData.sh -i       interactive (step by step) mode
#
# sc

# TODO
#       exit if wrong switchs combination!
#
#       BDGP : - add switch?
#              - currently using mysql db in modalone! setup mysql in mega3
#       NCBIfasta: - mirror?
#                  - gzip must check files integrity first/retry
#       prot2Dom: mirror?


# default settings: edit with care
INTERACT=n       # y: step by step interaction
DD=n             # y: run the download script?
FB=n             # y: get FB files and build FB db
UP=y             # n: don't run various updates and downloads
DBHOST=localhost # you can enter a different server


DATADIR=/micklem/data

CODEDIR=/data/code
SHDIR=$CODEDIR/intermine-scripts

progname=$0

function usage () {
	cat <<EOF

Usage:
$progname [-F] [-f] [d] [u] [-i] [-h] [-S server]
  -F: get ONLY flybase sources
  -f: get flybase sources
  -d: run DataDownloader
  -u: run various updates and loads (default)
  -i: interactive mode
  -S: choose the database server (default localhost)
  -h: display this help

examples:

$progname                run updates/loads, no questions, no Flybase and DataDownloader
$progname -d             as above, but run of DataDownloader
$progname -i             interactive version (source by source), default setting
$progname -if            interactive version (source by source), including flybase sources
$progname -iF            interactive version, get only flybase sources
$progname -ifd           interactive version, including running DataDownloader and flybase sources
$progname -ifdu          same as -ifd

$progname -S mega3       use mega3 as the database server

EOF
	exit 0
}


while getopts "dFfiS:uh" opt; do
   case $opt in
        f )  echo "| - Get FLYBASE data       |" ; FB=y;;
        d )  echo "| - Run DataDownloader     |" ; DD=y;;
        u )  echo "| - update and get sources |" ; UP=y;;
	i )  echo "| - Interactive mode       |" ; INTERACT=y;;
        F )  echo "| - get ONLY FLYBASE data  |" ; FB=y; DD=n; UP=n;;
      	S )  DBHOST=$OPTARG; echo "- Using database server $DBHOST";;
        h )  usage ;;
	    \?)  usage ;;
   esac
done

shift $(($OPTIND - 1))

echo


function interact {
# if in interactive mode, wait here before continuing
if [ $INTERACT = "y" ]
then
echo "$1"
echo "Press return to continue (^C to exit).."
echo -n "->"
read
fi
}

function interacts {
# s will skip current step and go to the next
if [ $INTERACT = "y" ]
then
echo; echo "$1"
echo "Press s to skip this step, return to continue (^C to exit).."
echo -n "->"
read
fi
}



function getSources {
#
# get sources not in the DataDownloader
#

if [ $INTERACT = "y" ]
then
  interacts "Get human FASTA please"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "running getNCBIfasta.."
		getNCBIfasta
	else
		echo "skipping.."
	fi
else
  echo "running getNCBIfasta.."
  getNCBIfasta
fi

if [ $INTERACT = "y" ]
then
  interacts "Get human GFF please"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "running getNCBIgff.."
		getNCBIgff
	else
		echo "skipping.."
	fi
else
  echo "running getNCBIgff.."
  getNCBIgff
fi


if [ $INTERACT = "y" ]
then
  interacts "Update NCBI (add ensembl IDs)"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "running updateNCBI.."
		updateNCBI
	else
		echo "skipping.."
	fi
else
  echo "running updateNCBI.."
  updateNCBI
fi

if [ $INTERACT = "y" ]
then
  interacts "Get gene summaries"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "running get_refseq_summaries.py.."
		getGeneSummaries
	else
		echo "skipping.."
	fi
else
		echo "running get_refseq_summaries.py.."
		getGeneSummaries

fi

if [ $INTERACT = "y" ]
then
  interacts "Get protein to domain data, takes a long time!"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "getting data.."
		getProt2Dom
	else
		echo "skipping.."
	fi
else
		echo "getting data.."
		getProt2Dom
fi


if [ $INTERACT = "y" ]
then
  interacts "Get phenotype annotation (HPO)"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "getting HPO.."
		getHPO
	else
		echo "skipping.."
	fi
else
        echo "getting HPO.."
		getHPO
fi

echo "-----------------------------------------------------"
echo

}

function getFlySources {
# get the data for flymine
#
#

if [ $INTERACT = "y" ]
then
  interacts "Get FlyBase please"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "running getFB.."
		getFB
	else
		echo "skipping.."
	fi
else
  echo "running getFB.."
  getFB
fi


if [ $INTERACT = "y" ]
then
  interacts "Get BDGP please"

  if [ $REPLY -a $REPLY != 's' ]
	then
		echo "running getBDGP.."
		getBDGP
	else
		echo "skipping.."
	fi
else
  echo "running getBDGP.."
  getBDGP
fi


}



function updateNCBI {

cd $SHDIR

echo "Running perl script adding ensembl ids..."
./bio/humanmine/ncbi-update.pl

WDIR=$DATADIR/ncbi/current

if [ -s "/tmp/renamed-ncbi.txt" ]
then
mv "/tmp/renamed-ncbi.txt" "$WDIR/All_Data.gene_info"
echo "NCBI Gene updated!"
else
echo "ERROR, please check $WDIR"
fi
}

function getGeneSummaries {

WDIR=$DATADIR/ncbi/gene-summaries

cd $WDIR

NOW=`date "+%Y-%m-%d"`
mkdir $NOW

rm current
ln -s $NOW current

cd $SHDIR

FIN=$DATADIR/ncbi/gene-info-human/current/Homo_sapiens.gene_info
FOUT=$WDIR/current/gene_summaries.txt

echo "Running python script getting gene summaries..."
./bio/get_refseq_summaries.py $FIN $FOUT

}

function getProt2Dom {
# using wget -t 0 to set retry number to no limit
# TODO: add a wget -c -t 0 if interruption happens

WDIR=$DATADIR/interpro/match_complete

cd $WDIR

NOW=`date "+%Y-%m-%d"`
mkdir $NOW

rm current
ln -s $NOW current

cd current

F1=ftp.ebi.ac.uk/pub/databases/interpro/current/match_complete.xml.gz
F2=ftp.ebi.ac.uk/pub/databases/interpro/current/protein2ipr.dat.gz

echo "Getting match_complete file from interpro..."
wget -t 0 $F1

echo "Getting protein2ipr file from interpro..."
wget -t 0 $F2

echo "Expanding files.."
gzip -d *.gz

ls -la

}

function getNCBIfasta {

WDIR=/micklem/data/human/fasta

cd $WDIR

URI1="ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/"
URI2="Homo_sapiens/reference/GCF_000001405.39_GRCh38.p13/"
URI3="GCF_000001405.39_GRCh38.p13_assembly_structure/Primary_Assembly"

# we assume these always change

NOW=`date "+%Y-%m-%d"`
mkdir $NOW
cd $NOW
wget "$URI1$URI2$URI3"/assembled_chromosomes/FASTA/*
gzip -d *

cd $WDIR

rm current

ln -s $NOW current

echo "NCBI fasta updated!"
}

function getNCBIgff {

WDIR=/micklem/data/human/gff

cd $WDIR

URI1="ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/"
URI2="Homo_sapiens/reference/GCF_000001405.39_GRCh38.p13/"
FILE="GCF_000001405.39_GRCh38.p13_genomic.gff.gz"

# to check if there is change
B4=`stat $FILE | grep Change`

wget -N "$URI1$URI2$FILE"

A3=`stat $FILE | grep Change`

if [ "$B4" != "$A3" ]
then

NOW=`date "+%Y-%m-%d"`
mkdir $NOW
cp $FILE $NOW
gzip -d $NOW/$FILE

rm current

ln -s $NOW current

echo "NCBI Gene updated!"
else
echo "NCBI Gene was already up to date, not retrieved."
fi
}



function getBDGP {
# WORKING on modalone
# TODO mv to mega3 (setup mysql)

BDGPDIR=/micklem/data/flymine/bdgp-insitu

cd $BDGPDIR/mysql

# to check if there is change
B4=`stat insitu.sql.gz | grep Change`

wget -N https://insitu.fruitfly.org/insitu-mysql-dump/insitu.sql.gz

A3=`stat insitu.sql.gz | grep Change`

if [ "$B4" != "$A3" ]
then
# cp, expand and load into mysql, query and update annotation file

NOW=`date "+%Y%m%d"`
mkdir $NOW
cp insitu.sql.gz $NOW
gzip -d $NOW/insitu.sql.gz

#create db
mysql -u flymine -p -e "CREATE DATABASE bdgp$NOW;"

# load 30 mins?
mysql -u flymine bdgp$NOW < $BDGPDIR/$NOW/insitu.sql

# run query
# TODO: change mysql conf to allow dumping of files in BDGP dir

EXPDIR="/var/lib/mysql-files/"

QUERY="select distinct g.gene_id, a.stage, i.image_path, t.go_term \
from main g, image i, annot a, annot_term j, term t \
where g.id = a.main_id and a.id = i.annot_id and g.gene_id LIKE 'CG%' \
and a.id = j.annot_id and j.term_id = t.id \
into outfile '$EXPDIR/bdgp-mysql.out';"

# a few secs
mysql -u flymine -d bdgp$NOW -e "$QUERY"

mkdir $BDGPDIR/$NOW

cp $EXPDIR/bdgp-mysql.out $BDGPDIR/$NOW

cd $BDGPDIR
rm current

ln -s $NOW current

echo "$BDGPDIR/$NOW updated!"

else
echo "BDGP has not been updated."
fi
}

function getHPO {

WDIR=/micklem/data/hpo
CFLAG="n"

cd $WDIR

URI1="http://compbio.charite.de/jenkins/job/hpo.annotations"
URI2="/lastStableBuild/artifact/misc"

cd mirror

# to check if there is change
B4=`stat phenotype_annotation.tab | grep Change`
wget -N $URI1$URI2/phenotype_annotation.tab
A3=`stat phenotype_annotation.tab | grep Change`

if [ "$B4" != "$A3" ]
then
CFLAG="y"
fi

B4=`stat phenotype_annotation_negated.tab | grep Change`
wget -N $URI1$URI2/phenotype_annotation.tab
A3=`stat phenotype_annotation_negated.tab | grep Change`

if [ "$B4" != "$A3" ]
then
CFLAG="y"
fi


if [ "$CFLAG" = "y" ]
then
# cp and expand

NOW=`date "+%Y%m%d"`
mkdir $NOW
cp $FILE $NOW
gzip -d $NOW/$FILE

rm current

ln -s $NOW current

echo "HPO: gene updated!"
else
echo "HPO: gene has not been updated."
fi
}

function getFB {

FBDIR=/micklem/data/flybase

cd $FBDIR

# saving previous downloads for the moment
NOW=`date "+%Y-%m-%d"`
mkdir $NOW

cd $NOW

# ~15 mins
wget ftp://ftp.flybase.net/releases/current/psql/*

# TODO: check md5?

# old version, keeping FB version number in postgres
#FB=`grep createdb README | cut -d' ' -f5`
#createdb -h localhost -U flymine $FB
#cat FB* | gunzip | psql -h mega2 -U flymine -d $FB

# create new fb db
# keeping a constant name (flybase) for the build properties

echo "Dropping old flybase.."
dropdb -h  $DBHOST -U flymine flybaseprevious

echo "Renaming last flybase.."
psql -h $DBHOST -d items-flymine -U flymine -c "alter database flybase rename to flybaseprevious;"

echo "Creating new flybase.."
createdb -h $DBHOST -U flymine flybase

echo "..and loading it (long, ~10h)"

# load - long ~10h?
cat FB* | gunzip | psql -h $DBHOST -U flymine -d flybase

# do the vacuum (analyse) (new step, check if it improves build times)
# it increases db size (then get back again) check if worth it. long: 9h!
#vacuumdb -f -z -v -h mega2 -U flymine -d $FB

}


function donothing {
echo "Just printing..."
}


function runDataDownloader {

  cd $CODEDIR/intermine-scripts/bio/DataDownloader
  echo "running DataDownloader.."
  perl bin/download_data -e intermine


}



#############
# main..
#############

if [ $DD = "y" ]
then
   interact "Running DataDownloader.."
   runDataDownloader
fi

if [ $UP = "y" ]
then
  interact "Update sources (NCBI, protein domanins, HPO)"
  getSources
fi

if [ $FB = "y" ]
then
  interact "Update FlyBase and BDGP"
  getFlySources
fi

echo "bye!"

exit;
