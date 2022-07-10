; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_Ne0_f_B.pro'

; input
;   tplot 'fce', 'Ne, 'erg_pwe_ofa_l2_spec_B_spectra_132', 'fce_TS04_half'
;   ver duct_time=duct_time, focus_f=focus_f, lsm=lsm,  duct_wid_data_n=duct_wid_data_n, IorD=IorD, test=test

; output
;   fig figname

pro plot_f_Ne0_f_B, duct_time=duct_time, focus_f=focus_f, lsm=lsm,  duct_wid_data_n=duct_wid_data_n, IorD=IorD, test=test
; duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

    ; ******************************
    ; 1.1.get data
    ; ******************************

    ; get fce_ave
    get_data, 'fce', data=fce_data

    duct_time_double = time_double(duct_time)
    time_res =  fce_data.x[100]- fce_data.x[99]
    idx_t = where( fce_data.x lt duct_time_double+time_res/2 and fce_data.x gt duct_time_double-time_res/2, cnt )

    fce_ave = fce_data.y[idx_t[0]] ;kHz 


    ; calc Ne_0 and Ne_1 from fce_ave
    plot_f = dindgen(500, increment=0.01, start=focus_f[0])
    kpara_linear = lsm[0] * plot_f + lsm[1]
    Ne_0 = fltarr(n_elements(plot_f))
    Ne_1 = fltarr(n_elements(plot_f))

    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    for i=0, n_elements( plot_f )-1 do Ne_0[i] = b1 * kpara_linear[i]^2 * (fce_ave / plot_f[i] - 1 ) / 10^(6.) ;cm-3
    for i=0, n_elements( plot_f )-1 do Ne_1[i] = b1 * kpara_linear[i]^2 * (fce_ave / (2*plot_f[i]))^2 / 10^(6.) ;cm-3

    ; for i=0, n_elements( plot_f )-1 do begin
    ;     b2 = kpara_linear[i]^2 * (fce_ave / plot_f[i] - 1 )
    ;     Ne_0[i] = b1 * b2 / 10^(6.) ;cm-3
    ;     b3 = kpara_linear[i]^2 * (fce_ave / (2*plot_f[i]))^2
    ;     Ne_1[i] = b1 * b3 / 10^(6.) ;cm-3
    ; endfor


    ; get Ne_min, Ne_max
    get_data, 'Ne', data=Ne_data

    time_res =  Ne_data.x[100]- Ne_data.x[99]
    idx_t = where( Ne_data.x lt duct_time_double+time_res/2 and Ne_data.x gt duct_time_double-time_res/2, cnt )
    Ne_obs = Ne_data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n, *] ; obs.y

    Ne_min = min(Ne_obs)
    Ne_max = max(Ne_obs)


    ; ******************************
    ; 1.2.get data
    ; ******************************

    get_data, 'erg_pwe_ofa_l2_spec_B_spectra_132', data = B_data
    time_res =  B_data.x[100]- B_data.x[99]
    idx_t = where( B_data.x lt duct_time_double+time_res/2 and B_data.x gt duct_time_double-time_res/2, cnt )

    B_obs = mean(B_data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n, *], DIMENSION=1, /nan) ; obs.y

    tinterpol_mxn, 'fce_TS04_half', 'erg_pwe_ofa_l2_spec_B_spectra_132'
    get_data, 'fce_TS04_half_interp', data=eqfce_data

    time_res =  eqfce_data.x[100]- eqfce_data.x[99]
    idx_t = where( eqfce_data.x lt duct_time_double+time_res/2 and eqfce_data.x gt duct_time_double-time_res/2, cnt )
    eqfce_duct = eqfce_data.y[idx_t]
    eqfce_duct = eqfce_duct[0] ; kHz


    ; ******************************
    ; 2.set color translation tables
    ; ******************************

    ; tvlct, 231,238,247,10
    if IorD eq 'D' then tvlct, 219,224,231,10
    if IorD eq 'I' then tvlct, 242,220,218,10


    ; ******************************
    ; 3.set plot range
    ; ******************************

    xmin = min(plot_f)
    xmax = max(plot_f)
    ymin1 = min([Ne_0,Ne_1])-5
    ymax1 = max([Ne_0,Ne_1])+5
    ymin2 = min(B_obs)
    ymax2 = max(B_obs)


    ; ******************************
    ; 4.1.plot Ne0(f), B(f)
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

    !p.multi=[0,1,2]

    plot, plot_f, Ne_0, xtitle='frequency [kHz]', ytitle='Ne0 [/cc]', yrange=[ymin1,ymax1], /nodata
    POLYFILL, [xmin,xmin,xmax,xmax]+0.0015, [Ne_min,Ne_max,Ne_max,Ne_min], color=10
    oplot, plot_f, Ne_0
    oplot, plot_f, Ne_1, linestyle='2'

    oplot, [plot_f[0]-1,plot_f[-1]+1], [Ne_min,Ne_min]
    xyouts, plot_f[-1]-0.5, Ne_min+2., string(Ne_min, format='(i0)'), CHARSIZE=1.5
    oplot, [plot_f[0]-1,plot_f[-1]+1], [Ne_max,Ne_max]
    xyouts, plot_f[-1]-0.5, Ne_max+2., string(Ne_max, format='(i0)'), CHARSIZE=1.5

    Ne_m=[Ne_min, Ne_max]

    for i=0,1 do begin

        dif = Ne_0-Ne_m[i]
        idx_dif = where( dif[0:-2] * dif[1:-1] lt 0, cnt )
        if idx_dif[0] ne -1 then begin
            for l=0, n_elements(idx_dif)-1 do begin
                duct_f = plot_f[idx_dif[l]]
                oplot, [duct_f,duct_f], [ymin1-100,ymax1+100]
            endfor
        endif

        dif = Ne_1-Ne_m[i]
        idx_dif = where( dif[0:-2] * dif[1:-1] lt 0, cnt )
        if idx_dif[0] ne -1 then begin
            for l=0, n_elements(idx_dif)-1 do begin
                duct_f = plot_f[idx_dif[l]]
                oplot, [duct_f,duct_f], [ymin1-100,ymax1+100], linestyle='2'
            endfor
        endif

    endfor


    ; ******************************
    ; 4.2.plot B(f)
    ; ******************************

    plot, B_data.v, B_obs, xtitle='frequency [kHz]', ytitle='OFA-SPEC B [pT^2/Hz]', xrange=[xmin, xmax]

    ; Ne_m=[Ne_min, Ne_max]

    for i=0,1 do begin

        dif = Ne_0-Ne_m[i]
        idx_dif = where( dif[0:-2] * dif[1:-1] lt 0, cnt )
        if idx_dif[0] ne -1 then begin
            for l=0, n_elements(idx_dif)-1 do begin
                duct_f = plot_f[idx_dif[l]]
                oplot, [duct_f,duct_f], [ymin2-0.1,ymax2+0.1]
            endfor
        endif

        dif = Ne_1-Ne_m[i]
        idx_dif = where( dif[0:-2] * dif[1:-1] lt 0, cnt )
        if idx_dif[0] ne -1 then begin
            for l=0, n_elements(idx_dif)-1 do begin
                duct_f = plot_f[idx_dif[l]]
                oplot, [duct_f,duct_f], [ymin2-0.1,ymax2+0.1], linestyle=2
            endfor
        endif

    endfor

    oplot, [eqfce_duct, eqfce_duct], [ymin2-0.1,ymax2+0.1], linestyle=4
    xyouts, eqfce_duct+0.1, min(B_obs)+0.0005, 'fce_eq/2 = '+string(eqfce_duct, format='(f0.1)'), CHARSIZE=1.5


    ; ******************************
    ; 5.save fig
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_Ne0_f_B', /mkdir
    endif


end