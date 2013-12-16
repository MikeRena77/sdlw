' Author:       Justin Yates
' Purpose:      Basic Registry tools
' Requirements: None

Option Explicit On 

Public Class Registry
    Private Reg As Microsoft.Win32.RegistryKey

    ' Read a String Value from Registry.
    Public Function GetString(ByRef hKey As Microsoft.Win32.RegistryKey, ByRef strPath As String, ByRef strValue As String) As String
        Reg = hKey.OpenSubKey(strPath, True)
        If (Not Reg Is Nothing) Then
            GetString = Reg.GetValue(strValue, 0)
            Reg.Close()
        End If
    End Function

    ' Set a String Value in the Registry.
    Public Function SetString(ByRef hKey As Microsoft.Win32.RegistryKey, ByRef strPath As String, ByRef strValue As String, ByRef strData As String)
        Reg = hKey.OpenSubKey(strPath, True)
        If (Not Reg Is Nothing) Then
            Reg.SetValue(strValue, strData)
            Reg.Flush()
            Reg.Close()
        End If
    End Function

    ' Delete a String Value in the Registry.
    Public Function DeleteValue(ByRef hKey As Microsoft.Win32.RegistryKey, ByRef strPath As String, ByRef strValue As String)
        Reg = hKey.OpenSubKey(strPath, True)
        If (Not Reg Is Nothing) Then
            Reg.DeleteValue(strValue, False)
        End If
    End Function

    ' Count the number of values in a key.
    Public Function CountValues(ByRef hKey As Microsoft.Win32.RegistryKey, ByRef strPath As String) As Integer
        Reg = hKey.OpenSubKey(strPath, True)
        If (Not Reg Is Nothing) Then
            CountValues = Reg.ValueCount
            Reg.Close()
        Else
            CountValues = 0
        End If
    End Function
End Class
