#!/bin/bash

ulimit -s unlimited

source /home/disco4/afalcione/sourcem_intel_23.sh 

HOME=/home/disco4/afalcione/OPER

YearStart=$(date -d "now" +"%Y")
MonthStart=$(date -d "now" +"%m")
DayStart=$(date -d "now" +"%d")
HourStart=00
YearEnd=$(date -d "now + 48 hour" +"%Y")
MonthEnd=$(date -d "now + 48 hour" +"%m")
DayEnd=$(date -d "now + 48 hour" +"%d")
HourEnd=00

echo 'Start: ' $YearStart $MonthStart $DayStart $HourStart 'End: ' $YearEnd $MonthEnd $DayEnd $HourEnd

cd ${HOME}/DATA
rm -f gfs*
rm -r wget-log*
./downloadDataGFS.sh $YearStart $MonthStart $DayStart $HourStart

cd ${HOME}
./writeNamelistWPS.sh $YearStart $MonthStart $DayStart $HourStart $YearEnd $MonthEnd $DayEnd $HourEnd

./writeNamelistInput.sh $YearStart $MonthStart $DayStart $HourStart $YearEnd $MonthEnd $DayEnd $HourEnd

cd ${HOME}/WRF/WPSv4.4

./geogrid.exe

rm -f GRIBFILE* 
./link_grib.csh ${HOME}/DATA/gfs*

rm -f FILE*
./ungrib.exe

rm -f met_em*
./metgrid.exe

cd ${HOME}/WRF/WRFv4.4.2/run

rm -f met_em*
ln -s ${HOME}/WRF/WPSv4.4/met_em* .

rm -f wrfinput*
rm -f wrfbdy*
mpirun -np 100 ./real.exe

rm -f wrfout*
#/opt/intel/oneapi/mpi/2021.8.0/bin/mpirun
mpirun -np 100 ./wrf.exe


rm -f ${HOME}/out/wrfout*
mv wrfout* ${HOME}/out

rm -f ${HOME}/plots/*.jpg
cd ${HOME}/plots
./plotParallel.sh "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}"

cd ${HOME}
./gitUpdate.sh

exit
