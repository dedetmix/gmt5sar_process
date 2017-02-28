#!/bin/bash
######################################################################
#   Xiaohua(Eric) Xu
#   June 2016
# 04
# script to prepare directory and process SBAS 
# GMT5SAR processing for sentinel1A/B
# 2017.02.28 "Noorlaila Hayati"
# email: n.isya@tu-braunschweig.de or noorlaila@geodesy.its.ac.id
# correct: Bparalel --> Bperpendicular
######################################################################

  if [[ $# -ne 2 ]]; then
    echo ""
    echo "Usage: prep_proc_SBAS.sh data.tab mode"
    echo ""
    echo "  script to prepare directory and process SBAS"
    echo ""
    echo "  example : prep_proc_SBAS.sh data.tab 1"
    echo ""
    echo "  format of data.tab:"
    echo "                      master_id slave_id"
    echo ""
    echo "  Mode: 1 Prepare SBAS file (intf.tab scene.tab)"
    echo "        2 run SBAS"
    echo ""
    exit 1
  fi

# use data.tab on intf_all path

mode=$2
echo "mode -->" $mode

if [ $mode -eq 1 ]; then
rm -rf SBAS
mkdir SBAS

shopt -s extglob
IFS=" "
while read master slave
do

cd intf_all/"$master"_"$slave"
#rm unwrap.grd

#crop corr.grd to match with unwrap.grd
region=$(grep region_cut ../../batch_tops.config | awk '{print $3}')
gmt grdcut corr.grd -Gcorr_crop.grd -R$region -V

ls *.PRM > tmp2
master_prm=$(head -n 1 tmp2)
slave_prm=$(head -n 2 tmp2 | tail -n 1)

#echo $master_prm $slave_prm > tmp
SAT_baseline "$master_prm" "$slave_prm" > tmp

BPR=$(grep B_perpendicular tmp | awk '{print $3}')
rm tmp*

#make intf.tab file
cd ../../SBAS
echo ../intf_all/"$master"_"$slave"/unwrap.grd ../intf_all/"$master"_"$slave"/corr_crop.grd $master $slave $BPR >> intf.tab
ln -f -s ../intf_all/"$master"_"$slave"/unwrap.grd .
cd ..
done < "$1"

cd SBAS
#make scene.tab file
awk '{print int($2),$3}' ../raw_orig/baseline_table.dat >> scene.tab
cd ..
fi

if [ $mode -eq 2 ]; then
cd SBAS
xdim=$(gmt grdinfo -C unwrap.grd | awk '{print $10}')
ydim=$(gmt grdinfo -C unwrap.grd | awk '{print $11}')
n_int=$(wc -l < intf.tab)
n_scn=$(wc -l < scene.tab)
#run SBAS
sbas intf.tab scene.tab $n_int $n_scn $xdim $ydim -smooth 1.0 -wavelength 0.0554658 -incidence 30 -range 800184.946186 -rms -dem

# project the velocity to Geocooridnates
#
ln -s ../topo/trans.dat .
proj_ra2ll.csh trans.dat vel.grd vel_ll.grd
gmt grd2cpt vel_ll.grd -T= -Z -Cjet > vel_ll.cpt
grd2kml.csh vel_ll vel_ll.cpt

# view disp.grd
rm *.jpg *.ps disp.tab
ls disp_0* > disp.tab

shopt -s extglob
IFS=" "
while read disp;
do
gambar="$disp".ps
gmt grdimage $disp -Cvel_ll.cpt -JX6i -Bx1000 -By250 -BWeSn -P -K > $gambar
gmt psscale -D1.3c/-1.2c/5c/0.2h -Cvel_ll.cpt -B30:"LOS displacement, mm":/:"range decrease": -P -J -O -X4 -Y20 >> $gambar

ps2raster $gambar -Tj -E100
#echo $disp
done < disp.tab

fi
