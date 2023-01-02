
; コンパイル
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis__lists/suspicion/memo_sus_201704_event_list.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal.pro'
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/event_analysis_duct.pro'

pro memo_sus_201704_event_list

    timespan, '2017-04-01/01:45:00', 15, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-03/10:25:00', 40, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-04/22:10:00', 15, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-05/10:25:00', 30, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-07/16:05:00', 50, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-11/08:00:00', 20, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-12/22:10:00', 30, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-13/14:40:00', 20, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-14/00:00:00', 30, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-14/11:55:00', 15, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-17/03:20:00', 40, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-24/17:30:00', 10, /minute 
    plot_event_normal, UHR_file_name='kuma'

    timespan, '2017-04-30/07:00:00', 20, /minute 
    plot_event_normal, UHR_file_name='kuma'


end