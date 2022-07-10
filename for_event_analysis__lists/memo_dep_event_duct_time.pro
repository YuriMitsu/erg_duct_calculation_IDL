
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis__lists/memo_dep_event_duct_time.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/event_analysis_duct.pro'

pro memo_dep_event_duct_time

    timespan, '2018-06-06/11:25:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2018-06-06/112500.tplot'
    event_analysis_duct, duct_time='2018-06-06/11:41:33', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2018-06-06/112500.tplot', duct_wid_data_n=7.0, IorD='D'', lsm=[0.00037287, 0.000200686]

    timespan, '2017-04-12/22:15:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-12/22:25:09', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-04-12/22:26:03', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'

    timespan, '2017-07-14/02:40:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-07-14/02:51:50', focus_f=[2., 3., 4., 5.], UHR_file_name='kuma', duct_wid_data_n=6.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-14/02:53:50', focus_f=[0.4, 0.8, 1.2, 1.6], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='I'

    timespan, '2017-04-11/08:00:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-04-11/08:07:47', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'
    event_analysis_duct, duct_time='2017-04-11/08:09:14', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'
    event_analysis_duct, duct_time='2017-04-11/08:10:25', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-04-11/08:12:13', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'
    event_analysis_duct, duct_time='2017-04-11/08:14:49', focus_f=[6.,8.,10.,12.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'

    timespan, '2017-05-15/06:10:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-05-15/06:29:22', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-15/06:30:09', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-15/06:32:03', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=5.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-15/06:33:28', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-15/06:39:22', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-15/06:40:04', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-15/06:41:29', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-15/06:44:11', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'

    timespan, '2017-05-15/22:25:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-05-15/22:37:41', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=10.0, IorD='D'

    timespan, '2017-05-26/07:25:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-05-26/07:30:44', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=7.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-26/07:34:03', focus_f=[8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-26/07:35:48', focus_f=[8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=9.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-26/07:40:12', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'

    timespan, '2017-05-30/15:25:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-05-30/15:36:22', focus_f=[5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-30/15:39:34', focus_f=[5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'
    event_analysis_duct, duct_time='2017-05-30/15:41:31', focus_f=[5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'

    timespan, '2017-05-30/15:45:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-05-30/15:54:53', focus_f=[4.,5.,6.,7.,8.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'

    timespan, '2017-06-18/13:50:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-06-20/04:00:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-07-03/04:05:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-07-03/04:09:46', focus_f=[8.,10.,12.,14.,16.,18.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-03/04:11:43', focus_f=[10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-03/04:13:16', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-03/04:14:04', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-03/04:16:39', focus_f=[8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'

    timespan, '2017-07-03/04:25:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-07-03/04:27:14', focus_f=[5.,7.,9.,11.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-03/04:28:07', focus_f=[5.,7.,9.,11.], UHR_file_name='kuma', duct_wid_data_n=0.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-03/04:32:46', focus_f=[4.,6.,8.,10.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D'

    timespan, '2017-07-26/20:15:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'
    event_analysis_duct, duct_time='2017-07-26/20:19:12', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-26/20:21:05', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=4.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-26/20:24:09', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=4.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-26/20:27:19', focus_f=[2.,3.,4.,5.,6.], UHR_file_name='kuma', duct_wid_data_n=6.0, IorD='D'
    event_analysis_duct, duct_time='2017-07-26/20:29:39', focus_f=[2.,3.,4.,5.,6.], UHR_file_name='kuma', duct_wid_data_n=5.0, IorD='D'

    timespan, '2018-04-05/10:33:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'

    timespan, '2018-04-20/01:15:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'

    timespan, '2018-05-26/10:35:00', 20.0, /minute 
    ;plot_event_normal, UHR_file_name='kuma'


end