; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_BErate.pro'

; input
;   tplot 'erg_pwe_ofa_l2_matrix_Etotal_132', 'erg_pwe_ofa_l2_matrix_Btotal_132'

; output
;   tplot 'BErate'

pro calc_BErate, cut_f=cut_f

    if not keyword_set(cut_f) then cut_f = 1E-2 ;nT


    ; ******************************
    ; 1.get data
    ; ******************************

    tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Etotal_132', 'erg_pwe_ofa_l2_matrix_Btotal_132'

    get_data, 'erg_pwe_ofa_l2_matrix_Etotal_132_interp', data=E_data
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data=B_data

    ; ******************************
    ; 2.calc E/B rate
    ; ******************************

    BE_rate =  3. * sqrt(B_data.y) / sqrt(E_data.y) / 10. ; pT = 1e-12 T, mV = 1e-3 V, c = 3e8

    ; ******************************
    ; 3.return data
    ; ******************************

    store_data, 'BErate', data = {x:E_data.x, y:BE_rate, v:E_data.v}
    options, 'BErate', spec=1
    ylim, 'BErate', 0.064, 20, 1 ; kHz
    zlim, 'BErate', 1, 1000, 1


    ; tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Btotal_132', 'BErate'
    ; get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132_interp', data=data_ref
    ; ; S
    ; get_data, 'BErate', data=data, dlim=dlim, lim=lim
    ; data.y[where(data_ref.y LT cut_f)] = 'NaN'
    ; store_data, 'BErate_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim


end