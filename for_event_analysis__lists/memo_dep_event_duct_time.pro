
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis__lists/memo_dep_event_duct_time.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/event_analysis_duct.pro'

pro memo_dep_event_duct_time

    timespan, '2018-06-06/11:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2018-06-06/11:41:33', focus_f=[2.,3.,4.,5.,6.], UHR_file_name='kuma', duct_wid_data_n=7.0, IorD='D', lsm=[0.00037287, 0.000200686]

    timespan, '2017-04-12/22:15:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-04-12/22:25:09', focus_f=[2.,3.,4.,5.,6.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.00011376926549760376, 0.0004171912826452921]
    ;event_analysis_duct, duct_time='2017-04-12/22:26:03', focus_f=[2.,3.,4.,5.,6.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.00014294477713674156, 0.0002738545817206499]

    timespan, '2017-07-14/02:40:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-07-14/02:51:50', focus_f=[2.,3.,4.,5.], UHR_file_name='kuma', duct_wid_data_n=6.0, IorD='D', lsm=[0.00011777949274519999, 0.0001460287142823464]
    ;event_analysis_duct, duct_time='2017-07-14/02:53:50', focus_f=[0.4, 0.8, 1.2, 1.6], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='I', lsm=[0.00044259922016848664, 0.000046475228845835536]

    timespan, '2017-04-11/08:00:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-04-11/08:07:47', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.0002126554104742885, 0.0002558529595174238]
    ;event_analysis_duct, duct_time='2017-04-11/08:09:14', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.00021225635220557855, 0.00040013595118899874]
    ;event_analysis_duct, duct_time='2017-04-11/08:10:25', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.00021216175770563935, 0.0003293091111066893]
    ;event_analysis_duct, duct_time='2017-04-11/08:12:13', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.00023257701427598627, 0.0004117647897177388]
    ;event_analysis_duct, duct_time='2017-04-11/08:14:49', focus_f=[6.,8.,10.,12.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.00022466630247720205, 0.0003387805947153649]

    timespan, '2017-05-15/06:10:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-05-15/06:29:22', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.0007094221505534363, -0.0009700368432542817]
    ;event_analysis_duct, duct_time='2017-05-15/06:30:09', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.0006223939141574966, -0.0006030267064318766]
    ;event_analysis_duct, duct_time='2017-05-15/06:32:03', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=5.0, IorD='D', lsm=[0.0006633156502643323, -0.0006974643555445389]
    ;event_analysis_duct, duct_time='2017-05-15/06:33:28', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.0006945339342840507, -0.0008246574256852181]
    ;event_analysis_duct, duct_time='2017-05-15/06:39:22', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.000728928335580851, -0.0013534602184820624]
    ;event_analysis_duct, duct_time='2017-05-15/06:40:04', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.0007791763353445447, -0.0018464398732416251]
    ;event_analysis_duct, duct_time='2017-05-15/06:41:29', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.0009175533997120385, -0.002588340672747758]
    ;event_analysis_duct, duct_time='2017-05-15/06:44:11', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.000803244402903017, -0.002249430325224485]

    timespan, '2017-05-15/22:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-05-15/22:37:41', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=10.0, IorD='D', lsm=[0.00027869147852899927, 0.0005865891262814288]

    timespan, '2017-05-26/07:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-05-26/07:30:44', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=7.0, IorD='D', lsm=[0.0005548292959752806, -0.0013075375454726203]
    ;event_analysis_duct, duct_time='2017-05-26/07:34:03', focus_f=[8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.0006467058244379748, -0.0014308087255944042]
    ;event_analysis_duct, duct_time='2017-05-26/07:35:48', focus_f=[8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=9.0, IorD='D', lsm=[0.0006096636659383255, -0.0012371973084091996]
    ;event_analysis_duct, duct_time='2017-05-26/07:40:12', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.0006731023521796008, -0.0012952956062034899]

    timespan, '2017-05-30/15:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-05-30/15:36:22', focus_f=[5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.00013625921018883117, 0.0009291982997271811]
    ;event_analysis_duct, duct_time='2017-05-30/15:39:34', focus_f=[5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.00022281190447744314, -8.880490311452296e-05]
    ;event_analysis_duct, duct_time='2017-05-30/15:41:31', focus_f=[5.,6.,7.,8.,9.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.00022800258169935385, 0.00025948342726687354]

    timespan, '2017-05-30/15:45:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-05-30/15:54:53', focus_f=[4.,5.,6.,7.,8.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.0003212277118179267, 0.00013250311640160728]

    timespan, '2017-06-18/13:50:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-06-20/04:00:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-07-03/04:05:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-07-03/04:09:46', focus_f=[8.,10.,12.,14.,16.,18.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.00031016927862050547, -0.0007316282600779312]
    ;event_analysis_duct, duct_time='2017-07-03/04:11:43', focus_f=[10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=3.0, IorD='D', lsm=[0.0003341311203341909, -0.0005238591548605215]
    ;event_analysis_duct, duct_time='2017-07-03/04:13:16', focus_f=[8.,10.,12.,14.,16.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.000400312469939152, -0.0007442854638101969]
    ;event_analysis_duct, duct_time='2017-07-03/04:14:04', focus_f=[6.,8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.0003569149466797103, -0.00026137847578578375]
    ;event_analysis_duct, duct_time='2017-07-03/04:16:39', focus_f=[8.,10.,12.,14.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.0003225582822909527, -0.0009489915882947956]

    timespan, '2017-07-03/04:25:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-07-03/04:27:14', focus_f=[5.,7.,9.,11.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.0002753873865639427, -2.069217638500817e-05]
    ;event_analysis_duct, duct_time='2017-07-03/04:28:07', focus_f=[5.,7.,9.,11.], UHR_file_name='kuma', duct_wid_data_n=0.0, IorD='D', lsm=[0.00021827477673731413, -2.3767939392336777e-05]
    ;event_analysis_duct, duct_time='2017-07-03/04:32:46', focus_f=[4.,6.,8.,10.], UHR_file_name='kuma', duct_wid_data_n=1.0, IorD='D', lsm=[0.0002624997909987045, 0.0006075894584115151]

    timespan, '2017-07-26/20:15:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'
    ;event_analysis_duct, duct_time='2017-07-26/20:19:12', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=2.0, IorD='D', lsm=[0.00021827477673731413, -2.3767939392336777e-05]
    ;event_analysis_duct, duct_time='2017-07-26/20:21:05', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=4.0, IorD='D', lsm=[0.00016425724550691982, 0.000223198166299865]
    ;event_analysis_duct, duct_time='2017-07-26/20:24:09', focus_f=[3.,4.,5.,6.,7.], UHR_file_name='kuma', duct_wid_data_n=4.0, IorD='D', lsm=[0.0001723245251390325, 0.00024346746570502254]
    ;event_analysis_duct, duct_time='2017-07-26/20:27:19', focus_f=[2.,3.,4.,5.,6.], UHR_file_name='kuma', duct_wid_data_n=6.0, IorD='D', lsm=[0.0001687467857048692, 0.0001819452092707107]
    ;event_analysis_duct, duct_time='2017-07-26/20:29:39', focus_f=[2.,3.,4.,5.,6.], UHR_file_name='kuma', duct_wid_data_n=5.0, IorD='D', lsm=[0.00019783970059613932, 0.00014450882091112123]

    timespan, '2018-04-05/10:33:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2018-04-20/01:15:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2018-05-26/10:35:00', 20.0, /minute 
    plot_event_normal, UHR_file_name='kuma'

    print, ''
    print, ''
    print, '************************************************************'
    print, ''
    print, ''
    print, '                !!! duct event plot DONE !!!'
    print, ''
    print, ''
    print, '************************************************************'
    print, ''
    print, ''

end