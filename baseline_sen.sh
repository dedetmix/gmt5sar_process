#!/bin/bash

# created by N.Isya 01.11.2017

# please set the parameters to your processing case
###################################################################
inputfile=m_s_pairs.txt
raw_orig=/home/isya/APPS/ciloto/Sentinel1/batch_asc/raw_orig
super_master=20160123
dir=$(pwd)
start_date=2014-06-01 #for x coordinate (date range)
end_date=2017-12-30
min=-150 #for y coordinate (baseline range)
max=150
###################################################################

#create baseline_configuration.txt
rm -f baseline_pair.ps base_config.txt
year=$(echo "$super_master" | awk '{print substr($0,1,4)}')
month=$(echo "$super_master" | awk '{print substr($0,5,2)}')
day=$(echo "$super_master" | awk '{print substr($0,7,2)}')
#echo "$year-$month-$day,0,S1A"$super_master"_ALL_F2" > base_config.txt

shopt -s extglob
IFS=" "
number=1
while read master slave
do

cd $raw_orig
baseline_table.csh S1A"$super_master"_ALL_F2.PRM S1A"$master"_ALL_F2.PRM GMT > table.gmt
y_m=$(cat table.gmt | awk '{print $2}')
baseline_table.csh S1A"$super_master"_ALL_F2.PRM S1A"$slave"_ALL_F2.PRM GMT > table.gmt
y_s=$(cat table.gmt | awk '{print $2}')
cd $dir
year_m=$(echo "$master" | awk '{print substr($0,1,4)}')
month_m=$(echo "$master" | awk '{print substr($0,5,2)}')
day_m=$(echo "$master" | awk '{print substr($0,7,2)}')
year_s=$(echo "$slave" | awk '{print substr($0,1,4)}')
month_s=$(echo "$slave" | awk '{print substr($0,5,2)}')
day_s=$(echo "$slave" | awk '{print substr($0,7,2)}')
echo "#$number" >> base_config.txt
echo "$year_m-$month_m-$day_m,$y_m,$master" >> base_config.txt
echo "$year_s-$month_s-$day_s,$y_s,$slave" >> base_config.txt
echo ">" >> base_config.txt
(( number++ ))

done < $inputfile

# plot baseline using GMT

gmt gmtset PS_PAGE_ORIENTATION=Landscape
gmt gmtset FORMAT_DATE_IN yyyy-mm-dd FORMAT_DATE_MAP o FONT_ANNOT_PRIMARY +10p
gmt gmtset FORMAT_TIME_PRIMARY_MAP abbreviated PS_CHAR_ENCODING ISOLatin1+
#gmtset FORMAT_DATE_OUT yyyy-mm-dd
gmt psxy base_config.txt -R"$start_date"T/"$end_date"T/"$min"/"$max" -JX9i/6i -Bsx1Y -Bpxa3Of1o+l"Acqusition time" -Bpy50+l"Perpendicular Baseline (m)" -BWeSn+t"Sentinel-1 SBAS Configuration" -K -Wthinner > baseline_pair.ps
gmt pstext base_config.txt -R -J -B -F+f7p,Helvetica,blue+jTL -O -K >> baseline_pair.ps
gmt psxy base_config.txt -R -J -O -W -Si0.05i >> baseline_pair.ps
