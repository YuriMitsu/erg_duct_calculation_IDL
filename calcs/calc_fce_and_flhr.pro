pro calc_fce_and_flhr

    ; *****************
    ; calculate fce and flhr
    ; *****************

    uname = 'erg_project'
    pass = 'geospace'

    ; *****************
    ; 1.load data
    ; *****************

    ;磁場読み込み
    erg_load_mgf, datatype='8sec', uname=uname, pass=pass

    get_data, 'erg_mgf_l2_magt_8sec', data=data

    if (size(data))[0] eq 0 then begin
        erg_load_mgf
        get_data, 'erg_mgf_l2_magt_8sec', data=data
    endif

    ; *****************
    ; 2.calc. fce and flhr
    ; *****************

    fce = data.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.  ; local electron gyro freq
    fcp = data.y / 10^(9.) * 1.6 * 10^(-19.) / (1.6726D * 10^(-27.)) / 2. / !pi / 1000.  ; proton gyro freq
    flhr = sqrt(fce * fcp)                                                                  ; lower hybrid frequency
    fce_half = fce / 2.
    store_data, 'fce', data={x:data.x, y:fce}
    store_data, 'fce_half', data={x:data.x, y:fce_half}
    options, 'fce', colors=5, thick=2                   ; 5=yellow
    options, 'fce_half', colors=1, thick=2              ; 1=purple

    store_data, 'flhr', data={x:data.x, y:flhr}         ; *** added ***
    options, 'flhr', colors=0, thick=2, linestyle=2     ; 0=black / 2=broken line

end