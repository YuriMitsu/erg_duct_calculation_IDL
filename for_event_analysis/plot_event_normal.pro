
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal.pro'


pro plot_event_normal, UHR_file_name=UHR_file_name

    ; *****************
    ; plot event for meeting
    ; *****************

    uname = 'erg_project'
    pass = 'geospace'

    ; *****************
    ; 1.set time span
    ; *****************

    ;  timespan, '2018-06-06/11:20:00', 40, /minute

    ; *****************
    ; 2.load orbit CDF & set var label
    ; *****************
    set_erg_var_label

    ; *****************
    ; 3.load HFA
    ; *****************

    erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
    pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified

    ; *****************
    ; 3.calc. wave params
    ; *****************

    calc_wave_params, moving_average=3, algebraic_SVD=0

    ; ************************************
    ; 13.stokes parameter
    ; ************************************

    ; calc_stokes_params

    ; ************************************
    ; 14.mask
    ; ************************************

    get_data, pr_matrix + 'Btotal_132', data=data_ref; *** modified (B_total_132 -> Btotal_132)
    cut_f = 1E-2

    ; kvec
    get_data, 'kvec_LASVD_ma3', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'kvec_LASVD_ma3_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ; polarization
    get_data, 'polarization_LASVD_ma3', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'polarization_LASVD_ma3_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ; planarity
    get_data, 'planarity_LASVD_ma3', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'planarity_LASVD_ma3_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


    ; ************************************
    ; 16.mepe
    ; ************************************

    ; calc_mepe

    ; ************************************
    ; 17-1.cal fce.etc
    ; ************************************

    calc_fce_and_flhr

    calc_Ne, UHR_file_name=UHR_file_name

    calc_equatorial_fce

    ; ************************************
    ; 17-2.overplot fce.etc
    ; ************************************

    store_data, pr_matrix + 'Etotal_132_gyro' $
        , data=[pr_matrix + 'Etotal_132', 'fce', 'fce_half','flhr']
    store_data, pr_matrix + 'Btotal_132_gyro' $
        , data=[pr_matrix + 'Btotal_132', 'fce', 'fce_half','flhr']
    
    store_data, 'planarity_gyro', data=['planarity_LASVD_ma3', 'fce', 'fce_half','flhr']
    options, 'kvec_mask_gyro', ytitle='WNA', ysubtitle='Frequency!C[kHz]', ztitle='[degree]'
    store_data, 'kvec_mask_gyro', data=['kvec_LASVD_ma3_mask', 'fce', 'fce_half','flhr']
    options, 'kvec_mask_gyro', ytitle='WNA', ysubtitle='Frequency!C[kHz]', ztitle='[degree]'
    store_data, 'polarization_mask_gyro', data=['polarization_LASVD_ma3_mask', 'fce', 'fce_half','flhr']
    options, 'polarization_mask_gyro', ytitle='polarization', ysubtitle='Frequency!C[kHz]', ztitle=''
    store_data, 'planarity_mask_gyro', data=['planarity_LASVD_ma3_mask', 'fce', 'fce_half','flhr']
    options, 'planarity_mask_gyro', ytitle='planarity', ysubtitle='Frequency!C[kHz]', ztitle=''

    ylim, '*_gyro', 0.1, 20, 1 ; kHz

    zlim, pr_matrix + 'Etotal_132_gyro', 1e-10, 1, 1
    zlim, pr_matrix + 'Btotal_132_gyro', 1E-2, 1E2, 1 ; pT^2/Hz

    options, pr_matrix + 'Etotal_132_gyro', $
        ytitle='OFA E total', ysubtitle='Frequency!C[kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'
    options, pr_matrix + 'Btotal_132_gyro', $
        ytitle='OFA B total', ysubtitle='Frequency!C[kHz]', ztitle='[pT!U2!N/Hz]'

    store_data, 'hfa_gyro' $
        , data=['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix', 'fce', 'fce_half','flhr', 'f_UHR_interp']
    ylim,  'hfa_gyro', 20.0, 400.0, 1
    zlim,  'hfa_gyro', 1e-10, 1, 1

    options, 'hfa_gyro', $
        ytitle='HFA E', ysubtitle='Frequency!C[kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'

    ; ************************************
    ; 18.plot
    ; ************************************

    SET_PLOT, 'Z'
    DEVICE, SET_RESOLUTION = [1500,1800]
    !p.BACKGROUND = 255
    !p.color = 0

    time_stamp, /off
    options, ['hfa_gyro', pr_matrix+'Btotal_132_gyro', pr_matrix+'Etotal_132_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_mask_gyro', 'planarity_gyro', 'ofa_b_Bmodels_correction'], 'color_table', 43
    ylim, [pr_matrix+'Btotal_132_gyro', pr_matrix+'Etotal_132_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_mask_gyro', 'planarity_gyro', 'ofa_b_Bmodels_correction'], 0.5, 10., 1
    ylim, 'Ne', 50, 500, 1
    tplot, ['hfa_gyro', pr_matrix+'Btotal_132_gyro', pr_matrix+'Etotal_132_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_mask_gyro', 'planarity_gyro', 'ofa_b_Bmodels_correction']

    t = timerange(/current) 
    ret1 = strsplit(time_string(t[0]), '-/:', /extract)
    ret2 = strsplit(time_string(t[1]), '-/:', /extract)
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret1[0]+ret1[1]+ret1[2]+'/'+ret1[3]+ret1[4]+ret1[5]+'-'+ret2[3]+ret2[4]+ret2[5]

    stop
end
