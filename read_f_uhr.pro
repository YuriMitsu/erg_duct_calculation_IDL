pro read_f_UHR, tplot_name=tplot_name

; timespan, '2018-06-02/10:00:00', 20, /minute
erg_load_pwe_hfa, level='l2', mode=['l','h'], uname='erg_project', pass='geospace'
;ylim,  'erg_pwe_hfa_l2_high_spectra_e_mix', 40.0, 120.0, 0
ylim,  'erg_pwe_hfa_l2_high_spectra_e_mix', 40.0, 200.0, 0
window, xsize=1200, ysize=800
;tplot, 'erg_pwe_hfa_l2_low_spectra_e_mix'
tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
ctime, f_time, f_y
; 右クリックで終了

store_data, 'f_UHR', data={x:f_time, y:f_y}, dlim={colors:5,thick:1,linestyle:1}
options, 'f_UHR', 'ytitle', 'f_UHR'
options, 'f_UHR', 'ysubtitle', 'frequency [kHz]'

ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR'], 40.0, 200.0, 0
tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
tplot, 'f_UHR', /oplot

;tplot_save, 'f_UHR', filename='f_UHR_2018-06-02/101400'

; ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR'], 40.0, 200.0, 0
; ylim, 'ofa_b_Bmodels', 1., 10., 0
; tplot, ['erg_pwe_hfa_l2_high_spectra_e_mix', 'ofa_b_Bmodels']
; tplot, ['f_UHR', 'ofa_b_Bmodels'], /oplot
; ctime, time_, y_


;自動化したかったがうまく作れない。pythonで書きたい。
;  if not keyword_set(tplot_name) then tplot_name=['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix'] ; [hour]
;  
;  if n_elements(tplot_names) eq 1 then begin
;    get_data, tplot_name[0], data=data
;  endif
;;  if tplot_name eq ['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix'] then begin
;    get_data, 'erg_pwe_hfa_l2_low_spectra_e_mix', data=data
;    get_data, 'erg_pwe_hfa_l2_high_spectra_e_mix', data=data2
;    
;;  endif
;  
;  f_UHR = fltarr(n_elements(data.x))
;  
;  for i=0, n_elements(data.x)-1 do begin
;    
;    bbb = data.y[i, *]
;    ccc = fltarr(n_elements(bbb)-5)
;    for l=0, n_elements(bbb)-6 do begin
;      
;      ccc[l] = (bbb[l+5]+bbb[l+4]+bbb[l+3]+bbb[l+2]) - (bbb[l+3]+bbb[l+2]+bbb[l+1]+bbb[l])
;      
;    endfor
;    
;    print, data.v[ccc eq max(ccc)]
;    stop
;  endfor

  stop





end