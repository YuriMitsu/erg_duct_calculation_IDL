


pro Santolik2003Fig2_test





;     !P.multi=[0,5,5]
;     esn = [10.^(-5), 10.^(-4.5), 10.^(-4), 10.^(-3.5), 10.^(-3)]
;     enr = esn*(8192L/2)
;     bsn = [10.^(-2.5), 10.^(-2.75), 10.^(-2), 10.^(-1.75), 10.^(-1.5)]
;     ; bsn = [10.^(-3), 10.^(-2.5), 10.^(-2), 10.^(-1.5), 10.^(-1)]
;     bnr = bsn*(8192L/2)

; for i=0,4 do begin
;     for l=0,4 do begin
;         mag_svd_test,wna_inp=0,phi_inp=0,rate_inp=0,enr=enr[i],bnr=bnr[l]

;         get_data, 'planarity_msvd', data=pdata1
;         plot, pdata1.v, pdata1.y[0,*], xrange=[550, 600], xtitle='f[Hz]', ytitle='planarity', title='E S/N='+string(esn[i])+'  B S/N='+string(bsn[l])
;         oplot, pdata1.v, pdata1.y[0,*], COLOR=80
;         for k=1,n_elements(pdata1.y[*,0])-1 do oplot, pdata1.v, pdata1.y[k,*], COLOR=80
;         xyouts, 592, 0.1, 'wave x 1', color=80


;         mag_svd_test,wna_inp=[0,30],phi_inp=[0,30],rate_inp=[1., 1.],enr=enr[i],bnr=bnr[l]

;         get_data, 'planarity_msvd', data=pdata2
;         oplot, pdata2.v, pdata2.y[0,*], COLOR=220
;         for k=1,n_elements(pdata2.y[*,0])-1 do oplot, pdata2.v, pdata2.y[k,*], COLOR=220
;         xyouts, 592, 0.055, 'wave x 2', color=220

;     endfor
; endfor


; window, 0, xsize=1400, ysize=700
; !P.multi=[0,5,5]

; for i=0,nn do begin
;         rate = i/nn
;         mag_svd_test,wna_inp=[28,152],phi_inp=[10,-170],rate_inp=[rate, 1.-rate],enr=[0.,0.],bnr=[0.,0.]

;         get_data, 'planarity_msvd', data=pdata2
;         oplot, pdata2.v, pdata2.y[0,*], COLOR=220
;         for k=1,n_elements(pdata2.y[*,0])-1 do oplot, pdata2.v, pdata2.y[k,*], COLOR=220
;         xyouts, 592, 0.055, 'wave x 2', color=220





end