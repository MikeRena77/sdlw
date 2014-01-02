  SELECT    
         Property.StockNo,   
         Property.PartNo,
         Property.GenericName,   
         Property.Attributes,   
         Supplier.SupplierDesc,   
         Property.Model,   
         Property.Noun,
         Category.CategoryDesc,   
         SubCategory.SubCategoryDesc,   
         Warehouse.WarehouseDesc,      
         Property.Cost,   
         Property.TotalQty            
    FROM Property,     
         PropertyComCatSubCat,      
         PropertySupplier,   
         PropertyWarehouse,   
         Category,     
         Commodity,      
         SubCategory,   
         Supplier,   
         Warehouse  
   WHERE ( Property.RecordNo = PropertyComCatSubCat.RecordNo ) and  
         ( Property.RecordNo = PropertySupplier.RecordNo ) and  
         ( Property.RecordNo = PropertyWarehouse.RecordNo ) and  
         ( PropertyComCatSubCat.CommodityCode = Commodity.CommodityCode ) and  
         ( PropertyComCatSubCat.CategoryCode = Category.CategoryCode ) and  
         ( PropertyComCatSubCat.SubCategoryCode = SubCategory.SubCategoryCode ) and   
         ( PropertyWarehouse.WarehouseCode = Warehouse.WarehouseCode ) and  
         ( PropertySupplier.SupplierNo = Supplier.SupplierNo ) and
         ( Commodity.CommodityDesc = "ADPE")   
