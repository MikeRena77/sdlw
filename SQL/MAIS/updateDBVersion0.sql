UPDATE [MAISDB].[dbo].[SYS_CM_Build_Header_Tbl]
SET [Build_ID]=	001,								-- <Build_ID,numeric(3,0),>, 
	[Build_Name]= '',								-- <Build_Name,varchar(30),>, 
	[Database_Version]= '',							-- <Database_Version,varchar(10),>, 
	[Build_Version]= '',							-- <Build_Version,varchar(10),>, 
	[Overall_Crc]= 000000,							-- <Overall_Crc,numeric(6,0),>, 
	[Build_Date]= CURRENT_DATE,						-- <Build_Date,datetime,>, 
	[Build_By]= 'Michael H. Andrews',				-- <Build_By,varchar(30),>, 
	[Created_By]= 'Bob Rasmussen',					-- <Created_By,varchar(30),>, 
	[Creation_Date]= '23 Aug 2004',					-- <Creation_Date,datetime,>, 
	[Modification_Date]='',							-- <Modification_Date,datetime,>, 
	[Modified_By]= ''								-- <Modified_By,varchar(30),>
WHERE												-- <Search conditions,,>
	[Build_ID]=	001