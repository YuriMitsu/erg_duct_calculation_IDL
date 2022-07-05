
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_k_para.pro'

; TPLOT variables that need to be prepared in advance
;     'kvec_*' : calc_wave_params.pro
;     'fce' : calc_fce_and_flhr.pro
;     'fpe' : calc_Ne.pro

; TPLOT variables created
;     'k_para'

pro calc_k_para

  ; ************************************
  ; 1.get data kvec,fce.etc
  ; ************************************

  kvec_tname = tnames('kvec_LASVD_???')

  tinterpol_mxn, 'fce', kvec_tname
  tinterpol_mxn, 'fpe', kvec_tname

  get_data, kvec_tname, data=kvec_data
  get_data, 'fce_interp', data = fce_data
  get_data, 'fpe_interp', data = fpe_data


  ; ************************************
  ; 2.calc. k_para
  ; ************************************

  wna = kvec_data.y
  alpha = wna / 180 * !pi

  kpara = fltarr(n_elements(alpha[*,0]), n_elements(alpha[0,*])) ;[timerange, freqrange]

  c = 2.99 * 10^(8.)
  a1 = 4 * !pi^2 * fpe_data.y^2 / c^2

  for i=0,n_elements(alpha[0,*])-1 do begin
    alpha_ = alpha[*,i]
    a2 = fce_data.y / kvec_data.v[i] / cos(alpha_)
    a3 = 1 / (cos(alpha_))^2
    kpara[*,i] = sqrt( a1 / (a2-a3) )
  endfor


  ; ************************************
  ; 3.store data k_para
  ; ************************************

  store_data, 'kpara', data={x:kvec_data.x, y:kpara, v:kvec_data.v}
  options, 'kpara', ytitle='kpara', ysubtitle='Frequency [kHz]', spec = 1
  zlim, 'kpara', 1.e-4, 5.e-3, 1

  stop

  ; ここはplot_kpara_neで設定した方が良い
  ; ylim, 'k_para', focus_f[0]-0.5, focus_f[-1]+0.5, 0 ; kHz
  ; zlim, 'k_para', 1.e-4, 5.e-3, 1 ;適宜ここ決める！

end
