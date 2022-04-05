
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_kpara_ne.pro'


function least_squares_method,x,y
  gate = [finite(x,/nan) + finite(y,/nan) eq 0]
  x_ = x[where(gate)]
  y_ = y[where(gate)]
  a = total( (x_-mean(x_))*(y_-mean(y_)) ) / total( (x_-mean(x_))^2 )
  b = mean(y_) - a*mean(x_)
  return, [a,b]
end

; plot_kpara_neはtimespanを設定してから使用！！
pro plot_kpara_ne, duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, k_para_=k_para_, cut_f=cut_f, k_perp_range=k_perp_range

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
  ; 3.calculate k_para
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
  
  tplot, ['erg_pwe_hfa', 'k_para'+wave_params_+'_mask']

  ; *****************
  ; 5.get k_para(freq)
  ; *****************
  ;2018-06-02/10:05:56のk_paraを試しに周波数方向に切り出してみる
  
  ; 保存するplotのwindowを用意
  SET_PLOT, 'Z'
  DEVICE, SET_RESOLUTION = [1000,600]
  !p.BACKGROUND = 255
  !p.color = 0
  
  get_data, 'k_para'+wave_params_+'_mask', data = k_paradata
  k_paradata.y[*, where(k_paradata.v lt focus_f[0]-0.1) ] = 'NaN'
  k_paradata.y[*, where(k_paradata.v gt focus_f[-1]+0.1) ] = 'NaN'

  time_ = time_double(duct_time)
  idx_t = where( k_paradata.x lt time_+4. and k_paradata.x gt time_-4., cnt )




  ; ダクトに合わせて変える or 消す！！！
  k_paradata.y[idx_t[0], *] = mean(k_paradata.y[idx_t[0]-3:idx_t[0]+3, *], DIMENSION=1, /nan)
  ; print, k_paradata.x[idx_t[0]+10]-k_paradata.x[idx_t[0]-10]
  ; print, time_string(k_paradata.x[idx_t[0]+10])
  ; print, time_string(k_paradata.x[idx_t[0]-10])

  ; stop




  if idx_t eq -1 then begin
    print, '!!!!Caution!!!! /n Duct time is not selected correctly. Check the code.'
    stop
  endif
  plot, k_paradata.v, k_paradata.y[idx_t[0], *], psym=-4, xtitle='f (kHz)', ytitle='k_para (/m)'

  ; 最小二乗法でダクト中心でのk_paraを直線に当てはめる
  if not keyword_set(lsm) then lsm = least_squares_method(k_paradata.v, k_paradata.y[idx_t[0], *]) ;外れ値に左右され過ぎてしまう 余裕があったらロバスト回帰を導入？
  ; lsm = [0.00019399999,   0.00014002688]

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
  makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_kpara'
  

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
    ; plot, k_perp, Ne_k_para[*, 0], color=4, yrange=[max([min(Ne_k_para)-5, 0.]), min([max(Ne_k_para)+5, 500.])] $
    plot, k_perp, Ne_k_para[*, 0], color=4, yrange=[250, 500] $
          , xtitle='k_perp [/m]', ytitle='Ne [/cc]'
    oplot, k_perp, Ne_k_para[*, 0], color=10
    oplot, [k_perp[0]], [Ne_k_para[0, 0]], psym=4, color=6
    xyouts, k_perp[2], Ne_k_para[0, 0], string(fix(Ne_k_para[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, k_perp[-8], Ne_k_para[-1, 0], string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
    for i = 1, n_elements(focus_f)-1 do begin
      oplot, k_perp, Ne_k_para[*, i], color=i+10
      oplot, [k_perp[0]], [Ne_k_para[0, i]], psym=4, color=6
      xyouts, k_perp[2], Ne_k_para[0, i], string(fix(Ne_k_para[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
      xyouts, k_perp[-8], Ne_k_para[-1, i], string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
    endfor

    get_data, 'f_ce', data = data
    idx_t = where( data.x lt time_+4. and data.x gt time_-4., cnt )
    xyouts, k_perp[-12], min(Ne_k_para[-1, *])-50, 'fce/2 = '+string(data.y[idx_t]/1000/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2
    
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_kpara'
    
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

  ; plot, theta, Ne_theta[*, 0], color=4, yrange=[max([min(Ne_theta)-5, 0.]), min([max(Ne_theta)+5, 500.])] $
  plot, theta, Ne_theta[*, 0], color=4, yrange=[250, 500] $
        , xtitle='theta [degree]', ytitle='Ne [/cc]'
  oplot, theta, Ne_theta[*, 0], color=10
  oplot, [theta[0]], [Ne_theta[0, 0]], psym=4, color=6
  xyouts, theta[2], Ne_theta[0, 0], string(fix(Ne_theta[0, 0]), format='(i0)'), color=10, CHARSIZE=2
  xyouts, theta[-8], Ne_theta[-1, 0], string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
  for i = 1, n_elements(focus_f)-1 do begin
    oplot, theta, Ne_theta[*, i], color=i+10
    oplot, [theta[0]], [Ne_theta[0, i]], psym=4, color=6
    xyouts, theta[2], Ne_theta[0, i], string(fix(Ne_theta[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
    xyouts, theta[-8], Ne_theta[-1, i], string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
  endfor

  get_data, 'f_ce', data = data
  idx_t = where( data.x lt time_+4. and data.x gt time_-4., cnt )
  xyouts, theta[-12], min(Ne_theta[-1, *])-50, 'fce/2 = '+string(data.y[idx_t]/1000/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2
  
  makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_theta'
  
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
    idx_f[i] = where( difarr eq min(difarr) , cnt )
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
  
  makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_UT_B'
  
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
  ; 9.plot f_Ne0
  ; *****************

  plot_f=dindgen(500, increment=0.01, start=1.0)
  Ne_0 = fltarr(n_elements(plot_f))
  k_para_Ne0 = lsm[0] * plot_f + lsm[1]
  for i=0, n_elements( plot_f )-1 do begin
    f_ = plot_f[i] * 1000. ;kHz -> Hz
    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    b2 = k_para_Ne0[i]^2 * (f_ce_ave / f_ - 1 )
    Ne_0[i] = b1 * b2 / 10^(6.) ;cm-3
  endfor

  set_plot, 'Z'
  !p.background = 255
  !p.color = 0
  plot, plot_f, Ne_0, xtitle='ferq [kHz]', ytitle='Ne0 [/cc]', yrange=[min(Ne_0)-5,max(Ne_0)+5]
  makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_Ne0'

  get_data, 'erg_pwe_ofa_l2_spec_B_spectra_132', data = Bdata
  time_ = time_double(duct_time)
  idx_t = where( Bdata.x lt time_+0.6 and Bdata.x gt time_-0.6, cnt )
  Bdata.y[idx_t,*] = mean(Bdata.y[idx_t-25:idx_t+25, *], DIMENSION=1, /nan)
  plot, Bdata.v, Bdata.y[idx_t,*], xtitle='frequency [kHz]', ytitle='OFA-SPEC B [pT^2/Hz]', xrange=[min(plot_f), max(plot_f)]
  makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_B'

  ; *****************
  ; 10.plot theta_Ne
  ; *****************

  calc_ave_WNA

  tinterpol_mxn, 'Ne', 'kvec_ave'

  get_data, 'kvec_ave', data=kvec_avedata
  get_data, 'Ne_interp', data=Nedata

  time_ = time_double(duct_time)
  idx_t = where( kvec_avedata.x lt time_+4. and kvec_avedata.x gt time_-4., cnt )

  set_plot, 'Z'
  !p.background = 255
  !p.color = 0
  
  plot, theta, Ne_theta[*, 0], color=4, yrange=[250, 500] $
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

  oplot, kvec_avedata.y[idx_t-3:idx_t+3], Nedata.y[idx_t-3:idx_t+3], xtitle='theta [deg]', ytitle='Ne [/cc]', psym=4, color=2

  makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_theta_withdata'

  stop



  
  
  ;
  ;
  ;  ここまで_(┐「ε:)_
  ;
  ;


end