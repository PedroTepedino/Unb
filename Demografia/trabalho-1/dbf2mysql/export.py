#!/usr/bin/python

import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('mysql+mysqldb://root:root@127.0.0.1:6603/demog')

for i in range(2000, 2022):
    print(f"PROCESSING {i} ", end = '')
    db = pd.read_sql(f'SELECT * FROM aux_date WHERE ANOORIGEM = {i};', engine)
    print("-", end='')
    db.to_csv(f"./aux_date{i}.csv", index=False)
    print("DONE!")