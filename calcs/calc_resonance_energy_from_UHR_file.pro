pro calc_resonance_energy_from_UHR_file, UHR_file_name=UHR_file_name

    ; *****************
    ; calc resonance energy
    ; *****************

    ; .compile -v 'calc_resonance_energy_from_UHR_file.pro'
    ; calc_resonance_energy_from_UHR_file, UHR_file_name='UHR_tplots/f_UHR_2018-07-10/052500-054500.tplot'
    ; 注意　：　l85あたりcalc_mepeは時間ごとに同じで計算に時間がかかる。ここを適宜コメントアウトすると、fの数値を変えて回しやすい！！

    uname = 'erg_project'
    pass = 'geospace'

    ; *****************
    ; 1.load 
    ; *****************

    ; Neデータが他の時間に存在していると、それを取ってきて (size(fce))[0] = 1 になることがある気がする...
    ; どうすればうまく回避できる？？思いつかないので、ひとまず全部計算させることに。時間もそんなかかんないはず。

    ; get_data, 'erg_mgf_l2_magt_8sec', data=magt
    ; if (size(magt))[0] eq 0 then begin
        erg_load_mgf, datatype='8sec', uname=uname, pass=pass
        get_data, 'erg_mgf_l2_magt_8sec', data=magt
    ; endif

    ; get_data, 'Ne', data=Nedata
    ; if (size(Nedata))[0] eq 0 then begin
        calc_ne, UHR_file_name=UHR_file_name
    ; endif
    ; tinterpol_mxn, 'Ne', 'erg_mgf_l2_magt_8sec'
    ; get_data, 'Ne_interp', data=Nedata
    get_data, 'Ne', data=Nedata

    ; get_data, 'fce', data=data
    ; if (size(data))[0] eq 0 then begin
        calc_fce_and_flhr
    ; endif
    tinterpol_mxn, 'fce', 'erg_mgf_l2_magt_8sec'
    get_data, 'fce_interp', data=fcedata

    myu0 = 1.257e-6 ; m kg s-2 A-2

    ; *****************
    ; 2.calc.
    ; *****************

    f = [0.5, 1.0, 1.5, 2.0, 2.5]
    ; rate = [0.3, 0.5, 0.8]
    names = 'resonance_energy_f' + string(f, FORMAT='(f0.1)')
    ; names = 'resonance_energy_f' + string(rate, FORMAT='(f0.1)')

    for i = 0, n_elements(f)-1 do begin

        ER = (magt.y)^2 / (2*myu0*Nedata.y) * fcedata.y / f[i] * ( 1 - f[i] / fcedata.y )^3 / 1.602 * 1e-8 ; keV
        ; ER = (magt.y)^2 / (2*myu0*Nedata.y) / rate[i] * ( 1 - rate[i] )^3 / 1.602 * 1e-8 ; keV
        ; 左辺 : 1[eV] = 1.602e-19[J] = 1.602e-19[kg m2 s-2]
        ; 右辺 : [nT]^2 / ([m kg s-2 A-2]*[cm-3])
        ;    = e-(9*2) * [kg A−1 s−2]*2 / ([m kg s-2 A-2]*1e-(2*-3)*[m-3])
        ;    = e(-9*2-2*3) * [kg(2-1) A(−2+2) s(−4+2) m(-1+3)]
        ;    = e-24 * [kg s−2 m2]
        ;    = e-24 * 1/1.602e-19 [eV]
        ;    = 1 / 1.602 * 1e-5 [eV]
        ;    = 1 / 1.602 * 1e-8 [keV]

        ; color: 0黒 1ピンク 2青 3シアン 4黄緑 5黄色 6赤 7以降黒
        ; linestyle: 0棒線 1破線(細) 2破線(長) 3破線(細＆長) 4破線(細*3＆長) 5以降破線(長)

        get_data, 'f_UHR', data=data

        mask1 = ( magt.x lt data.x[0] )
        idx1 = UINT( TOTAL(mask1) )
        ER[0:idx1-1] = !VALUES.F_NAN

        mask2 = ( magt.x lt data.x[-1] )
        idx2 = UINT( TOTAL(mask2) )
        ER[idx2:-1] = !VALUES.F_NAN


        store_data, names[i], data={x:magt.x, y:ER}
        options, names[i], colors=1, thick=2, linestyle=0
        options, names[i], labels=string(f[i], FORMAT='(f0.1)')+'kHz'
        ylim, names[i], 7., 90., 1

    endfor

    options, names[UINT(n_elements(names)/2)], colors=6, thick=2, linestyle=0
    options, names, 'labflag', 2

    calc_mepe

    ; data_names = strarr(n_elements([f])+1) ;strarr(n_elements(f)+1)
    ; data_names[0] = 'mepe_PA_0-3'
    ; data_names[1:-1] = names ;store_name[1:-1] = names

    store_names=['mepe_PA_0-3', 'resonance_energy_f0.5', 'resonance_energy_f1.0', 'resonance_energy_f1.5', 'resonance_energy_f2.0', 'resonance_energy_f2.5']
    ; store_names=['mepe_PA_0-3', 'resonance_energy_f0.3', 'resonance_energy_f0.5', 'resonance_energy_f0.8']

    store_data, 'mepe_PA_0-3_re', data=store_names
    ylim, 'mepe_PA_0-3_re', 7., 90., 1


    store_names[0] = 'mepe_PA_177-188'
    store_data, 'mepe_PA_177-188_re', data=store_names
    ylim, 'mepe_PA_177-188_re', 7., 90., 1


    store_names[0] = 'mepe_PA_3-37'
    store_data, 'mepe_PA_3-37_re', data=store_names
    ylim, 'mepe_PA_3-37_re', 7., 90., 1

    ;  ここまで_(┐「ε:)_
    ; ERのもと論文との違い、理由を吹澤さんに聞きたい！！

end