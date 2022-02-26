pro calc_equatorial_fce, plot_flag=plot_flag

    if not keyword_set(plot_flag) then plot_flag=0

    ; *****************
    ; calculate equatorial fce
    ; *****************

    uname = 'erg_project'
    pass = 'geospace'

    ; *****************
    ; 1.
    ; *****************

    ; 磁場モデルの磁力線に沿ってトレースした磁気赤道面でのfc/2を計算
    erg_load_orb_l3, model='ts04' ; TS04モデル ##erg_orb_l3_pos_blocal_TS04##
    get_data, 'erg_orb_l3_pos_beq_TS04', data=B_TS04
    fce_TS04 = B_TS04.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.
    store_data, 'fce_TS04', data={x:B_TS04.x, y:fce_TS04}
    store_data, 'fce_TS04_half', data={x:B_TS04.x, y:fce_TS04/2.}

    erg_load_orb_l3, model='t89' ; T89モデル
    get_data, 'erg_orb_l3_pos_beq_t89', data=B_T89
    fce_T89 = B_T89.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.
    store_data, 'fce_T89', data={x:B_T89.x, y:fce_T89}
    store_data, 'fce_T89_half', data={x:B_T89.x, y:fce_T89/2.}

    get_data, 'erg_mgf_l2_igrf_8sec_dsi', data=B_IGRF_dsi ; IGRFモデル
    if (size(B_IGRF_dsi))[0] eq 0 then begin
        erg_load_mgf
        get_data, 'erg_mgf_l2_igrf_8sec_dsi', data=B_IGRF_dsi ; IGRFモデル
    endif
    B_IGRF = sqrt(total(B_IGRF_dsi.y^2, 2))
    fce_IGRF = B_IGRF / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.
    store_data, 'fce_IGRF', data={x:B_IGRF_dsi.x, y:fce_IGRF}
    store_data, 'fce_IGRF_half', data={x:B_IGRF_dsi.x, y:fce_IGRF/2.}

    ; color: 0黒 1ピンク 2青 3シアン 4黄緑 5黄色 6赤 7以降黒
    ; linestyle: 0棒線 1破線(細) 2破線(長) 3破線(細＆長) 4破線(細*3＆長) 5以降破線(長)

    options, 'fce_TS04',      colors=1, thick=2, linestyle=0
    options, 'fce_TS04_half', colors=1, thick=2, linestyle=2
    options, 'fce_T89',       colors=6, thick=2, linestyle=0
    options, 'fce_T89_half',  colors=6, thick=2, linestyle=2
    options, 'fce_IGRF',      colors=4, thick=2, linestyle=0
    options, 'fce_IGRF_half', colors=4, thick=2, linestyle=2

    ; イベントプロットしてみる
    get_data, 'erg_pwe_hfa_l2_high_spectra_e_mix', data=data
    if (size(data))[0] eq 0 then erg_load_pwe_hfa, level='l2', mode=['h'], uname=uname, pass=pass
    store_data, 'hfa_e_Bmodels', data=['erg_pwe_hfa_l2_high_spectra_e_mix', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']
    
    get_data, 'erg_pwe_ofa_l2_spec_E_spectra_132', data=data
    if (size(data))[0] eq 0 then erg_load_pwe_ofa, uname=uname, pass=pass
    store_data, 'ofa_e_Bmodels', data=['erg_pwe_ofa_l2_spec_E_spectra_132', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']
    store_data, 'ofa_b_Bmodels', data=['erg_pwe_ofa_l2_spec_B_spectra_132', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']

    ylim,  'hfa_e_Bmodels', 10.0, 400.0, 1
    ylim,  'ofa_e_Bmodels', 1.0, 20.0, 1
    ylim,  'ofa_b_Bmodels', 1.0, 20.0, 1

    if plot_flag then begin
        SET_PLOT, 'X'
        !p.BACKGROUND = 255
        !p.COLOR = 0
        window, 0, xsize=1000, ysize=750
        time_stamp, /off
        tplot, ['hfa_e_Bmodels', 'ofa_e_Bmodels', 'ofa_b_Bmodels']
    endif

end