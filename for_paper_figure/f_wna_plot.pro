
; compile
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/f_wna_plot.pro'

function loading_f_wna_plot

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
    wave_params_ = '_LASVD_ma3'
    
    ; ******************************
    ; 2.2.calc. k_para
    ; ******************************

    calc_fce_and_flhr

    calc_Ne, UHR_file_name='kuma'

    calc_kpara, cut_f=cut_f


    ; ******************************
    ; 2.2.calc. equatorial fce
    ; ******************************

    ; for f_B plot in plot_f_Ne0_f_B 
    calc_equatorial_fce


end

function loading_f_wna_plot2, duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, number=number

    ; ******************************
    ; 1.get data
    ; ******************************

    ; for plot dots of observation WNA
    get_data, 'kvec_LASVD_ma3_mask', data=kvec_data
    kvec_data.y[*, where(kvec_data.v lt focus_f[0]-0.1) ] = 'NaN'
    kvec_data.y[*, where(kvec_data.v gt focus_f[-1]+0.1) ] = 'NaN'

    duct_time_double = time_double(duct_time)
    time_res =  kvec_data.x[100]- kvec_data.x[99]
    idx_t = where( kvec_data.x lt duct_time_double+time_res/2 and kvec_data.x gt duct_time_double-time_res/2, cnt )

    f_obs = kvec_data.v ; the.x
    kvec_obs = kvec_data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n,*] ; obs.y

    f_kvec_obs = fltarr(n_elements(kvec_obs[*,0]),n_elements(kvec_obs[0,*]))
    for i=0,n_elements(kvec_obs[*,0])-1 do f_kvec_obs[i,*] = f_obs ; obs.x

    ; calc gendrin angle
    get_data, 'fce', data=fce_data
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )
    fce_ave = fce_data.y[idx_t]
    fce_ave = fce_ave[0]

    gendrin_angle = fltarr(n_elements(f_obs))
    gendrin_angle = acos( 2.0 * f_obs / fce_ave ) / !pi * 180.0 ; the.y

    ; for plot line of equatorial fce
    calc_equatorial_fce
    
    tinterpol_mxn, 'fce_TS04_half', 'fce'
    get_data, 'fce_TS04_half_interp', data=eqfce_data
    time_res =  eqfce_data.x[100]- eqfce_data.x[99]
    idx_t = where( eqfce_data.x lt duct_time_double+time_res/2 and eqfce_data.x gt duct_time_double-time_res/2, cnt )
    equatorial_fce_duct = eqfce_data.y[idx_t]

    File_path = '/Users/ampuku/Documents/duct/code/python/for_paper_figure/f_wna_data'+STRING(number, FORMAT='(i0)')+'/'
    WRITE_CSV, File_path+'fobs_data.csv', f_obs
    WRITE_CSV, File_path+'gendrinangle_data.csv', gendrin_angle
    WRITE_CSV, File_path+'fkvecobs_data.csv', f_kvec_obs
    WRITE_CSV, File_path+'kvecobs_data.csv', kvec_obs
    WRITE_CSV, File_path+'fce_data.csv', fce_ave
    WRITE_CSV, File_path+'eqfce_data.csv', equatorial_fce_duct

end


function loading_f_wna_plot2_wfc, duct_time=duct_time, focus_f=focus_f, number=number


    ; ************************************
    ; 3.mask
    ; ************************************

    ; tinterpol_mxn, 'bspec', 'wna'
    ; get_data, 'bspec_interp', data=data_ref
    get_data, 'bspec', data=data_ref
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
    ; Poynting vector
    get_data, 'poyntingvec', data=data, dlim=dlim, lim=lim
    data.y[where(data_ref.y LT cut_f)] = 'NaN'
    store_data, 'poyntingvec_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


    ; ******************************
    ; 1.get data
    ; ******************************

    ; for plot dots of observation WNA
    get_data, 'wna_mask', data=kvec_data
    kvec_data.y[*, where(kvec_data.v/1000. lt focus_f[0]-0.1) ] = 'NaN'
    kvec_data.y[*, where(kvec_data.v/1000. gt focus_f[-1]+0.1) ] = 'NaN'

    duct_time1 = '2017-07-03/04:32:30'
    duct_time2 = '2017-07-03/04:32:35'

    duct_time_double1 = time_double(duct_time1)
    duct_time_double2 = time_double(duct_time2)
    time_res =  kvec_data.x[100]- kvec_data.x[99]
    idx_t1 = where( kvec_data.x lt duct_time_double1+time_res/2 and kvec_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( kvec_data.x lt duct_time_double2+time_res/2 and kvec_data.x gt duct_time_double2-time_res/2, cnt )

    f_obs = kvec_data.v/1000. ; the.x
    kvec_obs = kvec_data.y[idx_t1:idx_t2,*] ; obs.y

    f_kvec_obs = fltarr(n_elements(kvec_obs[*,0]),n_elements(kvec_obs[0,*]))
    for i=0,n_elements(kvec_obs[*,0])-1 do f_kvec_obs[i,*] = f_obs ; obs.x

    ; calc gendrin angle
    get_data, 'fce', data=fce_data
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt (duct_time_double1+duct_time_double2)/2+time_res/2 and fce_data.x gt (duct_time_double1+duct_time_double2)/2-time_res/2, cnt )
    fce_ave = fce_data.y[idx_t]
    fce_ave = fce_ave[0]

    gendrin_angle = fltarr(n_elements(f_obs))
    gendrin_angle = acos( 2.0 * f_obs / fce_ave ) / !pi * 180.0 ; the.y
    
    ; for plot line of equatorial fce
    calc_equatorial_fce
    
    tinterpol_mxn, 'fce_TS04_half', 'fce'
    get_data, 'fce_TS04_half_interp', data=eqfce_data
    time_res =  eqfce_data.x[100]- eqfce_data.x[99]
    idx_t = where( eqfce_data.x lt (duct_time_double1+duct_time_double2)/2+time_res/2 and eqfce_data.x gt (duct_time_double1+duct_time_double2)/2-time_res/2, cnt )
    equatorial_fce_duct = eqfce_data.y[idx_t]

    store_data, 'test', data={x:kvec_data.x[idx_t1:idx_t2], y:kvec_obs, v:f_obs}
    options, 'test', spec=1
    ylim, 'test', 0, 10, 0
    ylim, ['espec', 'bspec', 'wna_mask'], 0, 10000, 0
    stop
    tplot, [150, 145]

    File_path = '/Users/ampuku/Documents/duct/code/python/for_paper_figure/f_wna_data'+STRING(number, FORMAT='(i0)')+'/'
    WRITE_CSV, File_path+'fobs_data.csv', f_obs
    WRITE_CSV, File_path+'gendrinangle_data.csv', gendrin_angle
    WRITE_CSV, File_path+'fkvecobs_data.csv', f_kvec_obs
    WRITE_CSV, File_path+'kvecobs_data.csv', kvec_obs
    WRITE_CSV, File_path+'fce_data.csv', fce_ave
    WRITE_CSV, File_path+'eqfce_data.csv', equatorial_fce_duct

end


function loading_f_wna_plot_wfc

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
    ; 2.2.calc. k_para
    ; ******************************

    calc_fce_and_flhr

    calc_Ne, UHR_file_name='kuma'

    calc_equatorial_fce


end


pro f_wna_plot

    timespan, '2018-06-06/11:25:00', 20, /min

    duct_time='2018-06-06/11:29:40' & focus_f=[1., 2., 3., 4.] & duct_wid_data_n=3
    a = loading_f_wna_plot()
    ; 以下plot_f_Ne0_f_Bの中身
    a = loading_f_wna_plot2(duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, number=1)

    stop   

    duct_time='2018-06-06/11:32:29' & focus_f=[3., 4., 5., 6., 7.] & duct_wid_data_n=3
    a = loading_f_wna_plot2(duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, number=2)

    stop

    timespan, '2017-07-14/02:40:00', 20.0, /minute

    duct_time='2017-07-14/02:52:17' & focus_f=[1.,2.,3.,4.,5.] & duct_wid_data_n=10
    a = loading_f_wna_plot()
    a = loading_f_wna_plot2(duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, number=3)

    stop

    timespan, '2017-07-03/04:32:00', 1, /min

    duct_time='2017-07-03/04:32:32' & focus_f=[4., 5., 6., 7., 8., 9.]
    tplot_restore, file=['/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/erg_pwe_wfc_20170703043200_20170703043255.tplot']
    a = loading_f_wna_plot_wfc()
    a = loading_f_wna_plot2_wfc(duct_time=duct_time, focus_f=focus_f, number=4)

    ; stop

end

; set_plot, 'X'
; window, 0, xsize=1000, ysize=600
; !p.background = 255
; !p.color = 0
