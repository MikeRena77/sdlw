/* Microsoft SQL Server - Scripting			*/
/* Server: TIMS01					*/
/* Database: timsdb					*/
/* Creation Date 3/7/00 1:54:16 PM 			*/

/****** Object:  Table root.ActionCode    Script Date: 3/7/00 1:54:19 PM ******/
CREATE TABLE root.ActionCode (
	ActionCode tinyint NOT NULL ,
	ActionCodeDesc varchar (20) NOT NULL 
)
GO

/****** Object:  Table root.ApplicationAccess    Script Date: 3/7/00 1:54:20 PM ******/
CREATE TABLE root.ApplicationAccess (
	AppID smallint NOT NULL ,
	AppName char (20) NOT NULL ,
	AppFunction varchar (30) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX ApplicationAccess_key ON root.ApplicationAccess(AppID)
GO

/****** Object:  Table root.AuthorizationList    Script Date: 3/7/00 1:54:20 PM ******/
CREATE TABLE root.AuthorizationList (
	AuthorizedRecordNo int NOT NULL ,
	OTPNumber varchar (20) NULL ,
	UserID varchar (25) NOT NULL ,
	LoadedBy varchar (25) NOT NULL ,
	DateLoaded datetime NOT NULL ,
	WAONumber varchar (10) NULL 
)
GO

/****** Object:  Table root.AuthorizedHeader    Script Date: 3/7/00 1:54:20 PM ******/
CREATE TABLE root.AuthorizedHeader (
	AuthorizedRecordNo int NOT NULL ,
	RSTHeaderRecordNo int NOT NULL 
)
GO

/****** Object:  Table root.CatSubCat    Script Date: 3/7/00 1:54:20 PM ******/
CREATE TABLE root.CatSubCat (
	CategoryCode smallint NOT NULL ,
	SubCategoryCode smallint NOT NULL 
)
GO

/****** Object:  Table root.Category    Script Date: 3/7/00 1:54:20 PM ******/
CREATE TABLE root.Category (
	CategoryCode smallint NOT NULL ,
	CategoryDesc varchar (20) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX Category_key ON root.Category(CategoryCode)
GO

/****** Object:  Table root.ComCat    Script Date: 3/7/00 1:54:20 PM ******/
CREATE TABLE root.ComCat (
	CommodityCode tinyint NOT NULL ,
	CategoryCode smallint NOT NULL 
)
GO

/****** Object:  Table root.Commodity    Script Date: 3/7/00 1:54:20 PM ******/
CREATE TABLE root.Commodity (
	CommodityCode tinyint NOT NULL ,
	CommodityDesc varchar (20) NOT NULL ,
	CmdMgrEmpNo char (9) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX Commodity_key ON root.Commodity(CommodityCode)
GO

/****** Object:  Table root.Detail    Script Date: 3/7/00 1:54:21 PM ******/
CREATE TABLE root.Detail (
	DetailRecordNo int NOT NULL ,
	RSTHeaderRecordNo int NOT NULL ,
	PropertyRecordNo int NOT NULL ,
	FromDate smalldatetime NOT NULL ,
	ToDate smalldatetime NOT NULL ,
	Status char (1) NOT NULL ,
	Reserve char (1) NOT NULL ,
	Committ char (1) NOT NULL ,
	MakeReady char (1) NOT NULL ,
	Issued char (1) NOT NULL ,
	QuantityNeeded int NOT NULL ,
	ActionQuantity int NOT NULL 
)
GO

 CREATE  UNIQUE  INDEX Detail_x ON root.Detail(DetailRecordNo)
GO

/****** Object:  Table root.Distribution    Script Date: 3/7/00 1:54:21 PM ******/
CREATE TABLE root.Distribution (
	DetailRecordNo int NOT NULL ,
	Reserved int NOT NULL ,
	Comitted int NOT NULL ,
	Issued int NOT NULL 
)
GO

 CREATE  UNIQUE  INDEX Distribution_x ON root.Distribution(DetailRecordNo)
GO

/****** Object:  Table root.FSC    Script Date: 3/7/00 1:54:21 PM ******/
CREATE TABLE root.FSC (
	FSCCode char (4) NOT NULL ,
	FSCDesc varchar (100) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX FSC_key ON root.FSC(FSCCode)
GO

/****** Object:  Table root.FormDetail    Script Date: 3/7/00 1:54:21 PM ******/
CREATE TABLE root.FormDetail (
	FormNo decimal(18, 0) NOT NULL ,
	LastUpdate datetime NOT NULL ,
	RecordNo int NOT NULL ,
	ItemNo smallint NOT NULL ,
	Status varchar (15) NOT NULL ,
	TSCSerialNo varchar (15) NULL ,
	MFGSerialNo varchar (15) NULL ,
	Quantity smallint NOT NULL ,
	InvRecordNo int NULL 
)
GO

/****** Object:  Table root.FormHeader    Script Date: 3/7/00 1:54:21 PM ******/
CREATE TABLE root.FormHeader (
	FormNo decimal(18, 0) NOT NULL ,
	LastUpdate datetime NOT NULL ,
	CreateDate datetime NOT NULL ,
	FormType char (15) NOT NULL ,
	TempIssue char (1) NOT NULL ,
	TestIssue char (1) NULL ,
	TestNo smallint NULL ,
	IssueByName varchar (25) NOT NULL ,
	IssueByEmpNo char (9) NOT NULL ,
	IssueToName varchar (25) NOT NULL ,
	IssueToEmpNo char (9) NOT NULL ,
	WorkRequestNo char (15) NULL ,
	PhaseNo char (6) NULL ,
	ExpectReturnDate datetime NOT NULL ,
	FormStatus varchar (15) NOT NULL ,
	OffStation char (1) NOT NULL ,
	WAONo varchar (10) NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX FormHeader_key ON root.FormHeader(FormNo, LastUpdate)
GO

/****** Object:  Table root.FormStatus    Script Date: 3/7/00 1:54:21 PM ******/
CREATE TABLE root.FormStatus (
	Status tinyint NOT NULL ,
	StatusDesc varchar (15) NOT NULL 
)
GO

/****** Object:  Table root.FormType    Script Date: 3/7/00 1:54:22 PM ******/
CREATE TABLE root.FormType (
	FormType char (15) NOT NULL ,
	FormDesc char (25) NOT NULL 
)
GO

/****** Object:  Table root.InvNonSerialized    Script Date: 3/7/00 1:54:22 PM ******/
CREATE TABLE root.InvNonSerialized (
	RecordNo int NOT NULL ,
	Location varchar (15) NULL ,
	Remarks text NULL ,
	Qty int NOT NULL ,
	StatusCode tinyint NOT NULL ,
	LastUpdate datetime NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX invnonserialized_key ON root.InvNonSerialized(RecordNo, Location)
GO

/****** Object:  Table root.InvNonSerializedAttributes    Script Date: 3/7/00 1:54:22 PM ******/
CREATE TABLE root.InvNonSerializedAttributes (
	RecordNo int NOT NULL ,
	ParentRecord varchar (25) NULL ,
	MIRRNo char (13) NULL ,
	PONo char (13) NULL ,
	RegisterDocNO char (9) NULL ,
	ParentRecordNo int NULL ,
	Revision char (3) NULL ,
	StorageLocation varchar (25) NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX InvNonSerializedAttributes_key ON root.InvNonSerializedAttributes(RecordNo)
GO

/****** Object:  Table root.InvNonSerializedTrans    Script Date: 3/7/00 1:54:22 PM ******/
CREATE TABLE root.InvNonSerializedTrans (
	RecordNo int NOT NULL ,
	TransactionNo decimal(18, 0) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX InvNonSerializedTrans_key ON root.InvNonSerializedTrans(RecordNo, TransactionNo)
GO

/****** Object:  Table root.InvNonSerializedWarranty    Script Date: 3/7/00 1:54:22 PM ******/
CREATE TABLE root.InvNonSerializedWarranty (
	RecordNo int NOT NULL ,
	MfgWarranty char (1) NOT NULL ,
	MfgNo smallint NULL ,
	MfgWarExpDate datetime NULL ,
	VendorWarranty char (1) NOT NULL ,
	VendorNo smallint NULL ,
	VendorWarExpDate datetime NULL ,
	ThirdPartyWarranty char (1) NOT NULL ,
	ThirdPartyNo smallint NULL ,
	ThirdPartyWarExpDate datetime NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX InvNonSerializedWarranty_key ON root.InvNonSerializedWarranty(RecordNo)
GO

/****** Object:  Table root.InvSerialized    Script Date: 3/7/00 1:54:22 PM ******/
CREATE TABLE root.InvSerialized (
	InvRecordNo int NOT NULL ,
	RecordNo int NOT NULL ,
	TSCSerialNo varchar (15) NULL ,
	MfgSerialNo varchar (15) NULL ,
	Location varchar (15) NULL ,
	Remarks text NULL ,
	StatusCode tinyint NOT NULL ,
	LastUpdate datetime NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX InvSerialized_key ON root.InvSerialized(InvRecordNo)
GO

 CREATE  INDEX invserialized_recordno ON root.InvSerialized(RecordNo)
GO

/****** Object:  Table root.InvSerializedAttributes    Script Date: 3/7/00 1:54:23 PM ******/
CREATE TABLE root.InvSerializedAttributes (
	RecordNo int NOT NULL ,
	InvRecordNo int NOT NULL ,
	ParentRecord varchar (25) NULL ,
	MIRRNo char (13) NULL ,
	PONo char (13) NULL ,
	RegisterDocNo char (9) NULL ,
	UsaNo char (7) NULL ,
	BumperNo char (10) NULL ,
	PolKey char (6) NULL ,
	VINNo varchar (20) NULL ,
	ParentRecordNo int NULL ,
	ParentSerialNo varchar (15) NULL ,
	Revision char (3) NULL ,
	StorageLocation varchar (25) NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX InvSerializedAttributes_key ON root.InvSerializedAttributes(RecordNo, InvRecordNo)
GO

/****** Object:  Table root.InvSerializedTrans    Script Date: 3/7/00 1:54:23 PM ******/
CREATE TABLE root.InvSerializedTrans (
	RecordNo int NOT NULL ,
	InvRecordNo int NOT NULL ,
	TransactionNo decimal(18, 0) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX InvSerialzedTrans_key ON root.InvSerializedTrans(RecordNo, InvRecordNo, TransactionNo)
GO

/****** Object:  Table root.InvSerializedWarranty    Script Date: 3/7/00 1:54:23 PM ******/
CREATE TABLE root.InvSerializedWarranty (
	RecordNo int NOT NULL ,
	InvRecordNo int NOT NULL ,
	MfgWarranty char (1) NOT NULL ,
	MfgNo smallint NULL ,
	MfgWarExpDate datetime NULL ,
	VendorWarranty char (1) NOT NULL ,
	VendorNo smallint NULL ,
	VendorWarExpDate datetime NULL ,
	ThirdPartyWarranty char (1) NOT NULL ,
	ThirdPartyNo smallint NULL ,
	ThirdPartyWarExpDate datetime NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX InvSerializedWarranty_key ON root.InvSerializedWarranty(InvRecordNo)
GO

/****** Object:  Table root.LastFormNo    Script Date: 3/7/00 1:54:23 PM ******/
CREATE TABLE root.LastFormNo (
	FormNo decimal(18, 0) NOT NULL ,
	LastUpdate datetime NOT NULL 
)
GO

/****** Object:  Table root.LastInvRecordNo    Script Date: 3/7/00 1:54:23 PM ******/
CREATE TABLE root.LastInvRecordNo (
	InvRecordNo int NOT NULL ,
	LastUpdate datetime NOT NULL 
)
GO

/****** Object:  Table root.LastPropRecordNo    Script Date: 3/7/00 1:54:23 PM ******/
CREATE TABLE root.LastPropRecordNo (
	RecordNo int NOT NULL ,
	LastUpdate datetime NOT NULL 
)
GO

/****** Object:  Table root.LastStockNo    Script Date: 3/7/00 1:54:24 PM ******/
CREATE TABLE root.LastStockNo (
	FSC char (4) NOT NULL ,
	SeqNo char (4) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX LastStockNo_key ON root.LastStockNo(FSC)
GO

/****** Object:  Table root.LastTestNo    Script Date: 3/7/00 1:54:24 PM ******/
CREATE TABLE root.LastTestNo (
	TestNo smallint NOT NULL ,
	LastUpdate datetime NOT NULL 
)
GO

/****** Object:  Table root.LastTransaction    Script Date: 3/7/00 1:54:24 PM ******/
CREATE TABLE root.LastTransaction (
	LastTransaction decimal(18, 0) NOT NULL ,
	LastDate datetime NOT NULL ,
	LastBase smallint NOT NULL 
)
GO

/****** Object:  Table root.Location    Script Date: 3/7/00 1:54:24 PM ******/
CREATE TABLE root.Location (
	Location varchar (25) NOT NULL ,
	LocationType varchar (15) NOT NULL ,
	LocationDesc varchar (80) NOT NULL ,
	Address varchar (80) NOT NULL ,
	City varchar (25) NOT NULL ,
	State char (2) NOT NULL ,
	Zip char (10) NOT NULL 
)
GO

/****** Object:  Table root.MakeReady    Script Date: 3/7/00 1:54:24 PM ******/
CREATE TABLE root.MakeReady (
	TransactionNo decimal(18, 0) NOT NULL ,
	WorkRequestNo varchar (10) NULL ,
	PhaseNo varchar (3) NULL 
)
GO

/****** Object:  Table root.OTP    Script Date: 3/7/00 1:54:24 PM ******/
CREATE TABLE root.OTP (
	OTPNo varchar (20) NOT NULL ,
	OTPTestOfficer varchar (25) NOT NULL 
)
GO

/****** Object:  Table root.PT35_ASSET    Script Date: 3/7/00 1:54:25 PM ******/
CREATE TABLE root.PT35_ASSET (
	AS_ID int NOT NULL ,
	ROW_VER int NOT NULL ,
	AS_NAME varchar (50) NULL ,
	AS_TYPE varchar (50) NULL ,
	AS_STATUS varchar (50) NULL ,
	AS_USED_BY varchar (50) NULL ,
	AS_LOCATION varchar (250) NULL ,
	AS_BOUGHT_ON datetime NULL ,
	AS_SERIAL varchar (50) NULL ,
	AS_NOTES text NULL 
)
GO

/****** Object:  Table root.PT35_ATTACHED    Script Date: 3/7/00 1:54:25 PM ******/
CREATE TABLE root.PT35_ATTACHED (
	FILE_ID int NOT NULL ,
	TRACKING_ID int NOT NULL ,
	FILE_NAME varchar (50) NOT NULL ,
	FILE_DESC varchar (250) NULL ,
	FILE_SIZE int NOT NULL ,
	FILE_TIME datetime NOT NULL ,
	FILE_DATA image NULL 
)
GO

/****** Object:  Table root.PT35_ATTACHED2    Script Date: 3/7/00 1:54:25 PM ******/
CREATE TABLE root.PT35_ATTACHED2 (
	FILE_ID int NOT NULL ,
	TRACKING_ID int NOT NULL ,
	FILE_NAME varchar (50) NOT NULL ,
	FILE_DESC varchar (250) NULL ,
	FILE_SIZE int NOT NULL ,
	FILE_TIME datetime NOT NULL ,
	FILE_DATA image NULL 
)
GO

/****** Object:  Table root.PT35_CHANGE    Script Date: 3/7/00 1:54:25 PM ******/
CREATE TABLE root.PT35_CHANGE (
	CHANGE_ID int NOT NULL ,
	TRACKING_ID int NOT NULL ,
	MADE_BY varchar (50) NULL ,
	MADE_ON datetime NOT NULL ,
	TYPE varchar (20) NULL ,
	DESCRIPTION text NULL 
)
GO

/****** Object:  Table root.PT35_CHANGE2    Script Date: 3/7/00 1:54:25 PM ******/
CREATE TABLE root.PT35_CHANGE2 (
	CHANGE_ID int NOT NULL ,
	TRACKING_ID int NOT NULL ,
	MADE_BY varchar (50) NULL ,
	MADE_ON datetime NOT NULL ,
	TYPE varchar (20) NULL ,
	DESCRIPTION text NULL 
)
GO

/****** Object:  Table root.PT35_DOC    Script Date: 3/7/00 1:54:25 PM ******/
CREATE TABLE root.PT35_DOC (
	DOC_ID int NOT NULL ,
	DOC_OWNER varchar (50) NULL ,
	DOC_CREATED_BY varchar (50) NULL ,
	DOC_CREATED_ON datetime NULL ,
	DOC_UPDATED_BY varchar (50) NULL ,
	DOC_UPDATED_ON datetime NULL ,
	DOC_LOCKED_BY varchar (50) NULL ,
	DOC_LOCKED_ON datetime NULL ,
	DOC_PRODUCT varchar (50) NULL ,
	DOC_NAME varchar (50) NULL ,
	DOC_SIZE int NOT NULL ,
	DOC_TITLE varchar (250) NULL ,
	DOC_KEYWORD varchar (250) NULL ,
	DOC_SUMMARY text NULL ,
	DOC_CONTENT text NULL ,
	DOC_NOTE text NULL 
)
GO

/****** Object:  Table root.PT35_MODULE    Script Date: 3/7/00 1:54:26 PM ******/
CREATE TABLE root.PT35_MODULE (
	MODULE_ID int NOT NULL ,
	ROW_VER int NOT NULL ,
	PRODUCT varchar (50) NOT NULL ,
	NAME varchar (50) NOT NULL ,
	DESCRIPTION varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_PRIORITY    Script Date: 3/7/00 1:54:26 PM ******/
CREATE TABLE root.PT35_PRIORITY (
	NAME varchar (20) NOT NULL ,
	ROW_VER int NOT NULL ,
	DESCRIPTION varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_PRIORITY2    Script Date: 3/7/00 1:54:26 PM ******/
CREATE TABLE root.PT35_PRIORITY2 (
	NAME varchar (20) NOT NULL ,
	ROW_VER int NOT NULL ,
	DESCRIPTION varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_PRODUCT    Script Date: 3/7/00 1:54:26 PM ******/
CREATE TABLE root.PT35_PRODUCT (
	NAME varchar (50) NOT NULL ,
	ROW_VER int NOT NULL ,
	DESCRIPTION varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_PROD_USER    Script Date: 3/7/00 1:54:26 PM ******/
CREATE TABLE root.PT35_PROD_USER (
	RELATION_ID int NOT NULL ,
	ROW_VER int NOT NULL ,
	USER_ID varchar (50) NOT NULL ,
	PRODUCT varchar (50) NOT NULL ,
	RELATION varchar (50) NOT NULL 
)
GO

/****** Object:  Table root.PT35_QUERY    Script Date: 3/7/00 1:54:27 PM ******/
CREATE TABLE root.PT35_QUERY (
	QUERY_ID int NOT NULL ,
	ROW_VER int NOT NULL ,
	NAME varchar (100) NULL ,
	TYPE varchar (20) NULL ,
	SQL_SELECT varchar (250) NULL ,
	SQL_FROM varchar (50) NULL ,
	SQL_WHERE text NULL ,
	SQL_ORDERBY varchar (100) NULL ,
	MAX_ROW int NULL ,
	MAX_COL int NULL ,
	HTM_WHERE text NULL ,
	COL_WIDTHES varchar (100) NULL ,
	OPTIONS varchar (250) NULL ,
	PRODUCT varchar (50) NULL 
)
GO

/****** Object:  Table root.PT35_REGISTRY    Script Date: 3/7/00 1:54:27 PM ******/
CREATE TABLE root.PT35_REGISTRY (
	REG_USER varchar (50) NOT NULL ,
	REG_SECTION varchar (50) NOT NULL ,
	REG_KEY varchar (50) NOT NULL ,
	REG_VALUE varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_STATUS    Script Date: 3/7/00 1:54:27 PM ******/
CREATE TABLE root.PT35_STATUS (
	NAME varchar (20) NOT NULL ,
	ROW_VER int NOT NULL ,
	SEQ_NUM int NOT NULL ,
	DESCRIPTION varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_STATUS2    Script Date: 3/7/00 1:54:27 PM ******/
CREATE TABLE root.PT35_STATUS2 (
	NAME varchar (20) NOT NULL ,
	ROW_VER int NOT NULL ,
	SEQ_NUM int NOT NULL ,
	DESCRIPTION varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_TRACK    Script Date: 3/7/00 1:54:27 PM ******/
CREATE TABLE root.PT35_TRACK (
	TRACKING_ID int NOT NULL ,
	ROW_VER int NOT NULL ,
	STATUS varchar (20) NULL ,
	PRIORITY varchar (20) NULL ,
	DEADLINE datetime NULL ,
	SUBMITTED_TO varchar (50) NULL ,
	SUBMITTED_BY varchar (50) NULL ,
	SUBMITTED_ON datetime NULL ,
	ASSIGNED_TO varchar (50) NULL ,
	ASSIGNED_BY varchar (50) NULL ,
	ASSIGNED_ON datetime NULL ,
	RESOLVED_BY varchar (50) NULL ,
	RESOLVED_ON datetime NULL ,
	CLOSED_BY varchar (50) NULL ,
	CLOSED_ON datetime NULL ,
	PRODUCT varchar (50) NULL ,
	MODULE_ID int NULL ,
	VERSION1_ID int NULL ,
	VERSION2_ID int NULL ,
	TITLE varchar (250) NULL ,
	REMINDER_FLAG varchar (2) NULL ,
	CUSTOM_NUM1 int NULL ,
	CUSTOM_NUM2 int NULL ,
	CUSTOM_DATE1 datetime NULL ,
	CUSTOM_DATE2 datetime NULL ,
	CUSTOM_TEXT1 varchar (50) NULL ,
	CUSTOM_TEXT2 varchar (50) NULL ,
	CUSTOM_TEXT3 varchar (50) NULL ,
	CUSTOM_TEXT4 varchar (50) NULL ,
	CUSTOM_TEXT5 varchar (50) NULL ,
	CUSTOM_TEXT6 varchar (50) NULL 
)
GO

/****** Object:  Table root.PT35_TRACK2    Script Date: 3/7/00 1:54:28 PM ******/
CREATE TABLE root.PT35_TRACK2 (
	TRACKING_ID int NOT NULL ,
	ROW_VER int NOT NULL ,
	STATUS varchar (20) NULL ,
	PRIORITY varchar (20) NULL ,
	DEADLINE datetime NULL ,
	SUBMITTED_TO varchar (50) NULL ,
	SUBMITTED_BY varchar (50) NULL ,
	SUBMITTED_ON datetime NULL ,
	ASSIGNED_TO varchar (50) NULL ,
	ASSIGNED_BY varchar (50) NULL ,
	ASSIGNED_ON datetime NULL ,
	RESOLVED_BY varchar (50) NULL ,
	RESOLVED_ON datetime NULL ,
	CLOSED_BY varchar (50) NULL ,
	CLOSED_ON datetime NULL ,
	PRODUCT varchar (50) NULL ,
	MODULE_ID int NULL ,
	VERSION1_ID int NULL ,
	VERSION2_ID int NULL ,
	TITLE varchar (250) NULL ,
	DETAIL text NULL ,
	RESOLUTION text NULL ,
	REMINDER_FLAG varchar (2) NULL 
)
GO

/****** Object:  Table root.PT35_TRACK_TRACK2    Script Date: 3/7/00 1:54:28 PM ******/
CREATE TABLE root.PT35_TRACK_TRACK2 (
	FROM_ID int NOT NULL ,
	TO_ID int NOT NULL 
)
GO

/****** Object:  Table root.PT35_TRACK_TYPE    Script Date: 3/7/00 1:54:28 PM ******/
CREATE TABLE root.PT35_TRACK_TYPE (
	NAME varchar (50) NOT NULL ,
	DEF_TYPE varchar (10) NULL 
)
GO

/****** Object:  Table root.PT35_USER    Script Date: 3/7/00 1:54:28 PM ******/
CREATE TABLE root.PT35_USER (
	USER_ID varchar (50) NOT NULL ,
	ROW_VER int NOT NULL ,
	FULL_NAME varchar (50) NULL ,
	TYPE varchar (20) NULL ,
	PHONE varchar (50) NULL ,
	FAX varchar (50) NULL ,
	EMAIL varchar (200) NULL ,
	COMPANY varchar (50) NULL ,
	DEPT varchar (50) NULL ,
	TITLE varchar (50) NULL ,
	ADDRESS varchar (50) NULL ,
	CITY varchar (50) NULL ,
	STATE varchar (50) NULL ,
	ZIPCODE varchar (50) NULL ,
	COUNTRY varchar (50) NULL ,
	PASSWORD varchar (10) NULL ,
	SERIAL_NUM varchar (50) NULL ,
	NOTE varchar (250) NULL 
)
GO

/****** Object:  Table root.PT35_VERSION    Script Date: 3/7/00 1:54:28 PM ******/
CREATE TABLE root.PT35_VERSION (
	VERSION_ID int NOT NULL ,
	ROW_VER int NOT NULL ,
	PRODUCT varchar (50) NOT NULL ,
	NAME varchar (50) NOT NULL ,
	DESCRIPTION varchar (250) NULL 
)
GO

/****** Object:  Table root.PartTrans    Script Date: 3/7/00 1:54:29 PM ******/
CREATE TABLE root.PartTrans (
	TransactionNo decimal(18, 0) NOT NULL ,
	RecordNo int NOT NULL ,
	DetailRecordNo int NOT NULL 
)
GO

 CREATE  UNIQUE  INDEX PartTrans_x ON root.PartTrans(DetailRecordNo, RecordNo, TransactionNo)
GO

/****** Object:  Table root.ProjectTestType    Script Date: 3/7/00 1:54:29 PM ******/
CREATE TABLE root.ProjectTestType (
	TestNo smallint NOT NULL ,
	TestType varchar (20) NOT NULL 
)
GO

/****** Object:  Table root.PropReplenishment    Script Date: 3/7/00 1:54:29 PM ******/
CREATE TABLE root.PropReplenishment (
	RecordNo int NOT NULL ,
	MinQty int NOT NULL ,
	MaxQty int NOT NULL ,
	ReorderPoint int NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropReplenishment_key ON root.PropReplenishment(RecordNo)
GO

/****** Object:  Table root.PropTransBuildListDetail    Script Date: 3/7/00 1:54:29 PM ******/
CREATE TABLE root.PropTransBuildListDetail (
	PropTransBuildListNo decimal(18, 0) NOT NULL ,
	CreateDate datetime NOT NULL ,
	RecordNo int NOT NULL ,
	ItemNo int NOT NULL ,
	InvRecordNo int NULL ,
	TSCSerialNo varchar (15) NULL ,
	MFGSerialNo varchar (15) NULL ,
	Status tinyint NOT NULL ,
	Quantity smallint NOT NULL ,
	ActionCode tinyint NOT NULL ,
	PBCode tinyint NOT NULL ,
	BuildListItemStatus char (6) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropTransBuildListDetail_key ON root.PropTransBuildListDetail(PropTransBuildListNo, ItemNo)
GO

/****** Object:  Table root.PropTransBuildListHeader    Script Date: 3/7/00 1:54:29 PM ******/
CREATE TABLE root.PropTransBuildListHeader (
	PropTransBuildListNo decimal(18, 0) NOT NULL ,
	CreateDate datetime NOT NULL ,
	PostedByName varchar (25) NOT NULL ,
	PostedByEmpNo char (9) NOT NULL ,
	ReceivingOrg varchar (25) NULL ,
	BuildListStatus char (6) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropTransBuildListHeader_key ON root.PropTransBuildListHeader(PropTransBuildListNo)
GO

/****** Object:  Table root.PropTransDetail    Script Date: 3/7/00 1:54:29 PM ******/
CREATE TABLE root.PropTransDetail (
	PropTransNo decimal(18, 0) NOT NULL ,
	CreateDate datetime NOT NULL ,
	RecordNo int NOT NULL ,
	ItemNo int NOT NULL ,
	InvRecordNo int NULL ,
	TSCSerialNo varchar (15) NULL ,
	MFGSerialNo varchar (15) NULL ,
	Status tinyint NOT NULL ,
	Quantity smallint NOT NULL ,
	ActionCode tinyint NOT NULL ,
	PBCode tinyint NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropTransDetail_key ON root.PropTransDetail(PropTransNo, ItemNo)
GO

/****** Object:  Table root.PropTransHeader    Script Date: 3/7/00 1:54:30 PM ******/
CREATE TABLE root.PropTransHeader (
	PropTransNo decimal(18, 0) NOT NULL ,
	CreateDate datetime NOT NULL ,
	PostedByName varchar (25) NOT NULL ,
	PostedByEmpNo char (9) NOT NULL ,
	ReceivingOrg varchar (25) NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropTransHeader_key ON root.PropTransHeader(PropTransNo)
GO

/****** Object:  Table root.Property    Script Date: 3/7/00 1:54:30 PM ******/
CREATE TABLE root.Property (
	RecordNo int NOT NULL ,
	StockNo char (16) NOT NULL ,
	PartNo varchar (18) NOT NULL ,
	GenericName varchar (20) NOT NULL ,
	Attributes varchar (50) NULL ,
	Model varchar (20) NULL ,
	Noun varchar (50) NULL ,
	Cost money NOT NULL ,
	DrawingNo varchar (13) NULL ,
	PropertyBook char (1) NOT NULL ,
	Reservable char (1) NOT NULL ,
	Serialized char (1) NOT NULL ,
	Warranty char (1) NOT NULL ,
	Calibration char (1) NOT NULL ,
	GovVehicle char (1) NOT NULL ,
	Component char (1) NOT NULL ,
	Replenishment char (1) NOT NULL ,
	GFP char (1) NULL ,
	TDA char (1) NULL ,
	MgtInterest char (1) NOT NULL ,
	FYReportCode char (3) NULL ,
	LIN char (6) NULL ,
	CAGE char (6) NULL ,
	LCC char (1) NULL ,
	RICC char (1) NULL ,
	DODAC char (8) NULL ,
	TotalQty smallint NOT NULL ,
	Class varchar (20) NOT NULL ,
	Source varchar (20) NOT NULL ,
	UOM varchar (15) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX Property_key ON root.Property(RecordNo)
GO

 CREATE  INDEX Property_StockNo_ind ON root.Property(StockNo)
GO

/****** Object:  Table root.PropertyArchive    Script Date: 3/7/00 1:54:30 PM ******/
CREATE TABLE root.PropertyArchive (
	RecordNo int NOT NULL ,
	StockNo char (16) NOT NULL ,
	PartNo varchar (18) NOT NULL ,
	ArchiveDate datetime NOT NULL ,
	GenericName varchar (20) NOT NULL ,
	Attributes varchar (50) NULL ,
	Model varchar (20) NULL ,
	Noun varchar (50) NULL ,
	Cost money NOT NULL ,
	DrawingNo varchar (13) NULL ,
	PropertyBook char (1) NOT NULL ,
	Reservable char (1) NOT NULL ,
	Serialized char (1) NOT NULL ,
	Warranty char (1) NOT NULL ,
	Calibration char (1) NOT NULL ,
	GovVehicle char (1) NOT NULL ,
	Component char (1) NOT NULL ,
	Replenishment char (1) NOT NULL ,
	GFP char (1) NULL ,
	TDA char (1) NULL ,
	MgtInterest char (1) NOT NULL ,
	FYReportCode char (3) NULL ,
	LIN char (6) NULL ,
	CAGE char (6) NULL ,
	LCC char (1) NULL ,
	RICC char (1) NULL ,
	DODAC char (8) NULL ,
	TotalQty smallint NOT NULL ,
	Class varchar (15) NOT NULL ,
	Source varchar (20) NOT NULL ,
	UOM varchar (15) NOT NULL ,
	SupplierDesc varchar (20) NOT NULL ,
	FSCCode char (4) NOT NULL ,
	WarehouseDesc varchar (20) NOT NULL ,
	CommodityDesc varchar (20) NOT NULL ,
	CategoryDesc varchar (20) NOT NULL ,
	SubCategoryDesc varchar (20) NOT NULL ,
	InvRecordNo int NULL ,
	TSCSerialNo varchar (15) NULL ,
	MfgSerialNo varchar (15) NULL ,
	ParentRecord varchar (25) NULL ,
	MIRRNo char (13) NULL ,
	PONo char (13) NULL ,
	RegisterDocNo char (9) NULL ,
	UsaNo char (7) NULL ,
	BumperNo char (10) NULL ,
	PolKey char (6) NULL ,
	VINNo varchar (20) NULL ,
	ParentRecordNo int NULL ,
	ParentSerialNo varchar (15) NULL ,
	Revision char (3) NULL ,
	StorageLocation varchar (25) NULL ,
	InvQty int NOT NULL 
)
GO

/****** Object:  Table root.PropertyBookCode    Script Date: 3/7/00 1:54:31 PM ******/
CREATE TABLE root.PropertyBookCode (
	PBCode tinyint NOT NULL ,
	PBDesc varchar (20) NOT NULL 
)
GO

/****** Object:  Table root.PropertyComCatSubCat    Script Date: 3/7/00 1:54:31 PM ******/
CREATE TABLE root.PropertyComCatSubCat (
	RecordNo int NOT NULL ,
	CommodityCode tinyint NOT NULL ,
	CategoryCode smallint NOT NULL ,
	SubCategoryCode smallint NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropertyComCatSubCat_key ON root.PropertyComCatSubCat(RecordNo, CommodityCode, CategoryCode, SubCategoryCode)
GO

/****** Object:  Table root.PropertyDetail    Script Date: 3/7/00 1:54:31 PM ******/
CREATE TABLE root.PropertyDetail (
	RecordNo int NOT NULL ,
	stockno char (16) NULL ,
	partno char (18) NULL ,
	new_desc char (116) NULL ,
	descrip char (80) NULL ,
	genericname char (20) NULL ,
	attributes char (50) NULL ,
	manufacturer char (20) NULL ,
	model char (20) NULL ,
	barcode char (6) NULL ,
	noun char (25) NULL ,
	unit char (2) NULL ,
	qty smallint NULL ,
	comp char (1) NULL ,
	enditems char (25) NULL ,
	fsc_code char (4) NULL ,
	drawingno char (13) NULL ,
	price money NULL ,
	class char (15) NULL ,
	offstation char (3) NULL ,
	commodity char (15) NULL ,
	category char (15) NULL ,
	subcat char (15) NULL ,
	warehouse char (15) NULL ,
	location char (15) NULL ,
	wao char (6) NULL ,
	remarks char (30) NULL ,
	remark1 char (15) NULL ,
	postdate char (8) NULL ,
	changes char (8) NULL ,
	postinit char (3) NULL ,
	hrno char (3) NULL ,
	oldhr char (3) NULL ,
	invdata char (9) NULL ,
	schinvyr char (2) NULL ,
	shipstatus char (20) NULL ,
	idnumber char (8) NULL ,
	serno char (20) NULL ,
	polkey char (6) NULL ,
	usanumber char (7) NULL ,
	system char (5) NULL ,
	docno char (9) NULL ,
	action char (2) NULL ,
	lin char (6) NULL ,
	te10 char (1) NULL ,
	gfp char (1) NULL ,
	lcc char (1) NULL ,
	cage char (6) NULL ,
	tda char (1) NULL ,
	fyrptcode char (3) NULL ,
	ricc char (1) NULL 
)
GO

 CREATE  CLUSTERED  INDEX detail_recno ON root.PropertyDetail(RecordNo) WITH  ALLOW_DUP_ROW 
GO

/****** Object:  Table root.PropertyFSC    Script Date: 3/7/00 1:54:31 PM ******/
CREATE TABLE root.PropertyFSC (
	RecordNo int NOT NULL ,
	FSCCode char (4) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropertyFSC_key ON root.PropertyFSC(RecordNo, FSCCode)
GO

/****** Object:  Table root.PropertyImport    Script Date: 3/7/00 1:54:31 PM ******/
CREATE TABLE root.PropertyImport (
	bad char (1) NULL ,
	bcerr char (1) NULL ,
	snerr char (1) NULL ,
	stockno char (16) NULL ,
	partno char (18) NULL ,
	barcode char (6) NULL ,
	serno char (20) NULL ,
	ctrlserno char (20) NULL ,
	descrip char (80) NULL ,
	genericname char (20) NULL ,
	attributes char (50) NULL ,
	manufacturer char (20) NULL ,
	model char (20) NULL ,
	new_desc char (116) NULL ,
	noun char (25) NULL ,
	class char (15) NULL ,
	commodity char (15) NULL ,
	category char (15) NULL ,
	subcat char (15) NULL ,
	warehouse char (15) NULL ,
	qty smallint NULL ,
	unit char (2) NULL ,
	price money NULL ,
	offstation char (3) NULL ,
	location char (15) NULL ,
	wao char (6) NULL ,
	comp char (1) NULL ,
	enditems char (25) NULL ,
	drawingno char (13) NULL ,
	fsc_code char (4) NULL ,
	remarks char (30) NULL ,
	remark1 char (15) NULL ,
	action char (2) NULL ,
	changes char (8) NULL ,
	postdate char (8) NULL ,
	postinit char (3) NULL ,
	invdata char (9) NULL ,
	schinvyr char (2) NULL ,
	hrno char (3) NULL ,
	oldhr char (3) NULL ,
	shipstatus char (20) NULL ,
	docno char (9) NULL ,
	idnumber char (8) NULL ,
	usanumber char (7) NULL ,
	polkey char (6) NULL ,
	system char (5) NULL ,
	lin char (6) NULL ,
	gfp char (1) NULL ,
	lcc char (1) NULL ,
	cage char (6) NULL ,
	ricc char (1) NULL ,
	fyrptcode char (3) NULL ,
	te10 char (1) NULL ,
	tda char (1) NULL ,
	sequence int NULL ,
	recseq int NULL 
)
GO

/****** Object:  Table root.PropertySupplier    Script Date: 3/7/00 1:54:32 PM ******/
CREATE TABLE root.PropertySupplier (
	RecordNo int NOT NULL ,
	SupplierNo smallint NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropertySupplier_key ON root.PropertySupplier(RecordNo, SupplierNo)
GO

/****** Object:  Table root.PropertyTrans    Script Date: 3/7/00 1:54:32 PM ******/
CREATE TABLE root.PropertyTrans (
	RecordNo int NOT NULL ,
	TransactionNo decimal(18, 0) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropertyTrans_key ON root.PropertyTrans(RecordNo, TransactionNo)
GO

/****** Object:  Table root.PropertyWarehouse    Script Date: 3/7/00 1:54:32 PM ******/
CREATE TABLE root.PropertyWarehouse (
	RecordNo int NOT NULL ,
	WarehouseCode tinyint NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX PropertyWarehouse_key ON root.PropertyWarehouse(RecordNo)
GO

/****** Object:  Table root.RSTHeader    Script Date: 3/7/00 1:54:32 PM ******/
CREATE TABLE root.RSTHeader (
	RSTHeaderRecordNo int NOT NULL ,
	WAONumber varchar (10) NULL ,
	OTPNumber varchar (20) NULL ,
	CreatedBy varchar (25) NOT NULL ,
	CreationDate datetime NOT NULL ,
	LastUpdatedBy varchar (25) NOT NULL ,
	LastUpdatedDate datetime NOT NULL 
)
GO

 CREATE  UNIQUE  INDEX RSTHeader_x ON root.RSTHeader(RSTHeaderRecordNo)
GO

/****** Object:  Table root.RSTIssue    Script Date: 3/7/00 1:54:32 PM ******/
CREATE TABLE root.RSTIssue (
	TransactionNo decimal(18, 0) NOT NULL ,
	WAO varchar (10) NOT NULL ,
	WarehouseCode tinyint NOT NULL ,
	SenderName varchar (25) NOT NULL ,
	SentDateTime datetime NOT NULL 
)
GO

/****** Object:  Table root.Site    Script Date: 3/7/00 1:54:32 PM ******/
CREATE TABLE root.Site (
	SiteCode tinyint NOT NULL ,
	SiteDesc varchar (20) NOT NULL 
)
GO

/****** Object:  Table root.StatusCode    Script Date: 3/7/00 1:54:33 PM ******/
CREATE TABLE root.StatusCode (
	StatusCode tinyint NOT NULL ,
	StatusCodeDesc varchar (20) NOT NULL 
)
GO

/****** Object:  Table root.SubCategory    Script Date: 3/7/00 1:54:33 PM ******/
CREATE TABLE root.SubCategory (
	SubCategoryCode smallint NOT NULL ,
	SubCategoryDesc varchar (20) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX SubCategory_key ON root.SubCategory(SubCategoryCode)
GO

/****** Object:  Table root.Supplier    Script Date: 3/7/00 1:54:33 PM ******/
CREATE TABLE root.Supplier (
	SupplierNo smallint NOT NULL ,
	SupplierDesc varchar (20) NOT NULL ,
	SupplierPhone char (11) NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX Supplier_key ON root.Supplier(SupplierNo)
GO

/****** Object:  Table root.Test    Script Date: 3/7/00 1:54:33 PM ******/
CREATE TABLE root.Test (
	TestNo smallint NOT NULL ,
	TestAcronym varchar (15) NOT NULL ,
	TestName varchar (50) NOT NULL ,
	TestClass char (10) NOT NULL ,
	TestStartDate datetime NOT NULL ,
	TestEndDate datetime NOT NULL ,
	InstrumentedTest char (1) NOT NULL ,
	TestOffStation char (1) NOT NULL ,
	TestLocation varchar (50) NULL ,
	TestLeadDays smallint NOT NULL ,
	TestRecoveryDays smallint NOT NULL 
)
GO

/****** Object:  Table root.TestClass    Script Date: 3/7/00 1:54:33 PM ******/
CREATE TABLE root.TestClass (
	Class char (10) NOT NULL ,
	Priority tinyint NOT NULL ,
	ClassDesc varchar (60) NULL 
)
GO

/****** Object:  Table root.TestOTP    Script Date: 3/7/00 1:54:33 PM ******/
CREATE TABLE root.TestOTP (
	TestNo smallint NOT NULL ,
	OTPNo varchar (20) NOT NULL 
)
GO

/****** Object:  Table root.TestType    Script Date: 3/7/00 1:54:33 PM ******/
CREATE TABLE root.TestType (
	TestType varchar (25) NOT NULL 
)
GO

/****** Object:  Table root.TestWAO    Script Date: 3/7/00 1:54:34 PM ******/
CREATE TABLE root.TestWAO (
	TestNo smallint NOT NULL ,
	WAONo varchar (10) NOT NULL ,
	SystemsEngEmpNo char (9) NULL ,
	FieldOpsEmpNo char (9) NULL 
)
GO

/****** Object:  Table root.TransBuildListDetail    Script Date: 3/7/00 1:54:34 PM ******/
CREATE TABLE root.TransBuildListDetail (
	BuildListNo smallint NOT NULL ,
	RecordNo int NOT NULL ,
	TSCSerialNo varchar (15) NULL ,
	MFGSerialNo varchar (15) NULL ,
	Quantity smallint NOT NULL ,
	InvRecordNo int NULL 
)
GO

 CREATE  INDEX TransBuildListDetail_key ON root.TransBuildListDetail(BuildListNo, RecordNo)
GO

/****** Object:  Table root.TransBuildListHeader    Script Date: 3/7/00 1:54:34 PM ******/
CREATE TABLE root.TransBuildListHeader (
	BuildListNo smallint NOT NULL ,
	CreateDate datetime NOT NULL ,
	FormType char (15) NOT NULL ,
	TempIssue char (1) NOT NULL ,
	TestIssue char (1) NOT NULL ,
	TestNo smallint NULL ,
	IssueByName varchar (25) NOT NULL ,
	IssueByEmpNo char (9) NOT NULL ,
	IssueToName varchar (25) NULL ,
	IssueToEmpNo char (9) NULL ,
	WorkRequestNo char (15) NULL ,
	PhaseNo char (6) NULL ,
	ExpectReturnDate datetime NOT NULL ,
	OffStation char (1) NOT NULL ,
	WAONo varchar (10) NULL ,
	WarehouseCode tinyint NOT NULL ,
	Location varchar (25) NULL ,
	RSTIssue char (1) NOT NULL 
)
GO

/****** Object:  Table root.TransForm    Script Date: 3/7/00 1:54:34 PM ******/
CREATE TABLE root.TransForm (
	TransactionNo decimal(18, 0) NOT NULL ,
	FormNo decimal(18, 0) NOT NULL 
)
GO

/****** Object:  Table root.TransPBCode    Script Date: 3/7/00 1:54:34 PM ******/
CREATE TABLE root.TransPBCode (
	TransactionNo decimal(18, 0) NOT NULL ,
	PBCode tinyint NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX TransPBCode_key ON root.TransPBCode(TransactionNo, PBCode)
GO

/****** Object:  Table root.TransProp    Script Date: 3/7/00 1:54:34 PM ******/
CREATE TABLE root.TransProp (
	TransactionNo decimal(18, 0) NOT NULL ,
	PropTransNo decimal(18, 0) NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX TransProp_key ON root.TransProp(TransactionNo, PropTransNo)
GO

/****** Object:  Table root.TransTest    Script Date: 3/7/00 1:54:34 PM ******/
CREATE TABLE root.TransTest (
	TransactionNo decimal(18, 0) NOT NULL ,
	TestNo smallint NOT NULL 
)
GO

/****** Object:  Table root.TransactionAction    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE root.TransactionAction (
	TransactionNo decimal(18, 0) NOT NULL ,
	ActionCode tinyint NOT NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX TransactionAction_key ON root.TransactionAction(TransactionNo, ActionCode)
GO

/****** Object:  Table root.TransactionLog    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE root.TransactionLog (
	TransactionNo decimal(18, 0) NOT NULL ,
	TransactionDate datetime NOT NULL ,
	PostEmpNo char (9) NOT NULL ,
	Remarks text NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX TransactionLog_key ON root.TransactionLog(TransactionNo)
GO

/****** Object:  Table root.UserAppAccess    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE root.UserAppAccess (
	EmployeeID char (15) NOT NULL ,
	AppID smallint NOT NULL 
)
GO

/****** Object:  Table root.UserLogin    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE root.UserLogin (
	EmployeeNo char (15) NOT NULL ,
	UserLogin char (25) NOT NULL 
)
GO

 CREATE  UNIQUE  INDEX userlogin_key ON root.UserLogin(EmployeeNo)
GO

/****** Object:  Table root.Warehouse    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE root.Warehouse (
	WarehouseCode tinyint NOT NULL ,
	WarehouseDesc varchar (20) NOT NULL ,
	WhsMgrEmpNo char (9) NOT NULL 
)
GO

/****** Object:  Table root.WarehouseSite    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE root.WarehouseSite (
	WarehouseCode tinyint NOT NULL ,
	SiteCode tinyint NOT NULL 
)
GO

/****** Object:  Table dbo.pbcatcol    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE dbo.pbcatcol (
	pbc_tnam char (30) NULL ,
	pbc_tid int NULL ,
	pbc_ownr char (30) NULL ,
	pbc_cnam char (30) NULL ,
	pbc_cid smallint NULL ,
	pbc_labl varchar (254) NULL ,
	pbc_lpos smallint NULL ,
	pbc_hdr varchar (254) NULL ,
	pbc_hpos smallint NULL ,
	pbc_jtfy smallint NULL ,
	pbc_mask varchar (31) NULL ,
	pbc_case smallint NULL ,
	pbc_hght smallint NULL ,
	pbc_wdth smallint NULL ,
	pbc_ptrn varchar (31) NULL ,
	pbc_bmap char (1) NULL ,
	pbc_init varchar (254) NULL ,
	pbc_cmnt varchar (254) NULL ,
	pbc_edit varchar (31) NULL ,
	pbc_tag varchar (254) NULL 
)
GO

 CREATE  UNIQUE  INDEX pbcatcol_idx ON dbo.pbcatcol(pbc_tnam, pbc_ownr, pbc_cnam)
GO

/****** Object:  Table dbo.pbcatedt    Script Date: 3/7/00 1:54:35 PM ******/
CREATE TABLE dbo.pbcatedt (
	pbe_name varchar (30) NOT NULL ,
	pbe_edit varchar (254) NULL ,
	pbe_type smallint NOT NULL ,
	pbe_cntr int NULL ,
	pbe_seqn smallint NOT NULL ,
	pbe_flag int NULL ,
	pbe_work char (32) NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX pbcatedt_idx ON dbo.pbcatedt(pbe_name, pbe_seqn)
GO

/****** Object:  Table dbo.pbcatfmt    Script Date: 3/7/00 1:54:36 PM ******/
CREATE TABLE dbo.pbcatfmt (
	pbf_name varchar (30) NOT NULL ,
	pbf_frmt varchar (254) NOT NULL ,
	pbf_type smallint NOT NULL ,
	pbf_cntr int NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX pbcatfmt_idx ON dbo.pbcatfmt(pbf_name)
GO

/****** Object:  Table dbo.pbcattbl    Script Date: 3/7/00 1:54:36 PM ******/
CREATE TABLE dbo.pbcattbl (
	pbt_tnam char (30) NULL ,
	pbt_tid int NULL ,
	pbt_ownr char (30) NULL ,
	pbd_fhgt smallint NULL ,
	pbd_fwgt smallint NULL ,
	pbd_fitl char (1) NULL ,
	pbd_funl char (1) NULL ,
	pbd_fchr smallint NULL ,
	pbd_fptc smallint NULL ,
	pbd_ffce char (32) NULL ,
	pbh_fhgt smallint NULL ,
	pbh_fwgt smallint NULL ,
	pbh_fitl char (1) NULL ,
	pbh_funl char (1) NULL ,
	pbh_fchr smallint NULL ,
	pbh_fptc smallint NULL ,
	pbh_ffce char (32) NULL ,
	pbl_fhgt smallint NULL ,
	pbl_fwgt smallint NULL ,
	pbl_fitl char (1) NULL ,
	pbl_funl char (1) NULL ,
	pbl_fchr smallint NULL ,
	pbl_fptc smallint NULL ,
	pbl_ffce char (32) NULL ,
	pbt_cmnt varchar (254) NULL 
)
GO

 CREATE  UNIQUE  INDEX pbcattbl_idx ON dbo.pbcattbl(pbt_tnam, pbt_ownr)
GO

/****** Object:  Table dbo.pbcatvld    Script Date: 3/7/00 1:54:36 PM ******/
CREATE TABLE dbo.pbcatvld (
	pbv_name varchar (30) NOT NULL ,
	pbv_vald varchar (254) NOT NULL ,
	pbv_type smallint NOT NULL ,
	pbv_cntr int NULL ,
	pbv_msg varchar (254) NULL 
)
GO

 CREATE  UNIQUE  CLUSTERED  INDEX pbcatvld_idx ON dbo.pbcatvld(pbv_name)
GO

/****** Object:  View root.PT35_TRACK2_VIEW    Script Date: 3/7/00 1:54:36 PM ******/
setuser 'root'
GO

CREATE VIEW PT35_TRACK2_VIEW AS SELECT PT35_TRACK2.*, PT35_MODULE.NAME MODULE_NAME, v1.NAME VERSION1_NAME, v2.NAME VERSION2_NAME FROM PT35_TRACK2 LEFT OUTER JOIN PT35_MODULE ON PT35_TRACK2.MODULE_ID = PT35_MODULE.MODULE_ID LEFT OUTER JOIN PT35_VERSION v1 ON PT35_TRACK2.VERSION1_ID = v1.VERSION_ID LEFT OUTER JOIN PT35_VERSION v2 ON PT35_TRACK2.VERSION2_ID = v2.VERSION_ID 
GO

setuser
GO

/****** Object:  View root.PT35_TRACK_VIEW    Script Date: 3/7/00 1:54:36 PM ******/
setuser 'root'
GO

CREATE VIEW PT35_TRACK_VIEW AS SELECT PT35_TRACK.*, PT35_MODULE.NAME MODULE_NAME, v1.NAME VERSION1_NAME, v2.NAME VERSION2_NAME, PT35_USER.SERIAL_NUM SERIAL_NUM, PT35_USER.COMPANY COMPANY FROM PT35_TRACK LEFT OUTER JOIN PT35_MODULE ON PT35_TRACK.MODULE_ID = PT35_MODULE.MODULE_ID LEFT OUTER JOIN PT35_VERSION v1 ON PT35_TRACK.VERSION1_ID = v1.VERSION_ID LEFT OUTER JOIN PT35_VERSION v2 ON PT35_TRACK.VERSION2_ID = v2.VERSION_ID LEFT OUTER JOIN PT35_USER ON PT35_TRACK.SUBMITTED_BY = PT35_USER.USER_ID 
GO

setuser
GO

/****** Object:  Stored Procedure root.GetFormNo    Script Date: 3/7/00 1:54:36 PM ******/
setuser 'root'
GO


/* The following code creates stored procedures that control unique record number
   creation and access.
*/

/* Create stored procedure GetFormNo that controls creation of unique 
   FormNo.s
*/

create procedure GetFormNo

as

declare @LastFormNo int
declare @Today datetime

select @Today = getdate()
select @LastFormNo = (select FormNo from LastFormNo (TabLock))
if @LastFormNo = null
  select @LastFormNo = 1
else
  select @LastFormNo = @LastFormNo + 1
update LastFormNo set FormNo = @LastFormNo, 
                    LastUpDate = @Today
from LastFormNo (TabLockX)

select @LastFormNo


GO

setuser
GO

/****** Object:  Stored Procedure root.GetInvRecordNo    Script Date: 3/7/00 1:54:36 PM ******/
setuser 'root'
GO



/* Create stored procedure GetInvRecordNo that controls creation of unique 
   InvRecordNo.s
*/

create procedure GetInvRecordNo

as

declare @LastInvRecordNo int
declare @Today datetime

select @Today = getdate()
select @LastInvRecordNo = (select InvRecordNo from LastInvRecordNo (TabLock)) + 1
update LastInvRecordNo set InvRecordNo = @LastInvRecordNo, 
                    LastUpDate = @Today
from LastInvRecordNo (TabLockX)

select @LastInvRecordNo



GO

setuser
GO

/****** Object:  Stored Procedure root.GetNextStockNo    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

create procedure GetNextStockNo @FSC char(4) 

as

declare @seqno char(4)
declare @stockno char(16)
declare @exists tinyint

select @seqno = null

select @seqno = SeqNo
from LastStockNo
where FSC = @FSC

if @@rowcount = 0
  begin
    select @seqno = "0001"
    insert into LastStockNo
    values (@FSC, @seqno)
  end
else
  begin
    select @seqno = convert(char(4),convert(int,@seqno) + 1)
    if convert(int,@seqno) < 10
      select @seqno = "000" + @seqno
    else if convert(int,@seqno) < 100
      select @seqno = "00" + @seqno
    else if convert(int,@seqno) < 1000
      select @seqno = "0" + @seqno
    select @exists = 0
    while (@exists = 0)
      begin
        select @stockno = stockno 
        from property 
        where stockno = @FSC + "-01-Z33-" + @seqno
        if @@rowcount = 0
          begin
            update LastStockNo
            set SeqNo = @seqno
            where FSC = @FSC
            select @exists = 1
          end
        else
          begin          
            select @seqno = convert(char(4),convert(int,@seqno) + 1)
            if convert(int,@seqno) < 10
              select @seqno = "000" + @seqno
            else if convert(int,@seqno) < 100
              select @seqno = "00" + @seqno
            else if convert(int,@seqno) < 1000
              select @seqno = "0" + @seqno
          end
       end
    end
select @stockno = @FSC + "-01-Z33-" + @seqno
select @stockno


GO

setuser
GO

/****** Object:  Stored Procedure root.GetRecordNo    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO


/* Create stored procedure GetRecordNo that controls creation of unique 
   RecordNo.s
*/

create procedure GetRecordNo

as

declare @LastRecordNo int
declare @Today datetime

select @Today = getdate()
select @LastRecordNo = (select RecordNo from LastPropRecordNo (TabLock)) + 1
update LastPropRecordNo set RecordNo = @LastRecordNo, 
                    LastUpDate = @Today
from LastPropRecordNo (TabLockX)

select @LastRecordNo


GO

setuser
GO

/****** Object:  Stored Procedure root.GetTestNo    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

create procedure GetTestNo

as

declare @LastTestNo smallint
declare @Today datetime

select @Today = getdate()
select @LastTestNo = (select TestNo from LastTestNo (TabLock))
if @LastTestNo = null
  select @LastTestNo = 1
else
  select @LastTestNo = @LastTestNo + 1
update LastTestNo set TestNo = @LastTestNo, 
                    LastUpDate = @Today
from LastTestNo (TabLockX)

select @LastTestNo


GO

setuser
GO

/****** Object:  Stored Procedure root.GetTransaction    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

create procedure GetTransaction

as

declare @LastTransaction decimal
declare @Today datetime
declare @SiteCode decimal
declare @LastBase smallint
declare @Year decimal
declare @Month int
declare @Day int

select @Today = getdate()
select @SiteCode = 10*1000000000000
select @Year = datepart(year,@Today)*1000000
select @Year = @Year * 100
select @Month = datepart(month,@Today)*1000000
select @Day = datepart(day,@Today)*10000
select @LastBase = (select LastBase from LastTransaction (TabLock)) + 1
if @LastBase = null
  select @LastBase = 0
select @LastTransaction = @SiteCode + @Year + @Month + @Day + @LastBase
update LastTransaction set LastTransaction = @LastTransaction, 
                    LastBase = @LastBase,
                    LastDate = @Today
from LastTransaction (TabLockX)

select @LastTransaction


GO

setuser
GO

/****** Object:  Stored Procedure root.update_all_stats    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE PROCEDURE update_all_stats
AS
/*
	This procedure will run UPDATE STATISTICS against
	all user-defined tables within this database.
*/
DECLARE @tablename varchar(30)
DECLARE @tablename_header varchar(75)
DECLARE tnames_cursor CURSOR FOR SELECT name FROM sysobjects 
	WHERE type = 'U'
OPEN tnames_cursor
FETCH NEXT FROM tnames_cursor INTO @tablename
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		SELECT @tablename_header = "Updating " + 
			RTRIM(UPPER(@tablename))
		PRINT @tablename_header
		EXEC ("UPDATE STATISTICS " + @tablename )
	END
	FETCH NEXT FROM tnames_cursor INTO @tablename
END
PRINT " "
PRINT " "
SELECT @tablename_header = "*************  NO MORE TABLES"
			+ "  *************" 
PRINT @tablename_header

PRINT " "
PRINT "Statistics have been updated for all tables."
DEALLOCATE tnames_cursor


GO

setuser
GO

/****** Object:  Trigger root.PT35_ASSET_ITrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_ASSET_ITrig ON PT35_ASSET FOR INSERT AS
BEGIN
    -- prevent inserts if no matching key in PT35_USER but allow NULL
    IF (SELECT Count(*) FROM inserted 
        WHERE inserted.AS_USED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.AS_USED_BY)
    BEGIN
        RAISERROR('The AS_USED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_ASSET_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_ASSET_UTrig ON PT35_ASSET FOR UPDATE AS
BEGIN
    -- prevent updates if no matching key in PT35_USER but allow NULL
    IF UPDATE(AS_USED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.AS_USED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.AS_USED_BY)
    BEGIN
        RAISERROR('The AS_USED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_ATTACHED_ITrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_ATTACHED_ITrig ON PT35_ATTACHED FOR INSERT AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK
        WHERE PT35_TRACK.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_ATTACHED_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_ATTACHED_UTrig ON PT35_ATTACHED FOR UPDATE AS
BEGIN
    IF UPDATE(TRACKING_ID) 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK 
        WHERE PT35_TRACK.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_ATTACHED2_ITrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_ATTACHED2_ITrig ON PT35_ATTACHED2 FOR INSERT AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK2
        WHERE PT35_TRACK2.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_ATTACHED2_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_ATTACHED2_UTrig ON PT35_ATTACHED2 FOR UPDATE AS
BEGIN
    IF UPDATE(TRACKING_ID) 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK2 
        WHERE PT35_TRACK2.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_CHANGE_ITrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_CHANGE_ITrig ON PT35_CHANGE FOR INSERT AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK
        WHERE PT35_TRACK.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_CHANGE_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_CHANGE_UTrig ON PT35_CHANGE FOR UPDATE AS
BEGIN
    IF UPDATE(TRACKING_ID) 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK 
        WHERE PT35_TRACK.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_CHANGE2_ITrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_CHANGE2_ITrig ON PT35_CHANGE2 FOR INSERT AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK2
        WHERE PT35_TRACK2.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_CHANGE2_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_CHANGE2_UTrig ON PT35_CHANGE2 FOR UPDATE AS
BEGIN
    IF UPDATE(TRACKING_ID) 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_TRACK2 
        WHERE PT35_TRACK2.TRACKING_ID = inserted.TRACKING_ID)
    BEGIN
        RAISERROR('The tracking record does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_DOC_ITrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_DOC_ITrig ON PT35_DOC FOR INSERT AS
BEGIN
    -- Prevent inserts if no matching key in PT35_PRODUCT but allow NULL
    -- Works with single row insert. 
    -- Won't work with INSERT INTO table SELECT ...
    IF (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_PRODUCT, inserted 
        WHERE PT35_PRODUCT.NAME = inserted.DOC_PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    -- prevent inserts if no matching key in PT35_USER but allow NULL 
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_OWNER IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_OWNER)
    BEGIN
        RAISERROR('The DOC_OWNER does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_CREATED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_CREATED_BY)
    BEGIN
        RAISERROR('The DOC_CREATED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_UPDATED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_UPDATED_BY)
    BEGIN
        RAISERROR('The DOC_UPDATED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_LOCKED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_LOCKED_BY)
    BEGIN
        RAISERROR('The DOC_LOCKED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_DOC_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_DOC_UTrig ON PT35_DOC FOR UPDATE AS
BEGIN
    -- prevent updates if no matching key in PT35_PRODUCT but allow NULL
    IF UPDATE(DOC_PRODUCT) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_PRODUCT, inserted 
        WHERE PT35_PRODUCT.NAME = inserted.DOC_PRODUCT)
    BEGIN
        RAISERROR('The DOC_PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    -- prevent updates if no matching key in PT35_USER but allow NULL
    ELSE IF UPDATE(DOC_OWNER) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_OWNER IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_OWNER)
    BEGIN
        RAISERROR('The DOC_OWNER does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(DOC_CREATED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_CREATED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_CREATED_BY)
    BEGIN
        RAISERROR('The DOC_CREATED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(DOC_UPDATED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_UPDATED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_UPDATED_BY)
    BEGIN
        RAISERROR('The DOC_UPDATED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(DOC_LOCKED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.DOC_LOCKED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.DOC_LOCKED_BY)
    BEGIN
        RAISERROR('The DOC_LOCKED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_MODULE_ITrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_MODULE_ITrig ON PT35_MODULE FOR INSERT AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_MODULE_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_MODULE_UTrig ON PT35_MODULE FOR UPDATE AS
BEGIN
    IF UPDATE(PRODUCT) AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(MODULE_ID)
    BEGIN
        UPDATE PT35_TRACK 
        SET PT35_TRACK.MODULE_ID = inserted.MODULE_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.MODULE_ID = deleted.MODULE_ID 

        UPDATE PT35_TRACK2 
        SET PT35_TRACK2.MODULE_ID = inserted.MODULE_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.MODULE_ID = deleted.MODULE_ID
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_MODULE_DTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_MODULE_DTrig ON PT35_MODULE FOR DELETE AS
BEGIN
    UPDATE PT35_TRACK SET MODULE_ID = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.MODULE_ID = deleted.MODULE_ID

    UPDATE PT35_TRACK2 SET MODULE_ID = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.MODULE_ID = deleted.MODULE_ID
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PRIORITY_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PRIORITY_UTrig ON PT35_PRIORITY FOR UPDATE AS
BEGIN
    IF UPDATE(NAME)
    BEGIN
       UPDATE PT35_TRACK SET PT35_TRACK.PRIORITY = inserted.NAME
       FROM deleted, inserted, PT35_TRACK
       WHERE PT35_TRACK.PRIORITY = deleted.NAME
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PRIORITY_DTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PRIORITY_DTrig ON PT35_PRIORITY FOR DELETE AS
BEGIN
   UPDATE PT35_TRACK SET PT35_TRACK.PRIORITY = NULL
   FROM deleted, PT35_TRACK
   WHERE PT35_TRACK.PRIORITY = deleted.NAME
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PRIORITY2_UTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PRIORITY2_UTrig ON PT35_PRIORITY2 FOR UPDATE AS
BEGIN
    IF UPDATE(NAME)
    BEGIN
       UPDATE PT35_TRACK2 SET PT35_TRACK2.PRIORITY = inserted.NAME
       FROM deleted, inserted, PT35_TRACK2
       WHERE PT35_TRACK2.PRIORITY = deleted.NAME
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PRIORITY2_DTrig    Script Date: 3/7/00 1:54:37 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PRIORITY2_DTrig ON PT35_PRIORITY2 FOR DELETE AS
BEGIN
   UPDATE PT35_TRACK2 SET PT35_TRACK2.PRIORITY = NULL
   FROM deleted, PT35_TRACK2
   WHERE PT35_TRACK2.PRIORITY = deleted.NAME
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PRODUCT_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PRODUCT_UTrig ON PT35_PRODUCT FOR UPDATE AS
BEGIN
    IF UPDATE(NAME)
    BEGIN
        -- The FROM clause is a T-SQL extension to specifies
        -- additional tables to be used in the statement
        UPDATE PT35_TRACK 
        SET PT35_TRACK.PRODUCT = inserted.NAME
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.PRODUCT = deleted.NAME

        UPDATE PT35_TRACK2 
        SET PT35_TRACK2.PRODUCT = inserted.NAME
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.PRODUCT = deleted.NAME

        UPDATE PT35_MODULE 
        SET PT35_MODULE.PRODUCT = inserted.NAME
        FROM deleted, inserted, PT35_MODULE
        WHERE PT35_MODULE.PRODUCT = deleted.NAME

        UPDATE PT35_VERSION 
        SET PT35_VERSION.PRODUCT = inserted.NAME
        FROM deleted, inserted, PT35_VERSION 
        WHERE PT35_VERSION.PRODUCT = deleted.NAME

        UPDATE PT35_PROD_USER 
        SET PT35_PROD_USER.PRODUCT = inserted.NAME
        FROM deleted, inserted, PT35_PROD_USER
        WHERE PT35_PROD_USER.PRODUCT = deleted.NAME

        UPDATE PT35_DOC 
        SET PT35_DOC.DOC_PRODUCT = inserted.NAME
        FROM deleted, inserted, PT35_DOC
        WHERE PT35_DOC.DOC_PRODUCT = deleted.NAME

        UPDATE PT35_QUERY 
        SET PT35_QUERY.PRODUCT = inserted.NAME
        FROM deleted, inserted, PT35_QUERY
        WHERE PT35_QUERY.PRODUCT = deleted.NAME
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PRODUCT_DTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PRODUCT_DTrig ON PT35_PRODUCT FOR DELETE AS
BEGIN
    UPDATE PT35_TRACK SET PRODUCT = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.PRODUCT = deleted.NAME

    UPDATE PT35_TRACK2 SET PRODUCT = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.PRODUCT = deleted.NAME

    UPDATE PT35_DOC SET DOC_PRODUCT = NULL
    FROM deleted, PT35_DOC
    WHERE PT35_DOC.DOC_PRODUCT = deleted.NAME

    -- The FROM clause is a T-SQL extension to specifies
    -- additional tables to be used in the statement
    DELETE PT35_MODULE FROM deleted, PT35_MODULE 
    WHERE PT35_MODULE.PRODUCT = deleted.NAME

    DELETE PT35_VERSION FROM deleted, PT35_VERSION 
    WHERE PT35_VERSION.PRODUCT = deleted.NAME

    DELETE PT35_PROD_USER FROM deleted, PT35_PROD_USER 
    WHERE PT35_PROD_USER.PRODUCT = deleted.NAME

    DELETE PT35_QUERY FROM deleted, PT35_QUERY
    WHERE PT35_QUERY.PRODUCT = deleted.NAME
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PROD_USER_ITrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PROD_USER_ITrig ON PT35_PROD_USER FOR INSERT AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_PRODUCT, inserted 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.USER_ID)
    BEGIN
        RAISERROR('The USER does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_PROD_USER_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_PROD_USER_UTrig ON PT35_PROD_USER FOR UPDATE AS
BEGIN
    IF UPDATE(PRODUCT) AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_PRODUCT, inserted 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(USER_ID) AND 
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_USER, inserted 
        WHERE PT35_USER.USER_ID = inserted.USER_ID)
    BEGIN
        RAISERROR('The USER does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_QUERY_ITrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_QUERY_ITrig ON PT35_QUERY FOR INSERT AS
BEGIN
    -- prevent inserts if no matching key in PT35_PRODUCT but allow NULL
    IF (SELECT Count(*) FROM inserted 
        WHERE inserted.PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_PRODUCT, inserted 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_QUERY_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_QUERY_UTrig ON PT35_QUERY FOR UPDATE AS
BEGIN
    -- prevent updates if no matching key in PT35_PRODUCT but allow NULL
    IF UPDATE(PRODUCT) AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM PT35_PRODUCT, inserted 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_STATUS_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_STATUS_UTrig ON PT35_STATUS FOR UPDATE AS
BEGIN
    IF UPDATE(NAME)
    BEGIN
       UPDATE PT35_TRACK SET PT35_TRACK.STATUS = inserted.NAME
       FROM deleted, inserted, PT35_TRACK
       WHERE PT35_TRACK.STATUS = deleted.NAME
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_STATUS_DTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_STATUS_DTrig ON PT35_STATUS FOR DELETE AS
BEGIN
   UPDATE PT35_TRACK SET PT35_TRACK.STATUS = NULL
   FROM deleted, PT35_TRACK
   WHERE PT35_TRACK.STATUS = deleted.NAME
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_STATUS2_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_STATUS2_UTrig ON PT35_STATUS2 FOR UPDATE AS
BEGIN
    IF UPDATE(NAME)
    BEGIN
       UPDATE PT35_TRACK2 SET PT35_TRACK2.STATUS = inserted.NAME
       FROM deleted, inserted, PT35_TRACK2
       WHERE PT35_TRACK2.STATUS = deleted.NAME
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_STATUS2_DTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_STATUS2_DTrig ON PT35_STATUS2 FOR DELETE AS
BEGIN
   UPDATE PT35_TRACK2 SET PT35_TRACK2.STATUS = NULL
   FROM deleted, PT35_TRACK2
   WHERE PT35_TRACK2.STATUS = deleted.NAME
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_TRACK_ITrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_TRACK_ITrig ON PT35_TRACK FOR INSERT AS
BEGIN
    -- Note: replacing if-else with if-if results in the second
    -- rollback to fail to find the matching begin transaction

    -- prevent inserts if no matching key in PT35_STATUS
    IF (SELECT Count(*) FROM inserted 
        WHERE inserted.STATUS IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_STATUS 
        WHERE PT35_STATUS.NAME = inserted.STATUS)
    BEGIN
        RAISERROR('The STATUS does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent inserts if no matching key in PT35_PRIORITY but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.PRIORITY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRIORITY 
        WHERE PT35_PRIORITY.NAME = inserted.PRIORITY)
    BEGIN
        RAISERROR('The PRIORITY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent inserts if no matching key in PT35_PRODUCT but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent inserts if no matching key in PT35_USER but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_TO)
    BEGIN
        RAISERROR('The SUBMITTED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_BY)
    BEGIN
        RAISERROR('The SUBMITTED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_TO)
    BEGIN
        RAISERROR('The ASSIGNED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_BY)
    BEGIN
        RAISERROR('The ASSIGNED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.RESOLVED_BY IS NULL) = 0 AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.RESOLVED_BY)
    BEGIN
        RAISERROR('The RESOLVED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.CLOSED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER
        WHERE PT35_USER.USER_ID = inserted.CLOSED_BY)
    BEGIN
        RAISERROR('The CLOSED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent inserts if no matching key in PT35_MODULE but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.MODULE_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_MODULE 
        WHERE PT35_MODULE.MODULE_ID = inserted.MODULE_ID)
    BEGIN
        RAISERROR('The MODULE_ID does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent inserts if no matching key in PT35_VERSION but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION1_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION 
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION1_ID)
    BEGIN
        RAISERROR('The VERSION1_ID does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION2_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION 
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION2_ID)
    BEGIN
        RAISERROR('The VERSION2_ID does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_TRACK_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_TRACK_UTrig ON PT35_TRACK FOR UPDATE AS
BEGIN
    -- prevent updates if no matching key in PT35_STATUS but allow NULL
    IF UPDATE(STATUS) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.STATUS IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_STATUS
        WHERE PT35_STATUS.NAME = inserted.STATUS)
    BEGIN
        RAISERROR('The STATUS does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent updates if no matching key in PT35_PRIORITY but allow NULL
    ELSE IF UPDATE(PRIORITY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.PRIORITY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRIORITY 
        WHERE PT35_PRIORITY.NAME = inserted.PRIORITY)
    BEGIN
        RAISERROR('The PRIORITY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent updates if no matching key in PT35_PRODUCT but allow NULL
    ELSE IF UPDATE(PRODUCT) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent updates if no matching key in PT35_USER but allow NULL
    ELSE IF UPDATE(SUBMITTED_TO) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_TO)
    BEGIN
        RAISERROR('The SUBMITTED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(SUBMITTED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_BY)
    BEGIN
        RAISERROR('The SUBMITTED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(ASSIGNED_TO) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_TO)
    BEGIN
        RAISERROR('The ASSIGNED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(ASSIGNED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_BY)
    BEGIN
        RAISERROR('The ASSIGNED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(RESOLVED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.RESOLVED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.RESOLVED_BY)
    BEGIN
        RAISERROR('The RESOLVED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(CLOSED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.CLOSED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.CLOSED_BY)
    BEGIN
        RAISERROR('The CLOSED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent updates if no matching key in PT35_MODULE but allow NULL
    ELSE IF UPDATE(MODULE_ID) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.MODULE_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_MODULE 
        WHERE PT35_MODULE.MODULE_ID = inserted.MODULE_ID)
    BEGIN
        RAISERROR('The MODULE does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent updates if no matching key in PT35_VERSION but allow NULL
    ELSE IF UPDATE(VERSION1_ID) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION1_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION1_ID)
    BEGIN
        RAISERROR('The VERSION does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(VERSION2_ID) AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION2_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION 
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION2_ID)
    BEGIN
        RAISERROR('The VERSION does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- cascade updates to PT35_ATTACHED and PT35_CHANGE
    ELSE IF UPDATE(TRACKING_ID)
    BEGIN
       UPDATE PT35_CHANGE
       SET PT35_CHANGE.TRACKING_ID = inserted.TRACKING_ID
       FROM deleted, inserted, PT35_CHANGE
       WHERE PT35_CHANGE.TRACKING_ID = deleted.TRACKING_ID

       UPDATE PT35_ATTACHED
       SET PT35_ATTACHED.TRACKING_ID = inserted.TRACKING_ID
       FROM deleted, inserted, PT35_ATTACHED
       WHERE PT35_ATTACHED.TRACKING_ID = deleted.TRACKING_ID
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_TRACK_DTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_TRACK_DTrig ON PT35_TRACK FOR DELETE AS
BEGIN
    DELETE PT35_CHANGE FROM deleted, PT35_CHANGE 
    WHERE PT35_CHANGE.TRACKING_ID = deleted.TRACKING_ID

    DELETE PT35_ATTACHED FROM deleted, PT35_ATTACHED 
    WHERE PT35_ATTACHED.TRACKING_ID = deleted.TRACKING_ID
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_TRACK2_ITrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_TRACK2_ITrig ON PT35_TRACK2 FOR INSERT AS
BEGIN
    -- prevent inserts if no matching key in PT35_STATUS2
    IF (SELECT Count(*) FROM inserted 
        WHERE inserted.STATUS IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_STATUS2 
        WHERE PT35_STATUS2.NAME = inserted.STATUS)
    BEGIN
        RAISERROR('The STATUS does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    -- prevent inserts if no matching key in PT35_PRIORITY2 but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.PRIORITY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRIORITY2
        WHERE PT35_PRIORITY2.NAME = inserted.PRIORITY)
    BEGIN
        RAISERROR('The PRIORITY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    -- prevent inserts if no matching key in PT35_PRODUCT but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    -- prevent inserts if no matching key in PT35_USER but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_TO)
    BEGIN
        RAISERROR('The SUBMITTED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_BY)
    BEGIN
        RAISERROR('The SUBMITTED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_TO)
    BEGIN
        RAISERROR('The ASSIGNED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_BY)
    BEGIN
        RAISERROR('The ASSIGNED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.RESOLVED_BY IS NULL) = 0 AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.RESOLVED_BY)
    BEGIN
        RAISERROR('The RESOLVED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.CLOSED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER
        WHERE PT35_USER.USER_ID = inserted.CLOSED_BY)
    BEGIN
        RAISERROR('The CLOSED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    -- prevent inserts if no matching key in PT35_MODULE but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.MODULE_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_MODULE 
        WHERE PT35_MODULE.MODULE_ID = inserted.MODULE_ID)
    BEGIN
        RAISERROR('The MODULE_ID does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent inserts if no matching key in PT35_VERSION but allow NULL
    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION1_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION 
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION1_ID)
    BEGIN
        RAISERROR('The VERSION1_ID does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION2_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION 
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION2_ID)
    BEGIN
        RAISERROR('The VERSION2_ID does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_TRACK2_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_TRACK2_UTrig ON PT35_TRACK2 FOR UPDATE AS
BEGIN
    -- prevent updates if no matching key in PT35_STATUS2 but allow NULL
    IF UPDATE(STATUS) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.STATUS IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_STATUS2
        WHERE PT35_STATUS2.NAME = inserted.STATUS)
    BEGIN
        RAISERROR('The STATUS does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- prevent updates if no matching key in PT35_PRIORITY2 but allow NULL
    ELSE IF UPDATE(PRIORITY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.PRIORITY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRIORITY2 
        WHERE PT35_PRIORITY2.NAME = inserted.PRIORITY)
    BEGIN
        RAISERROR('The PRIORITY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    -- prevent updates if no matching key in PT35_PRODUCT but allow NULL
    ELSE IF UPDATE(PRODUCT) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.PRODUCT IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    -- prevent updates if no matching key in PT35_USER but allow NULL
    ELSE IF UPDATE(SUBMITTED_TO) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_TO)
    BEGIN
        RAISERROR('The SUBMITTED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF UPDATE(SUBMITTED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.SUBMITTED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.SUBMITTED_BY)
    BEGIN
        RAISERROR('The SUBMITTED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF UPDATE(ASSIGNED_TO) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_TO IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_TO)
    BEGIN
        RAISERROR('The ASSIGNED_TO does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    ELSE IF UPDATE(ASSIGNED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.ASSIGNED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.ASSIGNED_BY)
    BEGIN
        RAISERROR('The ASSIGNED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    ELSE IF UPDATE(RESOLVED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.RESOLVED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.RESOLVED_BY)
    BEGIN
        RAISERROR('The RESOLVED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    ELSE IF UPDATE(CLOSED_BY) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.CLOSED_BY IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_USER 
        WHERE PT35_USER.USER_ID = inserted.CLOSED_BY)
    BEGIN
        RAISERROR('The CLOSED_BY does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    -- prevent updates if no matching key in PT35_MODULE but allow NULL
    ELSE IF UPDATE(MODULE_ID) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.MODULE_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_MODULE 
        WHERE PT35_MODULE.MODULE_ID = inserted.MODULE_ID)
    BEGIN
        RAISERROR('The MODULE does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    -- prevent updates if no matching key in PT35_VERSION but allow NULL
    ELSE IF UPDATE(VERSION1_ID) 
    AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION1_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION1_ID)
    BEGIN
        RAISERROR('The VERSION does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    
    ELSE IF UPDATE(VERSION2_ID) AND
        (SELECT Count(*) FROM inserted 
        WHERE inserted.VERSION2_ID IS NULL) = 0 
    AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_VERSION 
        WHERE PT35_VERSION.VERSION_ID = inserted.VERSION2_ID)
    BEGIN
        RAISERROR('The VERSION does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END

    -- cascade updates to PT35_CHANGE2 and PT35_ATTACHED2 
    ELSE IF UPDATE(TRACKING_ID)
    BEGIN
       UPDATE PT35_CHANGE2
       SET PT35_CHANGE2.TRACKING_ID = inserted.TRACKING_ID
       FROM deleted, inserted, PT35_CHANGE2
       WHERE PT35_CHANGE2.TRACKING_ID = deleted.TRACKING_ID

       UPDATE PT35_ATTACHED2
       SET PT35_ATTACHED2.TRACKING_ID = inserted.TRACKING_ID
       FROM deleted, inserted, PT35_ATTACHED2
       WHERE PT35_ATTACHED2.TRACKING_ID = deleted.TRACKING_ID
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_TRACK2_DTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_TRACK2_DTrig ON PT35_TRACK2 FOR DELETE AS
BEGIN
    DELETE PT35_CHANGE2 FROM deleted, PT35_CHANGE2 
    WHERE PT35_CHANGE2.TRACKING_ID = deleted.TRACKING_ID

    DELETE PT35_ATTACHED2 FROM deleted, PT35_ATTACHED2 
    WHERE PT35_ATTACHED2.TRACKING_ID = deleted.TRACKING_ID
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_USER_UTrig    Script Date: 3/7/00 1:54:38 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_USER_UTrig ON PT35_USER FOR UPDATE AS
BEGIN
    IF UPDATE(USER_ID)
    BEGIN
        /* cascade updates to 'pt35_track' */
        UPDATE PT35_TRACK
        SET PT35_TRACK.SUBMITTED_TO = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.SUBMITTED_TO = deleted.USER_ID
 
        UPDATE PT35_TRACK
        SET PT35_TRACK.SUBMITTED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.SUBMITTED_BY = deleted.USER_ID

        UPDATE PT35_TRACK
        SET PT35_TRACK.ASSIGNED_TO = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.ASSIGNED_TO = deleted.USER_ID
 
        UPDATE PT35_TRACK
        SET PT35_TRACK.ASSIGNED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.ASSIGNED_BY = deleted.USER_ID

        UPDATE PT35_TRACK
        SET PT35_TRACK.RESOLVED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.RESOLVED_BY = deleted.USER_ID

        UPDATE PT35_TRACK
        SET PT35_TRACK.CLOSED_BY = inserted.USER_ID
        FROM PT35_TRACK, deleted, inserted
        WHERE PT35_TRACK.CLOSED_BY = deleted.USER_ID

        /* cascade updates to 'pt35_track2' */
        UPDATE PT35_TRACK2
        SET PT35_TRACK2.SUBMITTED_TO = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.SUBMITTED_TO = deleted.USER_ID

        UPDATE PT35_TRACK2
        SET PT35_TRACK2.SUBMITTED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.SUBMITTED_BY = deleted.USER_ID

        UPDATE PT35_TRACK2
        SET PT35_TRACK2.ASSIGNED_TO = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.ASSIGNED_TO = deleted.USER_ID

        UPDATE PT35_TRACK2
        SET PT35_TRACK2.ASSIGNED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.ASSIGNED_BY = deleted.USER_ID

        UPDATE PT35_TRACK2
        SET PT35_TRACK2.RESOLVED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.RESOLVED_BY = deleted.USER_ID

        UPDATE PT35_TRACK2
        SET PT35_TRACK2.CLOSED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.CLOSED_BY = deleted.USER_ID

        /* cascade updates to 'pt35_prod_user' */
        UPDATE PT35_PROD_USER
        SET PT35_PROD_USER.USER_ID = inserted.USER_ID
        FROM deleted, inserted, PT35_PROD_USER
        WHERE PT35_PROD_USER.USER_ID = deleted.USER_ID

        /* cascade updates to 'pt35_doc' */
        UPDATE PT35_DOC
        SET PT35_DOC.DOC_OWNER = inserted.USER_ID
        FROM deleted, inserted, PT35_DOC
        WHERE PT35_DOC.DOC_OWNER = deleted.USER_ID

        UPDATE PT35_DOC
        SET PT35_DOC.DOC_CREATED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_DOC
        WHERE PT35_DOC.DOC_CREATED_BY = deleted.USER_ID

        UPDATE PT35_DOC
        SET PT35_DOC.DOC_UPDATED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_DOC
        WHERE PT35_DOC.DOC_UPDATED_BY = deleted.USER_ID 

        UPDATE PT35_DOC
        SET PT35_DOC.DOC_LOCKED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_DOC
        WHERE PT35_DOC.DOC_LOCKED_BY = deleted.USER_ID

        /* cascade updates to 'pt35_asset' */
        UPDATE PT35_ASSET
        SET PT35_ASSET.AS_USED_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_ASSET
        WHERE PT35_ASSET.AS_USED_BY = deleted.USER_ID

        /* cascade updates to 'pt35_change and change2' */
        UPDATE PT35_CHANGE
        SET PT35_CHANGE.MADE_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_CHANGE
        WHERE PT35_CHANGE.MADE_BY = deleted.USER_ID

        UPDATE PT35_CHANGE2
        SET PT35_CHANGE2.MADE_BY = inserted.USER_ID
        FROM deleted, inserted, PT35_CHANGE2
        WHERE PT35_CHANGE2.MADE_BY = deleted.USER_ID
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_USER_DTrig    Script Date: 3/7/00 1:54:39 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_USER_DTrig ON PT35_USER FOR DELETE AS
BEGIN
    -- cascade set null to PT35_TRACK
    UPDATE PT35_TRACK SET SUBMITTED_TO = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.SUBMITTED_TO = deleted.USER_ID

    UPDATE PT35_TRACK SET SUBMITTED_BY = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.SUBMITTED_BY = deleted.USER_ID

    UPDATE PT35_TRACK SET ASSIGNED_TO = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.ASSIGNED_TO = deleted.USER_ID

    UPDATE PT35_TRACK SET ASSIGNED_BY = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.ASSIGNED_BY = deleted.USER_ID

    UPDATE PT35_TRACK SET RESOLVED_BY = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.RESOLVED_BY = deleted.USER_ID

    UPDATE PT35_TRACK SET CLOSED_BY = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.CLOSED_BY = deleted.USER_ID

    -- cascade set null to PT35_TRACK2
    UPDATE PT35_TRACK2 SET SUBMITTED_TO = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.SUBMITTED_TO = deleted.USER_ID

    UPDATE PT35_TRACK2 SET SUBMITTED_BY = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.SUBMITTED_BY = deleted.USER_ID

    UPDATE PT35_TRACK2 SET ASSIGNED_TO = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.ASSIGNED_TO = deleted.USER_ID

    UPDATE PT35_TRACK2 SET ASSIGNED_BY = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.ASSIGNED_BY = deleted.USER_ID

    UPDATE PT35_TRACK2 SET RESOLVED_BY = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.RESOLVED_BY = deleted.USER_ID

    UPDATE PT35_TRACK2 SET CLOSED_BY = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.CLOSED_BY = deleted.USER_ID

    -- cascade set null to PT35_DOC
    UPDATE PT35_DOC SET DOC_OWNER = NULL
    FROM deleted, PT35_DOC
    WHERE PT35_DOC.DOC_OWNER = deleted.USER_ID

    UPDATE PT35_DOC SET DOC_CREATED_BY = NULL
    FROM deleted, PT35_DOC
    WHERE PT35_DOC.DOC_CREATED_BY = deleted.USER_ID

    UPDATE PT35_DOC SET DOC_UPDATED_BY = NULL
    FROM deleted, PT35_DOC
    WHERE PT35_DOC.DOC_UPDATED_BY = deleted.USER_ID

    UPDATE PT35_DOC SET DOC_LOCKED_BY = NULL
    FROM deleted, PT35_DOC
    WHERE PT35_DOC.DOC_LOCKED_BY = deleted.USER_ID

    -- cascade set null to PT35_ASSET
    UPDATE PT35_ASSET SET AS_USED_BY = NULL
    FROM deleted, PT35_ASSET
    WHERE PT35_ASSET.AS_USED_BY = deleted.USER_ID

    -- cascade set null to 'pt35_change and change2' 
    UPDATE PT35_CHANGE SET PT35_CHANGE.MADE_BY = NULL
    FROM deleted, PT35_CHANGE
    WHERE PT35_CHANGE.MADE_BY = deleted.USER_ID

    UPDATE PT35_CHANGE2 SET PT35_CHANGE2.MADE_BY = NULL
    FROM deleted, PT35_CHANGE2
    WHERE PT35_CHANGE2.MADE_BY = deleted.USER_ID

    -- delete product user relations
    DELETE PT35_PROD_USER FROM deleted, PT35_PROD_USER 
    WHERE PT35_PROD_USER.USER_ID = deleted.USER_ID
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_VERSION_ITrig    Script Date: 3/7/00 1:54:39 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_VERSION_ITrig ON PT35_VERSION FOR INSERT AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_VERSION_UTrig    Script Date: 3/7/00 1:54:39 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_VERSION_UTrig ON PT35_VERSION FOR UPDATE AS
BEGIN
    IF UPDATE(PRODUCT) AND
        (SELECT COUNT(*) FROM inserted) !=
        (SELECT COUNT(*) FROM inserted, PT35_PRODUCT 
        WHERE PT35_PRODUCT.NAME = inserted.PRODUCT)
    BEGIN
        RAISERROR('The PRODUCT does not exist', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE IF UPDATE(VERSION_ID)
    BEGIN
        UPDATE PT35_TRACK 
        SET PT35_TRACK.VERSION1_ID = inserted.VERSION_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.VERSION1_ID = deleted.VERSION_ID

        UPDATE PT35_TRACK 
        SET PT35_TRACK.VERSION2_ID = inserted.VERSION_ID
        FROM deleted, inserted, PT35_TRACK
        WHERE PT35_TRACK.VERSION2_ID = deleted.VERSION_ID

        UPDATE PT35_TRACK2 
        SET PT35_TRACK2.VERSION1_ID = inserted.VERSION_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.VERSION1_ID = deleted.VERSION_ID

        UPDATE PT35_TRACK2 
        SET PT35_TRACK2.VERSION2_ID = inserted.VERSION_ID
        FROM deleted, inserted, PT35_TRACK2
        WHERE PT35_TRACK2.VERSION2_ID = deleted.VERSION_ID
    END
END

GO

setuser
GO

/****** Object:  Trigger root.PT35_VERSION_DTrig    Script Date: 3/7/00 1:54:39 PM ******/
setuser 'root'
GO

CREATE TRIGGER PT35_VERSION_DTrig ON PT35_VERSION FOR DELETE AS
BEGIN
    UPDATE PT35_TRACK SET VERSION1_ID = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.VERSION1_ID = deleted.VERSION_ID

    UPDATE PT35_TRACK SET VERSION2_ID = NULL
    FROM deleted, PT35_TRACK
    WHERE PT35_TRACK.VERSION2_ID = deleted.VERSION_ID

    UPDATE PT35_TRACK2 SET VERSION1_ID = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.VERSION1_ID = deleted.VERSION_ID

    UPDATE PT35_TRACK2 SET VERSION2_ID = NULL
    FROM deleted, PT35_TRACK2
    WHERE PT35_TRACK2.VERSION2_ID = deleted.VERSION_ID
END

GO

setuser
GO

