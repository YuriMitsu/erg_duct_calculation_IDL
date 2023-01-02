; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_phi.pro'

; input
;   tplot 'kvecazm_LASVD_ma3_mask'
;   ver vername

; output
;   fig figname

pro plot_f_phi, duct_time=duct_time, focus_f=focus_f, test=test, duct_wid_data_n=duct_wid_data_n

    if not keyword_set(test) then test=0

    ; ******************************
    ; 1.get data
    ; ******************************

    ; for plot dots of observation phi
    get_data, 'kvecazm_LASVD_ma3_mask', data=kvecazm_data
    kvecazm_data.y[*, where(kvecazm_data.v lt focus_f[0]-0.1) ] = 'NaN'
    kvecazm_data.y[*, where(kvecazm_data.v gt focus_f[-1]+0.1) ] = 'NaN'

    duct_time_double = time_double(duct_time)
    time_res =  kvecazm_data.x[100]- kvecazm_data.x[99]
    idx_t = where( kvecazm_data.x lt duct_time_double+time_res/2 and kvecazm_data.x gt duct_time_double-time_res/2, cnt )

    f_obs = kvecazm_data.v ; the.x
    kvecazm_obs = kvecazm_data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n,*] ; obs.y

    f_kvec_obs = fltarr(n_elements(kvecazm_obs[*,0]),n_elements(kvecazm_obs[0,*]))
    for i=0,n_elements(kvecazm_obs[*,0])-1 do f_kvec_obs[i,*] = f_obs ; obs.x


    ; for plot dots of observation WNA
    get_data, 'kvec_LASVD_ma3_mask', data=kvec_data
    kvec_data.y[*, where(kvec_data.v lt focus_f[0]-0.1) ] = 'NaN'
    kvec_data.y[*, where(kvec_data.v gt focus_f[-1]+0.1) ] = 'NaN'

    duct_time_double = time_double(duct_time)
    time_res =  kvec_data.x[100]- kvec_data.x[99]
    idx_t = where( kvec_data.x lt duct_time_double+time_res/2 and kvec_data.x gt duct_time_double-time_res/2, cnt )

    f_obs = kvec_data.v ; the.x
    kvec_obs = kvec_data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n,*] ; obs.y

    f_kvec_obs = fltarr(n_elements(kvec_obs[*,0]),n_elements(kvec_obs[0,*]))
    for i=0,n_elements(kvec_obs[*,0])-1 do f_kvec_obs[i,*] = f_obs ; obs.x


    ; calc fce
    get_data, 'fce', data=fce_data
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )
    fce_ave = fce_data.y[idx_t]
    fce_ave = fce_ave[0]


    ; for plot line of equatorial fce
    calc_equatorial_fce
    
    tinterpol_mxn, 'fce_TS04_half', 'fce'
    get_data, 'fce_TS04_half_interp', data=eqfce_data
    time_res =  eqfce_data.x[100]- eqfce_data.x[99]
    idx_t = where( eqfce_data.x lt duct_time_double+time_res/2 and eqfce_data.x gt duct_time_double-time_res/2, cnt )
    equatorial_fce_duct = eqfce_data.y[idx_t]


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