Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class Form1
	Inherits System.Windows.Forms.Form
	
	Private Declare Function RegOpenKeyEx Lib "advapi32.dll"  Alias "RegOpenKeyExA"(ByVal hKey As Integer, ByVal lpSubKey As String, ByVal ulOptions As Integer, ByVal samDesired As Integer, ByRef phkResult As Integer) As Integer
	Private Declare Function RegEnumKey Lib "advapi32.dll"  Alias "RegEnumKeyA"(ByVal hKey As Integer, ByVal dwIndex As Integer, ByVal lpName As String, ByVal cbName As Integer) As Integer
	Private Declare Function RegQueryValue Lib "advapi32.dll"  Alias "RegQueryValueA"(ByVal hKey As Integer, ByVal lpSubKey As String, ByVal lpValue As String, ByRef lpcbValue As Integer) As Integer
	Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Integer) As Integer
	Private Declare Function RegEnumValue Lib "advapi32.dll"  Alias "RegEnumValueA"(ByVal hKey As Integer, ByVal dwIndex As Integer, ByVal lpValueName As String, ByRef lpcbValueName As Integer, ByVal lpReserved As Integer, ByRef lpType As Integer, ByRef lpData As Byte, ByRef lpcbData As Integer) As Integer
	
	Private Const ERROR_SUCCESS As Short = 0
	
	Private Const HKEY_CLASSES_ROOT As Integer = &H80000000
	Private Const HKEY_CURRENT_CONFIG As Integer = &H80000005
	Private Const HKEY_CURRENT_USER As Integer = &H80000001
	Private Const HKEY_LOCAL_MACHINE As Integer = &H80000002
	Private Const HKEY_USERS As Integer = &H80000003
	
	Private Const STANDARD_RIGHTS_ALL As Integer = &H1F0000
	Private Const KEY_QUERY_VALUE As Integer = &H1
	Private Const KEY_SET_VALUE As Integer = &H2
	Private Const KEY_CREATE_SUB_KEY As Integer = &H4
	Private Const KEY_ENUMERATE_SUB_KEYS As Integer = &H8
	Private Const KEY_NOTIFY As Integer = &H10
	Private Const KEY_CREATE_LINK As Integer = &H20
	Private Const SYNCHRONIZE As Integer = &H100000
	Private Const KEY_ALL_ACCESS As Boolean = ((STANDARD_RIGHTS_ALL Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))
	Private Const ERROR_NO_MORE_ITEMS As Short = 259
	
	Private m_SelectedSection As Integer
	
	Private Const REG_BINARY As Short = 3
	Private Const REG_DWORD As Short = 4
	Private Const REG_DWORD_BIG_ENDIAN As Short = 5
	Private Const REG_DWORD_LITTLE_ENDIAN As Short = 4
	Private Const REG_EXPAND_SZ As Short = 2
	Private Const REG_FULL_RESOURCE_DESCRIPTOR As Short = 9
	Private Const REG_LINK As Short = 6
	Private Const REG_MULTI_SZ As Short = 7
	Private Const REG_NONE As Short = 0
	Private Const REG_RESOURCE_LIST As Short = 8
	Private Const REG_RESOURCE_REQUIREMENTS_LIST As Short = 10
	Private Const REG_SZ As Short = 1
	' Get the key information for this key and
	' its subkeys.
	Private Function GetKeyInfo(ByVal section As Integer, ByVal key_name As String, ByVal indent As Short) As String
		Dim subkeys As Collection
		Dim subkey_values As Collection
		Dim subkey_num As Short
		Dim subkey_name As String
		Dim subkey_value As String
		Dim length As Integer
		Dim hKey As Integer
		Dim txt As String
		Dim subkey_txt As String
		Dim value_num As Integer
		Dim value_name_len As Integer
		Dim value_name As String
		Dim reserved As Integer
		Dim value_type As Integer
		Dim value_string As String
		'UPGRADE_WARNING: Lower bound of array value_data was changed from 1 to 0. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="0F1C9BE1-AF9D-476E-83B1-17D43BECFF20"'
		Dim value_data(1024) As Byte
		Dim value_data_len As Integer
		Dim i As Short
		
		subkeys = New Collection
		subkey_values = New Collection
		
		' Open the key.
		If RegOpenKeyEx(section, key_name, 0, KEY_ALL_ACCESS, hKey) <> ERROR_SUCCESS Then
			MsgBox("Error opening key.")
			Exit Function
		End If
		
		' Enumerate the key's values.
		value_num = 0
		Do 
			value_name_len = 1024
			value_name = Space(value_name_len)
			value_data_len = 1024
			
			If RegEnumValue(hKey, value_num, value_name, value_name_len, 0, value_type, value_data(1), value_data_len) <> ERROR_SUCCESS Then Exit Do
			
			value_name = VB.Left(value_name, value_name_len)
			
			Select Case value_type
				Case REG_BINARY
					txt = txt & Space(indent) & "> " & value_name & " = [binary]" & vbCrLf
				Case REG_DWORD
					value_string = "&H" & VB6.Format(Hex(value_data(4)), "00") & VB6.Format(Hex(value_data(3)), "00") & VB6.Format(Hex(value_data(2)), "00") & VB6.Format(Hex(value_data(1)), "00")
					txt = txt & Space(indent) & "> " & value_name & " = " & value_string & vbCrLf
				Case REG_DWORD_BIG_ENDIAN
					txt = txt & Space(indent) & "> " & value_name & " = [dword big endian]" & vbCrLf
				Case REG_DWORD_LITTLE_ENDIAN
					txt = txt & Space(indent) & "> " & value_name & " = [dword little endian]" & vbCrLf
				Case REG_EXPAND_SZ
					txt = txt & Space(indent) & "> " & value_name & " = [expand sz]" & vbCrLf
				Case REG_FULL_RESOURCE_DESCRIPTOR
					txt = txt & Space(indent) & "> " & value_name & " = [full resource descriptor]" & vbCrLf
				Case REG_LINK
					txt = txt & Space(indent) & "> " & value_name & " = [link]" & vbCrLf
				Case REG_MULTI_SZ
					txt = txt & Space(indent) & "> " & value_name & " = [multi sz]" & vbCrLf
				Case REG_NONE
					txt = txt & Space(indent) & "> " & value_name & " = [none]" & vbCrLf
				Case REG_RESOURCE_LIST
					txt = txt & Space(indent) & "> " & value_name & " = [resource list]" & vbCrLf
				Case REG_RESOURCE_REQUIREMENTS_LIST
					txt = txt & Space(indent) & "> " & value_name & " = [resource requirements list]" & vbCrLf
				Case REG_SZ
					value_string = ""
					For i = 1 To value_data_len - 1
						value_string = value_string & Chr(value_data(i))
					Next i
					txt = txt & Space(indent) & "> " & value_name & " = """ & value_string & """" & vbCrLf
			End Select
			
			value_num = value_num + 1
		Loop 
		
		' Enumerate the subkeys.
		subkey_num = 0
		Do 
			' Enumerate subkeys until we get an error.
			length = 256
			subkey_name = Space(length)
			If RegEnumKey(hKey, subkey_num, subkey_name, length) <> ERROR_SUCCESS Then Exit Do
			subkey_num = subkey_num + 1
			
			subkey_name = VB.Left(subkey_name, InStr(subkey_name, Chr(0)) - 1)
			subkeys.Add(subkey_name)
			
			' Get the subkey's value.
			length = 256
			subkey_value = Space(length)
			If RegQueryValue(hKey, subkey_name, subkey_value, length) <> ERROR_SUCCESS Then
				subkey_values.Add("Error")
			Else
				' Remove the trailing null character.
				subkey_value = VB.Left(subkey_value, length - 1)
				subkey_values.Add(subkey_value)
			End If
		Loop 
		
		' Close the key.
		If RegCloseKey(hKey) <> ERROR_SUCCESS Then
			MsgBox("Error closing key.")
		End If
		
		' Recursively get information on the keys.
		For subkey_num = 1 To subkeys.Count()
			'UPGRADE_WARNING: Couldn't resolve default property of object subkeys(). Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			subkey_txt = GetKeyInfo(section, key_name & "\" & subkeys.Item(subkey_num), indent + 4)
			'UPGRADE_WARNING: Couldn't resolve default property of object subkey_values(subkey_num). Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			'UPGRADE_WARNING: Couldn't resolve default property of object subkeys(subkey_num). Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			txt = txt & Space(indent) & subkeys.Item(subkey_num) & ": " & subkey_values.Item(subkey_num) & vbCrLf & subkey_txt
		Next subkey_num
		
		GetKeyInfo = txt
	End Function
	
	Private Sub Command1_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Command1.Click
		txtKeys.Text = Text1.Text & vbCrLf & GetKeyInfo(m_SelectedSection, Text1.Text, 4)
	End Sub
	
	Private Sub Form1_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		Option1(2).Checked = True
		Text1.Text = "RemoteAccess"
	End Sub
	
	'UPGRADE_WARNING: Event Form1.Resize may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub Form1_Resize(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Resize
		Dim hgt As Single
		Dim wid As Single
		
		hgt = VB6.PixelsToTwipsY(ClientRectangle.Height) - VB6.PixelsToTwipsY(txtKeys.Top)
		If hgt < 120 Then hgt = 120
		txtKeys.SetBounds(0, txtKeys.Top, ClientRectangle.Width, VB6.TwipsToPixelsY(hgt))
		
		wid = VB6.PixelsToTwipsX(ClientRectangle.Width) - VB6.PixelsToTwipsX(Text1.Left)
		If wid < 120 Then wid = 120
		Text1.Width = VB6.TwipsToPixelsX(wid)
	End Sub
	
	
	'UPGRADE_WARNING: Event Option1.CheckedChanged may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub Option1_CheckedChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Option1.CheckedChanged
		If eventSender.Checked Then
			Dim Index As Short = Option1.GetIndex(eventSender)
			' Save the selected section number.
			m_SelectedSection = CInt(Option1(Index).Tag)
		End If
	End Sub
End Class