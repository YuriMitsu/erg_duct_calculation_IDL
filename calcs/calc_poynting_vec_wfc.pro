; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_poynting_vec_wfc.pro'
; timespan, '2017-07-03/04:32:00', 1, /min
; timespan, '2017-07-03/04:32:28', 7, /sec


pro calc_poynting_vec_wfc

  ; *****************
  ; calculate wave params
  ; *****************

  if not keyword_set(cut_f) then cut_f = 1E-2 ;nT

  uname = 'erg_project'
  pass = 'geospace'

  ; *****************
  ; 1.load data
  ; *****************

  ;磁場読み込み
  erg_load_mgf, datatype='8sec', uname=uname, pass=pass
  erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass
  erg_load_mgf, datatype='8sec', coord='sgi', uname=uname, pass=pass

  ;WFC読み込み
;   erg_load_pwe_wfc, uname=uname, pass=pass  

  
  ; *****************
  ; 2.2.OFA-MATRIX B to spacrla matrix
  ; *****************
  pr_matrix = 'erg_pwe_wfc_l2_'

  get_data, pr_matrix + 'e_65khz_Ex_waveform', data=exwave
  get_data, pr_matrix + 'e_65khz_Ey_waveform', data=eywave

;===============================
; Perform FFTs
;===============================

  rre=[[exwave.y], [eywave.y]]

        nfft=2048L
        stride=nfft
        fsamp=1.0/(exwave.x[1]-exwave.x[0])

        ndata=n_elements(exwave.x)
        wavee_fft=dcomplexarr(long(ndata-nfft)/stride+1,nfft,2)
        win=hanning(nfft,/double)*8/3.

        ; for i=0L,(ndata-nfft)/stride do for k=0,1 do wavee_fft[i,*,k]=fft(rre[stride*i:stride*i+nfft-1,k]*win)
        i=0L
        for j=0L,ndata-nfft-1,stride do begin
            for k=0,1 do wavee_fft[i,*,k]=fft(rre[j:j+nfft-1,k]*win)
            i++
        endfor


        npt=n_elements(wavee_fft[0:long(ndata-nfft)/stride-1,0,0])
        t_se=exwave.x[0]+(dindgen(i-1)*stride+nfft/2)/fsamp
        freq=findgen(nfft/2)*fsamp/nfft
        bw=fsamp/nfft ; 周波数分解能
        wavee_fft_tot=double(abs(wavee_fft[0:npt-1,0:nfft/2-1,0])^2/bw+abs(wavee_fft[0:npt-1,0:nfft/2-1,1])^2/bw)
        wavelim={spec:1,zlog:0,ylog:0,yrange:[100,1000],ystyle:1}

        c_ex=wavee_fft[0:npt-1,0:nfft/2-1,0]
        c_ey=wavee_fft[0:npt-1,0:nfft/2-1,1]

        store_data,'wave_fft_ex', data={x:t_se,y:abs(wavee_fft[0:npt-1,0:nfft/2-1,0])^2/bw,v:freq},lim=wavelim
        ; zlim,'wave_fft_ex',[min(c_ex),max(c_ex)]
        ylim,'wave_fft_ex',[min(freq),max(freq)]
        store_data,'wave_fft_ey', data={x:t_se,y:abs(wavee_fft[0:npt-1,0:nfft/2-1,1])^2/bw,v:freq},lim=wavelim
        ; zlim,'wave_fft_ey',[min(c_ey),max(c_ey)]
        ylim,'wave_fft_ey',[min(freq),max(freq)]
        store_data,'wave_fft_eall', data={x:t_se,y:wavee_fft_tot,v:freq},lim=wavelim

  get_data, pr_matrix + 'b_65khz_Bx_waveform', data=bxwave
  get_data, pr_matrix + 'b_65khz_By_waveform', data=bywave
  get_data, pr_matrix + 'b_65khz_Bz_waveform', data=bzwave
  
  rrb=[[bxwave.y], [bywave.y], [bzwave.y]]

        ndata=n_elements(bxwave.x)
        waveb_fft=dcomplexarr(long(ndata-nfft)/stride+1,nfft,3)

        i=0L
        for j=0L,ndata-nfft-1,stride do begin
            for k=0,2 do waveb_fft[i,*,k]=fft(rrb[j:j+nfft-1,k]*win)
            i++
        endfor

        npt=n_elements(waveb_fft[0:long(ndata-nfft)/stride-1,0,0])
        t_sb=bxwave.x[0]+(dindgen(i-1)*stride+nfft/2)/fsamp
        freq=findgen(nfft/2)*fsamp/nfft
        bw=fsamp/nfft ; 周波数分解能
        waveb_fft_tot=double(abs(waveb_fft[0:npt-1,0:nfft/2-1,0])^2/bw+abs(waveb_fft[0:npt-1,0:nfft/2-1,1])^2/bw+abs(waveb_fft[0:npt-1,0:nfft/2-1,2])^2/bw)
        wavelim={spec:1,zlog:1,ylog:0,yrange:[100,1000],ystyle:1}

        c_bx=waveb_fft[0:npt-1,0:nfft/2-1,0]
        c_by=waveb_fft[0:npt-1,0:nfft/2-1,1]
        c_bz=waveb_fft[0:npt-1,0:nfft/2-1,2]

        store_data,'wave_fft_bx', data={x:t_sb,y:abs(waveb_fft[0:npt-1,0:nfft/2-1,0])^2/bw,v:freq},lim=wavelim
        ; zlim,'wave_fft_bx',[min(c_bx),max(abs(waveb_fft[0:npt-1,0:nfft/2-1,0])^2/bw)]
        ylim,'wave_fft_bx',[min(freq),max(freq)]
        store_data,'wave_fft_by', data={x:t_sb,y:abs(waveb_fft[0:npt-1,0:nfft/2-1,1])^2/bw,v:freq},lim=wavelim
        ; zlim,'wave_fft_by',[min(c_by),max(abs(waveb_fft[0:npt-1,0:nfft/2-1,1])^2/b)]
        ylim,'wave_fft_by',[min(freq),max(freq)]
        store_data,'wave_fft_by', data={x:t_sb,y:abs(waveb_fft[0:npt-1,0:nfft/2-1,2])^2/bw,v:freq},lim=wavelim
        ; zlim,'wave_fft_by',[min(c_by),max(]
        ylim,'wave_fft_by',[min(freq),max(freq)]
        store_data,'wave_fft_ball', data={x:t_sb,y:waveb_fft_tot,v:freq},lim=wavelim


  ; ************************************
  ; 7.2.Poynting vector
  ; ************************************
  ;  https://ergsc.isee.nagoya-u.ac.jp/data/website/archives/documents/SPEDAS_training_session/SPEDAS_training_advanced_20180328.pdf を参考に作成

;   erg_load_pwe_ofa, datatype='complex', uname=uname, pass=pass
;   pr_complex = 'erg_pwe_wfc_complex_'

;   get_data, pr_complex + 'Ex_132', data=data_ex, dlim=dlim, lim=lim
;   if size(data_ex,/type) eq 8 then begin
;     c_ex = dcomplex(data_ex.y[*,*,0]*1E-3, data_ex.y[*,*,1]*1E-3)
;     get_data, pr_complex + 'Ey_132', data=data, dlim=dlim, lim=lim
;     c_ey = dcomplex(data.y[*,*,0]*1E-3, data.y[*,*,1]*1E-3)
;     get_data, 'wave_fft_bx', data=data_bx, dlim=dlim, lim=lim
;     c_bx = dcomplex(data_bx.y[*,*,0]*1E-12, data_bx.y[*,*,1]*1E-12)
;     get_data, pr_complex + 'By_132', data=data, dlim=dlim, lim=lim
;     c_by = dcomplex(data.y[*,*,0]*1E-12, data.y[*,*,1]*1E-12)
;     get_data, pr_complex + 'Bz_132', data=data, dlim=dlim, lim=lim
;     c_bz = dcomplex(data.y[*,*,0]*1E-12, data.y[*,*,1]*1E-12)

    ; calc Ez
    c_ez = dcindgen(n_elements(t_se), n_elements(freq))
    idx = nn(t_sb, t_se)
    print, total(abs(t_sb[idx]-t_se))
    ; dnn = 1000 - nn(data1.x[0:1000], data2.x[1000])
    ; get_timespan, timespans
    ; eidx_min = where( t_se gt timespans[0]-0.015 and t_se lt timespans[0]+0.015, cnt )
    ; eidx_min = eidx_min[0]
    ; eidx_max = where( t_se gt timespans[1]-0.015 and t_se lt timespans[1]+0.015, cnt )
    ; eidx_max = eidx_max[-1]

    ; bidx_min = where( t_sb gt timespans[0]-0.015 and t_sb lt timespans[0]+0.015, cnt )
    ; bidx_min = bidx_min[0]
    ; bidx_max = where( t_sb gt timespans[1]-0.015 and t_sb lt timespans[1]+0.015, cnt )
    ; bidx_max = bidx_max[-1]
    ; idx = nn(t_sb[bidx_min:bidx_max], t_se[eidx_min:eidx_max])

    for i=0, n_elements(t_se)-1 do begin
      c_ez[i,*] = (-c_ex[i,*]*c_bx[idx[i],*] - c_ey[i,*]*c_by[idx[i],*]) / c_bz[idx[i],*]
      ; l = i + eidx_min
      ; m = idx[i] + bidx_min
      ; c_ez[l,*] = (-c_ex[l,*]*c_bx[m,*] - c_ey[l,*]*c_by[m,*]) / c_bz[m,*]
    endfor
    print, 'end ez'
    store_data,'wave_fft_ez', data={x:t_se,y:abs(c_ez)^2/bw,v:freq},lim=wavelim
    ; zlim,'wave_fft_ez',[min(c_ez),max(c_ez)]
    ylim,'wave_fft_ez',[min(freq),max(freq)]

    Sx=dindgen(n_elements(t_sb),n_elements(freq))
    Sy=dindgen(n_elements(t_sb),n_elements(freq))
    Sz=dindgen(n_elements(t_sb),n_elements(freq))

    ; calc Poynting flux
    idx = nn(t_se, t_sb)
    ; idx = nn(t_se[eidx_min:eidx_max], t_sb[bidx_min:bidx_max])

    for i=0, n_elements(t_sb)-1 do begin
      for j=0, n_elements(freq)-1 do begin
        Sx[i,j]= double(c_ey[idx[i],j]*conj(c_bz[i,j])-c_ez[idx[i],j]*conj(c_by[i,j]))
        Sy[i,j]=-double(c_ex[idx[i],j]*conj(c_bz[i,j])-c_ez[idx[i],j]*conj(c_bx[i,j]))
        Sz[i,j]= double(c_ex[idx[i],j]*conj(c_by[i,j])-c_ey[idx[i],j]*conj(c_bx[i,j]))
        ; l = idx[i] + eidx_min
        ; m = i + bidx_min
        ; Sx[m,j]= double(c_ey[l,j]*conj(c_bz[m,j])-c_ez[l,j]*conj(c_by[m,j]))
        ; Sy[m,j]=-double(c_ex[l,j]*conj(c_bz[m,j])-c_ez[l,j]*conj(c_bx[m,j]))
        ; Sz[m,j]= double(c_ex[l,j]*conj(c_by[m,j])-c_ey[l,j]*conj(c_bx[m,j]))
      endfor
    endfor
    print, 'end S'

    ; analyze MGF data
    split_vec, 'erg_mgf_l2_mag_64hz_sgi'
    ; interpolation
    tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_x', 'wave_fft_bx'
    tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_y', 'wave_fft_bx'
    tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_z', 'wave_fft_bx'
    get_data, 'erg_mgf_l2_mag_64hz_sgi_x_interp', data=data_x
    get_data, 'erg_mgf_l2_mag_64hz_sgi_y_interp', data=data_y
    get_data, 'erg_mgf_l2_mag_64hz_sgi_z_interp', data=data_z

    rotmat=dblarr(3,3,n_elements(data_x.x))
    rotmat_t=dblarr(3,3,n_elements(data_x.x))
    for i=0, n_elements(data_x.x)-1 do begin
      bvec=[data_x.y[i],data_y.y[i],data_z.y[i]]
      zz=[0.,0.,1.]
      yhat=crossp(zz,bvec)
      xhat=crossp(yhat,bvec)
      zhat=bvec
      xhat=xhat/sqrt(xhat[0]^2+xhat[1]^2+xhat[2]^2)
      yhat=yhat/sqrt(yhat[0]^2+yhat[1]^2+yhat[2]^2)
      zhat=zhat/sqrt(zhat[0]^2+zhat[1]^2+zhat[2]^2)
      rotmat[*,*,i]=([[xhat],[yhat],[zhat]])
      rotmat_t[*,*,i]=transpose([[xhat],[yhat],[zhat]])
    endfor
    print, 'end rotmat'

    ; Poynting vector calculation

    S=dindgen(n_elements(t_sb),n_elements(freq),3)
    for i=0, n_elements(t_sb)-1 do begin
      for j=0, n_elements(freq)-1 do begin
        S[i,j,*] = rotmat[*,*,i] ## [Sx[i,j],Sy[i,j],Sz[i,j]]
      endfor
    endfor
    print, 'end rot'

    theta=acos(S[*,*,2]/sqrt(S[*,*,0]^2+S[*,*,1]^2+S[*,*,2]^2))/!dtor

    wavelim={spec:1,zlog:1,ylog:0,yrange:[100,1000],ystyle:1}
    store_data, 'S', data={x:t_sb, y:theta, v:freq/1000.}
    ylim, 'S', 2.0, 10.0, 0
    ; zlim, pr_complex + 'Etotal_132', 1E-7, 1E0, 1 ; mV^2/m^2/Hz
    ; zlim, pr_complex + 'Btotal_132', 1E-2, 1E2, 1 ; pT^2/Hz
    zlim, 'S', 0., 180., 0 ; degree
    options, 'S', ysubtitle='Frequency [kHz]'
    ; options, pr_complex + 'Etotal_132', ytitle='E total', ztitle='[mV!U2!N/m!U2!N/Hz]'
    ; options, pr_complex + 'Btotal_132', ytitle='B total', ztitle='[pT!U2!N/Hz]'
    options, 'S', ytitle='Poynting vector', ztitle='[degree]'
    options, 'S', spec=1
    tplot, 'S'

stop
;   tinterpol_mxn, 'erg_pwe_ofa_l2_matrix_Btotal_132', 'S'
;   get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132_interp', data=data_ref
  ; S
;   get_data, 'S', data=data, dlim=dlim, lim=lim
;   data.y[where(data_ref.y LT cut_f)] = 'NaN'
;   store_data, 'S_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim




end