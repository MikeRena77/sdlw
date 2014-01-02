
select distinct commoditydesc=convert(char(15),commoditydesc),
                categorydesc,pro.categorycode,subcategorydesc,pro.subcategorycode
from propertycomcatsubcat pro, commodity com, category cat, subcategory sub
where pro.commoditycode = com.commoditycode and
      pro.categorycode = cat.categorycode and
      pro.subcategorycode = sub.subcategorycode and
      commoditydesc = "ADPE"

/*
declare @oldsub smallint
declare @newsub smallint
declare @cat smallint

select @oldsub = 524
select @newsub = 563
select @cat = 68

update propertycomcatsubcat
set subcategorycode = @newsub
from propertycomcatsubcat pro, commodity com 
where pro.commoditycode = com.commoditycode and
      commoditydesc = "ADPE" and
      categorycode = @cat and
      subcategorycode = @oldsub

delete from catsubcat where categorycode = @cat and subcategorycode = @oldsub

delete from subcategory where subcategorycode = @oldsub
*/


