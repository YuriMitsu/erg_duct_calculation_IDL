; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_EBrate.pro'

; input
;   tplot 'erg_pwe_ofa_l2_matrix_Etotal_132', 'erg_pwe_ofa_l2_matrix_Btotal_132'

; output
;   tplot 'EBrate'


pro calc_EBrate

    ; ******************************
    ; 1.get data
    ; ******************************

    tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Etotal_132', 'erg_pwe_ofa_l2_matrix_Btotal_132'

    get_data, 'erg_pwe_ofa_l2_matrix_Etotal_132_interp', data=E_data
    get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data=B_data

    ; ******************************
    ; 2.calc E/B rate
    ; ******************************

    EB_rate = E_data.y/B_data.y

    ; ******************************
    ; 3.return data
    ; ******************************

    store_data, 'EBrate', data = {x:E_data.x, y:EB_rate, v:E_data.v}
    options, 'EBrate', spec=1
    zlim, 'EBrate', 0., 0.2, 0


end