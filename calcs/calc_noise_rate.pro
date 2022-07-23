
; compile
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_noise_rate.pro'
; for test use
; timespan, '2018-06-06/11:25:00', 20.0, /minute

; input
;   tplot 'erg_pwe_ofa_l2_matrix_Etotal_132', 'erg_pwe_ofa_l2_matrix_Btotal_132'

; output
;   tplot 'Etotal_nr', 'Btotal_nr'


pro calc_noise_rate
; duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

    uname = 'erg_project'
    pass = 'geospace'

    get_timespan, timesp

    plot_fl = 1

    ; ******************************
    ; 1.get data
    ; ******************************

    print, ''
    print, ''
    print, '****************************************************************************************'
    print, ''
    print, ''
    print, '  2018/6/6の背景ノイズデータを使おうとしています. '
    print, '  解析データによってはゲインが違う(?)ので、同じ日の背景ノイズデータを設定し直すと安心です. '
    print, '  このまま続ける場合は .continue を、変更する場合は calc_noise_rate.pro を書き換えてください. '
    print, ''
    print, ''
    print, '****************************************************************************************'
    print, ''
    print, ''

    stop

    timespan, '2018-06-06/13:30:00', 30, /min
    erg_load_pwe_ofa, datatype='matrix', uname=uname, pass=pass  
    get_data, 'erg_pwe_ofa_l2_matrix_Etotal_132', data = Etotal_data
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data = Btotal_data

    ; ******************************
    ; 2.calc Ne(kperp)
    ; ******************************

    duct_time_double1 = time_double('2018-06-06/13:30:00')
    duct_time_double2 = time_double('2018-06-06/14:00:00')
    time_res =  Etotal_data.x[1000]- Etotal_data.x[999]
    idx_t1 = where( Etotal_data.x lt duct_time_double1+time_res/2 and Etotal_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( Etotal_data.x lt duct_time_double2+time_res/2 and Etotal_data.x gt duct_time_double2-time_res/2, cnt )

    Epdata = fltarr(n_elements(Etotal_data.v))
    for i=0,n_elements(Etotal_data.y[idx_t1, *])-1 do begin
        Edata = Etotal_data.y[idx_t1:idx_t2, i]
        Epdata_ = cgPercentiles(Edata, Percentiles=0.1)
        Epdata[i] = Epdata_
    endfor

    if plot_fl then begin
        set_plot, 'X'
        window, 0, xsize=1000, ysize=600
        !p.background = 255
        !p.color = 0
        !p.multi=[0,1,2]

        plot, Etotal_data.v, Etotal_data.y[idx_t1, 0], xrange=[1.,20], yrange=[0.,2.0e-8], psym=3
        for i=1,n_elements(Etotal_data.y[idx_t1:idx_t2, 0])-1 do oplot, Etotal_data.v, Etotal_data.y[idx_t1+i, *], psym=3
        oplot, Etotal_data.v, Epdata
    endif

    time_res =  Btotal_data.x[1000]- Btotal_data.x[999]
    idx_t1 = where( Btotal_data.x lt duct_time_double1+time_res/2 and Btotal_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( Btotal_data.x lt duct_time_double2+time_res/2 and Btotal_data.x gt duct_time_double2-time_res/2, cnt )

    Bpdata = fltarr(n_elements(Btotal_data.v))
    for i=0,n_elements(Btotal_data.y[idx_t1, *])-1 do begin
        Bdata = Btotal_data.y[idx_t1:idx_t2, i]
        Bpdata_ = cgPercentiles(Bdata, Percentiles=0.1)
        Bpdata[i] = Bpdata_
    endfor


    if plot_fl then begin
        plot, Btotal_data.v, Btotal_data.y[idx_t1, 0], xrange=[1.,20], yrange=[0.,0.02], psym=3
        for i=1,n_elements(Btotal_data.y[idx_t1:idx_t2, 0])-1 do oplot, Btotal_data.v, Btotal_data.y[idx_t1+i, *], psym=3
        oplot, Btotal_data.v, Bpdata
    endif

    stop

    ; ******************************
    ; 3.return data
    ; ******************************

    timespan, timesp
    get_data, 'erg_pwe_ofa_l2_matrix_Etotal_132', data = Etotal_data, dlim=E_dlim, lim=E_lim
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data = Btotal_data, dlim=B_dlim, lim=B_lim

    duct_time_double1 = timesp[0]
    duct_time_double2 = timesp[1]
    time_res =  Etotal_data.x[1000]- Etotal_data.x[999]
    idx_t1 = where( Etotal_data.x lt duct_time_double1+time_res/2 and Etotal_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( Etotal_data.x lt duct_time_double2+time_res/2 and Etotal_data.x gt duct_time_double2-time_res/2, cnt )
    Etotal_nr = fltarr(n_elements(Etotal_data.y[idx_t1:idx_t2, 0]), n_elements(Etotal_data.y[idx_t1, *]))
    for i=0,n_elements(Etotal_data.y[idx_t1:idx_t2, 0])-1 do Etotal_nr[i,*] = Etotal_data.y[idx_t1+i,*] / Epdata
    store_data, 'Etotal_nr', data = {x:Etotal_data.x[idx_t1:idx_t2], y:Etotal_nr, v:Etotal_data.v}, dlim=E_dlim, lim=E_lim
    zlim, 'Etotal_nr', 1., 1e5, 1

    time_res =  Btotal_data.x[1000]- Btotal_data.x[999]
    idx_t1 = where( Btotal_data.x lt duct_time_double1+time_res/2 and Btotal_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( Btotal_data.x lt duct_time_double2+time_res/2 and Btotal_data.x gt duct_time_double2-time_res/2, cnt )
    Btotal_nr = fltarr(n_elements(Btotal_data.y[idx_t1:idx_t2, 0]), n_elements(Btotal_data.y[idx_t1, *]))
    for i=0,n_elements(Btotal_data.y[idx_t1:idx_t2, 0])-1 do Btotal_nr[i,*] = Btotal_data.y[idx_t1+i,*] / Bpdata
    store_data, 'Btotal_nr', data = {x:Btotal_data.x[idx_t1:idx_t2], y:Btotal_nr, v:Btotal_data.v}, dlim=B_dlim, lim=B_lim
    zlim, 'Btotal_nr', 1., 1e5, 1

    ylim, ['Etotal_nr', 'Btotal_nr'], 0.1, 20.0, 1
    ; ylim, ['erg_pwe_ofa_l2_matrix_Etotal_132', 'Etotal_nr', 'erg_pwe_ofa_l2_matrix_Btotal_132', 'Btotal_nr'], 0.1, 20.0, 1
    ; tplot, ['erg_pwe_ofa_l2_matrix_Etotal_132', 'Etotal_nr', 'erg_pwe_ofa_l2_matrix_Btotal_132', 'Btotal_nr']

    ; stop

end
