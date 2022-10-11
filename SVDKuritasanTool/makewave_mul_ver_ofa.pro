; Created by Satoshi Kurita!!
; Added by Ampuku.
; .compile '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/makewave_mul_ver_ofa.pro'


pro makewave_mul_ver_ofa,wna=wna,phi=phi,rate=rate,rmode=rmode,lmode=lmode,enr=nlevel_e,bnr=nlevel_b

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
ww=0.2*wce  ;assume 0.2wce wave
fsamp=8192.0D

tt=dindgen(fsamp*8)/fsamp ;[0, 1, 2, 3, ... , fsamp*8]/fsamp = [0, 1/fsamp, 2/fsamp, ... , 8]
timespan,'1970-01-01',tt,/s ;timespan, '1970-01-01', 8, /sec

; Cold plasma dispersion relation is evaluated
; assuming plasma consisting of electrons and protons

ex=0.0D
ey=0.0D
ez=0.0D

bx=0.0D
by=0.0D
bz=0.0D


sp=1.0-wpe*wpe/(ww*ww-wce*wce)-wpi*wpi/(ww*ww-wci*wci) ; Stix S parameter
dp=-wce*wpe*wpe/(ww^3-ww*wce*wce)+wpi*wpi*wci/(ww^3-ww*wci*wci) ; Stix D parameter
pp=1.0-wpe*wpe/ww^2-wpi*wpi/ww^2 ; Stix P parameter

rr=sp+dp
ll=sp-dp

for i=0,n_elements(wna_rad)-1 do begin

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
    ;nr=sqrt(wpe*wpe/(ww*(wce*cos(wna_)-ww))) 


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


    ex_base=examp*(cos(-ww*tt));+nlevel_e*randomu(s,n_elements(tt))-0.005)
    ey_base=eyamp*(sin(-ww*tt));+nlevel_e*randomu(s,n_elements(tt))-0.005)
    ez_base=ezamp*(cos(-ww*tt));+nlevel_e*randomu(s,n_elements(tt))-0.005)

    bx_base=bxamp*(sin(-ww*tt));+nlevel_b*randomu(s,n_elements(tt))-0.005)
    by_base=byamp*(cos(-ww*tt));+nlevel_b*randomu(s,n_elements(tt))-0.005)
    bz_base=bzamp*(sin(-ww*tt));+nlevel_b*randomu(s,n_elements(tt))-0.005)


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

ex+=etot*(nlevel_e*randomu(s,n_elements(tt))-0.5*nlevel_e)
ey+=etot*(nlevel_e*randomu(s,n_elements(tt))-0.5*nlevel_e)
ez+=etot*(nlevel_e*randomu(s,n_elements(tt))-0.5*nlevel_e)

bx+=btot*(nlevel_b*randomu(s,n_elements(tt))-0.5*nlevel_b)
by+=btot*(nlevel_b*randomu(s,n_elements(tt))-0.5*nlevel_b)
bz+=btot*(nlevel_b*randomu(s,n_elements(tt))-0.5*nlevel_b)

store_data,'efield',data={x:tt,y:[[ex],[ey],[ez]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
store_data,'bfield',data={x:tt,y:[[bx],[by],[bz]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
store_data,'Svec',data={x:tt,y:[[(ey*bz-ez*by)],[(ez*bx-ex*bz)],[(ex*by-ey*bx)]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}

;store_data,'xcomponent',data={x:tt,y:[[ex/max(ex)],[bx/max(bx)]]},dlim={colors:[1,2],labels:['Ex','Bx'],labflag:-1}
;store_data,'ycomponent',data={x:tt,y:[[ey/max(ey)],[by/max(by)]]},dlim={colors:[1,2],labels:['Ey','By'],labflag:-1}
;store_data,'zcomponent',data={x:tt,y:[[ez/max(ez)],[bz/max(bz)]]},dlim={colors:[1,2],labels:['Ez','Bz'],labflag:-1}

end