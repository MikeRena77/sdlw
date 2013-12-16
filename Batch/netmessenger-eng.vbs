'netmessenger-eng.vbs
'Script tosendmessagestonetworkcomputers,likeancientnetsend
'Version1.1
'VersionReleaseDate:8/26/2011
'VersionImprovements:Scriptprocessingdoesnotshowvariouscommandpromptwindows
'        andprogressmessagesareshownduringprocessing,withnoCPUstress. 
'ByPedroLima(pedrofln.blogspot.com)
'InformationTechnology,MBA
'MCT,MCSE,MCSA,MCP+I,Network+CertifiedProfessional
'------------------------------------------------------------

OptionExplicit 
OnErrorResumeNext 
ConstADS_SCOPE_SUBTREE=2 
DimobjConnection,objCommand,objRecordSet,objShell,objSA,objArquivoTexto,objProcessEnv
DimstrDomain,strContent,strCommand,strComputer,strMessage,strComputers,strCall,strLdapDomain
DimintCounter,intLines,intDomainParts,intDomainLenght,intPosition,intSent,intNotSent,intComputermatch
IntNotSent=0
IntSent=0

SetobjShell=CreateObject("WScript.Shell")
SetobjProcessEnv=objShell.Environment("Process")

'Askstheusertotypethemessage
strMessage=InputBox("Typethemessagetobesenttonetworkcomputer(s)","MessengerService",strMessage)
if strMessage="" Then
 Wscript.Echo"Operationcanceledbytheuser"
 Wscript.Quit
End if

'Determinesthescopeofthemessagebeingsent
strComputer=InputBox("-->Type*for allcomputers,or"&vbcr&"-->thesinglecomputername,or"&vbcr&"-->apathtoafilecontaining"&vbcr&"alistofcomputerslikec:\list.txt"&vbcr&"PS:Mustcontainthe':'characterinthepath","Choosetherightscope",strComputer)
if strComputer="" Then
 Wscript.Echo"Operationcanceledbytheuser"
 Wscript.Quit
End if

if strComputer="*" then 
 'getthedomainnameoftheuser
 strdomain=objProcessEnv("USERDNSDOMAIN")
 if strdomain="" then
  Wscript.Echo"Thiscomputerisnotjoinedinadomain,ormaybetheaccountyouhaveusedto"&vbcr&"callthescriptdoesnothavequeryprivilegestoAD.Pleasetryagain using"&vbcr&"acomputernameorafilewithalistcontainingcomputernames"
   Wscript.Quit
 else
  intdomainparts=Int(Conta(strdomain,".",false))
  for intCounter=1 to intdomainparts
   intdomainlenght=len(strdomain)
   if intCounter<intDomainparts then 
    intposition=InStr(strdomain,".")
   Else
    intposition=intdomainlenght+1
   End if
   strldapdomain=strldapdomain&",DC="&left(strdomain,intposition-1)
   if intCounter<intDomainparts then 
    strdomain=right(strdomain,intdomainlenght-intposition)
   End if
  Next
 End if
 strLdapDomain=right(strldapdomain,len(strldapdomain)-1)
 SetobjConnection=CreateObject("ADODB.Connection")
 SetobjCommand= CreateObject("ADODB.Command") 
 objConnection.Provider="ADsDSOObject" 
 objConnection.Open"ActiveDirectoryProvider" 
 SetobjCOmmand.ActiveConnection=objConnection 

 'Getallcomputerobjectsinthespecifieddomain 
 objCommand.CommandText="SelectNamefrom'LDAP://"&strLdapDomain&_
 "'whereobjectClass='computer'"
 objCommand.Properties("PageSize")=1500 
 objCommand.Properties("Timeout")=30 
 objCommand.Properties("Searchscope")=ADS_SCOPE_SUBTREE 
 objCommand.Properties("CacheResults")=False 
 SetobjRecordSet=objCommand.Execute 
 intComputermatch=objRecordSet.RecordCount 
 SetobjRecordSet=objCommand.Execute 'NecessarytocallagainonaccountoftheRecordcount
  
 'Failswhenthereisanerrorinthedomainname 
 if Err.Number<>0 then 
  Wscript.Echo"Themessengerscriptcouldnotfindthedomainspecified.Checkiftheac-"&vbcr&"countusedtocallthescripthasenoughprivileges.Nomessagewassent." 
  Wscript.Quit 
 Else
  DoWhilenotobjRecordSet.EOF         
   strComputer=objRecordSet.Fields("name").Value
   SetobjShell=CreateObject("WScript.Shell")
   strCommand=objShell.Run("cmd/cmsg*/server:"&strComputer&""&strMessage,0,True)    
   if strCommand<>0 then
     intNotSent=IntNotSent+1
     objShell.Popup strcomputer & "seems to be offline",2
   Else
     intSent=intSent+1
     objShell.Popup intSent & "/" & intComputermatch & "messages successfully sent to the network," & vbcr & "butatleast" & intNotSent & "computers were offline or" & vbcr & "did not exist or could not be contacted.",1
   End if
   SetobjShell=Nothing
   objRecordSet.MoveNext 
   Err.Clear  
  Loop 
  if intNotSent>0 then
   wscript.echo intSent & "messages successfully sent to the network," & vbcr & "butatleast" & intNotSent & "computers were offline or did" & vbcr & "notexistorcouldnotbecontacted."
  Else 
   wscript.echointSent&"messagessentsuccessfullytothenetwork."
  End if
 End if  
 wscript.quit
 
Elseif instr(strComputer,":") then
 
 'Routinetoreadafilecontainingalistofcomputers
 SetobjSA=CreateObject("Scripting.FileSystemObject")
 ConstForReading=1
 intLines=0
 SetobjArquivoTexto=objSA.OpenTextFile(strComputer,ForReading)
 if Err.Number<>0 then
  Wscript.echo"Thefilespecifieddoesnotexist.Tryagainwithacorrectpathtothefile.Exiting."
  Wscript.Quit
 End if 
 strContent=ObjArquivoTexto.ReadAll
 intLines=Conta(strContent,chr(13),false)
 RedimstrComputers(intLines+1)
 
 for intCounter=1tointLines
  strCall=GetLine(strContent,intCounter)
  strComputers(intCounter)=strCall
  SetobjShell=WScript.CreateObject("WScript.Shell")
  strCommand=objShell.Run("cmd/cmsg*/server:"&strComputers(intCounter)&""&strMessage,0,True)
  if strCommand<>0 then
    intNotSent=IntNotSent+1
    objShell.PopupstrComputers(intCounter)&"seamstobeoffline",2
  Else
    intSent=intSent+1
    objShell.PopupintSent&"/"&intLines&"messagessuccessfullysenttothenetwork,"&vbcr&"butatleast"&intNotSent&"computerswereofflineor"&vbcr&"didnotexistorcouldnotbecontacted.",1
  End if
  SetobjShell=Nothing
 Next
 if intNotSent>0 then
  Wscript.EchointSent&"messagessuccessfullysenttothenetwork,"&vbcr&"butatleast"&intNotSent&"computerswereofflineordid"&vbcr&"notexistorcouldnotbecontacted."
 Else 
  Wscript.EchointSent&"messagessentsuccessfullytothenetwork."
 End if
 Wscript.Quit
Else
 SetobjShell=CreateObject("WScript.Shell")
 strCommand=objShell.Run("cmd/cmsg*/server:"&strComputer&""&strMessage,0,True)
 SetobjShell=Nothing
 if strCommand<>0 then
  Wscript.Echo"Thespecifiedcomputerdoesnotexistorcanbe" &vbcr&"offline,oryoumaynothaveenoughprivileges"&vbcr&"tosendamessagetoit.Messagenotsent."
 else
  Wscript.Echo"Messagesentsuccessfully!"
 End if
End if

wscript.quit

'----------------------------------------------------------------------------------------------------------------
'Functions
'----------------------------------------------------------------------------------------------------------------

FunctionGetLine(strbuffer,Line)

 DimintEnd,strData,StrLine,IntLine

 StrLine=StrBuffer
 intEnd=InStr(strLine,Chr(13))' GettheinitialpositionofASCII13code(ENTER)
 IntLine=0
 Do 
 IntLine=IntLine+1
 if intEnd>0 then  
  if IntLine=Line then
    strLine=Left(strLine,intEnd-1)
    intEnd=InStr(strLine,Chr(13))
  Else
    StrLine=Mid(StrLine,IntEnd+2)
    intEnd=InStr(strLine,Chr(13))
  End if
 Else 
  strLine=strLine
 End if
 LoopWhileIntLine<Line

 GetLine=strLine

EndFunction

'--------------------------------------------------------------------------------------------------------------------

FunctionConta(strText,strFind,fCaseSensitive)
  DimintCount,intPos,intMode
  
  if Len(strFind)>0 then
    'Configuresthecomparisonmode.
    if fCaseSensitive then
      intMode=vbBinaryCompare
    Else
      intMode=vbTextCompare
    End if
    intPos=1
    Do
     intPos=InStr(intPos,strText,strFind,intMode)
      if intPos>0 then
        intCount=intCount+1
        intPos=intPos+Len(strFind)
      End if
    LoopWhileintPos>0
  Else
    intCount=0
  End if
  Conta=intCount+1
EndFunction
