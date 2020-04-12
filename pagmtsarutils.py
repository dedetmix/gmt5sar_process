# -*- coding: utf-8 -*-
#    python 3.5 or more
#    PaGMTSAR: Processing and Automation of GMTSAR 5
#    Author : MUHIRE Desire

# MIT Copyright 2019 MUHIRE Desire

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



import PySimpleGUI as sg
import configparser
import os,sys,os.path,subprocess  

def runBash(bashfile):      
        try:
            subprocess.call(bashfile, shell=True)
        except subprocess.CalledProcessError as e:
            print(e.returncode)
            print(e.cmd)
            print(e.output)

def batch_tops_config(start,master_image,corr_snaphu,corr,filter_wavelength,region_cut,defomax,near_interp,switch_land,num_patches,earth_radius,near_range,fd1,topo_phase,shift_topo,dec_factor,range_dec,azimuth_dec
):

	f = open('batch_tops.config','w') 

	f.write('''
	#
	# This is an example configuration file for batch processing
	#
	# all the comments or explanations are marked by "#" 
	# The parameters in this configuration file is distinguished by their first word so 
	# user should follow the naming of each parameter.
	# the parameter name, = sign, parameter value should be separated by space " ". 
	# leave the parameter value blank if using default value. 
	#
    \n''')
	f.write('''
	#######################################
	# processing stage for intf_batch.csh #
	#######################################
	# 1 - start from make topo_ra
	# 2 - start from make and filter interferograms, unwrap and geocode
    \n''')
   
	f.write( 'proc_stage = {}\n' .format( start))

	f.write('''# the namestem of the master image - REQUIRED example S1A20151123_ALL_F2 \n''')
 
	f.write( 'master_image ={}\n' .format(  master_image  ))

	f.write('''#########################################
	#   parameters for preprocess           #
	#   - pre_proc_batch.csh                #
	#   following 4 parameters are OPTIONAL #
	#########################################
	# num of patches \n''')
    
	f.write( 'num_patches ={}\n' .format(num_patches ))

	f.write('''# earth radius \n''')
    
	f.write( 'earth_radius ={}\n' .format(earth_radius ))

	f.write('''# near_range \n''')
    
	f.write( 'near_range ={}\n' .format(near_range ))

	f.write('''# Doppler centroid \n''')
    
	f.write( 'fd1 ={}\n' .format(fd1 ))


	f.write('''#####################################
	#   parameters for make topo_ra     #
	#   - dem2topo_ra.csh               #
	#####################################
	# subtract topo_ra from the phase
	#  (1 -- yes; 0 -- no) \n''')
    
	f.write( 'topo_phase ={}\n' .format(topo_phase ))
    
	f.write('''# if above parameter = 1 then one should have put DEM.grd in topo/ \n''')

	f.write('''# topo_ra shift (1 -- yes; 0 -- no) \n''')
    
	f.write( 'shift_topo ={}\n' .format(shift_topo ))

	f.write('''####################################################
	#   parameters for make and filter interferograms  #
	#   - intf.csh                                     #
	#   - filter.csh                                   #
	####################################################
    \n
	''')

	f.write('''# filters \n
	# look at the filter/ folder to choose other filters \n''')
    
	f.write( 'filter_wavelength ={}\n' .format(filter_wavelength ))

	f.write('''# decimation of images 
	# decimation control the size of the amplitude and phase images. It is either 1 or 2.
	# Set the decimation to be 1 if you want higher resolution images.
	# Set the decimation to be 2 if you want images with smaller file size.
	# 
    \n''')
    
	f.write( 'dec_factor ={}\n' .format(dec_factor ))
    
	f.write('''# for tops processing, to force the decimation factor
	# recommended range decimation to be 8, azimuth decimation to be 2 \n''')
	f.write( 'range_dec ={}\n' .format(range_dec ))
    
	f.write( 'azimuth_dec ={}\n' .format(azimuth_dec ))


	f.write('''#####################################
	#   parameters for unwrap phase     #
	#   - snaphu.csh                    #
	#####################################
	# correlation threshold for snaphu.csh (0~1)
	# set it to be 0 to skip unwrapping. \n''')
    
	f.write( 'threshold_snaphu ={}\n' .format(corr_snaphu ))


	f.write('''# interpolate masked or low coherence pixels with their nearest neighbors, 1 means interpolate, 
	# others or blank means using original phase, see snaphu.csh and snaphu_interp.csh for details
	# this could be very slow in case a large blank area exist \n''')
    
	f.write( 'near_interp ={}\n' .format( near_interp ))

	f.write('''# region to unwrap in radar coordinates (leave it blank if unwrap the whole region)
	#  example format 500/10800/500/27200  - OPTIONAL \n''')
    
	f.write( 'region_cut={}\n' .format(region_cut ))
    
	f.write('''# use landmask (1 -- yes; else -- no) \n''')
    
	f.write( 'switch_land ={}\n' .format(switch_land ))

	f.write('''#
	# Allow phase discontinuity in unrapped phase. This is needed for interferograms having sharp phase jumps.
	# defo_max = 0 - used for smooth unwrapped phase such as interseismic deformation
	# defo_max = 65 - will allow a phase jump of 65 cycles or 1.82 m of deformation at C-band
	#
    \n''')
    
	f.write( 'defomax ={}\n' .format( defomax ))

	f.write('''#####################################
	#   parameters for geocode          #
	#   - geocode.csh                   #
	#####################################
	# correlation threshold for geocode.csh (0~1) \n''')
    
	f.write( 'threshold_geocode ={}\n' .format( corr ))

	f.close() 

def makegmtsarconfigFile(workingspace,SAFEFolder,orbits,s1aauxcal,raw_orig,raw,iw,pol,sab,super_master,start_date,end_date,min_axes,max_axes,crop,temporal, perpendicular,sf,ni,inc,rng,wl, master_image,corr_snaphu,corr,filter_wavelength,region_cut,defomax,near_interp,switch_land,num_patches,earth_radius,near_range,fd1,topo_phase,shift_topo,dec_factor,range_dec,azimuth_dec):
    config['DEFAULT'] = {'Info':'SAFE files should be unzipped, and the working folder should be path */Safe */orbits */s1aauxcal */raw_orig */raw',
    'workingspace':workingspace,
    'dir':workingspace,
    'SAFEFolder':SAFEFolder,
    'sen_orbit':orbits,
    'calib':s1aauxcal,
    'raw_org':raw_orig,
    'raw':raw,
    'IW':iw,
    'POL':pol,
    'SAB':sab,
    'super_master':super_master,
    'start_date':start_date,
    'end_date':end_date,
    'min':min_axes,
    'max':max_axes,
    'crop':crop,
    'temporal':temporal,
    'perpendicular':perpendicular,
	'master_image':master_image,
	'corr_snaphu':corr_snaphu,
	'corr':corr,
	'filter_wavelength':filter_wavelength,
	'region_cut':region_cut,
	'defomax':defomax,
	'near_interp':near_interp,
	'switch_land':switch_land,
	'num_patches':num_patches,
	'earth_radius':earth_radius,
	'near_range':near_range,
	'fd1':fd1,
	'topo_phase':topo_phase,
	'shift_topo':shift_topo,
	'dec_factor':dec_factor,
	'range_dec':range_dec,
	'azimuth_dec':azimuth_dec, 
    'sf':sf,
    'ni':ni,
    'wl':wl,
    'inc':inc,
    'rng':rng}

    with open('gmtsar.config', 'w') as configfile:
        config.write(configfile)

config = configparser.ConfigParser()

sg.change_look_and_feel('DarkAmber')      # Add some color to the window

# Very basic window.  Return values using auto numbered keys
                
slc_folder_frame_layout = [
[sg.Text('Working space', size=(15, 1), auto_size_text=False),      
sg.InputText(os.path.dirname(os.path.realpath(__file__))), sg.FolderBrowse()],
[sg.Text('SAFE data folder', size=(15, 1), auto_size_text=False),      
sg.InputText('SAFE SLC data unzipped'), sg.FolderBrowse()],
[sg.Text('Sentinel-1 orbit folder', size=(15, 1), auto_size_text=False),      
sg.InputText('orbits'), sg.FolderBrowse()],     
[sg.Text('Sentinel-1 s1aauxcal folder', size=(15, 1), auto_size_text=False),      
sg.InputText('Auxcal'), sg.FolderBrowse()]
]
slc_variable_frame_layout = [
[sg.Text('IW', size=(15, 1)), sg.InputText(1)],
[sg.Text('Polarisation', size=(15, 1)), sg.InputText('VV')],
[sg.Text('Sentinel-A/B', size=(15, 1)), sg.InputText(1)],
[sg.Text('super_master', size=(15, 1)), sg.InputText('20151123')],
[sg.Text('start_date',size=(15, 1)), sg.InputText('20151123')],
[sg.Text('end_date',size=(15, 1)), sg.InputText(' 20151123')],
[sg.Text('min', size=(15, 1)), sg.InputText('-50')],
[sg.Text('max', size=(15, 1)), sg.InputText('50')],
[sg.Text('crop yes 1 no 0', size=(15, 1)), sg.InputText('0')],
[sg.Text('temporal', size=(15, 1)), sg.InputText('100')],
[sg.Text('perpendicular', size=(15, 1)), sg.InputText('100')]
]

slc_layout = [
[sg.Frame('Folder', slc_folder_frame_layout , font='Any 12', title_color='white')],
[sg.Frame('Variable', slc_variable_frame_layout, font='Any 12', title_color='white')],
[sg.Text('SLC pre-processing', size=(20,1), key='slc_output',justification='center', relief=sg.RELIEF_RIDGE)  ],  
[sg.Submit(key='slc')]
]

insar_variable_frame_layout = [
[sg.Text('Processing InSAR Configuration')],
[sg.Text('corr_snaphu', size=(15, 1)), sg.InputText(0.2)],
[sg.Text('corr', size=(15, 1)), sg.InputText(0.2)],
[sg.Text('filter_wavelength', size=(15, 1)), sg.InputText('200')],
[sg.Text('region_cut', size=(15, 1)), sg.InputText('0/100/0/100')],
[sg.Text('defomax', size=(15, 1)), sg.InputText('0')],
[sg.Text('switch_land', size=(15, 1)), sg.InputText('0')],
[sg.Text('near_interp', size=(15, 1)), sg.InputText('1')],
[sg.Text('num_patches', size=(15, 1)), sg.InputText(' ')],
[sg.Text('earth_radius', size=(15, 1)), sg.InputText(' ')],
[sg.Text('near_range', size=(15, 1)), sg.InputText(' ')],
[sg.Text('fd1', size=(15, 1)), sg.InputText(' ')],
[sg.Text('topo_phase: 1/0 y/n', size=(15, 1)), sg.InputText('1')],
[sg.Text('shift_topo: 1/0 y/n', size=(15, 1)), sg.InputText('0')],
[sg.Text('dec_factor', size=(15, 1)), sg.InputText('2')],
[sg.Text('range_dec', size=(15, 1)), sg.InputText('8')],
[sg.Text('azimuth_dec', size=(15, 1)), sg.InputText('2')],
]
insar_processing_frame_layout = [
[sg.Text('Processing stage: 1 for preprocessing and the baseline plot and 2 for interferogram processing')],
[sg.Text('stage', size=(15, 1)), sg.InputText(1)]
]

insar_layout = [
[sg.Frame('Variable', insar_variable_frame_layout, font='Any 12', title_color='white')],
[sg.Frame('Processing', insar_processing_frame_layout , font='Any 12', title_color='white')],
[sg.Text('INSAR', size=(20,1), key='insar_output',justification='center', relief=sg.RELIEF_RIDGE)],
[sg.Submit(key='insar'),sg.Button('runINSAR', button_color=('blue', 'white'))],
]
sbas_variable_frame_layout = [
[sg.Text('wl', size=(15, 1)), sg.InputText(' 0.0554658')],
[sg.Text('sf ', size=(15, 1)), sg.InputText('0.3')],
[sg.Text('ni ', size=(15, 1)), sg.InputText('1')],
[sg.Text('inc ', size=(15, 1)), sg.InputText('37')],
[sg.Text('rng ', size=(15, 1)), sg.InputText('846003.008169')],
[sg.Submit(key='sbas')]
]
sbas_layout = [
[sg.Frame('Folder', sbas_variable_frame_layout, font='Any 12', title_color='white')],  
[sg.Text('SBAS-InSAR', size=(20,1), key='sbas_output',justification='center', relief=sg.RELIEF_RIDGE)],
[sg.Button('runSBAS', button_color=('blue', 'white'))]
]
about='''
# PaGMTSAR

The purpose of code development is to allow GMTSAR 5 users: to automate InSAR and SBAS,
with an intuitive interface.

The code:
-take inputs and automatically generate the configuration file for gmtsar.
-allows you to launch gmtsar from a button.

The project is under development is called on the develloper:
to do:
1. beta tester
2. convert bash scripts codes to python
3. add plotting
4. adjust scripts for S1B
5. download orbits automatically
6. download sentinel-1 automatically
7. add other SAR data

Author:
Muhire Desire

Credits:
Bash scripts were primary coded by: 
# 2017.01.30 "Noorlaila Hayati"
and organized: 
# 2018.02.01  "Muhire Desire" 

MIT License
Copyright (c) 2019 Noorlaila Hayati MUHIRE Desire
'''
about_layout = [ 
[sg.Text('PaGMTSAR: Processing and Automation of GMTSAR 5')],
[sg.Text('GMTSAR Version 1.0')],
[sg.Text(about)]
]

layout = [
    [sg.Text('PaGMTSAR: Processing GMTSAR ', size=(35, 1), justification='center',font=("Helvetica", 20), relief=sg.RELIEF_RIDGE)],
    [sg.TabGroup([
        [sg.Tab(' Sentinel 1 SLC Processing', slc_layout,key='_slc_'), 
        sg.Tab('InSAR Processing', insar_layout,key='_insar_'),
        sg.Tab('SBAS-InSAR Processing', sbas_layout,key='_sbas_'),
        sg.Tab('About', about_layout,key='_about_')],
        ])
    ]
]

window = sg.Window('PaGMTSAR', layout)

while True:      
    event, values = window.read()
          
    if event is not None:      
        try:      
            workingspace=os.path.join(values[0])
            SAFEFolder=os.path.join(values[1])
            orbits=os.path.join(values[2])
            s1aauxcal=os.path.join(values[3])
            raw_orig=os.path.join(workingspace,"raw_orig")
            raw=os.path.join(workingspace,"raw")
            iw = values[4]
            pol = values[5]
            sab = values[6]
            super_master = values[7]
            master_image=super_master
            start_date = values[8]
            end_date = values[9]
            min_axes = values[10]
            max_axes = values[11]
            crop = values[12]
            temporal = values[13]
            perpendicular = values[14]
            corr_snaphu= values[15]
            corr=values[16]
            filter_wavelength=values[17]
            region_cut=values[18]
            defomax=values[19]
            switch_land=values[20]
            near_interp=values[21]
            num_patches=values[22]
            earth_radius=values[23]
            near_range=values[24]
            fd1=values[25]
            topo_phase=values[26]
            shift_topo=values[27]
            dec_factor=values[28]
            range_dec=values[29]
            azimuth_dec=values[30]
            stage = values[31]
            wl = values[32]
            sf = values[33]
            ni = values[34]
            inc = values[35]
            rng = values[36]  
            makegmtsarconfigFile(workingspace,SAFEFolder,orbits,s1aauxcal,raw_orig,raw,iw,pol,sab,super_master,start_date,end_date,min_axes,max_axes,crop,temporal, perpendicular,sf,ni,inc,rng,wl,master_image,corr_snaphu,corr,filter_wavelength,region_cut,defomax,near_interp,switch_land,num_patches,earth_radius,near_range,fd1,topo_phase,shift_topo,dec_factor,range_dec,azimuth_dec)  
            batch_tops_config(stage,values[7],values[15],values[16],values[17],values[18],values[19],values[20],values[21],values[22],values[23],values[24],values[25],values[26],values[27],values[28],values[29],values[30])            
            
        except:      
            print('Error')      

        if event==('slc'):
            window['slc_output'].update('SLC update') 
        elif event==('insar'):
            window['insar_output'].update('INSAR update') 
        elif event==('sbas'):
            window['sbas_output'].update('SBAS update') 
        elif event==('runINSAR'):
            runBash(os.path.join(workingspace,'processing_intfall.sh')+' '+stage)
        elif event==('runSBAS'):
            runBash(os.path.join(workingspace,'processing_sbas.sh')) 
        else:
            window['slc_output'].update('Update error') 
    else:      
        break  




