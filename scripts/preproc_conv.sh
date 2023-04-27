#!/bin/bash

source /home/afalcione/sourceme_gnu

HOME=/home/afalcione

DAY=$1
ANALYSIS_HOUR=$2
HOME=$3

cd ${HOME}/OPER/assimilation/decodeObs/SYNOP
rm *.TXT
wget -r  http://magritte.aquila.infn.it/~ecmwf/obs/synop/ --user=meteora --password="&cmwf8" -A *${DAY}${ANALYSIS_HOUR}*.TXT -nc -np -nd -e robots=off

LISTA=`ls S*`
for FILE in $LISTA 
do
tr -d "\015" <$FILE> new_$FILE
rm -f $FILE
done
echo " PRESI DATI --------->  SYNOP " 

cd ${HOME}/OPER/assimilation/decodeObs/TEMP
rm *.TXT
wget -r  http://magritte.aquila.infn.it/~ecmwf/obs/temp/ --user=meteora --password="&cmwf8" -A *${DAY}${ANALYSIS_HOUR}*.TXT -nc -np -nd -e robots=off

LISTA=`ls U*`
for FILE in $LISTA 
do
tr -d "\015" <$FILE> land_$FILE
rm -f $FILE
done
echo " PRESI DATI --------->  TEMP "

#echo "########################################### " 
#echo " ... ftp in corso dei TEMP di mare "  
#echo "######################################### " 
#wget -r  http://magritte.aquila.infn.it/~ecmwf/obs/syrep/ --user=meteora --password="&cmwf8" -A*${DAY_P}00*.TXT -nc -np -nd -e robots=off
#LISTA=`ls S*`
#for FILE in $LISTA 
#do
#
#tr -d "\015" <$FILE> new_$FILE
#rm -f $FILE
#done
#    #
#echo "################################### " 
#echo " PRESI DATI --------->  TEMP " 
#echo "----------------------------------------------- " 

# Preparazione osservazioni da raw a little_r (per obsproc)
cd ${HOME}/OPER/assimilation/decodeObs
rm -f obs_little_r.dat
./AAXX_all.deck >! out_synop
./TTAAdec_allNCEP.deck >! out_TEMP
echo ' fatto obs_little_r.dat'
