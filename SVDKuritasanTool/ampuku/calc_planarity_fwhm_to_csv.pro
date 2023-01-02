
; .compile '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/ampuku/calc_planarity_fwhm_to_csv.pro'

function make_csv,wna_inp=wna_inp,phi_inp=phi_inp,rate_inp=rate_inp,filename=filename

        esn = 10.^(4)
        enr = 1/esn*(8192L/2)
        bsn = 10.^(2.7)
        bnr = 1/bsn*(8192L/2)

        mag_svd_ofa,wna_inp=wna_inp,phi_inp=phi_inp,rate_inp=rate_inp,enr=enr,bnr=bnr,f_average=3,t_average=4
        testn=200
        get_data, 'waveangle_th_msvd', data=thdata
        thdata_all=dblarr(n_elements(thdata.v),testn+1)
        phidata_all=dblarr(n_elements(thdata.v),testn+1)
        pladata_all=dblarr(n_elements(thdata.v),testn+1)
        thdata_all[*,0]=thdata.v
        phidata_all[*,0]=thdata.v
        pladata_all[*,0]=thdata.v
        ; store_data, 'bfield', /delete
        ; store_data, 'Svec', /delete

        for i=0,testn-1 do begin
                mag_svd_ofa,wna_inp=wna_inp,phi_inp=phi_inp,rate_inp=rate_inp,enr=enr,bnr=bnr,f_average=3,t_average=4

                get_data, 'waveangle_th_msvd', data=thdata
                get_data, 'waveangle_phi_msvd', data=phidata
                get_data, 'planarity_msvd', data=pladata
                ; stop

                thdata_all[*,i+1]=thdata.y[1,*]
                phidata_all[*,i+1]=phidata.y[1,*]
                pladata_all[*,i+1]=pladata.y[1,*]
                
                store_data, 'bfield', /delete
                store_data, 'Svec', /delete
        endfor

        WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/for_planarity_fwhm/csv/'+filename+'_theta.csv', thdata_all
        WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/for_planarity_fwhm/csv/'+filename+'_phi.csv', phidata_all
        WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/for_planarity_fwhm/csv/'+filename+'_pla.csv', pladata_all


end



pro calc_planarity_fwhm_to_csv

; make_csv,wna_inp=wna_inp,phi_inp=phi_inp,rate_inp=rate_inp,filename=filename

a=make_csv(wna_inp=[0.,0.,0.,0.,0.,0.,0.,0.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna0_phi0360_wave8')
a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5_phi0360_wave8')
a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna15_phi0360_wave8')
a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna25_phi0360_wave8')
a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna35_phi0360_wave8')
a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna45_phi0360_wave8')
a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna55_phi0360_wave8')
a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna65_phi0360_wave8')
a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna75_phi0360_wave8')
a=make_csv(wna_inp=[85.,85.,85.,85.,85.,85.,85.,85.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna85_phi0360_wave8')

a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5_phi090_wave8')
a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna15_phi090_wave8')
a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna25_phi090_wave8')
a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna35_phi090_wave8')
a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna45_phi090_wave8')
a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna55_phi090_wave8')
a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna65_phi090_wave8')
a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna75_phi090_wave8')

a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5_phi0_wave8')
a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna15_phi0_wave8')
a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna25_phi0_wave8')
a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna35_phi0_wave8')
a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna45_phi0_wave8')
a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna55_phi0_wave8')
a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna65_phi0_wave8')
a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna75_phi0_wave8')


stop


; rand(FFT区間ごとの位相がランダム)にしたければmakewave_ofa.pro 115行目 を書き換え！

; a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna5_phi0360_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna15_phi0360_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna25_phi0360_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna35_phi0360_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna45_phi0360_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna55_phi0360_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna65_phi0360_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna75_phi0360_wave8')

; a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna5_phi090_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna15_phi090_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna25_phi090_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna35_phi090_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna45_phi090_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna55_phi090_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna65_phi090_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna75_phi090_wave8')

; a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna5_phi0_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna15_phi0_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna25_phi0_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna35_phi0_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna45_phi0_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna55_phi0_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna65_phi0_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna75_phi0_wave8')


; rand(FFT区間ごとの位相がランダム)にしたければmakewave_ofa.pro 115行目 を書き換え！
; fconst(周波数一定)にしたければmakewave_ofa.pro 45-55行目 を書き換え！

; a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna5_phi0360_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna15_phi0360_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna25_phi0360_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna35_phi0360_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna45_phi0360_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna55_phi0360_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna65_phi0360_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna75_phi0360_wave8')

; a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna5_phi090_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna15_phi090_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna25_phi090_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna35_phi090_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna45_phi090_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna55_phi090_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna65_phi090_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,10.,20.,30.,40.,50.,60.,70.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna75_phi090_wave8')

; a=make_csv(wna_inp=[5.,5.,5.,5.,5.,5.,5.,5.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna5_phi0_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,15.,15.,15.,15.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna15_phi0_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,25.,25.,25.,25.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna25_phi0_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,35.,35.,35.,35.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna35_phi0_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna45_phi0_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,55.,55.,55.,55.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna55_phi0_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,65.,65.,65.,65.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna65_phi0_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna75_phi0_wave8')





; a=make_csv(wna_inp=45.,phi_inp=0.,rate_inp=10.,filename='rand_wna45_phi0360_wave1')
; a=make_csv(wna_inp=[45.,45.,45.,45.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,filename='rand_wna45_phi0360_wave4')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna45_phi0360_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,120.,150.,180.,210.,240.,270.,300.,330.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,filename='rand_wna45_phi0360_wave12')


; a=make_csv(wna_inp=75.,phi_inp=0.,rate_inp=10.,filename='rand_wna75_phi0360_wave1')
; a=make_csv(wna_inp=[75.,75.,75.,75.],phi_inp=[0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.]/4.,filename='rand_wna75_phi0360_wave4')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,45.,90.,135.,180.,225.,270.,315.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna75_phi0360_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,30.,60.,90.,120.,150.,180.,210.,240.,270.,300.,330.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,filename='rand_wna75_phi0360_wave12')


; a=make_csv(wna_inp=45.,phi_inp=0.,rate_inp=10.,filename='rand_wna45_phi090_wave1')
; a=make_csv(wna_inp=[45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.]/4.,filename='rand_wna45_phi090_wave4')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,45.,90.,0.,45.,90.,0.,45.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna45_phi090_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.,0.,30.,60.,90.,0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,filename='rand_wna45_phi090_wave12')


; a=make_csv(wna_inp=75.,phi_inp=0.,rate_inp=10.,filename='rand_wna75_phi090_wave1')
; a=make_csv(wna_inp=[75.,75.,75.,75.],phi_inp=[0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.]/4.,filename='rand_wna75_phi090_wave4')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,45.,90.,0.,45.,90.,0.,45.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_wna75_phi090_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.,75.],phi_inp=[0.,30.,60.,90.,0.,30.,60.,90.,0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10.]/12.,filename='rand_wna75_phi090_wave12')



; 
; a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5185_phi0_wave8')
; a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5185_phi030_wave8')
; a=make_csv(wna_inp=[0.,180.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna0180_phi0_wave2')
; a=make_csv(wna_inp=[5.,185.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna5185_phi0_wave2')
; a=make_csv(wna_inp=[15.,195.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna15195_phi0_wave2')
; a=make_csv(wna_inp=[25.,205.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna25205_phi0_wave2')
; a=make_csv(wna_inp=[35.,215.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna35215_phi0_wave2')
; a=make_csv(wna_inp=[45.,225.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna45225_phi0_wave2')
; a=make_csv(wna_inp=[55.,235.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna55235_phi0_wave2')
; a=make_csv(wna_inp=[65.,245.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna65245_phi0_wave2')
; a=make_csv(wna_inp=[75.,255.],phi_inp=[0.,0.],rate_inp=[10.,10.]/2.,filename='wna75255_phi0_wave2')

; a=make_csv(wna_inp=[0.,0.,0.,0.,180.,180.,180.,180.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna0180_phi0_wave8')
; a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5185_phi0_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,195.,195.,195.,195.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna15195_phi0_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,205.,205.,205.,205.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna25205_phi0_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,215.,215.,215.,215.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna35215_phi0_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,225.,225.,225.,225.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna45225_phi0_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,235.,235.,235.,235.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna55235_phi0_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,245.,245.,245.,245.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna65245_phi0_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,255.,255.,255.,255.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna75255_phi0_wave8')



; a=make_csv(wna_inp=[0.,0.,0.,0.,180.,180.,180.,180.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna0180_phi030_wave8')
; a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5185_phi030_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,195.,195.,195.,195.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna15195_phi030_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,205.,205.,205.,205.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna25205_phi030_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,215.,215.,215.,215.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna35215_phi030_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,225.,225.,225.,225.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna45225_phi030_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,235.,235.,235.,235.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna55235_phi030_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,245.,245.,245.,245.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna65245_phi030_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,255.,255.,255.,255.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna75255_phi030_wave8')



; a=make_csv(wna_inp=[0.,0.,0.,0.,180.,180.,180.,180.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna0180_phi0360_wave8')
; a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna5185_phi0360_wave8')
; a=make_csv(wna_inp=[15.,15.,15.,15.,195.,195.,195.,195.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna15195_phi0360_wave8')
; a=make_csv(wna_inp=[25.,25.,25.,25.,205.,205.,205.,205.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna25205_phi0360_wave8')
; a=make_csv(wna_inp=[35.,35.,35.,35.,215.,215.,215.,215.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna35215_phi0360_wave8')
; a=make_csv(wna_inp=[45.,45.,45.,45.,225.,225.,225.,225.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna45225_phi0360_wave8')
; a=make_csv(wna_inp=[55.,55.,55.,55.,235.,235.,235.,235.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna55235_phi0360_wave8')
; a=make_csv(wna_inp=[65.,65.,65.,65.,245.,245.,245.,245.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna65245_phi0360_wave8')
; a=make_csv(wna_inp=[75.,75.,75.,75.,255.,255.,255.,255.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='wna75255_phi0360_wave8')



; rand

a=make_csv(wna_inp=[0.,0.,0.,0.,180.,180.,180.,180.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna0180_phi0_wave8')
a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna5185_phi0_wave8')
a=make_csv(wna_inp=[15.,15.,15.,15.,195.,195.,195.,195.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna15195_phi0_wave8')
a=make_csv(wna_inp=[25.,25.,25.,25.,205.,205.,205.,205.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna25205_phi0_wave8')
a=make_csv(wna_inp=[35.,35.,35.,35.,215.,215.,215.,215.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna35215_phi0_wave8')
a=make_csv(wna_inp=[45.,45.,45.,45.,225.,225.,225.,225.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna45225_phi0_wave8')
a=make_csv(wna_inp=[55.,55.,55.,55.,235.,235.,235.,235.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna55235_phi0_wave8')
a=make_csv(wna_inp=[65.,65.,65.,65.,245.,245.,245.,245.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna65245_phi0_wave8')
a=make_csv(wna_inp=[75.,75.,75.,75.,255.,255.,255.,255.],phi_inp=[0.,0.,0.,0.,0.,0.,0.,0.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna75255_phi0_wave8')



a=make_csv(wna_inp=[0.,0.,0.,0.,180.,180.,180.,180.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna0180_phi030_wave8')
a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna5185_phi030_wave8')
a=make_csv(wna_inp=[15.,15.,15.,15.,195.,195.,195.,195.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna15195_phi030_wave8')
a=make_csv(wna_inp=[25.,25.,25.,25.,205.,205.,205.,205.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna25205_phi030_wave8')
a=make_csv(wna_inp=[35.,35.,35.,35.,215.,215.,215.,215.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna35215_phi030_wave8')
a=make_csv(wna_inp=[45.,45.,45.,45.,225.,225.,225.,225.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna45225_phi030_wave8')
a=make_csv(wna_inp=[55.,55.,55.,55.,235.,235.,235.,235.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna55235_phi030_wave8')
a=make_csv(wna_inp=[65.,65.,65.,65.,245.,245.,245.,245.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna65245_phi030_wave8')
a=make_csv(wna_inp=[75.,75.,75.,75.,255.,255.,255.,255.],phi_inp=[0.,10.,20.,30.,0.,10.,20.,30.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna75255_phi030_wave8')



a=make_csv(wna_inp=[0.,0.,0.,0.,180.,180.,180.,180.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna0180_phi0360_wave8')
a=make_csv(wna_inp=[5.,5.,5.,5.,185.,185.,185.,185.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna5185_phi0360_wave8')
a=make_csv(wna_inp=[15.,15.,15.,15.,195.,195.,195.,195.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna15195_phi0360_wave8')
a=make_csv(wna_inp=[25.,25.,25.,25.,205.,205.,205.,205.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna25205_phi0360_wave8')
a=make_csv(wna_inp=[35.,35.,35.,35.,215.,215.,215.,215.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna35215_phi0360_wave8')
a=make_csv(wna_inp=[45.,45.,45.,45.,225.,225.,225.,225.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna45225_phi0360_wave8')
a=make_csv(wna_inp=[55.,55.,55.,55.,235.,235.,235.,235.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna55235_phi0360_wave8')
a=make_csv(wna_inp=[65.,65.,65.,65.,245.,245.,245.,245.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna65245_phi0360_wave8')
a=make_csv(wna_inp=[75.,75.,75.,75.,255.,255.,255.,255.],phi_inp=[0.,90.,180.,270.,0.,90.,180.,270.],rate_inp=[10.,10.,10.,10.,10.,10.,10.,10.]/8.,filename='rand_fconst_wna75255_phi0360_wave8')





print, 'Fin.'

end

