
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_ave_WNA.pro'


pro calc_ave_WNA

    ; ************************************
    ; load WNA and calc ave WNA
    ; make tplot 'WNA_ave'
    ; calc_wave_params後に実行, kvec_LASVD_ma3_maskの名前は適宜変更...
    ; ************************************

    ; ************************************
    ; 1.load data
    ; ************************************

    get_data, 'kvec_LASVD_ma3_mask', data=kvec

    ; ************************************
    ; 2.calc. kvec_ave
    ; ************************************

    kvec_ave = fltarr(n_elements(kvec.x))
    idx_min = where( kvec.v gt 1. and kvec.v lt 1.5, cnt )
    idx_max = where( kvec.v gt 9.5 and kvec.v lt 10., cnt )

    store_data, 'test', data = {x:kvec.x, y:kvec.y[*,idx_min[0]:idx_max[-1]], v:kvec.v[idx_min[0]:idx_max[-1]]}

    kvec_ave = mean(kvec.y[*,idx_min[0]:idx_max[-1]], DIMENSION=2, /nan)

    store_data, 'kvec_ave', data={x:kvec.x, y:kvec_ave} ;, v:s00.v2}
    ylim, 'kvec_ave', 0.0, 90.0, 0

end