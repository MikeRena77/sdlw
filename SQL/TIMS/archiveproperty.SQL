/* For Serialized Property */
/*
insert into PropertyArchive
select P.RecordNo,StockNo,PartNo,ArchiveDate=getdate(),GenericName,Attributes,Model,
       Noun,Cost,DrawingNo,PropertyBook,Reservable,Serialized,Warranty,Calibration,
       GovVehicle,Component,Replenishment,GFP,TDA,MgtInterest,FYReportCode,
       LIN,CAGE,LCC,RICC,DODAC,TotalQty,Class,Source,UOM,SupplierDesc,FSC.FSCCode,
       WarehouseDesc,CommodityDesc,CategoryDesc,SubCategoryDesc,Inv.InvRecordNo,
       TSCSerialNo,MfgSerialNo,ParentRecord,MIRRNo,PONo,RegisterDocNo,UsaNo,
       BumperNo,PolKey,VINNo,ParentRecordNo,ParentSerialNo,Revision,StorageLocation,
       InvQty = 1
from Property P, PropertySupplier PS, Supplier S, PropertyFSC PFSC, FSC, 
     PropertyWarehouse PW, Warehouse W, PropertyComCatSubCat PCCSC, Commodity Com,
     Category Cat, SubCategory SubCat, InvSerialized Inv, InvSerializedAttributes InvA
where P.RecordNo = PS.RecordNo and
      P.RecordNo = PFSC.RecordNo and
      P.RecordNo = PW.RecordNo and
      P.RecordNo = PCCSC.RecordNo and
      P.RecordNo = Inv.RecordNo and
      P.RecordNo = InvA.RecordNo and
      PS.SupplierNo = S.SupplierNo and
      PFSC.FSCCode = FSC.FSCCode and
      PW.WarehouseCode = W.WarehouseCode and
      PCCSC.CommodityCode = Com.CommodityCode and
      PCCSC.CategoryCode = Cat.CategoryCode and
      PCCSC.SubCategoryCode = SubCat.SubCategoryCode and
      Inv.InvRecordNo = InvA.InvRecordNo and
      P.RecordNo in (4)
*/
/* For Non Serialized Property */
/*
insert into PropertyArchive
select P.RecordNo,StockNo,PartNo,ArchiveDate=getdate(),GenericName,Attributes,Model,
       Noun,Cost,DrawingNo,PropertyBook,Reservable,Serialized,Warranty,Calibration,
       GovVehicle,Component,Replenishment,GFP,TDA,MgtInterest,FYReportCode,
       LIN,CAGE,LCC,RICC,DODAC,TotalQty,Class,Source,UOM,SupplierDesc,FSC.FSCCode,
       WarehouseDesc,CommodityDesc,CategoryDesc,SubCategoryDesc,InvRecordNo=null,
       TSCSerialNo=null,MfgSerialNo=null,ParentRecord,MIRRNo,PONo,RegisterDocNo,UsaNo=null,
       BumperNo=null,PolKey=null,VINNo=null,ParentRecordNo,ParentSerialNo=null,Revision,
       StorageLocation,InvQty=Qty
from Property P, PropertySupplier PS, Supplier S, PropertyFSC PFSC, FSC, 
     PropertyWarehouse PW, Warehouse W, PropertyComCatSubCat PCCSC, Commodity Com,
     Category Cat, SubCategory SubCat, InvNonSerialized Inv, InvNonSerializedAttributes InvA
where P.RecordNo = PS.RecordNo and
      P.RecordNo = PFSC.RecordNo and
      P.RecordNo = PW.RecordNo and
      P.RecordNo = PCCSC.RecordNo and
      P.RecordNo = Inv.RecordNo and
      P.RecordNo = InvA.RecordNo and
      PS.SupplierNo = S.SupplierNo and
      PFSC.FSCCode = FSC.FSCCode and
      PW.WarehouseCode = W.WarehouseCode and
      PCCSC.CommodityCode = Com.CommodityCode and
      PCCSC.CategoryCode = Cat.CategoryCode and
      PCCSC.SubCategoryCode = SubCat.SubCategoryCode and
      P.RecordNo in (2133)
*/
/*
delete from Property
where RecordNo in (x)

delete from PropertySupplier
where RecordNo in (x)

delete from PropertyFSC
where RecordNo in (x)

delete from PropertyWarehouse
where RecordNo in (x)

delete from PropertyComCatSubCat
where RecordNo in (x)

delete from PropertyReplenishment
where RecordNo in (x)
*/

/* For Serialized Property */
/*
delete from InvSerialized
where RecordNo in (x)

delete from InvSerializedAttributes
where RecordNo in (x)

delete from InvSerializedWarranty
where RecordNo in (x)

select TransactionNo into #Transaction
from InvSerializedTrans
where RecordNo in (x)

delete from InvSerializedTrans
where TransactionNo in (select TransactionNo from #Transaction)
*/

/* For Non Serialized Property */

/*
delete from InvNonSerialized
where RecordNo in (x)

delete from InvNonSerializedAttributes
where RecordNo in (x)

delete from InvNonSerializedWarranty
where RecordNo in (x)

select TransactionNo into #Transaction
from InvNonSerializedTrans
where RecordNo in (x)

delete from InvNonSerializedTrans
where TransactionNo in (select TransactionNo from #Transaction)
*/

/* For both Serialized and Non Serialized property */

delete from TransactionLog 
where TransactionNo in (select TransactionNo from #Transaction)

delete from PropertyTrans 
where TransactionNo in (select TransactionNo from #Transaction)

delete from InvSerializedTrans 
where TransactionNo in (select TransactionNo from #Transaction)

delete from InvNonSerializedTrans 
where TransactionNo in (select TransactionNo from #Transaction)

delete from TransTest
where TransactionNo in (select TransactionNo from #Transaction)

delete from TransactionAction 
where TransactionNo in (select TransactionNo from #Transaction)
*/


