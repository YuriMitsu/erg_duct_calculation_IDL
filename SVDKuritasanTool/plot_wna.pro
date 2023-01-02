
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/plot_wna.pro'


function plot_figuer, COLOR=COLOR, ii=ii, wave=wave

        yvals = [0.4,0.35,0.3,0.25,0.2,0.15]*70

        get_data, 'waveangle_th_msvd', data=pdata1
        ; oplot, pdata1.v, pdata1.y[0,*], COLOR=COLOR
        ; for k=1,n_elements(pdata1.y[*,0])-1 do oplot, pdata1.v, pdata1.y[k,*], COLOR=COLOR
        oplot, pdata1.v, total(pdata1.y, 1)/n_elements(pdata1.y[*,0]), COLOR=COLOR, thick = 2
        xyouts, 565, yvals[ii], 'wave '+string(wave,FORMAT='(i0)'), color=COLOR, charsize=1.5
        return, 'Done'

end



pro plot_wna

window, 0, xsize=1200, ysize=350

!P.multi=[0,4,1]
!P.CHARSIZE=6

esn = [10.^(4)]
enr = 1/esn*(8192L/2)
bsn = [10.^(2), 10.^(2.7), 10.^(3)]
bnr = 1/bsn*(8192L/2)


; for l=0,n_elements(bsn)-1 do begin
;         ; for i=0,n_elements(esn)-1 do begin
;         i=0
;                 plot, [0.,1.], [0,1000], xrange=[300, 900], yrange=[0.,100.], xtitle='f[Hz]', ytitle='WNA', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

;                 xyouts, 565, 0.45*70, 'wna=45, phi var', color=0, charsize=1.5
;                 mag_svd_test_ver_ofa,wna_inp=45.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=80, ii=0, wave=1)
;                 mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=120, ii=1, wave=4)
;                 mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=180, ii=2, wave=8)
;                 ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,0.,30.,60.,90.,120.,150.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 ; print, plot_figuer(COLOR=220, ii=3, wave=12)
;                 mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,180.,210.,240.,270.,300.,330.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=220, ii=3, wave=12)
; endfor
; makepng, '/Users/ampuku/Desktop/360_45ver'
; plot, [0.,1.], [0,1000]

; for l=0,n_elements(bsn)-1 do begin
;         ; for i=0,n_elements(esn)-1 do begin
;         i=0
;                 plot, [0.,1.], [0,1000], xrange=[300, 900], yrange=[0.,100.], xtitle='f[Hz]', ytitle='WNA', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

;                 xyouts, 565, 0.45*70, 'wna=75, phi var', color=0, charsize=1.5
;                 mag_svd_test_ver_ofa,wna_inp=75.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=80, ii=0, wave=1)
;                 mag_svd_test_ver_ofa,wna_inp=[75.,75.,75.,75.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=120, ii=1, wave=4)
;                 mag_svd_test_ver_ofa,wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=180, ii=2, wave=8)
;                 ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,0.,30.,60.,90.,120.,150.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 ; print, plot_figuer(COLOR=220, ii=3, wave=12)
;                 mag_svd_test_ver_ofa,wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,30.,60.,90.,120.,150.,180.,210.,240.,270.,300.,330.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=220, ii=3, wave=12)
; endfor
; makepng, '/Users/ampuku/Desktop/360_75ver'
; plot, [0.,1.], [0,1000]



for l=0,n_elements(bsn)-1 do begin
        ; for i=0,n_elements(esn)-1 do begin
        i=0
                plot, [0.,1.], [0,1000], xrange=[300, 900], yrange=[0.,100.], xtitle='f[Hz]', ytitle='WNA', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

                xyouts, 565, 0.45*70, 'wna=45,75, phi var', color=0, charsize=1.5
                mag_svd_test_ver_ofa,wna_inp=60.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=80, ii=0, wave=1)
                mag_svd_test_ver_ofa,wna_inp=[75.,75.,45.,45.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=120, ii=1, wave=4)
                mag_svd_test_ver_ofa,wna_inp=[75.,75.,45.,45.,75.,75.,45.,45.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=180, ii=2, wave=8)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,0.,30.,60.,90.,120.,150.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                ; print, plot_figuer(COLOR=220, ii=3, wave=12)
                mag_svd_test_ver_ofa,wna_inp=[75.,75.,45.,45.,75.,75.,45.,45.,75.,75.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,180.,210.,240.,270.,300.,330.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=220, ii=3, wave=12)
endfor
makepng, '/Users/ampuku/Desktop/360_4575ver'
plot, [0.,1.], [0,1000]



; for l=0,n_elements(bsn)-1 do begin
;         ; for i=0,n_elements(esn)-1 do begin
;         i=0
;                 plot, [0.,1.], [0,1000], xrange=[300, 900], yrange=[0.,100.], xtitle='f[Hz]', ytitle='WNA', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

;                 xyouts, 565, 0.45*70, 'wna=45, phi var', color=0, charsize=1.5
;                 mag_svd_test_ver_ofa,wna_inp=45.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=80, ii=0, wave=1)
;                 mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=120, ii=1, wave=4)
;                 mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,45.,90.,0.,45.,90.,0.,45.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=180, ii=2, wave=8)
;                 ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,0.,30.,60.,90.,120.,150.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 ; print, plot_figuer(COLOR=220, ii=3, wave=12)
;                 mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,0.,30.,60.,90.,0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=220, ii=3, wave=12)
; endfor
; makepng, '/Users/ampuku/Desktop/90_45ver'
; plot, [0.,1.], [0,1000]



; for l=0,n_elements(bsn)-1 do begin
;         ; for i=0,n_elements(esn)-1 do begin
;         i=0
;                 plot, [0.,1.], [0,1000], xrange=[300, 900], yrange=[0.,100.], xtitle='f[Hz]', ytitle='WNA', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

;                 xyouts, 565, 0.45*70, 'wna=75, phi var', color=0, charsize=1.5
;                 mag_svd_test_ver_ofa,wna_inp=75.,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=80, ii=0, wave=1)
;                 mag_svd_test_ver_ofa,wna_inp=[75.,75.,75.,75.],phi_inp=[0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=120, ii=1, wave=4)
;                 mag_svd_test_ver_ofa,wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,45.,90.,0.,45.,90.,0.,45.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=180, ii=2, wave=8)
;                 ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,0.,30.,60.,90.,120.,150.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 ; print, plot_figuer(COLOR=220, ii=3, wave=12)
;                 mag_svd_test_ver_ofa,wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,30.,60.,90.,0.,30.,60.,90.,0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
;                 print, plot_figuer(COLOR=220, ii=3, wave=12)
; endfor
; makepng, '/Users/ampuku/Desktop/90_75ver'
; plot, [0.,1.], [0,1000]


for l=0,n_elements(bsn)-1 do begin
        ; for i=0,n_elements(esn)-1 do begin
        i=0
                plot, [0.,1.], [0,1000], xrange=[300, 900], yrange=[0.,100.], xtitle='f[Hz]', ytitle='WNA', title='E'+string(esn[i],FORMAT='(e10.0)')+',  B'+string(bsn[l],FORMAT='(e10.0)'), charsize = 2.5

                xyouts, 565, 0.45*70, 'wna=45,75, phi var', color=0, charsize=1.5
                mag_svd_test_ver_ofa,wna_inp=60,phi_inp=0.,rate_inp=10.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=80, ii=0, wave=1)
                mag_svd_test_ver_ofa,wna_inp=[75.,75.,45.,45.],phi_inp=[0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=120, ii=1, wave=4)
                mag_svd_test_ver_ofa,wna_inp=[75.,75.,45.,45.,75.,75.,45.,45.],phi_inp=[0.,45.,90.,0.,45.,90.,0.,45.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=180, ii=2, wave=8)
                ; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,0.,30.,60.,90.,120.,150.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                ; print, plot_figuer(COLOR=220, ii=3, wave=12)
                mag_svd_test_ver_ofa,wna_inp=[75.,75.,45.,45.,75.,75.,45.,45.,75.,75.,45.,45.],phi_inp=[0.,30.,60.,90.,0.,30.,60.,90.,0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
                print, plot_figuer(COLOR=220, ii=3, wave=12)
endfor
makepng, '/Users/ampuku/Desktop/90_4575ver'
plot, [0.,1.], [0,1000]






end

