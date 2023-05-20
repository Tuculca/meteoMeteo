HOME=$1
YEAR_S=$2
YEAR_E=$6
MONTH_S=$3
MONTH_E=$7
DAY_S=$4
DAY_E=$8
HOUR_S=$5
HOUR_E=$9

cat << End_Of_Namelist2 | sed -e 's/#.*//; s/  *$//' > ${HOME}/WRFv4.4.2/run/namelist.input
 &time_control
 run_days                            = 0,
 run_hours                           = 48,
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = $YEAR_S, $YEAR_S,
 start_month                         = $MONTH_S, $MONTH_S,
 start_day                           = $DAY_S,   $DAY_S,
 start_hour                          = $HOUR_S,  $HOUR_S,
 start_minute                        = 00,   00,   00,   00,   00,
 start_second                        = 00,   00,   00,   00,   00,
 end_year                            = $YEAR_E, $YEAR_E,
 end_month                           = $MONTH_E, $MONTH_E,
 end_day                             = $DAY_E,   $DAY_E,
 end_hour                            = $HOUR_E,  $HOUR_E,
 end_minute                          = 00,   00,   00,   00,  00,
 end_second                          = 00,   00,   00,   00,  00,
 interval_seconds                    = 10800
 input_from_file                     = .true.,.true.,.true.,.true., .true.,
 history_interval                    = 60,  60,   60,  60,  60,
 frames_per_outfile                  = 1, 1, 1, 1, 1,
 restart                             = .false.,
 restart_interval                    = 0,
 cycling                             = .false.,
 io_form_history                     = 11
 io_form_restart                     = 11
 io_form_input                       = 11
 io_form_boundary                    = 11
 io_form_auxinput4                   = 11
 io_form_auxhist4                    = 11
 io_form_auxhist24                   = 11
 io_form_auxinput24                  = 11
 debug_level                         = 0
 nocolons                            = .false.,
 /

 &domains
 eta_levels   = 1.000, 0.996, 0.994, 0.993, 0.992,
               0.987, 0.979, 0.97, 0.96, 0.949,
                0.93, 0.909, 0.88, 0.845, 0.807,
                0.765, 0.719, 0.672, 0.622, 0.571,
                0.52, 0.468, 0.42, 0.376, 0.335,
                0.298, 0.263, 0.231, 0.202, 0.175,
                0.15, 0.127, 0.106, 0.088, 0.07,
                0.055, 0.04, 0.026, 0.013, 0.000,
 time_step                           = 5,
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 100,
 use_adaptive_time_step              = .true.
 step_to_output_time                 = .true.,
 target_cfl                          = 1.2,1.2,1.2,1.1,1.1,
 max_step_increase_pct               = 51,   71,  51,  71, 71,
 starting_time_step                  = -1,  -1,  20,  4, -1,
 min_time_step                       = -1,  -1,  -1,  -1, -1,
 adaptation_domain                   = 2,
 max_dom                             = 2,
 s_we                                = 1,     1,    1,    1,  1,
 e_we                                = 379,340,301,157,217, 
 s_sn                                = 1,     1,    1,    1,  1,
 e_sn                                = 431,319,229,139,193,
 s_vert                              = 1,     1,    1,    1,  1,
 e_vert                              = 40,    40,   40,   37,   37,
 auto_levels_opt                     = 1,
 num_metgrid_levels                  = 34,
 num_metgrid_soil_levels             = 4,
 p_top_requested                     = 10000,
 dx                                  = 3000,1000,777.778,259.259,
 dy                                  = 3000,1000,777.778,259.259,
 grid_id                             = 1,     2,     3,    4,    5,
 parent_id                           = 1,     1,     2,    3,    4,
 i_parent_start    		     = 1,140,185,32,39,
 j_parent_start    		     = 1,180,192,29,43,
 parent_grid_ratio                   = 1,     3,     3,    3,    3,
 parent_time_step_ratio              = 1,     3,     3,    3,    3,
 feedback                            = 0,     
 smooth_option                       = 2,
 /
&physics
 mp_physics                          = 6,6,6,6,6,
 mp_zero_out                         = 2,
 mp_zero_out_thresh                  = 1.e-8,
 ra_lw_physics                       = 1,1,1,1,1,
 ra_sw_physics                       = 1,1,1,1,1,
 slope_rad                           = 1,1,1,
 topo_shading                        = 0,
 shadlen                             = 1000.,
 radt                                = 1,1,1,1,1,
 sf_sfclay_physics                   = 2,2,2,1,1,
 sf_surface_physics                  = 2,2,2,1,1,
 bl_pbl_physics                      = 2,2,2,1,0,
 bldt                                = 0,0,0,0,0,
 cu_physics                          = 0,0,0,0,0,
 cudt                                = 0,0,0,0,0,
 isftcflx                            = 0,
 isfflx                              = 1,
 ifsnow                              = 1,
 icloud                              = 1,
 surface_input_source                = 1,
 num_soil_layers                     = 4,
 sf_urban_physics                    = 2,2,2,
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
 diff_opt                            = 1,
 km_opt                              = 4,
 base_pres                           = 100000.,
 base_temp                           = 290.,
 base_lapse                          = 50.,
 iso_temp                            = 0.,
 use_baseparam_fr_nml                = .false.,
 damp_opt                            = 1,
 zdamp                               = 3000.,3000.,3000.,3000.,3000.,
 dampcoef                            = 0.01,0.01,0.01,0.01,0.01,
 khdif                               = 0,0,0,0,0,
 kvdif                               = 0,0,0,0,0,
 smdiv                               = 0.1,0.1,0.1,0.1,0.1,
 emdiv                               = 0.01,0.01,0.01,0.01,0.01,
 epssm                               = 0.2,0.4,0.1,
 time_step_sound                     = 0,0,0,0,0,
 h_mom_adv_order                     = 5,5,5,5,5,
 v_mom_adv_order                     = 3,3,3,3,3,
 h_sca_adv_order                     = 5,5,5,5,5,
 v_sca_adv_order                     = 3,3,3,3,3,
 non_hydrostatic                     = .true.,.true.,.true.,.true.,.true.,
 moist_adv_opt                       = 1,1,1,1,1,
 scalar_adv_opt                      = 1,1,1,1,1,
 tke_adv_opt                         = 1,1,1,1,1,
 chem_adv_opt                        = 1,1,1,1,1,
 /
 &bdy_control
 spec_bdy_width                      = 5,
 spec_zone                           = 1,
 relax_zone                          = 4,
 specified                           = .true., .false.,.false.,.false.,.false.,
 spec_exp                            = 0.33,
 periodic_x                          = .false.,.false.,.false.,.false.,
 symmetric_xs                        = .false.,.false.,.false.,.false.,
 symmetric_xe                        = .false.,.false.,.false.,.false.,
 open_xs                             = .false.,.false.,.false.,.false.,
 open_xe                             = .false.,.false.,.false.,.false.,
 periodic_y                          = .false.,.false.,.false.,.false.,
 symmetric_ys                        = .false.,.false.,.false.,.false.,
 symmetric_ye                        = .false.,.false.,.false.,.false.,
 open_ys                             = .false.,.false.,.false.,.false.,
 open_ye                             = .false.,.false.,.false.,.false.,
 nested                              = .false., .true., .true.,.true.,.true.,
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = 0,
 nio_groups = 1,
 /

End_Of_Namelist2

