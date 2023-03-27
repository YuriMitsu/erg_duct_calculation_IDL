; pythonで綺麗に書けたらいいかも？と思ったり
; ひとまず早くできそうなIDLで作図

; compile
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/event_plot.pro'




function loading

    ; *****************
    ; 1.load data
    ; *****************

    uname = 'erg_project'
    pass = 'geospace'

    set_erg_var_label
    erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
    erg_load_pwe_ofa
    erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass

    ; *****************
    ; 1.calc params
    ; *****************

    calc_wave_params, moving_average=3, algebraic_SVD=1
    calc_equatorial_fce

    load_fufp_txt, /high
    store_data, 'Ne', /delete
    store_data, 'hfa_l3_ne', newname='Ne'

    store_data, 'fUHR', /delete
    store_data, 'hfa_l3_fuh', newname='fUHR'

    calc_fce_and_flhr


    ; ************************************
    ; 3.mask
    ; ************************************

    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data=data_ref; *** modified (B_total_132 -> Btotal_132)
    cut_f = 1E-2
    ; kvec
    get_data, 'kvec_LASVD_ma3', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'kvec_LASVD_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    ; polarization
    get_data, 'polarization_LASVD_ma3', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'polarization_LASVD_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    ; planarity
    get_data, 'planarity_LASVD_ma3', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'planarity_LASVD_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ; Poynting vector
    ; erg_load_pwe_ofa, level='l3'
    tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Btotal_132', 'erg_pwe_ofa_l3_property_Pvec_angle_132'
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132_interp', data=data_ref
    get_data, 'erg_pwe_ofa_l3_property_Pvec_angle_132', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'S_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ; tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Btotal_132', 'S'
    ; get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132_interp', data=data_ref
    ; get_data, 'S', data=data, dlim=dlim, lim=lim
    ; data.y[where(data_ref.y LT cut_f)] = 'NaN'
    ; store_data, 'S_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


    ; ************************************
    ; 4.overplot fce.etc
    ; ************************************

    store_data, 'hfa_e_gyro', $
        data=['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix', 'fUHR']
    store_data, 'ofa_e_gyro', $
        data=['erg_pwe_ofa_l2_matrix_Etotal_132', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'ofa_b_gyro', $
        data=['erg_pwe_ofa_l2_matrix_Btotal_132', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'kvec_gyro', $
        data=['kvec_LASVD_ma3', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'kvec_mask_gyro', $
        data=['kvec_LASVD_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'polarization_gyro', $
        data=['polarization_LASVD_ma3', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'polarization_mask_gyro', $
        data=['polarization_LASVD_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'planarity_gyro', $
        data=['planarity_LASVD_ma3', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'planarity_mask_gyro', $
        data=['planarity_LASVD_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'S_gyro', $
        data=['erg_pwe_ofa_l3_property_Pvec_angle_132', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']

    ; store_data, 'S_gyro', $
        ; data=['S', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'S_mask_gyro', $
        data=['S_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']


    ; ************************************
    ; 4.set options
    ; ************************************

    zlim, 'hfa_e_gyro', 1e-9, 1e-4, 1
    zlim, 'ofa_e_gyro', 1e-9, 1e2,  1
    zlim, 'ofa_b_gyro', 1e-4, 1e2,  1 ; pT^2/Hz

    options, 'hfa_e_gyro',             ytitle='HFA-E',             ysubtitle='f [kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'
    options, 'ofa_e_gyro',             ytitle='OFA-E',             ysubtitle='f [kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'
    options, 'ofa_b_gyro',             ytitle='OFA-B',             ysubtitle='f [kHz]', ztitle='[pT!U2!N/Hz]'
    options, 'Ne',                     ytitle='',                  ysubtitle='Ne [/cc]'
    options, 'kvec_gyro',              ytitle='WNA',               ysubtitle='f [kHz]', ztitle='[degree]'
    options, 'kvec_mask_gyro',         ytitle='WNA',               ysubtitle='f [kHz]', ztitle='[degree]'
    options, 'polarization_gyro',      ytitle='ploarization',      ysubtitle='f [kHz]', ztitle=''
    options, 'polarization_mask_gyro', ytitle='ploarization',      ysubtitle='f [kHz]', ztitle=''
    options, 'planarity_gyro',         ytitle='planarity',         ysubtitle='f [kHz]', ztitle=''
    options, 'planarity_mask_gyro',    ytitle='planarity',         ysubtitle='f [kHz]', ztitle=''
    options, 'S_gyro',                 ytitle='Poynting!Cvector',  ysubtitle='f [kHz]', ztitle='[degree]'
    options, 'S_mask_gyro',            ytitle='Poynting!Cvector',  ysubtitle='f [kHz]', ztitle='[degree]'

    options, '*_gyro', 'zoffset', [1., 2.]
    options, '*_gyro', 'zticklen', -0.5
    options, 'ofa_b_gyro', ztickunits='scientific'

    tplot_options, 'xticklen', -0.02
    tplot_options, 'yticklen', -0.01

    ; color: 0黒 1ピンク 2青 3シアン 4黄緑 5黄色 6赤 7以降黒
    ; linestyle: 0棒線 1破線(細) 2破線(長) 3破線(細＆長) 4破線(細*3＆長) 5以降破線(長)

    thick_=3.5
    options, 'fUHR',          colors=5, thick=thick_, linestyle=0
    options, 'fce',           colors=1, thick=thick_, linestyle=0
    options, 'fce_half',      colors=1, thick=thick_, linestyle=2
    options, 'fce_TS04',      colors=0, thick=thick_, linestyle=0
    options, 'fce_TS04_half', colors=0, thick=thick_, linestyle=2
    options, 'flhr',          colors=0, thick=thick_, linestyle=1

    ; options, ['hfa_e_gyro', 'ofa_e_gyro', 'Btotal_132_gyro', 'kvec_LASVD_ma3', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S', 'S_mask'], 'datagap', 60.0

end

function loading_wfc

    ; *****************
    ; 1.load data
    ; *****************

    uname = 'erg_project'
    pass = 'geospace'

    set_erg_var_label
    erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
    ; erg_load_pwe_ofa
    erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass

    ; *****************
    ; 1.calc params
    ; *****************

    ; calc_wave_params, moving_average=3, algebraic_SVD=1
    calc_equatorial_fce

    load_fufp_txt, /high
    store_data, 'Ne', /delete
    store_data, 'hfa_l3_ne', newname='Ne'

    store_data, 'fUHR', /delete
    store_data, 'hfa_l3_fuh', newname='fUHR'

    calc_fce_and_flhr

    calc_wave_params

    ; ************************************
    ; 3.mask
    ; ************************************

    get_data, 'bspec', data=data_ref; *** modified (B_total_132 -> Btotal_132)
    cut_f = 1E-2
    ; kvec
    get_data, 'wna', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'wna_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    ; polarization
    get_data, 'polarization', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'polarization_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    ; planarity
    get_data, 'planarity', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'planarity_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    ; planarity
    get_data, 'kvec_xy', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'kvec_xy_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ; Poynting vector
    ; tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Btotal_132', 'S'
    ; get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132_interp', data=data_ref
    ; get_data, 'S', data=data, dlim=dlim, lim=lim
    ; data.y[where(data_ref.y LT cut_f)] = 'NaN'
    ; store_data, 'S_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


    ; ************************************
    ; 4.overplot fce.etc
    ; ************************************

    store_data, 'hfa_e_gyro', $
        data=['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix', 'fUHR']
    store_data, 'wfc_e_gyro', $
        data=['espec', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'wfc_b_gyro', $
        data=['bspec', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'wna_gyro', $
        data=['wna', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'wna_mask_gyro', $
        data=['wna_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']

    store_data, 'kvec_xy_gyro', $
        data=['kvec_xy', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'kvec_xy_mask_gyro', $
        data=['kvec_xy_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']

    store_data, 'polarization_gyro', $
        data=['polarization', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'polarization_mask_gyro', $
        data=['polarization_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'planarity_gyro', $
        data=['planarity', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'planarity_mask_gyro', $
        data=['planarity_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    ; store_data, 'S_gyro', $
    ;     data=['S', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    ; store_data, 'S_mask_gyro', $
    ;     data=['S_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']


    ; ************************************
    ; 4.set options
    ; ************************************

    zlim, 'hfa_e_gyro', 1e-9, 1e-4, 1
    zlim, 'wfc_e_gyro', 1e-9, 1e2,  1
    zlim, 'wfc_b_gyro', 1e-4, 1e2,  1 ; pT^2/Hz

    get_data, 'espec', data=data & store_data, 'espec', data={x:data.x, y:data.y, v:data.v/1000.}
    get_data, 'bspec', data=data & store_data, 'bspec', data={x:data.x, y:data.y, v:data.v/1000.}
    get_data, 'wna', data=data & store_data, 'wna', data={x:data.x, y:data.y, v:data.v/1000.}
    get_data, 'wna_mask', data=data & store_data, 'wna_mask', data={x:data.x, y:data.y, v:data.v/1000.}

    get_data, 'kvec_xy', data=data & store_data, 'kvec_xy', data={x:data.x, y:data.y, v:data.v/1000.}
    get_data, 'kvec_xy_mask', data=data & store_data, 'kvec_xy_mask', data={x:data.x, y:data.y, v:data.v/1000.}
    
    get_data, 'polarization', data=data & store_data, 'polarization', data={x:data.x, y:data.y, v:data.v/1000.}
    get_data, 'polarization_mask', data=data & store_data, 'polarization_mask', data={x:data.x, y:data.y, v:data.v/1000.}
    get_data, 'planarity', data=data & store_data, 'planarity', data={x:data.x, y:data.y, v:data.v/1000.}
    get_data, 'planarity_mask', data=data & store_data, 'planarity_mask', data={x:data.x, y:data.y, v:data.v/1000.}
    ; get_data, 'S', data=data & store_data, 'S', data={x:data.x, y:data.y, v:data.v/1000.}
    ; get_data, 'S_mask', data=data & store_data, 'S_mask', data={}
    ; get_data, 'S_mask', data=data & store_data, 'S_mask', data={x:data.x, y:data.y, v:data.v/1000.}

    options, 'hfa_e_gyro',             ytitle='HFA-E',             ysubtitle='f [kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'
    options, 'wfc_e_gyro',             ytitle='WFC-E',             ysubtitle='f [kHz]', ztitle='[mV!U2!N/m!U2!N/Hz]'
    options, 'wfc_b_gyro',             ytitle='WFC-B',             ysubtitle='f [kHz]', ztitle='[pT!U2!N/Hz]'
    options, 'Ne',                     ytitle='',                  ysubtitle='Ne [/cc]'
    options, 'wna_gyro',               ytitle='WNA',               ysubtitle='f [kHz]', ztitle='[degree]'
    options, 'wna_mask_gyro',          ytitle='WNA',               ysubtitle='f [kHz]', ztitle='[degree]'

    options, 'kvec_xy_gyro',           ytitle='phi',               ysubtitle='f [kHz]', ztitle='[degree]'
    options, 'kvec_xy_mask_gyro',      ytitle='phi',               ysubtitle='f [kHz]', ztitle='[degree]'
    
    options, 'polarization_gyro',      ytitle='ploarization',      ysubtitle='f [kHz]', ztitle=''
    options, 'polarization_mask_gyro', ytitle='ploarization',      ysubtitle='f [kHz]', ztitle=''
    options, 'planarity_gyro',         ytitle='planarity',         ysubtitle='f [kHz]', ztitle=''
    options, 'planarity_mask_gyro',    ytitle='planarity',         ysubtitle='f [kHz]', ztitle=''
    ; options, 'S_gyro',                 ytitle='Poynting!Cvector',  ysubtitle='f [kHz]', ztitle='[degree]'
    ; options, 'S_mask_gyro',            ytitle='Poynting!Cvector',  ysubtitle='f [kHz]', ztitle='[degree]'

    options, '*_gyro', 'zoffset', [1., 2.]
    options, '*_gyro', 'zticklen', -0.5
    options, 'wfc_b_gyro', ztickunits='scientific'

    tplot_options, 'xticklen', -0.02
    tplot_options, 'yticklen', -0.01

    ; color: 0黒 1ピンク 2青 3シアン 4黄緑 5黄色 6赤 7以降黒
    ; linestyle: 0棒線 1破線(細) 2破線(長) 3破線(細＆長) 4破線(細*3＆長) 5以降破線(長)

    thick_=3.5
    options, 'fUHR',          colors=5, thick=thick_, linestyle=0
    options, 'fce',           colors=1, thick=thick_, linestyle=0
    options, 'fce_half',      colors=1, thick=thick_, linestyle=2
    options, 'fce_TS04',      colors=0, thick=thick_, linestyle=0
    options, 'fce_TS04_half', colors=0, thick=thick_, linestyle=2
    options, 'flhr',          colors=0, thick=thick_, linestyle=1

    ; options, ['hfa_e_gyro', 'ofa_e_gyro', 'Btotal_132_gyro', 'kvec_LASVD_ma3', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S', 'S_mask'], 'datagap', 60.0

end

pro event_plot

    SET_PLOT, 'Z'
    DEVICE, SET_RESOLUTION = [1000,800]
    ; DEVICE, SET_RESOLUTION = [600,1800]
    !p.BACKGROUND = 255
    !p.color = 0
    ; !P.FONT = 0
    !p.charsize=1.2


    timespan, '2018-06-06/11:25:00', 20, /min

    a = loading()

    ylim, '*_gyro', 0.064, 8, 0 ; kHz
    ylim, 'hfa_e_gyro', 90.0, 190.0, 0
    ylim, 'Ne', 100.0, 400.0, 0

    ; tplot_save, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro'], $
        ; filename='/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/event_tplots/event_plot1'
    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot12_ver4', /mkdir
    makepng, '/Users/ampuku/OneDrive/4_event12_test'

    stop


    ; timespan, '2017-07-14/02:40:00', 20, /min

    ; a = loading()

    ; ylim, '*_gyro', 0.064, 8, 0 ; kHz
    ; ylim, '*_gyro', 0.064, 6, 0 ; kHz
    ; ; ylim, '*_gyro', 1, 5, 0 ; kHz
    ; ylim, 'hfa_e_gyro', 90.0, 190.0, 0
    ; ; ylim, 'hfa_e_gyro', 90.0, 160.0, 0
    ; ylim, 'Ne', 100.0, 400.0, 0
    ; ; ylim, 'Ne', 100.0, 260.0, 0

    ; ; tplot_save, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro'], $
    ;     ; filename='/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/event_tplots/event_plot1'
    ; ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']
    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']

    ; ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot3_ver4', /mkdir
    ; makepng, '/Users/ampuku/OneDrive/4_event3_test'

    ; stop


    ; timespan, '2017-07-03/04:32:00', 40, /sec

    ; tplot_restore, filename='/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/erg_pwe_wfc_20170703043200_20170703043255.tplot'
    ; a = loading_wfc()

;     ylim, '*_gyro', 2., 10., 0 ; kHz
;     ylim, 'hfa_e_gyro', 120.0, 160.0, 0
;     ylim, 'Ne', 230.0, 270.0, 0

;     ; tplot_save, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro'], $
;         ; filename='/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/event_tplots/event_plot1'
;     ; tplot, ['hfa_e_gyro', 'wfc_e_gyro', 'wfc_b_gyro', 'Ne', 'wna_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']
;     tplot, ['hfa_e_gyro', 'wfc_e_gyro', 'wfc_b_gyro', 'Ne', 'wna_gyro', 'wna_mask_gyro', 'polarization_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']

;     ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot4_ver4', /mkdir
;     makepng, '/Users/ampuku/OneDrive/4_event41_test'

; stop


    ; timespan, '2017-07-03/04:17:00', 20, /min

    ; a = loading()

    ; ylim, '*_gyro', 2., 12., 0 ; kHz
    ; ylim, 'hfa_e_gyro', 80.0, 160.0, 0
    ; ylim, 'Ne', 100.0, 270.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']

    ; ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot4_ver42', /mkdir
    ; makepng, '/Users/ampuku/OneDrive/4_event42_test'

    ; stop


    timespan, '2017-07-03/04:32:28', 8, /sec

    a = loading_wfc()

    ylim, '*_gyro', 4., 9., 0 ; kHz

    tplot, ['wfc_e_gyro', 'wfc_b_gyro', 'wna_gyro', 'kvec_xy_gyro', 'planarity_gyro']
    ; tplot, ['wfc_e_gyro', 'wfc_b_gyro', 'wna_gyro', 'wna_mask_gyro', 'polarization_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_gyro', 'S_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot4_ver42', /mkdir
    makepng, '/Users/ampuku/OneDrive/5_event4'

    stop




end





; set_plot, 'X'
; window, 0, xsize=1000, ysize=600
; !p.background = 255
; !p.color = 0
