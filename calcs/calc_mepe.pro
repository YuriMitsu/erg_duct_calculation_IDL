pro calc_mepe

    ; *****************
    ; plot event for meeting
    ; *****************

    ; .compile -v 'calc_mepe.pro'
    ; calc_mepe

    uname = 'erg_project'
    pass = 'geospace'

    ; ************************************
    ; 1.load data
    ; ************************************

    get_data, 'erg_orb_l2_pos_gse', data=data
    if (size(data))[0] eq 0 then begin
        erg_load_orb
    endif

    
    get_data, 'erg_mgf_l2_mag_8sec_dsi', data=data
    if (size(data))[0] eq 0 then begin
        erg_load_mgf, datatype='8sec', uname=uname, pass=pass
    endif


    ; ************************************
    ; 16.1.mepe PA
    ; ************************************

    yrange = [7., 90.]

    erg_load_mepe,uname='erg_project', pass='geospace',datatype='3dflux'
    ; 特定の値のenergyを測っている。plotで決めた範囲内に観測しているエネルギー値がなければtplot変数にデータが入らない？
    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[0.,3.], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
    store_data, 'mepe_PA_0-3', /delete
    get_data, 'erg_mepe_l2_3dflux_FEDU_energy', data=data
    store_data, 'mepe_PA_0-3', data={x:data.x, y:data.y, v:data.v/1000.} ;eV->keV
    options, 'mepe_PA_0-3', spec=1
    ylim, 'mepe_PA_0-3', yrange[0], yrange[1], 1

    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[177.,188.], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
    store_data, 'mepe_PA_177-188', /delete
    get_data, 'erg_mepe_l2_3dflux_FEDU_energy', data=data
    store_data, 'mepe_PA_177-188', data={x:data.x, y:data.y, v:data.v/1000.} ;eV->keV
    options, 'mepe_PA_177-188', spec=1
    ylim, 'mepe_PA_177-188', yrange[0], yrange[1], 1

    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[3.,37.5], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
    store_data, 'mepe_PA_3-37', /delete
    get_data, 'erg_mepe_l2_3dflux_FEDU_energy', data=data
    store_data, 'mepe_PA_3-37', data={x:data.x, y:data.y, v:data.v/1000.} ;eV->keV
    options, 'mepe_PA_3-37', spec=1
    ylim, 'mepe_PA_3-37', yrange[0], yrange[1], 1


    ; ************************************
    ; 16.2.mepe ET
    ; ************************************
    erg_load_mepe,level='l2',datatype='omniflux'
    ; 'erg_mepe_l2_omniflux_FEDO'を取得
    store_data, 'mepe_ET', /delete
    store_data, 'erg_mepe_l2_omniflux_FEDO', newname='mepe_ET'


end