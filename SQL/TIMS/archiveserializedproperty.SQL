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
