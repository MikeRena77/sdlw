select 
    envobjid, 
    environmentname, 
    harenvironment.creationtime, 
    username, 
    realname
from 
    harenvironment, 
    haruser
where 
    harenvironment.creatorid = haruser.creatorid
order by 
    username;