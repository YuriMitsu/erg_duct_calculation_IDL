; usage: ERG> load_fufp_txt, file, trange=trange, err=err, ver=ver
; ex1)   ERG> time_span, '2017-04-01'
;        ERG> load_fufp_txt
; ex1)   ERG> time_span, '2017-04-01'
;        ERG> load_fufp_txt, ver='v01_03'
; ex1)   ERG> load_fufp_txt, 'Z:\uhrdata\hfa_l3\2017\hfa_l3_20170401_v01_02.txt'
;
;------------------------------------------------------------------
;
pro load_fufp_txt, trange=trange, err=err, file_src=file_src, high=high

  err=0
  if keyword_set(trange) then timespan, trange
;  template_file = 'C:\Data\ERG\HFA\L3\text\hfa_l3_ne_temp_v03.sav'
  template_file = '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/uhrHtool/hfa_l3_ne_temp_v03.sav'
  restore, filename = template_file

  ;-------------------------------
  ; Download HFA L3 electron density data
  ;-------------------------------
  if keyword_set(high) then begin
    remotedir = 'http://adrastea.gp.tohoku.ac.jp/~erg/data/hfa_l3_h/'
    localdir = root_data_dir() + 'ERG\HFA\L3\text\'
    relfpathfmt = 'YYYY/erg_hfa_l3_high_YYYYMMDD.txt'
  endif else begin
    remotedir = 'http://adrastea.gp.tohoku.ac.jp/~erg/data/hfa_l3/'
    localdir = root_data_dir() + 'ERG\HFA\L3\text\'
    relfpathfmt = 'YYYY/hfa_l3_YYYYMMDD_v??_??.txt'    
  endelse
  
  relfpaths = file_dailynames(file_format=relfpathfmt, trange=trange, times=times)
  datfiles = $
    spd_download( remote_file = relfpaths, $
    remote_path = remotedir, local_path = localdir, url_username='erg_project', url_password='geospace', /last_version, $
    /force_download, _extra=_extra )

  ; Number of data files
  nd = n_elements(datfiles)

  ;-------------------------------
  ; read HFA L3 electron density data
  ;-------------------------------
  if file_exist(datfiles[0]) ne 1 then begin
    err=1
    return
  endif

  ts    = []
  r     = []
  glat  = []
  mlt   = []
  l_val = []
  b     = []
  fce   = []
  fuh   = []
  fpe   = []
  dne   = []

  file_src = file_basename(datfiles[nd/2])
  for k = 0, nd-1 do begin
    
    hfa_l3 = read_ascii(datfiles[k], template=hfa_l3_ne_temp, count=count)
    if count eq 0 then continue

    n = n_elements(hfa_l3.date)

    for i=0, n-1 do begin
      yr = strmid(hfa_l3.date[i],0,4)
      mn = strmid(hfa_l3.date[i],4,2)
      dy = strmid(hfa_l3.date[i],6,2)
      hr = fix(hfa_l3.hour[i])
      mm = fix(fix(hfa_l3.hour[i]*60)   - hr*60)
      sc = fix(fix(hfa_l3.hour[i]*3600) - hr*3600 - mm*60)
      ts = [ts, string(yr,mn,dy,hr,mm,sc, format='(i4,"-",i2.2,"-",i2.2,"/",i2.2,":",i2.2,":",i2.2)')]
    endfor

    r     = [ r,    hfa_l3.r              ]
    glat  = [ glat, hfa_l3.glat           ]
    mlt   = [ mlt,  hfa_l3.mlt            ]
    l_val = [ l_val,hfa_l3.l_val          ]
    b     = [ b,    hfa_l3.b              ]
    fce   = [ fce,  hfa_l3.fce * 1000.0  ]
    fuh   = [ fuh,  hfa_l3.fuh * 1000.0  ]
    fpe   = [ fpe,  hfa_l3.fpe * 1000.0  ]
    dne   = [ dne,  hfa_l3.dne            ]

  endfor

  
  td = time_double(ts); + 30.0
  store_data, 'hfa_l3_r',    data={x:td,y:r}
  options, 'hfa_l3_r', 'ytitle', 'R[RE]'
  store_data, 'hfa_l3_glat', data={x:td,y:glat}
  options, 'hfa_l3_glat','ytitle', 'GMAT[deg]'
  store_data, 'hfa_l3_mlt',  data={x:td,y:mlt}
  options, 'hfa_l3_mlt','ytitle','MLT[hour]'
  store_data, 'hfa_l3_L',    data={x:td,y:l_val}
  options, 'hfa_l3_L', 'ytitle','L-val'
  store_data, 'hfa_l3_b',    data={x:td,y:b}
  options, 'hfa_l3_b','ytitle','B[nT]'
  store_data, 'hfa_l3_fce',  data={x:td,y:fce}
  options, 'hfa_l3_fce','ytitle','Fce[kHz]'
  store_data, 'hfa_l3_fuh',  data={x:td,y:fuh};, dlim={colors:5,thick:2}
  options, 'hfa_l3_fuh','ytitle','Fuhr[kHz]'
  store_data, 'hfa_l3_fpe',  data={x:td,y:fpe};, dlim={colors:5,thick:2,linestyle:2}
  options, 'hfa_l3_fpe','ytitle','Fpe[kHz]'
  store_data, 'hfa_l3_ne',   data={x:td,y:dne}
  options, 'hfa_l3_ne','ytitle','Ne[/cc]'
  
  fzc = sqrt( (fce/2.0)^2 + (fpe)^2 ) - (fce)/2.0  ; z-mode cutoff. [kHz]
  store_data, 'hfa_l3_fzc',  data={x:td,y:fzc};,               dlim={colors:5,thick:2,linestyle:2}
  options, 'hfa_l3_fzc','ytitle','Fzc[kHz]'

  fpi = fpe * sqrt(1.6726219D * 10^(-27.) / (9.1093D * 10^(-31.)))
  fcp = fce * 1.6726219D * 10^(-27.) / (9.1093D * 10^(-31.))
  flh = 1.0/sqrt(1.0/(fce*fcp)+1.0/(fpi*fpi))
  store_data, 'hfa_l3_flh',  data={x:td,y:flh};,               dlim={colors:4,thick:1}
  options, 'hfa_l3_flh','ytitle','Flh[kHz]'
  
end
