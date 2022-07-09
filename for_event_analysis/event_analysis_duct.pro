
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/event_analysis_duct.pro'

; duct中心の時刻がduct_time
; このproとcalc_ave_WNAは未完成！！

; plot_kpara_neはtimespanを設定してから使用！！

pro event_analysis_duct, duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

  test = 0 ; 0: Fig保存あり、画面上plotなし　　　1: Fig保存なし、画面上plotあり

  if not keyword_set(duct_time) then duct_time = '2018-06-02/10:05:56'
  if not keyword_set(focus_f) then focus_f = [3., 4., 5., 6., 7.] ;Hz
  if not keyword_set(UHR_file_name) then UHR_file_name = 'UHR_tplots/f_UHR_2018-06-02/100000-102000.tplot' ;Hz
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
  erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
  erg_load_pwe_ofa, datatype='matrix', uname=uname, pass=pass
  pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified


  ; ******************************
  ; 2.calc.
  ; ******************************
  ; 1. load data で読み込んだデータを使って各物理量を計算する
  ; ここで計算した値は全てtplot変数にして記録する

  ; ******************************
  ; 2.1.calc. wave palams
  ; ******************************

  calc_wave_params, cut_f=cut_f
  wave_params_ = '_LASVD_ma3'
  
  ; ******************************
  ; 2.2.calc. k_para
  ; ******************************

  calc_fce_and_flhr

  calc_Ne, UHR_file_name=UHR_file_name

  calc_kpara, cut_f=cut_f

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
  stop

  ; ******************************
  ; 12.plot f_Ne0, f_B
  ; ******************************

  plot_f = dindgen(500, increment=0.01, start=focus_f[0])
  Ne_0 = fltarr(n_elements(plot_f))
  Ne_1 = fltarr(n_elements(plot_f))
  k_para_Ne0 = lsm[0] * plot_f + lsm[1]
  b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
  for i=0, n_elements( plot_f )-1 do begin
    f_ = plot_f[i] * 1000. ;kHz -> Hz
    b2 = k_para_Ne0[i]^2 * (fce_ave / f_ - 1 )
    Ne_0[i] = b1 * b2 / 10^(6.) ;cm-3
    b3 = k_para_Ne0[i]^2 * (fce_ave / (2*f_))^2
    Ne_1[i] = b1 * b3 / 10^(6.) ;cm-3
  endfor

  if test eq 0 then begin
    set_plot, 'Z'
    !p.background = 255
    !p.color = 0
  endif
  
  !p.multi=[0,1,2]
  plot, plot_f, Ne_0, xtitle='frequency [kHz]', ytitle='Ne0 [/cc]', yrange=[min([Ne_0,Ne_1])-5,max([Ne_0,Ne_1])+5]
  oplot, plot_f, Ne_1, linestyle='2'
  get_data, 'Ne', data=obs_Ne
  idx_t_Ne = where( obs_Ne.x lt time_+4.0 and obs_Ne.x gt time_-4.0, cnt )
  duct_obs_Ne = obs_Ne.y[idx_t_Ne-duct_wid_data_n:idx_t_Ne+duct_wid_data_n]

  if IorD eq 'I' then begin
    idx_Ne = where( duct_obs_Ne eq max(duct_obs_Ne), cnt )
    duct_obs_Ne_top = duct_obs_Ne[ idx_Ne[0] ]
  endif else begin
  if IorD eq 'D' then begin
    idx_Ne = where( duct_obs_Ne eq min(duct_obs_Ne), cnt )
    duct_obs_Ne_top = duct_obs_Ne[ idx_Ne[0] ]
  endif else begin
    print, 'Please specify an argument IorD'
  endelse
  endelse



  oplot, [plot_f[0]-1,plot_f[-1]+1], [duct_obs_Ne_top,duct_obs_Ne_top]
  xyouts, plot_f[-1]-0.5, duct_obs_Ne_top+2., string(duct_obs_Ne_top, format='(i0)'), CHARSIZE=1.5
  
  dif = Ne_0-duct_obs_Ne_top
  idx_dif = where( dif[0:-2] * dif[1:-1] lt 0, cnt )
  if idx_dif[0] ne -1 then begin
    for i=0, n_elements(idx_dif)-1 do begin
      duct_f = plot_f[idx_dif[i]]
      oplot, [duct_f,duct_f], [min(Ne_0)-300,max(Ne_0)+300]
      ; xyouts, duct_f+0.1, min(Ne_0), string(duct_f, format='(f0.1)'), CHARSIZE=2
    endfor
  endif

  ; if test eq 0 then begin
  ;   makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_Ne0'
  ; endif

  get_data, 'erg_pwe_ofa_l2_spec_B_spectra_132', data = Bdata
  time_ = time_double(duct_time)
  idx_t = where( Bdata.x lt time_+0.51 and Bdata.x gt time_-0.51, cnt )
  Bdata.y[idx_t,*] = mean(Bdata.y[idx_t-25:idx_t+25, *], DIMENSION=1, /nan)

  plot, Bdata.v, Bdata.y[idx_t,*], xtitle='frequency [kHz]', ytitle='OFA-SPEC B [pT^2/Hz]', xrange=[min(plot_f), max(plot_f)]

  if idx_dif[0] ne -1 then begin
    for i=0, n_elements(idx_dif)-1 do begin
      duct_f = plot_f[idx_dif[i]]
      oplot, [duct_f,duct_f], [min(Bdata.y[idx_t,*])-0.1,max(Bdata.y[idx_t,*])+0.1]
      ; xyouts, duct_f+0.1, min(), string(duct_f, format='(f0.1)'), CHARSIZE=2
    endfor

  endif

  calc_equatorial_fce
  tinterpol_mxn, 'fce_TS04_half', 'erg_pwe_ofa_l2_spec_B_spectra_132'
  get_data, 'fce_TS04_half_interp', data=equatorial_fce
  time_ = time_double(duct_time)
  idx_t = where( equatorial_fce.x lt time_+0.6 and equatorial_fce.x gt time_-0.6, cnt )
  duct_equatorial_fce = equatorial_fce.y[idx_t]

  oplot, [duct_equatorial_fce, duct_equatorial_fce], [min(Bdata.y[idx_t,*])-0.1,max(Bdata.y[idx_t,*])+0.1], linestyle=2
  xyouts, duct_equatorial_fce+0.1, min(Bdata.y[idx_t,*])+0.00, 'fce_eq/2 = '+string(duct_equatorial_fce, format='(f0.1)'), CHARSIZE=1.5

  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_Ne0_f_B'
  endif



  ; ******************************
  ; 12.plot hfa_kpara_mask
  ; ******************************

  get_data, 'Ne', data=data
  idx_duct_t = ( where( data.x lt time_double(duct_time)+5. and data.x gt time_double(duct_time)-5., cnt ) )[0]
  Ne_max =  max( [FLOAT(data.y[idx_duct_t]+20.), Ne_k_para[0, 0], Ne_k_para[0, -1]] )
  idx_duct_start = ( where( data.x lt time_double(time1)+5. and data.x gt time_double(time1)-5., cnt ) )[0]
  idx_duct_end = ( where( data.x lt time_double(time2)+5. and data.x gt time_double(time2)-5., cnt ) )[0]
  Ne_min_ = FLOAT( min(data.y[idx_duct_start:idx_duct_end]) )
  Ne_min =  max( [min( [Ne_min_, Ne_k_para[0, 0], Ne_k_para[0, -1]] ), 0.] )
  ylim, 'Ne', Ne_min, Ne_max, 0
  ylim, 'kvec'+wave_params_+'_mask', 0., 9.0, 0
  timespan, time_string(time_double(duct_time)-120. ), 4, /minute
  tplot, ['Ne', 'kvec'+wave_params_+'_mask']
  timebar, duct_time

  ret = strsplit(duct_time, '-/:', /extract)
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_hfa_kpara_mask'
  endif

  ;
  ;
  ;  ここまで_(┐「ε:)_
  ;
  ;


end