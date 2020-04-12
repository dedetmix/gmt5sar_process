#!/bin/bash
######################################################################
# 
# script to prepare -the data_asc.txt date_asc.txt  and data_asc_grub.txt 
# GMT5SAR processing for sentinel1A/B
# 2017.01.30 "Noorlaila Hayati"  email: n.isya@tu-braunschweig.de or noorlaila@geodesy.its.ac.id
#2018.02.01  "Muhire Desire "         
######################################################################
#run in bash: prep_dir.sh
#input : create a configuration file gmt5sar.config
#output: data_asc.txt date_asc.txt  data_asc_grub.txt 
source gmt5sar.config
rm data_asc.txt 
rm date_asc.txt
rm data_asc_grub.txt
cd $SAFEFolder
for f in *.SAFE; do
    if [ -d ${f} ]; then
        # Will not run if no directories are available
        echo "Reading $f"
        echo $f  | awk '{print substr($0,1,67)}'>> $workingspace/data_asc.txt     
        echo $f  | awk '{print substr($0,18,8)}' >> $workingspace/date_asc.txt
    fi
done
cd $workingspace
paste -d\  data_asc.txt date_asc.txt > data_asc_grub.txt

rm -r raw_orig
mkdir raw_orig
path_raw_orig=$workingspace/raw_orig
cp $calib/s1$sab-aux-cal.xml $path_raw_orig
shopt -s extglob
IFS=" "
while read nama tanggal
do
cp $SAFEFolder/"$nama".SAFE/manifest.safe $path_raw_orig/"$tanggal"_manifest.safe
cp $SAFEFolder/"$nama".SAFE/measurement/s1$sab-iw$IW-slc-$POL-*.tiff $path_raw_orig
cp $SAFEFolder/"$nama".SAFE/annotation/s1$sab-iw$IW-slc-$POL-*.xml $path_raw_orig
done < "data_asc_grub.txt"

source gmt5sar.config
dir=$(pwd)
rm $raw_org/*.EOF
rm data_orb.txt
#rm -r $raw_org/aux_poeorb

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
echo " Processing file:"
echo $raw_org

cd $raw_org
ls *.EOF > data_orb.txt
mv data_orb.txt $dir
done < "provide date_asc.txt"

cd $raw_org

ls *.tiff -1 | sed -e 's/\.tiff$//' > data2_asc.txt
mv data2_asc.txt $dir
cd $dir
paste -d\:  data2_asc.txt data_orb.txt > data.in
# data.in must be arranged by super master at the first line and follow other scenes ! see baseline_time (to make it easy, just move the super master to the first line
# make sure also that data.in have a suitable pair for each line
rm data2_asc.txt
rm -rf raw
mkdir -p raw
cd raw
ln -s ../raw_orig/*EOF .
ln -s ../raw_orig/*tiff .
ln -s ../topo/dem.grd .
ln -s ../raw_orig/*_manifest.safe .
cp $raw_org/*.xml  $raw/.
cp $dir/date_asc.txt $raw/.
cp $dir/data.in $raw/.
paste -d\  date_asc.txt data.in | sed -r 's/[:]+/ /g'> date_xml.in
#cp $dir/date_xml.in $raw/.
cp date_xml.in $workingspace/.


cd $raw
shopt -s extglob
IFS=" "
while read tanggal xml orb
do
awk 'NR>1 {print $0}' < "$tanggal"_manifest.safe > tmp_file
cat $xml.xml tmp_file s1$sab-aux-cal.xml > ./"$xml"_a.xml
rm tmp_file
rm $xml.xml
mv "$xml"_a.xml $xml.xml
done < "date_xml.in"
cd $dir
