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

# Download dati
cd ${HOME}/DATA
rm -f gfs*
rm -r wget-log*
./downloadDataGFS.sh $YearStart $MonthStart $DayStart $HourStart

# Namelist
cd ${HOME}
./writeNamelistWPS.sh $YearStart $MonthStart $DayStart $HourStart $YearEnd $MonthEnd $DayEnd $HourEnd
./writeNamelistInput.sh $YearStart $MonthStart $DayStart $HourStart $YearEnd $MonthEnd $DayEnd $HourEnd

# WPS
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

# WRF
rm -f wrfinput*
rm -f wrfbdy*
mpirun -np 64 ./real.exe
# WRFDA ########################
DateInit=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}")
YearAnalysis=$(date -d "$DateInit" +"%Y")
MonthAnalysis=$(date -d "$DateInit" +"%m")
DayAnalysis=$(date -d "$DateInit" +"%d")
HourAnalysis=$(date -d "$DateInit" +"%H")
MinuteAnalysis=$(date -d "$DateInit" +"%M")
YearMin=$(date -d "$DateInit - 30 minutes" +"%Y")
MonthMin=$(date -d "$DateInit - 30 minutes" +"%m")
DayMin=$(date -d "$DateInit - 30 minutes" +"%d")
HourMin=$(date -d "$DateInit - 30 minutes" +"%H")
MinuteMin=$(date -d "$DateInit - 30 minutes" +"%M")
YearMax=$(date -d "$DateInit + 30 minutes" +"%Y")
MonthMax=$(date -d "$DateInit + 30 minutes" +"%m")
DayMax=$(date -d "$DateInit + 30 minutes" +"%d")
HourMax=$(date -d "$DateInit + 30 minutes" +"%H")
MinuteMax=$(date -d "$DateInit + 30 minutes" +"%M")
cd ${HOME}/assimilation
./run3DvarConv.sh ${YearAnalysis} ${MonthAnalysis} ${DayAnalysis} ${HourAnalysis} ${MinuteAnalysis} ${YearMin} ${MonthMin} ${DayMin} ${HourMin} ${MinuteMin} ${YearMax} ${MonthMax} ${DayMax} ${HourMax} ${MinuteMax}
################################
cd ${HOME}/WRF/WRFv4.4.2/run
mpirun -np 64 ./wrf.exe
rm -f ${HOME}/out/wrfout*
mv wrfout* ${HOME}/out
mkdir ${HOME}/DATA/archive/${YearAnalysis}-${MonthAnalysis}-${DayAnalysis}_${HourAnalysis}
cp ${HOME}/out/wrfout* ${HOME}/DATA/archive/${YearAnalysis}-${MonthAnalysis}-${DayAnalysis}_${HourAnalysis}

# Plot
rm -f ${HOME}/plots/*.jpg
cd ${HOME}/plots
./plotParallel.sh "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}"

# Git
cd ${HOME}
./gitUpdate.sh

exit
