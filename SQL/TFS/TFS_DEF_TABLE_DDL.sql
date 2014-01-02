CREATE TABLE BUILD_DEF
(def_num int(7) NOT NULL UNIQUE PRIMARY KEY,
def_name varchar(25),
def_trigger enum('NOT_CHECKIN','EACH_CHECKIN','ACCUM_CHECKIN','ON_DAYS'),
def_disable bool,
def_workspace varchar(25),
def_proj varchar(50),
def_retention enum('KNONE','KLATEST','K2','KALL'),
def_default_agent varchar(36),
def_drop varchar(65)
);
