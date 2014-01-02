set DTSTMP=%date:~4,2%-%date:~7,2%-%date:~10,4%

exp harvest/harvest@harvest owner=harvest grants=y file="exports\%DTSTMP%_scmDbExp.dmp" log="logs\%DTSTMP%_scmDbBkUp.log"