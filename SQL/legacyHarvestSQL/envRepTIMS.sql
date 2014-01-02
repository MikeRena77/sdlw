select harenvironment.environmentname, harrepository.repositname, haritempath.pathname, harrepository.modifiedtime, harrepository.creationtime 
from harenvironment, harrepository, harenvrepository, haritempath
where harenvironment.envobjid=harenvrepository.envobjid and
harrepository.repositobjid=harenvrepository.repositobjid and
haritempath.pathobjid=harrepository.rootpathid AND harenvironment.environmentname LIKE 'TIMS%'

order by harenvironment.environmentname, harrepository.repositname, haritempath.pathname