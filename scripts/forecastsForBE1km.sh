#!/bin/bash

HOME=/home/HDD6/ALE

#for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14
for day in 07 08 09 10 11 12 13 14
do
for hour in 00 12
do

ulimit -s unlimited
source /opt/sourceme
source ${HOME}/sourceme_ale.sh

echo "Start run"
echo " "

dayPlusOne=$((10#$day+1))
dayPlusOne=$(printf "%02d" $dayPlusOne) 

echo "++++++++++++++++++++++++++++++++++++++++"
echo "Initialization Day:${day} Hour:${hour}"
echo "End Day:${dayPlusOne} Hour:${hour}"
echo "++++++++++++++++++++++++++++++++++++++++"
echo " "

cd ${HOME}/WPS3.8.1
echo "Writing namelist.wps"
echo " " 

cat << End_Of_Namelist1 | sed -e 's/#.*//; s/  *$//' > namelist.wps
&share
 wrf_core = 'ARW',
 max_dom = 1,
 start_date = '2022-09-${day}_${hour}:00:00','2022-09-14_12:00:00'
 end_date   = '2022-09-${dayPlusOne}_${hour}:00:00','2022-09-15_12:00:00'
 interval_seconds = 10800,
 io_form_geogrid = 2,
 opt_output_from_geogrid_path = '/home/HDD6/ALE/WPS3.8.1',
 debug_level = 0,
/

&geogrid
 parent_id         = 1,1,
 parent_grid_ratio = 1,3,
 i_parent_start    = 1,140,
 j_parent_start    = 1,180,
 e_we          = 340,
 e_sn          = 319,
 geog_data_res = 'modis_lakes+30s','modis_lakes+30s',
 dx = 1000,
 dy = 1000,
 map_proj =  'lambert',
 ref_lat   = 42.388,
 ref_lon   = 12.719,
 truelat1  = 42.388,
 truelat2  = 42.388,
 stand_lon = 12.719,
 geog_data_path = '/home/HDD2/ANTO/geog',
 opt_geogrid_tbl_path = '/home/HDD6/ALE/WPS3.8.1',
/

&ungrib
 out_format = 'WPS',
 prefix = 'FILE',
/


&metgrid
 fg_name = 'FILE',
 io_form_metgrid = 2,
 opt_output_from_metgrid_path = '/home/HDD6/ALE/WPS3.8.1',
 opt_metgrid_tbl_path = '/home/HDD6/ALE/WPS3.8.1',
/

&mod_levs
 press_pa = 201300 , 200100 , 100000 ,
             95000 ,  90000 ,
             85000 ,  80000 ,
             75000 ,  70000 ,
             65000 ,  60000 ,
             55000 ,  50000 ,
             45000 ,  40000 ,
             35000 ,  30000 ,
             25000 ,  20000 ,
             15000 ,  10000 ,
              5000 ,   1000
/
End_Of_Namelist1

echo " " 
echo "Executing link_grib"
rm GRIBFILE*
./link_grib.csh ${HOME}/DATA/marche/be/202209${day}${hour}/gfs*
echo " "

echo "Executing ungrib.exe"
rm FILE*
./ungrib.exe
echo " "

echo "Executing metgrid.exe"
rm met_em*
./metgrid.exe
echo " "

cd ${HOME}/WRFV3.8.1/run
echo "Writing namelist.input"

cat << End_Of_Namelist2 | sed -e 's/#.*//; s/  *$//' > namelist.input
&time_control
 run_days                            = 0,
 run_hours                           = 24,
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = 2022, 2022, 2018, 
 start_month                         = 09, 09, 03, 
 start_day                           = ${day}, 14,  10, 
 start_hour                          = ${hour}, 00,  18, 
 start_minute                        = 00, 00,   00,
 start_second                        = 00, 00,   00, 
 end_year                            = 2022, 2022, 2018, 
 end_month                           = 09, 09, 03, 
 end_day                             = ${dayPlusOne}, 16,   11,
 end_hour                            = ${hour}, 00,  00,
 end_minute                          = 00, 00,   00, 
 end_second                          = 00, 00,   00,
 interval_seconds                    = 10800,
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = 720,  60, 15,
 frames_per_outfile                  = 1, 1,
 restart                             = .false.,
 restart_interval                    = 10000,
 cycling                             = .false.,
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 debug_level                         = 0
 nocolons                            = .false.,
 io_form_auxinput2                   = 2,
/
&domains
 time_step                           = 5,
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 100,
 use_adaptive_time_step              = .true.,
 step_to_output_time                 = .true.,
 target_cfl                          = 1.2,1.2,1.2,
 max_step_increase_pct               = 51,71, 
 starting_time_step                  = -1,-1,
 max_time_step                       = -1,-1,
 min_time_step                       = -1,-1,
 max_dom                             = 1,
 s_we                                = 1,     1,    1,
 e_we                                = 340,  466,
 s_sn                                = 1,     1,    1, 
 e_sn                                = 319,  376,
 s_vert                              = 1,     1,    1,
 e_vert                              = 40,    40,   80,
 p_top_requested                     = 10000,
 num_metgrid_levels                  = 34,
 num_metgrid_soil_levels             = 4,
 eta_levels                          = 1.000, 0.996, 0.994, 0.993, 0.992,
                                       0.987, 0.979, 0.970, 0.960, 0.949,
                                       0.930, 0.909, 0.880, 0.845, 0.807,
                                       0.765, 0.719, 0.672, 0.622, 0.571,
                                       0.520, 0.468, 0.420, 0.376, 0.335,
                                       0.298, 0.263, 0.231, 0.202, 0.175,
                                       0.150, 0.127, 0.106, 0.088, 0.070,
                                       0.055, 0.040, 0.026, 0.013, 0.000
 dx                                  = 1000,300,
 dy                                  = 1000,300,
 grid_id                             = 1,     2,     3,
 parent_id                           = 1,     1,     2,
 i_parent_start                      = 1,     140,    125,
 j_parent_start                      = 1,     180,    68,
 parent_grid_ratio                   = 1,     3,     5,   
 parent_time_step_ratio              = 1,     3,     20, 
 feedback                            = 1,
 smooth_option                       = 2, 
 /
&physics
 mp_physics                          = 6,6,6,
 mp_zero_out                         = 2,
 mp_zero_out_thresh                  = 1.e-8,
 ra_lw_physics                       = 1,1,1,
 ra_sw_physics                       = 1,1,1,
 slope_rad                           = 1,1,1,
 topo_shading                        = 0,
 shadlen                             = 1000.,
 radt                                = 1,1,1,
 sf_sfclay_physics                   = 2,2,1,
 sf_surface_physics                  = 2,2,2,
 bl_pbl_physics                      = 2,2,0,
 bldt                                = 0,
 cu_physics                          = 0,0,0,
 cudt                                = 0,
 isftcflx                            = 0,
 isfflx                              = 1,
 ifsnow                              = 1,
 icloud                              = 1,
 surface_input_source                = 1,
 num_soil_layers                     = 4,
 sf_urban_physics                    = 2,2,0,
 maxiens                             = 1,
 maxens                              = 3,
 maxens2                             = 3,
 maxens3                             = 16,
 ensdim                              = 144,
 num_land_cat                        = 21,
 num_soil_cat                        = 16,
 usemonalb                           = .true.
 /

 &fdda
 /

 &dynamics
 rk_ord                              = 3,
 w_damping                           = 1,
 diff_opt                            = 1,1,2,
 km_opt                              = 4,4,2,
 base_pres                           = 100000.,
 base_temp                           = 290.,
 base_lapse                          = 50.,
 iso_temp                            = 0.,
 use_baseparam_fr_nml                = .false.,
 damp_opt                            = 1,
 zdamp                               = 3000.,3000.,5000.,
 dampcoef                            = 0.01,0.01,0.01,
 khdif                               = 0,0,0,
 kvdif                               = 0,0,0,
 smdiv                               = 0.1,0.1,0.1,
 emdiv                               = 0.01,0.01,0.01,
 epssm                               = 0.2,0.4,0.1,
 time_step_sound                     = 0,0,0,
 h_mom_adv_order                     = 5,5,5,
 v_mom_adv_order                     = 3,3,3,
 h_sca_adv_order                     = 5,5,5,
 v_sca_adv_order                     = 3,3,3,
 non_hydrostatic                     = .true.,.true.,.true.,
 moist_adv_opt                       = 1,1,1,
 scalar_adv_opt                      = 1,1,1,
 tke_adv_opt                         = 1,1,1,
 chem_adv_opt                        = 1,1,1,
 /
 &bdy_control
 spec_bdy_width                      = 5,
 spec_zone                           = 1,
 relax_zone                          = 4,
 specified                           = .true.,.false.,.false.,
 spec_exp                            = 0.33,
 periodic_x                          = .false.,.false.,.false.,
 symmetric_xs                        = .false.,.false.,.false.,
 symmetric_xe                        = .false.,.false.,.false.,
 open_xs                             = .false.,.false.,.false.,
 open_xe                             = .false.,.false.,.false.,
 periodic_y                          = .false.,.false.,.false.,
 symmetric_ys                        = .false.,.false.,.false.,
 symmetric_ye                        = .false.,.false.,.false.,
 open_ys                             = .false.,.false.,.false.,
 open_ye                             = .false.,.false.,.false.,
 nested                              = .false., .true., .true.,
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = 0,
 nio_groups = 1,
 /
End_Of_Namelist2

echo " "
rm met_em*
echo "Linking met_em files"
ln -s ${HOME}/WPS3.8.1/met_em* .
echo " "

echo "Executing real.exe"
mpirun -np 16 ./real.exe

echo " "
mv rsl.out.0000 real.rsl.out.0000
mv rsl.error.0000 real.rsl.error.0000

echo "Executing wrf.exe"
mpirun -np 16 ./wrf.exe
echo " "
outdir=${HOME}/marche/FC_BE/202209${day}${hour}
mkdir $outdir

echo "Moving output files to ${outdir}"
mv wrfout* $outdir
rm wrfinput*
rm wrfbdy*

echo "End ${day} ${hour}"
echo " "


done
done
