# %%
import pandas as pd

# %%
data = pd.read_csv('memo.csv')
days = data['日付']

# %%
# ./fufp3-txt YYYYMMDD > txt/YYYY/erg_hfa_l3_high_YYYYMMDD.txt

texts = []

for day in days:
    text = './fufp3-txt ' + day[0:4] + day[5:7] + day[8:10] + ' > txt/' \
        + day[0:4] + '/erg_hfa_l3_high_' + day + '.txt'
    texts.append(text)

texts
# %%
