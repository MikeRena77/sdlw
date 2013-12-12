Dim WshShell, FileManagment, BrowseDialogBox, SelectedFolder, OldString, NewString, FullPath, TheFolder, FileList
Dim File, ThisFile, TheString, AlreadyRenamed, TempName, FlagName, Success, FindFlag, NewName, Dummy

Set WshShell = WScript.CreateObject("WScript.Shell")
Set FileManagment = WScript.CreateObject ("Scripting.FileSystemObject")
Set BrowseDialogBox = WScript.CreateObject("Shell.Application")

Set SelectedFolder = BrowseDialogBox.BrowseForFolder(0, "Select the folder containing the files to be renamed.", &H0001)

If InStr(1, TypeName(SelectedFolder), "Folder") = 0 Then
  Wscript.Quit
Else
  OldString = InputBox("Enter the characters in the filename that you want to replace","Rename Files") 
  If OldString = "" Then Wscript.Quit
  NewString = InputBox("Enter the characters with which you will replace them","Rename Files") 
  'If NewString = "" Then Wscript.Quit
End If

FullPath = SelectedFolder.ParentFolder.ParseName(SelectedFolder.Title).Path

Set TheFolder = FileManagment.GetFolder(FullPath)
Set FileList = TheFolder.Files
Success = 0

For Each File in FileList 
  
   ThisFile = File.Name
   TheString = InStr(ThisFile, OldString)
   AlreadyRenamed = InStr(ThisFile, "%") 
   If (TheString <> 0) AND (AlreadyRenamed = 0) Then
      Success = 1
      TempName = Replace(ThisFile, OldString, NewString)
      FlagName = "%" + TempName
      File.Name = FlagName
   End If

Next

For Each File in FileList 
  
   ThisFile = File.Name
   FindFlag = InStr(ThisFile, "%")
   If FindFlag <> 0 Then
     NewName = Replace(ThisFile, "%", "")
     File.Name = NewName
   End If

Next

If Success = 1 Then
  Dummy = WshShell.Popup ("Rename Files operation has completed!",5,"Rename Files",64)
Else
  Dummy =   WshShell.Popup ("Rename Files operation has failed!   Please attempt the operation again.",0,"Rename Files",16)
End If

Wscript.Quit
