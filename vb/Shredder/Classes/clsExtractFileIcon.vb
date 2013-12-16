' Author:       Justin Yates
' Purpose:      To retrieve any file's icon.
' Requirements: None

Option Explicit On 
Imports System.Runtime.InteropServices
Imports System.IO

Public Class ExtractFileIcon

    Private Declare Function ExtractIcon Lib "shell32.dll" Alias "ExtractIconA" (ByVal hIcon As IntPtr, ByVal lpszExeFileName As String, ByVal nIconIndex As Integer) As IntPtr
    Private Declare Function DestroyIcon Lib "user32" (ByVal hIcon As IntPtr) As Boolean

    Private myReg As Microsoft.Win32.Registry

    Public Function GetIconFromFile(ByVal myFile As FileInfo, ByRef myImgList As System.Windows.Forms.ImageList) As Integer
        Dim hIcon As IntPtr
        Dim myIcon As Icon
        Dim intIconIndex As Integer
        Dim strRegResult As String
        Dim str() As String

        Try ' If the file is an aplication, retrieve the icon from that file.
            If myFile.Extension = ".exe" Then
                hIcon = ExtractIcon(IntPtr.Zero, myFile.FullName, 0)
                ' If no success then use windows default.
                If hIcon.ToInt32 <= 1 Then hIcon = ExtractIcon(IntPtr.Zero, "Shell32.dll", 0)
            Else ' Get location from registry.
                strRegResult = myReg.ClassesRoot.OpenSubKey(myFile.Extension).GetValue("")
                strRegResult = myReg.ClassesRoot.OpenSubKey(strRegResult).OpenSubKey("DefaultIcon").GetValue("")
                str = strRegResult.Split(",")
                If str.Length > 1 Then
                    intIconIndex = str(1)
                Else
                    intIconIndex = 0
                End If
                strRegResult = str(0)
                hIcon = ExtractIcon(IntPtr.Zero, strRegResult, intIconIndex)
            End If
            myIcon = Icon.FromHandle(hIcon)
            myImgList.Images.Add(myIcon)
            DestroyIcon(hIcon) ' Remove the icon from the memory.
        Catch
            hIcon = ExtractIcon(IntPtr.Zero, "Shell32.dll", 0)
            myIcon = Icon.FromHandle(hIcon)
            myImgList.Images.Add(myIcon)
            DestroyIcon(hIcon) ' Remove the icon from the memory.
        End Try
        Return myImgList.Images.Count - 1
    End Function

End Class
