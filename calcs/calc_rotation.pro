
; compile
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/calcs/calc_rotation.pro'
; for test use
; timespan, '2017-07-03/04:32:00', 1, /minute

; input
;   tplot 'erg_mgf_l2_mag_64hz_sgi', 'erg_pwe_wfc_l2_b_65khz_B?_waveform'

; output
;   tplot 'wfc_b_B?_waveform', 'wfc_b_waveform'


pro calc_rotation

  ; *****************
  ; 1.load data. background B, waveform B
  ; *****************
  ; uname = 'erg_project'
  ; pass = 'geospace'

  ; erg_load_mgf, datatype='64hz', coord='sgi', uname=uname, pass=pass
  ; erg_load_pwe_wfc

  ; *****************
  ; 2.calc. rotation matrix B
  ; *****************
  split_vec, 'erg_mgf_l2_mag_64hz_sgi'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_x', 'erg_pwe_wfc_l2_b_65khz_Bx_waveform'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_y', 'erg_pwe_wfc_l2_b_65khz_Bx_waveform'
  tinterpol_mxn, 'erg_mgf_l2_mag_64hz_sgi_z', 'erg_pwe_wfc_l2_b_65khz_Bx_waveform'

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


  ; ************************************
  ; 3.rotate waveform B
  ; ************************************

  get_data, 'erg_pwe_wfc_l2_b_65khz_Bx_waveform', data=Bx
  get_data, 'erg_pwe_wfc_l2_b_65khz_By_waveform', data=By
  get_data, 'erg_pwe_wfc_l2_b_65khz_Bz_waveform', data=Bz

  rr=dblarr(3,n_elements(Bx.x))
  rr[0,*]=Bx.y & rr[1,*]=By.y & rr[2,*]=Bz.y

  for i=0, n_elements(Bx.x)-1 do begin
    rr[*,i] = rotmat_t[*,*,i] # rr[*,i]
  endfor


  ; ************************************
  ; 4.rotate MGF B : test
  ; ************************************

  rr_test=dblarr(3,n_elements(data_x.x))
  rr_test[0,*]=data_x.y & rr_test[1,*]=data_y.y & rr_test[2,*]=data_z.y

  for i=0, n_elements(data_x.x)-1 do begin
    rr_test[*,i] = rotmat_t[*,*,i] # rr_test[*,i]
  endfor



  ; ************************************
  ; 5.store data
  ; ************************************

  store_data, 'wfc_b_Bx_waveform', data={x:Bx.x, y:transpose(rr[0,*])}
  store_data, 'wfc_b_By_waveform', data={x:Bx.x, y:transpose(rr[1,*])}
  store_data, 'wfc_b_Bz_waveform', data={x:Bx.x, y:transpose(rr[2,*])}
  store_data, 'wfc_b_waveform', data={x:Bx.x, y:transpose(rr)}

  store_data, 'wfc_b_Bx_test', data={x:data_x.x, y:transpose(rr_test[0,*])}
  store_data, 'wfc_b_By_test', data={x:data_x.x, y:transpose(rr_test[1,*])}
  store_data, 'wfc_b_Bz_test', data={x:data_x.x, y:transpose(rr_test[2,*])}


  tplot_save, 'wfc_b_Bx_waveform', filename='/Users/ampuku/Dropbox/WFC_dep_duct_event/wfc_b_Bx_waveform'
  tplot_save, 'wfc_b_By_waveform', filename='/Users/ampuku/Dropbox/WFC_dep_duct_event/wfc_b_By_waveform'
  tplot_save, 'wfc_b_Bz_waveform', filename='/Users/ampuku/Dropbox/WFC_dep_duct_event/wfc_b_Bz_waveform'
  tplot_save, 'wfc_b_waveform', filename='/Users/ampuku/Dropbox/WFC_dep_duct_event/wfc_b_waveform'

end

; 北村さんに送ったplot作成用
;   erg_load_pwe_wfc, datatype='spec'

;   SET_PLOT, 'Z'
;   DEVICE, SET_RESOLUTION = [1000,1200]
;   !p.BACKGROUND = 255
;   !p.color = 0

;   ylim, ['erg_pwe_wfc_l2_e_65khz_E_spectra', 'erg_pwe_wfc_l2_b_65khz_B_spectra'], 1000, 12000, 0
;   tplot, ['erg_pwe_wfc_l2_e_65khz_E_spectra', 'erg_pwe_wfc_l2_b_65khz_B_spectra', 'wfc_b_Bx_waveform', 'wfc_b_By_waveform', 'wfc_b_Bz_waveform']

;   makepng, '/Users/ampuku/Dropbox/WFC_dep_duct_event/event_plot'


