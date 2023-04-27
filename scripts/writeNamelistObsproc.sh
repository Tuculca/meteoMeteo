#!/bin/bash

HOME=/home/disco4/afalcione/OPER

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


echo 'Writing namelist.obsproc'

cat << End_Of_Namelist8 | sed -e 's/#.*//; s/  *$//' > ${HOME}/assimilation/obsproc/namelist.obsproc
&record1
obs_gts_filename = '$HOME/assimilation/obsproc/obs_little_r.dat',
obs_err_filename = '$HOME/assimilation/obsproc/obserr.txt',
/
&record2
time_window_min  = ${YEAR_MIN}-${MONTH_MIN}-${DAY_MIN}_${HOUR_MIN}:${MINUTE_MIN}:00.0000,
time_analysis    = ${YEAR_ANALYSIS}-${MONTH_ANALYSIS}-${DAY_ANALYSIS}_${HOUR_ANALYSIS}:${MINUTE_ANALYSIS}:00.0000,
time_window_max  = ${YEAR_MAX}-${MONTH_MAX}-${DAY_MAX}_${HOUR_MAX}:${MINUTE_MAX}:00.0000,
/
&record3
max_number_of_obs        = 400000,
fatal_if_exceed_max_obs  = .TRUE.,
/
&record4
qc_test_vert_consistency = .TRUE.,
qc_test_convective_adj   = .TRUE.,
qc_test_above_lid        = .TRUE.,
remove_above_lid         = .TRUE.,
domain_check_h           = .true.,
Thining_SATOB            = false,
Thining_SSMI             = false,
Thining_QSCAT            = false,
/
&record5
print_gts_read           = .TRUE.,
print_gpspw_read         = .TRUE.,
print_recoverp           = .TRUE.,
print_duplicate_loc      = .TRUE.,
print_duplicate_time     = .TRUE.,
print_recoverh           = .TRUE.,
print_qc_vert            = .TRUE.,
print_qc_conv            = .TRUE.,
print_qc_lid             = .TRUE.,
print_uncomplete         = .TRUE.,
/
&record6
ptop =  10000.0,
base_pres       = 100000.0,
base_temp       = 290.0,
base_lapse      = 50.0,
base_strat_temp = 215.0,
/
&record7
IPROJ = 1,
PHIC  = 41.916,
XLONC = 12.47,
TRUELAT1= 41.916,
TRUELAT2= 41.916,
MOAD_CEN_LAT = 41.916,
STANDARD_LON = 12.47,
/
&record8
IDD    =   1,
MAXNES =   1,
NESTIX =  379,  200,  136,  181,  211,
NESTJX =  431,  200,  181,  196,  211,
DIS    =  3.,  10.,  3.3,  1.1,  1.1,
NUMC   =    1,    1,   2,     3,    4,
NESTI  =    1,   40,  28,    35,   45,
NESTJ  =    1,   60,  25,    65,   55,
/
&record9
PREPBUFR_OUTPUT_FILENAME = 'prepbufr_output_filename',
PREPBUFR_TABLE_FILENAME = 'prepbufr_table_filename',
OUTPUT_OB_FORMAT = 2
use_for          = '3DVAR',
num_slots_past   = 3,
num_slots_ahead  = 3,
write_synop = .true.,
write_ship  = .true.,
write_metar = .true.,
write_buoy  = .true.,
write_pilot = .true.,
write_sound = .true.,
write_amdar = .true.,
write_satem = .true.,
write_satob = .true.,
write_airep = .true.,
write_gpspw = .true.,
write_gpsztd= .true.,
write_gpsref= .true.,
write_gpseph= .true.,
write_ssmt1 = .true.,
write_ssmt2 = .true.,
write_ssmi  = .true.,
write_tovs  = .true.,
write_qscat = .true.,
write_profl = .true.,
write_bogus = .true.,
write_airs  = .true.,
/ 
End_Of_Namelist8
