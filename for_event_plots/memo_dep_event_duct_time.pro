
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_plots/memo_dep_event_duct_time.pro'

pro memo_decrease_duct_time

    ; timespan, '2018-06-06/11:25:00', 20.0, /minute 
    ; plot_event_normal, UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'
    ; plot_kpara_ne, duct_time='2018-06-06/11:41:33', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', duct_wid_data_n=7.0, IorD='D', lsm=[0.00037287, 0.000200686]

    ; timespan, '2017-04-12/22:15:00', 20.0, /minute 
    ; plot_event_normal, UHR_file_name='kuma'
    ; plot_kpara_ne, duct_time='2017-04-12/22:25:09', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D
    ; plot_kpara_ne, duct_time='2017-04-12/22:26:03', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D

    ; timespan, '2017-07-14/02:40:00', 20.0, /minute 
    ; plot_event_normal, UHR_file_name='kuma'
    ; plot_kpara_ne, duct_time='2017-07-14/02:51:50', focus_f=[2., 3., 4., 5.], UHR_file_name='kuma', duct_wid_data_n=6.0, IorD='D
    ; plot_kpara_ne, duct_time='2017-07-14/02:53:50', focus_f=[0.4, 0.8, 1.2, 1.6], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='I

    timespan, '2017-04-11/08:00:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-05-15/06:10:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-05-15/06:30:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-05-15/22:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    ; timespan, '2017-05-22/00:??', 20.0, /minute 
    ; plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-05-26/07:20:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-05-26/07:40:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-05-30/15:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-05-30/15:45:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-06-18/13:50:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-06-20/04:00:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-07-03/04:05:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-07-03/04:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-07-26/20:15:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2018-04-05/10:33:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2018-04-20/01:15:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2018-05-26/10:35:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'


end