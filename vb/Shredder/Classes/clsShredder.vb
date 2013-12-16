' Author:       Justin Yates
' Purpose:      The cleaning tools
' Requirements: clsRegistry
'               clsHistory
'               clsURLHistItem

' Information on Shredding files.
' Deleting doesn't remove a file from your hard drive. The disk space is sent back
' to the system, but the actual bytes on disk haven't changed. The file is still
' recoverable and the contents can still be viewed. Using the ShredFile function in 
' this class will overwrite the contents of the file. The file will still be able to 
' be recovered, but you will not be able to view the contents of the file.
' For example, a picture file will not be able to be displayed or a word docement will 
' not be viewable. I've tested this with RStudio and was unable to recover previous 
' contents.
' The only true way of secure deletion is by physically destroying the hard drive.

Option Explicit On 
Imports System.IO
Imports Microsoft.Win32.Registry
Imports System.Runtime.InteropServices

Public Class Shredder

    ' Private variables.
    Private _File As String
    Private _Files() As String
    Private _Folder As String
    Private _Folders() As String
    Private _keyName As String
    Private _Hist As New clsHistory
    Private _History As String
    Private _Cookies As String
    Private _TempInternet As String
    Private _Temp As String

    Private MyReg As New Registry

    ' Constants.
    Private Const ChunkSize = 1
    Private Const BUFFERSIZE = 2048
    Private Const CACHGROUP_SEARCH_ALL = &H0
    Private Const CACHEGROUP_FLAG_FLUSHURL_ONDELETE = &H2
    Private Const ERROR_FILE_NOT_FOUND = &H2
    Private Const ERROR_NO_MORE_FILES = 18
    Private Const ERROR_NO_MORE_ITEMS = 259

    ' API declarations.
    Private Declare Function DeleteFile Lib "kernel32" Alias "DeleteFileA" (ByVal lpFileName As String) As Long
    Private Declare Function SHAddToRecentDocs Lib "Shell32" (ByVal lFlags As Long, ByVal lPv As Long) As Long
    Private Declare Function GetInputState Lib "user32" () As Long

    Private Declare Function FindFirstUrlCacheGroup Lib "wininet.dll" (ByVal dwFlags As Integer, ByVal dwFilter As Integer, ByRef lpSearchCondition As Integer, ByVal dwSearchCondition As Integer, ByRef lpGroupId As Date, ByRef lpReserved As Integer) As Integer
    Private Declare Function FindNextUrlCacheGroup Lib "wininet.dll" (ByVal hFind As Integer, ByRef lpGroupId As Date, ByRef lpReserved As Integer) As Integer
    Private Declare Function DeleteUrlCacheGroup Lib "wininet.dll" (ByVal sGroupID As Date, ByVal dwFlags As Integer, ByRef lpReserved As Integer) As Integer

    ' The next 3 api require Marshaling.

    ' Marshaling - Provides a collection of methods for allocating unmanaged memory,
    ' copying unmanaged memory blocks, and converting managed to unmanaged types, 
    ' as well as other miscellaneous methods used when interacting with unmanaged code.

    ' SetLastError: - Indicates whether the callee calls the SetLastError Win32 API function before returning from the attributed method.
    ' Charset: -  Indicates how to marshal string parameters to the method and controls name mangling.
    ' EntryPoint: - Indicates the name or ordinal of the DLL entry point to be called.
    ' CallingConvention: - Indicates the calling convention of an entry point.

    ' Platform Invoke: Begins the enumeration of the Internet cache.
    <DllImport("wininet.dll", _
        SetLastError:=True, _
        CharSet:=CharSet.Auto, _
        EntryPoint:="FindFirstUrlCacheEntryA", _
        CallingConvention:=CallingConvention.StdCall)> _
     Private Shared Function FindFirstUrlCacheEntry( _
     <MarshalAs(UnmanagedType.LPStr)> ByVal lpszUrlSearchPattern As String, _
          ByVal lpFirstCacheEntryInfo As IntPtr, _
          ByRef lpdwFirstCacheEntryInfoBufferSize As Int32) As IntPtr
    End Function

    ' Platform Invoke: Retrieves the next entry in the Internet cache.
    <DllImport("wininet.dll", _
       SetLastError:=True, _
       CharSet:=CharSet.Auto, _
       EntryPoint:="FindNextUrlCacheEntryA", _
       CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function FindNextUrlCacheEntry( _
          ByVal hFind As IntPtr, _
          ByVal lpNextCacheEntryInfo As IntPtr, _
          ByRef lpdwNextCacheEntryInfoBufferSize As Integer) As Boolean
    End Function

    ' Platform Invoke: Removes the file that is associated with the source name from the cace, if the file exists.
    <DllImport("wininet.dll", _
      SetLastError:=True, _
      CharSet:=CharSet.Auto, _
      EntryPoint:="DeleteUrlCacheEntryA", _
      CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DeleteUrlCacheEntry( _
        ByVal lpszUrlName As IntPtr) As Boolean
    End Function

    ' Structures.
    <StructLayout(LayoutKind.Explicit, Size:=80)> _
    Public Structure INTERNET_CACHE_ENTRY_INFOA
        <FieldOffset(0)> Public dwStructSize As UInt32
        <FieldOffset(4)> Public lpszSourceUrlName As IntPtr
        <FieldOffset(8)> Public lpszLocalFileName As IntPtr
        <FieldOffset(12)> Public CacheEntryType As UInt32
        <FieldOffset(16)> Public dwUseCount As UInt32
        <FieldOffset(20)> Public dwHitRate As UInt32
        <FieldOffset(24)> Public dwSizeLow As UInt32
        <FieldOffset(28)> Public dwSizeHigh As UInt32
        <FieldOffset(32)> Public LastModifiedTime As FILETIME
        <FieldOffset(40)> Public ExpireTime As FILETIME
        <FieldOffset(48)> Public LastAccessTime As FILETIME
        <FieldOffset(56)> Public LastSyncTime As FILETIME
        <FieldOffset(64)> Public lpHeaderInfo As IntPtr
        <FieldOffset(68)> Public dwHeaderInfoSize As UInt32
        <FieldOffset(72)> Public lpszFileExtension As IntPtr
        <FieldOffset(76)> Public dwReserved As UInt32
        <FieldOffset(76)> Public dwExemptDelta As UInt32
    End Structure

    ' Check to see if "\" is at the end of the path, and if not then add it.
    Public Function CheckPath(ByVal strPath As String) As String
        If strPath.Substring(strPath.Length - 1) = "\" Then
            Return strPath
        Else
            Return strPath & "\"
        End If
    End Function

    ' Shred file function will overwrite file.
    Public Function ShredFile(ByVal strFile As String, ByVal intOverwriteNum As Integer, ByVal blnDisplayError As Boolean)
        Dim FileLength As Long = 0
        Dim i As Integer = 0
        Dim j As Long = 0

        ' Used for test purposes.
        Dim StartTime As Date
        Dim EndTime As Date
        Dim Patterns(intOverwriteNum) As Byte
        Dim intPatternIndex As Integer = 0

        Try
            StartTime = Now ' Used for test purposes

            ' Remove the read only attribute.
            FileSystem.SetAttr(strFile, FileAttribute.Normal)
            FileLength = FileLen(strFile)

            For i = 0 To intOverwriteNum
                Patterns(i) = Asc(1 + i)
            Next

            For intPatternIndex = 0 To intOverwriteNum
                Dim fs As New FileStream(strFile, FileMode.Open, FileAccess.ReadWrite, FileShare.None)
                fs.Seek(0, SeekOrigin.Begin)
                For j = 0 To FileLength
                    fs.Write(Patterns, intPatternIndex, 1)
                Next
                fs.Flush()
                fs.Close()
                Application.DoEvents()
            Next
            System.Threading.Thread.Sleep(200)
            DeleteFile(strFile)

            ' This is purley for testing purposes.
            EndTime = Now
            'MessageBox.Show(DateDiff(DateInterval.Second, StartTime, EndTime) & " seconds to shred file.", "Duration", MessageBoxButtons.OK, MessageBoxIcon.Information)

        Catch ex As Exception
            If blnDisplayError Then MessageBox.Show("Failed to shred file: " & strFile, "Shredder", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Function

    ' Shred folder using recursion to shred all sub folders.
    Private Function ShredSubFolder(ByVal strFolder As String, ByVal intOverwriteNum As Integer)
        _Files = Directory.GetFiles(strFolder)
        For Each _File In _Files
            ShredFile(_File, intOverwriteNum, False) ' Shred each file.
        Next
        _Folders = Directory.GetDirectories(strFolder)
        For Each _Folder In _Folders
            ShredSubFolder(_Folder, intOverwriteNum) ' Use recursion to shred sub folder of current parent folder.
        Next
    End Function

    ' Shred folder (will delete strFolder).
    Public Function ShredFolder(ByVal strFolder As String, ByVal intOverwriteNum As Integer)
        Try
            ShredSubFolder(strFolder, intOverwriteNum)
            Directory.Delete(strFolder, True)
        Catch ex As Exception
            MessageBox.Show("Failed to shred folder: " & strFolder, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Function

    ' Clean Internet Explorer history and typed URLs.
    Public Function CleanHistory()
        _History = Environment.GetFolderPath(Environment.SpecialFolder.History)
        ' Delete Index.dat file from History.
        DeleteFile(CheckPath(_History) & "History.IE5\index.dat")
        _Hist = New clsHistory
        _Hist.Clear()
        _Hist.RefreshHistory()

        ' Clear Typed URLs (Internet Explorer must be closed).
        _keyName = "Software\Microsoft\Internet Explorer\TypedURLs"
        ' Delete the key that contains the URLs the history.
        CurrentUser.DeleteSubKey(_keyName, False)
        ' Recreate the key, empty.
        CurrentUser.CreateSubKey(_keyName)
    End Function

    ' Clean cookies.
    Public Function CleanCookies()
        _Cookies = Environment.GetFolderPath(Environment.SpecialFolder.Cookies)
        _Files = Directory.GetFiles(_Cookies) ' Get all the files in the folder.

        For Each _File In _Files ' Run through each file.
            If Right(_File, 3) = "dat" Then
                ' Use api to delete "Index.dat" files.
                DeleteFile(_File)
            Else
                ShredFile(_File, 10, False) ' Default cookies to 10 times overwrite.
            End If
        Next
    End Function

    ' Remove temparory internet cache.
    Public Function CleanInternetCache()
        Dim dtGroupID As Date
        Dim intGroup As Integer = 0
        Dim intSize As Integer = 0
        Dim intCacheEntryInfoBufferSizeInitial As Integer = 0
        Dim intCacheEntryInfoBufferSize As Integer = 0
        Dim cacheEntryInfoBuffer As IntPtr = IntPtr.Zero
        Dim internetCacheEntry As INTERNET_CACHE_ENTRY_INFOA
        Dim enumHandle As IntPtr = IntPtr.Zero
        Dim blnReturnValue As Boolean = False

        ' Find first group.
        intGroup = FindFirstUrlCacheGroup(0, CACHGROUP_SEARCH_ALL, 0, 0, dtGroupID, 0)

        If (intGroup <> 0) Then
            ' We succeeded in finding the first cache group, delete it and find the next.
            Do
                If (0 = DeleteUrlCacheGroup(dtGroupID, CACHEGROUP_FLAG_FLUSHURL_ONDELETE, 0)) Then
                    MessageBox.Show("Could not delete url cache", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
                End If
                intSize = BUFFERSIZE
                If (0 = FindNextUrlCacheGroup(intGroup, dtGroupID, intSize)) And (Err.LastDllError <> 2) Then
                    Exit Function
                End If
            Loop Until Err.LastDllError = 2
        End If

        ' Find first cache entry.
        enumHandle = FindFirstUrlCacheEntry(vbNull, IntPtr.Zero, intCacheEntryInfoBufferSizeInitial)
        If (Not enumHandle.Equals(IntPtr.Zero) And ERROR_NO_MORE_ITEMS.Equals(Marshal.GetLastWin32Error())) Then
            Exit Function
        End If
        intCacheEntryInfoBufferSize = intCacheEntryInfoBufferSizeInitial
        ' Allocate a block of memory using GlobalAlloc.
        cacheEntryInfoBuffer = Marshal.AllocHGlobal(intCacheEntryInfoBufferSize)
        enumHandle = FindFirstUrlCacheEntry(vbNull, cacheEntryInfoBuffer, intCacheEntryInfoBufferSizeInitial)
        While (True)
            ' Now Marshal data from an unmanaged block of memory to a managed object. (INTERNET_CACHE_ENTRY_INFOA)
            internetCacheEntry = CType(Marshal.PtrToStructure(cacheEntryInfoBuffer, GetType(INTERNET_CACHE_ENTRY_INFOA)), INTERNET_CACHE_ENTRY_INFOA)
            intCacheEntryInfoBufferSizeInitial = intCacheEntryInfoBufferSize
            blnReturnValue = DeleteUrlCacheEntry(internetCacheEntry.lpszSourceUrlName)

            ' Allocate a managed String and copy unmanaged ANSI string into it.
            Marshal.PtrToStringAnsi(internetCacheEntry.lpszSourceUrlName)

            If Not IntPtr.Zero.Equals(internetCacheEntry.lpszSourceUrlName) Then
                ' Remove the cached entry.
                DeleteUrlCacheEntry(internetCacheEntry.lpszSourceUrlName)
            End If

            blnReturnValue = FindNextUrlCacheEntry(enumHandle, cacheEntryInfoBuffer, intCacheEntryInfoBufferSizeInitial)
            If (Not blnReturnValue And ERROR_NO_MORE_ITEMS.Equals(Marshal.GetLastWin32Error())) Then
                Exit While
            End If

            If (Not blnReturnValue And intCacheEntryInfoBufferSizeInitial > intCacheEntryInfoBufferSize) Then
                intCacheEntryInfoBufferSize = intCacheEntryInfoBufferSizeInitial
                Dim tempIntPtr As New IntPtr(intCacheEntryInfoBufferSize)
                cacheEntryInfoBuffer = Marshal.ReAllocHGlobal(cacheEntryInfoBuffer, tempIntPtr)
                blnReturnValue = FindNextUrlCacheEntry(enumHandle, cacheEntryInfoBuffer, intCacheEntryInfoBufferSizeInitial)
            ElseIf (Not blnReturnValue And intCacheEntryInfoBufferSizeInitial = 0 And intCacheEntryInfoBufferSize = 0) Then
                Exit While ' No more left.
            End If
        End While

        ' Now free previously allocated memory.
        Marshal.FreeHGlobal(cacheEntryInfoBuffer)

        CleanTempInternet()

    End Function

    ' Clean the temparory internet files folder.
    Private Function CleanTempInternet()
        Try
            _TempInternet = Environment.GetFolderPath(Environment.SpecialFolder.InternetCache)
            ' Delete index.dat from Temporary Internet files.
            DeleteFile(CheckPath(_TempInternet) & "Content.IE5\index.dat")
            ' Get the folder.
            _Folders = Directory.GetDirectories(CheckPath(_TempInternet) & "Content.IE5")

            For Each _Folder In _Folders
                _Files = Directory.GetFiles(_Folder) ' Get all the files in the folder.
                For Each _File In _Files ' Run through each file .
                    DeleteFile(_File)
                Next
                Directory.Delete(_Folder)
            Next
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
    End Function

    ' Clean Windows temp folder.
    Public Function CleanTempFolder(ByVal intOverwriteNum As Integer)
        Try
            _Temp = Path.GetTempPath
            ShredSubFolder(_Temp, intOverwriteNum)
        Catch ex As Exception
        End Try
    End Function

    ' Clean the Run dialog box recent files. Only refreshes after computer reboots.
    Public Function CleanRun()
        Dim strCount As String
        Dim i As Integer

        Try
            _keyName = "Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
            strCount = (MyReg.GetString(CurrentUser, _keyName, "MRUList"))
            ' Delete all the sub keys.
            For i = 1 To strCount.Length
                MyReg.DeleteValue(CurrentUser, _keyName, strCount.Substring(i - 1, 1))
            Next
            ' Set the MRUList to nothing.
            MyReg.SetString(CurrentUser, _keyName, "MRUList", "")
        Catch ex As Exception
        End Try
    End Function

    ' Clean Recent Document list.
    Public Function CleanRecentDocs()
        Try
            SHAddToRecentDocs(0, 0)
            _keyName = "Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"
            CurrentUser.DeleteSubKey(_keyName, False)
        Catch ex As Exception
        End Try
    End Function

    ' Clean Media player recent file list.
    Public Function CleanMediaPlayer()
        Dim i As Integer
        Dim intCount As Integer

        Try
            _keyName = "Software\Microsoft\MediaPlayer\Player"
            intCount = MyReg.CountValues(CurrentUser, _keyName)
            For i = 1 To intCount
                MyReg.DeleteValue(CurrentUser, _keyName, "File" & i)
            Next
        Catch ex As Exception
        End Try
    End Function

    ' clean Paint's recent file list.
    Public Function CleanPaint()
        Dim i As Integer
        Dim intCount As Integer

        Try
            _keyName = "Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List"
            intCount = MyReg.CountValues(CurrentUser, _keyName)
            For i = 1 To intCount
                MyReg.DeleteValue(CurrentUser, _keyName, "File" & i)
            Next
        Catch ex As Exception
        End Try
    End Function

    ' clean Adobe Acrobat recent file list.
    Public Function CleanAcrobat()
        Dim strAcrobatVer As String

        Try
            ' Get Adobe Acrobat version (5 or 6 or 7).
            strAcrobatVer = MyReg.GetString(CurrentUser, "Software\Adobe\Acrobat Reader\7.0\Language", "UI")
            If strAcrobatVer <> vbNullString Then
                strAcrobatVer = "7.0"
                CleanAcrobatFileList(strAcrobatVer)
            End If
            strAcrobatVer = MyReg.GetString(CurrentUser, "Software\Adobe\Acrobat Reader\6.0\Language", "UI")
            If strAcrobatVer <> vbNullString Then
                strAcrobatVer = "6.0"
                CleanAcrobatFileList(strAcrobatVer)
            End If
            strAcrobatVer = MyReg.GetString(CurrentUser, "Software\Adobe\Acrobat Reader\5.0\Language", "UI")
            If strAcrobatVer <> vbNullString Then
                strAcrobatVer = "5.0"
                CleanAcrobatFileList(strAcrobatVer)
            End If

        Catch ex As Exception
        End Try
    End Function

    Private Function CleanAcrobatFileList(ByVal AcrobatVersion As String)
        Dim i As Integer

        Try
            For i = 1 To 5
                _keyName = "Software\Adobe\Acrobat Reader\" & AcrobatVersion & "\AVGeneral\cRecentFiles\c" & i
                ' Delet the key.
                CurrentUser.DeleteSubKey(_keyName, False)
                ' Recreate the key, empty.
                CurrentUser.CreateSubKey(_keyName)
            Next
        Catch ex As Exception
        End Try
    End Function

    ' Clean WinRAR recent extract's list.
    Public Function CleanWinRAR()
        Dim i As Integer
        Dim intCount As Integer

        Try
            _keyName = "Software\WinRAR\ArcHistory"
            intCount = MyReg.CountValues(CurrentUser, _keyName)
            ' Remove the Archive History.
            For i = 0 To intCount - 1
                MyReg.DeleteValue(CurrentUser, _keyName, i)
            Next
            _keyName = "Software\WinRAR\DialogEditHistory\ExtrPath"
            intCount = MyReg.CountValues(CurrentUser, _keyName)
            ' Remove the extract path history.
            For i = 0 To intCount - 1
                MyReg.DeleteValue(CurrentUser, _keyName, i)
            Next
        Catch ex As Exception
        End Try
    End Function

    Public Function CleanWinzip()
        Try
            _keyName = "Software\Nico Mak Computing\Winzip\extract"
            ' Delete the key that contains the extract history.
            CurrentUser.DeleteSubKey(_keyName, False)
            ' Recreate the key, empty.
            CurrentUser.CreateSubKey(_keyName)

            _keyName = "Software\Nico Mak Computing\Winzip\filemenu"
            ' Delete the key that contains the filemenu history.
            CurrentUser.DeleteSubKey(_keyName, False)
            ' Recreate the key, empty.
            CurrentUser.CreateSubKey(_keyName)

            ' Set the default directorys.
            MyReg.SetString(CurrentUser, "Software\Nico Mak Computing\Winzip\directories", "DefDir", "C:\")
            MyReg.SetString(CurrentUser, "Software\Nico Mak Computing\Winzip\directories", "ExtractTo", "C:\")
        Catch ex As Exception
        End Try
    End Function
End Class
