pro read_f_UHR, tplot_name=tplot_name

; timespan, '2017-05-10/04:00:00', 30, /minute
; timespan, '2018-06-02/10:00:00', 20, /minute
; timespan, '2018-06-06/11:25:00', 40, /minute
; timespan, '2018-07-10/05:25:00', 20, /minute

erg_load_pwe_hfa, level='l2', mode=['l','h'], uname='erg_project', pass='geospace'
;ylim,  'erg_pwe_hfa_l2_high_spectra_e_mix', 40.0, 120.0, 0
ylim,  'erg_pwe_hfa_l2_high_spectra_e_mix', 100.0, 250.0, 0

SET_PLOT, 'X'
!p.BACKGROUND = 255
!p.color = 0
window, xsize=1200, ysize=800
;tplot, 'erg_pwe_hfa_l2_low_spectra_e_mix'
tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
ctime, f_time, f_y
; 右クリックで終了

store_data, 'f_UHR', data={x:f_time, y:f_y}, dlim={colors:5,thick:1,linestyle:1}
options, 'f_UHR', 'ytitle', 'f_UHR'
options, 'f_UHR', 'ysubtitle', 'frequency [kHz]'

; ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR'], 40.0, 200.0, 0
ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR'], 100.0, 250.0, 0
tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
tplot, 'f_UHR', /oplot



stop


;前後の時間を追加・訂正したいとき
;tplot_restore, file=['/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2017-05-10/040000.tplot']

tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
ctime, f_time, f_y

get_data, 'f_UHR', data=data

idx0 = n_elements(data.x)

new_datax = dblarr( n_elements(data.x)+n_elements(f_time) )
new_datay = dblarr( n_elements(data.x)+n_elements(f_time) )

new_datax[0:idx0-1] = data.x
new_datay[0:idx0-1] = data.y
new_datax[idx0:-1] = f_time
new_datay[idx0:-1] = f_y

store_data, 'new_f_UHR', data={x:new_datax, y:new_datay}, dlim={colors:5,thick:1,linestyle:1}

ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'new_f_UHR'], 100.0, 250.0, 0
tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
tplot, 'new_f_UHR', /oplot

; いい感じなら再保存
store_data, 'f_UHR', /delete
store_data, 'new_f_UHR', newname='f_UHR'
options, 'f_UHR', 'ytitle', 'f_UHR'
options, 'f_UHR', 'ysubtitle', 'frequency [kHz]'



;点を追加・訂正したいとき
;tplot_restore, file=['/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2017-05-10/040000.tplot']

tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
ctime, f_time, f_y

get_data, 'f_UHR', data=data
mask1 = ( data.x lt f_time[0] )
idx1 = UINT( TOTAL(mask1) )
mask2 = ( data.x lt f_time[-1] )
idx2 = UINT( TOTAL(mask2) )

new_datax = dblarr( n_elements(data.x[0:idx1-1])+n_elements(f_time)+n_elements(data.x[idx2:-1]) )
new_datay = dblarr( n_elements(data.x[0:idx1-1])+n_elements(f_time)+n_elements(data.x[idx2:-1]) )

new_datax[0:idx1-1] = data.x[0:idx1-1]
new_datay[0:idx1-1] = data.y[0:idx1-1]
new_datax[idx1:idx1+n_elements(f_time)-1] = f_time
new_datay[idx1:idx1+n_elements(f_time)-1] = f_y
new_datax[idx1+n_elements(f_time):-1] = data.x[idx2:-1]
new_datay[idx1+n_elements(f_time):-1] = data.y[idx2:-1]

store_data, 'new_f_UHR', data={x:new_datax, y:new_datay}, dlim={colors:5,thick:1,linestyle:1}

ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'new_f_UHR'], 20.0, 110.0, 0
tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
tplot, 'new_f_UHR', /oplot

; いい感じなら再保存
store_data, 'f_UHR', /delete
store_data, 'new_f_UHR', newname='f_UHR'
options, 'f_UHR', 'ytitle', 'f_UHR'
options, 'f_UHR', 'ysubtitle', 'frequency [kHz]'

;tplot_save, 'f_UHR', filename='/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2017-05-10/040000'
;tplot_save, 'f_UHR', filename='/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2018-06-02/101400'
;tplot_save, 'f_UHR', filename='/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2018-06-06/112500-120500'
;tplot_save, 'f_UHR', filename='/Users/ampuku/Documents/duct/code/IDL/UHR_tplots/f_UHR_2018-07-10/052500-054500'


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