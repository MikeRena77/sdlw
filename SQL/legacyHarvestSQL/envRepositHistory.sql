select harenvironment.environmentname, harrepository.repositname, haritempath.pathname, harrepository.modifiedtime, harrepository.creationtime 
from harenvironment, harrepository, harenvrepository, haritempath
where harenvironment.envobjid=harenvrepository.envobjid and
harrepository.repositobjid=harenvrepository.repositobjid and
haritempath.pathobjid=harrepository.rootpathid
order by harenvironment.environmentname, harrepository.repositname, haritempath.pathname