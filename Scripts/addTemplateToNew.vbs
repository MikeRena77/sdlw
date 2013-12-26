' Adds template to "New" context menu
' as defined by template (e.g. template.vbs) located in the
' \Windows\System32\ShellExt folder (on Windows XP and Windows Server 2003),
' or in the \Winnt\ShellNew folder (Windows 2000). 

Set objShell = WScript.CreateObject("WScript.Shell")
objShell.RegWrite "HKCR\.VBS\ShellNew\FileName","template.vbs"