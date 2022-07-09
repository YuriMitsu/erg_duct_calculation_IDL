
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/event_analysis_duct.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_ave_WNA.pro'

; duct中心の時刻がduct_time
; このproとcalc_ave_WNAは未完成！！

; plot_kpara_neはtimespanを設定してから使用！！

pro event_analysis_duct, duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, kperp_range=kperp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

  test = 0 ; 0: Fig保存あり、画面上plotなし　　　1: Fig保存なし、画面上plotあり

  if not keyword_set(duct_time) then duct_time = '2018-06-02/10:05:56'
  if not keyword_set(focus_f) then focus_f = [3., 4., 5., 6., 7.] ;Hz
  if not keyword_set(UHR_file_name) then UHR_file_name = 'UHR_tplots/f_UHR_2018-06-02/100000-102000.tplot' ;Hz
  if not keyword_set(cut_f) then cut_f = 1E-2 ;nT
  if not keyword_set(kperp_range) then kperp_range = 40 ;nT


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

  plot_f_kpara, focus_f=focus_f, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, test=test ,lsm=lsm

  ; ******************************
  ; 3.2. Ne(kperp)
  ; ******************************

  calc__Ne_kpara, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, kperp_range=kperp_range, kperp=kperp, Ne_k_para=Ne_k_para
  plot_Ne_kpara, test=test, lsm=lsm, kperp_range=kperp_range, kperp=kperp, Ne_k_para=Ne_k_para

  ; ******************************
  ; 3.3. Ne(theta)
  ; ******************************

  calc__Ne_theta, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, kperp_range=kperp_range, theta=theta, Ne_theta=Ne_theta
  plot_Ne_theta, test=test, lsm=lsm, kperp_range=kperp_range, theta=theta, Ne_theta=Ne_theta

  stop

  ; ******************************
  ; 8.plot UT_B
  ; ******************************
  
  plot_UT_B

  ; ******************************
  ; 9.plot theta_Ne
  ; ******************************

  if test eq 0 then begin
    set_plot, 'Z'
    !p.background = 255
    !p.color = 0
  endif

  plot, theta, Ne_theta[*, 0], color=4, yrange=[max([min(Ne_theta)-5, 0.]), min([max(Ne_theta)+5, 500.])] $ $
  ; plot, theta, Ne_theta[*, 0], color=4, yrange=[0, 300] $
        , xtitle='theta [degree]', ytitle='Ne [/cc]'
  oplot, theta, Ne_theta[*, 0], color=10
  oplot, [theta[0]], [Ne_theta[0, 0]], psym=4, color=6
  ; xyouts, theta[2], Ne_theta[0, 0], string(fix(Ne_theta[0, 0]), format='(i0)'), color=10, CHARSIZE=2
  ; xyouts, theta[-8], Ne_theta[-1, 0], string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
  for i = 1, n_elements(focus_f)-1 do begin
    oplot, theta, Ne_theta[*, i], color=i+10
    oplot, [theta[0]], [Ne_theta[0, i]], psym=4, color=6
    ; xyouts, theta[2], Ne_theta[0, i], string(fix(Ne_theta[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
    ; xyouts, theta[-8], Ne_theta[-1, i], string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
  endfor

  if 0 then begin
    calc_ave_WNA

    tinterpol_mxn, 'Ne', 'kvec_ave'

    get_data, 'kvec_ave', data=kvec_avedata
    get_data, 'Ne_interp', data=Nedata

    time_ = time_double(duct_time)
    idx_t = where( kvec_avedata.x lt time_+4. and kvec_avedata.x gt time_-4., cnt )

    kvec__ = kvec_avedata.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n]
    Ne__ = Nedata.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n]

    oplot, kvec__, Ne__, psym=4
  endif


  ; ******************************
  ; 10.plot Ne_theta_withdata
  ; ******************************

  ; ここ、ダクト外のfreqにあたるkvec__を切る作業をしていない　　!!!書き換えないでの使用不可!!!
  ; tinterpol_mxn, 'Ne', 'kvec_LASVD_ma3_mask'

  ; get_data, 'kvec_LASVD_ma3_mask', data=kvec__data
  ; get_data, 'Ne_interp', data=Nedata

  ; time_ = time_double(duct_time)
  ; idx_t = where( kvec__data.x lt time_+4. and kvec__data.x gt time_-4., cnt )

  ; kvec__ = kvec__data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n,*]
  ; Ne__ = Nedata.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n]
  ; for i=0,n_elements(kvec__[0,*])-1 do oplot, kvec__[*,i], Ne__, psym=4

  ; if test eq 0 then begin
  ;   makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_theta_withdata'
  ; endif


  ; ******************************
  ; 11.plot f_theta
  ; ******************************

  if test eq 0 then begin
    set_plot, 'Z'
    !p.background = 255
    !p.color = 0
  endif

  get_data, 'kvec_LASVD_ma3_mask', data=kvec__data

  time_ = time_double(duct_time)
  idx_t = where( kvec__data.x lt time_+4. and kvec__data.x gt time_-4., cnt )

  kvec__ = kvec__data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n,*]

  obs_f = kvec__data.v
  gendrin_angle = fltarr(n_elements(obs_f))
  gendrin_angle = acos( 2.0 * obs_f*1000.0 / fce_ave ) / !pi * 180.0
  kvec__gendrin_diff = fltarr(n_elements(kvec__[*,0]),n_elements(kvec__[0,*]))
  f_kvec__ = fltarr(n_elements(kvec__[*,0]),n_elements(kvec__[0,*]))

  for i=0, n_elements(gendrin_angle)-1 do begin
    kvec__gendrin_diff[*, i] = kvec__[*, i] - gendrin_angle[i]
    f_kvec__[*, i] = obs_f[i]
  endfor





  ;
  ;
  ;  ここから_(┐「ε:)_
  ;
  ;




  polarization_color = indgen(n_elements(obs_f)*7)


  ; t: t方向に潰してplotしたので変数にしてないが、idx_tの前後nデータ分, freq: obs_f, theta-theta_gendrin: kvec__gendrin_diff
  fce_ave_ = fce_ave / 1000.
  plot, obs_f/fce_ave_, gendrin_angle, xtitle='f/fce  '+'(fce = '+fce_loc_string+'kHz)', ytitle='theta [degree]', xrange=[ (min(focus_f)-0.5)/fce_ave_, (max(focus_f)+0.5)/fce_ave_ ]
  oplot, obs_f/fce_ave_, gendrin_angle, color=6
  oplot, fkvec__/fce_ave_, kvec__, psym=4



  ; plot, f_kvec__/fce_ave_, kvec__
  ; colorbar
  ; plots, f_kvec__/fce_ave_, kvec__, color=polarization_color, psym=4
  xyouts, max(focus_f/fce_ave_)-0.04, min(kvec__)+5, 'Gendrin Angle', color=6, CHARSIZE=1.5


  calc_equatorial_fce
  tinterpol_mxn, 'fce_TS04_half', 'erg_pwe_ofa_l2_spec_B_spectra_132'
  get_data, 'fce_TS04_half_interp', data=equatorial_fce
  time_ = time_double(duct_time)
  idx_t = where( equatorial_fce.x lt time_+0.6 and equatorial_fce.x gt time_-0.6, cnt )
  duct_equatorial_fce = equatorial_fce.y[idx_t]

  oplot, [duct_equatorial_fce/fce_ave_, duct_equatorial_fce/fce_ave_], [min(gendrin_angle)-20.,max(gendrin_angle)+20.], linestyle=2
  xyouts, duct_equatorial_fce/fce_ave_+0.1, min(kvec__)+1, 'fce_eq/2 = '+string(duct_equatorial_fce/fce_ave_, format='(f0.1)')+'kHz', CHARSIZE=1.5


  ;
  ;
  ;  ここまで_(┐「ε:)_
  ;
  ;




  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_theta'
  endif

  tvlct, 255, 0, 102, 20
  tvlct, 204, 0, 204, 21
  tvlct, 102, 0, 204, 22
  tvlct, 51, 51, 255, 23
  tvlct, 0, 51, 102, 24
  tvlct, 0, 153, 153, 25
  tvlct, 0, 153, 0, 26
  tvlct, 255, 204, 0, 27
  tvlct, 255, 153, 0, 28

  oplot, obs_f/fce_ave_, gendrin_angle
  xyouts, max(focus_f/fce_ave_)-0.04, min(kvec__)+5, 'Gendrin Angle', CHARSIZE=1.5
  for i=0, n_elements(kvec__[*,0])-1 do oplot, obs_f/fce_ave_, kvec__[i,*], color=i+20, psym=4
  xyouts, max(focus_f), 65, 'obs t', CHARSIZE=1.5
  for i=0, n_elements(kvec__[*,0])-1 do xyouts, max(focus_f/fce_ave_)-0.04, 60-5*i, string(i, format='(i0)'), color=i+20

  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_theta_witht'
  endif

  ; plot, f_kvec__gendrin_diff, kvec__gendrin_diff, xtitle='f [kHz]', ytitle='theta - theta_G [degree]', xrange=[min(focus_f)-0.5, max(focus_f)+0.5]

  ; 確認用 手で調べたやつ いい感じに一致した
  ; 対応するダクト：
  ; timespan, '2018-06-06/11:25:00', 20, /minute
  ; plot_kpara_ne, duct_time='2018-06-06/11:32:29', focus_f=[3., 4., 5., 6., 7.], UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot', lsm=[0.000355,0.00032] ; D
  ; oplot, [3], [64], color=11, psym=4
  ; oplot, [4], [54], color=12, psym=4
  ; oplot, [5], [42], color=13, psym=4
  ; oplot, [6], [27], color=14, psym=4
  ; oplot, [7], [0], color=14, psym=4



  ; ******************************
  ; 12.plot f_Ne0, f_B
  ; ******************************

  plot_f=dindgen(500, increment=0.01, start=focus_f[0])
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