strComputer = "."
Set objWMIService = GetObject _
("winmgmts:{impersonationLevel=impersonate, (Shutdown)}\\" &_
strComputer & "\root\cimv2")

Set colOperatingSystems = objWMIService.ExecQuery _
("Select * from Win32_OperatingSystem")

For Each objOperatingSystem in colOperatingSystems
objOperatingSystem.Win32Shutdown(2)
Next
