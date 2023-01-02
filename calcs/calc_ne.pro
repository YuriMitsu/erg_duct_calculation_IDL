; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_Ne.pro'

pro calc_Ne, UHR_file_name=UHR_file_name, wfc=wfc

    if not keyword_set(wfc) then wfc=0
    

    ; ************************************
    ; load fuhr and calc Ne
    ; make tplot 'fUHR', 'fUHR_interp', 'Ne', 'fpe'
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


    if UHR_file_name eq 'kuma' then begin
        load_fufp_txt, /high
        get_data, 'hfa_l3_fuh', data = data
        store_data, 'fUHR', data={x:data.x, y:data.y}
    endif else begin
        tplot_restore, file=[UHR_file_name]
    endelse

    if not wfc then begin
        tinterpol_mxn, 'fUHR', 'erg_mgf_l2_magt_8sec'
        ; options, 'fUHR_interp', linestyles=0
        ; get_data, 'fUHR_interp', data=f_UHR



        get_data, 'fUHR', data=data
        get_data, 'fUHR_interp', data=data_interp

        mask1 = ( data_interp.x lt data.x[0] )
        idx1 = UINT( TOTAL(mask1) )
        data_interp.y[0:idx1-1] = !VALUES.F_NAN

        mask2 = ( data_interp.x lt data.x[-1] )
        idx2 = UINT( TOTAL(mask2) )
        data_interp.y[idx2:-1] = !VALUES.F_NAN

    endif else begin

        tinterpol_mxn, 'erg_mgf_l2_magt_8sec', 'bspec'
        get_data, 'erg_mgf_l2_magt_8sec_interp', data=magt

        tinterpol_mxn, 'fUHR', 'bspec'

        get_data, 'fUHR_interp', data=data_interp

    endelse

    store_data, 'fUHR_interp_nan', data={x:data_interp.x, y:data_interp.y}
    options, 'fUHR_interp_nan', linestyles=0
    get_data, 'fUHR_interp_nan', data=f_UHR


    ; ************************************
    ; 2.calc. Ne
    ; ************************************

    f_ce = magt.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi ; in Hz ,DはDOUBLEのD
    f_pe = sqrt( (f_UHR.y*10^(3.))^2. - f_ce^2. ) ; Hz
    Ne_ = (f_pe * 2 * !pi)^2 * (9.1093D * 10^(-31.)) * (8.854D * 10^(-12.)) /  (1.602D * 10^(-19.))^2 / 10^(6.) ;cm-3

    store_data, 'fpe', data={x:magt.x, y:f_pe}
    ; ylim, 'fpe', 10.0, 1000.0, 1

    store_data, 'Ne', data={x:magt.x, y:Ne_}
    ylim, 'Ne', 10.0, 1000.0, 1

end