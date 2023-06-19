#!/usr/bin/fish

if test \( -e ./dbc -a -d ./dbc \)
    cd ./dbc
else
    echo "DBC Directory do not exist !!!"
    return
end 

for file in *.{dbc,DBC}
    echo $file " --> " (string lower $file)
    mv $file (string lower $file)
end


cd ..

if test ! \( -e ./dbf -a -d ./dbf \)
    mkdir ./dbf
end 

# for file in ./dbc/*
#     echo (basename $file .dbc).dbf
# end

for file in ./dbc/*
    echo $file Processing
    ../blast-dbf/blast-dbf $file ./dbf/(basename $file .dbc).dbf
    echo $file Processed correctilly
end

echo
echo DONE!

# for file in ./dbc/*
#     echo $file
# end