


; 背景のコールドプラズマがどの程度の速度で動いているか確認


    timespan, '2018-06-06/11:25:00', 20, /min
    duct_time='2018-06-06/11:29:40' & focus_f=[1., 2., 3., 4.] & duct_wid_data_n=3
    duct_time='2018-06-06/11:32:29' & focus_f=[3., 4., 5., 6., 7.] & duct_wid_data_n=3



    timespan, '2017-07-14/02:40:00', 20.0, /minute
    duct_time='2017-07-14/02:52:17' & focus_f=[1.,2.,3.,4.,5.] & duct_wid_data_n=10



    timespan, '2017-07-03/04:32:00', 1, /min
    duct_time='2017-07-03/04:32:32' & focus_f=[4., 5., 6., 7., 8., 9.]
    tplot_restore, file=['/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/erg_pwe_wfc_20170703043200_20170703043255.tplot']


磁場強度：
'erg_mgf_l2_magt_8sec'
'erg_pwe_efd_l2_E_spin_Eu_dsi'


EE = (edata.y[*,0])^2+(edata.y[*,1])^2
BB = 

erg_load_pwe_efd


; 課サバ先生によると、どこの時間帯もv x B = Eを基に計算していいとのこと。EにEFDのEuとEvを使って良い.
; だいたい衛星の進む速度と一緒のはず.
