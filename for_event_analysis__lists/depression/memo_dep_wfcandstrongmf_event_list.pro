
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis__lists/depression/memo_dep_wfcandstrongmf_event_list.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal_5min.pro'

pro memo_dep_wfcandstrongmf_event_list

    timespan, '2017-07-03/04:20:00', 25.0, /minute 
    ;plot_event_normal_5min, UHR_file_name='kuma'
    event_analysis_duct__wfc, duct_time='2017-07-03/04:32:32', focus_f=[4.,5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=uint(2.0/0.037617), IorD='D', lsm=[0.0003885061167220895, 0.00014587832147501856]
    ; event_analysis_duct, duct_time='2017-07-03/04:32:32', focus_f=[4.,5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1, IorD='D'
    event_analysis_duct, duct_time='2017-07-03/04:32:50', focus_f=[4.,5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1, IorD='D', lsm=[0.0002624997909987045, 0.0006075894584115151]

    timespan, '2017-12-01/23:25:00', 15.0, /minute 
    ;plot_event_normal_5min, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-12-01/23:36:32', focus_f=[4.,5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=4, IorD='D', lsm=[0.0001657776593928861, 0.0007098478980064288]

    timespan, '2018-08-24/13:45:00', 30.0, /minute 
    ;plot_event_normal_5min, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2018-08-24/13:46:30', focus_f=[3.,4.,5.,6.,7.,8.], UHR_file_name='kuma', duct_wid_data_n=4, IorD='D', lsm=[0.00044576302856956713, 1.5555388312756606e-05]


end