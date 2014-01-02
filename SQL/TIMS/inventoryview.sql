 SELECT  Property.RecordNo,   
         PropertySerialized.SerialBarcodeNo,
	 Property.PartNo,
	 Quantity.AvailableQty,   
         "Quantity Needed" = 0,   
         Property.Description  
    FROM  Property,
	  PropertySerialized,
	  Quantity,
          PropertyComCatSubCat,   
          ComCatSubCat,   
          Commodity,   
	  Category,   
          SubCategory  
   WHERE  ( Commodity.CommodityDesc = "ADPE") AND
          ( Category.CategoryDesc = "COMPUTERS") AND  
	  ( SubCategory.SubCategoryDesc = "TOWER") AND
	  ( Commodity.CommodityCode = ComCatSubCat.CommodityCode ) AND
	  ( Category.CategoryCode = ComCatSubCat.CategoryCode ) AND
	  ( SubCategory.SubCategoryCode = ComCatSubCat.SubCategoryCode ) AND
	  ( ComCatSubCat.ComCatSubCatRecordNo = PropertyComCatSubCat.ComCatSubCatRecordNo ) AND
	  ( PropertyComCatSubCat.RecordNo = Property.RecordNo ) AND
	  ( Property.RecordNo = Quantity.RecordNo ) AND
	  ( Property.RecordNo = PropertySerialized.RecordNo ) AND
          ( Property.ReservableItem = 1 )

