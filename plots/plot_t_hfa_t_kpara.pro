; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_t_hfa_t_kpara.pro'

; input
;   tplot 'Ne'
;   ver duct_time, duct_wid_data_n

; output
;   fig t_hfa_t_kpara

pro plot_t_hfa_t_kpara, duct_time=duct_time, duct_wid_data_n=duct_wid_data_n, test=test
; duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

    ; ******************************
    ; 1.get data
    ; ******************************

    ; get Ne_min, Ne_max
    get_data, 'Ne', data=Ne_data

    duct_time_double = time_double(duct_time)
    time_res =  Ne_data.x[100]- Ne_data.x[99]
    idx_t = where( Ne_data.x lt duct_time_double+time_res/2 and Ne_data.x gt duct_time_double-time_res/2, cnt )
    Ne_obs = Ne_data.y[idx_t-120/time_res:idx_t+120/time_res, *] ; obs.y

    Ne_min = min(Ne_obs)
    Ne_max = max(Ne_obs)

    idx_start = idx_t - duct_wid_data_n
    start_time = Ne_data.x[idx_start]
    idx_end = idx_t + duct_wid_data_n
    end_time = Ne_data.x[idx_end]


    ; ******************************
    ; 2.set color translation tables
    ; ******************************

    ; ******************************
    ; 3.set plot range
    ; ******************************

    ylim, 'Ne', Ne_min, Ne_max, 0
    ylim, 'kvec_LASVD_ma3_mask', 0., 9.0, 0
    timespan, time_string( duct_time_double-120. ), 4, /minute

    ; ******************************
    ; 4.plot 
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

    tplot, ['Ne', 'kvec_LASVD_ma3_mask']
    timebar, duct_time
    timebar, start_time, linestyle=2
    timebar, end_time, linestyle=2

    ; ******************************
    ; 5.save fig
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_t_hfa_t_kpara', /mkdir
    endif


end