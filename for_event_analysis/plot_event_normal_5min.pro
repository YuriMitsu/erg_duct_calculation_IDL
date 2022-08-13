
; コンパイル 
; .compile -v '/Users/ampuku/Documents/duct/code/IDL/for_event_analysis/plot_event_normal_5min.pro'


pro plot_event_normal_5min, UHR_file_name=UHR_file_name, desplay_on=desplay_on

    get_timespan, timesp_
    n_indextimes = fix( ( timesp_[1] - timesp_[0] ) / (5*60-10) )
    indextimes = dblarr(n_indextimes)
    for i=0,n_indextimes-1 do indextimes[i] = timesp_[0] + 5*60*i

    for i=0,n_indextimes-1 do begin
        timespan, indextimes[i], 5, /min
        plot_event_normal, UHR_file_name=UHR_file_name, desplay_on=desplay_on
    endfor

end
