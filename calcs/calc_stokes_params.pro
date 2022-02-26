pro calc_stokes_params

  ; *****************
  ; calculate stokes params
  ; *****************

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
  ; 2.1.OFA-MATRIX E to spacrla matrix
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
  ; 3.2.calc. rotation matrix E
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



  ; ************************************
  ; 4.3.rotate OFA matrix E
  ; ************************************


  for i=0, n_elements(sE00.x)-1 do begin
    for j=0, n_elements(sE00.v2)-1 do begin ; *** modified (v->v2)
      for k=0, 1 do begin
        rrE[*,*,i,j,k] = (rotmatE[*,*,i] ## rrE[*,*,i,j,k]) ## rotmat_tE[*,*,i]
      endfor
    endfor
  endfor


  ; ************************************
  ; 5.2.auto-spectra E
  ; ************************************
  get_data, pr_matrix + 'Ex_Ex_132',data=data, dlim=dlim, lim=lim
  store_data, pr_matrix + 'Ex_Ex_re', data={x:data.x,y:data.y[*,*,0],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  store_data, pr_matrix + 'Ex_Ex_im', data={x:data.x,y:data.y[*,*,1],v:data.v2}, dlim=dlim, lim=lim ; *** modified (v->v2)
  
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
  ; 13.stokes parameter
  ; ************************************

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


end