
; コンパイル 
; .compile -v '/Users/ampuku/Desktop/M1_spring/Arase/IDL/plot_kpara_ne.pro'


function least_squares_method,x,y
  gate = [finite(x,/nan) + finite(y,/nan) eq 0]
  x_ = x[where(gate)]
  y_ = y[where(gate)]
  a = total( (x_-mean(x_))*(y_-mean(y_)) ) / total( (x_-mean(x_))^2 )
  b = mean(y_) - a*mean(x_)
  return, [a,b]
end

; plot_kpara_neはtimespanを設定してから使用！！
pro plot_kpara_ne, duct_time=duct_time, focus_f=focus_f, UHR_file_name=UHR_file_name, lsm=lsm, k_para_=k_para_
  
  if not keyword_set(duct_time) then duct_time = '2018-06-02/10:05:56'
  if not keyword_set(focus_f) then focus_f = [3., 4., 5., 6., 7.] ;Hz
  if not keyword_set(UHR_file_name) then UHR_file_name = 'f_UHR_2018-06-02/100000-102000.tplot' ;Hz

  ; timespan, '2018-06-02/10:00:00', 20, /minute

  ; *****************
  ; 1.load data
  ; *****************

  uname = 'erg_project'
  pass = 'geospace'

  ;軌道読み込み
  ;set_erg_var_label
  
  ;磁場読み込み
  erg_load_mgf, datatype='8sec', uname=uname, pass=pass
  erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass

  ;HFA,OFA読み込み
  erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
  erg_load_pwe_ofa, datatype='matrix', uname=uname, pass=pass
  pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified
  
  ; *****************
  ; 2.calculate wave normal angle, polarization
  ; *****************
  
  ; *****************
  ; 2.1.analyze OFA-MATRIX B
  ; *****************
  get_data, pr_matrix + 'Bx_Bx_132', data=s00
  get_data, pr_matrix + 'Bx_By_132', data=s01
  get_data, pr_matrix + 'Bx_Bz_132', data=s02
  get_data, pr_matrix + 'By_Bx_132', data=s10
  get_data, pr_matrix + 'By_By_132', data=s11
  get_data, pr_matrix + 'By_Bz_132', data=s12
  get_data, pr_matrix + 'Bz_Bx_132', data=s20
  get_data, pr_matrix + 'Bz_By_132', data=s21
  get_data, pr_matrix + 'Bz_Bz_132', data=s22

  ; rr[ 3x3matrix 2D-1, 3x3matrix 2D-2, time, Energy, Re&Im ]
  rr=dblarr(3,3,n_elements(s00.x),n_elements(s00.v2),2) ; *** modified (v->v2)
  rr[0,0,*,*,*]=s00.y & rr[1,0,*,*,*]=s01.y & rr[2,0,*,*,*]=s02.y
  rr[0,1,*,*,*]=s10.y & rr[1,1,*,*,*]=s11.y & rr[2,1,*,*,*]=s12.y
  rr[0,2,*,*,*]=s20.y & rr[1,2,*,*,*]=s21.y & rr[2,2,*,*,*]=s22.y
  
  ; for 
  

  ; *****************
  ; 2.2.analyze OFA-MATRIX E
  ; *****************
  get_data, pr_matrix + 'Ex_Ex_132', data=sE00
  get_data, pr_matrix + 'Ex_Ey_132', data=sE01
  get_data, pr_matrix + 'Ey_Ex_132', data=sE10
  get_data, pr_matrix + 'Ey_Ey_132', data=sE11

  ; rrE : [ 2x2matrix 2D-1, 2x2matrix 2D-2, time, Energy, Re&Im ]
  rrE=dblarr(2,2,n_elements(sE00.x),n_elements(sE00.v2),2) ; *** modified (v->v2)
  rrE[0,0,*,*,*]=sE00.y & rrE[1,0,*,*,*]=sE01.y
  rrE[0,1,*,*,*]=sE10.y & rrE[1,1,*,*,*]=sE11.y


  ; *****************
  ; 2.3.analyze MGF data B
  ; *****************
  split_vec, 'erg_mgf_l2_mag_64hz_sgi'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_x', pr_matrix+'Bx_Bx_132'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_y', pr_matrix+'Bx_Bx_132'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_z', pr_matrix+'Bx_Bx_132'

  get_data, 'erg_mgf_l2_mag_64hz_sgi_x_interp', data=data_x, dlim=dlim_x, lim=lim_x
  get_data, 'erg_mgf_l2_mag_64hz_sgi_y_interp', data=data_y, dlim=dlim_y, lim=lim_y
  get_data, 'erg_mgf_l2_mag_64hz_sgi_z_interp', data=data_z, dlim=dlim_z, lim=lim_z

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


  ; *****************
  ; 2.4.analyze MGF data E
  ; *****************
  split_vec, 'erg_mgf_l2_mag_64hz_sgi'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_x', pr_matrix+'Ex_Ex_132'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_y', pr_matrix+'Ex_Ex_132'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_z', pr_matrix+'Ex_Ex_132'

  get_data, 'erg_mgf_l2_mag_64hz_sgi_x_interp', data=data_x, dlim=dlim_x, lim=lim_x
  get_data, 'erg_mgf_l2_mag_64hz_sgi_y_interp', data=data_y, dlim=dlim_y, lim=lim_y
  get_data, 'erg_mgf_l2_mag_64hz_sgi_z_interp', data=data_z, dlim=dlim_z, lim=lim_z

  ; x,y平面のみxがx,y平面上の磁力線に沿った向きになるように回転させる

  rotmatE=dblarr(2,2,n_elements(data_x.x))
  rotmat_tE=dblarr(2,2,n_elements(data_x.x))
  for i=0, n_elements(data_x.x)-1 do begin
    bvec=[data_x.y[i],data_y.y[i],data_z.y[i]]
    zz=[0.,0.,1.]
    xhat=bvec-bvec*zz ;*: 内積
    yhat=crossp(zz,xhat)
    xhat=xhat/sqrt(xhat[0]^2+xhat[1]^2+xhat[2]^2)
    yhat=yhat/sqrt(yhat[0]^2+yhat[1]^2+yhat[2]^2)
    rotmatE[*,*,i]=([[xhat[0:1]],[yhat[0:1]]])
    rotmat_tE[*,*,i]=transpose([[xhat[0:1]],[yhat[0:1]]])
  endfor

  memo=i

  ;test
  ;試しにi番目のデータを見てみる
  ;vec_E = [[1,0,0],[0,1,0],[0,0,1]]
  ;i = 300 & vec_rotE = rotmatE[*,*,100] ## vec_E ## rotmat_tE[*,*,100] & print, vec_rotE

  ; ------------------------------------------------------------------
  ; *****************
  ; 2.5.MGF rotation (test)
  ; *****************
  data_rot=dblarr(n_elements(data_x.x), 3)
  for i=0, n_elements(data_x.x)-1 do begin
    data=[[data_x.y[i]], [data_y.y[i]],[data_z.y[i]]]
    data_rot[i,*] = rotmat[*,*,i] ## data
  endfor
  store_data, 'erg_mgf_l2_mag_64hz_sgi_rot_x',$
    data={x:data_x.x, y:data_rot[*,0]}, dlim=dlim_x, lim=lim_x
  store_data, 'erg_mgf_l2_mag_64hz_sgi_rot_y',$
    data={x:data_y.x, y:data_rot[*,1]}, dlim=dlim_y, lim=lim_y
  store_data, 'erg_mgf_l2_mag_64hz_sgi_rot_z',$
    data={x:data_z.x, y:data_rot[*,2]}, dlim=dlim_z, lim=lim_z
  ylim, 'erg_mgf_l2_mag_64hz_sgi_rot_?', -1E4, 4E4, 0


  ; ************************************
  ; 2.6.MATRIX ROTATION B
  ; ************************************

  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-1 do begin ; *** modified (v->v2)
      for k=0, 1 do begin
        rr[*,*,i,j,k] = (rotmat[*,*,i] ## rr[*,*,i,j,k]) ## rotmat_t[*,*,i]
      endfor
    endfor
  endfor


  ; ************************************
  ; 2.7.MATRIX ROTATION E
  ; ************************************


  for i=0, n_elements(sE00.x)-1 do begin
    for j=0, n_elements(sE00.v2)-1 do begin ; *** modified (v->v2)
      for k=0, 1 do begin
        rrE[*,*,i,j,k] = (rotmatE[*,*,i] ## rrE[*,*,i,j,k]) ## rotmat_tE[*,*,i]
      endfor
    endfor
  endfor


  ; ************************************
  ; 2.8.auto-spectra B
  ; ************************************
  get_data, pr_matrix + 'Bx_Bx_132',data=data, dlim=dlim, lim=lim
  store_data, pr_matrix + 'Bx_Bx_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  store_data, pr_matrix + 'Bx_Bx_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  ;
  get_data, pr_matrix + 'By_By_132',data=data, dlim=dlim, lim=lim
  store_data, pr_matrix + 'By_By_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  store_data, pr_matrix + 'By_By_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  ;
  get_data, pr_matrix + 'Bz_Bz_132',data=data, dlim=dlim, lim=lim
  store_data, pr_matrix + 'Bz_Bz_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  store_data, pr_matrix + 'Bz_Bz_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)

  options, pr_matrix + 'Bx_Bx_re', ytitle='Re(BxBx*)'
  options, pr_matrix + 'Bx_Bx_im', ytitle='Im(BxBx*)'
  options, pr_matrix + 'By_By_re', ytitle='Re(ByBy*)'
  options, pr_matrix + 'By_By_im', ytitle='Im(ByBy*)'
  options, pr_matrix + 'Bz_Bz_re', ytitle='Re(BzBz*)'
  options, pr_matrix + 'Bz_Bz_im', ytitle='Im(BzBz*)'
  options, pr_matrix + 'B?_B?_??', ysubtitle = 'Frequency [kHz]'
  options, pr_matrix + 'B?_B?_??', ztitle = '[pT!U2!N/Hz]'
  ylim, pr_matrix + 'B?_B?_??', 0.064, 20, 1 ; kHz
  zlim, pr_matrix + 'B?_B?_??', 1E-3, 1E2, 1 ; nT


  ; ************************************
  ; 2.9.auto-spectra E
  ; ************************************
  get_data, pr_matrix + 'Ex_Ex_132',data=data, dlim=dlim, lim=lim
  store_data, pr_matrix + 'Ex_Ex_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  store_data, pr_matrix + 'Ex_Ex_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  ;
  get_data, pr_matrix + 'Ey_Ey_132',data=data, dlim=dlim, lim=lim
  store_data, pr_matrix + 'Ey_Ey_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  store_data, pr_matrix + 'Ey_Ey_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)

  options, pr_matrix + 'Ex_Ex_re', ytitle='Re(ExEx*)'
  options, pr_matrix + 'Ex_Ex_im', ytitle='Im(ExEx*)'
  options, pr_matrix + 'Ey_Ey_re', ytitle='Re(EyEy*)'
  options, pr_matrix + 'Ey_Ey_im', ytitle='Im(EyEy*)'
  options, pr_matrix + 'E?_E?_??', ysubtitle = 'Frequency [kHz]'
  options, pr_matrix + 'E?_E?_??', ztitle = '[pT!U2!N/Hz]'
  ylim, pr_matrix + 'E?_E?_??', 0.064, 20, 1 ; kHz
  zlim, pr_matrix + 'E?_E?_??', 1E-3, 1E2, 1 ; nT

  
  ; ************************************
  ; 2.10.wave normal angle
  ; ************************************
  wna=dblarr(n_elements(s00.x), n_elements(s00.v2)) ; *** modified (v->v2)
  rrr = rr * 0.0
  for i=0, n_elements(s00.x)-1 do begin
    for j=1, n_elements(s00.v2)-2 do begin ; *** modified (v->v2)
      idx_j = j + indgen(3) -1
      rrr[2,1,i,j,1] = total( rr[2,1,i,idx_j,1] )
      rrr[0,2,i,j,1] = total( rr[0,2,i,idx_j,1] )
      rrr[1,0,i,j,1] = total( rr[1,0,i,idx_j,1] )
      
      ; wave normal
      wna_x = rrr[2,1,i,j,1] / sqrt(rrr[2,1,i,j,1]^2 + rrr[0,2,i,j,1]^2 + rrr[1,0,i,j,1]^2)
      wna_y = rrr[0,2,i,j,1] / sqrt(rrr[2,1,i,j,1]^2 + rrr[0,2,i,j,1]^2 + rrr[1,0,i,j,1]^2)
      wna_z = rrr[1,0,i,j,1] / sqrt(rrr[2,1,i,j,1]^2 + rrr[0,2,i,j,1]^2 + rrr[1,0,i,j,1]^2)
      
      ; wave normal
;      wna_x = rr[2,1,i,j,1] / sqrt(rr[2,1,i,j,1]^2 + rr[0,2,i,j,1]^2 + rr[1,0,i,j,1]^2)
;      wna_y = rr[0,2,i,j,1] / sqrt(rr[2,1,i,j,1]^2 + rr[0,2,i,j,1]^2 + rr[1,0,i,j,1]^2)
;      wna_z = rr[1,0,i,j,1] / sqrt(rr[2,1,i,j,1]^2 + rr[0,2,i,j,1]^2 + rr[1,0,i,j,1]^2)

      wna[i,j] = abs(atan(sqrt(wna_x^2+wna_y^2)/wna_z)/!dtor)
    endfor
  endfor
  store_data, 'kvec', data={x:s00.x, y:wna, v:s00.v2} ; *** modified (v->v2)
  options, 'kvec', ytitle='wave normal angle', $
    ztitle='[degree]', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'kvec', 0.064, 20, 1 ; kHz
  zlim, 'kvec', 0., 90, 0 ; degree


  ; ************************************
  ; 2.11.polarization
  ; ************************************
  Polarization = $
    dblarr(n_elements(s00.x),n_elements(s00.v2)) ; *** modified (v->v2)
  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-1 do begin ; *** modified (v->v2)
      polarization[i,j] = $
        (2 * rr[1,0,i,j,1]) / (rr[0,0,i,j,0] + rr[1,1,i,j,0])
    endfor
  endfor
  store_data, 'polarization', data={x:s00.x, y:polarization, v:s00.v2} ; *** modified (v->v2)
  options, 'polarization', ytitle='polarization', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'polarization', 0.064, 20., 1 ; kHz
  zlim, 'polarization', -1., 1., 0 ;

  
  ; *****************
  ; 3.calculate k_para
  ; *****************

  tinterpol_mxn, 'erg_mgf_l2_magt_8sec', 'polarization'
  get_data, 'erg_mgf_l2_magt_8sec_interp', data=magt
  get_data, 'polarization', data=pol
  
  f = pol.v
  
;  read_f_uhr
  tplot_restore, file=[UHR_file_name]
  get_data, 'f_UHR', data=data
  store_data, 'test', data={x:data.x, y:data.y}, dlim={colors:5,thick:1,linestyle:1}
  tinterpol_mxn, 'f_UHR', 'polarization'
  options, 'f_UHR_interp', linestyles=0
  get_data, 'f_UHR_interp', data=f_UHR
  store_data, 'erg_pwe_hfa', data=['erg_pwe_hfa_l2_high_spectra_e_mix', 'f_UHR_interp']
  ylim, 'erg_pwe_hfa', 40.0, 200.0, 0
  tplot, 'erg_pwe_hfa'
  

  f_ce = magt.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi ; in Hz ,DはDOUBLEのD
  f_pe = sqrt( (f_UHR.y*10^(3.))^2. - f_ce^2. ) ; Hz
;  f_pe_test = sqrt( (f_UHR.y)^2. - f_ce^2./10^(6.) ) * 10^(3.) ; Hz
  Ne_ = (f_pe * 2 * !pi)^2 * (9.1093D * 10^(-31.)) * (8.854D * 10^(-12.)) /  (1.602D * 10^(-19.))^2 / 10^(6.) ;cm-3
  alpha = wna / 180 * !pi
  store_data, 'Ne', data={x:s00.x, y:Ne_} ;, v:s00.v2}
  ylim, 'Ne', 10.0, 1000.0, 1
  ;  erg_load_pwe_hfa, level='l3', uname='erg_project', pass='geospace' ; neの参考 桁の一致を確認済み
  store_data, 'f_pe', data={x:s00.x, y:f_pe}
  
  k_para = fltarr(n_elements(alpha[*,0]), n_elements(alpha[0,*]))
  for i=0,n_elements(alpha[0,*])-1 do begin
    alpha_ = alpha[*,i]
    c = 2.99 * 10^(8.)
    a1 = 4 * !pi^2 * f_pe^2 / c^2
    a2 = f_ce / (f[i] * 10^(3.)) / cos(alpha_)
    a3 = 1 / (cos(alpha_))^2
    k_para[*,i] = sqrt( a1 / (a2-a3) )
  endfor
  
  store_data, 'f_ce', data={x:s00.x, y:f_ce, v:s00.v2}
  store_data, 'k_para', data={x:s00.x, y:k_para, v:s00.v2}
  options, 'k_para', ytitle='k_para', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'k_para', 2., 10., 0 ; kHz
  zlim, 'k_para', 1.e-4, 5.e-3, 1 ;適宜ここ決める！

  
  ; *****************
  ; 4.mask
  ; *****************

  get_data, pr_matrix + 'Btotal_132', data=data_ref; *** modified (B_total_132 -> Btotal_132)
  cut_f = 1E-2
  ; kvec
  get_data, 'kvec', data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'kvec_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
  ; polarization
  get_data, 'polarization', data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'polarization_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
  ; k_para
  get_data, 'k_para', data=data, dlim=dlim, lim=lim
  data.y[where(data_ref.y LT cut_f)] = 'NaN'
  store_data, 'k_para_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
  
  tplot, ['erg_pwe_hfa', 'k_para_mask']


  
  ; *****************
  ; 5.get k_para(freq)
  ; *****************
  ;2018-06-02/10:05:56のk_paraを試しに周波数方向に切り出してみる
  
  ; 保存するplotのwindowを用意
  SET_PLOT, 'Z'
  DEVICE, SET_RESOLUTION = [1000,600]
  !p.BACKGROUND = 255
  !p.color = 0
  
  get_data, 'k_para', data = k_paradata
  time_ = time_double(duct_time)
  idx_t = where( k_paradata.x lt time_+4. and k_paradata.x gt time_-4., cnt )
  plot, k_paradata.v, k_paradata.y[idx_t[0], *], psym=-4, xtitle='f (kHz)', ytitle='k_para (/m)'
 
  ; 最小二乗法でダクト中心でのk_paraを直線に当てはめる
  if not keyword_set(lsm) then lsm = least_squares_method(k_paradata.v[where(k_paradata.v lt 8)], k_paradata.y[idx_t[0], where(k_paradata.v lt 8)]) ;外れ値に左右され過ぎてしまう 余裕があったらロバスト回帰を導入？
  ; lsm = [0.00019399999,   0.00014002688]

;  k_para_ = [ 0.00072889862, 0.00084289216, 0.0010308567, 0.0013732987, 0.0016690817] ; 3,4,5,6,7
;  k_para_ = [0.00074098376,    0.0012041943,    0.0016674048,    0.0019,    0.00235]
;  f_ = [3000., 4000., 5000., 6000., 7000.] ;Hz
  
  if not keyword_set(k_para_) then k_para_ = lsm[0] * focus_f + lsm[1]
  tvlct, 255,0,0,1
  oplot, focus_f, k_para_, psym=2, color=1
  lsm_f = [min(k_paradata.v), max(k_paradata.v)]
  lsm_k_para = lsm[0] * lsm_f + lsm[1]
  oplot, lsm_f, lsm_k_para, color=1
  
  ; 保存
  ret = strsplit(duct_time, '-/:', /extract)
  makepng, 'events/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_f_kpara'
  

  ; *****************
  ; 6.calculate Ne(k_perp)
  ; *****************
  get_data, 'f_ce', data=f_cedata
  idx_t_ = where( f_cedata.x lt time_+5. and f_cedata.x gt time_-5., cnt )
  f_ce_ave = f_cedata.y[idx_t_[0]]
;  f_chorus = [3000., 4000., 5000., 6000., 7000.] ;Hz
  
  k_perp = dindgen(60, increment=0.0001, start=0.0)
  
  Ne_k_para = fltarr(n_elements(k_perp), n_elements(focus_f))

  for i=0, n_elements( focus_f )-1 do begin
    f_ = focus_f[i] * 1000. ;kHz -> Hz
    b1 = (9.1093D * 10^(-31.)) / (1.25D * 10^(-6.)) / (1.6 * 10^(-19.))^2
    b2 = - k_perp^2 + f_ce_ave / f_ * k_para_[i] * sqrt( k_para_[i]^2 + k_perp^2 ) - k_para_[i]^2
    Ne_k_para[*, i] = b1 * b2 / 10^(6.) ;cm-3

  endfor

  ; *****************
  ; 7.plot
  ; *****************
  
  tvlct, 255,0,0,1
  tvlct, 0,0,0,4
  
  tvlct, 143,119,181,10
  tvlct, 0,0,255,11
  tvlct, 0,255,0,12
  tvlct, 200,125,0,13
  tvlct, 252,15,192,14
  tvlct, 255,0,0,15
  
  
  plot, k_perp, Ne_k_para[*, 0], color=4, yrange=[min(Ne_k_para)-5, max(Ne_k_para)+5]
  oplot, k_perp, Ne_k_para[*, 0], color=10
  oplot, [k_perp[0]], [Ne_k_para[0, 0]], psym=4, color=6
  xyouts, k_perp[2], Ne_k_para[0, 0], string(fix(Ne_k_para[0, 0]), format='(i0)'), color=10, CHARSIZE=2
  xyouts, k_perp[-8], Ne_k_para[-1, 0], string(fix(focus_f[0]), format='(i0)')+'kHz', color=10, CHARSIZE=2
  for i = 1, n_elements(focus_f)-1 do begin
    oplot, k_perp, Ne_k_para[*, i], color=i+10
    oplot, [k_perp[0]], [Ne_k_para[0, i]], psym=4, color=6
    xyouts, k_perp[2], Ne_k_para[0, i], string(fix(Ne_k_para[0, i]), format='(i0)'), color=i+10, CHARSIZE=2
    xyouts, k_perp[-8], Ne_k_para[-1, i], string(fix(focus_f[i]), format='(i0)')+'kHz', color=i+10, CHARSIZE=2
  endfor
  
  makepng, 'events/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_Ne_kpara'
  
  print, ' n_0'
  print, Ne_k_para[0, *]
  
  print, ' n_max'
  for i=0,n_elements(focus_f)-1 do begin
    print, max(Ne_k_para[*, i])
  endfor
  
  
  ; *****************
  ; 8.plot UT_B
  ; *****************
  
  time1 = time_string( time_double(duct_time) - 60.*2. ) ;sec
  time2 = time_string( time_double(duct_time) + 60.*2. ) ;sec
  
  timespan, [time1, time2]
;  get_data, 'erg_pwe_ofa_l2_matrix_Btotal_132', data=Btotal
  erg_load_pwe_ofa
  get_data, 'erg_pwe_ofa_l2_spec_B_spectra_132', data=Bspec
  get_data, 'Ne', data=data
  
  N0_obs = fltarr(n_elements(focus_f)) * 1000.
;  idx_f = [where( Bspec.v eq 3.0079999 , cnt ), where( Bspec.v eq 3.9679999 , cnt ), where( Bspec.v eq 4.9920001 , cnt ), where( Bspec.v eq 5.9520001 , cnt ), where( Bspec.v eq 7.104000 , cnt )]
  idx_f = fltarr(n_elements(focus_f))
;  UT_B_names = ['UT_B_f3', 'UT_B_f4', 'UT_B_f5', 'UT_B_f6', 'UT_B_f7']
  UT_B_names = strarr(n_elements(focus_f))
;  N0_names = ['N0_f3', 'N0_f4', 'N0_f5', 'N0_f6', 'N0_f7']
  N0_names = strarr(n_elements(focus_f))
;  UT_B_ymax = [0.03, 0.2, 0.03, 0.03, 0.03]
  UT_B_ymax = fltarr(n_elements(focus_f)) + 0.03
  
  for i=0, n_elements(focus_f)-1 do begin
    difarr = abs(Bspec.v-focus_f[i])
    idx_f[i] = where( difarr eq min(difarr) , cnt )
    UT_B_names[i] = 'UT_B_f' + string(fix(focus_f[i]), format='(i0)')
    N0_names[i] = 'N0_f' + string(fix(focus_f[i]), format='(i0)')
  endfor

  for i=0,n_elements(focus_f)-1 do begin
    
    store_data, UT_B_names[i], data={x:Bspec.x, y:Bspec.y[*,idx_f[i]]}
    ylim, UT_B_names[i], 0.0, UT_B_ymax[i], 0
    options, UT_B_names[i], 'ystyle', 9
    
    store_data, N0_names[i], data={x:data.x, y:data.y}
;    options, N0_names[i], 'databar', {yval:Ne_k_para[0,i], linestyle:2, color:i+10, thick:2}
;    options, N0_names[i], 'databar', {yval:N0_obs[i], linestyle:1, color:i+10, thick:2}
    
    idx_duct_t = ( where( data.x lt time_double(duct_time)+5. and data.x gt time_double(duct_time)-5., cnt ) )[0]
    Ne_max =  max( [FLOAT(data.y[idx_duct_t]+20.), Ne_k_para[0, 0], Ne_k_para[0, -1]] )
    idx_duct_start = ( where( data.x lt time_double(time1)+5. and data.x gt time_double(time1)-5., cnt ) )[0]
    idx_duct_end = ( where( data.x lt time_double(time2)+5. and data.x gt time_double(time2)-5., cnt ) )[0]
    Ne_min_ = FLOAT( min(data.y[idx_duct_start:idx_duct_end]) )
    Ne_min =  max( [min( [Ne_min_, Ne_k_para[0, 0], Ne_k_para[0, -1]] ), 0.] )
    ylim, N0_names[i], Ne_min, Ne_max, 0
    options, N0_names[i], axis={yaxis:1, yrange:[Ne_min, Ne_max], ystyle:1, color:6}, ystyle=5
    options, N0_names[i], colors=6
    
    tplot, UT_B_names[i]
    tplot, N0_names[i], /oplot
    options, N0_names[i], 'databar', {yval:Ne_k_para[0,i], linestyle:2, color:i+10, thick:2}
    tplot_apply_databar
;    options, N0_names[i], 'databar', {yval:N0_obs[i], linestyle:1, color:i+10, thick:2}
;    tplot_apply_databar
    
  endfor
  
  tplot, UT_B_names
  tplot, N0_names, /oplot
  tplot_apply_databar
  
  makepng, 'events/'+ret[0]+ret[1]+ret[2]+'/'+ret[3]+ret[4]+ret[5]+'_UT_B'
  
  stop
  
  
;  store_data, 'UT_B_f3', data={x:Bspec.x, y:Bspec.y[*,idx_f[0]]}
;  ylim, 'UT_B_f3', 0.0, 0.01, 0
;  options, 'UT_B_f3', 'ystyle', 9
;
;  options, 'N0_f', 'databar', {yval:Ne_k_para[0,0], linestyle:2, color:i, thick:2}
;  options, 'N0_f', 'databar', {yval:N0_obe[0], linestyle:1, color:i, thick:2}
;
;  ylim, 'N0_f', 0.0, 160.0, 0
;  options, 'N0_f', axis={yaxis:1, yrange:[0., 160.], ystyle:1, color:6}, ystyle=5
;  options, 'N0_f', colors=6
; 
;  tplot, 'UT_B_f3'
;  tplot, 'N0_f', /oplot
;  tplot_apply_databar

  
  
  ;
  ;
  ;  ここまで_(┐「ε:)_
  ;
  ;


end