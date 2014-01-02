declare @oldcat smallint
declare @newcat smallint
declare @sub smallint
declare @com smallint
declare @newsub smallint

select @com = 1
select @oldcat = 239
select @newcat = 244
select @sub = 341
select @newsub = 341


update propertycomcatsubcat
set categorycode = @newcat, subcategorycode = @newsub
from propertycomcatsubcat pro, commodity com 
where pro.commoditycode = com.commoditycode and
      commoditydesc = "ADPE" and
      categorycode = @oldcat and
      subcategorycode = @sub

delete from catsubcat where categorycode = @oldcat and subcategorycode = @sub

delete from category where categorycode = @oldcat
delete from comcat where commoditycode = @com and categorycode = @oldcat

insert into catsubcat values (@newcat,@sub)

/*
update subcategory set subcategorydesc = "DISK DRIVE"
where subcategorycode = 694
*/
