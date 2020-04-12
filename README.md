The purpose of code development is to allow GMTSAR 5 users: to automate InSAR and SBAS,
with an intuitive interface. Here a script to process SBAS for TOPS mode more easily. We know \
that Sentinel-1 is free and make huge archive data could be processed for Stacking InSAR or SBAS.

Based on example data S1A_Stack from GMT5SAR website, i modified the script to automatically prepare some files to run SBAS GMT5SAR (such as intf.tab and scene.tab).

Download prep_proc_SBAS.sh

Note: - change the path to your batch_tops.config file location (line 51)
      - change SBAS parameter to your area (line 90)

***

If you are also interested to prepare directory and precise orbit ephemeris files, here

prep_dir.sh

prep_orb.sh

prep.sh

Note: 
- make sure that the path on every script has to be changed to your computer path!
- pair_config.sh and baseline_sen.sh are used to select master-slave combination pairs and draw them with GMT

The code:
-take inputs and automatically generate the configuration file for gmtsar.
-allows you to launch gmtsar from a button.

Installation of prep scripts:
-compile the c code in prep
-gcc combination.c -o combination
-use the python code to create configuration file


The project is under development is called on the develloper:

To do:
1. beta tester
2. convert bash scripts codes to python
3. add plotting
4. adjust scripts for S1B
5. download orbits automatically
6. download sentinel-1 automatically
7. add other SAR data

Author and credits:
Bash scripts were primary coded by: 
# 2017.01.30 "Noorlaila Hayati"
and organized: 
# 2018.02.01  "Muhire Desire" 

MIT License
Copyright (c) 2020 Noorlaila HayatiMUHIRE Desire
