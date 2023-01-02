pro makewave_ver_ofa,wna=wna,phi=phi,rmode=rmode,lmode=lmode

if not keyword_set(rmode) and not keyword_set(lmode) then rmode=1

wna=wna*!dtor
phi=phi*!dtor

vc=3.0e8 ;spped of light

wce=2800D*2*!dpi
wpe=5.0D*wce ; assume wpe/wce=5.0
wpi=wpe/sqrt(1840.0D)
wci=wce/1840.0D
ww=0.2*wce  ; assume 0.2wce wave
fsamp=8192.0*8D ; 65kHz OFA

tt=dindgen(fsamp*8)/fsamp
timespan,'1970-01-01',tt,/s

; Cold plasma dispersion relation is evaluated
; assuming plasma consisting of electrons and protons

sp=1.0-wpe*wpe/(ww*ww-wce*wce)-wpi*wpi/(ww*ww-wci*wci) ; Stix S parameter
dp=-wce*wpe*wpe/(ww^3-ww*wce*wce)+wpi*wpi*wci/(ww^3-ww*wci*wci) ; Stix D parameter
pp=1.0-wpe*wpe/ww^2-wpi*wpi/ww^2 ; Stix P parameter

rr=sp+dp
ll=sp-dp

aa=sp*sin(wna)*sin(wna)+pp*cos(wna)*cos(wna)
bb=rr*ll*sin(wna)*sin(wna)+pp*sp*(1.0+cos(wna)*cos(wna))
ff=sqrt(((rr*ll-pp*sp)^2)*sin(wna)^4+4*(pp*dp*cos(wna))^2)

if keyword_set(lmode) then nr=sqrt((bb+ff)/(2.0*aa))
if keyword_set(rmode) then nr=sqrt((bb-ff)/(2.0*aa))

; For test use
; Square root of approximate dispersion relation for whistler-mode waves
;nr=sqrt(wpe*wpe/(ww*(wce*cos(wna)-ww))) 


; calcuration of wave amplitude based on Mosier and Gurnett, JGR, 1971
; ===
; definition of coordinate system of the wave fields
;
; z: along the ambient magnetic field B0
; y: cross product of k-vector and z-axis (i.e., B0 x k)
; x: complete right-hand coordinate system (y x z)
; in this coordinate, k-vector lies in x-z plane
; ===

examp=1.0D
eyamp=dp/(sp-nr*nr)
ezamp=-nr*nr*cos(wna)*sin(wna)/(pp-nr*nr*sin(wna)*sin(wna))

etot=sqrt(examp^2+eyamp^2+ezamp^2)

bxamp=-nr*cos(wna)*dp/vc/(sp-nr*nr)
byamp=nr*cos(wna)*pp/vc/(pp-nr*nr*sin(wna)*sin(wna))
bzamp=nr*sin(wna)*dp/vc/(sp-nr*nr)

btot=sqrt(bxamp^2+byamp^2+bzamp^2)

nlevel=10000.0

; creating waveforms of electromagnetic waves with noise
ex_base=examp*(cos(-ww*tt));+nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
ey_base=eyamp*(sin(-ww*tt));+nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
ez_base=ezamp*(cos(-ww*tt));+nlevel*randomu(s,n_elements(tt))-0.5*nlevel)

bx_base=bxamp*(sin(-ww*tt));+nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
by_base=byamp*(cos(-ww*tt));+nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
bz_base=bzamp*(sin(-ww*tt));+nlevel*randomu(s,n_elements(tt))-0.5*nlevel)

; rotation of wave fields, considering the rotation of k-vector around the z-axis,
; i.e., ambient magnetic field.
ex=ex_base*cos(phi)-ey_base*sin(phi)+etot*(nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
ey=ex_base*sin(phi)+ey_base*cos(phi)+etot*(nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
ez=ez_base+etot*(nlevel*randomu(s,n_elements(tt))-0.5*nlevel)

bx=bx_base*cos(phi)-by_base*sin(phi)+btot*(nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
by=bx_base*sin(phi)+by_base*cos(phi)+btot*(nlevel*randomu(s,n_elements(tt))-0.5*nlevel)
bz=bz_base+btot*(nlevel*randomu(s,n_elements(tt))-0.5*nlevel)

store_data,'efield',data={x:tt,y:[[ex],[ey],[ez]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
store_data,'bfield',data={x:tt,y:[[bx],[by],[bz]]},dlim={colors:[2,4,6],labels:['x','y','z'],labflag:-1}
store_data,'Svec',data={x:tt,y:[[(ey*bz-ez*by)],[(ez*bx-ex*bz)],[(ex*by-ey*bx)]]}

;store_data,'xcomponent',data={x:tt,y:[[ex/max(ex)],[bx/max(bx)]]},dlim={colors:[1,2],labels:['Ex','Bx'],labflag:-1}
;store_data,'ycomponent',data={x:tt,y:[[ey/max(ey)],[by/max(by)]]},dlim={colors:[1,2],labels:['Ey','By'],labflag:-1}
;store_data,'zcomponent',data={x:tt,y:[[ez/max(ez)],[bz/max(bz)]]},dlim={colors:[1,2],labels:['Ez','Bz'],labflag:-1}

end