
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_ne.pro'
; http://adrastea.gp.tohoku.ac.jp/~erg/data/hfa_l3_h/

; 熊本先生のuhrHtoolでUHRを読み取っていた場合、UHR_file_name='kuma'とすればOK


pro plot_event_normal, UHR_file_name=UHR_file_name, desplay_on=desplay_on

    if not keyword_set(UHR_file_name) then UHR_file_name = 'kuma'
    if not keyword_set(desplay_on) then desplay_on = 0

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

    calc_wave_params, moving_average=3, algebraic_SVD=1

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

    ; kvec means
    get_data, 'kvec_algebraicSVD_ma3', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'kvec_algebraicSVD_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ; Poynting vector
    get_data, 'S', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'S_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


    ; ************************************
    ; 16.mepe
    ; ************************************

    ; calc_mepe

    ; ************************************
    ; 17-1.cal fce,Ne.etc
    ; ************************************

    if UHR_file_name eq 'kuma' then begin

        load_fufp_txt, /high
        calc_fufp_renames

    endif else begin

        calc_fce_and_flhr
        calc_Ne, UHR_file_name=UHR_file_name

    endelse

    calc_equatorial_fce

    calc_EBrate

    ; ************************************
    ; 17-2.overplot fce.etc
    ; ************************************

    store_data, pr_matrix + 'Etotal_132_gyro' $
        , data=[pr_matrix + 'Etotal_132', 'fce', 'fce_half', 'flhr']
    store_data, pr_matrix + 'Btotal_132_gyro' $
        , data=[pr_matrix + 'Btotal_132', 'fce', 'fce_half', 'flhr']
    
    store_data, 'planarity_gyro', data=['planarity_LASVD_ma3', 'fce', 'fce_half', 'flhr']
    options, 'kvec_mask_gyro', ytitle='WNA', ysubtitle='Frequency!C[kHz]', ztitle='[degree]'
    store_data, 'kvec_mask_gyro', data=['kvec_LASVD_ma3_mask', 'fce', 'fce_half', 'flhr']
    options, 'kvec_mask_gyro', ytitle='WNA', ysubtitle='Frequency!C[kHz]', ztitle='[degree]'
    store_data, 'polarization_mask_gyro', data=['polarization_LASVD_ma3_mask', 'fce', 'fce_half', 'flhr']
    options, 'polarization_mask_gyro', ytitle='polarization', ysubtitle='Frequency!C[kHz]', ztitle=''
    store_data, 'planarity_mask_gyro', data=['planarity_LASVD_ma3_mask', 'fce', 'fce_half', 'flhr']
    options, 'planarity_mask_gyro', ytitle='planarity', ysubtitle='Frequency!C[kHz]', ztitle=''
    store_data, 'S_mask_gyro', data=['S_mask', 'fce', 'fce_half', 'flhr']
    options, 'S_mask_gyro', ytitle='Poynting vector', ysubtitle='Frequency!C[kHz]', ztitle=''


    ylim, '*_gyro', 0.1, 20, 1 ; kHz

    zlim, pr_matrix + 'Etotal_132_gyro', 1E-9, 1E-1, 1
    zlim, pr_matrix + 'Btotal_132_gyro', 1E-4, 1E2, 1 ; pT^2/Hz

    options, pr_matrix + 'Etotal_132_gyro', $
        ytitle='OFA E total', ysubtitle='Frequency!C[kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'
    options, pr_matrix + 'Btotal_132_gyro', $
        ytitle='OFA B total', ysubtitle='Frequency!C[kHz]', ztitle='[pT!U2!N/Hz]'

    store_data, 'hfa_gyro' $
        , data=['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix', 'fce', 'fce_half','flhr', 'f_UHR_interp']
    ylim,  'hfa_gyro', 20.0, 400.0, 1
    zlim,  'hfa_gyro', 1E-10, 1E-3, 1

    options, 'hfa_gyro', $
        ytitle='HFA E', ysubtitle='Frequency!C[kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'

    if desplay_on eq 1 then begin
        set_plot, 'X'
        window, 0, xsize=850, ysize=600
        !p.background = 255
        !p.color = 0

        ylim, ['kvec_mask_gyro', 'planarity_mask_gyro'], 1.0, 20.0, 1
        ylim, 'Ne', 100, 1500, 1
        tplot, [pr_matrix+'Btotal_132_gyro', pr_matrix+'Etotal_132_gyro', 'Ne', 'kvec_mask_gyro', 'planarity_mask_gyro']
        stop
    endif

    ; ************************************
    ; 18.plot
    ; ************************************

    if desplay_on eq 0 then begin
        SET_PLOT, 'Z'
        DEVICE, SET_RESOLUTION = [1500,2500]
        !p.BACKGROUND = 255
        !p.color = 0

        time_stamp, /off
        options, ['hfa_gyro', pr_matrix+'Btotal_132_gyro', pr_matrix+'Etotal_132_gyro', 'EBrate', 'kvec_algebraicSVD_ma3', 'kvec_algebraicSVD_mask', 'kvec_LASVD_ma3', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_mask_gyro', 'planarity_gyro', 'S_mask_gyro', 'ofa_b_Bmodels_correction'], 'color_table', 43
        ylim, [pr_matrix+'Btotal_132_gyro', pr_matrix+'Etotal_132_gyro', 'EBrate', 'kvec_algebraicSVD_ma3', 'kvec_algebraicSVD_mask', 'kvec_LASVD_ma3', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_mask_gyro', 'planarity_gyro', 'S_mask_gyro', 'ofa_b_Bmodels_correction'], 0.0, 16.0, 0
        ylim, 'Ne', 0, 500, 1
        ; tplot, [pr_matrix+'Etotal_132_gyro', pr_matrix+'Btotal_132_gyro', 'Ne', 'kvec_mask_gyro']
        tplot, ['hfa_gyro', pr_matrix+'Btotal_132_gyro', pr_matrix+'Etotal_132_gyro', 'EBrate', 'Ne', 'kvec_algebraicSVD_ma3', 'kvec_algebraicSVD_mask', 'kvec_LASVD_ma3', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S', 'S_mask_gyro', 'ofa_b_Bmodels_correction']
        t = timerange(/current) 
        ret1 = strsplit(time_string(t[0]), '-/:', /extract)
        ret2 = strsplit(time_string(t[1]), '-/:', /extract)

        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret1[0]+ret1[1]+ret1[2]+'/'+ret1[3]+ret1[4]+ret1[5]+'-'+ret2[3]+ret2[4]+ret2[5], /mkdir
    endif

end
