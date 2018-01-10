Here a script to process SBAS for TOPS mode more easily. We know that Sentinel-1 is free and make huge archive data could be processed for Stacking InSAR or SBAS.

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

Happy processing 🙂

