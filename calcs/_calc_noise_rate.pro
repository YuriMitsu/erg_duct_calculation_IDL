pro calc_noise_rate


    ; *****************
    ; calc noise rate
    ; *****************

    uname = 'erg_project'
    pass = 'geospace'

    ; *****************
    ; 1.load 
    ; *****************

    ; 下記計算後に使用
    ; calc_wave_params, moving_average=3, algebraic_SVD=0

    SET_PLOT, 'X'
    !p.BACKGROUND = 255
    !p.color = 0
    window, xsize=1200, ysize=800
    ;tplot, 'erg_pwe_hfa_l2_low_spectra_e_mix'
    tplot, 'powspec_b_LASVD_ma3'
    ctime, f_time, f_y
    ; 右クリックで終了

    max_f_time = max(f_time) & min_f_time = min(f_time)
    max_f_y = max(f_y) & min_f_y = min(f_y)

    get_data, 'powspec_b_LASVD_ma3', data=powspec_b

    ; ここまで _(:3 」∠)_

    powspec_b.x
    mask1 = ( data.x lt f_time[0] )
idx1 = UINT( TOTAL(mask1) )
mask2 = ( data.x lt f_time[-1] )
idx2 = UINT( TOTAL(mask2) )


store_data, 'f_UHR', data={x:f_time, y:f_y}, dlim={colors:5,thick:1,linestyle:1}
options, 'f_UHR', 'ytitle', 'f_UHR'
options, 'f_UHR', 'ysubtitle', 'frequency [kHz]'

; ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR'], 40.0, 200.0, 0
ylim,  ['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR'], 20.0, 110.0, 0
tplot, 'erg_pwe_hfa_l2_high_spectra_e_mix'
tplot, 'f_UHR', /oplot






end