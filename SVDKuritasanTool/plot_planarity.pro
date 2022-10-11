
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/plot_planarity.pro'


function plot_figuer, COLOR=COLOR, ii=ii, wave=wave

        yvals = [0.4,0.35,0.3,0.25,0.2,0.15]

        get_data, 'planarity_msvd', data=pdata1
        ; oplot, pdata1.v, pdata1.y[0,*], COLOR=COLOR
        ; for k=1,n_elements(pdata1.y[*,0])-1 do oplot, pdata1.v, pdata1.y[k,*], COLOR=COLOR
        oplot, pdata1.v, total(pdata1.y, 1)/n_elements(pdata1.y[*,0]), COLOR=COLOR, thick = 2
        xyouts, 565, yvals[ii], 'wave '+string(wave,FORMAT='(i0)'), color=COLOR, charsize=1.5
        return, 'Done'

end



pro plot_planarity

window, 0, xsize=1400, ysize=750

!P.multi=[0,4,3]

; esn = [10.^(4)]
esn = [10.^(3), 10.^(4), 10.^(5), 10.^(6)]
enr = 1/esn*(8192L/2)
; enr = 1/esn*(1024L/2)
; bsn = [10.^(2), 10.^(2.5), 10.^(3)]
bsn = [10.^(1), 10.^(2), 10.^(3)]
bnr = 1/bsn*(8192L/2)
; bnr = 1/bsn*(1024L/2)

for l=0,2 do begin
        for i=0,3 do begin
        ; i=0

; theta 1-4
                plot, [0.,1.], [0,1000], xrange=[540, 580], yrange=[0.2,1], xtitle='f[Hz]', ytitle='planarity', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5
                
                mag_svd_test_ver_ofa,wna_inp=10.,phi_inp=0.,rate_inp=1.,enr=enr[i],bnr=bnr[l]
                print, plot_figuer(COLOR=80, wave=1, ii=0)
                mag_svd_test_ver_ofa,wna_inp=[10.,30.],phi_inp=[0.,0.],rate_inp=[1.,1.]/2.,enr=enr[i],bnr=bnr[l]
                print, plot_figuer(COLOR=120, wave=2, ii=1)
                mag_svd_test_ver_ofa,wna_inp=[10.,30.,50.],phi_inp=[0.,0.,0.],rate_inp=[1.,1.,1.]/3.,enr=enr[i],bnr=bnr[l]
                print, plot_figuer(COLOR=180, wave=3, ii=2)
                mag_svd_test_ver_ofa,wna_inp=[10.,30.,50.,70.],phi_inp=[0.,0.,0.,0.],rate_inp=[1.,1.,1.,1.]/4.,enr=enr[i],bnr=bnr[l]
                print, plot_figuer(COLOR=220, wave=4, ii=3)

                ; mag_svd_test_ver_ofa,wna_inp=10.,phi_inp=30.,rate_inp=1.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, wave=1, ii=0)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,30.],phi_inp=[30.,30.],rate_inp=[1.,1.]/2.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, wave=2, ii=1)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,30.,50.],phi_inp=[30.,30.,30.],rate_inp=[1.,1.,1.]/3.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, wave=3, ii=2)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,30.,50.,70.],phi_inp=[30.,30.,30.,30.],rate_inp=[1.,1.,1.,1.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, wave=4, ii=3)

                ; mag_svd_test_ver_ofa,wna_inp=10.,phi_inp=0.,rate_inp=1.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, wave=1, ii=0)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,30.,50.,70.],phi_inp=[0.,0.,0.,0.],rate_inp=[1.,1.,1.,1.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, wave=4, ii=1)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,15.,25.,30.,35.,45.,50.,55.,65.,70.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[1.,1.,1.,1.,1.,1.,1.,1.,1.,1.]/10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, wave=10, ii=2)
                ; mag_svd_test_ver_ofa,wna_inp=[5.,10.,15.,20.,25.,30.,35.,40.,45.,50.,55.,60.,65.,70.,75.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.,1.]/15.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, wave=15, ii=3)


; phi 1-4
                ; plot, [0.,1.], [0,1000], xrange=[540, 580], yrange=[0.2,1], xtitle='f[Hz]', ytitle='planarity', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

                ; mag_svd_test_ver_ofa,wna_inp=50.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, ii=0, wave=1)
                ; mag_svd_test_ver_ofa,wna_inp=[50.,50.],phi_inp=[0.,90.],rate_inp=[10.,10.]/2.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, ii=1, wave=2)
                ; mag_svd_test_ver_ofa,wna_inp=[50.,50.,50.],phi_inp=[0.,90.,180.],rate_inp=[10.,10.,10.]/3.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, ii=2, wave=3)
                ; mag_svd_test_ver_ofa,wna_inp=[50.,50.,50.,50.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=4)


                ; mag_svd_test_ver_ofa,wna_inp=45.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, ii=0, wave=1)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.],phi_inp=[0.,90.],rate_inp=[10.,10.]/2.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, ii=1, wave=2)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.],phi_inp=[0.,90.,180.],rate_inp=[10.,10.,10.]/3.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, ii=2, wave=3)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=4)


                ; mag_svd_test_ver_ofa,wna_inp=30.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, ii=0, wave=1)
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.],phi_inp=[0.,90.],rate_inp=[10.,10.]/2.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, ii=1, wave=2)
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.],phi_inp=[0.,90.,180.],rate_inp=[10.,10.,10.]/3.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, ii=2, wave=3)
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=4)

                ; mag_svd_test_ver_ofa,wna_inp=30.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, ii=0, wave=1)
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, ii=1, wave=4)
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.,30.,30.,30.,30.,30.,30.],phi_inp=[0.,36.,72.,108.,144.,180.,216.,252.,288.,324.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, ii=2, wave=10)
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.,30.,30.,30.,30.,30.,30.,30.,30.,30.,30.,30],phi_inp=[0.,24.,48.,72.,96.,120.,144.,168.,192.,216.,240.,264.,288.,312.,336.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/15.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=15)

                ; mag_svd_test_ver_ofa,wna_inp=45.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, ii=0, wave=1)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, ii=1, wave=4)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,36.,72.,108.,144.,180.,216.,252.,288.,324.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, ii=2, wave=10)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45],phi_inp=[0.,24.,48.,72.,96.,120.,144.,168.,192.,216.,240.,264.,288.,312.,336.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/15.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=15)


                ; mag_svd_test_ver_ofa,wna_inp=10.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, ii=0, wave=1)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,10.],phi_inp=[0.,90.],rate_inp=[10.,10.]/2.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, ii=1, wave=2)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,10.,10.],phi_inp=[0.,90.,180.],rate_inp=[10.,10.,10.]/3.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, ii=2, wave=3)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,10.,10.,10.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=4)

                ; mag_svd_test_ver_ofa,wna_inp=5.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, ii=0, wave=1)
                ; mag_svd_test_ver_ofa,wna_inp=[5.,5.],phi_inp=[0.,90.],rate_inp=[10.,10.]/2.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, ii=1, wave=2)
                ; mag_svd_test_ver_ofa,wna_inp=[5.,5.,5.],phi_inp=[0.,90.,180.],rate_inp=[10.,10.,10.]/3.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, ii=2, wave=3)
                ; mag_svd_test_ver_ofa,wna_inp=[5.,5.,5.,5.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=4)
                ; mag_svd_test_ver_ofa,wna_inp=[5.,5.,5.,5.,5.],phi_inp=[0.,72.,144.,216.,288.],rate_inp=[10.,10.,10.,10.,10.]/5.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=4)
                ; mag_svd_test_ver_ofa,wna_inp=[5.,5.,5.,5.,5.,5.],phi_inp=[0.,60.,120.,180.,240.,300.],rate_inp=[10.,10.,10.,10.,10.,10.]/6.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, ii=3, wave=4)


; phi 1,5,10
                ; plot, [0.,1.], [0,1000], xrange=[540, 580], yrange=[0.2,1], xtitle='f[Hz]', ytitle='planarity', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5
                
                ; mag_svd_test_ver_ofa,wna_inp=30.,phi_inp=0.,rate_inp=1.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, wave=1, ii=0)
                ; stop
                ; ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.],phi_inp=[0.,120.,240.],rate_inp=[3.33,3.33,3.33],enr=enr[i],bnr=bnr[l]
                ; ; print, plot_figuer(COLOR=120, wave=3, ii=1)
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.,30.],phi_inp=[0.,72.,144.,216.,288.],rate_inp=[1.,1.,1.,1.,1.]/5,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, wave=5, ii=1)
                ; stop
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.,30.,30.],phi_inp=[0.,60.,120.,180.,240.,300.],rate_inp=[1.,1.,1.,1.,1.,1.]/6,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, wave=6, ii=2)
                ; stop
                ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.,30.,30.,30.],phi_inp=[0.,50.,100.,150.,200.,250.,300.],rate_inp=[1.,1.,1.,1.,1.,1.,1.]/7,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, wave=7, ii=3)
                ; stop
                ; ; mag_svd_test_ver_ofa,wna_inp=[30.,30.,30.,30.,30.,30.,30.,30.,30.,30.],phi_inp=[0.,36.,72.,108.,144.,180.,216.,252.,288.,324.],rate_inp=[1.,1.,1.,1.,1.,1.,1.,1.,1.,1.],enr=enr[i],bnr=bnr[l]
                ; ; print, plot_figuer(COLOR=220, wave=10, ii=3)


; どちらも動かす
                ; plot, [0.,1.], [0,1000], xrange=[540, 580], yrange=[0.2,1], xtitle='f[Hz]', ytitle='planarity', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

                ; mag_svd_test_ver_ofa,wna_inp=10.,phi_inp=10.,rate_inp=1.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=80, wave=1, ii=0)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,20.,30.],phi_inp=[10.,20.,30.],rate_inp=[1.,1.,1.]/3.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=120, wave=2, ii=1)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,20.,30.,40.,50.],phi_inp=[10.,20.,30.,40.,50.],rate_inp=[1.,1.,1.,1.,1.]/5.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=180, wave=3, ii=2)
                ; mag_svd_test_ver_ofa,wna_inp=[10.,20.,30.,40.,50.,60.,70.],phi_inp=[10.,20.,30.,40.,50.,60.,70.],rate_inp=[1.,1.,1.,1.,1.,1.,1.]/7.,enr=enr[i],bnr=bnr[l]
                ; print, plot_figuer(COLOR=220, wave=4, ii=3)

        endfor
endfor

stop


;     window, 0, xsize=1400, ysize=700

;     !P.multi=[0,5,5]
;     esn = [10.^(-5), 10.^(-4.5), 10.^(-4), 10.^(-3.5), 10.^(-3)]
;     enr = esn*(8192L/2)
;     bsn = [10.^(-2.5), 10.^(-2.75), 10.^(-2), 10.^(-1.75), 10.^(-1.5)]
;     ; bsn = [10.^(-3), 10.^(-2.5), 10.^(-2), 10.^(-1.5), 10.^(-1)]
;     bnr = bsn*(8192L/2)

; for i=0,4 do begin
;     for l=0,4 do begin
;         mag_svd_test_ver_ofa,wna_inp=0,phi_inp=0,rate_inp=0,enr=enr[i],bnr=bnr[l]

;         get_data, 'planarity_msvd', data=pdata1
;         plot, pdata1.v, pdata1.y[0,*], xrange=[550, 600], xtitle='f[Hz]', ytitle='planarity', title='E S/N='+string(esn[i])+'  B S/N='+string(bsn[l])
;         oplot, pdata1.v, pdata1.y[0,*], COLOR=80
;         for k=1,n_elements(pdata1.y[*,0])-1 do oplot, pdata1.v, pdata1.y[k,*], COLOR=80
;         xyouts, 592, 0.1, 'wave x 1', color=80


;         mag_svd_test_ver_ofa,wna_inp=[0,30],phi_inp=[0,30],rate_inp=[1., 1.],enr=enr[i],bnr=bnr[l]

;         get_data, 'planarity_msvd', data=pdata2
;         oplot, pdata2.v, pdata2.y[0,*], COLOR=220
;         for k=1,n_elements(pdata2.y[*,0])-1 do oplot, pdata2.v, pdata2.y[k,*], COLOR=220
;         xyouts, 592, 0.055, 'wave x 2', color=220

;     endfor
; endfor


end

