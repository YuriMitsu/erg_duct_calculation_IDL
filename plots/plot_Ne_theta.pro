; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_Ne_theta.pro'

; input
;   tplot 'fce'
;   ver test, lsm

; output
;   fig Ne_theta

pro plot_Ne_theta, test=test, lsm=lsm, kperp_range=kperp_range


    ; ******************************
    ; 7.plot
    ; ******************************

    tvlct, 255,0,0,1
    tvlct, 255,255,255,2
    tvlct, 0,0,0,4

    tvlct, 143,119,181,10
    tvlct, 0,0,255,11
    tvlct, 0,255,0,12
    tvlct, 200,125,0,13
    tvlct, 252,15,192,14
    tvlct, 255,0,0,15


    ; ******************************
    ; 7.1.plot Ne(kpara)
    ; ******************************

    plot, kperp, Ne_k_para[*, 0], color=4, yrange=[max([min(Ne_k_para)-5, 0.]), min([max(Ne_k_para)+5, 600.])] $
    ; plot, kperp, Ne_k_para[*, 0], color=4, yrange=[0, 300] $
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

    if test eq 0 then begin
    makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_kpara'
    endif

    print, ' n_0'
    print, Ne_k_para[0, *]
    
    print, ' n_max'
    for i=0,n_elements(focus_f)-1 do begin
    print, max(Ne_k_para[*, i])
    endfor


    ; ******************************
    ; 7.2.plot Ne(theta)
    ; ******************************

    plot, theta, Ne_theta[*, 0], color=4, yrange=[max([min(Ne_k_para)-5, 0.]), min([max(Ne_k_para)+5, 600.])] $
    ; plot, theta, Ne_theta[*, 0], color=4, yrange=[0, 300] $
            , xtitle='theta [degree]', ytitle='Ne [/cc]'
    oplot, theta, Ne_theta[*, 0], color=10
    oplot, [theta[0]], [Ne_theta[0, 0]], psym=4, color=6
    xyouts, theta[4], min([max(Ne_k_para)+5, 600.])-25, string(fix(Ne_theta[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, theta[-16], min([max(Ne_k_para)+5, 600.])-25, string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
    for i = 1, n_elements(focus_f)-1 do begin
        oplot, theta, Ne_theta[*, i], color=i+10
        oplot, [theta[0]], [Ne_theta[0, i]], psym=4, color=6
        xyouts, theta[4], min([max(Ne_k_para)+5, 600.])-25-25*i, string(fix(Ne_theta[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
        xyouts, theta[-16], min([max(Ne_k_para)+5, 600.])-25-25*i, string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
    endfor

    xyouts, theta[-24], max([min(Ne_k_para)-5, 0.])+25, 'fce/2 = '+string(data.y[idx_t]/1000/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2

    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_theta'
    endif

    print, ' n_0'
    print, Ne_theta[0, *]

    print, ' n_max'
    for i=0,n_elements(focus_f)-1 do begin
        print, max(Ne_theta[*, i])
    endfor

end