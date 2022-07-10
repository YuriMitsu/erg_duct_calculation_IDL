; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot.pro'

; input
;   tplot tplotname
;   ver vername

; output
;   fig figname

pro plot_, vername=vername
; duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, cut_f=cut_f, k_perp_range=k_perp_range, duct_wid_data_n=duct_wid_data_n, IorD=IorD

    ; ******************************
    ; 1.get data
    ; ******************************

    ; ******************************
    ; 2.set color translation tables
    ; ******************************

    ; ******************************
    ; 3.set plot range
    ; ******************************

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

    !p.multi=0
    ; !p.multi=[0, 1,2]

    ; ******************************
    ; 5.save fig
    ; ******************************

    ret = strsplit(duct_time, '-/:', /extract)
    if test eq 0 then begin
        makepng, '/Users/ampuku/Documents/duct/fig/event_plots/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_figname'
    endif


end