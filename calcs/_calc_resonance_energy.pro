pro calc_resonance_energy

    ; *****************
    ; calc resonance energy
    ; *****************

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

    f = [1., 2., 3., 4. ,5., 6. ,7.] ;kHz
    myu0 = 1.257e-6 ;m kg s-2 A-2

    ; *****************
    ; 2.calc.
    ; *****************

    names = 'resonance_energy_f' + string(f, FORMAT='(i0)')

    for i = 0, n_elements(f)-1 do begin
        ER = (magt.y)^2 / (2*myu0*Nedata.y) * fce.y / f[i]
        

        ;  ここまで_(┐「ε:)_
        ; ERがあってるか確認が必要！！
        ; 2DのMEPeプロットに1DのERをどう重ねるか？？

        ; color: 0黒 1ピンク 2青 3シアン 4黄緑 5黄色 6赤 7以降黒
        ; linestyle: 0棒線 1破線(細) 2破線(長) 3破線(細＆長) 4破線(細*3＆長) 5以降破線(長)

        store_data, names[i], data={x:magt.x, y:ER}
        options, names[i], colors=i+1, thick=2, linestyle=0
    endfor

    calc_mepe

    store_names = strarr(n_elements(f)+1)
    store_names[1:-1] = names

    store_names[0] = 'mepe_PA_0-3'
    store_data, 'mepe_PA_0-3_re', data=store_names
    store_names[0] = 'mepe_PA_177-188'
    store_data, 'mepe_PA_177-188_re', data=store_names
    store_names[0] = 'mepe_PA_3-37'
    store_data, 'mepe_PA_3-37_re', data=store_names

    stop

end