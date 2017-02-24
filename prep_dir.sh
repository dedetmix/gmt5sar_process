#!/bin/bash

######################################################################
# 01
# script to prepare the directory 
# GMT5SAR processing for sentinel1A/B
# 2017.01.30 "Noorlaila Hayati"
# email: n.isya@tu-braunschweig.de or noorlaila@geodesy.its.ac.id
######################################################################

# prepare list data to be copied
# ls /home/user/area/Sentinel-1/ascending/ -1 | sed -e 's/\.zip$//' > data_asc.txt
# ls /home/user/area/Sentinel-1/ascending/ | awk '{print substr($0,18,8)}' > date_asc.txt
# paste -d\  data_asc.txt date_asc.txt > data_asc_grub.txt
# rm data_asc.txt date_asc.txt

dir=$(pwd)

shopt -s extglob
IFS=" "
while read nama tanggal
do

cd /home/user/area/Sentinel-1/ascending/
mkdir load
unzip $nama.zip
mv $nama.SAFE load/.
cp load/"$nama".SAFE/measurement/*002.tiff $dir/batch_asc/raw_orig/.
cp load/"$nama".SAFE/manifest.safe $dir/batch_asc/raw_orig/"$tanggal"_manifest.safe
cp load/"$nama".SAFE/annotation/*002.xml $dir/batch_asc/raw_orig/.
rm -r load
done < "$1"


cd $dir

