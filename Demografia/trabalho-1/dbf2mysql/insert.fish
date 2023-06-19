#!/usr/bin/fish

for file in ./dbf/*
    echo (basename $file .dbf)
    /home/tepe/UnB/Demografia/trabalho-1/dbf2mysql/insert.py $file (basename $file .dbf)
    echo done!
end