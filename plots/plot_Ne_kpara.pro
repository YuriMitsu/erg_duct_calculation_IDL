; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_Ne_kpara.pro'

; input
;   ver duct_time, focus_f, test, lsm, kperp_range, kperp, Ne_k_para

; output
;   fig Ne_kpara

pro plot_Ne_kpara, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, kperp_range=kperp_range, kperp=kperp, Ne_k_para=Ne_k_para


    ; ******************************
    ; 1.plot Ne(kpara)
    ; ******************************

    ; set color translation tables
    tvlct, 255,0,0,1
    tvlct, 255,255,255,2
    tvlct, 0,0,0,4

    tvlct, 143,119,181,10
    tvlct, 0,0,255,11
    tvlct, 0,255,0,12
    tvlct, 200,125,0,13
    tvlct, 252,15,192,14
    tvlct, 255,0,0,15

    ; plot
    plot, kperp, Ne_k_para[*, 0], color=4, yrange=[max([min(Ne_k_para)-5, 0.]), min([max(Ne_k_para)+5, 600.])] $
        , xtitle='k_perp [/m]', ytitle='Ne [/cc]'
    oplot, kperp, Ne_k_para[*, 0], color=10
    oplot, [kperp[0]], [Ne_k_para[0, 0]], psym=4, color=6
    ; xyouts, kperp[2], Ne_k_para[0, 0], string(fix(Ne_k_para[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, kperp[2], min([max(Ne_k_para)+5, 600.])-25, string(fix(Ne_k_para[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, kperp[-8], min([max(Ne_k_para)+5, 600.])-25, string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
    for i = 1, n_elements(focus_f)-1 do begin
    oplot, kperp, Ne_k_para[*, i], color=i+10
    oplot, [kperp[0]], [Ne_k_para[0, i]], psym=4, color=6
    ; xyouts, kperp[2], Ne_k_para[0, i], string(fix(Ne_k_para[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
    xyouts, kperp[2], min([max(Ne_k_para)+5, 600.])-25-25*i, string(fix(Ne_k_para[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
    xyouts, kperp[-8], min([max(Ne_k_para)+5, 600.])-25-25*i, string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
    endfor

    xyouts, kperp[-12], max([min(Ne_k_para)-5, 0.])+25, 'fce/2 = '+string(data.y[idx_t]/1000/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2
    fce_loc_string = string(data.y[idx_t]/1000, FORMAT='(f0.1)')

    ; make fig
    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_kpara'
    endif

    ; print, ' n_0'
    ; print, Ne_k_para[0, *]
    
    ; print, ' n_max'
    ; for i=0,n_elements(focus_f)-1 do begin
    ; print, max(Ne_k_para[*, i])
    ; endfor


end