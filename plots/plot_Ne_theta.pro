; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_Ne_theta.pro'

; input
;   ver  duct_time, focus_f, test, lsm, data__Ne_theta

; output
;   fig Ne_theta

pro plot_Ne_theta, duct_time=duct_time, focus_f=focus_f, test=test, lsm=lsm, data__Ne_theta=data__Ne_theta

    ; ******************************
    ; 1.get data
    ; ******************************

    theta = data__Ne_theta.x
    Ne_theta = data__Ne_theta.y

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
    ymin = max([min(Ne_theta)-5, 0.])
    ymax = min([max(Ne_theta)+5, 600.])

    ; ******************************
    ; 4.plot Ne(theta)
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

    plot, theta, Ne_theta[*, 0], color=4, yrange=[ymin, ymax], xtitle='theta [degree]', ytitle='Ne [/cc]'
    oplot, theta, Ne_theta[*, 0], color=10
    oplot, [theta[0]], [Ne_theta[0, 0]], psym=4, color=6
    xyouts, theta[4], ymax-25, string(fix(Ne_theta[0, 0]), format='(i0)'), color=10, CHARSIZE=2
    xyouts, theta[-16], ymax-25, string(focus_f[0], FORMAT='(f0.1)')+'kHz', color=10, CHARSIZE=2
    for i = 1, n_elements(focus_f)-1 do begin
        oplot, theta, Ne_theta[*, i], color=i+10
        oplot, [theta[0]], [Ne_theta[0, i]], psym=4, color=6
        xyouts, theta[4], ymax-25*(1+i), string(fix(Ne_theta[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
        xyouts, theta[-16], ymax-25*(1+i), string(focus_f[i], FORMAT='(f0.1)')+'kHz', color=i+10, CHARSIZE=2
    endfor

    get_data, 'fce', data=fce_data
    duct_time_double = time_double(duct_time)
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )

    xyouts, theta[-24], ymin+25, 'fce/2 = '+string(fce_data.y[idx_t]/2, FORMAT='(f0.1)')+'kHz', color=4, CHARSIZE=2


    ; ******************************
    ; 5.save fig
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_theta'
    endif


end