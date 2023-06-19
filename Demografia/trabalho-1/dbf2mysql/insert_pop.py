#!/usr/bin/python

from dbfread import DBF
from pandas import DataFrame
import sys
from sqlalchemy import create_engine

engine = create_engine('mysql+mysqldb://root:root@127.0.0.1:6603/demog')

dbf = DBF(sys.argv[1], load=True)
db = DataFrame(iter(dbf))

db.to_sql(con=engine, name=sys.argv[2], if_exists='replace')
