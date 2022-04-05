pro calc_wave_params, moving_average=moving_average, algebraic_SVD=algebraic_SVD

  ; *****************
  ; calculate wave params
  ; *****************

  if not keyword_set(moving_average) then moving_average = 3
  if not keyword_set(algebraic_SVD) then algebraic_SVD = 0 ; algebraic_SVD=1 だと algebraic SVD も計算する

  uname = 'erg_project'
  pass = 'geospace'

  ; *****************
  ; 1.load data
  ; *****************

  ;磁場読み込み
  erg_load_mgf, datatype='8sec', uname=uname, pass=pass
  erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass

  ;OFA読み込み
  erg_load_pwe_ofa, datatype='matrix', uname=uname, pass=pass  

  
  ; *****************
  ; 2.2.OFA-MATRIX B to spacrla matrix
  ; *****************
  pr_matrix = 'erg_pwe_ofa_l2_matrix_'
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
  ; 2.1.OFA-MATRIX E to spacrla matrix
  ; *****************
  ; get_data, pr_matrix + 'Ex_Ex_132', data=sE00
  ; get_data, pr_matrix + 'Ex_Ey_132', data=sE01
  ; get_data, pr_matrix + 'Ey_Ex_132', data=sE10
  ; get_data, pr_matrix + 'Ey_Ey_132', data=sE11

  ; ; rrE : [ 2x2matrix 2D-1, 2x2matrix 2D-2, time, Energy, Re&Im ]
  ; rrE=dblarr(2,2,n_elements(sE00.x),n_elements(sE00.v2),2) ; *** modified (v->v2)
  ; rrE[0,0,*,*,*]=sE00.y & rrE[1,0,*,*,*]=sE01.y
  ; rrE[0,1,*,*,*]=sE10.y & rrE[1,1,*,*,*]=sE11.y


  ; *****************
  ; 3.1.calc. rotation matrix B
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
  ; 3.2.calc. rotation matrix E
  ; *****************
  ; split_vec, 'erg_mgf_l2_mag_64hz_sgi'
  ; tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_x', pr_matrix+'Ex_Ex_132'
  ; tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_y', pr_matrix+'Ex_Ex_132'
  ; tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_z', pr_matrix+'Ex_Ex_132'

  ; get_data, 'erg_mgf_l2_mag_64hz_sgi_x_interp', data=data_x, dlim=dlim_x, lim=lim_x
  ; get_data, 'erg_mgf_l2_mag_64hz_sgi_y_interp', data=data_y, dlim=dlim_y, lim=lim_y
  ; get_data, 'erg_mgf_l2_mag_64hz_sgi_z_interp', data=data_z, dlim=dlim_z, lim=lim_z

  ; ; x,y平面のみxがx,y平面上の磁力線に沿った向きになるように回転させる

  ; rotmatE=dblarr(2,2,n_elements(data_x.x))
  ; rotmat_tE=dblarr(2,2,n_elements(data_x.x))
  ; for i=0, n_elements(data_x.x)-1 do begin
  ;   bvec=[data_x.y[i],data_y.y[i],data_z.y[i]]
  ;   zz=[0.,0.,1.]
  ;   xhat=bvec-bvec*zz ;*: 内積
  ;   yhat=crossp(zz,xhat)
  ;   xhat=xhat/sqrt(xhat[0]^2+xhat[1]^2+xhat[2]^2)
  ;   yhat=yhat/sqrt(yhat[0]^2+yhat[1]^2+yhat[2]^2)
  ;   rotmatE[*,*,i]=([[xhat[0:1]],[yhat[0:1]]])
  ;   rotmat_tE[*,*,i]=transpose([[xhat[0:1]],[yhat[0:1]]])
  ; endfor


  ; *****************
  ; 4.1.rotate MGF (test)
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
  ; 4.2.rotate OFA matrix B
  ; ************************************

  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-1 do begin ; *** modified (v->v2)
      for k=0, 1 do begin
        rr[*,*,i,j,k] = (rotmat[*,*,i] ## rr[*,*,i,j,k]) ## rotmat_t[*,*,i]
      endfor
    endfor
  endfor


  ; ************************************
  ; 4.3.rotate OFA matrix E
  ; ************************************


  ; for i=0, n_elements(sE00.x)-1 do begin
  ;   for j=0, n_elements(sE00.v2)-1 do begin ; *** modified (v->v2)
  ;     for k=0, 1 do begin
  ;       rrE[*,*,i,j,k] = (rotmatE[*,*,i] ## rrE[*,*,i,j,k]) ## rotmat_tE[*,*,i]
  ;     endfor
  ;   endfor
  ; endfor


  ; ************************************
  ; 5.1.auto-spectra B
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
  ; 5.2.auto-spectra E
  ; ************************************
  ; get_data, pr_matrix + 'Ex_Ex_132',data=data, dlim=dlim, lim=lim
  ; store_data, pr_matrix + 'Ex_Ex_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  ; store_data, pr_matrix + 'Ex_Ex_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  
  ; get_data, pr_matrix + 'Ey_Ey_132',data=data, dlim=dlim, lim=lim
  ; store_data, pr_matrix + 'Ey_Ey_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  ; store_data, pr_matrix + 'Ey_Ey_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)

  ; options, pr_matrix + 'Ex_Ex_re', ytitle='Re(ExEx*)'
  ; options, pr_matrix + 'Ex_Ex_im', ytitle='Im(ExEx*)'
  ; options, pr_matrix + 'Ey_Ey_re', ytitle='Re(EyEy*)'
  ; options, pr_matrix + 'Ey_Ey_im', ytitle='Im(EyEy*)'
  ; options, pr_matrix + 'E?_E?_??', ysubtitle = 'Frequency [kHz]'
  ; options, pr_matrix + 'E?_E?_??', ztitle = '[pT!U2!N/Hz]'
  ; ylim, pr_matrix + 'E?_E?_??', 0.064, 20, 1 ; kHz
  ; zlim, pr_matrix + 'E?_E?_??', 1E-3, 1E2, 1 ; nT

  ; ************************************
  ; 6.moving average
  ; ************************************
  ; rrをrrrに保存、移動平均をrrに保存
  if moving_average ne 1 then begin
    rrr = rr * 0.0

    for i=0, n_elements(s00.x)-1 do begin
      for j=1, n_elements(s00.v2)-2 do begin 

          idx_j = j + indgen(moving_average) - uint(moving_average/2)
          rrr[0,0,i,j,0] = total( rr[0,0,i,idx_j,0] ) / double(moving_average)
          rrr[0,0,i,j,1] = total( rr[0,0,i,idx_j,1] ) / double(moving_average)
          rrr[0,1,i,j,0] = total( rr[0,1,i,idx_j,0] ) / double(moving_average)
          rrr[0,1,i,j,1] = total( rr[0,1,i,idx_j,1] ) / double(moving_average)
          rrr[0,2,i,j,0] = total( rr[0,2,i,idx_j,0] ) / double(moving_average)
          rrr[0,2,i,j,1] = total( rr[0,2,i,idx_j,1] ) / double(moving_average)

          rrr[1,0,i,j,0] = total( rr[1,0,i,idx_j,0] ) / double(moving_average)
          rrr[1,0,i,j,1] = total( rr[1,0,i,idx_j,1] ) / double(moving_average)
          rrr[1,1,i,j,0] = total( rr[1,1,i,idx_j,0] ) / double(moving_average)
          rrr[1,1,i,j,1] = total( rr[1,1,i,idx_j,1] ) / double(moving_average)
          rrr[1,2,i,j,0] = total( rr[1,2,i,idx_j,0] ) / double(moving_average)
          rrr[1,2,i,j,1] = total( rr[1,2,i,idx_j,1] ) / double(moving_average)

          rrr[2,0,i,j,0] = total( rr[2,0,i,idx_j,0] ) / double(moving_average)
          rrr[2,0,i,j,1] = total( rr[2,0,i,idx_j,1] ) / double(moving_average)
          rrr[2,1,i,j,0] = total( rr[2,1,i,idx_j,0] ) / double(moving_average)
          rrr[2,1,i,j,1] = total( rr[2,1,i,idx_j,1] ) / double(moving_average)
          rrr[2,2,i,j,0] = total( rr[2,2,i,idx_j,0] ) / double(moving_average)
          rrr[2,2,i,j,1] = total( rr[2,2,i,idx_j,1] ) / double(moving_average)

      endfor
    endfor
  
    rr_ = rrr
  endif else begin

    rr_ = rr

  endelse



  ; ************************************
  ; 6.SVD analysis
  ; ************************************
  ;  erg_calc_pwe_wna.pro を参考に作成

  n_t = n_elements(s00.x)
  n_e = n_elements(s00.v2)

  A=dblarr(3,6,n_t,n_e)
  W2=dblarr(3,n_t,n_e)
  V2=dblarr(3,3,n_t,n_e)
  W_SORT=dblarr(3,n_t,n_e)
  V_SORT=dblarr(3,3,n_t,n_e)

  A[0,0,*,*]=rr_[0,0,*,*,0] & A[1,0,*,*]=rr_[1,0,*,*,0]  & A[2,0,*,*]=rr_[2,0,*,*,0]
  A[0,1,*,*]=rr_[1,0,*,*,0] & A[1,1,*,*]=rr_[1,1,*,*,0]  & A[2,1,*,*]=rr_[2,1,*,*,0]
  A[0,2,*,*]=rr_[2,0,*,*,0] & A[1,2,*,*]=rr_[2,1,*,*,0]  & A[2,2,*,*]=rr_[2,2,*,*,0]
  A[0,3,*,*]=0.0           & A[1,3,*,*]=-rr_[1,0,*,*,1] & A[2,3,*,*]=-rr_[2,0,*,*,1]
  A[0,4,*,*]=rr_[1,0,*,*,1] & A[1,4,*,*]=0.0            & A[2,4,*,*]=-rr_[2,1,*,*,1]
  A[0,5,*,*]=rr_[2,0,*,*,1] & A[1,5,*,*]=rr_[2,1,*,*,1]  & A[2,5,*,*]=0.0


  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-1 do begin
    
      LA_SVD,reform(A[*,*,i,j]),W,U,V,/double ; W: 特異値を含む行列  U: 左特異ベクトル  V: 右特異ベクトル
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
  ; 7.WNA, polarization and planarity 
  ; ************************************
  ;  erg_calc_pwe_wna.pro を参考に作成

  powspec_b = dblarr(n_t,n_e)
  wna = dblarr(n_t,n_e)
  polarization = dblarr(n_t,n_e)
  planarity = dblarr(n_t,n_e)
  lambda1 = dblarr(n_t,n_e)
  lambda2 = dblarr(n_t,n_e)
  lambda3 = dblarr(n_t,n_e)


  for i=0, n_elements(s00.x)-1 do begin
    for j=0, n_elements(s00.v2)-2 do begin
      ; power spec
      powspec_b[i,j] = sqrt(A[0,0,i,j]^2 + A[1,1,i,j]^2 + A[2,2,i,j]^2)
      ; wave normal
      wna[i,j] = abs(atan(sqrt(V_SORT[0,0,i,j]^2+V_SORT[0,1,i,j]^2)/V_SORT[0,2,i,j])/!dtor) ;[degree]
      ; wna_azm[i,j] = atan(V_SORT[0,1,i,j], V_SORT[0,0,i,j])/!dtor 
      ; polarization
      polarization[i,j] = W_SORT[1,i,j]/W_SORT[2,i,j]
      if(rr_[1,0,i,j,1] LT 0.) then polarization[i,j] *= -1.
      ; planarity
      planarity[i,j] = 1. - sqrt(W_SORT[0,i,j]/W_SORT[2,i,j])

      ;lambda
      lambda1[i,j] = W_sort[0,i,j]
      lambda2[i,j] = W_sort[1,i,j]
      lambda3[i,j] = W_sort[2,i,j]

    endfor
  endfor

  ma = ''
  if moving_average ne 1 then ma = '_ma'+string(moving_average, FORMAT='(i0)')

  store_data, 'powspec_b_LASVD'+ma, data={x:s00.x, y:powspec_b, v:s00.v2} ; *** modified (v->v2)
  options, 'powspec_b_LASVD'+ma, ytitle='powspec_b!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'powspec_b_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'powspec_b_LASVD'+ma, 1E-4, 1E2, 1 ; nT
  
  store_data, 'kvec_LASVD'+ma, data={x:s00.x, y:wna, v:s00.v2} ; *** modified (v->v2)
  options, 'kvec_LASVD'+ma, ytitle='wave normal angle!CLA SVD'+ma, $
    ztitle='[degree]', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'kvec_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'kvec_LASVD'+ma, 0., 90, 0 ; degree

  store_data, 'polarization_LASVD'+ma, data={x:s00.x, y:polarization, v:s00.v2} ; *** modified (v->v2)
  options, 'polarization_LASVD'+ma, ytitle='polarization!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'polarization_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'polarization_LASVD'+ma, -1., 1., 0 ; degree

  store_data, 'planarity_LASVD'+ma, data={x:s00.x, y:planarity, v:s00.v2} ; *** modified (v->v2)
  options, 'planarity_LASVD'+ma, ytitle='planarity!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'planarity_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'planarity_LASVD'+ma, 0., 1., 0

  ;lambda1
  ; lambda1 = dblarr(n_elements(s00.x), n_elements(s00.v2))
  ; for i=0, n1(s00.)
  ; lambda1[*,*] = W_sort[0,*,*]
  store_data, 'lambda1_LASVD'+ma, data={x:s00.x, y:lambda1, v:s00.v2} ; *** modified (v->v2)
  options, 'lambda1_LASVD'+ma, ytitle='lambda1!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'lambda1_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'lambda1_LASVD'+ma, 0., 10., 0
  zlim, ['lambda1_LASVD'+ma,'lambda2_LASVD'+ma,'lambda3_LASVD'+ma], 0., 10., 0

  ;lambda2
  store_data, 'lambda2_LASVD'+ma, data={x:s00.x, y:lambda2, v:s00.v2} ; *** modified (v->v2)
  options, 'lambda2_LASVD'+ma, ytitle='lambda2!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'lambda2_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'lambda2_LASVD'+ma, 0., 10., 0

  ;lambda3
  store_data, 'lambda3_LASVD'+ma, data={x:s00.x, y:lambda3, v:s00.v2} ; *** modified (v->v2)
  options, 'lambda3_LASVD'+ma, ytitle='lambda3!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'lambda3_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'lambda3_LASVD'+ma, 0., 10., 0

    ;lambda2-1
  store_data, 'lambda2-1_LASVD'+ma, data={x:s00.x, y:lambda2-lambda1, v:s00.v2} ; *** modified (v->v2)
  options, 'lambda2-1_LASVD'+ma, ytitle='lambda2-1!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'lambda2-1_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'lambda2-1_LASVD'+ma, 0., 0.1, 0

  ;lambda3-2
  store_data, 'lambda3-2_LASVD'+ma, data={x:s00.x, y:lambda3-lambda2, v:s00.v2} ; *** modified (v->v2)
  options, 'lambda3-2_LASVD'+ma, ytitle='lambda3-2!CLA SVD'+ma, $
    ztitle='', ysubtitle='Frequency [kHz]', spec = 1
  ylim, 'lambda3-2_LASVD'+ma, 0.064, 20, 1 ; kHz
  zlim, 'lambda3-2_LASVD'+ma, 0., 0.1, 0

  ; ************************************
  ; 7*.WNA, polarization and planarity with Algebraic SVD? or Means et al 1972
  ; ************************************

  if algebraic_SVD then begin

    wna_algebraic = dblarr(n_t,n_e)
    polarization_algebraic = dblarr(n_t,n_e)

    for i=0, n_elements(s00.x)-1 do begin
      for j=0, n_elements(s00.v2)-1 do begin ; *** modified (v->v2)
        ; wave normal
        wna_x = rr_[2,1,i,j,1] / sqrt(rr_[2,1,i,j,1]^2 + rr_[0,2,i,j,1]^2 + rr_[1,0,i,j,1]^2)
        wna_y = rr_[0,2,i,j,1] / sqrt(rr_[2,1,i,j,1]^2 + rr_[0,2,i,j,1]^2 + rr_[1,0,i,j,1]^2)
        wna_z = rr_[1,0,i,j,1] / sqrt(rr_[2,1,i,j,1]^2 + rr_[0,2,i,j,1]^2 + rr_[1,0,i,j,1]^2)

        wna_algebraic[i,j] = abs(atan(sqrt(wna_x^2+wna_y^2)/wna_z)/!dtor)

        polarization_algebraic[i,j] = $
          (2 * rr_[1,0,i,j,1]) / (rr_[0,0,i,j,0] + rr_[1,1,i,j,0])
      endfor
    endfor

    store_data, 'kvec_algebraicSVD'+ma, data={x:s00.x, y:wna_algebraic, v:s00.v2} ; *** modified (v->v2)
    options, 'kvec_algebraicSVD'+ma, ytitle='wave normal angle/algebraic SVD'+'  '+ma, $
      ztitle='[degree]', ysubtitle='Frequency [kHz]', spec = 1
    ylim, 'kvec_algebraicSVD'+ma, 0.064, 20, 1 ; kHz
    zlim, 'kvec_algebraicSVD'+ma, 0., 90, 0 ; degree

    store_data, 'polarization_algebraicSVD'+ma, data={x:s00.x, y:polarization_algebraic, v:s00.v2} ; *** modified (v->v2)
    options, 'polarization_algebraicSVD'+ma, ytitle='polarization/algebraic SVD'+'  '+ma, ysubtitle='Frequency [kHz]', spec = 1
    ylim, 'polarization_algebraicSVD'+ma, 0.064, 20., 1 ; kHz
    zlim, 'polarization_algebraicSVD'+ma, -1., 1., 0 ;

  endif



end