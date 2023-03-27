
; compile
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/f_ne_f_b_plot.pro'

function loading_f_ne_f_b_plot

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

function loading_f_ne_f_b_plot2, duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, IorD=IorD, lsm=lsm, number=number

    ; ******************************
    ; 1.1.get data
    ; ******************************

    ; get fce_ave
    get_data, 'fce', data=fce_data

    duct_time_double = time_double(duct_time)
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )

    fce_ave = fce_data.y[idx_t[0]] ;kHz 


    ; calc Ne_0 and Ne_1 from fce_ave
    plot_f = dindgen(500, increment=0.01, start=focus_f[0])
    kpara_linear = lsm[0] * plot_f + lsm[1]
    Ne_0 = fltarr(n_elements(plot_f))
    Ne_1 = fltarr(n_elements(plot_f))

    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    for i=0, n_elements( plot_f )-1 do Ne_0[i] = b1 * kpara_linear[i]^2 * (fce_ave / plot_f[i] - 1 ) / 10^(6.) ;cm-3
    for i=0, n_elements( plot_f )-1 do Ne_1[i] = b1 * kpara_linear[i]^2 * (fce_ave / (2*plot_f[i]))^2 / 10^(6.) ;cm-3

    ; ******************************
    ; 1.2.get data
    ; ******************************

    
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data = B_data


    time_res =  B_data.x[10]- B_data.x[9]
    idx_t = where( B_data.x lt duct_time_double+time_res/2 and B_data.x gt duct_time_double-time_res/2, cnt )

    B_obs = mean(B_data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n, *], DIMENSION=1, /nan) ; obs.y

    tinterpol_mxn, 'fce_TS04_half', 'erg_pwe_ofa_l2_matrix_Btotal_132'

    get_data, 'fce_TS04_half_interp', data=eqfce_data


    time_res =  eqfce_data.x[100]- eqfce_data.x[99]
    idx_t = where( eqfce_data.x lt duct_time_double+time_res/2 and eqfce_data.x gt duct_time_double-time_res/2, cnt )
    eqfce_duct = eqfce_data.y[idx_t]
    eqfce_duct = eqfce_duct[0] ; kHz


    ; ; ******************************
    ; ; 2.set color translation tables
    ; ; ******************************

    ; ; tvlct, 231,238,247,10
    ; if IorD eq 'D' then tvlct, 219,224,231,10
    ; if IorD eq 'I' then tvlct, 242,220,218,10


    ; ******************************
    ; 3.set plot range
    ; ******************************

    ; xmin = min(plot_f)
    ; xmax = max(plot_f)
    ; ymin1 = min([Ne_0,Ne_1])-5
    ; ymax1 = max([Ne_0,Ne_1])+5
    ; ymin2 = min(B_obs)
    ; ymax2 = max(B_obs)

    ; Ne_min = 280
    ; Ne_max = 299
    ; xmin = 1.
    ; xmax = 4.

    File_path = '/Users/ampuku/Documents/duct/code/python/for_paper_figure/f_Ne_f_B_data'+STRING(number, FORMAT='(i0)')+'/'
    WRITE_CSV, File_path+'plotf_Ne0_Ne1_data.csv', plot_f, Ne_0, Ne_1
    WRITE_CSV, File_path+'Bv_Bobs_data.csv', B_data.v, B_obs
    WRITE_CSV, File_path+'eqfce_data.csv', eqfce_duct

end


function loading_f_ne_f_b_plot_wfc

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

    calc_kpara, cut_f=cut_f


    ; ******************************
    ; 2.2.calc. equatorial fce
    ; ******************************

    ; for f_B plot in plot_f_Ne0_f_B 
    calc_equatorial_fce


end

function loading_f_ne_f_b_plot2_wfc, duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, IorD=IorD, lsm=lsm, number=number

    ; ******************************
    ; 1.1.get data
    ; ******************************

    ; get fce_ave
    get_data, 'fce', data=fce_data

    duct_time_double = time_double(duct_time)
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )

    fce_ave = fce_data.y[idx_t[0]] ;kHz 


    ; calc Ne_0 and Ne_1 from fce_ave
    plot_f = dindgen(500, increment=0.01, start=focus_f[0])
    kpara_linear = lsm[0] * plot_f + lsm[1]
    Ne_0 = fltarr(n_elements(plot_f))
    Ne_1 = fltarr(n_elements(plot_f))

    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    for i=0, n_elements( plot_f )-1 do Ne_0[i] = b1 * kpara_linear[i]^2 * (fce_ave / plot_f[i] - 1 ) / 10^(6.) ;cm-3
    for i=0, n_elements( plot_f )-1 do Ne_1[i] = b1 * kpara_linear[i]^2 * (fce_ave / (2*plot_f[i]))^2 / 10^(6.) ;cm-3

    ; ******************************
    ; 1.2.get data
    ; ******************************

    get_data, 'bspec', data = B_data

    duct_time1 = '2017-07-03/04:32:30'
    duct_time2 = '2017-07-03/04:32:35'

    duct_time_double1 = time_double(duct_time1)
    duct_time_double2 = time_double(duct_time2)
    time_res =  B_data.x[100]- B_data.x[99]
    idx_t1 = where( B_data.x lt duct_time_double1+time_res/2 and B_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( B_data.x lt duct_time_double2+time_res/2 and B_data.x gt duct_time_double2-time_res/2, cnt )

    B_obs = mean(B_data.y[idx_t1:idx_t2, *], DIMENSION=1, /nan) ; obs.y

    tinterpol_mxn, 'fce_TS04_half', 'bspec'

    get_data, 'fce_TS04_half_interp', data=eqfce_data


    time_res =  eqfce_data.x[100]- eqfce_data.x[99]
    idx_t = where( eqfce_data.x lt duct_time_double+time_res/2 and eqfce_data.x gt duct_time_double-time_res/2, cnt )
    eqfce_duct = eqfce_data.y[idx_t]
    eqfce_duct = eqfce_duct[0] ; kHz

    File_path = '/Users/ampuku/Documents/duct/code/python/for_paper_figure/f_Ne_f_B_data'+STRING(number, FORMAT='(i0)')+'/'
    WRITE_CSV, File_path+'plotf_Ne0_Ne1_data.csv', plot_f, Ne_0, Ne_1
    WRITE_CSV, File_path+'Bv_Bobs_data.csv', B_data.v/1000., B_obs
    WRITE_CSV, File_path+'eqfce_data.csv', eqfce_duct

end




pro f_ne_f_b_plot


    ; SET_PLOT, 'Z'
    ; DEVICE, SET_RESOLUTION = [600,1200]
    ; !p.BACKGROUND = 255
    ; !p.color = 0
    ; ; !P.FONT = 0
    ; !p.charsize=1.0


    timespan, '2018-06-06/11:25:00', 20, /min

    duct_time='2018-06-06/11:29:40' & focus_f=[1., 2., 3., 4.] & duct_wid_data_n=3 & IorD='I' & lsm=[0.00037135126, 0.00056528556]
    a = loading_f_ne_f_b_plot()
    ; 以下plot_f_Ne0_f_Bの中身
    a = loading_f_ne_f_b_plot2(duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, IorD=IorD, lsm=lsm,  number=1)

    stop   

    duct_time='2018-06-06/11:32:29' & focus_f=[3., 4., 5., 6., 7.] & duct_wid_data_n=3 & IorD='D' & lsm=[0.0003555313670662758, 0.00036820383445613147]
    a = loading_f_ne_f_b_plot2(duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, IorD=IorD, lsm=lsm,  number=2)

    stop

    timespan, '2017-07-14/02:40:00', 20.0, /minute

    duct_time='2017-07-14/02:52:17' & focus_f=[1.,2.,3.,4.,5.] & duct_wid_data_n=10 & IorD='D' & lsm=[0.00021773415,-0.00012809447]
    a = loading_f_ne_f_b_plot()
    a = loading_f_ne_f_b_plot2(duct_time=duct_time, focus_f=focus_f, duct_wid_data_n=duct_wid_data_n, IorD=IorD, lsm=lsm,  number=3)

    stop

    timespan, '2017-07-03/04:32:00', 1, /min

    ; calc_kpara_wfc

    duct_time1 = '2017-07-03/04:32:30'
    duct_time2 = '2017-07-03/04:32:35'
    duct_time='2017-07-03/04:32:32' & focus_f=[4., 5., 6., 7., 8., 9.] & IorD='D'
    ; lsm=[0.00039838069116176393, 0.0001354145537163298] ; 全体を直線で近似するとこうなる
    ; lsm = [0.0003870881139733962, 0.00021967210167693631]
    ; lsm=[0.0003880460722666711, 0.00021286074114011458] ; 全体を直線で近似するとこうなる
    lsm=[0.0004362278143921447, -0.0001565701415621355] ; Upper-bandにフォーカスするとこうなる
    ; lsm=[0.0003793070494856606, 0.0002664968416327885] ; Lower-bandにフォーカス
    ; calc__f_kpara_wfc, focus_f=focus_f, duct_time_=duct_time, duct_time1=duct_time1, duct_time2=duct_time2, lsm=lsm, data__f_kpara=data__f_kpara
    ; plot_f_kpara_wfc, focus_f=focus_f, duct_time=duct_time, test=0, lsm=lsm, data__f_kpara=data__f_kpara

    a = loading_f_ne_f_b_plot()
    a = loading_f_ne_f_b_plot2_wfc(duct_time=duct_time, focus_f=focus_f, IorD=IorD, lsm=lsm,  number=42)


    ; lsm=[0.0003793070494856606, 0.0002664968416327885] ; Lower-bandにフォーカス
    ; a = loading_f_ne_f_b_plot2_wfc(duct_time=duct_time, focus_f=focus_f, IorD=IorD, lsm=lsm,  number=41)

    ; ; ちょっとしたの方の周波数帯も見てみた
    ; duct_time='2017-07-03/04:32:32' & focus_f=[0., 1., 2., 3., 4., 5., 6., 7., 8., 9.] & IorD='D'
    ; a = loading_f_ne_f_b_plot2_wfc(duct_time=duct_time, focus_f=focus_f, IorD=IorD, lsm=lsm,  number=43)


    stop

end



; set_plot, 'X'
; window, 0, xsize=1000, ysize=600
; !p.background = 255
; !p.color = 0
