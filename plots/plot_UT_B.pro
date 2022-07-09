; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_UT_B.pro'

; 時間ができたらcalcとplotに分けよう
; 論文作成に重要なplotでないはずなので整理してない

; input
;   tplot 'erg_pwe_ofa_l2_spec_B_spectra_132', 'Ne'
;   ver 

; output
;   fig UT_B


pro plot_UT_B, duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, test=test, data__Ne_kperp=data__Ne_kperp
; duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, k_para_=k_para_, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

  ; ******************************
  ; 1.get data
  ; ******************************

  time1 = time_string( time_double(duct_time) - 60.*2. ) ;sec
  time2 = time_string( time_double(duct_time) + 60.*2. ) ;sec
  timespan, [time1, time2]

  erg_load_pwe_ofa
  get_data, 'erg_pwe_ofa_l2_spec_B_spectra_132', data=Bspec_data
  get_data, 'Ne', data=Ne_data

  Ne_thetaG = data__Ne_kperp.y[0,*]


  ; ******************************
  ; 2.calc UT_B
  ; ******************************

  N0_obs = fltarr(n_elements(focus_f)) * 1000.
  idx_f = fltarr(n_elements(focus_f))
  UT_B_names = strarr(n_elements(focus_f))
  N0_names = strarr(n_elements(focus_f))
  UT_B_ymax = fltarr(n_elements(focus_f)) + 0.03
  
  for i=0, n_elements(focus_f)-1 do begin
    difarr = abs(Bspec_data.v-focus_f[i])
    idx_f[i] = (where( difarr eq min(difarr) , cnt ))[0]
    UT_B_names[i] = 'UT_B_f' + string(focus_f[i], FORMAT='(f0.1)')
    N0_names[i] = 'N0_f' + string(focus_f[i], FORMAT='(f0.1)')
  endfor

  for i=0, n_elements(focus_f)-1 do begin
    
    store_data, UT_B_names[i], data={x:Bspec_data.x, y:Bspec_data.y[*,idx_f[i]]}
    ylim, UT_B_names[i], 0.0, UT_B_ymax[i], 0
    options, UT_B_names[i], 'ystyle', 9
    options, UT_B_names[i], 'ytitle', 'f' + string(focus_f[i], FORMAT='(f0.1)') + '!COFA B [nT]'
    
    store_data, N0_names[i], data={x:Ne_data.x, y:Ne_data.y}
;    options, N0_names[i], 'databar', {yval:Ne_thetaG[i], linestyle:2, color:i+10, thick:2}
;    options, N0_names[i], 'databar', {yval:N0_obs[i], linestyle:1, color:i+10, thick:2}
    
    idx_duct_t = ( where( Ne_data.x lt time_double(duct_time)+5. and Ne_data.x gt time_double(duct_time)-5., cnt ) )[0]
    Ne_max =  max( [FLOAT(Ne_data.y[idx_duct_t]+20.), Ne_thetaG[0], Ne_thetaG[-1]] )
    idx_duct_start = ( where( Ne_data.x lt time_double(time1)+5. and Ne_data.x gt time_double(time1)-5., cnt ) )[0]
    idx_duct_end = ( where( Ne_data.x lt time_double(time2)+5. and Ne_data.x gt time_double(time2)-5., cnt ) )[0]
    Ne_min_ = FLOAT( min(Ne_data.y[idx_duct_start:idx_duct_end]) )
    Ne_min =  max( [min( [Ne_min_, Ne_thetaG[0], Ne_thetaG[-1]] ), 0.] )
    ylim, N0_names[i], Ne_min, Ne_max, 0
    options, N0_names[i], axis={yaxis:1, yrange:[Ne_min, Ne_max], ystyle:1, color:6}, ystyle=5
    options, N0_names[i], colors=6
    
    
    ; tplot, UT_B_names[i]
    ; tplot, N0_names[i], /oplot
    options, N0_names[i], 'databar', {yval:Ne_thetaG[i], linestyle:2, color:i+10, thick:2}
    ; tplot_apply_databar
;    options, N0_names[i], 'databar', {yval:N0_obs[i], linestyle:1, color:i+10, thick:2}
;    tplot_apply_databar
    
  endfor

  if test eq 1 then begin
      SET_PLOT, 'X'
      !p.BACKGROUND = 255
      !p.color = 0
  endif else begin
      SET_PLOT, 'Z'
      DEVICE, SET_RESOLUTION = [1000,600]
      !p.BACKGROUND = 255
      !p.color = 0
  endelse

  !p.multi=0
  
  time_stamp, /off
  tplot, UT_B_names
  tplot, N0_names, /oplot
  tplot_apply_databar

  timebar, duct_time

  ret = strsplit(duct_time, '-/:', /extract)
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_UT_B'
  endif

;  store_data, 'UT_B_f3', data={x:Bspec_data.x, y:Bspec_data.y[*,idx_f[0]]}
;  ylim, 'UT_B_f3', 0.0, 0.01, 0
;  options, 'UT_B_f3', 'ystyle', 9
;
;  options, 'N0_f', 'databar', {yval:Ne_thetaG[0], linestyle:2, color:i, thick:2}
;  options, 'N0_f', 'databar', {yval:N0_obe[0], linestyle:1, color:i, thick:2}
;
;  ylim, 'N0_f', 0.0, 160.0, 0
;  options, 'N0_f', axis={yaxis:1, yrange:[0., 160.], ystyle:1, color:6}, ystyle=5
;  options, 'N0_f', colors=6
; 
;  tplot, 'UT_B_f3'
;  tplot, 'N0_f', /oplot
;  tplot_apply_databar
end