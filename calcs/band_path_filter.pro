pro band_path_filter, in_data, t, bandfreq, out_data, out_t

  nnn = n_elements(in_data)
  in_data = in_data[0:nnn-(nnn mod long(1024))-1]
;  in_data = in_data[0:3670016-1]
  t = t[0:nnn-(nnn mod long(1024))-1]
;  t = t[0:3670016-1]
  out_t = t
  dt = t[10]-t[9]
  bandwidth = 2.0
;  bandfreq = bandfreq
    
  ;fft
  n = n_elements(in_data)
  f = fft(in_data)
  f_org = f
  
  ;frequency
  x = findgen((n - 1)/2) + 1
  is_n_even = (n mod 2) eq 0 ;偶数:True 奇数:False
  if (is_n_even) then freq = [0.0, x, n/2, -n/2 + x]/(n*dt) $
  else                freq = [0.0, x, -(n/2 + 1) + x]/(n*dt)
  
  ; plot spectrum (before filtering)
  if 1 then begin
    window, 1
    !p.multi=[0,1,2]
    yrange = [min(abs(f)),max(abs(f))]
    plot,freq, abs(f), /ylog, xtitle='Frequency (Hz)', ytitle='Amplitude', yrange=yrange, title='Spectrum before filtering'
  endif
  
  ; get f index of bandfreq
  idx = [0., 0.]
  bfidx = min(abs(freq[0:n/2]-bandfreq[0]), ind)
  idx[0] = ind
  bfidx = min(abs(freq[0:n/2]-bandfreq[1]), ind)
  idx[1] = ind

  ; set new f
  f_abs = abs(f)

  df = 1.0/(n*dt)
  nf = fix(bandwidth/df)

  imax = min(idx)

  f[0:imax-nf-1] *= 0.

  for j=-nf,0 do begin
    if imax+j lt 0 then continue
    if imax+j ge n then continue
    fact = 1. - float(abs(j)) / float(nf)
    f[imax+j] *= fact
  endfor
  
  imax = max(idx)

  for j=0,nf do begin
    if imax+j lt 0 then continue
    if imax+j ge n then continue
    fact = 1. - float(abs(j)) / float(nf)
    f[imax+j] *= fact
  endfor
  
  f[imax+nf+1:n/2] *= 0.
  
  
  ; get f index of bandfreq
  idx = [0., 0.]
  bfidx = min(abs(-freq[n/2:-1]-bandfreq[0]), ind)
  idx[0] = ind + n/2
  bfidx = min(abs(-freq[n/2:-1]-bandfreq[1]), ind)
  idx[1] = ind + n/2

  ; set new f
  f_abs = abs(f)

  df = 1.0/(n*dt)
  nf = fix(bandwidth/df)

  imax = min(idx)

  f[n/2:imax-nf-1] *= 0.

  for j=-nf,0 do begin
    if imax+j lt 0 then continue
    if imax+j ge n then continue
    fact = 1. - float(abs(j)) / float(nf)
    f[imax+j] *= fact
  endfor

  imax = max(idx)

  for j=0,nf do begin
    if imax+j lt 0 then continue
    if imax+j ge n then continue
    fact = 1. - float(abs(j)) / float(nf)
    f[imax+j] *= fact
  endfor

  f[imax+nf+1:-1] *= 0.
  
  
  

  ; plot spectrum (after filtering)
  if 1 then begin
    plot, freq, abs(f), /ylog, xtitle='Frequency (Hz)', ytitle='Amplitude', yrange=yrange, title='Spectrum after filtering'
    !p.multi=0
  endif

  out_data = fft(f, /inverse)
  

end