; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_kpara.pro'

; 入力データは
;   get_data, 'k_para'+wave_params_+'_mask', data = kpara_data
;   kpara_data.y[*, where(kpara_data.v lt focus_f[0]-0.1) ] = 'NaN'
;   kpara_data.y[*, where(kpara_data.v gt focus_f[-1]+0.1) ] = 'NaN'
;   focus_f=focus_f, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, test=test, lsm=lsm


; 出力は
;   画像f_kpara

pro plot_f_kpara, focus_f=focus_f, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, test=test, lsm=lsm

  get_data, 'kpara_LASVD_ma3_mask', data = kpara_data
  kpara_data.y[*, where(kpara_data.v lt focus_f[0]-0.1) ] = 'NaN'
  kpara_data.y[*, where(kpara_data.v gt focus_f[-1]+0.1) ] = 'NaN'

  time_ = time_double(duct_time)
  time_res =  kpara_data.x[100]- kpara_data.x[99]
  idx_t = where( kpara_data.x lt time_+time_res/2 and kpara_data.x gt time_-time_res/2, cnt )

  kpara_data.y[idx_t[0], *] = mean(kpara_data.y[idx_t[0]-duct_wid_data_n:idx_t[0]+duct_wid_data_n, *], DIMENSION=1, /nan)

  if idx_t eq -1 then begin
    print, '!!!!Caution!!!! /n Duct time is not selected correctly. Check the code.'
    stop
  endif

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

  ; 最小二乗法でダクト中心でのk_paraを直線に当てはめる
  if not keyword_set(lsm) then begin
    lsm = least_squares_method(kpara_data.v, kpara_data.y[idx_t[0], *])
  endif

  k_para_ = lsm[0] * focus_f + lsm[1]

  xmin = max([0., focus_f[0]]-1.5)
  xmax = focus_f[-1] + 1.5

  plot, [xmin, xmax], lsm[0] * [xmin, xmax] + lsm[1], xtitle='f (kHz)', ytitle='k_para (/m)'

  oplot, kpara_data.v, kpara_data.y[idx_t[0], *], psym=-4
  tvlct, 255,0,0,1
  oplot, focus_f, k_para_, psym=2, color=1
  lsm_f = [min(kpara_data.v), max(kpara_data.v)]
  lsm_k_para = lsm[0] * lsm_f + lsm[1]
  oplot, lsm_f, lsm_k_para, color=1

  ; 保存
  ret = strsplit(duct_time, '-/:', /extract)
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_kpara'
  endif

end