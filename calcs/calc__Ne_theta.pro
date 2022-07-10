; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc__Ne_theta.pro'

; input
;   tplot 'fce'
;   ver duct_time, focus_f, test, lsm, k_perp_range, data__Ne_theta


; output
;   ver data__Ne_theta
;       : structure  x:theta, y:Ne(theta)



pro calc__Ne_theta, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, k_perp_range=k_perp_range, data__Ne_theta=data__Ne_theta

    ; ******************************
    ; 1.get data
    ; ******************************

    get_data, 'fce', data=fce_data


    ; ******************************
    ; 2.calc Ne(theta)
    ; ******************************
    duct_time_double = time_double(duct_time)
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )

    fce_ave = fce_data.y[idx_t[0]]

    theta = dindgen(80, increment=1.0, start=0.0)
    Ne_theta = fltarr(n_elements(theta), n_elements(focus_f))
    
    kpara_linear = lsm[0] * focus_f + lsm[1]

    b1_theta = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    for i=0, n_elements( focus_f )-1 do begin
        kperp_theta = kpara_linear[i] * tan( theta / 180 * !pi ) ; tan([radian])
        b2_theta = - kperp_theta^2 + fce_ave / focus_f[i] * kpara_linear[i] * sqrt( kpara_linear[i]^2 + kperp_theta^2 ) - kpara_linear[i]^2
        Ne_theta[*, i] = b1_theta * b2_theta / 10^(6.) ;cm-3
    endfor

    ; ******************************
    ; 3.return data
    ; ******************************

    data__Ne_theta = {x:theta, y:Ne_theta}


end