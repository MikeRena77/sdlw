CREATE TABLE WORKSPACE_DEF
(def_num int(7) NOT NULL UNIQUE PRIMARY KEY,
def_name varchar(25),
def_status enum('Active','Inactive'),
def_scfolders varchar(50),
def_locfolders varchar(50)
);
