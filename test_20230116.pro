
pro test_20230116

    duct_time='2018-06-06/11:29:40' & focus_f=[1., 2., 3., 4.] & duct_wid_data_n=3




    WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/for_M_thesis/event1/f.csv', phi.x
    WRITE_CSV, '/Users/ampuku/Documents/duct/code/python/for_M_thesis/event1/phi.csv', data.y[*,0]


get_data, 'wna', data=test
1/(test.x[100]-test.x[99])


end