/*  
Update the Category, Subcategory, ComCat, and Subcat tables with new 
values or with replacement values.  When appropriate, update the 
propertycomcatsubcat table by remapping recordno to new commodity,
category, or subcategory values.
*/

-- Declare the temp variables that will be used
declare @com smallint
declare @comdesc varchar(20)
declare @oldcat smallint
declare @newcat smallint
declare @catdesc varchar(20)
declare @oldsub smallint
declare @newsub smallint
declare @subdesc varchar(20)

-- Input the old and new values here
select @com = 25
select @oldcat = 239
select @newcat = 244
select @catdesc = ''
select @oldsub = 341
select @newsub = 341
select @subdesc = '' 


/*
-- **** Only use this block of code when needed. ****
-- Update the propertycomcatsubcat table only if remapping of recordno's to 
-- commodity, category, or subcategory is required because existing 
-- recordno's are pointing to old commodity, category, or subcategory.
update propertycomcatsubcat
set categorycode = @newcat, 
    subcategorycode = @newsub
from propertycomcatsubcat pro, commodity com 
where pro.commoditycode = com.commoditycode and
      com.commoditydesc = @comdesc and
      categorycode = @oldcat and
      subcategorycode = @oldsub
*/


-- 
delete from comcat where commoditycode = @com and categorycode = @oldcat

delete from catsubcat where categorycode = @oldcat and subcategorycode = @oldsub

delete from category where categorycode = @oldcat

-- **** Don't run this line if the subcode = 0 or there is no existing subcode ****
-- delete from subcategory where subcategorycode = @oldsub




-- Run this line to insert a new comcat record (comcode & catcode)
insert into comcat values (@com, @newcat)

-- Run this line to insert a new catsubcat record (catcode & subcatcode)
insert into catsubcat values (@newcat,@newsub)

-- Run this line to insert a new category
insert into category values (@newcat, @catdesc)

-- Run this line to insert a new subcategory
insert into subcategory values (@newsub, @subdesc)

-- Run this line to insert a new commodity
-- insert into commodity values (@com, @comdesc, '000000000')


/*
update subcategory 
set subcategorydesc = "DISK DRIVE"
where subcategorycode = 694
*/
