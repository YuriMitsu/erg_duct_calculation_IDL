pro calc_resonance_energy_from_UHR_file, UHR_file_name=UHR_file_name

    ; *****************
    ; calc resonance energy
    ; *****************

    ; .compile -v 'calc_resonance_energy_from_UHR_file.pro'
    ; calc_resonance_energy_from_UHR_file, UHR_file_name='UHR_tplots/f_UHR_2018-06-06/112500.tplot'

    uname = 'erg_project'
    pass = 'geospace'

    ; *****************
    ; 1.load 
    ; *****************


    get_data, 'fce', data=fce
    if (size(fce))[0] eq 0 then begin
        calc_fce_and_flhr
        get_data, 'fce', data=fce
    endif

    get_data, 'erg_mgf_l2_magt_8sec', data=magt
    if (size(magt))[0] eq 0 then begin
        erg_load_mgf, datatype='8sec', uname=uname, pass=pass
        get_data, 'erg_mgf_l2_magt_8sec', data=magt
    endif

    get_data, 'Ne', data=Nedata
    if (size(Nedata))[0] eq 0 then begin
        calc_ne, UHR_file_name=UHR_file_name
    endif
    tinterpol_mxn, 'Ne', 'erg_mgf_l2_magt_8sec'
    get_data, 'Ne_interp', data=Nedata

    myu0 = 1.257e-6 ; m kg s-2 A-2

    ; *****************
    ; 2.calc.
    ; *****************

    rate = [0.3, 0.5, 0.8]
    names = 'resonance_energy_f' + string(rate, FORMAT='(f0.1)')

    for i = 0, n_elements(rate)-1 do begin

        ;  ここまで_(┐「ε:)_
        ;次数が合わない...
        ER = (magt.y)^2 / (2*myu0*Nedata.y) * rate[i] * ( 1 - rate[i] )^3 * 1e4 / 1e3 ; keV
        ; ER = (magt.y)^2 / (2*myu0*Nedata.y) * rate[i] * ( 1 - rate[i] )^3 * 1e18 / 1e3 ; keV
        ; ER = (magt.y)^2 / (2*myu0*Nedata.y) * fce.y / fce.y*rate[i] * ( 1 - fce.y*rate[i] / fce.y )^3
        ; [kg m2 s-2]
        ;    => [nT]^2 / ([m kg s-2 A-2]*[m-3])
        ;    = e-18 * [kg A−1 s−2]^2 / ([m kg s-2 A-2]*[m-3])
        ;    = e-18 * [kg2 A−2 s−4 m-1 kg-1 s2 A2 m3]
        ;    = e-18 * [kg s−2 m2]
        ; [s-1 A-1]どこ？？

        ; color: 0黒 1ピンク 2青 3シアン 4黄緑 5黄色 6赤 7以降黒
        ; linestyle: 0棒線 1破線(細) 2破線(長) 3破線(細＆長) 4破線(細*3＆長) 5以降破線(長)

        store_data, names[i], data={x:magt.x, y:ER}
        options, names[i], colors=i+1, thick=2, linestyle=0

    endfor

    ; calc_mepe

    stop

    ; data_names = strarr(n_elements([f])+1) ;strarr(n_elements(f)+1)
    ; data_names[0] = 'mepe_PA_0-3'
    ; data_names[1:-1] = names ;store_name[1:-1] = names

    store_names=['mepe_PA_0-3', 'resonance_energy_f0.3', 'resonance_energy_f0.5', 'resonance_energy_f0.8']

    store_data, 'mepe_PA_0-3_re', data=store_names
    ylim, 'mepe_PA_0-3_re', 7., 90., 1


    store_names[0] = 'mepe_PA_177-188'
    store_data, 'mepe_PA_177-188_re', data=store_names
    ylim, 'mepe_PA_177-188_re', 7., 90., 1


    store_names[0] = 'mepe_PA_3-37'
    store_data, 'mepe_PA_3-37_re', data=store_names
    ylim, 'mepe_PA_3-37_re', 7., 90., 1

    stop

    ; ERのもと論文との違い、理由を吹澤さんに聞きたい！！

end