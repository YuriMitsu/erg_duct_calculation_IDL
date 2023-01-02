; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_kpara_wfc.pro'

; input
;   tplot 'kpara_LASVD_ma3_mask'
;   ver focus_f, duct_time, duct_wid_data_n, test, lsm, kpara_data_idx_t


; output
;   fig f_kpara
;   ver lsm


pro plot_f_kpara_wfc, focus_f=focus_f, duct_time=duct_time, test=test, lsm=lsm, data__f_kpara=data__f_kpara


  ; ******************************
  ; 3.make fig
  ; ******************************

  get_data, 'kpara_mask', data = kpara_data
  kpara_data.y[*, where(kpara_data.v lt focus_f[0]-0.1) ] = 'NaN'
  kpara_data.y[*, where(kpara_data.v gt focus_f[-1]+0.1) ] = 'NaN'

  ; duct_time_double1 = time_double(duct_time1)
  ; duct_time_double2 = time_double(duct_time2)
  ; time_res =  kvec_data.x[100]- kvec_data.x[99]
  ; idx_t1 = where( kvec_data.x lt duct_time_double1+time_res/2 and kvec_data.x gt duct_time_double1-time_res/2, cnt )
  ; idx_t2 = where( kvec_data.x lt duct_time_double2+time_res/2 and kvec_data.x gt duct_time_double2-time_res/2, cnt )

  kpara_linear = lsm[0] * focus_f + lsm[1]

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

  xmin = max([0., focus_f[0]]-1.5)
  xmax = focus_f[-1] + 1.5

  plot, [xmin, xmax], lsm[0] * [xmin, xmax] + lsm[1], xtitle='f (kHz)', ytitle='k_para (/m)'

  oplot, kpara_data.v, data__f_kpara, psym=-4
  tvlct, 255,0,0,1
  oplot, focus_f, kpara_linear, psym=2, color=1
  lsm_f = [min(kpara_data.v), max(kpara_data.v)]
  lsm_kpara = lsm[0] * lsm_f + lsm[1]
  oplot, lsm_f, lsm_kpara, color=1

  ; save fig
  ret = strsplit(duct_time, '-/:', /extract)
  if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_kpara', /mkdir
  endif

end