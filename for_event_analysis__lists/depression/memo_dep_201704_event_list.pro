
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis__lists/depression/memo_dep_201704_event_list.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal.pro'

pro memo_dep_201704_event_list

    timespan, '2017-04-01/01:45:00', 15.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-01/01:48:12', focus_f=[7.,9.,11.,13.,15.], UHR_file_name='kuma', duct_wid_data_n=1, IorD='D', lsm=[0.0001445828931184357, 0.000333513615533033]
    event_analysis_duct, duct_time='2017-04-01/01:51:10', focus_f=[7.,9.,11.,13.,15.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='D', lsm=[6.843270033739466e-05, 0.0011029826700924526]
    event_analysis_duct, duct_time='2017-04-01/01:52:37', focus_f=[7.,9.,11.,13.,15.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='D', lsm=[0.00015834195017224554, -0.000117070622975287]

    timespan, '2017-04-03/10:25:00', 40.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-03/10:29:35', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=4, IorD='D', lsm=[0.00010580251984096746, -5.345693013296855e-05]
    event_analysis_duct, duct_time='2017-04-03/10:32:05', focus_f=[6.,8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=1, IorD='D', lsm=[0.00010996022723548395, 6.701354868999998e-06]
    event_analysis_duct, duct_time='2017-04-03/10:35:20', focus_f=[6.,8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='D', lsm=[0.00011067829020588042, -2.722206936140646e-05]
    event_analysis_duct, duct_time='2017-04-03/10:38:15', focus_f=[6.,8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=1, IorD='D', lsm=[0.00010654157741214491, 0.00020173536905497327]
    event_analysis_duct, duct_time='2017-04-03/10:48:38', focus_f=[4.,6.,8.,10.,12.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='D', lsm=[0.0001182513021367236, 0.00043332427443864457]
    event_analysis_duct, duct_time='2017-04-03/10:52:00', focus_f=[4.,6.,8.,10.,12.], UHR_file_name='kuma', duct_wid_data_n=8, IorD='D', lsm=[0.00011982136321245611, 0.00039482015593530725]

    timespan, '2017-04-05/10:25:00', 30.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-05/10:31:30', focus_f=[3.,5.,7.,9.], UHR_file_name='kuma', duct_wid_data_n=28, IorD='D', lsm=[0.00018321061456568263, 0.0003437031160494985]


end