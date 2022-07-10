
.RESET_SESSION
timespan, '2017-07-14/02:40:00', 20, /minute
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_wave_params.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_fce_and_flhr.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_Ne.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_kpara.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc__f_kpara.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_kpara.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc__Ne_kperp.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_Ne_kperp.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc__Ne_theta.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_Ne_theta.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_UT_B.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_theta.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_Ne0_f_B.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_t_hfa_t_kpara.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/event_analysis_duct.pro'
event_analysis_duct, duct_time='2017-07-14/02:51:50', focus_f=[2., 3., 4., 5.], UHR_file_name='kuma', duct_wid_data_n=6, IorD='D'

