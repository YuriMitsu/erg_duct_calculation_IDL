; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_Ne0_f_B.pro'

; input
;   tplot tplotname
;   ver vername

; output
;   fig figname

pro plot_f_Ne0_f_B, lsm=lsm, 
; duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

    ; ******************************
    ; 1.1.get data
    ; ******************************

    ; get fce_ave
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
    Ne_obs = Ne_data.y[idx_t-duct_wid_data_n:idx_t+duct_wid_data_n, *] ; obs.y

    Ne_min = min(Ne_obs)
    Ne_max = max(Ne_obs)


    ; ******************************
    ; 1.2.get data
    ; ******************************

    ; ******************************
    ; 2.set color translation tables
    ; ******************************

    tvlct, 135,206,250,10
    tvlct, 135,206,250,11


    ; ******************************
    ; 3.get plot range
    ; ******************************

    xmin = min(plot_f)
    xmax = max(plot_f)
    ymin = min([Ne_0,Ne_1])-5
    ymax = max([Ne_0,Ne_1])+5

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

    plot, plot_f, Ne_0, xtitle='frequency [kHz]', ytitle='Ne0 [/cc]', yrange=[ymin,ymax], /nodata
    POLYFILL, [xmin,xmin,xmax,xmax], [Ne_min,Ne_max,Ne_max,Ne_min], color=10
    oplot, plot_f, Ne_0
    oplot, plot_f, Ne_1, linestyle='2'

    oplot, [plot_f[0]-1,plot_f[-1]+1], [Ne_min,Ne_min]
    xyouts, plot_f[-1]-0.5, Ne_min+2., string(Ne_min, format='(i0)'), CHARSIZE=1.5
    oplot, [plot_f[0]-1,plot_f[-1]+1], [Ne_max,Ne_max]
    xyouts, plot_f[-1]-0.5, Ne_max+2., string(Ne_max, format='(i0)'), CHARSIZE=1.5

stop
    ; ******************************
    ; 4.2.plot B(f)
    ; ******************************

    ; ******************************
    ; 5.save fig
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_figname'
    endif


end