pro calc_Ne, UHR_file_name=UHR_file_name

    ; ************************************
    ; load f_uhr and calc Ne
    ; make tplot 'f_UHR', 'f_UHR_interp', 'Ne'
    ; ************************************

    uname = 'erg_project'
    pass = 'geospace'

    ; ************************************
    ; 1.load data
    ; ************************************

    get_data, 'erg_mgf_l2_magt_8sec', data=magt

    if (size(magt))[0] eq 0 then begin
        erg_load_mgf, datatype='8sec', uname=uname, pass=pass
        get_data, 'erg_mgf_l2_magt_8sec', data=magt
    endif

    tplot_restore, file=[UHR_file_name]
    tinterpol_mxn, 'f_UHR', 'erg_mgf_l2_magt_8sec'
    options, 'f_UHR_interp', linestyles=0
    get_data, 'f_UHR_interp', data=f_UHR

    ; ************************************
    ; 2.calc. Ne
    ; ************************************

    f_ce = magt.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi ; in Hz ,DはDOUBLEのD
    f_pe = sqrt( (f_UHR.y*10^(3.))^2. - f_ce^2. ) ; Hz
    Ne_ = (f_pe * 2 * !pi)^2 * (9.1093D * 10^(-31.)) * (8.854D * 10^(-12.)) /  (1.602D * 10^(-19.))^2 / 10^(6.) ;cm-3

    store_data, 'Ne', data={x:magt.x, y:Ne_} ;, v:s00.v2}
    ylim, 'Ne', 10.0, 1000.0, 1

end