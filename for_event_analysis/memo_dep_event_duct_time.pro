
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/memo_dep_event_duct_time.pro'

pro memo_decrease_duct_time

    timespan, '2018-06-06/11:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'
    plot_kpara_ne, duct_time='2018-06-06/11:41:33', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', duct_wid_data_n=7, IorD='D', lsm=[0.00037287, 0.000200686]

    timespan, '2017-04-12/22:15:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    plot_kpara_ne, duct_time='2017-04-12/22:25:09', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='D'
    plot_kpara_ne, duct_time='2017-04-12/22:26:03', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=3, IorD='D'

    timespan, '2017-07-14/02:40:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    plot_kpara_ne, duct_time='2017-07-14/02:51:50', focus_f=[2., 3., 4., 5.], UHR_file_name='kuma', duct_wid_data_n=6, IorD='D'
    plot_kpara_ne, duct_time='2017-07-14/02:53:50', focus_f=[0.4, 0.8, 1.2, 1.6], UHR_file_name='kuma', duct_wid_data_n=2, IorD='I'

    timespan, '2017-07-03/04:15:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    plot_kpara_ne, duct_time='2017-07-03/04:11:30', focus_f=[9., 9.5, 10., 10.5, 11.], UHR_file_name='kuma', duct_wid_data_n=4, IorD='D'

    timespan, '2017-07-03/04:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    plot_kpara_ne, duct_time='2017-07-03/04:40:00', focus_f=[4.5, 5., 5.5, 6., 6.5], UHR_file_name='kuma', duct_wid_data_n=1, IorD='D'


end