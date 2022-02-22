pro day_plot, span=span, hour_plot=hour_plot


  ;--------------------------------------------------------------------
  ; HFAの電場スペクトル、OFAの電場スペクトル、OFA-Bから計算した磁場スペクトル、伝搬角、円偏波のPLOT
  ;
  ; 使用方法
  ; IDL> erg_init
  ; ERG> timespan, '2018-06-02'
  ; ERG> day_plot_20220112, span=1 ; 横軸１時間のPLOTを24枚作成し、erg\erg_ofa_matrix\erg_ofa_matrix_YYYYMMDD_HH.pngに保存
  ;
  ;--------------------------------------------------------------------

  ; default plot span [hour] (整数値を指定する。24の約数であること。)
  if not keyword_set(span) then span=1 ; [hour]
  if not keyword_set(hour_plot) then hour_plot=0

  uname='erg_project'
  pass='geospace'

  stokes_on = 0
  calPA_on = 0 ;未完成
  hourplot_on = 1

  ; *****************
  ; 1.set time span
  ; *****************
  ;  timespan, '2018-06-02', 1, /day

  ; *****************
  ; 2.load orbit CDF & set var label
  ; *****************
  set_erg_var_label

  ; *** added ***
  ; *****************
  ; 3.load HFA
  ; *****************
  erg_load_pwe_hfa, level='l2', mode=['l','h'], uname=uname, pass=pass
  ;  erg_load_pwe_hfa, level='l3', uname=uname, pass=pass
  ;  store_data, 'erg_pwe_hfa_marge', data=['erg_pwe_hfa_l2_lh_spectra_e_mix','erg_pwe_hfa_l3_1min_Fuhr']

  ; *****************
  ; 4.load OFA-MATRIX
  ; *****************
  erg_load_pwe_ofa, datatype='matrix', uname=uname, pass=pass
  pr_matrix = 'erg_pwe_ofa_l2_matrix_'  ; *** modified

  ; *****************
  ; 5.load MGF L2 CDF
  ; *****************
  erg_load_mgf, datatype='8sec', uname=uname, pass=pass
  erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass

  ; *****************
  ; 6.1.analyze OFA-MATRIX B
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


  ; *****************
  ; 6.2.analyze OFA-MATRIX E
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
  ; 7.1.calc. rotation matrix 3D
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
  ; 7.2.calc. rotation matrix 2D
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


  ; *****************
  ; 8.rotate MGF (test)
  ; *****************
  data_rot=dblarr(n_elements(data_x.x), 3)
  for i=0, n_elements(data_x.x)-1 do begin
    data = [[data_x.y[i]], [data_y.y[i]],[data_z.y[i]]]
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
  ; 9.1.rotate OFA matrix B
  ; ************************************

  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-1 do begin ; *** modified (v->v2)
      for k=0, 1 do begin
        rr[*,*,i,j,k] = (rotmat[*,*,i] ## rr[*,*,i,j,k]) ## rotmat_t[*,*,i]
      endfor
    endfor
  endfor


  ; ************************************
  ; 9.2.rotate OFA matrix E
  ; ************************************


  for i=0, n_elements(sE00.x)-1 do begin
    for j=0, n_elements(sE00.v2)-1 do begin ; *** modified (v->v2)
      for k=0, 1 do begin
        rrE[*,*,i,j,k] = (rotmatE[*,*,i] ## rrE[*,*,i,j,k]) ## rotmat_tE[*,*,i]
      endfor
    endfor
  endfor


  ; ************************************
  ; 10.1.auto-spectra B
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

  ;  tplot, pr_matrix + ['Bx_Bx_re', 'Bx_Bx_im', 'By_By_re', 'By_By_im', 'Bz_Bz_re', 'Bz_Bz_im']

  ; ************************************
  ; 10.2.auto-spectra E
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

  tplot, pr_matrix + ['Ex_Ex_re', 'Ex_Ex_im', 'Ey_Ey_re', 'Ey_Ey_im']

  ; ************************************
  ; 11.SVD analysis
  ; ************************************
  ;  erg_calc_pwe_wna.pro を参考に作成

  n_t = n_elements(s00.x)
  n_e = n_elements(s00.v2)

  A=dblarr(3,6,n_t,n_e)
  W2=dblarr(3,n_t,n_e)
  V2=dblarr(3,3,n_t,n_e)
  W_SORT=dblarr(3,n_t,n_e)
  V_SORT=dblarr(3,3,n_t,n_e)

  A[0,0,*,*]=rr[0,0,*,*,0] & A[1,0,*,*]=rr[1,0,*,*,0]  & A[2,0,*,*]=rr[2,0,*,*,0]
  A[0,1,*,*]=rr[1,0,*,*,0] & A[1,1,*,*]=rr[1,1,*,*,0]  & A[2,1,*,*]=rr[2,1,*,*,0]
  A[0,2,*,*]=rr[2,0,*,*,0] & A[1,2,*,*]=rr[2,1,*,*,0]  & A[2,2,*,*]=rr[2,2,*,*,0]
  A[0,3,*,*]=0.0           & A[1,3,*,*]=-rr[1,0,*,*,1] & A[2,3,*,*]=-rr[2,0,*,*,1]
  A[0,4,*,*]=rr[1,0,*,*,1] & A[1,4,*,*]=0.0            & A[2,4,*,*]=-rr[2,1,*,*,1]
  A[0,5,*,*]=rr[2,0,*,*,1] & A[1,5,*,*]=rr[2,1,*,*,1]  & A[2,5,*,*]=0.0


  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-1 do begin
      LA_SVD,reform(A[*,*,i,j]),W,U,V,/double
      W2[*,i,j]=W
      V2[*,*,i,j]=V
      W_ORDER = SORT(W2[*,i,j])
      for k=0,2 do begin
        W_SORT[k,i,j] = W2[W_ORDER[k],i,j]
        V_SORT[k,*,i,j] = V2[W_ORDER[k],*,i,j]
      endfor
    endfor
  endfor

  ; ************************************
  ; 12.WNA, polarization and planarity 
  ; ************************************
  ;  erg_calc_pwe_wna.pro を参考に作成

  powspec_b = dblarr(n_t,n_e)
  wna = dblarr(n_t,n_e)
  polarization = dblarr(n_t,n_e)
  planarity = dblarr(n_t,n_e)

  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-2 do begin
      ; power spec
      powspec_b[i,j] = sqrt(A[0,0,i,j]^2 + A[1,1,i,j]^2 + A[2,2,i,j]^2)
      ; wave normal
      wna[i,j] = abs(atan(sqrt(V_SORT[0,0,i,j]^2+V_SORT[0,1,i,j]^2)/V_SORT[0,2,i,j])/!dtor) ;[degree]
      ; wna_azm[i,j] = atan(V_SORT[0,1,i,j], V_SORT[0,0,i,j])/!dtor 
      ; polarization
      polarization[i,j] = W_SORT[1,i,j]/W_SORT[2,i,j]
      if(rr[1,0,i,j,1] LT 0.) then polarization[i,j] *= -1.
      ; planarity
      planarity[i,j] = 1. - sqrt(W_SORT[0,i,j]/W_SORT[2,i,j])
    endfor
  endfor

  store_data, 'powspec_b', data={x:s00.x, y:powspec_b, v:s00.v2} ; *** modified (v->v2)
  options, 'powspec_b', ytitle='powspec_b_LA SVD', $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'powspec_b', 0.064, 20, 1 ; kHz
  zlim, 'powspec_b', 1E-2, 1E2, 1 ; nT
  
  store_data, 'kvec', data={x:s00.x, y:wna, v:s00.v2} ; *** modified (v->v2)
  options, 'kvec', ytitle='wave normal angle_LA SVD', $
    ztitle='[degree]', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'kvec', 0.064, 20, 1 ; kHz
  zlim, 'kvec', 0., 90, 0 ; degree

  store_data, 'polarization', data={x:s00.x, y:polarization, v:s00.v2} ; *** modified (v->v2)
  options, 'polarization', ytitle='polarization_LA SVD', $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'polarization', 0.064, 20, 1 ; kHz
  zlim, 'polarization', -1., 1., 0 ; degree

  store_data, 'planarity', data={x:s00.x, y:planarity, v:s00.v2} ; *** modified (v->v2)
  options, 'planarity', ytitle='planarity_LA SVD', $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'planarity', 0.064, 20, 1 ; kHz
  zlim, 'planarity', 0., 1., 0

  ;  tplot, [pr_matrix+'Bx_Bx_re', pr_matrix+'By_By_re', pr_matrix+'Bz_Bz_re', 'kvec']

  ; ************************************
  ; 12*.WNA, polarization and planarity with Algebraic SVD? or Means et al 1972
  ; ************************************

  wna_algebraic = dblarr(n_t,n_e)
  polarization_algebraic = dblarr(n_t,n_e)

  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-1 do begin ; *** modified (v->v2)
      ; wave normal
      wna_x = rr[2,1,i,j,1] / sqrt(rr[2,1,i,j,1]^2 + rr[0,2,i,j,1]^2 + rr[1,0,i,j,1]^2)
      wna_y = rr[0,2,i,j,1] / sqrt(rr[2,1,i,j,1]^2 + rr[0,2,i,j,1]^2 + rr[1,0,i,j,1]^2)
      wna_z = rr[1,0,i,j,1] / sqrt(rr[2,1,i,j,1]^2 + rr[0,2,i,j,1]^2 + rr[1,0,i,j,1]^2)

      wna_algebraic[i,j] = abs(atan(sqrt(wna_x^2+wna_y^2)/wna_z)/!dtor)

      polarization_algebraic[i,j] = $
        (2 * rr[1,0,i,j,1]) / (rr[0,0,i,j,0] + rr[1,1,i,j,0])
    endfor
  endfor

   store_data, 'kvec_algebraic', data={x:s00.x, y:wna_algebraic, v:s00.v2} ; *** modified (v->v2)
  options, 'kvec_algebraic', ytitle='wave normal angle_algebraic SVD', $
    ztitle='[degree]', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'kvec_algebraic', 0.064, 20, 1 ; kHz
  zlim, 'kvec_algebraic', 0., 90, 0 ; degree

  store_data, 'polarization_algebraic', data={x:s00.x, y:polarization_algebraic, v:s00.v2} ; *** modified (v->v2)
  options, 'polarization_algebraic', ytitle='polarization_algebraic SVD', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'polarization_algebraic', 0.064, 20., 1 ; kHz
  zlim, 'polarization_algebraic', -1., 1., 0 ;

  ;  tplot, [pr_matrix+'Bx_Bx_re', pr_matrix+'By_By_re', pr_matrix+'Bz_Bz_re', 'polarization']


  ; ************************************
  ; *.WNA, polarization and planarity with Algebraic SVD?の比較
  ; ************************************

  window, 0, xsize=1000, ysize=750
  tplot, ['kvec', 'kvec_algebraic', 'polarization', 'polarization_algebraic', 'planarity']
  ; tplot, ['erg_pwe_ofa_l2_spec_B_spectra_132', 'powspec_b']

  stop

  ; ************************************
  ; 13.stokes parameter
  ; ************************************

  if stokes_on eq 1 then begin
    st_I = $
      dblarr(n_elements(sE00.x),n_elements(sE00.v2))
    st_Q = $
      dblarr(n_elements(sE00.x),n_elements(sE00.v2))
    st_U = $
      dblarr(n_elements(sE00.x),n_elements(sE00.v2))
    st_V = $
      dblarr(n_elements(sE00.x),n_elements(sE00.v2))
    ;  st_chi = $
    ;    dblarr(n_elements(s00.x),n_elements(s00.v2))

    for i=0, n_elements(sE00.x)-1 do begin
      for j=0, n_elements(sE00.v2)-1 do begin ; *** modified (v->v2)
        st_I[i,j] = rrE[0,0,i,j,0] + rrE[1,1,i,j,0]
        st_Q[i,j] = rrE[0,0,i,j,0] - rrE[1,1,i,j,0]
        st_U[i,j] = 2 * rrE[0,1,i,j,0]
        st_V[i,j] = 2 * rrE[0,1,i,j,1]
      endfor
    endfor

    st_chi = atan(st_U,st_Q)/2

    store_data, 'st_I', data={x:sE00.x, y:st_I, v:sE00.v2}
    store_data, 'st_Q/I', data={x:sE00.x, y:st_Q/st_I, v:sE00.v2}
    store_data, 'st_U/I', data={x:sE00.x, y:st_U/st_I, v:sE00.v2}
    store_data, 'st_V/I', data={x:sE00.x, y:st_V/st_I, v:sE00.v2}
    store_data, 'st_chi', data={x:sE00.x, y:st_chi, v:sE00.v2}

    options, 'st_I', ytitle='st_I'
    options, 'st_Q/I', ytitle='st_Q/I'
    options, 'st_U/I', ytitle='st_U/I'
    options, 'st_V/I', ytitle='st_V/I'
    options, 'st_chi', ytitle='st_chi'
    options, 'st_*', ysubtitle='Frequency [kHz]', spec = 1, color_table=70
    options, 'st_I', color_table=40
    ylim, 'st_*', 0.064, 20., 1 ; kHz
    zlim, 'st_*', -1., 1., 0 ;
    zlim, 'st_I', 1.e-10, 1., 1 ;

    tplot, ['st_I','st_Q/I','st_U/I','st_chi']
  endif


  ; ************************************
  ; 14.mask
  ; ************************************
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

  if stokes_on eq 1 then begin
    get_data, pr_matrix + 'Etotal_132', data=data_refE; *** modified (E_total_132 -> Etotal_132)
    cut_fE = 1E-8

    get_data, 'st_I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_Q/I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_Q/I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_U/I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_U/I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_V/I', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_fE)] = 'NaN'
    store_data, 'st_V/I_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim
    get_data, 'st_chi', data=data, dlim=dlim, lim=lim
    data.y[where(data_refE.y LT cut_f)] = 'NaN'
    store_data, 'st_chi_mask', data={x:data.x, y:data.y, v:data.v}, dlim=dlim, lim=lim

    ;  tplot, [pr_matrix + 'Bx_Bx_re', pr_matrix + 'By_By_re', pr_matrix + 'Bz_Bz_re', $
    ;    'kvec_mask', 'polarization_mask']
  endif


  ; ************************************
  ; 15.cal PA 未完成
  ; ************************************
  if calPA_on eq 1 then begin
    get_data, 'erg_mgf_l2_magt_8sec', data = magt
    ;      get_data, '', data =
    ;      LM = ;LMを取得
    BA = magt.x ;BAを取得

    cos2lambdaM = 1 / LM
    BE = 3.11e-5
    BM = BE / L^3 * (1 + 3*(1-cos2lambda))^(0.5) / cos2lambda^3
    alpha = arcsin(sqrt(BA/BM))
    PA = alpha / pi * 180  ; ラジアンをdegreeに変換
  endif

  ; ************************************
  ; 16.1.mepe PA
  ; ************************************
  erg_load_mepe,uname='erg_project', pass='geospace',datatype='3dflux'
  ; 特定の値のenergyを測っている。plotで決めた範囲内に観測しているエネルギー値がなければtplot変数にデータが入らない？
  ;    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='pa', energy=[10000,11000], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  ;    store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_10keV'
  erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[0.,3.], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_0-3'

  ;    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='pa', energy=[41000,42000], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  ;    store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_41keV'
  erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[177.,188.], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_177-188'

  ;    erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='pa', energy=[72000,73000], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  ;    store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_72keV'
  erg_mep_part_products, 'erg_mepe_l2_3dflux_FEDU',outputs='energy', pitch=[3.,37.5], regrid=[32,32], mag_name='erg_mgf_l2_mag_8sec_dsi', pos_name='erg_orb_l2_pos_gse', /no_ang_weight
  store_data, 'erg_mepe_l2_3dflux_FEDU_pa', newname='mepe_PA_3-37'


  ; ************************************
  ; 16.2.mepe ET
  ; ************************************
  erg_load_mepe,level='l2',datatype='omniflux'
  ; 'erg_mepe_l2_omniflux_FEDO'を取得
  store_data, 'erg_mepe_l2_omniflux_FEDO', newname='mepe_ET'


  ; ************************************
  ; 17-1.cal fce.etc
  ; ************************************
  get_data, 'erg_mgf_l2_magt_8sec', data=data
  fce = data.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.  ; local electron gyro freq
  fcp = data.y / 10^(9.) * 1.6 * 10^(-19.) / (1.6726D * 10^(-27.)) / 2. / !pi / 1000.  ; proton gyro freq
  flhr = sqrt(fce * fcp)                                                                  ; lower hybrid frequency
  fce_half = fce / 2.
  store_data, 'fce', data={x:data.x, y:fce}
  store_data, 'fce_half', data={x:data.x, y:fce_half}
  options, 'fce', colors=5, thick=2                   ; 5=yellow
  options, 'fce_half', colors=1, thick=2              ; 1=purple

  store_data, 'flhr', data={x:data.x, y:flhr}         ; *** added ***
  options, 'flhr', colors=0, thick=2, linestyle=2     ; 0=black / 2=broken line

  ; 磁場モデルの磁力線に沿ってトレースした磁気赤道面でのfc/2を計算
  erg_load_orb_l3, model='ts04' ; TS04モデル ##erg_orb_l3_pos_blocal_TS04##
  get_data, 'erg_orb_l3_pos_beq_TS04', data=B_TS04
  fce_TS04 = B_TS04.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.
  store_data, 'fce_TS04', data={x:B_TS04.x, y:fce_TS04}
  store_data, 'fce_TS04_half', data={x:B_TS04.x, y:fce_TS04/2.}

  erg_load_orb_l3, model='t89' ; T89モデル
  get_data, 'erg_orb_l3_pos_beq_t89', data=B_T89
  fce_T89 = B_T89.y / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.
  store_data, 'fce_T89', data={x:B_T89.x, y:fce_T89}
  store_data, 'fce_T89_half', data={x:B_T89.x, y:fce_T89/2.}

  get_data, 'erg_mgf_l2_igrf_8sec_dsi', data=B_IGRF_dsi ; IGRFモデル
  B_IGRF = sqrt(total(B_IGRF_dsi.y^2, 2))
  fce_IGRF = B_IGRF / 10^(9.) * 1.6 * 10^(-19.) / (9.1093D * 10^(-31.)) / 2. / !pi / 1000.
  store_data, 'fce_IGRF', data={x:B_IGRF_dsi.x, y:fce_IGRF}
  store_data, 'fce_IGRF_half', data={x:B_IGRF_dsi.x, y:fce_IGRF/2.}

  ; color: 0黒 1ピンク 2青 3シアン 4黄緑 5黄色 6赤 7以降黒
  ; linestyle: 0棒線 1破線(細) 2破線(長) 3破線(細＆長) 4破線(細*3＆長) 5以降破線(長)

  options, 'fce_TS04',      colors=1, thick=2, linestyle=0
  options, 'fce_TS04_half', colors=1, thick=2, linestyle=2
  options, 'fce_T89',       colors=6, thick=2, linestyle=0
  options, 'fce_T89_half',  colors=6, thick=2, linestyle=2
  options, 'fce_IGRF',      colors=4, thick=2, linestyle=0
  options, 'fce_IGRF_half', colors=4, thick=2, linestyle=2

  ; イベントプロットしてみる
  erg_load_pwe_ofa
  store_data, 'hfa_e_Bmodels', data=['erg_pwe_hfa_l2_high_spectra_e_mix', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']
  store_data, 'ofa_e_Bmodels', data=['erg_pwe_ofa_l2_spec_E_spectra_132', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']
  store_data, 'ofa_b_Bmodels', data=['erg_pwe_ofa_l2_spec_B_spectra_132', 'fce_TS04', 'fce_TS04_half', 'fce_T89', 'fce_T89_half', 'fce_IGRF', 'fce_IGRF_half']

  ylim,  'hfa_e_Bmodels', 10.0, 400.0, 1
  ylim,  'ofa_e_Bmodels', 1.0, 20.0, 1
  ylim,  'ofa_b_Bmodels', 1.0, 20.0, 1

  window, 0, xsize=1000, ysize=750
  tplot, ['hfa_e_Bmodels', 'ofa_e_Bmodels', 'ofa_b_Bmodels']

  stop

  ; ************************************
  ; 17-2.overplot fce.etc
  ; ************************************

  store_data, pr_matrix + 'Btotal_132_gyro', $
    data=[pr_matrix + 'Btotal_132', 'fce', 'fce_half','flhr']
  store_data, 'kvec_mask_gyro', data=['kvec_mask', 'fce', 'fce_half','flhr']
  store_data, 'polarization_mask_gyro', data=['polarization_mask', 'fce', 'fce_half','flhr']
  ylim, '*_gyro', 0.064, 20, 1 ; kHz
  zlim, pr_matrix + 'Btotal_132_gyro', 1E-2, 1E2, 1 ; pT^2/Hz
  options, 'erg_pwe_ofa_l2_Btotal_132_gyro', $
    ytitle='B total', ysubtitle='Frequency [kHz]', ztitle='[pT!U2!N/Hz]'

  ; *** added ***
  store_data, 'hfa_e_gyro', data=['erg_pwe_hfa_l2_low_spectra_e_mix', 'erg_pwe_hfa_l2_high_spectra_e_mix', 'fce', 'fce_half','flhr']
  store_data, 'ofa_e_gyro', data=['erg_pwe_ofa_l2_matrix_Etotal_132', 'fce', 'fce_half','flhr']
  options, 'ofa_e_gyro', 'ytitle', 'OFA-E'
  options, 'ofa_e_gyro', 'ysubtitle', 'frequency [kHz]'
  options, 'ofa_e_gyro', 'zbtitle', '[mV^2/m^2/Hz]'
  ylim,  'hfa_e_gyro', 20.0, 400.0, 1
  ylim,  'ofa_e_gyro', 0.064, 20.0, 1
  zlim,  ['hfa','ofa']+'_e_gyro', 1e-10, 1, 1

  options, pr_matrix + 'Btotal_132_gyro', 'ytitle', 'OFA-B'
  options, pr_matrix + 'Btotal_132_gyro', 'ysubtitle', 'frequency [kHz]'
  options, pr_matrix + 'Btotal_132_gyro', 'zbtitle', '[pT^2/Hz]'

  ; window, xsize=1200, ysize=600
  tplot, ['hfa_e','ofa_e', pr_matrix + 'Btotal_132', 'kvec_mask', 'polarization_mask'] + '_gyro'


  ; ************************************
  ; 18.plot
  ; ************************************

  SET_PLOT, 'Z'
  DEVICE, SET_RESOLUTION = [1500,1800]
  !p.BACKGROUND = 255
  !p.color = 0

  get_timespan, td
  ts = time_string(td[0])
  ret = strsplit(ts, '-/:', /extract)

  options, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'mepe_PA_10keV', 'mepe_PA_41keV', 'mepe_PA_72keV', 'mepe_ET'], 'datagap', 60.0

  tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'mepe_PA_10keV', 'mepe_PA_41keV', 'mepe_PA_72keV', 'mepe_ET']
  makepng, 'erg_ofa_matrix_mepe_'+ret[0]+ret[1]+ret[2]

  if hourplot_on eq 1 then begin
    n_plot = fix(24.0/span)
    for i=0, n_plot-1 do begin
      timespan, [td[0]+3600.0*span*i, td[0]+3600.0*span*(i+1)]
      tplot, ['hfa_e_gyro', 'ofa_e_gyro', 'ofa_b_gyro', 'kvec_mask_gyro', 'polarization_mask_gyro', 'mepe_PA_10keV', 'mepe_PA_41keV', 'mepe_PA_72keV', 'mepe_ET']
      makepng, 'erg_ofa_matrix_mepe_'+ret[0]+ret[1]+ret[2]+'_'+string(span*i,format='(i2.2)')
    endfor
  endif

end
