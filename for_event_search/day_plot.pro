pro day_plot, span=span, hour_plot=hour_plot


  ;--------------------------------------------------------------------
  ; HFAの電場スペクトル、OFAの電場スペクトル、OFA-Bから計算した磁場スペクトル、伝搬角、円偏波のPLOT
  ;
  ; 使用方法
  ; IDL> erg_init
  ; ERG> timespan, '2018-06-02'
  ; ERG> day_plot_20220112, span=1 ; 横軸１時間のPLOTを24枚作成し、erg\erg_ofa_matrix\erg_ofa_matrix_YYYYMMDD_HH.pngに保存
  ;
  ;--------------------------------------------------------------------

  ; default plot span [hour] (整数値を指定する。24の約数であること。)
  if not keyword_set(span) then span=1 ; [hour]
  if not keyword_set(hour_plot) then hour_plot=0

  STOKES_ON = 0
  calPA_on = 0 ;未完成
  hourplot_on = 1


  uname = 'erg_project'
  pass = 'geospace'


  ; *****************
  ; 1.set time span
  ; *****************
  ;  timespan, '2018-06-02', 1, /day

  ; *****************
  ; 2.load orbit CDF & set var label
  ; *****************
  set_erg_var_label

  ; *** added ***
  ; *****************
  ; 3.load HFA
  ; *****************
  erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
  pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified

  ; *****************
  ; 3.calc. wave params
  ; *****************

  calc_wave_params, moving_average=1, algebraic_SVD=1

  ; ************************************
  ; *.WNA, polarization and planarity with LA SVD と Algebraic SVD? の比較
  ; ************************************

  window, 0, xsize=1000, ysize=750
  tplot, ['kvec_LASVD', 'kvec_algebraic', 'polarization_LASVD', 'polarization_algebraic', 'planarity_LASVD']
  ; tplot, ['erg_pwe_ofa_l2_spec_B_spectra_132', 'powspec_b']

  stop

  ; ************************************
  ; 13.stokes parameter
  ; ************************************

  ; calc_stokes_params

  ; ************************************
  ; 14.mask
  ; ************************************
  
  get_data, pr_matrix + 'Btotal_132', data=data_ref; *** modified (B_total_132 -> Btotal_132)
  cut_f = 1E-2
  ; kvec
  get_data, 'kvec_LASVD', data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'kvec_LASVD_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
  ; polarization
  get_data, 'polarization_LASVD', data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'polarization_LASVD_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

  ; planarity
  get_data, 'planarity_LASVD', data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'planarity_LASVD_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


  if stokes_on eq 1 then begin
    get_data, pr_matrix + 'Etotal_132', data=data_refE; *** modified (E_total_132 -> Etotal_132)
    cut_fE = 1E-8

    get_data, 'st_I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_Q/I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_Q/I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_U/I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_U/I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_V/I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_V/I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_chi', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_f)] = 'NaN'
    store_data, 'st_chi_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ;  tplot, [pr_matrix + 'Bx_Bx_re', pr_matrix + 'By_By_re', pr_matrix + 'Bz_Bz_re', $
    ;    'kvec_mask', 'polarization_mask']
  endif


  ; ************************************
  ; 15.cal PA 未完成
  ; ************************************
  if calPA_on eq 1 then begin
    get_data, 'erg_mgf_l2_magt_8sec', data = magt
    ;      get_data, '', data =
    ;      LM = ;LMを取得
    BA = magt.x ;BAを取得

    cos2lambdaM = 1 / LM
    BE = 3.11e-5
    BM = BE / L^3 * (1 + 3*(1-cos2lambda))^(0.5) / cos2lambda^3
    alpha = arcsin(sqrt(BA/BM))
    PA = alpha / pi * 180  ; ラジアンをdegreeに変換
  endif

  ; ************************************
  ; 16.1.mepe PA
  ; ************************************
  erg_load_mepe,uname='erg_project', pass='geospace',datatype='3dflux'
  ; 特定の値のenergyを測っている。plotで決めた範囲内に観測しているエネルギー値がなければtplot変数にデータが入らない？
  ;    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='pa', energy=[10000,11000], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  ;    store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_10keV'
  erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[0.,3.], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_0-3'

  ;    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='pa', energy=[41000,42000], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  ;    store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_41keV'
  erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[177.,188.], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_177-188'

  ;    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='pa', energy=[72000,73000], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  ;    store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_72keV'
  erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[3.,37.5], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_3-37'


  ; ************************************
  ; 16.2.mepe ET
  ; ************************************
  erg_load_mepe,level='l2',datatype='omniflux'
  ; 'erg_mepe_l2_omniflux_FEDO'を取得
  store_data, 'erg_mepe_l2_omniflux_FEDO', newname='mepe_ET'


  ; ************************************
  ; 17-1.cal fce.etc
  ; ************************************
  get_data, 'erg_mgf_l2_magt_8sec', data=data
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
  erg_load_pwe_ofa
  store_data, 'hfa_e_Bmodels', data=['erg_pwe_hfa_l2_high_spectra_e_mix', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']
  store_data, 'ofa_e_Bmodels', data=['erg_pwe_ofa_l2_spec_E_spectra_132', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']
  store_data, 'ofa_b_Bmodels', data=['erg_pwe_ofa_l2_spec_B_spectra_132', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']

  ylim,  'hfa_e_Bmodels', 10.0, 400.0, 1
  ylim,  'ofa_e_Bmodels', 1.0, 20.0, 1
  ylim,  'ofa_b_Bmodels', 1.0, 20.0, 1

  window, 0, xsize=1000, ysize=750
  tplot, ['hfa_e_Bmodels', 'ofa_e_Bmodels', 'ofa_b_Bmodels']

  stop

  ; ************************************
  ; 17-2.overplot fce.etc
  ; ************************************

  store_data, pr_matrix + 'Btotal_132_gyro', $
    data=[pr_matrix + 'Btotal_132', 'fce', 'fce_half','flhr']
  store_data, 'kvec_mask_gyro', data=['kvec_mask', 'fce', 'fce_half','flhr']
  store_data, 'polarization_mask_gyro', data=['polarization_mask', 'fce', 'fce_half','flhr']
  ylim, '*_gyro', 0.064, 20, 1 ; kHz
  zlim, pr_matrix + 'Btotal_132_gyro', 1E-2, 1E2, 1 ; pT^2/Hz
  options, 'erg_pwe_ofa_l2_Btotal_132_gyro', $
    ytitle='B total', ysubtitle='Frequency [kHz]', ztitle='[pT!U2!N/Hz]'

  ; *** added ***
  store_data, 'hfa_e_gyro', data=['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix', 'fce', 'fce_half','flhr']
  store_data, 'ofa_e_gyro', data=['erg_pwe_ofa_l2_matrix_Etotal_132', 'fce', 'fce_half','flhr', 'fce_TS04', 'fce_TS04_half']
  options, 'ofa_e_gyro', 'ytitle', 'OFA-E'
  options, 'ofa_e_gyro', 'ysubtitle', 'frequency [kHz]'
  options, 'ofa_e_gyro', 'zbtitle', '[mV^2/m^2/Hz]'
  ylim,  'hfa_e_gyro', 20.0, 400.0, 1
  ylim,  'ofa_e_gyro', 0.064, 20.0, 1
  zlim,  ['hfa','ofa']+'_e_gyro', 1e-10, 1, 1

  options, pr_matrix + 'Btotal_132_gyro', 'ytitle', 'OFA-B'
  options, pr_matrix + 'Btotal_132_gyro', 'ysubtitle', 'frequency [kHz]'
  options, pr_matrix + 'Btotal_132_gyro', 'zbtitle', '[pT^2/Hz]'

  ; window, xsize=1200, ysize=600
  tplot, ['hfa_e','ofa_e', pr_matrix + 'Btotal_132', 'kvec_mask', 'polarization_mask'] + '_gyro'


  ; ************************************
  ; 18.plot
  ; ************************************

  SET_PLOT, 'Z'
  DEVICE, SET_RESOLUTION = [1500,1800]
  !p.BACKGROUND = 255
  !p.color = 0

  get_timespan, td
  ts = time_string(td[0])
  ret = strsplit(ts, '-/:', /extract)

  options, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'mepe_PA_10keV', 'mepe_PA_41keV', 'mepe_PA_72keV', 'mepe_ET'], 'datagap', 60.0

  tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'mepe_PA_10keV', 'mepe_PA_41keV', 'mepe_PA_72keV', 'mepe_ET']
  makepng, 'erg_ofa_matrix_mepe_'+ret[0]+ret[1]+ret[2]

  if hourplot_on eq 1 then begin
    n_plot = fix(24.0/span)
    for i=0, n_plot-1 do begin
      timespan, [td[0]+3600.0*span*i, td[0]+3600.0*span*(i+1)]
      tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'mepe_PA_10keV', 'mepe_PA_41keV', 'mepe_PA_72keV', 'mepe_ET']
      makepng, 'erg_ofa_matrix_mepe_'+ret[0]+ret[1]+ret[2]+'_'+string(span*i,format='(i2.2)')
    endfor
  endif

end
