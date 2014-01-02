  SELECT InvNonSerialized.RecordNo,   
         InvNonSerialized.Location,   
         InvNonSerializedAttributes.StorageLocation,   
         InvNonSerialized.Qty,   
         InvNonSerialized.StatusCode,   
         InvNonSerialized.LastUpdate,   
         InvNonSerialized.Remarks  
    FROM InvNonSerialized,   
         InvNonSerializedAttributes  
   WHERE ( InvNonSerialized.RecordNo = InvNonSerializedAttributes.RecordNo ) and  
         ( ( InvNonSerialized.RecordNo = :recordno ) )    
