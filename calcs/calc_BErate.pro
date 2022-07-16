; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_BErate.pro'

; input
;   tplot 'erg_pwe_ofa_l2_matrix_Etotal_132', 'erg_pwe_ofa_l2_matrix_Btotal_132'

; output
;   tplot 'BErate'


pro calc_BErate

    ; ******************************
    ; 1.get data
    ; ******************************

    tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Etotal_132', 'erg_pwe_ofa_l2_matrix_Btotal_132'

    get_data, 'erg_pwe_ofa_l2_matrix_Etotal_132_interp', data=E_data
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data=B_data

    ; ******************************
    ; 2.calc E/B rate
    ; ******************************

    BE_rate = B_data.y/E_data.y

    ; ******************************
    ; 3.return data
    ; ******************************

    store_data, 'BErate', data = {x:E_data.x, y:BE_rate, v:E_data.v}
    options, 'BErate', spec=1
    zlim, 'BErate', 0., 0.2, 0


end