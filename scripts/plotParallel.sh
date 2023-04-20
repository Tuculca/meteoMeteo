#!/bin/bash -l

HOME=/home/afalcione
addressWrfouts=${HOME}/OPER/output
addressPlots=${HOME}/OPER/plots

. /home/afalcione/.bashrc_conda
eval "$(conda shell.bash hook)"
conda activate aleOPER

cd ${addressPlots}

for domain in d01 d02
do

dateStart=$1
#dateStart="12:00:00 2022-12-17"
dateEnd=$(date -d "$dateStart + 48 hour" +%Y-%m-%d_%H:%M:%S)
dateNewFmt=$dateStart
dateNew=$dataStart

hourNew=01
while [ "$dateNew" != $dateEnd ]
do
dateOld=$(date -d "$dateNewFmt" +"%Y-%m-%d_%H:%M:%S")
dateNewFmt=$(date -d "$dateNewFmt + 3 hour" +"%H:%M:%S %Y-%m-%d")
dateNew=$(date -d "$dateNewFmt" +%Y-%m-%d_%H:%M:%S)
echo "Start: "$dateOld
echo "End  : "$dateNew
echo " "
echo "python plotRainDiff.py ${addressWrfouts}/wrfout_d0x_${dateOld} ${addressWrfouts}/wrfout_d0x_${dateNew} /mnt/disk2/afalcione/OPER_intel/plots/Rain3h_d0x_"
echo " "
python plotRainDiff_OPER.py ${addressWrfouts}/wrfout_${domain}_${dateOld} ${addressWrfouts}/wrfout_${domain}_${dateNew} ${addressPlots}/Rain3h_${domain}_${hourNew} &

hourNew=$((10#$hourNew+1))
hourNew=$(printf "%02d" $hourNew)
done
done

date2End=$(date -d "$dateStart + 48 hour" +%Y-%m-%d_%H:%M:%S)
date2NewFmt=$dateStart
date2New=$dataStart

hourNew=01
while [ "$date2New" != $date2End ]
do
date2Old=$(date -d "$date2NewFmt" +"%Y-%m-%d_%H:%M:%S")
date2NewFmt=$(date -d "$date2NewFmt + 1 hour" +"%H:%M:%S %Y-%m-%d")
date2New=$(date -d "$date2NewFmt" +%Y-%m-%d_%H:%M:%S)
echo "Start: "$date2Old
echo "End  : "$date2New
echo " "
echo "python plotCloud_OPER.py ${addressWrfouts}/wrfout_d0x_${date2New} /mnt/disk2/afalcione/OPER_intel/plots/Clouds_d0x_"
echo " "
python plotCloud_OPER.py ${addressWrfouts}/wrfout_d01_${date2New} ${addressPlots}/Clouds_d01_${hourNew} &
python plotCloud_OPER.py ${addressWrfouts}/wrfout_d02_${date2New} ${addressPlots}/Clouds_d02_${hourNew} &

echo " "
echo "python plotCloudTot_OPER.py ${addressWrfouts}/wrfout_${domain}_${date2New} /mnt/disk2/afalcione/OPER_intel/plots/CloudTot_d0x_"
echo " "
python plotCloudTot_OPER.py ${addressWrfouts}/wrfout_d01_${date2New} ${addressPlots}/CloudTot_d01_${hourNew} &
python plotCloudTot_OPER.py ${addressWrfouts}/wrfout_d02_${date2New} ${addressPlots}/CloudTot_d02_${hourNew} &

echo " "
echo "python plotGeop_OPER.py ${addressWrfouts}/wrfout_d0x_${date2New} /mnt/disk2/afalcione/OPER_intel/plots/Clouds_d0x_"
echo " "
python plotGeop_OPER.py ${addressWrfouts}/wrfout_d01_${date2New} ${addressPlots}/Geop_d01_${hourNew} &
python plotGeop_OPER.py ${addressWrfouts}/wrfout_d02_${date2New} ${addressPlots}/Geop_d02_${hourNew} &

echo " "
echo "python plotTemperature_OPER.py ${addressWrfouts}/wrfout_d0x_${date2New} /mnt/disk2/afalcione/OPER_intel/plots/Temperature_d0x_"
echo " "
python plotTemperature_OPER.py ${addressWrfouts}/wrfout_d01_${date2New} ${addressPlots}/Temperature_d01_${hourNew} &
python plotTemperature_OPER.py ${addressWrfouts}/wrfout_d02_${date2New} ${addressPlots}/Temperature_d02_${hourNew} &

echo " "
echo "python plotWind_OPER.py ${addressWrfouts}/wrfout_d0x_${date2New} /mnt/disk2/afalcione/OPER_intel/plots/Wind_d0x_"
echo " "
python plotWind_OPER.py ${addressWrfouts}/wrfout_d01_${date2New} ${addressPlots}/Wind_d01_${hourNew} &
python plotWind_OPER.py ${addressWrfouts}/wrfout_d02_${date2New} ${addressPlots}/Wind_d02_${hourNew} &

echo " "
echo "python plotRH_OPER.py ${addressWrfouts}/wrfout_d0x_${date2New} /mnt/disk2/afalcione/OPER_intel/plots/RH_d0x_"
echo " "
python plotRH_OPER.py ${addressWrfouts}/wrfout_d01_${date2New} ${addressPlots}/RH_d01_${hourNew} &
python plotRH_OPER.py ${addressWrfouts}/wrfout_d02_${date2New} ${addressPlots}/RH_d02_${hourNew} &

wait
hourNew=$((10#$hourNew+1))
hourNew=$(printf "%02d" $hourNew)
done
