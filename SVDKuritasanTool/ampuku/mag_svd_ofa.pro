; Created by Satoshi Kurita!!
; Added by Ampuku.
; .compile '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/ampuku/mag_svd_ofa.pro'

; mag_svd_test_ver_ofa,wna_inp=30,phi_inp=0,rate_inp=0,enr=1e-3*(8192L/2),bnr=1e-2*(8192L/2)
; mag_svd_test_ver_ofa,wna_inp=[10,60],phi_inp=[0,0],rate_inp=[1., 1.],enr=1e-3*(8192L/2),bnr=1e-2*(8192L/2)


pro mag_svd_ofa,wna_inp=wna_inp,phi_inp=phi_inp,rate_inp=rate_inp,enr=enr,bnr=bnr,f_average=f_average,t_average=t_average

makewave_ofa,wna=wna_inp,phi=phi_inp,rate=rate_inp,enr=enr,bnr=bnr
print, 'use makewave_ofa'

get_data,'bfield',data=scw

help, scw

; if size(scw,/type) eq 8 then begin

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
        bw=fsamp/nfft ; 周波数分解能
        scw_fft_tot=double(abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw+abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw)
        scwlim={spec:1,zlog:1,ylog:0,yrange:[100,1000],ystyle:1}

; storing power spectra in tplot vars.
        fft_x=abs(scw_fft[0:npt-1,0:nfft/2-1,0])^2/bw
        fft_y=abs(scw_fft[0:npt-1,0:nfft/2-1,1])^2/bw
        fft_z=abs(scw_fft[0:npt-1,0:nfft/2-1,2])^2/bw
        store_data,'scw_fft_x_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:fft_x,v:freq},lim=scwlim
        ; zlim,'scw_fft_x',[min(fft_x),max(fft_x)]
        ; zlim,'scw_fft_x',[1e-25, 1e-20]
        store_data,'scw_fft_y_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:fft_y,v:freq},lim=scwlim
        ; zlim,'scw_fft_y',[min(fft_y),max(fft_y)]
        ; zlim,'scw_fft_y',[1e-25, 1e-20]
        store_data,'scw_fft_z_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:fft_z,v:freq},lim=scwlim
        ; zlim,'scw_fft_z',[min(fft_z),max(fft_z)]
        ; zlim,'scw_fft_z',[1e-25, 1e-20]
        store_data,'scw_fft_all_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:scw_fft_tot,v:freq},lim=scwlim
        store_data,'scw_fft_all',data={x:t_s,y:scw_fft_tot,v:freq},lim=scwlim

        scw_tnames=tnames('scw_*')
        ; ylim, scw_tnames, 0, 4000, 0
        ; zlim, scw_tnames, 1e-23, 1e-21, 1
        ; zlim,'scw_fft_all', 1e-22, 1e-20

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
        
        if not keyword_set(t_average) then t_average=4
        for i=0,npt-t_average do begin

;===============================
; same S-matrix creation procedure as OFA is implemented 
;===============================

            indx_t=i+indgen(t_average)

            bubu=total(scw_fft[indx_t,0:nfft/2-1,0]*conj(scw_fft[indx_t,0:nfft/2-1,0]),1)/float(t_average)
            bubv=total(scw_fft[indx_t,0:nfft/2-1,0]*conj(scw_fft[indx_t,0:nfft/2-1,1]),1)/float(t_average)
            bubw=total(scw_fft[indx_t,0:nfft/2-1,0]*conj(scw_fft[indx_t,0:nfft/2-1,2]),1)/float(t_average)

            bvbv=total(scw_fft[indx_t,0:nfft/2-1,1]*conj(scw_fft[indx_t,0:nfft/2-1,1]),1)/float(t_average)
            bvbw=total(scw_fft[indx_t,0:nfft/2-1,1]*conj(scw_fft[indx_t,0:nfft/2-1,2]),1)/float(t_average)

            bwbw=total(scw_fft[indx_t,0:nfft/2-1,2]*conj(scw_fft[indx_t,0:nfft/2-1,2]),1)/float(t_average)

            if 10*double(i)/(npt-1) gt (counter_start+1) then begin
                dprint, strtrim(100*double(i)/(npt-1),2) + ' % Complete '
                dprint, ' Processing step no. :'+ strtrim(i+1,2)
                counter_start++
            endif

            if not keyword_set(f_average) then f_average=1
            for j=(f_average-1)/2,n_elements(freq)-(f_average+1)/2 do begin
            
              indx_f=j+indgen(f_average)-1
             ; indx_f=j

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

        ; store_data,'waveangle_th_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:wna,v:freq},dlim=wnalim
        store_data,'waveangle_th_msvd',data={x:t_s,y:wna,v:freq},dlim=wnalim
        ; store_data,'waveangle_phi_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:phi,v:freq},dlim=philim
        store_data,'waveangle_phi_msvd',data={x:t_s,y:phi,v:freq},dlim=philim
        ; store_data,'planarity_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:plan,v:freq},dlim=planlim
        store_data,'planarity_msvd',data={x:t_s,y:plan,v:freq},dlim=planlim
        ; store_data,'elipricity_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'),data={x:t_s,y:elip,v:freq},dlim=eliplim

;===============================
; mask
;===============================
        ; get_data,'scw_fft_all',data=scw_fft_all_data
        ; cut_f=5e-16

        ; get_data, 'waveangle_th_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'), data=data, dlim=dlim, lim=lim
        ; data.y[where(scw_fft_all_data.y LT cut_f)] = 'NaN'
        ; store_data, 'waveangle_th_msvd_mask_'+string(n_elements(wna_inp), FORMAT='(i0)'), data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
        ; get_data, 'waveangle_phi_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'), data=data, dlim=dlim, lim=lim
        ; data.y[where(scw_fft_all_data.y LT cut_f)] = 'NaN'
        ; store_data, 'waveangle_phi_msvd_mask_'+string(n_elements(wna_inp), FORMAT='(i0)'), data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
        ; get_data, 'planarity_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'), data=data, dlim=dlim, lim=lim
        ; data.y[where(scw_fft_all_data.y LT cut_f)] = 'NaN'
        ; store_data, 'planarity_msvd_mask_'+string(n_elements(wna_inp), FORMAT='(i0)'), data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
        ; get_data, 'elipricity_msvd_'+string(n_elements(wna_inp), FORMAT='(i0)'), data=data, dlim=dlim, lim=lim
        ; data.y[where(scw_fft_all_data.y LT cut_f)] = 'NaN'
        ; store_data, 'elipricity_msvd_mask_'+string(n_elements(wna_inp), FORMAT='(i0)'), data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

        ; mask_tname = tnames('*_mask*')
        ; ylim, mask_tname, 300, 900, 0
        ; ; ylim, mask_tname, 20, 1000, 1
        ; scw_names=tnames('scw_*')
        ; ylim, scw_names, 300, 900, 0
        ; ; ylim, scw_names, 20, 1000, 1
        ; all_tnames = tnames('*_msvd*')
        ; ylim, all_tnames, 300, 900, 0
        ; ; ylim, all_tnames, 20, 1000, 1

; endif

end