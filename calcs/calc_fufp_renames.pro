
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_fufp_renames.pro'

pro calc_fufp_renames

    ; ************************************
    ; 1.calc. fce,flhr
    ; ************************************

    get_data, 'hfa_l3_fce', data=fce
    get_data, 'hfa_l3_fpe', data=fpe

    store_data, 'fce', /delete
    store_data, 'fce', data={x:fce.x, y:fce.y}

    store_data, 'fce_half', /delete
    store_data, 'fce_half', data = {x:fce.x, y:fce.y/2}

    store_data, 'flhr', /delete
    flhr = sqrt(fce.y * fpe.y)
    store_data, 'flhr', data = {x:fce.x, y:flhr}

    options, 'fce', colors=5, thick=2                   ; 5=yellow
    options, 'fce_half', colors=1, thick=2    
    options, 'flhr', colors=0, thick=2, linestyle=2


    ; ************************************
    ; 2.calc. Ne
    ; ************************************

    store_data, 'Ne', /delete
    store_data, 'hfa_l3_ne', newname='Ne'
    ylim, 'Ne', 10.0, 1000.0, 1

end
