
YEAR=$1
MONTH=$2
DAY=$3
HOUR=$4

#wget https://ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.${YEAR}${MONTH}${DAY}/${HOUR}/atmos/gfs.t${HOUR}z.pgrb2.0p25.anl

for hour in 00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48
do
echo 'Downloading f0'$hour 
#wget https://ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.${YEAR}${MONTH}${DAY}/${HOUR}/atmos/gfs.t${HOUR}z.pgrb2.0p25.f0${hour} --no-check-certificate
wget --no-check-certificate "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t${HOUR}z.pgrb2.0p25.f0${hour}&subregion=&leftlon=0&rightlon=30&toplat=50&bottomlat=30&dir=%2Fgfs.${YEAR}${MONTH}${DAY}%2F${HOUR}%2Fatmos" -O gfs.f0${hour}
done

exit
