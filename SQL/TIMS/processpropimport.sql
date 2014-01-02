/* TIS Database sql load program.
    Bob Rasmussen, Comarco Systems, Inc.
    September 20, 1999

    Modified November 12, 1999 by BR
      -  Added capability to insert new records into existing database by
         setting recordno and invrecordno to max value + 1

   This cursor sql program will populate serialized and 
   non serialized property and inventory tables from data
   located in the table PropertyImport.  PropertyImport is
   populated by BCP from a comma delimited text file. 
*/

declare @recordno int
declare @stockno char(16)
declare @prevstockno char(16)
declare @partno varchar(18)
declare @prevpartno varchar(18)
declare @new_desc varchar(116)
declare @old_desc varchar(80)
declare @genericname varchar(20)
declare @attributes varchar(50)
declare @model varchar(20)
declare @noun varchar(50)
declare @comp char(1)
declare @price money
declare @fsc_code char(4)
declare @offstation char(3)
declare @drawingno varchar(13)
declare @commodity char(15)
declare @category char(15)
declare @subcat char(15)
declare @warehouse char(15)
declare @changes char(8)
declare @shipstatus char(20)
declare @gfp char(1)
declare @tda char(1)
declare @te10 char(1)
declare @fyrptcode char(3)
declare @lin char(6)
declare @cage char(6)
declare @lcc char(1)
declare @ricc char(1)
declare @polkey char(6)
declare @dodac char(8)
declare @qty smallint
declare @qtycum smallint
declare @control tinyint
declare @propertybook char(1)
declare @reservable char(1)
declare @serialized char(1)
declare @warranty char(1)
declare @calibration char(1)
declare @govvehicle char(1)
declare @component char(1)
declare @replenishment char(1)
declare @mgmtinterest char(1)
declare @lasttype char(1)
declare @invrecordno int
declare @tscserialno char(6)
declare @mfgserialno varchar(20)
declare @ctrlserno varchar(20)
declare @location varchar(15)
declare @parentrecord varchar(25)
declare @mirrno char(13)
declare @pono char(13)
declare @registerdocno char(9)
declare @usano char(7)
declare @bumperno char(10)
declare @vinno varchar(20)
declare @remarks char(30)
declare @remark1 char(15)
declare @docno char(9)
declare @action char(2)
declare @class char(15)
declare @hrno char(3)
declare @oldhr char(3)
declare @statuscode tinyint
declare @idnumber char(8)
declare @oldpartno varchar(18)
declare @olddesc varchar(80)
declare @system char(5)
declare @postdate char(8)
declare @postinit char(3)
declare @invdata char(9)
declare @schinvyr char(2)
declare @manufacturer char(20)
declare @unit char(2)
declare @enditems char(25)
declare @wao char(6)
declare @usanumber char(7)
declare @today datetime

declare importcursor cursor for

  select stockno,partno,new_desc,descrip,genericname,attributes,model,noun,comp,fsc_code,price,
         class,drawingno,offstation,commodity,category,subcat,warehouse,gfp,tda,te10,fyrptcode,
         lin,cage,changes,hrno,oldhr,lcc,ricc,polkey,qty,barcode,serno,ctrlserno,location,enditems,
         usanumber,remarks,remark1,idnumber,descrip,system,docno,action,postdate,postinit,
         invdata,schinvyr,shipstatus,class,manufacturer,unit,wao
  from PropertyImport
  where bad = null and
        bcerr = null and
        snerr = null
  order by stockno,partno

select @qtycum = 0
select @recordno = max(RecordNo) from Property
if @recordno = null
  select @recordno = 0
select @invrecordno = max(InvRecordNo) from InvSerialized
if @invrecordno = null
  select @invrecordno = 0
select @prevstockno = "                "
select @prevpartno = "                  "
select @dodac = "CN0MU2"
select @propertybook = "1"
select @reservable = "0"
select @serialized = "0"
select @warranty = "1"
select @calibration = "0"
select @govvehicle  = "0"
select @replenishment = "0"
select @component = "0"
select @mgmtinterest = "0"
select @lasttype = "0"
select @statuscode = 0
select @mirrno = null
select @pono = null
select @registerdocno = null
select @bumperno = null
select @vinno = null
select @today = getdate()

open importcursor

while (0 = 0)
 begin
   fetch next
   from importcursor
   into @stockno,@partno,@new_desc,@old_desc,@genericname,@attributes,@model,@noun,@comp,
        @fsc_code,@price,@class,@drawingno,@offstation,@commodity,@category,@subcat,
        @warehouse,@gfp,@tda,@te10,@fyrptcode,@lin,@cage,@changes,@hrno,@oldhr,@lcc,@ricc,
        @polkey,@qty,@tscserialno,@mfgserialno,@ctrlserno,@location,@parentrecord,@usano,
        @remarks,@remark1,@idnumber,@olddesc,@system,@docno,@action,@postdate,
        @postinit,@invdata,@schinvyr,@shipstatus,@class,@manufacturer,@unit,@wao
   if (@@fetch_status <> 0) 
     break
   if ((@stockno = @prevstockno) and (@partno = @prevpartno))
     begin
       select @qtycum = @qtycum + @qty
       select @qty = @qtycum
       update Property
         set TotalQty = @qty
         where RecordNo = @recordno   
     end
   else
     begin
       select @recordno = @recordno + 1
       select @qtycum = @qty
       if @polkey = "N/A"
         select @govvehicle = "1"
       if @class = "PROP" 
         select @propertybook = "1"
       else 
         begin        
           if @class = "IX"
             select @replenishment = "1"
         end
       if (@ctrlserno = null)
         select @serialized = "0"
       else
         select @serialized = "1"
       if @comp = "Y"
         select @component = "1" 
       if @te10 = "Y"
         begin
           select @mgmtinterest = "1"
           select @reservable = "1"
         end
       if @wao = null
         select @statuscode = 1
       else
         select @statuscode = 2
       insert into Property
         values (@recordno,@stockno,@partno,@genericname,@attributes,@model,@noun,
                 @price,@drawingno,@propertybook,@reservable,@serialized,@warranty,
                 @calibration,@govvehicle,@component,@replenishment,@gfp,@tda,
                 @mgmtinterest,@fyrptcode,@lin,@cage,@lcc,@ricc,@dodac,@qty)
       if (@serialized = "0")
         begin
           insert into InvNonSerializedAttributes
              values (@recordno,@enditems,@mirrno,@pono,@registerdocno,0,null,null)
         end
     end
   insert into PropertyDetail
     values (@recordno,@stockno,@partno,@new_desc,@old_desc,@genericname,@attributes,
         @manufacturer,@model,@tscserialno,@noun,@unit,@qty,@comp,@enditems,@fsc_code,
         @drawingno,@price,@class,@offstation,@commodity,@category,@subcat,@warehouse,
         @location,@wao,@remarks,@remark1,@postdate,@changes,@postinit,@hrno,@oldhr,
         @invdata,@schinvyr,@shipstatus,@idnumber,@mfgserialno,@polkey,@usanumber,@system,
         @docno,@action,@lin,@te10,@gfp,@lcc,@cage,@tda,@fyrptcode,@ricc)
   if (@serialized = "1")
    begin
      select @invrecordno = @invrecordno + 1
      insert into InvSerialized
        values (@invrecordno,@recordno,@tscserialno,@mfgserialno,@location,@remark1,
                @statuscode,@today)
      insert into InvSerializedAttributes
        values (@recordno,@invrecordno,@enditems,@mirrno,@pono,@registerdocno,
                @usano,@bumperno,@polkey,@vinno,0,null,null,null)
    end
   select @prevstockno = @stockno
   select @prevpartno = @partno
 end
close importcursor 
deallocate importcursor

             