; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc__f_kpara_wfc.pro'

; input
;   tplot 'wna_mask' from isee_wave
;   ver focus_f, duct_time, duct_time1, duct_time2, test, lsm

; output
;   fig f_kpara
;   ver lsm


function least_squares_method,x,y
    gate = [finite(x,/nan) + finite(y,/nan) eq 0]
    x_ = x[where(gate)]
    y_ = y[where(gate)]
    a = total( (x_-mean(x_))*(y_-mean(y_)) ) / total( (x_-mean(x_))^2 )
    b = mean(y_) - a*mean(x_)
    return, [a,b]
end


pro calc__f_kpara_wfc, focus_f=focus_f, duct_time_=duct_time, duct_time1=duct_time1, duct_time2=duct_time2, lsm=lsm, data__f_kpara=data__f_kpara

    ; ******************************
    ; 1.get data
    ; ******************************

    get_data, 'wna_mask', data = kvec_data
    get_data, 'kpara_mask', data = kpara_data
    kpara_data.y[*, where(kpara_data.v lt focus_f[0]-0.1) ] = 'NaN'
    kpara_data.y[*, where(kpara_data.v gt focus_f[-1]+0.1) ] = 'NaN'


    ; ******************************
    ; 2.calc kpara(f)
    ; ******************************

    duct_time1 = '2017-07-03/04:32:30'
    duct_time2 = '2017-07-03/04:32:35'


    duct_time_double1 = time_double(duct_time1)
    duct_time_double2 = time_double(duct_time2)
    time_res =  kvec_data.x[100]- kvec_data.x[99]
    idx_t1 = where( kvec_data.x lt duct_time_double1+time_res/2 and kvec_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( kvec_data.x lt duct_time_double2+time_res/2 and kvec_data.x gt duct_time_double2-time_res/2, cnt )

    ; ダクトの全幅分のkparaを持ってくる → 周波数方向を残して平均をとる
    kpara_data_idx_t = mean(kpara_data.y[idx_t1:idx_t2, *], DIMENSION=1, /nan)

    ; if idx_t eq -1 then begin
    ;     print, '!!!!Caution!!!! /n Duct time is not selected correctly. Check the code.'
    ;     stop
    ; endif

    ; 最小二乗法でダクト中心でのkparaを直線に当てはめる
    if not keyword_set(lsm) then begin
        lsm = least_squares_method(kpara_data.v, kpara_data_idx_t)
    endif

    data__f_kpara = kpara_data_idx_t

end