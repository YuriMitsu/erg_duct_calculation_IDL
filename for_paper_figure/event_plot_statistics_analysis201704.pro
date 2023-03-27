; pythonで綺麗に書けたらいいかも？と思ったり
; ひとまず早くできそうなIDLで作図

; compile
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/event_plot_statistics_analysis201704.pro'




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
    tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Btotal_132', 'S'
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132_interp', data=data_ref
    get_data, 'S', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'S_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


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
    store_data, 'polarization_mask_gyro', $
        data=['polarization_LASVD_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'planarity_gyro', $
        data=['planarity_LASVD_ma3', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
    store_data, 'planarity_mask_gyro', $
        data=['planarity_LASVD_mask', 'fce', 'fce_half', 'flhr', 'fce_TS04', 'fce_TS04_half']
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
    options, 'polarization_mask_gyro', ytitle='ploarization',      ysubtitle='f [kHz]', ztitle=''
    options, 'planarity_gyro',         ytitle='planarity',         ysubtitle='f [kHz]', ztitle=''
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


pro event_plot_statistics_analysis201704



    SET_PLOT, 'Z'
    DEVICE, SET_RESOLUTION = [1000,1300]
    !p.BACKGROUND = 255
    !p.color = 0
    ; !P.FONT = 0
    !p.charsize=1.2



    timespan, '2017-04-01/01:45:00', 15, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 15.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 300.0, 0
    ylim, 'Ne', 120.0, 600.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0401', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0401', /mkdir
    ; stop




    timespan, '2017-04-03/10:25:00', 40, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 15.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 300.0, 0
    ylim, 'Ne', 100.0, 500.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0403', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0403', /mkdir



    timespan, '2017-04-04/22:10:00', 15, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 7.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 100.0, 250.0, 0
    ylim, 'Ne', 250.0, 550.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0404', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0404', /mkdir



    timespan, '2017-04-05/10:25:00', 30, /minute 

    a = loading()

    ylim, '*_gyro', 3.0, 9.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 50.0, 130.0, 0
    ylim, 'Ne', 50.0, 130.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0405', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0405', /mkdir



    timespan, '2017-04-07/16:05:00', 50, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 5.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 300.0, 0
    ylim, 'Ne', 100.0, 500.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0407', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0407', /mkdir


    timespan, '2017-04-11/08:00:00', 20, /minute

    a = loading()

    ylim, '*_gyro', 5.0, 15.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 300.0, 0
    ylim, 'Ne', 150.0, 600.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0411', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0411', /mkdir

; stop

    timespan, '2017-04-12/22:10:00', 30, /minute 

    a = loading()

    ylim, '*_gyro', 1.0, 6.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 50.0, 200.0, 0
    ylim, 'Ne', 50.0, 350.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0412', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0412', /mkdir



    timespan, '2017-04-13/14:40:00', 20, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 4.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 200.0, 0
    ylim, 'Ne', 50.0, 300.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0413', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0413', /mkdir



    timespan, '2017-04-14/00:00:00', 30, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 5.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 100.0, 350.0, 0
    ylim, 'Ne', 300.0, 800.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot04141', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot04141', /mkdir



    timespan, '2017-04-14/11:55:00', 15, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 4.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 100.0, 250.0, 0
    ylim, 'Ne', 100.0, 500.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot04142', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot04142', /mkdir



    timespan, '2017-04-17/03:20:00', 40, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 3.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 250.0, 0
    ylim, 'Ne', 100.0, 500.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0417', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0417', /mkdir



    timespan, '2017-04-24/17:30:00', 10, /minute 

    a = loading()

    ylim, '*_gyro', 0.064, 7.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 300.0, 0
    ylim, 'Ne', 100.0, 500.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0424', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0424', /mkdir



    timespan, '2017-04-30/07:00:00', 20, /minute 

    a = loading()

    ylim, '*_gyro', 1.0, 5.0, 0 ; kHz
    ylim, 'hfa_e_gyro', 70.0, 200.0, 0
    ylim, 'Ne', 150.0, 350.0, 0

    ; tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro', 'S_mask_gyro']
    tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'Ne', 'kvec_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'planarity_gyro', 'planarity_mask_gyro']

    ; makepng, '/Users/ampuku/Documents/duct/fig/_paper_figure/event_plot0430', /mkdir
    makepng, '/Users/ampuku/OneDrive/duct/test/event_plot0430', /mkdir










end