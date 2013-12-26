Const CONVERSION_FACTOR = 1048576
computer = "hoodwkotc123632"
Set objWMIService = GetObject("winmgmts://" & computer)
Set objLogicalDisk = objWMIService.Get("Win32_LogicalDisk.DeviceID='c:'")
Wscript.Echo objLogicalDisk.FreeSpace
FreeMegaBytes = objLogicalDisk.FreeSpace / CONVERSION_FACTOR
Wscript.Echo FreeMegaBytes
Wscript.Echo Int(FreeMegaBytes)
Wscript.Echo "There are " & Int(FreeMegaBytes) & _
 " megabytes of free disk space on " & computer &"."
 ' or, alternately
Wscript.Echo "There are" , Int(FreeMegaBytes) , _
 "megabytes of free disk space on" , computer ,"." 

