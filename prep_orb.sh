#!/bin/bash

######################################################################
# 02
# script to prepare the precise orbit ephemeris (POEORB)
# GMT5SAR processing for sentinel1A/B
# 2017.02.28 "Noorlaila Hayati"
# email: n.isya@tu-braunschweig.de or noorlaila@geodesy.its.ac.id
######################################################################

#use date_asc.txt

sen_orbit=/home/isya/APPS/ciloto/sen_orbit/aux_poeorb/S1A
raw_org=/home/isya/APPS/ciloto/Sentinel1/batch_asc/raw_orig
dir=$(pwd)
#rm $raw_org/*.EOF
rm data_orb.txt
rm -r $raw_org/aux_poeorb

shopt -s extglob
IFS=" "
while read tanggal
do

cd $sen_orbit
yesterday=$( date -d "${tanggal} -1 days" +'%Y%m%d' )

#check=$(echo "$range" | awk '{print substr($0,7,2)}')
#if [ "$check" == "00" ]; then
#range_edit=$(echo "$range" | awk '{print substr($0,1,6)}')
#range2=$((range_edit-1))
#   check2=$(echo "$range" | awk '{print substr($0,5,2)}')
#   if [[ "$check2" != "01" && "$check2" != "03" && "$check2" != "05" && "$check2" != "07" && "$check2" != "08" && #"$check2" != "10" && "$check2" !=  "12" ]]; then
#   range=$(echo "$range2"31)
#   else
#   range=$(echo "$range2"30)
#   fi
#fi

orb_fix=$(grep -r -l V"$yesterday"T | head -1)
ln -s $sen_orbit/"$orb_fix" $raw_org/.
cd $raw_org
ls *.EOF > data_orb.txt
mv data_orb.txt $dir
done < "$1"

cd $raw_org

ls *.tiff -1 | sed -e 's/\.tiff$//' > data2_asc.txt
mv data2_asc.txt $dir
cd $dir
paste -d\:  data2_asc.txt data_orb.txt > data.in
# data.in must be arranged by super master at the first line and follow other scenes ! see baseline_time (to make it easy, just move the super master to the first line
# make sure also that data.in have a suitable pair for each line
rm data2_asc.txt
