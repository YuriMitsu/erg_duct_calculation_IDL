
pro test_20220711

    if not keyword_set(cut_f) then cut_f = 1E-2 ;nT
    if not keyword_set(UHR_file_name) then UHR_file_name = 'kuma'
    ; ******************************
    ; 1.load data
    ; ******************************


    uname = 'erg_project'
    pass = 'geospace'

    ;軌道読み込み
    ;set_erg_var_label
    
    ;磁場読み込み
    erg_load_mgf, datatype='8sec', uname=uname, pass=pass
    erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass

    ;HFA,OFA読み込み
    erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
    erg_load_pwe_ofa, datatype='matrix', uname=uname, pass=pass
    pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified


    ; ******************************
    ; 2.calc.
    ; ******************************
    ; 1. load data で読み込んだデータを使って各物理量を計算する
    ; ここで計算した値は全てtplot変数にして記録する

    ; ******************************
    ; 2.1.calc. wave palams
    ; ******************************

    calc_wave_params, cut_f=cut_f

    calc_fce_and_flhr

    calc_Ne, UHR_file_name=UHR_file_name

    calc_kpara, cut_f=cut_f

    set_plot, 'X'
    window, 0, xsize=1000, ysize=600
    !p.background = 255
    !p.color = 0

    tplot, 'kpara_LASVD_ma3_mask'

        t = timerange(/current) 
        ret = strsplit(time_string(t[0]), '-/:', /extract)

    tplot_save, 'kpara_LASVD_ma3_mask', filename='/Users/ampuku/Documents/duct/code/IDL/tplots/kpara_LASVD_ma3_mask_tplots/'+ret[0]+ret[1]+ret[2]+ret[3]+ret[4]+ret[5]+'kpara_LASVD_ma3_mask'

end