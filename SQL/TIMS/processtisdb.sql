/* SQL file ProcessTISDB batch sql to populate TIS database tables */

declare @supplierno smallint
declare @manufacturer varchar(20)
declare @phoneno char(11)
declare @commoditycode tinyint
declare @commoditydesc varchar(20)
declare @commgrempno char(9)
declare @categorycode smallint
declare @categorydesc varchar(20)
declare @subcategorycode smallint
declare @subcategorydesc varchar(20)
declare @recordno int
declare @invrecordno int

/* Find the last RecordNo from the Property table */

select @recordno = max(RecordNo) from Property

/* Update table LastPropRecordNo with the last RecordNo from Property and
   LastUpdate set to todays date and time.
*/

if @recordno = null
  insert into LastPropRecordNo
     select @recordno,getdate()
else
  update LastPropRecordno
     set RecordNo = @recordno, LastUpdate = getdate()

/* Find the last InvRecordNo from the InvSerialized table */

select @invrecordno = max(InvRecordNo) from InvSerialized

/* Update table LastInvRecordNo with the last InvRecordNo from InvSerialized and
   LastUpdate set to todays date and time.
*/

if @invrecordno = null
   insert into LastInvRecordNo
      select @invrecordno,getdate()
else
   update LastInvRecordNo
      set InvRecordno = @invrecordno, LastUpdate = getdate()

/* Build the non serialized inventory data using the import data for the
   current location and quantity of parts and the temporary table created 
   above for the unique RecordNo for each stock no and part no combination.
*/

insert into InvNonSerialized
select t.RecordNo,location,Remarks = null,sum(qty),StatusCode = 1,getdate()
from Property t, propertyimport p
where t.stockno = p.stockno and
      t.partno = p.partno and
      p.ctrlserno = null and
      wao = null
group by t.RecordNo,location,Remarks

insert into InvNonSerialized
select t.RecordNo,location,Remarks = null,sum(qty),StatusCode = 2,getdate()
from Property t, propertyimport p
where t.stockno = p.stockno and
      t.partno = p.partno and
      p.ctrlserno = null and
      wao <> null
group by t.RecordNo,location,Remarks

/* Declaration of the Supplier creation cursor.  This cursor will populate
   the Supplier table with distinct manufacturer data from the import data.
*/

declare suppliercursor cursor for
 select distinct manufacturer from PropertyDetail
 where manufacturer <> null and
      manufacturer not like "XX%"
 order by manufacturer

/* Declaration of the Commodity creation cursor.  This cursor will populate
   the Commodity table with distinct commodity data from the import data.

declare commoditycursor cursor for
 select distinct commodity 
 from PropertyDetail
 where commodity <> null
 order by commodity

/* Declaration of the Category creation cursor.  This cursor will populate
   the Category table with distinct category data from the import data.
*/

declare categorycursor cursor for
 select distinct category 
 from PropertyDetail
 where category <> null
 order by category

/* Declaration of the SubCategory creation cursor.  This cursor will
   populate the SubCategory table with distinct subcategory data from
   the import data.
*/

declare subcategorycursor cursor for
 select distinct subcat 
 from PropertyDetail
 where subcat <> null
 order by subcat

select @supplierno = 0
select @phoneno = "xxxxxxxxxxx"
truncate table Supplier

/* Open and execute the Supplier cursor. */

open suppliercursor

while (0=0)
 begin
   fetch next
   from suppliercursor
   into @manufacturer

   if (@@fetch_status <> 0)
     break
   else
     begin
       select @supplierno = @supplierno + 1
       insert into Supplier
       values (@supplierno,@manufacturer,@phoneno)   
     end
  end
close suppliercursor
deallocate suppliercursor

/* Populate PropertySupplier a relationship table between Property and
   Supplier tables.
*/

truncate table PropertySupplier

insert into PropertySupplier
select distinct RecordNo,SupplierNo
from PropertyDetail p, Supplier s
where p.manufacturer = s.SupplierDesc

/* execute the commoditycursor */

select @commgrempno = "000000"
select @commoditycode = 0
truncate table Commodity

open commoditycursor

while (0=0)
 begin
   fetch next
   from commoditycursor
   into @commoditydesc

   if (@@fetch_status <> 0)
     break
   else
     begin
       select @commoditycode = @commoditycode + 1
       insert into Commodity
       values (@commoditycode,@commoditydesc,@commgrempno)   
     end
  end
close commoditycursor
deallocate commoditycursor


select @categorycode = 0
select @subcategorycode = 0
truncate table Category

/* Open and execute the Category cursor. */

open categorycursor

while (0=0)
 begin
   fetch next
   from categorycursor
   into @categorydesc

   if (@@fetch_status <> 0)
     break
   else
     begin
       select @categorycode = @categorycode + 1
       insert into Category
       values (@categorycode,@categorydesc)   
     end
  end
close categorycursor
deallocate categorycursor

truncate table SubCategory

/* Open and execute the SubCategory cursor. */

open subcategorycursor

while (0=0)
 begin
   fetch next
   from subcategorycursor
   into @subcategorydesc

   if (@@fetch_status <> 0)
     break
   else
     begin
       select @subcategorycode = @subcategorycode + 1
       insert into SubCategory
       values (@subcategorycode,@subcategorydesc)   
     end
  end
close subcategorycursor
deallocate subcategorycursor

/* Build a temporary table of distinct recordno, Commodity,
   Category, and SubCategory tuples from the import data. Create a
   field for RecordNo and set to 0 for later update.
*/
select distinct recordno,
                commodity,commoditycode = 0,
                category,categorycode = 0,
                subcat, subcatcode = 0 
into #tempdetail
from propertydetail

update #tempdetail
set t.commoditycode = c.commoditycode
from #tempdetail t, commodity c
where t.commodity = c.commoditydesc 

update #tempdetail
set t.categorycode = c.categorycode
from #tempdetail t, category c
where t.category = c.categorydesc 

update #tempdetail
set t.subcatcode = c.subcategorycode
from #tempdetail t, subcategory c
where t.subcat = c.subcategorydesc

truncate table PropertyComCatSubCat

insert into propertycomcatsubcat
select recordno,commoditycode,categorycode,subcatcode
from #tempdetail

/* Populate ComCat a relationship table between Commodity and 
   Category tables.
*/

truncate table ComCat

insert into ComCat
select distinct commoditycode,categorycode
from PropertyComCatSubCat

/* Populate CatSubCat a relationship table between Category
   and SubCategory tables.
*/

truncate table CatSubCat

insert into CatSubCat
select distinct categorycode,subcategorycode
from PropertyComCatSubCat
where subcategorycode <> 0

/* Update PropertyDetail setting the different class types for each
   item.  PropertyDetail is an archive of certain fields from the
   import data.
*/

update PropertyDetail
set class = "EXPENDABLE"
where class = "EXPEN"

update PropertyDetail
set class = "NON-EXPENDABLE"
where class = "PROP"

update PropertyDetail
set class = "CLASSIX-COMP"
where class = "IX"

/* Populate PropertyClass a relationship table between Property and
   Class tables.
*/

truncate table PropertyClass

insert into PropertyClass
select distinct RecordNo,ClassCode
from PropertyDetail p, Class c
where p.class = c.ClassDesc

insert into PropertyClass
select distinct RecordNo,ClassCode
from PropertyDetail p, Class c
where p.class = "CLASSIX-COMP" and
      c.ClassDesc like "CLASSIX-COMP%"

update Property
set GFP = "1"
where GFP = null

/* Populate PropertySource a relationship table between 
   Property and Source tables.
*/

truncate table PropertySource

insert into PropertySource
select distinct RecordNo,SourceCode
from Property p, Source s
where p.GFP = convert(char(1),s.SourceCode)

/* Populate PropertyUOM a relationship table between 
   Property and UOM tables.
*/

truncate table PropertyUOM

insert into PropertyUOM
select distinct RecordNo,UOMCode
from PropertyDetail p, UOM u
where p.unit = u.UOMCode

/* Populate PropertyFSC a relationship table between 
   Property and FSC tables.
*/

truncate table PropertyFSC

insert into PropertyFSC
select distinct RecordNo,FSCCode 
from Property p, FSC f 
where substring(StockNo,1,4) = FSCCode 

/* Populate PropertyWarehouse a relationship table between 
   Property and Warehouse tables.
*/

truncate table PropertyWarehouse

insert into PropertyWarehouse
select distinct p.recordno,warehousecode
from propertydetail pi, Property p, Warehouse w
where pi.stockno = p.stockno and
      pi.partno = p.partno and
      pi.warehouse = w.warehousedesc    