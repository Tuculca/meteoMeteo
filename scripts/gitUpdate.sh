#!/bin/bash
SHELL=/bin/bash
source /home/disco4/afalcione/sourcem_intel_23.sh

cd /home/disco4/afalcione/OPER/meteoMeteo


rm -f /home/disco4/afalcione/OPER/meteoMeteo/Temperature/*.jpg
cp /home/disco4/afalcione/OPER/plots/Temperature*.jpg /home/disco4/afalcione/OPER/meteoMeteo/Temperature/
cd /home/disco4/afalcione/OPER/meteoMeteo/Temperature/
convert -delay 50 -loop 0 $(ls -v Temperature_d01*.jpg) Temperature.gif

rm -f /home/disco4/afalcione/OPER/meteoMeteo/Rain/*.jpg
cp /home/disco4/afalcione/OPER/plots/Rain*.jpg /home/disco4/afalcione/OPER/meteoMeteo/Rain/
cd /home/disco4/afalcione/OPER/meteoMeteo/Rain/
convert -delay 50 -loop 0 $(ls -v Rain3h_d01*.jpg) Rain.gif

rm -f /home/disco4/afalcione/OPER/meteoMeteo/Wind/*.jpg
cp /home/disco4/afalcione/OPER/plots/Wind*.jpg /home/disco4/afalcione/OPER/meteoMeteo/Wind/
cd /home/disco4/afalcione/OPER/meteoMeteo/Wind/
convert -delay 50 -loop 0 $(ls -v Wind_d01*.jpg) Wind.gif

rm -f /home/disco4/afalcione/OPER/meteoMeteo/CloudTot/*.jpg
cp /home/disco4/afalcione/OPER/plots/CloudTot*.jpg /home/disco4/afalcione/OPER/meteoMeteo/CloudTot/
cd /home/disco4/afalcione/OPER/meteoMeteo/CloudTot/
convert -delay 50 -loop 0 $(ls -v CloudTot_d01*.jpg) CloudTot.gif

rm -f /home/disco4/afalcione/OPER/meteoMeteo/Geopotential/*.jpg
cp /home/disco4/afalcione/OPER/plots/Geop*.jpg /home/disco4/afalcione/OPER/meteoMeteo/Geopotential/
cd /home/disco4/afalcione/OPER/meteoMeteo/Geopotential/
convert -delay 50 -loop 0 $(ls -v Geop_d01*.jpg) Geop.gif

rm -f /home/disco4/afalcione/OPER/meteoMeteo/RH/*.jpg
cp /home/disco4/afalcione/OPER/plots/RH*.jpg /home/disco4/afalcione/OPER/meteoMeteo/RH/
cd /home/disco4/afalcione/OPER/meteoMeteo/RH/
convert -delay 50 -loop 0 $(ls -v RH_d01*.jpg) RH.gif

cd /home/disco4/afalcione/OPER/meteoMeteo

git remote set-url origin https://tuculca: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@github.com/Tuculca/meteoMeteo.git

git add --all
git commit -m "Prova git auto"
git push -u origin main
