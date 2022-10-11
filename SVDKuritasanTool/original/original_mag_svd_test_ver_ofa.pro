pro mag_svd_test_ver_ofa
;,wna_in=wna_in,dwna_in=dwna_in,phi_in=phi_in,dphi_in=dphi_in

;makewave2,wna_in=wna_in,dwna_in=dwna_in,phi_in=phi_in,dphi_in=dphi_in
makewave_ver_ofa,wna=20.0,phi=40.0,/rmode

get_data,'bfield',data=scw

if size(scw,/type) eq 8 then begin

;===============================
; Perform FFTs
;===============================

        nfft=1024L
        stride=nfft
        fsamp=1.0/(scw.x[1]-scw.x[0])

        ndata=n_elements(scw.x)
        scw_fft=dcomplexarr(long(ndata-nfft)/stride+1,nfft,3)
        win=hanning(nfft,/double)*8/3.
        
        i=0L
        for j=0L,ndata-nfft-1,stride do begin
            for k=0,2 do scw_fft[i,*,k]=fft(scw.y[j:j+nfft-1,k]*win)
            i++
        endfor

        npt=n_elements(scw_fft[0:long(ndata-nfft)/stride-1,0,0])
        t_s=scw.x[0]+(dindgen(i-1)*stride+nfft/2)/fsamp
        freq=findgen(nfft/2)*fsamp/nfft
        bw=fsamp/nfft
        scw_fft_tot=double(abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw)
        scwlim={spec:1,zlog:1,ylog:0,yrange:[100,1000],ystyle:1}

; storing power spectra in tplot vars.
        store_data,'scw_fft_x',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw,v:freq},lim=scwlim
        store_data,'scw_fft_y',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw,v:freq},lim=scwlim
        store_data,'scw_fft_z',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw,v:freq},lim=scwlim
        store_data,'scw_fft_all',data={x:t_s,y:scw_fft_tot,v:freq},lim=scwlim

;===============================
; Magnetic SVD analysis
;===============================

        wna=scw_fft_tot*0.0D
        phi=scw_fft_tot*0.0D
        plan=wna
        elip=wna
        degpol=wna
        counter_start=0.0
        
        print,' '
        dprint,'Total Number of steps:',npt
        print,' '
        
        for i=0,npt-4 do begin

;===============================
; same S-matrix creation procedure as OFA is implemented 
;===============================

            indx_t=i+indgen(4)

            bubu=total(scw_fft[indx_t,0:nfft/2-1,0]*conj(scw_fft[indx_t,0:nfft/2-1,0]),1)/4.
            bubv=total(scw_fft[indx_t,0:nfft/2-1,0]*conj(scw_fft[indx_t,0:nfft/2-1,1]),1)/4.
            bubw=total(scw_fft[indx_t,0:nfft/2-1,0]*conj(scw_fft[indx_t,0:nfft/2-1,2]),1)/4.

            bvbv=total(scw_fft[indx_t,0:nfft/2-1,1]*conj(scw_fft[indx_t,0:nfft/2-1,1]),1)/4.
            bvbw=total(scw_fft[indx_t,0:nfft/2-1,1]*conj(scw_fft[indx_t,0:nfft/2-1,2]),1)/4.
            
            bwbw=total(scw_fft[indx_t,0:nfft/2-1,2]*conj(scw_fft[indx_t,0:nfft/2-1,2]),1)/4.

            if 10*double(i)/(npt-1) gt (counter_start+1) then begin
                dprint, strtrim(100*double(i)/(npt-1),2) + ' % Complete '
                dprint, ' Processing step no. :'+ strtrim(i+1,2)
                counter_start++
            endif

            for j=1,n_elements(freq)-2 do begin
            
;               indx_f=j+indgen(3)-1
                indx_f=j

                A=[[total(real_part(bubu[indx_f])),     total(real_part(bubv[indx_f])),     total(real_part(bubw[indx_f]))],$
                   [total(real_part(bubv[indx_f])),     total(real_part(bvbv[indx_f])),     total(real_part(bvbw[indx_f]))],$
                   [total(real_part(bubw[indx_f])),     total(real_part(bvbw[indx_f])),     total(real_part(bwbw[indx_f]))],$
                   [0.0                           ,total(-1.0*imaginary(bubv[indx_f])),total(-1.0*imaginary(bubw[indx_f]))],$
                   [total(imaginary(bubv[indx_f])),     0.0                           ,total(-1.0*imaginary(bvbw[indx_f]))],$
                   [total(imaginary(bubw[indx_f])),     total(imaginary(bvbw[indx_f])),     0.0                           ]]

;                A=[[total(real_part(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,0]))),total(real_part(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,1]))),total(real_part(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,2])))],$
;                        [total(real_part(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,1]))),total(real_part(scw_fft[indx_t,indx_f,1]*conj(scw_fft[indx_t,indx_f,1]))),total(real_part(scw_fft[indx_t,indx_f,1]*conj(scw_fft[indx_t,indx_f,2])))],$
;                        [total(real_part(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,2]))),total(real_part(scw_fft[indx_t,indx_f,2]*conj(scw_fft[indx_t,indx_f,1]))),total(real_part(scw_fft[indx_t,indx_f,2]*conj(scw_fft[indx_t,indx_f,2])))],$
;                        [0.0,total(-1.0*imaginary(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,1]))),total(-1.0*imaginary(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,2])))],$
;                        [total(imaginary(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,1]))),0.0,total(-1.0*imaginary(scw_fft[indx_t,indx_f,1]*conj(scw_fft[indx_t,indx_f,2])))],$
;                        [total(imaginary(scw_fft[indx_t,indx_f,0]*conj(scw_fft[indx_t,indx_f,2]))),total(imaginary(scw_fft[indx_t,indx_f,1]*conj(scw_fft[indx_t,indx_f,2]))),0.0]]/3.
            
                la_svd,A,w,u,v,/double

;===============================
; Polarization calculation
;===============================

                idx=sort(w) & w=w(idx) & v=v(idx,*) & u=u(idx,*)
                if (w(2) gt 0.) then begin
                    ;"planarity"
                    plan[i,j]=1.-sqrt(w(0)/w(2))
                
                    ;"ellipticity" with the sign of polarization sense
                    if imaginary(scw_fft[i,j,0]*conj(scw_fft[i,j,1])) lt 0 then elip[i,j]=-w(1)/w(2) else elip[i,j]= w(1)/w(2)
                    
                    ; magnetic SVD cannot reveal the sign of k-vector, so the k-vector direction is changed to have kz > 0.
                    if v[0,2] lt 0.0 then v[0,*]=-1.0*v[0,*]
                    
                    ;polar angle of k-vector
                    wna[i,j]=atan(sqrt(v[0,0]^2+v[0,1]^2),v[0,2])/!dtor
                
                    ;azimuth angle of k-vector
                    if v[0,0] ge 0 then phi[i,j]=atan(v[0,1]/v[0,0])/!dtor
                    if v[0,0] lt 0 and v[0,1] lt 0.0 then phi[i,j]=atan(v[0,1]/v[0,0])/!dtor-180.0
                    if v[0,0] lt 0 and v[0,1] ge 0.0 then phi[i,j]=atan(v[0,1]/v[0,0])/!dtor+180.0
                endif
            endfor
        endfor        

;===============================
; Storing data into tplot vars.
;===============================

        wnalim={spec:1,zlog:0,ylog:0,yrange:[100,4096],ystyle:1,zrange:[0.0,90.0]}
        philim={spec:1,zlog:0,ylog:0,yrange:[100,4096],ystyle:1,zrange:[-180.0,180.0]}
        planlim={spec:1,zlog:0,ylog:0,yrange:[100,4096],ystyle:1,zrange:[0.0,1.0]}
        eliplim={spec:1,zlog:0,ylog:0,yrange:[100,4096],ystyle:1,zrange:[-1.0,1.0]}

        store_data,'waveangle_th_msvd',data={x:t_s,y:wna,v:freq},dlim=wnalim
        store_data,'waveangle_phi_msvd',data={x:t_s,y:phi,v:freq},dlim=philim
        store_data,'planarity_msvd',data={x:t_s,y:plan,v:freq},dlim=planlim
        store_data,'elipricity_msvd',data={x:t_s,y:elip,v:freq},dlim=eliplim
    
endif

end