; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc__Ne_kperp.pro'

; input
;   tplot 'fce'
;   ver duct_time, focus_f, test, lsm, k_perp_range, data__Ne_kperp

; output
;   ver data__Ne_kperp
;       : structure  x:kperp, y:Ne(kperp)



pro calc__Ne_kperp, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, k_perp_range=k_perp_range, data__Ne_kperp=data__Ne_kperp

    ; ******************************
    ; 1.get data
    ; ******************************

    get_data, 'fce', data=fce_data


    ; ******************************
    ; 2.calc Ne(kperp)
    ; ******************************

    duct_time_double = time_double(duct_time)
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )

    fce_ave = fce_data.y[idx_t[0]] ;kHz 
    kperp = dindgen(k_perp_range, increment=0.0001, start=0.0)
    Ne_kperp = fltarr(n_elements(kperp), n_elements(focus_f))

    kpara_linear = lsm[0] * focus_f + lsm[1]

    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2

    ; for i=0, n_elements( focus_f )-1 do Ne_kperp[*, i] = b1 * ( - kperp^2 + fce_ave / ( focus_f[i] ) * kpara_linear[i] * sqrt( kpara_linear[i]^2 + kperp^2 ) - kpara_linear[i]^2 ) / 10^(6.)

    for i=0, n_elements( focus_f )-1 do begin
        f_ = focus_f[i] ;kHz 
        b2 = - kperp^2 + fce_ave / f_ * kpara_linear[i] * sqrt( kpara_linear[i]^2 + kperp^2 ) - kpara_linear[i]^2
        Ne_kperp[*, i] = b1 * b2 / 10^(6.) ;cm-3
    endfor

    ; ******************************
    ; 3.return data
    ; ******************************

    data__Ne_kperp = {x:kperp, y:Ne_kperp}

end