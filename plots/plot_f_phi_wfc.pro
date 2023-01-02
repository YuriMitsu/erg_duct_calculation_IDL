; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_phi_wfc.pro'

; input
;   tplot '' from isee_wave
;   ver vername

; output
;   fig figname

pro plot_f_phi_wfc, duct_time=duct_time, focus_f=focus_f, test=test

    if not keyword_set(test) then test=0

    ; ******************************
    ; 1.get data
    ; ******************************

    get_data, 'bspec', data=bdata
    b_masked = bdata.y
    b_masked[ where(bdata.y lt 1e-2) ] = 'NaN'
    store_data, 'bspec_mask', data={x:bdata.x, y:b_masked, v:bdata.v}

    duct_time1 = '2017-07-03/04:32:30'
    duct_time2 = '2017-07-03/04:32:35'

    ; for plot dots of observation phi
    get_data, 'kvec_xy', data=kvecazm_data
    kvecazm_data.y[ where(bdata.y lt 1e-2) ] = 'NaN'
    store_data, 'kvec_xy_mask', data={x:kvecazm_data.x, y:kvecazm_data.y, v:kvecazm_data.v}

    kvecazm_data.y[*, where(kvecazm_data.v lt focus_f[0]-0.1) ] = 'NaN'
    kvecazm_data.y[*, where(kvecazm_data.v gt focus_f[-1]+0.1) ] = 'NaN'

    duct_time_double1 = time_double(duct_time1)
    duct_time_double2 = time_double(duct_time2)
    time_res =  kvecazm_data.x[100]- kvecazm_data.x[99]
    idx_t1 = where( kvecazm_data.x lt duct_time_double1+time_res/2 and kvecazm_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( kvecazm_data.x lt duct_time_double2+time_res/2 and kvecazm_data.x gt duct_time_double2-time_res/2, cnt )

    ; duct_time_double = time_double(duct_time)
    ; time_res =  kvecazm_data.x[100]- kvecazm_data.x[99]
    ; idx_t = where( kvecazm_data.x lt duct_time_double+time_res/2 and kvecazm_data.x gt duct_time_double-time_res/2, cnt )

    f_obs = kvecazm_data.v ; the.x
    kvecazm_obs = kvecazm_data.y[idx_t1:idx_t2,*] ; obs.y

    f_kvec_obs = fltarr(n_elements(kvecazm_obs[*,0]),n_elements(kvecazm_obs[0,*]))
    for i=0,n_elements(kvecazm_obs[*,0])-1 do f_kvec_obs[i,*] = f_obs ; obs.x


    ; for plot dots of observation WNA
    get_data, 'wna', data=kvec_data
    kvec_data.y[ where(bdata.y lt 1e-2) ] = 'NaN'
    store_data, 'wna_mask', data={x:kvec_data.x, y:kvec_data.y, v:kvec_data.v}

    kvec_data.y[*, where(kvec_data.v lt focus_f[0]-0.1) ] = 'NaN'
    kvec_data.y[*, where(kvec_data.v gt focus_f[-1]+0.1) ] = 'NaN'

    time_res =  kvec_data.x[100]- kvec_data.x[99]
    idx_t1 = where( kvec_data.x lt duct_time_double1+time_res/2 and kvec_data.x gt duct_time_double1-time_res/2, cnt )
    idx_t2 = where( kvec_data.x lt duct_time_double2+time_res/2 and kvec_data.x gt duct_time_double2-time_res/2, cnt )

    f_obs = kvec_data.v ; the.x
    kvec_obs = kvec_data.y[idx_t1:idx_t2,*] ; obs.y

    f_kvec_obs = fltarr(n_elements(kvec_obs[*,0]),n_elements(kvec_obs[0,*]))
    for i=0,n_elements(kvec_obs[*,0])-1 do f_kvec_obs[i,*] = f_obs ; obs.x


    ; calc fce
    get_data, 'fce', data=fce_data
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt (duct_time_double1+duct_time_double2)/2+time_res/2 and fce_data.x gt (duct_time_double1+duct_time_double2)/2-time_res/2, cnt )
    fce_ave = fce_data.y[idx_t]
    fce_ave = fce_ave[0]


    ; for plot line of equatorial fce
    calc_equatorial_fce
    
    tinterpol_mxn, 'fce_TS04_half', 'fce'
    get_data, 'fce_TS04_half_interp', data=eqfce_data
    time_res =  eqfce_data.x[100]- eqfce_data.x[99]
    idx_t = where( eqfce_data.x lt (duct_time_double1+duct_time_double2)/2+time_res/2 and eqfce_data.x gt (duct_time_double1+duct_time_double2)/2-time_res/2, cnt )
    equatorial_fce_duct = eqfce_data.y[idx_t]


    ; ******************************
    ; 2.set color translation tables
    ; ******************************


    ; ******************************
    ; 3.get plot range
    ; ******************************

    xmin = (min(focus_f)-0.5)/fce_ave
    xmax = (max(focus_f)+0.5)/fce_ave
    ymin = -180.
    ymax = 180.

    ; ******************************
    ; 4.plot phi(f)
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

    ; plot, f_obs/fce_ave, ,$
    plot, f_kvec_obs/fce_ave, kvecazm_obs, psym=4, $
        xtitle='f/fce  '+'(fce = '+string(fce_ave, FORMAT='(f0.1)')+'kHz)', ytitle='phi [degree]',$
        xrange=[xmin, xmax], yrange=[ymin, ymax]
    ; oplot, f_kvec_obs/fce_ave, kvec_obs, psym=4
    ; oplot, f_obs/fce_ave, gendrin_angle, color=6

    ; xyouts, xmax-0.04, ymin+8, 'Gendrin Angle', color=6, CHARSIZE=1.5

    oplot, [equatorial_fce_duct/fce_ave, equatorial_fce_duct/fce_ave], [ymin-30.,ymax+30.], linestyle=2
    xyouts, equatorial_fce_duct/fce_ave-0.1, ymin+8, 'fce_eq/2 = '+string(equatorial_fce_duct/fce_ave, format='(f0.1)')+'kHz', CHARSIZE=1.5


    ; ******************************
    ; 5.save fig1
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Desktop/test_plots/'+ret[0]+ret[1]+ret[2]+'_'+ret[3]+ret[4]+ret[5]+'_f_thetaazm', /mkdir
        ; makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_thetaazm', /mkdir
    endif



    ; ******************************
    ; 6.plot phi theta
    ; ******************************

    ; plot, f_obs/fce_ave, ,$
    plot, kvecazm_obs, kvec_obs, psym=4, $
        xtitle='phi [degree]', ytitle='theta [degree]',$
        xrange=[-180, 180], yrange=[0, 90]

    ; ******************************
    ; 7.save fig2
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Desktop/test_plots/'+ret[0]+ret[1]+ret[2]+'_'+ret[3]+ret[4]+ret[5]+'_thetaazm_theta', /mkdir
        ; makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_thetaazm', /mkdir
    endif


end