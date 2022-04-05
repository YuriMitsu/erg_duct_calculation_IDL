pro memo_duct_time_focus_f

  ; plot_kpara_neはtimespanを設定してから使用！！
  ; [1., 2., 3., 4., 5., 6., 7., 8.]
  
  ; 最初のイベント
  timespan, '2018-06-02/10:00:00', 20, /minute
  plot_kpara_ne, duct_time='2018-06-02/10:04:00', focus_f=[3., 4., 5., 6., 7.], cut_f=1E-4 ;ダクト外比較用
  plot_kpara_ne, duct_time='2018-06-02/10:05:56', focus_f=[3., 4., 5., 6., 7., 8.] ;, lsm = [0.00018982743, 0.00018986984]
  plot_kpara_ne, duct_time='2018-06-02/10:09:40', focus_f=[3., 4., 5., 6., 7.];, lsm = [0.00027217917, 0.00015393361]
  plot_kpara_ne, duct_time='2018-06-02/10:11:20', focus_f=[3., 4., 5., 6., 7., 8.]
  
  
  ; 入れ子になっているイベント
  ; timespan, '2018-06-06/11:20:00', 40, /minute
  ; plot_event, UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'
  timespan, '2018-06-06/11:25:00', 20, /minute
  plot_kpara_ne, duct_time='2018-06-06/11:29:35', focus_f=[1., 2., 3., 4., 5.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'
  plot_kpara_ne, duct_time='2018-06-06/11:31:28', focus_f=[1., 2., 3., 4., 5.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'
  plot_kpara_ne, duct_time='2018-06-06/11:32:29', focus_f=[3., 4., 5., 6., 7.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'
  plot_kpara_ne, duct_time='2018-06-06/11:39:53', focus_f=[1., 2., 3., 4., 5.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'
  plot_kpara_ne, duct_time='2018-06-06/11:42:08', focus_f=[2., 3., 4., 5., 6.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'

  ; 特にこの４つ 2018-06-06/11:29:56, 2018-06-06/11:31:28, 2018-06-06/11:32:29, 2018-06-06/11:39:53
  ; 以下弱いのも含めた１４こ
  ; 2018-06-06/11:27:40, 2018-06-06/11:29:56, 2018-06-06/11:31:28, 2018-06-06/11:32:29, 2018-06-06/11:33:57, 2018-06-06/11:35:21, 2018-06-06/11:36:00
  ; 2018-06-06/11:36:23, 2018-06-06/11:36:58, 2018-06-06/11:37:17, 2018-06-06/11:38:02 ,2018-06-06/11:39:53, 2018-06-06/11:40:35, 2018-06-06/11:42:08
  ; 2018-06-06/11:43:46


  ; 粒子のデータが見えているイベント
  ; timespan, '2018-07-10/05:20:00', 30, /minute
  ; plot_event_normal, UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'
  ; plot_event_mepe, UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'
  timespan, '2018-07-10/05:25:00', 20, /minute
  plot_kpara_ne, duct_time='2018-07-10/05:31:15', focus_f=[0.1, 0.3, 0.5, 0.7, 0.9, 1.1, 1.3], UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot', k_perp_range=80
  plot_kpara_ne, duct_time='2018-07-10/05:32:06', focus_f=[0.1, 0.3, 0.5, 0.7, 0.9, 1.1, 1.3], UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'
  plot_kpara_ne, duct_time='2018-07-10/05:34:07', focus_f=[0.1, 0.3, 0.5, 0.7, 0.9, 1.1, 1.3], UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'
  plot_kpara_ne, duct_time='2018-07-10/05:36:25', focus_f=[0.1, 0.3, 0.5, 0.7, 0.9, 1.1, 1.3], UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'
  plot_kpara_ne, duct_time='2018-07-10/05:37:44', focus_f=[0.1, 0.3, 0.5, 0.7, 0.9, 1.1, 1.3], UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'
  plot_kpara_ne, duct_time='2018-07-10/05:38:03', focus_f=[0.1, 0.3, 0.5, 0.7, 0.9, 1.1, 1.3], UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'

  
end