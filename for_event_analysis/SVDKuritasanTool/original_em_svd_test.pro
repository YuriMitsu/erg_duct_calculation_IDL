pro em_svd_test,wna_inp=wna_inp,phi_inp=phi_inp

makewave,wna=wna_inp,phi=phi_inp

get_data,'bfield',data=scw
get_data,'efield',data=efw

if size(scw,/type) ne 8 or size(efw,/type) then begin            
    dprint,'No valid data are not available. Returning...'
endif

if size(scw,/type) eq 8 and size(efw,/type) eq 8 then begin

;===============================
; Perform FFTs
;===============================

        nfft=8192L
        stride=nfft

        ndata=n_elements(scw.x)
        efw_fft=dcomplexarr(long(ndata-nfft)/stride+1,nfft,3)
        scw_fft=dcomplexarr(long(ndata-nfft)/stride+1,nfft,3)
        win=hanning(nfft,/double)*8/3.
        
        i=0L
        for j=0L,ndata-nfft-1,stride do begin
            for k=0,2 do efw_fft[i,*,k]=fft(efw.y[j:j+nfft-1,k]*win)
            for k=0,2 do scw_fft[i,*,k]=fft(scw.y[j:j+nfft-1,k]*win)
            i++
        endfor
        
        npt=n_elements(scw_fft[0:long(ndata-nfft)/stride-1,0,0])
        t_e=efw.x[0]+(dindgen(i-1)*stride+nfft/2)/8192.
        t_s=scw.x[0]+(dindgen(i-1)*stride+nfft/2)/8192.
        freq=findgen(nfft/2)*8192/nfft
        bw=8192/nfft
        efw_fft_tot=double(abs(efw_fft[0:npt-1,0:nfft/2-1,0])^2/bw+abs(efw_fft[0:npt-1,0:nfft/2-1,1])^2/bw+abs(efw_fft[0:npt-1,0:nfft/2-1,2])^2/bw)
        scw_fft_tot=double(abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw)

        efwlim={spec:1,zlog:1,ylog:0,yrange:[100,4096],ystyle:1}
        scwlim={spec:1,zlog:1,ylog:0,yrange:[100,4096],ystyle:1}
;        store_data,'th'+sc+'_scw_fft_x',data={x:t_s,y:abs(scw_fft[0:long(ndata-nfft)/stride-1,0:nfft/2-1,0])^2/bw,v:freq},lim=scwlim
;        store_data,'th'+sc+'_scw_fft_y',data={x:t_s,y:abs(scw_fft[0:long(ndata-nfft)/stride-1,0:nfft/2-1,1])^2/bw,v:freq},lim=scwlim
;        store_data,'th'+sc+'_scw_fft_z',data={x:t_s,y:abs(scw_fft[0:long(ndata-nfft)/stride-1,0:nfft/2-1,2])^2/bw,v:freq},lim=scwlim

; storing power spectra in tplot vars.
        store_data,'efw_fft_x',data={x:t_s,y:abs(efw_fft[0:npt-1,0:nfft/2-1,0])^2/bw,v:freq},lim=efwlim
        store_data,'efw_fft_y',data={x:t_s,y:abs(efw_fft[0:npt-1,0:nfft/2-1,1])^2/bw,v:freq},lim=efwlim
        store_data,'efw_fft_z',data={x:t_s,y:abs(efw_fft[0:npt-1,0:nfft/2-1,2])^2/bw,v:freq},lim=efwlim
        store_data,'efw_fft_all',data={x:t_s,y:efw_fft_tot,v:freq},lim=efwlim

        store_data,'scw_fft_x',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw,v:freq},lim=scwlim
        store_data,'scw_fft_y',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw,v:freq},lim=scwlim
        store_data,'scw_fft_z',data={x:t_s,y:abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw,v:freq},lim=scwlim
        store_data,'scw_fft_all',data={x:t_s,y:scw_fft_tot,v:freq},lim=scwlim

;===============================
; Electromagnetic SVD analysis
;===============================

        wna=scw_fft_tot*0.0D
        phi=scw_fft_tot*0.0D
        plan=wna
        vcc=3.0e8
        counter_start=0.0
        print,' '
        dprint,'Total Number of steps:',npt
        print,' '
        
        for i=0L,npt-1 do begin
            
            if 10*double(i)/(npt-1) gt (counter_start+1) then begin
                dprint, strtrim(100*double(i)/(npt-1),2) + ' % Complete '
                dprint, ' Processing step no. :'+ strtrim(i+1,2)
                counter_start++
            endif

            for j=0,n_elements(freq)-1 do begin

; making spectral matrix (first version, no emsemble average...)
                indx=j
                z=[vcc*scw_fft[i,indx,0],vcc*scw_fft[i,indx,1],vcc*scw_fft[i,indx,2],efw_fft[i,indx,0],efw_fft[i,indx,1],efw_fft[i,indx,2]]

                Atmp=dcomplexarr(3,18)
                Btmp=dcomplexarr(18)

                for ii=1,6 do begin
                    Atmp[*,(ii-1)*3:ii*3-1]=[[0.0,z[5],-z[4]],[-z[5],0.0,z[3]],[z[4],-z[3],0.0]]*conj(z[ii-1])
                    Btmp[(ii-1)*3:ii*3-1]=[z[0],z[1],z[2]]*conj(z[ii-1])
                endfor

                A=0.0 & B=0.0

                append_array,A,transpose(real_part(Atmp))
                append_array,A,transpose(imaginary(Atmp))

                append_array,B,real_part(Btmp)
                append_array,B,imaginary(Btmp)

; making spectral matrix (first version) end

; making spectral matrix (emsenble averagin is implemented, but something is wronng...)
;
;                indx=j+indgen(1)-1
;
;                bubu=total(scw_fft[i,indx,0]*conj(scw_fft[i,indx,0]))/n_elements(indx)
;                bvbv=total(scw_fft[i,indx,1]*conj(scw_fft[i,indx,1]))/n_elements(indx)
;                bwbw=total(scw_fft[i,indx,2]*conj(scw_fft[i,indx,2]))/n_elements(indx)
;                eueu=total(efw_fft[i,indx,0]*conj(efw_fft[i,indx,0]))/n_elements(indx)
;                evev=total(efw_fft[i,indx,1]*conj(efw_fft[i,indx,1]))/n_elements(indx)
;                ewew=total(efw_fft[i,indx,2]*conj(efw_fft[i,indx,2]))/n_elements(indx)
;
;                bubv=total(scw_fft[i,indx,0]*conj(scw_fft[i,indx,1]))/n_elements(indx)
;                bubw=total(scw_fft[i,indx,0]*conj(scw_fft[i,indx,2]))/n_elements(indx)
;                bvbw=total(scw_fft[i,indx,1]*conj(scw_fft[i,indx,2]))/n_elements(indx)
;                bueu=total(scw_fft[i,indx,0]*conj(efw_fft[i,indx,0]))/n_elements(indx)
;                buev=total(scw_fft[i,indx,0]*conj(efw_fft[i,indx,1]))/n_elements(indx)
;                buew=total(scw_fft[i,indx,0]*conj(efw_fft[i,indx,2]))/n_elements(indx)
;                bveu=total(scw_fft[i,indx,1]*conj(efw_fft[i,indx,0]))/n_elements(indx)
;                bvev=total(scw_fft[i,indx,1]*conj(efw_fft[i,indx,1]))/n_elements(indx)
;                bvew=total(scw_fft[i,indx,1]*conj(efw_fft[i,indx,2]))/n_elements(indx)
;                bweu=total(scw_fft[i,indx,2]*conj(efw_fft[i,indx,0]))/n_elements(indx)
;                bwev=total(scw_fft[i,indx,2]*conj(efw_fft[i,indx,1]))/n_elements(indx)
;                bwew=total(scw_fft[i,indx,2]*conj(efw_fft[i,indx,2]))/n_elements(indx)
;                euev=total(efw_fft[i,indx,0]*conj(efw_fft[i,indx,1]))/n_elements(indx)
;                euew=total(efw_fft[i,indx,0]*conj(efw_fft[i,indx,2]))/n_elements(indx)
;                evew=total(efw_fft[i,indx,1]*conj(efw_fft[i,indx,2]))/n_elements(indx)
;
;                Atmp=dcomplexarr(18,3)
;                Btmp=dcomplexarr(18)
;
;                Atmp[0:2,*]=vcc*transpose([[0.0,conj(buew),-conj(buev)],$
;                                          [-conj(buew),0.0,conj(bueu)],$
;                                          [conj(buev),-conj(bueu),0.0]])
;
;                Atmp[3:5,*]=vcc*transpose([[0.0,conj(bvew),-conj(bvev)],$
;                                          [-conj(bvew),0.0,conj(bveu)],$
;                                          [conj(bvev),-conj(bveu),0.0]])
;
;                Atmp[6:8,*]=vcc*transpose([[0.0,conj(bwew),-conj(bwev)],$
;                                          [-conj(bwew),0.0,conj(bweu)],$
;                                          [conj(bwev),-conj(bweu),0.0]])
;
;                Atmp[9:11,*]=transpose([[0.0,conj(euew),-conj(euev)],$
;                                       [-conj(euew),0.0,conj(eueu)],$
;                                       [conj(euev),-conj(eueu),0.0]])
;
;                Atmp[12:14,*]=transpose([[0.0,conj(evew),-conj(evev)],$
;                                        [-conj(evew),0.0,euev],$
;                                        [conj(evev),-euev,0.0]])
;
;                Atmp[15:17,*]=transpose([[0.0,ewew,-evew],$
;                                        [-ewew,0.0,euew],$
;                                        [evew,-euew,0.0]])
;
;
;                Btmp[0:2]=vcc*vcc*[bubu,conj(bubv),conj(bubw)]
;
;                Btmp[3:5]=vcc*vcc*[bubv,bvbv,conj(bvbw)]
;
;                Btmp[6:8]=vcc*vcc*[bubw,bvbw,bvbw]
;
;                Btmp[9:11]=vcc*[bueu,bveu,bweu]
;
;                Btmp[12:14]=vcc*[buev,bvev,bwev]
;
;                Btmp[15:17]=vcc*[buew,bvew,bwew]
;
;                A=0 & B=0
;
;                append_array,A,real_part(Atmp)
;                append_array,A,imaginary(Atmp)
;
;                append_array,B,real_part(Btmp)
;                append_array,B,imaginary(Btmp)
; making spectral matrix (emsenble averagin is implemented, but something is wronng...) end

                la_svd,transpose(A),w,u,v,/double

; Calculation of refractive index

                sv=dblarr(3,3) & sv[0,0]=w[0] & sv[1,1]=w[1] & sv[2,2]=w[2]
                k=v ## invert(sv) ## transpose(u) ## transpose(B)
                beta_mat=A # reform(k)
                k=k/sqrt(k[0]^2.+k[1]^2.+k[2]^2.)

;===============================
; Polarization calculation
;===============================
                
                if (min(w) gt 0.) then begin
                    ;k-vector (perp to polarization plane) direction
                    wna[i,j]=atan(sqrt(k[0]^2+k[1]^2),k[2])/!dtor

                    ;azimuth angle of k-vector
                    if k[0] ge 0 then phi[i,j]=atan(k[1]/k[0])/!dtor
                    if k[0] lt 0 and k[1] lt 0.0 then phi[i,j]=atan(k[1]/k[0])/!dtor-180.0
                    if k[0] lt 0 and k[1] ge 0.0 then phi[i,j]=atan(k[1]/k[0])/!dtor+180.0

                    ;Electromagnetic planarity                
                    n_plan=0.0 & d_plan=n_plan

                    for ijk=0,35 do begin
                        n_plan=n_plan+(beta_mat[ijk]-B[ijk])^2
                        d_plan=d_plan+(abs(beta_mat[ijk])+abs(B[ijk]))^2
                    endfor

                    plan[i,j]=1.0-sqrt(n_plan/d_plan)

                endif
            endfor
        endfor        
        
; Storing data into tplot vars.
        wnalim={spec:1,zlog:0,ylog:0,yrange:[100,4096],ystyle:1,zrange:[0.0,180.0]}
        philim={spec:1,zlog:0,ylog:0,yrange:[100,4096],ystyle:1,zrange:[-180.0,180.0]}
        planlim={spec:1,zlog:0,ylog:0,yrange:[100,4096],ystyle:1,zrange:[0.0,1.0]}

        store_data,'waveangle_th_emsvd',data={x:t_s,y:wna,v:freq},dlim=wnalim
        store_data,'waveangle_phi_emsvd',data={x:t_s,y:phi,v:freq},dlim=philim
        store_data,'planarity_emsvd',data={x:t_s,y:plan,v:freq},dlim=planlim
    
endif

end