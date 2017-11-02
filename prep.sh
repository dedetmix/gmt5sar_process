#!/bin/bash

######################################################################
# 03
# script to prepare product information (.xml) combined to auxilary calibration
# GMT5SAR processing for sentinel1A/B
# 2017.01.30 "Noorlaila Hayati"
# email: n.isya@tu-braunschweig.de or noorlaila@geodesy.its.ac.id
######################################################################

dir=$(pwd)
mkdir xml_origin
mv *.xml $dir/xml_origin/.
cp ../../date_asc.txt .
cp ../../data.in .
paste -d\  date_asc.txt data.in | sed -r 's/[:]+/ /g'> date_xml.in

shopt -s extglob
IFS=" "
while read tanggal xml orb
do

awk 'NR>1 {print $0}' < "$tanggal"_manifest.safe > tmp_file
#cat $xml.xml tmp_file > ./"$xml"_a.xml       #if there is no file aux_cal during the SAR images, use this command
cat $xml.xml tmp_file s1a-aux-cal.xml > ./"$xml"_a.xml
rm tmp_file
rm $xml.xml
mv "$xml"_a.xml $xml.xml

done < "$1"

# make sure to have space " " between column instead of symbol ":" on file date_xml.in
# attention that aux file could be from sen 1a or sen 1b with IPFV difference
# input output name has to be different, change the output file name and replace the original
# remember also the aux callibration is not applied to all interferograms, just the one which has different IPF version, > read Elevation Antenna Pattern (EAP) Contribution

# run prep.sh to sentinel 1A aux_cal and sentinel 1B aux_cal (if exist)

# finally run (on raw_orig folder):
# --> preproc_batch_tops.csh data.in dem.grd 1 ,this step to prepare SBAS process (baseline_table.dat)
# --> preproc_batch_tops.csh data.in dem.grd 2
# then type on terminal
# $ cd ..
# $ rm -r -f raw
# $ mkdir raw
# $ cd raw
# $ ln -s ../raw_orig/*.PRM .
# $ ln -s ../raw_orig/*.PRM0 .
# $ ln -s ../raw_orig/*.LED .
# $ ln -s ../raw_orig/*.SLC .
# $ ln -s ../raw_orig/*.PRM .
# $ ln -s ../raw_orig/*.dat .
# $ ln -s ../raw_orig/*.grd .
# $ cd ..
# --> go to main directory, run: intf_tops.csh intf.in batch_tops.config
