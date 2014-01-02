
SELECT Recordno = Property.RecordNo,   
       invrecordno = Invserialized.InvRecordno,
       nonrecordno = Null,
       Barcode = Invserialized.TSCSerialNo,
       Mfg_Serial_No = Invserialized.MfgSerialno,   
       Description = Property.GenericName + ', ' + Property.Attributes,
       Stock_No = Property.Stockno,
       Part_No = Property.PartNo,
       Model = Property.Model,
       Shop_Noun = Property.Noun
  FROM Property   
  JOIN Invserialized ON Property.RecordNo = Invserialized.RecordNo 
 WHERE Property.GenericName LIKE :Description OR 
       Property.Attributes LIKE :Description OR  
       Property.Noun LIKE :Description OR 
       Property.Description LIKE :Description

UNION

SELECT Recordno = Property.RecordNo,   
       invrecordno = Null,
       nonrecordno = InvNonserialized.NonRecordno,
       Barcode = '',
       Mfg_Serial_No = '',   
       Description = Property.GenericName + ', ' + Property.Attributes,
       Stock_No = Property.Stockno,
       Part_No = Property.PartNo,
       Model = Property.Model,
       Shop_Noun = Property.Noun
  FROM Property   
  JOIN InvNonserialized ON Property.RecordNo = InvNonserialized.RecordNo 
 WHERE Property.GenericName LIKE :Description OR 
       Property.Attributes LIKE :Description OR  
       Property.Noun LIKE :Description OR 
       Property.Description LIKE :Description