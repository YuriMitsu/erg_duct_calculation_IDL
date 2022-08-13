
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis__lists/enhancement/memo_enh_201704_event_list.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal.pro'

pro memo_enh_201704_event_list

    timespan, '2017-04-07/16:05:00', 50.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-07/16:07:30', focus_f=[1.,2.,3.,4.], UHR_file_name='kuma', duct_wid_data_n=7, IorD='I'
    event_analysis_duct, duct_time='2017-04-07/16:09:35', focus_f=[1.,2.,3.,4.], UHR_file_name='kuma', duct_wid_data_n=3, IorD='I'
    event_analysis_duct, duct_time='2017-04-07/16:11:30', focus_f=[1.,2.,3.,4.], UHR_file_name='kuma', duct_wid_data_n=8, IorD='I'
    event_analysis_duct, duct_time='2017-04-07/16:13:20', focus_f=[1.,2.,3.,4.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='I'
    event_analysis_duct, duct_time='2017-04-07/16:14:32', focus_f=[1.,2.,3.,4.,5.], UHR_file_name='kuma', duct_wid_data_n=3, IorD='I'
    event_analysis_duct, duct_time='2017-04-07/16:43:30', focus_f=[1.,2.,3.,4.], UHR_file_name='kuma', duct_wid_data_n=30, IorD='I'

    timespan, '2017-04-13/14:40:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-13/14:52:31', focus_f=[1.,2.,3.,4.], UHR_file_name='kuma', duct_wid_data_n=9, IorD='I'
    event_analysis_duct, duct_time='2017-04-13/14:54:52', focus_f=[1.,2.,3.,4.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='I'

    timespan, '2017-04-30/07:00:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-30/07:09:55', focus_f=[1.,2.,3.,4.,5.], UHR_file_name='kuma', duct_wid_data_n=13, IorD='I'
    event_analysis_duct, duct_time='2017-04-30/07:12:20', focus_f=[1.,2.,3.,4.,5.], UHR_file_name='kuma', duct_wid_data_n=3, IorD='I'
    event_analysis_duct, duct_time='2017-04-30/07:14:42', focus_f=[1.,2.,3.,4.,5.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='I'


end