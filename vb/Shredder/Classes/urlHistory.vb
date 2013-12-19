Imports System.Collections.Generic
Imports Microsoft.Win32

Public Class UrlHistory
    Public Function PopulateUrlList() As List(Of String)
        Dim regKey As String = "Software\Microsoft\Internet Explorer\TypedURLs"
        Dim subKey As RegistryKey = Registry.CurrentUser.OpenSubKey(regKey)
        Dim url As String
        Dim urlHistory As New List(Of String)()
        Dim counter As Integer = 1
        While True
            Dim sValName As String = "url" + counter.ToString()
            url = DirectCast(subKey.GetValue(sValName), String)
            If DirectCast(url, Object) Is Nothing Then
                Exit While
            End If
            urlHistory.Add(url)
            counter += 1
        End While
        Return urlHistory
    End Function
    Public Function ClearHistory()

    End Function
End Class
