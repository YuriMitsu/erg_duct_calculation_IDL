



    timespan, '2018-06-06/11:25:00', 20, /min
    a = loading_f_wna_plot() ; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_paper_figure/f_wna_plot.pro' のfunction

    duct_time='2018-06-06/11:29:40' & focus_f=[1., 2., 3., 4.] & duct_wid_data_n=3
    plot_f_phi, duct_time=duct_time, focus_f=focus_f, test=test, duct_wid_data_n=duct_wid_data_n ; .compile -v '/Users/ampuku/Documents/duct/code/IDL/plots/plot_f_phi.pro'
    duct_time='2018-06-06/11:32:29' & focus_f=[3., 4., 5., 6., 7.] & duct_wid_data_n=3
    plot_f_phi, duct_time=duct_time, focus_f=focus_f, test=test, duct_wid_data_n=duct_wid_data_n


    timespan, '2017-07-14/02:40:00', 20, /min
    a = loading_f_wna_plot()

    duct_time='2017-07-14/02:52:17' & focus_f=[1.,2.,3.,4.,5.] & duct_wid_data_n=10
    plot_f_phi, duct_time=duct_time, focus_f=focus_f, test=test, duct_wid_data_n=duct_wid_data_n


    timespan, '2017-07-03/04:32:00', 1, /min

    duct_time='2017-07-03/04:32:32' & focus_f=[4., 5., 6., 7., 8., 9.]*1000
    duct_time='2017-07-03/04:32:32' & focus_f=[4., 5., 6., 7.2]*1000
    duct_time='2017-07-03/04:32:32' & focus_f=[7.4, 8., 9.]*1000
    tplot_restore, file=['/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/wfc_iseewave_20170703043200_20170703043255.tplot']
    a = loading_f_wna_plot_wfc()
    plot_f_phi_wfc, duct_time=duct_time, focus_f=focus_f, test=test

    ; tplot_save, ['espec', 'bspec', 'wna', 'kvec_xy', 'polarization', 'planarity'], filename='/Users/ampuku/Documents/duct/code/IDL/tplots/wfc_wna_tplots_from_iseewave/2017-07-03/wfc_iseewave_20170703043200_20170703043255'
