; Created by Satoshi Kurita!!
; Added by Ampuku.
; .compile '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/ampuku/makewave_ofa.pro'

; mag_svd_test_ver_ofa,wna_inp=[45.,45.,45.,45.],phi_inp=[0.,30.,60.,90.],rate_inp=[10.,10.,10.,10.]/4.,enr=enr[i],bnr=bnr[l],f_average=3,t_average=4
; makewave_ofa,wna=45.,phi=0.,rate=10.,enr=1e-3,bnr=1e-3

pro makewave_ofa,wna=wna,phi=phi,rate=rate,rmode=rmode,lmode=lmode,enr=nlevel_e,bnr=nlevel_b

if n_elements(wna) ne n_elements(phi) then begin
    print, 'Make wna and phi an array of the same length.' 
    stop
endif
if n_elements(wna) ne n_elements(rate) then begin
    print, 'Make wna and rate an array of the same length.' 
    stop
endif
if not keyword_set(rmode) and not keyword_set(lmode) then rmode=1

wna_rad=wna*!dtor ;[degree] to [rad]
phi_rad=phi*!dtor ;[degree] to [rad]

vc=3.0e8 ;speed of light

wce=2800D*2*!dpi ;!dpi=Pi
wpe=5.0D*wce ;assume wpe/wce=5.0
wpi=wpe/sqrt(1840.0D)
wci=wce/1840.0D
fsamp=8192.0*8D ; 65kHz OFA

tt=dindgen(fsamp/8)/fsamp ;[0, 1, 2, 3, ... , fsamp*8]/fsamp = [0, 1/fsamp, 2/fsamp, ... , 8]
timespan,'1970-01-01',tt,/s ;timespan, '1970-01-01', 8, /sec


ex=0.0D
ey=0.0D
ez=0.0D

bx=0.0D
by=0.0D
bz=0.0D


wrnn = n_elements(wna_rad)

; 周波数変化あり
if wrnn eq 1 then begin
    dfreq = [0.]
endif else begin
    ; dfreq = ( dindgen(wrnn) - float(wrnn-1)/2. ) * 50/wrnn
    dfreq = ( dindgen(wrnn) - float(wrnn-1)/2. ) * 64/(wrnn-1) ; ズレ幅を増やしてみるべき
endelse

; 周波数変化なし
; dfreq = fltarr(wrnn)

randn = randomu(seed,[n_elements(wna_rad),8])*2*!dpi ; 初期位相のズレを入れる

for i=0,n_elements(wna_rad)-1 do begin

    ww=0.2*wce + dfreq[i]  ;assume 0.2wce wave

    ; Cold plasma dispersion relation is evaluated
    ; assuming plasma consisting of electrons and protons

    sp=1.0-wpe*wpe/(ww*ww-wce*wce)-wpi*wpi/(ww*ww-wci*wci) ; Stix S parameter
    dp=wce*wpe*wpe/(ww^3-ww*wce*wce)+wpi*wpi*wci/(ww^3-ww*wci*wci) ; Stix D parameter
    ; dp=-wce*wpe*wpe/(ww^3-ww*wce*wce)+wpi*wpi*wci/(ww^3-ww*wci*wci) ; Stix D parameter
    pp=1.0-wpe*wpe/ww^2-wpi*wpi/ww^2 ; Stix P parameter

    rr=sp+dp
    ll=sp-dp

    wna_=wna_rad[i]
    phi_=phi_rad[i]
    rate_=rate[i]

    aa=sp*sin(wna_)*sin(wna_)+pp*cos(wna_)*cos(wna_)
    bb=rr*ll*sin(wna_)*sin(wna_)+pp*sp*(1.0+cos(wna_)*cos(wna_))
    ff=sqrt(((rr*ll-pp*sp)^2)*sin(wna_)^4+4*(pp*dp*cos(wna_))^2)

    if keyword_set(lmode) then nr=sqrt((bb+ff)/(2.0*aa))
    if keyword_set(rmode) then nr=sqrt((bb-ff)/(2.0*aa))

    ; For test use
    ; Square root of approximate dispersion relation for whistler-mode waves
    ; nr=sqrt(wpe*wpe/(ww*(wce*cos(wna_)-ww))) 

    ; calcuration of wave amplitude based on Mosier and Gurnett, JGR, 1971
    ; ===
    ; definition of coordinate system of the wave fields
    ;
    ; z: along the ambient magnetic field B0
    ; y: cross product of k-vector and z-axis (i.e., B0 x k)
    ; x: complete right-hand coordinate system (y x z)
    ; in this coordinate, k-vector lies in x-z plane
    ; ===

    examp=1.0D*rate_
    eyamp=dp/(sp-nr*nr)*rate_
    ezamp=-nr*nr*cos(wna_)*sin(wna_)/(pp-nr*nr*sin(wna_)*sin(wna_))*rate_

    bxamp=-nr*cos(wna_)*dp/vc/(sp-nr*nr)*rate_
    byamp=nr*cos(wna_)*pp/vc/(pp-nr*nr*sin(wna_)*sin(wna_))*rate_
    bzamp=nr*sin(wna_)*dp/vc/(sp-nr*nr)*rate_

    print, randn[i,0]
    ; randn = 0 ; 初期位相のズレを入れない
    ex_base=examp*(cos(-ww*tt+randn[i,0]));+nlevel_e*randomu(s,n_elements(tt))-0.005)
    ey_base=eyamp*(sin(-ww*tt+randn[i,0]));+nlevel_e*randomu(s,n_elements(tt))-0.005)
    ez_base=ezamp*(cos(-ww*tt+randn[i,0]));+nlevel_e*randomu(s,n_elements(tt))-0.005)
    bx_base=bxamp*(sin(-ww*tt+randn[i,0]));+nlevel_b*randomu(s,n_elements(tt))-0.005)
    by_base=byamp*(cos(-ww*tt+randn[i,0]));+nlevel_b*randomu(s,n_elements(tt))-0.005)
    bz_base=bzamp*(sin(-ww*tt+randn[i,0]));+nlevel_b*randomu(s,n_elements(tt))-0.005)

    if 0 then begin
        for l=0,7 do begin
            ex_base[1024*l:1024*(l+1)-1]=examp*(cos(-ww*tt[1024*l:1024*(l+1)-1]+randn[i,l]));+nlevel_e*randomu(s,n_elements(tt))-0.005)
            ey_base[1024*l:1024*(l+1)-1]=eyamp*(sin(-ww*tt[1024*l:1024*(l+1)-1]+randn[i,l]));+nlevel_e*randomu(s,n_elements(tt))-0.005)
            ez_base[1024*l:1024*(l+1)-1]=ezamp*(cos(-ww*tt[1024*l:1024*(l+1)-1]+randn[i,l]));+nlevel_e*randomu(s,n_elements(tt))-0.005)
            bx_base[1024*l:1024*(l+1)-1]=bxamp*(sin(-ww*tt[1024*l:1024*(l+1)-1]+randn[i,l]));+nlevel_b*randomu(s,n_elements(tt))-0.005)
            by_base[1024*l:1024*(l+1)-1]=byamp*(cos(-ww*tt[1024*l:1024*(l+1)-1]+randn[i,l]));+nlevel_b*randomu(s,n_elements(tt))-0.005)
            bz_base[1024*l:1024*(l+1)-1]=bzamp*(sin(-ww*tt[1024*l:1024*(l+1)-1]+randn[i,l]));+nlevel_b*randomu(s,n_elements(tt))-0.005)
        endfor
    endif

    ; rotation of wave fields, considering the rotation of k-vector around the z-axis,
    ; i.e., ambient magnetic field.
    ex+=ex_base*cos(phi_)-ey_base*sin(phi_)
    ey+=ex_base*sin(phi_)+ey_base*cos(phi_)
    ez+=ez_base

    bx+=bx_base*cos(phi_)-by_base*sin(phi_)
    by+=bx_base*sin(phi_)+by_base*cos(phi_)
    bz+=bz_base

endfor

; creating waveforms of electromagnetic waves with noise (0.1 % in amplitude)
if not keyword_set(nlevel_e) then nlevel_e=1e-3*(8192L/2)
if not keyword_set(nlevel_b) then nlevel_b=1e-2*(8192L/2)

etot=sqrt(ex^2+ey^2+ez^2)
btot=sqrt(bx^2+by^2+bz^2)

; ------------Add noise------------
ex+=etot*(nlevel_e*(randomu(s,n_elements(tt))-0.5))
ey+=etot*(nlevel_e*(randomu(s,n_elements(tt))-0.5))
ez+=etot*(nlevel_e*(randomu(s,n_elements(tt))-0.5))

bx+=btot*(nlevel_b*(randomu(s,n_elements(tt))-0.5))
by+=btot*(nlevel_b*(randomu(s,n_elements(tt))-0.5))
bz+=btot*(nlevel_b*(randomu(s,n_elements(tt))-0.5))
; ---------------------------------

; store_data,'efield_'+string(n_elements(wna), FORMAT='(i0)'),data={x:tt,y:[[ex],[ey],[ez]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
; store_data,'bfield_'+string(n_elements(wna), FORMAT='(i0)'),data={x:tt,y:[[bx],[by],[bz]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
store_data,'bfield',data={x:tt,y:[[bx],[by],[bz]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
; store_data,'Svec_'+string(n_elements(wna), FORMAT='(i0)'),data={x:tt,y:[[(ey*bz-ez*by)],[(ez*bx-ex*bz)],[(ex*by-ey*bx)]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
store_data,'Svec',data={x:tt,y:[[(ey*bz-ez*by)],[(ez*bx-ex*bz)],[(ex*by-ey*bx)]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}

;store_data,'xcomponent',data={x:tt,y:[[ex/max(ex)],[bx/max(bx)]]},dlim={colors:[1,2],labels:['Ex','Bx'],labflag:-1}
;store_data,'ycomponent',data={x:tt,y:[[ey/max(ey)],[by/max(by)]]},dlim={colors:[1,2],labels:['Ey','By'],labflag:-1}
;store_data,'zcomponent',data={x:tt,y:[[ez/max(ez)],[bz/max(bz)]]},dlim={colors:[1,2],labels:['Ez','Bz'],labflag:-1}

end