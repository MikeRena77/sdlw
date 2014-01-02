SELECT 
  P.packagename,
  A.execdtime ,
  U.RealName ,
  U.UserName ,
  U.UsrObjId ,
  G.USERGROUPNAME ,
  G.USRGRPOBJID ,
  A.Action ,
  SP.processname ,
  SP.processobjid,
  A.note
FROM 
  harUser U ,
  harApproveHistView V ,
  harApproveHist A ,
  harApproveList L ,
  harPackage P ,
  harStateProcess SP,
  harusergroup G
WHERE 
  P.PackageObjId = V.PackageObjId AND
  V.stateobjid = P.StateObjID AND
  SP.StateObjId = P.StateObjID AND
  L.ProcessObjId = SP.ProcessObjId AND
  L.StateObjId = SP.StateObjId AND
  U.UsrObjId = L.UsrObjId AND
  V.UsrObjId = L.UsrObjId  AND
  A.envobjid = V.envobjid AND
  A.stateobjid = V.stateobjid AND
  A.packageobjid = V.packageobjid AND
  A.usrobjid = V.usrobjid AND
  A.execdtime = V.actiontime 
  
UNION 
  
SELECT 
  P.packagename,
  A.execdtime , 
  U.RealName , 
  U.USERNAME ,     
  U.UsrObjId , 
  G.UserGroupName , 
  G.UsrGrpObjId , 
  A.Action ,     
  SP.processname , 
  SP.processobjid, 
  A.note 
FROM 
  harUser U , 
  harUserGroup G , 
  harApproveHistView V ,      
  harApproveHist A , 
  harApproveList L ,     
  harPackage P , 
  harStateProcess SP , 
  harUsersInGroup I 
WHERE 

  P.PackageObjId = V.PackageObjId AND
  P.StateObjId = V.StateObjId AND
  SP.StateObjId = P.StateObjID AND
  L.ProcessObjId = SP.ProcessObjId AND
  L.StateObjId = SP.StateObjId AND
  G.UsrGrpObjId = L.UsrGrpObjId AND
  I.UsrGrpObjId = G.UsrGrpObjId AND
  I.UsrObjId = V.UsrObjId AND
  U.UsrObjId = V.UsrObjId AND
  A.packageobjid = V.packageobjid AND
  A.envobjid = V.envobjid AND
  A.stateobjid = V.stateobjid AND
  A.packageobjid = V.packageobjid AND
  A.usrobjid = V.usrobjid AND
  A.execdtime = V.actiontime  

UNION

SELECT 
  P.packagename,
  TO_DATE(NULL) , 
  U.RealName , 
  U.UserName , 
  U.UsrObjId , 
  '' , 
  0 ,       
  'Need' , 
  SP.processname , 
  SP.processobjid, 
  '' NOTE 
FROM 
  harUser U , 
  harApproveList L , 
  harStateProcess SP , 
  harPackage P 
WHERE

  SP.StateObjId = P.StateObjID AND
  L.ProcessObjId = SP.ProcessObjId AND
  L.StateObjId = SP.StateObjId AND
  U.UsrObjId = L.UsrObjId AND
  (L.UsrObjId NOT IN     
     (SELECT V.UsrObjId      
	 FROM harApproveHistView V      
	 WHERE P.PackageObjId = V.PackageObjId AND 
	 V.StateObjId = P.StateObjId ) 
   OR 
   L.UsrObjId IS NULL )

UNION 

SELECT 
  P.packagename,
  TO_DATE(NULL) , 
  '' , '
  ' , 
  0 , 
  G.UserGroupName , 
  G.UsrGrpObjId ,       
  'Need' , 
  SP.processname , 
  SP.processobjid, 
  '' NOTE 
  FROM 
    harUserGroup G , 
	harApproveList L , 
	harPackage P , 
	harStateProcess SP 
WHERE 

  SP.StateObjId = P.StateObjID AND
  L.ProcessObjId = SP.ProcessObjId AND
  L.StateObjId = SP.StateObjId AND
  G.UsrGrpObjId = L.UsrGrpObjId AND
  (L.UsrGrpObjId NOT IN     
    (SELECT I.UsrGrpObjId     
	FROM harApproveHistView V , 
	harUsersInGroup I     
	WHERE P.PackageObjId = V.PackageObjId     AND
	V.StateObjId = P.StateObjId     AND
	I.UsrObjId = V.UsrObjId ) 	OR 
	L.UsrGrpObjId IS NULL )
