-- Data Dictionary SQL script
select "Table Name" = convert(char(25),obj.name),
       "Column Name" = convert(char(20),col.name),
       "Data Type" = convert(char(10),typ.name),
       "Length" = col.length
from sysobjects obj, syscolumns col, systypes typ
where obj.id = col.id and
      col.usertype = typ.usertype and
      obj.type = "U"
order by obj.name,col.colid

