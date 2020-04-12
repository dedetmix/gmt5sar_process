#/bin/bash
######################################################################
# PROCESSING Sentinel 1 SLC in GMT5SAR
# run: ./muh_processing_intfall.sh 1(2,3)
# Set 1 for preprocessing and the baseline plot
# Set 2 for interferogram processing
# 2017.01.30 "Noorlaila Hayati"  email: n.isya@tu-braunschweig.de or noorlaila@geodesy.its.ac.id
# 2018.02.01 "Muhire Desire "     
######################################################################
clear
if [[ $# -eq 0 ]] ; then
    echo '# run: ./muh_processing_intfall.sh 1(2,3)'
    echo '# Set 1 for preprocessing and the baseline plot'
    echo '# Set 2 for interferogram processing'   
    exit 1
fi
source gmt5sar.config
clear
echo "Running GMT5SAR"
echo
echo
    if [[ $1 -eq 1 ]]; then
echo "1.preprocessing folder"
./prep_dir.sh 
echo " data.in created"
echo
echo "#*-----------------end part 01-set the master ahead in data.in ?-------------------------------*"

#preproc_batch_tops_esd.csh data.in dem.grd 1
#preproc_batch_tops_esd.csh data.in dem.grd 2
#echo " preproc_batch_tops_esd.csh end"
        cd $raw
        preproc_batch_tops.csh data.in dem.grd 1
        echo "Set the master at the top and visualise else (2)"
        cd ..

    elif [[ $1 -eq 2 ]]; then
       cd raw
       preproc_batch_tops.csh data.in dem.grd 2
       #preproc_batch_tops_esd.csh data.in dem.grd 2
       cd ..
       echo " preproc_batch_tops.csh end"
       echo 
       echo "  script to make master - slave configuration"
       ./pair_config.sh $raw/date_asc.txt $temporal $perpendicular .
       cp result_combination.txt $raw/.
       cp temp_bperp_combination.txt $raw/.
       cp intf.in $raw/.
       ./baseline.sh temp_bperp_combination.txt
       echo "preprocessing interferograms ended: visualise baseline plot else (3)"
       
        elif [[ $1 -eq 3 ]]; then
       echo "run: intf_tops.csh intf.in batch_tops.config"
       intf_tops.csh intf.in batch_tops.config
       
       else
       echo "set the value (1) or (2) or (3)"
    fi
echo "END OF rocessing_intfall.sh $1"


