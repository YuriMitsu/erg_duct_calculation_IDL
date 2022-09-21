; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/test_20220920.pro'


pro test_20220920

    w = 1

    if not w then begin
        print, 'wでない'
    endif else begin
        print, 'wである'
    endelse


end