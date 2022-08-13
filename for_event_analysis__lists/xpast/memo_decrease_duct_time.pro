pro memo_decrease_duct_time


    ; 2017-04-13/
    timespan, '2017-04-13/08:06:00', 16, /minute
    
    plot_kpara_ne, duct_time='', focus_f=[], UHR_file_name='' ; I


    ; 2017-05-10/04:00:00 前半15
    timespan, '2017-05-10/04:00:00', 15, /minute
    plot_event_normal, UHR_file_name='/UHR_tplots/f_UHR_2017-05-10/040000.tplot' ; 040000-041500.pngを作成
    timespan, '2017-05-10/04:15:00', 15, /minute
    plot_event_normal, UHR_file_name='/UHR_tplots/f_UHR_2017-05-10/040000.tplot' ; 041500-043000.pngを作成
    
    timespan, '2017-05-10/04:00:00', 30, /minute
    plot_kpara_ne, duct_time='2017-05-10/04:04:20', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2017-05-10/040000.tplot', duct_wid_data_n=7, IorD='D' ; D
    plot_kpara_ne, duct_time='2017-05-10/04:09:39', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2017-05-10/040000.tplot', duct_wid_data_n=3, IorD='D' ; D
    plot_kpara_ne, duct_time='2017-05-10/04:09:58', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2017-05-10/040000.tplot', duct_wid_data_n=3, IorD='D' ; D
    plot_kpara_ne, duct_time='2017-05-10/04:11:40', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2017-05-10/040000.tplot', duct_wid_data_n=1, IorD='D' ; D
    plot_kpara_ne, duct_time='2017-05-10/04:13:07', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2017-05-10/040000.tplot', duct_wid_data_n=3, IorD='D' ; D


    ; 2018-06-06/11:25:00 :(2)イベント
    ; timespan, '2018-06-06/11:20:00', 40, /minute
    ; plot_event_normal, UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112000.tplot' ; 112000-120000.pngを作成
    ; timespan, '2018-06-06/11:25:00', 20, /minute
    ; plot_kpara_ne, duct_time='2018-06-06/11:29:40', focus_f=[1., 2., 3., 4., 5.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', duct_wid_data_n=3, IorD='I' ; I
    ; plot_kpara_ne, duct_time='2018-06-06/11:31:25', focus_f=[1., 2., 3., 4.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', duct_wid_data_n=3, IorD='I' ; I
    ; plot_kpara_ne, duct_time='2018-06-06/11:32:29', focus_f=[3., 4., 5., 6., 7.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', lsm=[0.000355,0.00032], duct_wid_data_n=3, IorD='D' ; D
    ; plot_kpara_ne, duct_time='2018-06-06/11:39:53', focus_f=[1., 2., 3., 4., 5.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', duct_wid_data_n=3, IorD='I' ; I
    ; plot_kpara_ne, duct_time='2018-06-06/11:41:33', focus_f=[3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', lsm=[0.000355,0.00032], duct_wid_data_n=7, IorD='D' ; D


    timespan, '2017-06-27/06:40:00', 20, /minute
    plot_event_normal, UHR_file_name='/UHR_tplots/f_UHR_2017-05-10/040000.tplot' ; 041500-043000.pngを作成



    timespan, '2017-07-03/04:05:00', 20, /minute
    plot_event_normal, UHR_file_name='/UHR_tplots/f_UHR_2017-07-03/040500.tplot' ; 040500-042500.pngを作成
    plot_kpara_ne, duct_time='2017-07-03/04:0:40', focus_f=[1., 2., 3., 4., 5.], UHR_file_name='UHR_tplots/f_UHR_2017-07-03/040500.tplot', duct_wid_data_n=3, IorD='I' ; I
    timespan, '2017-07-03/04:25:00', 20, /minute
    plot_event_normal, UHR_file_name='/UHR_tplots/f_UHR_2017-07-03/040500.tplot' ; 042500-044500.pngを作成

    timespan, '2017-04-12/22:15:00', 20, /minute
    plot_event_normal, UHR_file_name='kuma'
    plot_kpara_ne, duct_time='2017-04-12/22:25:09', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=2, IorD='D' ; D
    plot_kpara_ne, duct_time='2017-04-12/22:26:03', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=3, IorD='D' ; D

    timespan, '2017-07-14/02:40:00', 20, /minute
    plot_event_normal, UHR_file_name='kuma'
    plot_kpara_ne, duct_time='2017-07-14/02:51:50', focus_f=[2., 3., 4., 5.], UHR_file_name='kuma', duct_wid_data_n=6, IorD='D' ; D
    plot_kpara_ne, duct_time='2017-07-14/02:53:50', focus_f=[0.4, 0.8, 1.2, 1.6], UHR_file_name='kuma', duct_wid_data_n=2, IorD='I' ; D


end