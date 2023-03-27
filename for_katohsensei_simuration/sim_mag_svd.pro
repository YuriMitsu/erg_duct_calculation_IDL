; .compile '/Users/ampuku/Documents/duct/code/IDL/for_katohsensei_simuration/sim_mag_svd.pro'
pro sim_mag_svd

nfft=4096
stride=1024

get_data,'wfc_b',data=scw
    
if size(scw,/type) ne 8 then begin            
        dprint,'No valid SCW data are not available. Returning...'
endif
if size(scw,/type) eq 8 then begin

;===============================
; Perform FFTs
;===============================

        ndata=n_elements(scw.x)
        scw_fft=dcomplexarr(long(ndata-nfft)/stride+1,nfft,3)
        smat_all=dcomplexarr(long(ndata-nfft)/stride+1,nfft,3,3)
        win=hanning(nfft,/double)*2.0d
        fsamp=1.0/(scw.x[1]-scw.x[0])

        i=0L
        for j=0L,ndata-nfft-1,stride do begin
            for k=0,2 do scw_fft[i,*,k]=fft((scw.y[j:j+nfft-1,k]-mean(scw.y[j:j+nfft-1,k]))*win)
            i++
        endfor
        
        npt=n_elements(scw_fft[0:long(ndata-nfft)/stride-1,0,0])
        t_s=scw.x[0]+(dindgen(i-1)*stride+nfft/2)/fsamp
        freq=findgen(nfft/2)*fsamp/nfft
        bw=fsamp/nfft
        scw_fft_tot=double(abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw)

        scwlim={spec:1,zlog:1,ylog:0,yrange:[0,fsamp/2],ystyle:1}

;===============================
; storing power spectra in tplot vars.
;===============================

        store_data,'wfc_fft_bx',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw,v:freq},lim=scwlim
        store_data,'wfc_fft_by',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw,v:freq},lim=scwlim
        store_data,'wfc_fft_bz',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw,v:freq},lim=scwlim
        store_data,'wfc_fft_all',data={x:t_s,y:scw_fft_tot,v:freq},lim=scwlim

;===============================
; Magnetic SVD analysis
;===============================
    
        wna=scw_fft_tot*0.0D
        azimuth=wna
        plan=wna
        elip=wna
        degpol=wna
        counter_start=0.0
        
        print,' '
        dprint,'Total Number of steps:',npt
        print,' '
        
        for i=0,npt-2 do begin
            
            if 10*double(i)/(npt-1) gt (counter_start+1) then begin
                dprint, strtrim(100*double(i)/(npt-1),2) + ' % Complete '
                dprint, ' Processing step no. :'+ strtrim(i+1,2)
                counter_start++
                dprint,'alpha reverse in S-MAT, XY-rotation in S-MAT'
            endif

            for j=1,n_elements(freq)-2 do begin
            
                ;make soomthed smepctral matrix in frequency
                indx=j+indgen(3)-1
                bubu=total(scw_fft[i,indx,0]*conj(scw_fft[i,indx,0]))
                bubv=total(scw_fft[i,indx,0]*conj(scw_fft[i,indx,1]))
                bubw=total(scw_fft[i,indx,0]*conj(scw_fft[i,indx,2]))
                bvbv=total(scw_fft[i,indx,1]*conj(scw_fft[i,indx,1]))
                bvbw=total(scw_fft[i,indx,1]*conj(scw_fft[i,indx,2]))
                bwbw=total(scw_fft[i,indx,2]*conj(scw_fft[i,indx,2]))

                smat2=[[bubu,bubv,bubw],$
                       [conj(bubv),bvbv,bvbw],$
                       [conj(bubw),conj(bvbw),bwbw]]

                A=[[real_part(smat2[0,0]),real_part(smat2[1,0]),real_part(smat2[2,0])],$
                    [real_part(smat2[0,1]),real_part(smat2[1,1]),real_part(smat2[2,1])],$
                    [real_part(smat2[0,2]),real_part(smat2[1,2]),real_part(smat2[2,2])],$
                    [imaginary(smat2[0,0]),imaginary(smat2[1,0]),imaginary(smat2[2,0])],$
                    [imaginary(smat2[0,1]),imaginary(smat2[1,1]),imaginary(smat2[2,1])],$
                    [imaginary(smat2[0,2]),imaginary(smat2[1,2]),imaginary(smat2[2,2])]]

               la_svd,A,w,u,v,/double
;===============================
; Polarization calculation
;===============================

                idx=sort(w) & w=w(idx) & v=v(idx,*) & u=u(idx,*)
                if (w(2) gt 0.) then begin
                    ;"planarity of polarization: 0 for 3d polar, 1 for 2d or 1d polar"
                    plan[i,j]=1.-sqrt(w(0)/w(2))
                
                    ;"ellipticity of polarization" with the sign of polarization sense
                    if imaginary(smat2[1,0]) lt 0 then elip[i,j]=-w(1)/w(2) else elip[i,j]= w(1)/w(2)
                    
                    ;polar angle of k-vector
                    wna[i,j]=abs(atan(sqrt(v[0,0]^2+v[0,1]^2)/v[0,2])/!dtor)

                    ;azimuthal angle of k-vector
                    if v[0,0] ge 0.0 then azimuth[i,j]=atan(v[0,1]/v[0,0])/!dtor
                    if v[0,0] lt 0.0 and v[0,1] lt 0.0 then azimuth[i,j]=(atan(v[0,1]/v[0,0])-!dpi)/!dtor
                    if v[0,0] lt 0.0 and v[0,1] ge 0.0 then azimuth[i,j]=(atan(v[0,1]/v[0,0])+!dpi)/!dtor

                    ;degree of polarization
                    degpol[i,j]=w[2]/total(w)
                endif

;                if j eq 1 then dprint,w,w(1)/w(2),elip[i,j]

            endfor
        endfor        
        
;===============================
; Storing data into tplot vars.
;===============================

        wnalim={spec:1,zlog:0,ylog:0,yrange:[0,fsamp/2],ystyle:1,zrange:[0.0,90.0]}
        azimuthlim={spec:1,zlog:0,ylog:0,yrange:[0,fsamp/2],ystyle:1,zrange:[-180.0,180.0]}
        planlim={spec:1,zlog:0,ylog:0,yrange:[0,fsamp/2],ystyle:1,zrange:[0.0,1.0]}
        eliplim={spec:1,zlog:0,ylog:0,yrange:[0,fsamp/2],ystyle:1,zrange:[-1.0,1.0]}

        store_data,'sim_wfc_wna_msvd',data={x:t_s,y:wna,v:freq},dlim=wnalim
        store_data,'sim_wfc_azim_msvd',data={x:t_s,y:azimuth,v:freq},dlim=azimuthlim
        store_data,'sim_wfc_plan_msvd',data={x:t_s,y:plan,v:freq},dlim=planlim
        store_data,'sim_wfc_elip_msvd',data={x:t_s,y:elip,v:freq},dlim=eliplim
        store_data,'sim_wfc_degpol_msvd',data={x:t_s,y:degpol,v:freq},dlim=planlim

        set_plot, 'X'
        window, 0, xsize=1500, ysize=900
        ; window, 0, xsize=700, ysize=400
        !p.background = 255
        !p.color = 0

        ylim,['wfc_fft_all','sim_wfc_wna_msvd','sim_wfc_plan_msvd','sim_wfc_elip_msvd','sim_wfc_azim_msvd'],1e4,1e6, 1
        zlim,'wfc_fft_all',1e-10,1e-1
        tplot,['wfc_fft_all','sim_wfc_wna_msvd','sim_wfc_plan_msvd','sim_wfc_elip_msvd','sim_wfc_azim_msvd']

endif
end