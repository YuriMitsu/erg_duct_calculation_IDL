
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_kpara_ne.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_ave_WNA.pro'

; duct中心の時刻がduct_time
; このproとcalc_ave_WNAは未完成！！
; 着目するダクトによって手書きで周波数方向と時間方向のデータ数を決めないと各ダクトの大きさに対応できない...
; うまく修正できたら良いな...


function least_squares_method,x,y
  gate = [finite(x,/nan) + finite(y,/nan) eq 0]
  x_ = x[where(gate)]
  y_ = y[where(gate)]
  a = total( (x_-mean(x_))*(y_-mean(y_)) ) / total( (x_-mean(x_))^2 )
  b = mean(y_) - a*mean(x_)
  return, [a,b]
end

; plot_kpara_neはtimespanを設定してから使用！！
pro plot_kpara_ne, duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, k_para_=k_para_, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

  test = 1 ; 0: Fig保存あり、画面上plotなし　　　1: Fig保存なし、画面上plotあり

  if not keyword_set(duct_time) then duct_time = '2018-06-02/10:05:56'
  if not keyword_set(focus_f) then focus_f = [3., 4., 5., 6., 7.] ;Hz
  if not keyword_set(UHR_file_name) then UHR_file_name = 'UHR_tplots/f_UHR_2018-06-02/100000-102000.tplot' ;Hz
  if not keyword_set(cut_f) then cut_f = 1E-2 ;nT
  if not keyword_set(k_perp_range) then k_perp_range = 40 ;nT


  ; timespan, '2018-06-02/10:00:00', 20, /minute

  ; *****************
  ; 1.load data
  ; *****************

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


  ; *****************
  ; 2.calc. wave palams
  ; *****************

  calc_wave_params
  wave_params_ = '_LASVD_ma3'
  
  ; *****************
  ; 3.calc. k_para
  ; *****************

  SET_PLOT, 'X'
  !p.BACKGROUND = 255
  !p.color = 0

  tinterpol_mxn, 'erg_mgf_l2_magt_8sec', 'polarization'+wave_params_
  get_data, 'erg_mgf_l2_magt_8sec_interp', data=magt
  get_data, 'polarization'+wave_params_, data=pol

  f = pol.v

;  read_f_uhr
  tplot_restore, file=[UHR_file_name]
  get_data, 'f_UHR', data=data
  ; store_data, 'test', data={x:data.x, y:data.y}, dlim={colors:5,thick:1,linestyle:1}
  tinterpol_mxn, 'f_UHR', 'polarization'+wave_params_
  options, 'f_UHR_interp', linestyles=0
  get_data, 'f_UHR_interp', data=f_UHR
  store_data, 'erg_pwe_hfa', data=['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR_interp']
  ylim, 'erg_pwe_hfa', 20.0, 200.0, 0
  tplot, 'erg_pwe_hfa'

  f_ce = magt.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi ; in Hz ,DはDOUBLEのD
  f_pe = sqrt( (f_UHR.y*10^(3.))^2. - f_ce^2. ) ; Hz
;  f_pe_test = sqrt( (f_UHR.y)^2. - f_ce^2./10^(6.) ) * 10^(3.) ; Hz
  Ne_ = (f_pe * 2 * !pi)^2 * (9.1093D * 10^(-31.)) * (8.854D * 10^(-12.)) /  (1.602D * 10^(-19.))^2 / 10^(6.) ;cm-3


  ; 観測した伝搬角
  get_data, 'kvec'+wave_params_, data=data
  wna = data.y

  alpha = wna / 180 * !pi
  store_data, 'Ne', data={x:data.x, y:Ne_} ;, v:s00.v2}
  ylim, 'Ne', 10.0, 1000.0, 1
  ;  erg_load_pwe_hfa, level='l3', uname='erg_project', pass='geospace' ; neの参考 桁の一致を確認済み
  store_data, 'f_pe', data={x:data.x, y:f_pe}

  k_para = fltarr(n_elements(alpha[*,0]), n_elements(alpha[0,*])) ;[timerange, freqrange]
  for i=0,n_elements(alpha[0,*])-1 do begin
    alpha_ = alpha[*,i] 
    c = 2.99 * 10^(8.)
    a1 = 4 * !pi^2 * f_pe^2 / c^2
    a2 = f_ce / (f[i] * 10^(3.)) / cos(alpha_)
    a3 = 1 / (cos(alpha_))^2
    k_para[*,i] = sqrt( a1 / (a2-a3) )
  endfor

  store_data, 'f_ce', data={x:data.x, y:f_ce, v:data.v}
  store_data, 'k_para'+wave_params_, data={x:data.x, y:k_para, v:data.v}
  options, 'k_para'+wave_params_, ytitle='k_para', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'k_para'+wave_params_, focus_f[0]-0.5, focus_f[-1]+0.5, 0 ; kHz
  zlim, 'k_para'+wave_params_, 1.e-4, 5.e-3, 1 ;適宜ここ決める！


  ; *****************
  ; 4.mask
  ; *****************

  get_data, pr_matrix + 'Btotal_132', data=data_ref; *** modified (B_total_132 -> Btotal_132)
  ; kvec
  get_data, 'kvec'+wave_params_, data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'kvec'+wave_params_+'_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
  ; polarization
  get_data, 'polarization'+wave_params_, data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'polarization'+wave_params_+'_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
  ; k_para
  get_data, 'k_para'+wave_params_, data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'k_para'+wave_params_+'_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
  
    ; 保存するplotのwindowを用意
  if test eq 0 then begin
    SET_PLOT, 'Z'
    DEVICE, SET_RESOLUTION = [1000,600]
    !p.BACKGROUND = 255
    !p.color = 0
  endif


  options, 'erg_pwe_hfa', 'color_table', 43
  options, 'k_para'+wave_params_+'_mask', 'color_table', 43
  timespan, time_string(time_double(duct_time)-120. ), 4, /minute
  tplot, ['erg_pwe_hfa', 'k_para'+wave_params_+'_mask']

  options, 'kvec'+wave_params_+'_mask', 'color_table', 43
  ylim, 'Ne', 150, 400, 0
  ylim, 'kvec'+wave_params_+'_mask', 1., 9.0, 0
  timespan, time_string(time_double(duct_time)-120. ), 4, /minute
  tplot, ['Ne', 'kvec'+wave_params_+'_mask']

  ret = strsplit(duct_time, '-/:', /extract)
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_hfa_kpara_mask'
  endif



  ; *****************
  ; 5.get k_para(freq)
  ; *****************
  ;2018-06-02/10:05:56のk_paraを試しに周波数方向に切り出してみる
  
  ; 保存するplotのwindowを用意
  if test eq 0 then begin
    SET_PLOT, 'Z'
    DEVICE, SET_RESOLUTION = [1000,600]
    !p.BACKGROUND = 255
    !p.color = 0
  endif
  
  get_data, 'k_para'+wave_params_+'_mask', data = k_paradata
  k_paradata.y[*, where(k_paradata.v lt focus_f[0]-0.1) ] = 'NaN'
  k_paradata.y[*, where(k_paradata.v gt focus_f[-1]+0.1) ] = 'NaN'

  time_ = time_double(duct_time)
  idx_t = where( k_paradata.x lt time_+4. and k_paradata.x gt time_-4., cnt )




  ; ダクトに合わせて変える or 消す！！！
  ; k_paradata.y[idx_t[0], *] = mean(k_paradata.y[idx_t[0]-3:idx_t[0]+3, *], DIMENSION=1, /nan)
  k_paradata.y[idx_t[0], *] = mean(k_paradata.y[idx_t[0]-duct_wid_data_n:idx_t[0]+duct_wid_data_n, *], DIMENSION=1, /nan)
  ; print, k_paradata.x[idx_t[0]+10]-k_paradata.x[idx_t[0]-10]
  ; print, time_string(k_paradata.x[idx_t[0]+10])
  ; print, time_string(k_paradata.x[idx_t[0]-10])

  ; stop




  if idx_t eq -1 then begin
    print, '!!!!Caution!!!! /n Duct time is not selected correctly. Check the code.'
    stop
  endif
  !p.multi=0
  plot, k_paradata.v, k_paradata.y[idx_t[0], *], psym=-4, xtitle='f (kHz)', ytitle='k_para (/m)'

  ; 最小二乗法でダクト中心でのk_paraを直線に当てはめる
  if not keyword_set(lsm) then begin
    lsm = least_squares_method(k_paradata.v, k_paradata.y[idx_t[0], *]) ;外れ値に左右され過ぎてしまう 余裕があったらロバスト回帰を導入？
    ; mask_lsm = ( (k_paradata.y[idx_t[0],*]-lsm[0]*k_paradata.v+lsm[1]) lt 0.001 )
    ; k_paradatay = k_paradata.y[idx_t[0], *]
    ; lsm = least_squares_method(k_paradata.v*[mask_lsm], k_paradatay*[mask_lsm])
  endif
;  k_para_ = [ 0.00072889862, 0.00084289216, 0.0010308567, 0.0013732987, 0.0016690817] ; 3,4,5,6,7
;  k_para_ = [0.00074098376,    0.0012041943,    0.0016674048,    0.0019,    0.00235]
;  f_ = [3000., 4000., 5000., 6000., 7000.] ;Hz
  
  ; if not keyword_set(k_para_) then k_para_ = lsm[0] * focus_f + lsm[1]
  k_para_ = lsm[0] * focus_f + lsm[1]

  plot, [0., 15.], lsm[0] * [0., 15.] + lsm[1], xtitle='f (kHz)', ytitle='k_para (/m)'

  oplot, k_paradata.v, k_paradata.y[idx_t[0], *], psym=-4
  tvlct, 255,0,0,1
  oplot, focus_f, k_para_, psym=2, color=1
  lsm_f = [min(k_paradata.v), max(k_paradata.v)]
  lsm_k_para = lsm[0] * lsm_f + lsm[1]
  oplot, lsm_f, lsm_k_para, color=1
  
  ; 保存
  ret = strsplit(duct_time, '-/:', /extract)
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_kpara'
  endif


  ; *****************
  ; 6.1.calculate Ne(k_perp)
  ; *****************
  if 0 then begin
    get_data, 'f_ce', data=f_cedata
    idx_t_ = where( f_cedata.x lt time_+5. and f_cedata.x gt time_-5., cnt )
    f_ce_ave = f_cedata.y[idx_t_[0]]
  ;  f_chorus = [3000., 4000., 5000., 6000., 7000.] ;Hz
    
    k_perp = dindgen(k_perp_range, increment=0.0001, start=0.0)
    
    Ne_k_para = fltarr(n_elements(k_perp), n_elements(focus_f))

    for i=0, n_elements( focus_f )-1 do begin
      f_ = focus_f[i] * 1000. ;kHz -> Hz
      b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
      b2 = - k_perp^2 + f_ce_ave / f_ * k_para_[i] * sqrt( k_para_[i]^2 + k_perp^2 ) - k_para_[i]^2
      Ne_k_para[*, i] = b1 * b2 / 10^(6.) ;cm-3
    endfor
  endif

  ; *****************
  ; 6.2.calculate Ne(theta)
  ; *****************
  get_data, 'f_ce', data=f_cedata
  idx_t_ = where( f_cedata.x lt time_+5. and f_cedata.x gt time_-5., cnt )
  f_ce_ave = f_cedata.y[idx_t_[0]] ; ここ、あとでindex変えて試す！！
;  f_chorus = [3000., 4000., 5000., 6000., 7000.] ;Hz
  
  k_perp = dindgen(k_perp_range, increment=0.0001, start=0.0)
  theta = dindgen(80, increment=1.0, start=0.0)
  
  Ne_k_para = fltarr(n_elements(k_perp), n_elements(focus_f))
  Ne_theta = fltarr(n_elements(theta), n_elements(focus_f))

  for i=0, n_elements( focus_f )-1 do begin
    f_ = focus_f[i] * 1000. ;kHz -> Hz
    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    b2 = - k_perp^2 + f_ce_ave / f_ * k_para_[i] * sqrt( k_para_[i]^2 + k_perp^2 ) - k_para_[i]^2
    Ne_k_para[*, i] = b1 * b2 / 10^(6.) ;cm-3

    k_perp_theta = k_para_[i] * tan( theta / 180 * !pi ) ; tan([radian])
    b1_theta = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    b2_theta = - k_perp_theta^2 + f_ce_ave / f_ * k_para_[i] * sqrt( k_para_[i]^2 + k_perp_theta^2 ) - k_para_[i]^2
    Ne_theta[*, i] = b1_theta * b2_theta / 10^(6.) ;cm-3
  endfor

  

  ; *****************
  ; 7.plot
  ; *****************
  
  tvlct, 255,0,0,1
  tvlct, 255,255,255,2
  tvlct, 0,0,0,4
  
  tvlct, 143,119,181,10
  tvlct, 0,0,255,11
  tvlct, 0,255,0,12
  tvlct, 200,125,0,13
  tvlct, 252,15,192,14
  tvlct, 255,0,0,15

  ; *****************
  ; 7.1.plot Ne(k_para)
  ; *****************
  
  if 1 then begin
    plot, k_perp, Ne_k_para[*, 0], color=4, yrange=[max([min(Ne_k_para)-5, 0.]), min([max(Ne_k_para)+5, 600.])] $
    ; plot, k_perp, Ne_k_para[*, 0], color=4, yrange=[0, 300] $
          , xtitle='k_perp [/m]', ytitle='Ne [/cc]'
    oplot, k_perp, Ne_k_para[*, 0], color=10
    oplot, [k_perp[0]], [Ne_k_para[0, 0]], psym=4, color=6
    ; xyouts, k_perp[2], Ne_k_para[0, 0], string(fix(Ne_k_para[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, k_perp[2], min([max(Ne_k_para)+5, 600.])-25, string(fix(Ne_k_para[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, k_perp[-8], min([max(Ne_k_para)+5, 600.])-25, string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
    for i = 1, n_elements(focus_f)-1 do begin
      oplot, k_perp, Ne_k_para[*, i], color=i+10
      oplot, [k_perp[0]], [Ne_k_para[0, i]], psym=4, color=6
      ; xyouts, k_perp[2], Ne_k_para[0, i], string(fix(Ne_k_para[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
      xyouts, k_perp[2], min([max(Ne_k_para)+5, 600.])-25-25*i, string(fix(Ne_k_para[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
      xyouts, k_perp[-8], min([max(Ne_k_para)+5, 600.])-25-25*i, string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
    endfor

    get_data, 'f_ce', data = data
    idx_t = where( data.x lt time_+4. and data.x gt time_-4., cnt )
    xyouts, k_perp[-12], max([min(Ne_k_para)-5, 0.])+25, 'fce/2 = '+string(data.y[idx_t]/1000/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2
    fce_loc_string = string(data.y[idx_t]/1000, FORMAT='(f0.1)')

    if test eq 0 then begin
      makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_kpara'
    endif

    print, ' n_0'
    print, Ne_k_para[0, *]
    
    print, ' n_max'
    for i=0,n_elements(focus_f)-1 do begin
      print, max(Ne_k_para[*, i])
    endfor
  endif

  ; *****************
  ; 7.2.plot Ne(theta)
  ; *****************

  plot, theta, Ne_theta[*, 0], color=4, yrange=[max([min(Ne_k_para)-5, 0.]), min([max(Ne_k_para)+5, 600.])] $
  ; plot, theta, Ne_theta[*, 0], color=4, yrange=[0, 300] $
        , xtitle='theta [degree]', ytitle='Ne [/cc]'
  oplot, theta, Ne_theta[*, 0], color=10
  oplot, [theta[0]], [Ne_theta[0, 0]], psym=4, color=6
  xyouts, theta[4], min([max(Ne_k_para)+5, 600.])-25, string(fix(Ne_theta[0, 0]), format='(i0)'), color=10, CHARSIZE=2
  xyouts, theta[-16], min([max(Ne_k_para)+5, 600.])-25, string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
  for i = 1, n_elements(focus_f)-1 do begin
    oplot, theta, Ne_theta[*, i], color=i+10
    oplot, [theta[0]], [Ne_theta[0, i]], psym=4, color=6
    xyouts, theta[4], min([max(Ne_k_para)+5, 600.])-25-25*i, string(fix(Ne_theta[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
    xyouts, theta[-16], min([max(Ne_k_para)+5, 600.])-25-25*i, string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
  endfor

  get_data, 'f_ce', data = data
  idx_t = where( data.x lt time_+4. and data.x gt time_-4., cnt )
  xyouts, theta[-24], max([min(Ne_k_para)-5, 0.])+25, 'fce/2 = '+string(data.y[idx_t]/1000/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2
  
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_theta'
  endif

  print, ' n_0'
  print, Ne_theta[0, *]
  
  print, ' n_max'
  for i=0,n_elements(focus_f)-1 do begin
    print, max(Ne_theta[*, i])
  endfor

  ; *****************
  ; 8.plot UT_B
  ; *****************
  
  time1 = time_string( time_double(duct_time) - 60.*2. ) ;sec
  time2 = time_string( time_double(duct_time) + 60.*2. ) ;sec
  
  timespan, [time1, time2]
;  get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data=Btotal
  erg_load_pwe_ofa
  get_data, 'erg_pwe_ofa_l2_spec_B_spectra_132', data=Bspec
  get_data, 'Ne', data=data
  
  N0_obs = fltarr(n_elements(focus_f)) * 1000.
;  idx_f = [where( Bspec.v eq 3.0079999 , cnt ), where( Bspec.v eq 3.9679999 , cnt ), where( Bspec.v eq 4.9920001 , cnt ), where( Bspec.v eq 5.9520001 , cnt ), where( Bspec.v eq 7.104000 , cnt )]
  idx_f = fltarr(n_elements(focus_f))
;  UT_B_names = ['UT_B_f3', 'UT_B_f4', 'UT_B_f5', 'UT_B_f6', 'UT_B_f7']
  UT_B_names = strarr(n_elements(focus_f))
;  N0_names = ['N0_f3', 'N0_f4', 'N0_f5', 'N0_f6', 'N0_f7']
  N0_names = strarr(n_elements(focus_f))
;  UT_B_ymax = [0.03, 0.2, 0.03, 0.03, 0.03]
  UT_B_ymax = fltarr(n_elements(focus_f)) + 0.03
  
  for i=0, n_elements(focus_f)-1 do begin
    difarr = abs(Bspec.v-focus_f[i])
    idx_f[i] = (where( difarr eq min(difarr) , cnt ))[0]
    UT_B_names[i] = 'UT_B_f' + string(focus_f[i], FORMAT='(f0.1)')
    N0_names[i] = 'N0_f' + string(focus_f[i], FORMAT='(f0.1)')
  endfor

  for i=0, n_elements(focus_f)-1 do begin
    
    store_data, UT_B_names[i], data={x:Bspec.x, y:Bspec.y[*,idx_f[i]]}
    ylim, UT_B_names[i], 0.0, UT_B_ymax[i], 0
    options, UT_B_names[i], 'ystyle', 9
    options, UT_B_names[i], 'ytitle', 'f' + string(focus_f[i], FORMAT='(f0.1)') + '!COFA B [nT]'
    
    store_data, N0_names[i], data={x:data.x, y:data.y}
;    options, N0_names[i], 'databar', {yval:Ne_k_para[0,i], linestyle:2, color:i+10, thick:2}
;    options, N0_names[i], 'databar', {yval:N0_obs[i], linestyle:1, color:i+10, thick:2}
    
    idx_duct_t = ( where( data.x lt time_double(duct_time)+5. and data.x gt time_double(duct_time)-5., cnt ) )[0]
    Ne_max =  max( [FLOAT(data.y[idx_duct_t]+20.), Ne_k_para[0, 0], Ne_k_para[0, -1]] )
    idx_duct_start = ( where( data.x lt time_double(time1)+5. and data.x gt time_double(time1)-5., cnt ) )[0]
    idx_duct_end = ( where( data.x lt time_double(time2)+5. and data.x gt time_double(time2)-5., cnt ) )[0]
    Ne_min_ = FLOAT( min(data.y[idx_duct_start:idx_duct_end]) )
    Ne_min =  max( [min( [Ne_min_, Ne_k_para[0, 0], Ne_k_para[0, -1]] ), 0.] )
    ylim, N0_names[i], Ne_min, Ne_max, 0
    options, N0_names[i], axis={yaxis:1, yrange:[Ne_min, Ne_max], ystyle:1, color:6}, ystyle=5
    options, N0_names[i], colors=6
    
    
    ; tplot, UT_B_names[i]
    ; tplot, N0_names[i], /oplot
    options, N0_names[i], 'databar', {yval:Ne_k_para[0,i], linestyle:2, color:i+10, thick:2}
    ; tplot_apply_databar
;    options, N0_names[i], 'databar', {yval:N0_obs[i], linestyle:1, color:i+10, thick:2}
;    tplot_apply_databar
    
  endfor
  
  time_stamp, /off
  tplot, UT_B_names
  tplot, N0_names, /oplot
  tplot_apply_databar
  
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_UT_B'
  endif

;  store_data, 'UT_B_f3', data={x:Bspec.x, y:Bspec.y[*,idx_f[0]]}
;  ylim, 'UT_B_f3', 0.0, 0.01, 0
;  options, 'UT_B_f3', 'ystyle', 9
;
;  options, 'N0_f', 'databar', {yval:Ne_k_para[0,0], linestyle:2, color:i, thick:2}
;  options, 'N0_f', 'databar', {yval:N0_obe[0], linestyle:1, color:i, thick:2}
;
;  ylim, 'N0_f', 0.0, 160.0, 0
;  options, 'N0_f', axis={yaxis:1, yrange:[0., 160.], ystyle:1, color:6}, ystyle=5
;  options, 'N0_f', colors=6
; 
;  tplot, 'UT_B_f3'
;  tplot, 'N0_f', /oplot
;  tplot_apply_databar


  ; *****************
  ; 9.plot theta_Ne
  ; *****************

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


  ; *****************
  ; 10.plot Ne_theta_withdata
  ; *****************

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


  ; *****************
  ; 11.plot f_theta
  ; *****************

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
  gendrin_angle = acos( 2.0 * obs_f*1000.0 / f_ce_ave ) / !pi * 180.0
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
  f_ce_ave_ = f_ce_ave / 1000.
  plot, obs_f/f_ce_ave_, gendrin_angle, xtitle='f/fce  '+'(fce = '+fce_loc_string+'kHz)', ytitle='theta [degree]', xrange=[ (min(focus_f)-0.5)/f_ce_ave_, (max(focus_f)+0.5)/f_ce_ave_ ]
  oplot, obs_f/f_ce_ave_, gendrin_angle, color=6
  oplot, f_kvec__/f_ce_ave_, kvec__, psym=4



  ; plot, f_kvec__/f_ce_ave_, kvec__
  ; colorbar
  ; plots, f_kvec__/f_ce_ave_, kvec__, color=polarization_color, psym=4
  xyouts, max(focus_f/f_ce_ave_)-0.04, min(kvec__)+5, 'Gendrin Angle', color=6, CHARSIZE=1.5


  calc_equatorial_fce
  tinterpol_mxn, 'fce_TS04_half', 'erg_pwe_ofa_l2_spec_B_spectra_132'
  get_data, 'fce_TS04_half_interp', data=equatorial_fce
  time_ = time_double(duct_time)
  idx_t = where( equatorial_fce.x lt time_+0.6 and equatorial_fce.x gt time_-0.6, cnt )
  duct_equatorial_fce = equatorial_fce.y[idx_t]

  oplot, [duct_equatorial_fce/f_ce_ave_, duct_equatorial_fce/f_ce_ave_], [min(gendrin_angle)-20.,max(gendrin_angle)+20.], linestyle=2
  xyouts, duct_equatorial_fce/f_ce_ave_+0.1, min(kvec__)+1, 'fce_eq/2 = '+string(duct_equatorial_fce/f_ce_ave_, format='(f0.1)')+'kHz', CHARSIZE=1.5


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

  oplot, obs_f/f_ce_ave_, gendrin_angle
  xyouts, max(focus_f/f_ce_ave_)-0.04, min(kvec__)+5, 'Gendrin Angle', CHARSIZE=1.5
  for i=0, n_elements(kvec__[*,0])-1 do oplot, obs_f/f_ce_ave_, kvec__[i,*], color=i+20, psym=4
  xyouts, max(focus_f), 65, 'obs t', CHARSIZE=1.5
  for i=0, n_elements(kvec__[*,0])-1 do xyouts, max(focus_f/f_ce_ave_)-0.04, 60-5*i, string(i, format='(i0)'), color=i+20

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



  ; *****************
  ; 12.plot f_Ne0, f_B
  ; *****************

  plot_f=dindgen(500, increment=0.01, start=focus_f[0])
  Ne_0 = fltarr(n_elements(plot_f))
  k_para_Ne0 = lsm[0] * plot_f + lsm[1]
  for i=0, n_elements( plot_f )-1 do begin
    f_ = plot_f[i] * 1000. ;kHz -> Hz
    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    b2 = k_para_Ne0[i]^2 * (f_ce_ave / f_ - 1 )
    Ne_0[i] = b1 * b2 / 10^(6.) ;cm-3
  endfor

  if test eq 0 then begin
    set_plot, 'Z'
    !p.background = 255
    !p.color = 0
  endif
  
  !p.multi=[0,1,2]
  plot, plot_f, Ne_0, xtitle='frequency [kHz]', ytitle='Ne0 [/cc]', yrange=[min(Ne_0)-5,max(Ne_0)+5]
  get_data, 'Ne', data=obs_Ne
  idx_t_Ne = where( obs_Ne.x lt time_+0.6 and obs_Ne.x gt time_-0.6, cnt )
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
  idx_t = where( Bdata.x lt time_+0.6 and Bdata.x gt time_-0.6, cnt )
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

stop

  ;
  ;
  ;  ここまで_(┐「ε:)_
  ;
  ;


end