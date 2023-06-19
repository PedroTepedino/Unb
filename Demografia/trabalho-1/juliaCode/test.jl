using DataFrames
import DBFTables

cd("/home/tepe/UnB/Demografia/trabalho-1/juliaCode/")

dbf = DBFTables.Table("../PA/dbfFiles/dnpa2021.dbf")

df = DataFrame(dbf)

t = dropmissing(df, :ESCMAE)

collect(ismissing(x) for x in eachcol(df))

missing_count = describe(df, :nmissing, length => :length)