; .COMPILE '/Users/ampuku/Documents/duct/code/IDL/SVDKuritasanTool/test_20221103.pro'

pro test_20221103

esn = 10.^(4)
enr = 1/esn*(8192L/2)
bsn = 10.^(2)
bnr = 1/bsn*(8192L/2)

; makewave_mul_ver_ofa,wna=[45.],phi=[0.],rate=[10.],enr=enr,bnr=bnr
; makewave_mul_ver_ofa,wna=[45.,45.],phi=[0.,30.],rate=[10.,10.]/2,enr=enr,bnr=bnr
; makewave_mul_ver_ofa,wna=[45.,45.,45.],phi=[0.,30.,60.],rate=[10.,10.,10.]/3,enr=enr,bnr=bnr
; makewave_mul_ver_ofa,wna=[45.,45.,45.,45.],phi=[0.,30.,60.,90.],rate=[10.,10.,10.,10.]/4.,enr=enr,bnr=bnr
; makewave_mul_ver_ofa,wna=[45.,45.,45.,45.],phi=[0.,90.,180.,270.],rate=[10.,10.,10.,10.]/4.,enr=enr,bnr=bnr

nnn='4'

get_data, 'efield_'+nnn, data=data

e_x = data.y[4000:4500,0]
e_y = data.y[4000:4500,1]
e_z = data.y[4000:4500,2]

; e_x = data.y[0:15000,0]
; e_y = data.y[0:15000,1]
; e_z = data.y[0:15000,2]

window, 0, xsize=850, ysize=500

!P.multi=[0,3,2]

range_ = max(data.y)*1.1

plot, e_x, e_y, xrange=[-range_,range_],yrange=[-range_,range_], psym=1, title='E xy', charsize=2.5
plot, e_x, e_z, xrange=[-range_,range_],yrange=[-range_,range_], psym=1, title='E xz', charsize=2.5
plot, e_z, e_y, xrange=[-range_,range_],yrange=[-range_,range_], psym=1, title='E yz', charsize=2.5



get_data, 'bfield_'+nnn, data=data

b_x = data.y[4000:4500,0]
b_y = data.y[4000:4500,1]
b_z = data.y[4000:4500,2]

; b_x = data.y[0:15000,0]
; b_y = data.y[0:15000,1]
; b_z = data.y[0:15000,2]


range_ = max(data.y)*1.1

plot, b_x, b_y, xrange=[-range_,range_],yrange=[-range_,range_], psym=1, title='B xy', charsize=2.5
plot, b_x, b_z, xrange=[-range_,range_],yrange=[-range_,range_], psym=1, title='B xz', charsize=2.5
plot, b_z, b_y, xrange=[-range_,range_],yrange=[-range_,range_], psym=1, title='B yz', charsize=2.5


end
