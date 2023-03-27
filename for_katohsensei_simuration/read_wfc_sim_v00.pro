; .compile '/Users/ampuku/Documents/duct/code/IDL/for_katohsensei_simuration/read_wfc_sim_v00.pro' 


pro read_wfc_sim_v00,dir=dir

; omega_ce = 2*!dpi*2000.
; omega_ce = 1./2/!dpi
omega_ce = 1.0D

if not keyword_set(dir) then dir = 'N033_H0026/'

dir = '/Users/ampuku/Desktop/Katohsnisei_simulation/02fcdata/' + dir

datafile = file_search(dir+'wfc_b?_waveform.txt')
timefile = file_search(dir+'wfc_time.txt')

nl = file_lines(dir+'wfc_time.txt')

bx = fltarr(nl)
by = fltarr(nl)
bz = fltarr(nl)
tt = dblarr(nl)

bx_tmp = 0.
by_tmp = 0.
bz_tmp = 0.
tt_tmp = 0D

ii = 0L

close,1 & openr,1,datafile[0]
close,2 & openr,2,datafile[1]
close,3 & openr,3,datafile[2]
close,4 & openr,4,timefile

for ii=0L,nl-1 do begin

	readf,1,bx_tmp
	readf,2,by_tmp
	readf,3,bz_tmp
	readf,4,tt_tmp

	bx[ii] = bx_tmp
	by[ii] = by_tmp
	bz[ii] = bz_tmp
	tt[ii] = tt_tmp

endfor

store_data,'wfc_b',data={x:tt*omega_ce,y:[[bx],[by],[bz]]*1e9}

sim_mag_svd

stop

end