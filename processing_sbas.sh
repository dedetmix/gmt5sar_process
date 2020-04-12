######################################################################
# PROCESSING Sentinel 1 SLC in GMT5SAR
# run: ./muh_processing_sbas.sh 
# 2017.01.30 "Noorlaila Hayati"  email: n.isya@tu-braunschweig.de or noorlaila@geodesy.its.ac.id
# 2018.02.01 "Muhire Desie "     
######################################################################
echo "  script to prepare directory and process SBAS"
source gmt5sar.config
rm ../datatemp.tab
rm datatest.tab
cd intf_all
ls -d *>../datatemp.tab
cd ..
filename="datatemp.tab"
while read -r line
do
    name="$line"
    echo "Name read from file - $name"
    echo $name | sed 's/_/ /g' >>data.tab
done < "$filename"
./prep/muh_ca_prep_proc_SBAS.sh data.tab 1
./prep/muh_ca_prep_proc_SBAS.sh data.tab 2 
 