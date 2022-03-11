pro plot_event_equatorial_fce

    ; *****************
    ; plot event equatorial fce
    ; *****************

    uname = 'erg_project'
    pass = 'geospace'

    ; *****************
    ; 1.set time span
    ; *****************

    ;  timespan, '2018-06-06/11:20:00', 40, /minute

    ; *****************
    ; 2.load HFA
    ; *****************

    set_erg_var_label
    erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
    erg_load_pwe_ofa
    pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified

    ; *****************
    ; 3.calc. fce
    ; *****************

    calc_equatorial_fce
    calc_fce_and_flhr

    ; ************************************
    ; 18.plot
    ; ************************************

    SET_PLOT, 'Z'
    DEVICE, SET_RESOLUTION = [1000,600]
    !p.BACKGROUND = 255
    !p.color = 0

    time_stamp, /off
    tplot, ['hfa_e_Bmodels_correction', 'ofa_e_Bmodels_correction', 'ofa_b_Bmodels_correction']

    t = timerange(/current) 
    ret1 = strsplit(time_string(t[0]), '-/:', /extract)
    ret2 = strsplit(time_string(t[1]), '-/:', /extract)
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret1[0]+ret1[1]+ret1[2]+'/'+ret1[3]+ret1[4]+ret1[5]+'-'+ret2[3]+ret2[4]+ret2[5]+'_equatorial_fce'

    stop
end
