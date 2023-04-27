#!/bin/bash

source /home/afalcione/sourceme_gnu

HOME=${16}

YEAR_ANALYSIS=$1
MONTH_ANALYSIS=$2
DAY_ANALYSIS=$3
HOUR_ANALYSIS=$4
MINUTE_ANALYSIS=$5

YEAR_MIN=$6
MONTH_MIN=$7
DAY_MIN=$8
HOUR_MIN=$9
MINUTE_MIN=${10}

YEAR_MAX=${11}
MONTH_MAX=${12}
DAY_MAX=${13}
HOUR_MAX=${14}
MINUTE_MAX=${15}

# Download dati & Little_R creation
cd ${HOME}/OPER/assimilation
./preproc_conv.sh ${DAY_ANALYSIS} ${HOUR_ANALYSIS} ${HOME}
cp ${HOME}/OPER/assimilation/decodeObs/obs_little_r.dat ${HOME}/OPER/assimilation/obsproc/

# Obsproc
cd ${HOME}/OPER/assimilation/obsproc
./writeNamelistObsproc.sh ${YEAR_ANALYSIS} ${MONTH_ANALYSIS} ${DAY_ANALYSIS} ${HOUR_ANALYSIS} ${MINUTE_ANALYSIS} ${YEAR_MIN} ${MONTH_MIN} ${DAY_MIN} ${HOUR_MIN} ${MINUTE_MIN} ${YEAR_MAX} ${MONTH_MAX} ${DAY_MAX} ${HOUR_MAX} ${MINUTE_MAX}
./obsproc.exe

# Analysis update
cd ${HOME}/WRFDA/workdir/
./writeNamelistWRFDA.sh ${YEAR_ANALYSIS} ${MONTH_ANALYSIS} ${DAY_ANALYSIS} ${HOUR_ANALYSIS} ${MINUTE_ANALYSIS} ${YEAR_MIN} ${MONTH_MIN} ${DAY_MIN} ${HOUR_MIN} ${MINUTE_MIN} ${YEAR_MAX} ${MONTH_MAX} ${DAY_MAX} ${HOUR_MAX} ${MINUTE_MAX}
ln -sf ${HOME}/WRFv4.4.2/run/wrfinput_d01 fg
ln -sf ${HOME}/OPER/assimilation/obsproc/obs_gts_${YEAR_ANALYSIS}-${MONTH_ANALYSIS}-${DAY_ANALYSIS}_${MINUTE_ANALYSIS}:00:00.3DVAR ob.ascii
mpirun -np 64 ./da_wrfvar.exe

# Boundary update
cd ${HOME}/WRFDA/workdir/bdy
cp ${HOME}/WRFDA/workdir/wrfvar_output ${HOME}/WRFDA/workdir/bdy
cp ${HOME}/WRFv4.4.2/run/wrfbdy_d01 ${HOME}/WRFv4.4.2/run/wrfbdy_d01_noDA
cp ${HOME}/WRFv4.4.2/run/wrfinput_d01 ${HOME}/WRFv4.4.2/run/wrfinput_d01_noDA
mv ${HOME}/WRFv4.4.2/run/wrfbdy_d01 ${HOME}/WRFDA/workdir/bdy
mv ${HOME}/WRFv4.4.2/run/wrfinput_d01 ${HOME}/WRFDA/workdir/bdy
./writeNamelistWRFDAbdy.sh
./da_update_bc.exe

# Move updated files to WRF input files
mv ${HOME}/WRFDA/workdir/bdy/wrfbdy_d01 ${HOME}/WRFv4.4.2/run/wrfbdy_d01
mv ${HOME}/WRFDA/workdir/bdy/wrfvar_output ${HOME}/WRFv4.4.2/run/wrfinput_d01

