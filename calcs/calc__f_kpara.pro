; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc__f_kpara.pro'

; input
;   tplot 'kpara_LASVD_ma3_mask'
;   ver focus_f, duct_time, duct_wid_data_n, test

; output
;   ver lsm, kpara_data_idx_t


function least_squares_method,x,y
    gate = [finite(x,/nan) + finite(y,/nan) eq 0]
    x_ = x[where(gate)]
    y_ = y[where(gate)]
    a = total( (x_-mean(x_))*(y_-mean(y_)) ) / total( (x_-mean(x_))^2 )
    b = mean(y_) - a*mean(x_)
    return, [a,b]
end


pro calc__f_kpara, focus_f=focus_f, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, lsm=lsm, data__f_kpara=data__f_kpara

    ; ******************************
    ; 1.get data
    ; ******************************

    get_data, 'kpara_LASVD_ma3_mask', data = kpara_data
    kpara_data.y[*, where(kpara_data.v lt focus_f[0]-0.1) ] = 'NaN'
    kpara_data.y[*, where(kpara_data.v gt focus_f[-1]+0.1) ] = 'NaN'


    ; ******************************
    ; 2.calc kpara(f)
    ; ******************************

    duct_time_double = time_double(duct_time)
    time_res =  kpara_data.x[100]- kpara_data.x[99]
    idx_t = where( kpara_data.x lt duct_time_double+time_res/2 and kpara_data.x gt duct_time_double-time_res/2, cnt )

    ; ダクトの全幅分のkparaを持ってくる → 周波数方向を残して平均をとる
    kpara_data_idx_t = mean(kpara_data.y[idx_t[0]-duct_wid_data_n:idx_t[0]+duct_wid_data_n, *], DIMENSION=1, /nan)

    if idx_t eq -1 then begin
        print, '!!!!Caution!!!! /n Duct time is not selected correctly. Check the code.'
        stop
    endif

    ; 最小二乗法でダクト中心でのkparaを直線に当てはめる
    if not keyword_set(lsm) then begin
        lsm = least_squares_method(kpara_data.v, kpara_data_idx_t)
    endif

    data__f_kpara = kpara_data_idx_t

end