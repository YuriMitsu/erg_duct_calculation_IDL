; .compile -v '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/check_sn_of_obs.pro'

; timespan, '2017-07-03/04:32:20', 30, /sec & check_sn_of_obs, duct_time1='2017-07-03/04:32:36', duct_time2='2017-07-03/04:32:37'
; timespan, '2017-07-03/01:05:15', 45, /sec & check_sn_of_obs, duct_time1='2017-07-03/01:05:45', duct_time2='2017-07-03/01:05:48'
; timespan, '2017-07-03/05:02:15', 65, /sec & check_sn_of_obs, duct_time1='2017-07-03/05:03:10', duct_time2='2017-07-03/05:03:11'

; timespan, '2017-07-03/04:32:32'イベント用に作成、他イベントに使いたければ書き換えが必要...


pro check_sn_of_obs, duct_time1=duct_time1, duct_time2=duct_time2


    erg_load_pwe_wfc, datatype='spec'

    plot_fl = 1

    get_data, 'erg_pwe_wfc_l2_e_65khz_E_spectra', data=esdata
    get_data, 'erg_pwe_wfc_l2_b_65khz_B_spectra', data=bsdata



    duct_time_double1 = time_double(duct_time1)
    duct_time_double2 = time_double(duct_time2)
    time_res =  esdata.x[100]- esdata.x[99]
    idx_t1 = where( esdata.x lt duct_time_double1+time_res/2 and esdata.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( esdata.x lt duct_time_double2+time_res/2 and esdata.x gt duct_time_double2-time_res/2, cnt )

    Epdata = fltarr(n_elements(esdata.v))
    for i=0,n_elements(esdata.y[idx_t1, *])-1 do begin
        Edata = esdata.y[idx_t1:idx_t2, i]
        Epdata_ = cgPercentiles(Edata, Percentiles=0.1)
        Epdata[i] = Epdata_
    endfor

    if plot_fl then begin
        set_plot, 'X'
        window, 0, xsize=1000, ysize=600
        !p.background = 255
        !p.color = 0
        !p.multi=[0,1,2]

        plot, esdata.v, esdata.y[idx_t1, *], xrange=[4000,10000], yrange=[0.,cgPercentiles(esdata.y[idx_t1, *], Percentiles=0.9)], psym=3, xtitle='f[Hz]', ytitle='E spec'
        for i=1,n_elements(esdata.y[idx_t1:idx_t2, 0])-1 do oplot, esdata.v, esdata.y[idx_t1+i, *], psym=3
        oplot, esdata.v, Epdata
    endif


    time_res =  bsdata.x[100]- bsdata.x[99]
    idx_t1 = where( bsdata.x lt duct_time_double1+time_res/2 and bsdata.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( bsdata.x lt duct_time_double2+time_res/2 and bsdata.x gt duct_time_double2-time_res/2, cnt )

    Bpdata = fltarr(n_elements(bsdata.v))
    for i=0,n_elements(bsdata.y[idx_t1, *])-1 do begin
        Bdata = bsdata.y[idx_t1:idx_t2, i]
        Bpdata_ = cgPercentiles(Bdata, Percentiles=0.1)
        Bpdata[i] = Bpdata_
    endfor


    if plot_fl then begin
        plot, bsdata.v, bsdata.y[idx_t1, *], xrange=[4000,10000], yrange=[0.,cgPercentiles(bsdata.y[idx_t1, *], Percentiles=0.9)], psym=3, xtitle='f[Hz]', ytitle='B spec'
        for i=1,n_elements(bsdata.y[idx_t1:idx_t2, 0])-1 do oplot, bsdata.v, bsdata.y[idx_t1+i, *], psym=3
        oplot, bsdata.v, Bpdata
    endif


    ; stop


    timespan, '2017-07-03/04:32:20', 30, /sec

    erg_load_pwe_wfc, datatype='spec'

    get_data, 'erg_pwe_wfc_l2_e_65khz_E_spectra', data = Etotal_data, dlim=E_dlim, lim=E_lim
    get_data, 'erg_pwe_wfc_l2_b_65khz_B_spectra', data = Btotal_data, dlim=B_dlim, lim=B_lim

    duct_time_double1 = time_double('2017-07-03/04:32:30')
    duct_time_double2 = time_double('2017-07-03/04:32:34')
    time_res =  Etotal_data.x[100]- Etotal_data.x[99]
    idx_t1 = where( Etotal_data.x lt duct_time_double1+time_res/2 and Etotal_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( Etotal_data.x lt duct_time_double2+time_res/2 and Etotal_data.x gt duct_time_double2-time_res/2, cnt )
    Etotal_nr = fltarr(n_elements(Etotal_data.y[idx_t1:idx_t2, 0]), n_elements(Etotal_data.y[idx_t1, *]))
    for i=0,n_elements(Etotal_data.y[idx_t1:idx_t2, 0])-1 do Etotal_nr[i,*] = Etotal_data.y[idx_t1+i,*] / Epdata
    store_data, 'Etotal_nr', data = {x:Etotal_data.x[idx_t1:idx_t2], y:Etotal_nr, v:Etotal_data.v}, dlim=E_dlim, lim=E_lim
    zlim, 'Etotal_nr', 1., 1e5, 1

    time_res =  Btotal_data.x[100]- Btotal_data.x[99]
    idx_t1_ = where( Btotal_data.x lt duct_time_double1+time_res/2 and Btotal_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2_ = where( Btotal_data.x lt duct_time_double2+time_res/2 and Btotal_data.x gt duct_time_double2-time_res/2, cnt )
    Btotal_nr = fltarr(n_elements(Btotal_data.y[idx_t1_:idx_t2_, 0]), n_elements(Btotal_data.y[idx_t1_, *]))
    for i=0,n_elements(Btotal_data.y[idx_t1_:idx_t2_, 0])-1 do Btotal_nr[i,*] = Btotal_data.y[idx_t1_+i,*] / Bpdata
    store_data, 'Btotal_nr', data = {x:Btotal_data.x[idx_t1_:idx_t2_], y:Btotal_nr, v:Btotal_data.v}, dlim=B_dlim, lim=B_lim
    zlim, 'Btotal_nr', 1., 1e5, 1

    ylim, ['Etotal_nr', 'Btotal_nr'], 32, 20000.0, 1
    tplot, ['Etotal_nr', 'Btotal_nr']

    ; stop

    duct_time_double3 = time_double('2017-07-03/04:32:32')

    time_res =  Etotal_data.x[100]- Etotal_data.x[99]
    idx_t3 = where( Etotal_data.x[idx_t1:idx_t2] lt duct_time_double3+time_res/2 and Etotal_data.x[idx_t1:idx_t2] gt duct_time_double3-time_res/2, cnt )
    idx_t3 += 8

    plot, Etotal_data.v, total(Etotal_nr[idx_t3-10:idx_t3+10, *],1)/21., xrange=[4000,10000], xtitle='f[Hz]', ytitle='E S/N', yrange=[0,1e8]


    time_res =  Btotal_data.x[100]- Btotal_data.x[99]
    idx_t3_ = where( Btotal_data.x[idx_t1_:idx_t2_] lt duct_time_double3+time_res/2 and Btotal_data.x[idx_t1_:idx_t2_] gt duct_time_double3-time_res/2, cnt )
    idx_t3_ += 8

    plot, Btotal_data.v, total(Btotal_nr[idx_t3-10:idx_t3+10, *],1)/21., xrange=[4000,10000], xtitle='f[Hz]', ytitle='B S/N'

    stop



end