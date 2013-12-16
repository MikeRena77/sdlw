
Option Explicit On 
Imports System.IO
Imports System.Diagnostics

Module modGeneral
    Public Structure Options
        Dim Transparency As Double
        Dim OverwriteNumber As Integer
        Dim AutoCleanIE As Boolean
        Dim AutoCleanCache As Boolean
        Dim clAcrobat As Boolean
        Dim clIEHistory As Boolean
        Dim clIECookies As Boolean
        Dim clMSPaint As Boolean
        Dim clMSRun As Boolean
        Dim clCache As Boolean
        Dim clMediaPlayer As Boolean
        Dim clRecentDocs As Boolean
        Dim clTemp As Boolean
        Dim clWinRAR As Boolean
        Dim clWinZip As Boolean
    End Structure

    Public MyOptions As Options

    Public Function GetOptions()
        Try
            Dim FS As New FileStream(AddBackSlash(Application.StartupPath) & "Options.dat", FileMode.Open, FileAccess.Read)
            Dim BR As New BinaryReader(FS)

            BR.BaseStream.Seek(0, SeekOrigin.Begin)
            MyOptions.Transparency = BR.ReadDouble
            MyOptions.OverwriteNumber = BR.ReadInt32
            MyOptions.AutoCleanIE = BR.ReadBoolean
            MyOptions.AutoCleanCache = BR.ReadBoolean
            MyOptions.clAcrobat = BR.ReadBoolean
            MyOptions.clCache = BR.ReadBoolean
            MyOptions.clIECookies = BR.ReadBoolean
            MyOptions.clIEHistory = BR.ReadBoolean
            MyOptions.clMediaPlayer = BR.ReadBoolean
            MyOptions.clMSPaint = BR.ReadBoolean
            MyOptions.clMSRun = BR.ReadBoolean
            MyOptions.clRecentDocs = BR.ReadBoolean
            MyOptions.clTemp = BR.ReadBoolean
            MyOptions.clWinRAR = BR.ReadBoolean
            MyOptions.clWinZip = BR.ReadBoolean

            BR.Close()
            FS.Close()
        Catch FileNotFoundException As Exception
            ' Set defaults.
            ResetOptions()
        End Try
    End Function

    Public Function SaveOptions()
        Try
            Dim FS As New FileStream(AddBackSlash(Application.StartupPath) & "Options.dat", FileMode.Create, FileAccess.Write)
            Dim BW As New BinaryWriter(FS)

            BW.Write(MyOptions.Transparency)
            BW.Write(MyOptions.OverwriteNumber)
            BW.Write(MyOptions.AutoCleanIE)
            BW.Write(MyOptions.AutoCleanCache)
            BW.Write(MyOptions.clAcrobat)
            BW.Write(MyOptions.clCache)
            BW.Write(MyOptions.clIECookies)
            BW.Write(MyOptions.clIEHistory)
            BW.Write(MyOptions.clMediaPlayer)
            BW.Write(MyOptions.clMSPaint)
            BW.Write(MyOptions.clMSRun)
            BW.Write(MyOptions.clRecentDocs)
            BW.Write(MyOptions.clTemp)
            BW.Write(MyOptions.clWinRAR)
            BW.Write(MyOptions.clWinZip)

            BW.Flush()
            BW.Close()
            FS.Close()
        Catch ex As Exception
            MessageBox.Show("Failed to save your settings.", "Shredder", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Function

    Public Function ResetOptions()
        MyOptions.Transparency = 1
        MyOptions.OverwriteNumber = 10
        MyOptions.AutoCleanCache = False
        MyOptions.AutoCleanIE = False
        MyOptions.clAcrobat = False
        MyOptions.clCache = False
        MyOptions.clIECookies = False
        MyOptions.clIEHistory = False
        MyOptions.clMediaPlayer = False
        MyOptions.clMSPaint = False
        MyOptions.clMSRun = False
        MyOptions.clRecentDocs = False
        MyOptions.clTemp = False
        MyOptions.clWinRAR = False
        MyOptions.clWinZip = False
    End Function

    ' Check to see if a specifed process is currently running
    Public Function GetProcessStatus(ByVal strProcess As String) As Boolean
        Dim i As Integer
        Dim Prc() As Process

        Try
            ' Retrieve all processes currently running.
            Prc = Process.GetProcesses(Environment.MachineName.ToString)
            For i = 0 To UBound(Prc)
                If Prc(i).ProcessName.ToLower = strProcess.ToLower Then
                    GetProcessStatus = True
                    Exit Function
                End If
            Next
            ' If not found return false.
            GetProcessStatus = False
        Catch ex As Exception
            GetProcessStatus = False
        End Try
    End Function

    ' Retrieve an embedded icon. Icon's build action must be set to embedded resource.
    Public Function GetEmbeddedIcon(ByVal strName As String) As Icon
        Return New Icon(System.Reflection.Assembly.GetExecutingAssembly.GetManifestResourceStream(strName))
    End Function

    ' Remove the "\" from the end of a specifed path.
    Public Function RemoveBackSlash(ByVal strItem As String) As String
        If strItem.Substring(strItem.Length - 1) = "\" Then
            RemoveBackSlash = strItem.Substring(0, strItem.Length - 1)
        Else
            RemoveBackSlash = strItem
        End If
    End Function

    ' Check to see if "\" is at the end of the path, and if not then add it.
    ' Class Shredder contains the same function (CheckPath) to make that class distributable.
    Public Function AddBackSlash(ByVal strItem As String) As String
        If strItem.Substring(strItem.Length - 1) = "\" Then
            AddBackSlash = strItem
        Else
            AddBackSlash = strItem & "\"
        End If
    End Function
End Module
