/* This cursor program reads (category,subcategory) tuples from 
   a table called categoryimport that are to be inserted into
   the Category, SubCategory, ComCat, and CatSubCat tables.  This
   program assumes that the Commodity to add these to already 
   exists in the Commodity table and that no other categories or
   subcategories exist for that Commodity.  The variable 
   @commoditycode holds the commoditycode to add these categories to.
   The subcategory for a blank is always "****" and is expected instead
   of a blank field. 
*/ 

declare @commoditycode int
declare @categorycode int 
declare @subcategorycode int
declare @nextcategorycode int
declare @nextsubcategorycode int
declare @newcategorydesc char(20)
declare @newsubcategorydesc char(20)


declare newcategorycursor cursor for
 select distinct categorydesc,subcategorydesc 
 from categoryimport
 order by categorydesc,subcategorydesc

select @commoditycode = 25

open newcategorycursor

while (0=0)
 begin
   fetch next
   from newcategorycursor
   into @newcategorydesc, @newsubcategorydesc

   if (@@fetch_status <> 0)
     break
   else
     begin

       select @nextcategorycode = max(categorycode) + 1
       from category
       
       select @categorycode = categorycode
       from category
       where categorydesc = @newcategorydesc

       if @@rowcount = 0
        begin
          select @categorycode = @nextcategorycode
          insert into category values (@categorycode,@newcategorydesc)
          insert into comcat values (@commoditycode,@categorycode)
        end 

       select @nextsubcategorycode = max(subcategorycode) + 1
       from subcategory
       
       select @subcategorycode = subcategorycode
       from subcategory
       where subcategorydesc = @newsubcategorydesc

       if @@rowcount = 0
        begin
          select @subcategorycode = @nextsubcategorycode
          insert into subcategory values (@nextsubcategorycode,@newsubcategorydesc) 
        end
           
       insert into catsubcat values (@categorycode,@subcategorycode)
                       
     end
  end
close newcategorycursor
deallocate newcategorycursor
