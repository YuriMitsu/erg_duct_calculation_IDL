
.RESET_SESSION
timespan, '2017-07-14/02:40:00', 20, /minute
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_wave_params.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_fce_and_flhr.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_Ne.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_kpara.pro'
.compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_kpara.pro'
plot_kpara_ne, duct_time='2017-07-14/02:51:50', focus_f=[2., 3., 4., 5.], UHR_file_name='kuma', duct_wid_data_n=6, IorD='D' ; D











;
  ; *****************
  ; 2.calc.
  ; *****************
  ; 1. load data で読み込んだデータを使って各物理量を計算する
  ; 計算した値は全てtplot変数にして記録する

  ; *****************
  ; 2.calc. wave palams
  ; *****************

  calc_wave_params
  wave_params_ = '_LASVD_ma3'
  
  ; *****************
  ; 3.calc. k_para
  ; *****************

  if test eq 1 then begin
    SET_PLOT, 'X'
    !p.BACKGROUND = 255
    !p.color = 0
  endif else begin
    SET_PLOT, 'Z'
    DEVICE, SET_RESOLUTION = [1500,2000]
    !p.BACKGROUND = 255
    !p.color = 0
  endelse

  tinterpol_mxn, 'erg_mgf_l2_magt_8sec', 'polarization'+wave_params_
  get_data, 'erg_mgf_l2_magt_8sec_interp', data=magt
  get_data, 'polarization'+wave_params_, data=pol

  f = pol.v

;  read_f_uhr

  if UHR_file_name eq 'kuma' then begin
    load_fufp_txt, /high
    get_data, 'hfa_l3_fuh', data = data
    store_data, 'f_UHR', data={x:data.x, y:data.y}
  endif else begin
    tplot_restore, file=[UHR_file_name]
  endelse

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
  ; get_data, 'Ne', data=data
  ; idx_duct_t = ( where( data.x lt time_double(duct_time)+5. and data.x gt time_double(duct_time)-5., cnt ) )[0]
  ; Ne_max =  max( [FLOAT(data.y[idx_duct_t]+20.), Ne_k_para[0, 0], Ne_k_para[0, -1]] )
  ; idx_duct_start = ( where( data.x lt time_double(time1)+5. and data.x gt time_double(time1)-5., cnt ) )[0]
  ; idx_duct_end = ( where( data.x lt time_double(time2)+5. and data.x gt time_double(time2)-5., cnt ) )[0]
  ; Ne_min_ = FLOAT( min(data.y[idx_duct_start:idx_duct_end]) )
  ; Ne_min =  max( [min( [Ne_min_, Ne_k_para[0, 0], Ne_k_para[0, -1]] ), 0.] )
  ; ylim, 'Ne', Ne_max, Ne_min, 0
  ylim, 'kvec'+wave_params_+'_mask', 1., 9.0, 0
  timespan, time_string(time_double(duct_time)-120. ), 4, /minute
  ; tplot, ['Ne', 'kvec'+wave_params_+'_mask']

  ret = strsplit(duct_time, '-/:', /extract)
  ; if test eq 0 then begin
  ;   makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_hfa_kpara_mask'
  ; endif


