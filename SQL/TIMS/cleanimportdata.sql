/* This script is run immediately after loading in the import data
   into the PropertyImport table.
*/

use timsdb

go

update propertyimport
set location = "UNKNOWN"
where location = null

update propertyimport
set idnumber = null
where idnumber like "%N/%"

go

update propertyimport
set polkey = null
where  polkey like "%N/%"

go

update propertyimport
set usanumber = null
where usanumber like "%N/%"

go 

update propertyimport
set cage = null
where cage like "%N/%"

go

update propertyimport
set manufacturer = "UNKNOWN" 
where manufacturer = null
