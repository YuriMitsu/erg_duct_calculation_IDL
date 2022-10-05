
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/event_analysis_duct__wfc.pro'

; WFCデータのダクト解析図を作成する用


pro event_analysis_duct__wfc, duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

  test = 0 ; 0: Fig保存あり、画面上plotなし　　　1: Fig保存なし、画面上plotあり

  if not keyword_set(duct_time) then duct_time = '2018-06-02/10:05:56'
  if not keyword_set(focus_f) then focus_f = [3., 4., 5., 6., 7.] ;Hz
  if not keyword_set(UHR_file_name) then UHR_file_name = 'kuma' ;Hz
  if not keyword_set(cut_f) then cut_f = 1E-2 ;nT
  if not keyword_set(k_perp_range) then k_perp_range = 40 ;nT

  ; ******************************
  ; 1.load data
  ; ******************************

  uname = 'erg_project'
  pass = 'geospace'

  ;軌道読み込み
  ;set_erg_var_label
  
  ;磁場読み込み
  erg_load_mgf, datatype='8sec', uname=uname, pass=pass
  erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass

  ;HFA,OFA読み込み
;   erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
   erg_load_pwe_ofa, datatype='matrix', uname=uname, pass=pass
  pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified

  ;WFC読み込み
  erg_load_pwe_wfc, level='l2'

    ; isee_waveから保存しておく！
    ; tplot_save, 'wna', filename='/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/043220_wna'
    ; tplot_save, 'wna_mask', filename='/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/043220_wna_mask'
;   iw_wna_plot = '/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/043220_wna.tplot'
  iw_wna_mask = '/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/043220_wna_mask.tplot'
  iw_ = '/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/erg_pwe_wfc_20170703043220_20170703043250.tplot'
;   tplot_restore, file=[iw_wna_plot, iw_wna_mask, iw_]
  tplot_restore, file=[iw_wna_mask, iw_]
  get_data, 'wna', data = data, dlim=dlim, lim=lim
  store_data, 'kvec_LASVD_ma3', /delete
  store_data, 'kvec_LASVD_ma3', data={x:data.x, y:data.y, v:data.v/1000}, dlim=dlim, lim=lim

  get_data, 'wna_mask', data = data, dlim=dlim, lim=lim
  store_data, 'kvec_LASVD_ma3_mask', /delete
  store_data, 'kvec_LASVD_ma3_mask', data={x:data.x, y:data.y, v:data.v/1000}, dlim=dlim, lim=lim


  ; ******************************
  ; 2.calc.
  ; ******************************
  ; 1. load data で読み込んだデータを使って各物理量を計算する
  ; ここで計算した値は全てtplot変数にして記録する

  ; ******************************
  ; 2.1.calc. wave palams
  ; ******************************

;   calc_wave_params, cut_f=cut_f
  wave_params_ = '_LASVD_ma3'
  
  ; ******************************
  ; 2.2.calc. k_para
  ; ******************************

  calc_fce_and_flhr

  calc_Ne, UHR_file_name=UHR_file_name, wfc=1

  calc_kpara, cut_f=cut_f


  ; ******************************
  ; 2.2.calc. equatorial fce
  ; ******************************

  ; for f_B plot in plot_f_Ne0_f_B 
  calc_equatorial_fce

  ; ******************************
  ; 3.plot
  ; ******************************

  ; ここ納得いかない..
  ; kparaの計算値をlsmとして引き渡している → plotなのに、計算を担っている

  ; ******************************
  ; 3.1. k_para(freq)
  ; ******************************

  calc__f_kpara, focus_f=focus_f, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, lsm=lsm, data__f_kpara=data__f_kpara
  plot_f_kpara, focus_f=focus_f, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, test=test, lsm=lsm, data__f_kpara=data__f_kpara

  ; ******************************
  ; 3.2. Ne(kperp)
  ; ******************************

  calc__Ne_kperp, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, k_perp_range=k_perp_range, data__Ne_kperp=data__Ne_kperp
  plot_Ne_kperp, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, data__Ne_kperp=data__Ne_kperp

  ; ******************************
  ; 3.3. Ne(theta)
  ; ******************************

  calc__Ne_theta, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, k_perp_range=k_perp_range, data__Ne_theta=data__Ne_theta
  plot_Ne_theta, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, data__Ne_theta=data__Ne_theta

  ; ******************************
  ; 8.plot UT_B
  ; ******************************

  plot_UT_B, duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, test=test, data__Ne_kperp=data__Ne_kperp

  ; ******************************
  ; 11.plot f_theta
  ; ******************************
  plot_f_theta, duct_time=duct_time, focus_f=focus_f, test=test, duct_wid_data_n=duct_wid_data_n

  ; ******************************
  ; 12.plot f_Ne0, f_B
  ; ******************************

  stop
  plot_f_Ne0_f_B, duct_time=duct_time, focus_f=focus_f, lsm=lsm,  duct_wid_data_n=duct_wid_data_n, IorD=IorD, test=test, wfc=1
  plot_f_Ne0_f_B, duct_time=duct_time, focus_f=focus_f, lsm=lsm,  duct_wid_data_n=duct_wid_data_n, IorD=IorD, test=1, wfc=1

  ; ******************************
  ; 12.plot hfa(t), kpara(t)
  ; ******************************

  plot_t_hfa_t_kpara, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, test=test



  print, ''
  print, ''
  print, '************************************************************'
  print, ''
  print, ''
  if IorD eq 'I' then print, '            Enh duct ' + duct_time + ' fin.'
  if IorD eq 'D' then print, '            Dep duct ' + duct_time + ' fin.'
  print, ''
  print, ''
  print, '************************************************************'
  print, ''
  print, ''


end