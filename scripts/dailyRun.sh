#!/bin/bash

ulimit -s unlimited

source /home/afalcione/sourceme_intel 

HOME=/home/afalcione

YearStart=$(date -d "now" +"%Y")
MonthStart=$(date -d "now" +"%m")
DayStart=$(date -d "now" +"%d")
HourStart=00
YearEnd=$(date -d "now + 48 hour" +"%Y")
MonthEnd=$(date -d "now + 48 hour" +"%m")
DayEnd=$(date -d "now + 48 hour" +"%d")
HourEnd=00
nCPU=18

echo 'Start: ' $YearStart $MonthStart $DayStart $HourStart 'End: ' $YearEnd $MonthEnd $DayEnd $HourEnd

# Download dati
cd ${HOME}/OPER/input
rm -f gfs*
rm -r wget-log*
./downloadDataGFS.sh $YearStart $MonthStart $DayStart $HourStart

# Namelist WRF
cd ${HOME}/OPER
./writeNamelistWPS.sh $HOME $YearStart $MonthStart $DayStart $HourStart $YearEnd $MonthEnd $DayEnd $HourEnd
./writeNamelistInput.sh $HOME $YearStart $MonthStart $DayStart $HourStart $YearEnd $MonthEnd $DayEnd $HourEnd

# WPS
cd ${HOME}/WPSv4.4
./geogrid.exe
rm -f GRIBFILE* 
./link_grib.csh ${HOME}/OPER/input/gfs*
rm -f FILE*
./ungrib.exe
rm -f met_em*
./metgrid.exe
cd ${HOME}/WRFv4.4.2/run
rm -f met_em*
ln -s ${HOME}/WPSv4.4/met_em* .

# WRF
rm -f wrfinput*
rm -f wrfbdy*
mpirun -np ${nCPU} ./real.exe
# WRFDA ########################
DateInit=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}")
YearAnalysis=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}" +"%Y")
MonthAnalysis=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}" +"%m")
DayAnalysis=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}" +"%d")
HourAnalysis=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}" +"%H")
MinuteAnalysis=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}" +"%M")
YearMin=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} - 30 minutes" +"%Y")
MonthMin=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} - 30 minutes" +"%m")
DayMin=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} - 30 minutes" +"%d")
HourMin=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} - 30 minutes" +"%H")
MinuteMin=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} - 30 minutes" +"%M")
YearMax=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} + 30 minutes" +"%Y")
MonthMax=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} + 30 minutes" +"%m")
DayMax=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} + 30 minutes" +"%d")
HourMax=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} + 30 minutes" +"%H")
MinuteMax=$(date -d "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart} + 30 minutes" +"%M")
#cd ${HOME}/assimilation
#./run3DvarConv.sh ${YearAnalysis} ${MonthAnalysis} ${DayAnalysis} ${HourAnalysis} ${MinuteAnalysis} ${YearMin} ${MonthMin} ${DayMin} ${HourMin} ${MinuteMin} ${YearMax} ${MonthMax} ${DayMax} ${HourMax} ${MinuteMax} ${HOME}
################################
cd ${HOME}/WRFv4.4.2/run
mpirun -np ${nCPU} ./wrf.exe
rm -f ${HOME}/OPER/output/wrfout*
mv wrfout* ${HOME}/OPER/output
mkdir ${HOME}/OPER/archive/${YearAnalysis}-${MonthAnalysis}-${DayAnalysis}_${HourAnalysis}
cp ${HOME}/OPER/output/wrfout* ${HOME}/OPER/archive/${YearAnalysis}-${MonthAnalysis}-${DayAnalysis}_${HourAnalysis}

# Plot
rm -f ${HOME}/OPER/plots/*.jpg
cd ${HOME}/OPER/plots
./plotParallel.sh "${HourStart}:00:00 ${YearStart}-${MonthStart}-${DayStart}"

# Git
cd ${HOME}/OPER
./gitUpdate.sh

exit
