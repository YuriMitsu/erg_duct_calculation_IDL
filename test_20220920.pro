; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/test_20220920.pro'


pro test_20220920

    w = 1

    if not w then begin
        print, 'wでない'
    endif else begin
        print, 'wである'
    endelse


    /Users/ampuku/Documents/duct/code/python/wave_calculation/data/wfc_b_waveform.tplot
    tplot_restore, file=['/Users/ampuku/Documents/duct/code/python/wave_calculation/data/wfc_b_waveform.tplot']

    WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/wave_calculation/data/wfc_time.csv', data.x
    WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/wave_calculation/data/wfc_bx_waveform.csv', data.y[*,0]
    WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/wave_calculation/data/wfc_by_waveform.csv', data.y[*,1]
    WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/wave_calculation/data/wfc_bz_waveform.csv', data.y[*,2]



end