; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_Ne_kperp.pro'

; input
;   ver focus_f, test, lsm, data__Ne_kperp

; output
;   fig Ne_kperp

pro plot_Ne_kperp, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, data__Ne_kperp=data__Ne_kperp

    ; ******************************
    ; 1.get data
    ; ******************************

    kperp = data__Ne_kperp.x
    Ne_kperp = data__Ne_kperp.y

    ; Get fce_half=fce/2 to put the fce/2 in the figure
    get_data, 'fce', data=fce_data
    duct_time_double = time_double(duct_time)
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )
    fce_ave = fce_data.y[idx_t]

    ; ******************************
    ; 2.set color translation tables
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
    ; 3.get plot range
    ; ******************************

    ; xmin = 
    ; xmax = 
    ymin = max([min(Ne_kperp)-5, 0.])
    ymax = min([max(Ne_kperp)+5, 600.])

    ; ******************************
    ; 4.plot Ne(kperp)
    ; ******************************

    if test eq 1 then begin
        SET_PLOT, 'X'
        !p.BACKGROUND = 255
        !p.color = 0
    endif else begin
        SET_PLOT, 'Z'
        DEVICE, SET_RESOLUTION = [1000,600]
        !p.BACKGROUND = 255
        !p.color = 0
    endelse

    !p.multi=0

    ; plot
    plot, kperp, Ne_kperp[*, 0], color=4, yrange=[ymin, ymax], xtitle='k_perp [/m]', ytitle='Ne [/cc]'
    oplot, kperp, Ne_kperp[*, 0], color=10
    oplot, [kperp[0]], [Ne_kperp[0, 0]], psym=4, color=6
    ; xyouts, kperp[2], Ne_kperp[0, 0], string(fix(Ne_kperp[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, kperp[2], ymax-25, string(fix(Ne_kperp[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, kperp[-8], ymax-25, string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
    for i = 1, n_elements(focus_f)-1 do begin
        oplot, kperp, Ne_kperp[*, i], color=i+10
        oplot, [kperp[0]], [Ne_kperp[0, i]], psym=4, color=6
        xyouts, kperp[2], ymax-25*(1+i), string(fix(Ne_kperp[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
        xyouts, kperp[-8], ymax-25*(1+i), string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
    endfor

    xyouts, kperp[-12], ymin+25, 'fce/2 = '+string(fce_ave/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2

    ; ******************************
    ; 5.save fig
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_kperp', /mkdir
    endif


end