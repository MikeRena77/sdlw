Imports System
Imports System.IO

Public Class frmMain
    Inherits System.Windows.Forms.Form

    Enum PLType
        pM3U = 0
        pASX
        p3MP
        pWPL
        pPLS
        pHTM
        pTXT
    End Enum

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents tabMain As System.Windows.Forms.TabControl
    Friend WithEvents tpgOptions As System.Windows.Forms.TabPage
    Friend WithEvents tpgResults As System.Windows.Forms.TabPage
    Friend WithEvents cmdStart As System.Windows.Forms.Button
    Friend WithEvents cmdClose As System.Windows.Forms.Button
    Friend WithEvents grpOptions As System.Windows.Forms.GroupBox
    Friend WithEvents lblFolderPL As System.Windows.Forms.Label
    Friend WithEvents lnkBrowsePL As System.Windows.Forms.LinkLabel
    Friend WithEvents txtFolderPL As System.Windows.Forms.TextBox
    Friend WithEvents lblInfo2 As System.Windows.Forms.Label
    Friend WithEvents cmbFormat As System.Windows.Forms.ComboBox
    Friend WithEvents lblFormat As System.Windows.Forms.Label
    Friend WithEvents lnkBrowseMP3 As System.Windows.Forms.LinkLabel
    Friend WithEvents lblFolderMP3 As System.Windows.Forms.Label
    Friend WithEvents txtFolderMP3 As System.Windows.Forms.TextBox
    Friend WithEvents lblInfo1 As System.Windows.Forms.Label
    Friend WithEvents grpResults As System.Windows.Forms.GroupBox
    Friend WithEvents pbrProgress As System.Windows.Forms.ProgressBar
    Friend WithEvents lstArtists As System.Windows.Forms.ListBox
    Friend WithEvents lblArtists As System.Windows.Forms.Label
    Friend WithEvents nudSongs As System.Windows.Forms.NumericUpDown
    Friend WithEvents lblSide2 As System.Windows.Forms.Label
    Friend WithEvents lnkReverb As System.Windows.Forms.LinkLabel
    Friend WithEvents lblSide1 As System.Windows.Forms.Label
    Friend WithEvents chkAll As System.Windows.Forms.CheckBox
    Friend WithEvents lblMin As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmMain))
        Me.tabMain = New System.Windows.Forms.TabControl()
        Me.tpgOptions = New System.Windows.Forms.TabPage()
        Me.lblSide2 = New System.Windows.Forms.Label()
        Me.grpOptions = New System.Windows.Forms.GroupBox()
        Me.chkAll = New System.Windows.Forms.CheckBox()
        Me.nudSongs = New System.Windows.Forms.NumericUpDown()
        Me.lblMin = New System.Windows.Forms.Label()
        Me.lblFolderPL = New System.Windows.Forms.Label()
        Me.lnkBrowsePL = New System.Windows.Forms.LinkLabel()
        Me.txtFolderPL = New System.Windows.Forms.TextBox()
        Me.lblInfo2 = New System.Windows.Forms.Label()
        Me.cmbFormat = New System.Windows.Forms.ComboBox()
        Me.lblFormat = New System.Windows.Forms.Label()
        Me.lnkBrowseMP3 = New System.Windows.Forms.LinkLabel()
        Me.lblFolderMP3 = New System.Windows.Forms.Label()
        Me.txtFolderMP3 = New System.Windows.Forms.TextBox()
        Me.lblInfo1 = New System.Windows.Forms.Label()
        Me.tpgResults = New System.Windows.Forms.TabPage()
        Me.lblSide1 = New System.Windows.Forms.Label()
        Me.grpResults = New System.Windows.Forms.GroupBox()
        Me.pbrProgress = New System.Windows.Forms.ProgressBar()
        Me.lstArtists = New System.Windows.Forms.ListBox()
        Me.lblArtists = New System.Windows.Forms.Label()
        Me.cmdClose = New System.Windows.Forms.Button()
        Me.cmdStart = New System.Windows.Forms.Button()
        Me.lnkReverb = New System.Windows.Forms.LinkLabel()
        Me.tabMain.SuspendLayout()
        Me.tpgOptions.SuspendLayout()
        Me.grpOptions.SuspendLayout()
        CType(Me.nudSongs, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.tpgResults.SuspendLayout()
        Me.grpResults.SuspendLayout()
        Me.SuspendLayout()
        '
        'tabMain
        '
        Me.tabMain.Controls.AddRange(New System.Windows.Forms.Control() {Me.tpgOptions, Me.tpgResults})
        Me.tabMain.Location = New System.Drawing.Point(4, 4)
        Me.tabMain.Name = "tabMain"
        Me.tabMain.SelectedIndex = 0
        Me.tabMain.Size = New System.Drawing.Size(392, 272)
        Me.tabMain.TabIndex = 0
        '
        'tpgOptions
        '
        Me.tpgOptions.Controls.AddRange(New System.Windows.Forms.Control() {Me.lblSide2, Me.grpOptions})
        Me.tpgOptions.Location = New System.Drawing.Point(4, 26)
        Me.tpgOptions.Name = "tpgOptions"
        Me.tpgOptions.Size = New System.Drawing.Size(384, 242)
        Me.tpgOptions.TabIndex = 0
        Me.tpgOptions.Text = "Options"
        '
        'lblSide2
        '
        Me.lblSide2.BackColor = System.Drawing.SystemColors.AppWorkspace
        Me.lblSide2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSide2.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.lblSide2.Font = New System.Drawing.Font("Franklin Gothic Book", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSide2.ForeColor = System.Drawing.SystemColors.ControlLight
        Me.lblSide2.Location = New System.Drawing.Point(4, 6)
        Me.lblSide2.Name = "lblSide2"
        Me.lblSide2.Size = New System.Drawing.Size(40, 230)
        Me.lblSide2.TabIndex = 3
        Me.lblSide2.Text = "Reverb"
        Me.lblSide2.TextAlign = System.Drawing.ContentAlignment.BottomCenter
        '
        'grpOptions
        '
        Me.grpOptions.Controls.AddRange(New System.Windows.Forms.Control() {Me.chkAll, Me.nudSongs, Me.lblMin, Me.lblFolderPL, Me.lnkBrowsePL, Me.txtFolderPL, Me.lblInfo2, Me.cmbFormat, Me.lblFormat, Me.lnkBrowseMP3, Me.lblFolderMP3, Me.txtFolderMP3, Me.lblInfo1})
        Me.grpOptions.Location = New System.Drawing.Point(48, 0)
        Me.grpOptions.Name = "grpOptions"
        Me.grpOptions.Size = New System.Drawing.Size(332, 236)
        Me.grpOptions.TabIndex = 0
        Me.grpOptions.TabStop = False
        '
        'chkAll
        '
        Me.chkAll.Location = New System.Drawing.Point(8, 168)
        Me.chkAll.Name = "chkAll"
        Me.chkAll.Size = New System.Drawing.Size(220, 20)
        Me.chkAll.TabIndex = 36
        Me.chkAll.Text = "Create one playlist for all my MP3s"
        '
        'nudSongs
        '
        Me.nudSongs.Location = New System.Drawing.Point(196, 52)
        Me.nudSongs.Maximum = New Decimal(New Integer() {50, 0, 0, 0})
        Me.nudSongs.Minimum = New Decimal(New Integer() {2, 0, 0, 0})
        Me.nudSongs.Name = "nudSongs"
        Me.nudSongs.ReadOnly = True
        Me.nudSongs.Size = New System.Drawing.Size(76, 22)
        Me.nudSongs.TabIndex = 35
        Me.nudSongs.Value = New Decimal(New Integer() {5, 0, 0, 0})
        '
        'lblMin
        '
        Me.lblMin.Location = New System.Drawing.Point(8, 56)
        Me.lblMin.Name = "lblMin"
        Me.lblMin.Size = New System.Drawing.Size(176, 16)
        Me.lblMin.TabIndex = 34
        Me.lblMin.Text = "Minimum songs by each artist:"
        '
        'lblFolderPL
        '
        Me.lblFolderPL.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFolderPL.Location = New System.Drawing.Point(8, 112)
        Me.lblFolderPL.Name = "lblFolderPL"
        Me.lblFolderPL.Size = New System.Drawing.Size(64, 16)
        Me.lblFolderPL.TabIndex = 33
        Me.lblFolderPL.Text = "PL Folder:"
        '
        'lnkBrowsePL
        '
        Me.lnkBrowsePL.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkBrowsePL.Location = New System.Drawing.Point(276, 116)
        Me.lnkBrowsePL.Name = "lnkBrowsePL"
        Me.lnkBrowsePL.Size = New System.Drawing.Size(48, 16)
        Me.lnkBrowsePL.TabIndex = 32
        Me.lnkBrowsePL.TabStop = True
        Me.lnkBrowsePL.Text = "Browse"
        '
        'txtFolderPL
        '
        Me.txtFolderPL.BackColor = System.Drawing.SystemColors.Control
        Me.txtFolderPL.Location = New System.Drawing.Point(88, 108)
        Me.txtFolderPL.Name = "txtFolderPL"
        Me.txtFolderPL.ReadOnly = True
        Me.txtFolderPL.Size = New System.Drawing.Size(184, 22)
        Me.txtFolderPL.TabIndex = 31
        Me.txtFolderPL.Text = ""
        '
        'lblInfo2
        '
        Me.lblInfo2.Location = New System.Drawing.Point(4, 196)
        Me.lblInfo2.Name = "lblInfo2"
        Me.lblInfo2.Size = New System.Drawing.Size(320, 32)
        Me.lblInfo2.TabIndex = 30
        Me.lblInfo2.Text = "Fill in the options above and click 'Start' below to begin the process."
        '
        'cmbFormat
        '
        Me.cmbFormat.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbFormat.Font = New System.Drawing.Font("Franklin Gothic Book", 9.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmbFormat.Items.AddRange(New Object() {"M3U - Standard List", "ASX - Win Media Player", "3mP - 3mP Playa", "WPL - Win Media Player 9", "PLS - Older playlist system", "HTML - For Viewing", "TXT - For Viewing"})
        Me.cmbFormat.Location = New System.Drawing.Point(88, 136)
        Me.cmbFormat.Name = "cmbFormat"
        Me.cmbFormat.Size = New System.Drawing.Size(184, 24)
        Me.cmbFormat.TabIndex = 29
        '
        'lblFormat
        '
        Me.lblFormat.Location = New System.Drawing.Point(8, 140)
        Me.lblFormat.Name = "lblFormat"
        Me.lblFormat.Size = New System.Drawing.Size(72, 16)
        Me.lblFormat.TabIndex = 28
        Me.lblFormat.Text = "PL Format:"
        '
        'lnkBrowseMP3
        '
        Me.lnkBrowseMP3.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lnkBrowseMP3.Location = New System.Drawing.Point(276, 88)
        Me.lnkBrowseMP3.Name = "lnkBrowseMP3"
        Me.lnkBrowseMP3.Size = New System.Drawing.Size(48, 16)
        Me.lnkBrowseMP3.TabIndex = 27
        Me.lnkBrowseMP3.TabStop = True
        Me.lnkBrowseMP3.Text = "Browse"
        '
        'lblFolderMP3
        '
        Me.lblFolderMP3.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFolderMP3.Location = New System.Drawing.Point(8, 84)
        Me.lblFolderMP3.Name = "lblFolderMP3"
        Me.lblFolderMP3.Size = New System.Drawing.Size(76, 16)
        Me.lblFolderMP3.TabIndex = 26
        Me.lblFolderMP3.Text = "MP3 Folder:"
        '
        'txtFolderMP3
        '
        Me.txtFolderMP3.BackColor = System.Drawing.SystemColors.Control
        Me.txtFolderMP3.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtFolderMP3.Location = New System.Drawing.Point(88, 80)
        Me.txtFolderMP3.Name = "txtFolderMP3"
        Me.txtFolderMP3.ReadOnly = True
        Me.txtFolderMP3.Size = New System.Drawing.Size(184, 22)
        Me.txtFolderMP3.TabIndex = 25
        Me.txtFolderMP3.Text = ""
        '
        'lblInfo1
        '
        Me.lblInfo1.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblInfo1.Location = New System.Drawing.Point(8, 12)
        Me.lblInfo1.Name = "lblInfo1"
        Me.lblInfo1.Size = New System.Drawing.Size(320, 32)
        Me.lblInfo1.TabIndex = 24
        Me.lblInfo1.Text = "Reverb examines your MP3 collection, creating playlists for artists you have a mi" & _
        "nimum number of songs by."
        '
        'tpgResults
        '
        Me.tpgResults.Controls.AddRange(New System.Windows.Forms.Control() {Me.lblSide1, Me.grpResults})
        Me.tpgResults.Location = New System.Drawing.Point(4, 22)
        Me.tpgResults.Name = "tpgResults"
        Me.tpgResults.Size = New System.Drawing.Size(384, 246)
        Me.tpgResults.TabIndex = 1
        Me.tpgResults.Text = "Results"
        '
        'lblSide1
        '
        Me.lblSide1.BackColor = System.Drawing.SystemColors.AppWorkspace
        Me.lblSide1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSide1.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.lblSide1.Font = New System.Drawing.Font("Franklin Gothic Book", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSide1.ForeColor = System.Drawing.SystemColors.ControlLight
        Me.lblSide1.Location = New System.Drawing.Point(4, 6)
        Me.lblSide1.Name = "lblSide1"
        Me.lblSide1.Size = New System.Drawing.Size(40, 230)
        Me.lblSide1.TabIndex = 4
        Me.lblSide1.Text = "Reverb"
        Me.lblSide1.TextAlign = System.Drawing.ContentAlignment.BottomCenter
        '
        'grpResults
        '
        Me.grpResults.Controls.AddRange(New System.Windows.Forms.Control() {Me.pbrProgress, Me.lstArtists, Me.lblArtists})
        Me.grpResults.Location = New System.Drawing.Point(48, 0)
        Me.grpResults.Name = "grpResults"
        Me.grpResults.Size = New System.Drawing.Size(332, 236)
        Me.grpResults.TabIndex = 0
        Me.grpResults.TabStop = False
        '
        'pbrProgress
        '
        Me.pbrProgress.Location = New System.Drawing.Point(16, 200)
        Me.pbrProgress.Name = "pbrProgress"
        Me.pbrProgress.Size = New System.Drawing.Size(304, 24)
        Me.pbrProgress.TabIndex = 21
        '
        'lstArtists
        '
        Me.lstArtists.ItemHeight = 17
        Me.lstArtists.Location = New System.Drawing.Point(16, 40)
        Me.lstArtists.Name = "lstArtists"
        Me.lstArtists.Size = New System.Drawing.Size(304, 157)
        Me.lstArtists.TabIndex = 20
        '
        'lblArtists
        '
        Me.lblArtists.Location = New System.Drawing.Point(8, 16)
        Me.lblArtists.Name = "lblArtists"
        Me.lblArtists.Size = New System.Drawing.Size(124, 16)
        Me.lblArtists.TabIndex = 19
        Me.lblArtists.Text = "Created playlists for:"
        '
        'cmdClose
        '
        Me.cmdClose.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.cmdClose.Location = New System.Drawing.Point(328, 280)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.Size = New System.Drawing.Size(68, 28)
        Me.cmdClose.TabIndex = 19
        Me.cmdClose.Text = "Close"
        '
        'cmdStart
        '
        Me.cmdStart.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.cmdStart.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdStart.Location = New System.Drawing.Point(256, 280)
        Me.cmdStart.Name = "cmdStart"
        Me.cmdStart.Size = New System.Drawing.Size(68, 28)
        Me.cmdStart.TabIndex = 18
        Me.cmdStart.Text = "Start"
        '
        'lnkReverb
        '
        Me.lnkReverb.Location = New System.Drawing.Point(32, 288)
        Me.lnkReverb.Name = "lnkReverb"
        Me.lnkReverb.Size = New System.Drawing.Size(192, 16)
        Me.lnkReverb.TabIndex = 25
        Me.lnkReverb.TabStop = True
        Me.lnkReverb.Text = "Reverb :: (c) 2002 tHe_cLeanER"
        '
        'frmMain
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(6, 15)
        Me.ClientSize = New System.Drawing.Size(402, 313)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.lnkReverb, Me.cmdClose, Me.cmdStart, Me.tabMain})
        Me.Font = New System.Drawing.Font("Franklin Gothic Book", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.Name = "frmMain"
        Me.Text = "Reverb :: Auto Playlist Creation"
        Me.tabMain.ResumeLayout(False)
        Me.tpgOptions.ResumeLayout(False)
        Me.grpOptions.ResumeLayout(False)
        CType(Me.nudSongs, System.ComponentModel.ISupportInitialize).EndInit()
        Me.tpgResults.ResumeLayout(False)
        Me.grpResults.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Function CheckFields() As Boolean
        Dim bCheck1, bCheck2 As Boolean
        Dim dTest As Directory

        If txtFolderMP3.Text <> "" Then
            If Not dTest.Exists(txtFolderMP3.Text) Then
                MessageBox.Show("No MP3 source folder selected. Please rectify on the 'Options' tab", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Else
                bCheck1 = True
            End If
        End If

        If txtFolderPL.Text <> "" Then
            If Not dTest.Exists(txtFolderPL.Text) Then
                MessageBox.Show("No playlist destination folder selected. Please rectify on the 'Options' tab", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Else
                bCheck2 = True
            End If
        End If

        If bCheck1 And bCheck2 Then
            Return True
        End If
    End Function

    Private Sub lnkBrowseMP3_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkBrowseMP3.LinkClicked
        Dim bFolder As BrowseForFolder = New BrowseForFolder()
        txtFolderMP3.Text = bFolder.BrowseDialog("Select MP3 Folder")
    End Sub

    Private Sub lnkBrowsePL_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkBrowsePL.LinkClicked
        Dim bFolder As BrowseForFolder = New BrowseForFolder()
        txtFolderPL.Text = bFolder.BrowseDialog("Select Playlist Folder")
    End Sub

    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        txtFolderMP3.Text = GetSetting("Reverb", "Settings", "txtFolderMP3.Text")
        txtFolderPL.Text = GetSetting("Reverb", "Settings", "txtFolderPL.Text")
        nudSongs.Value = CDec(GetSetting("Reverb", "Settings", "nudSongs.Value", "5"))

        cmbFormat.SelectedIndex = CInt(GetSetting("Reverb", "Settings", "cmbformat.SelectedIndex", "0"))

        tpgResults.Enabled = False
    End Sub

    Private Sub cmdClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClose.Click
        Me.Close()
    End Sub

    Sub Shutdown()
        Call SaveSetting("Reverb", "Settings", "txtFolderMP3.Text", txtFolderMP3.Text)
        Call SaveSetting("Reverb", "Settings", "txtFolderPL.Text", txtFolderPL.Text)
        Call SaveSetting("Reverb", "Settings", "nudSongs.Value", nudSongs.Value.ToString)
        Call SaveSetting("Reverb", "Settings", "cmbformat.SelectedIndex", cmbFormat.SelectedIndex.ToString)
    End Sub

    Private Sub cmdStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdStart.Click
        Static iState As Integer

        Static tStart As Threading.Thread = New Threading.Thread(AddressOf StartGen)

        If iState = 0 Then
            If CheckFields() = True Then
                iState = 1
                cmdStart.Text = "Stop"
                tabMain.SelectedTab = tpgResults
                tpgOptions.Enabled = False
                tpgResults.Enabled = True

                tStart.Start()

                Do Until tStart.ThreadState = Threading.ThreadState.Stopped
                    Application.DoEvents()
                    Application.DoEvents()
                Loop

                iState = 2
                cmdStart.Text = "Reset"
            End If

        ElseIf iState = 1 Then
            tStart.Suspend()
            If MessageBox.Show("Cancel the process? This is not recommended in the middle of generating playlists.", "Confirm Stop", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) = DialogResult.OK Then
                tStart.Resume()
                tStart.Abort()
            Else
                tStart.Resume()
            End If

        ElseIf iState = 2 Then
            iState = 0

            tabMain.SelectedTab = tpgOptions
            tpgOptions.Enabled = True
            tpgResults.Enabled = False
            cmdStart.Text = "Start"
            lstArtists.Items.Clear()
            pbrProgress.Value = pbrProgress.Minimum

            tStart = New Threading.Thread(AddressOf StartGen)
        End If
    End Sub

    Sub StartGen()
        Dim dMP3 As DirectoryInfo = New DirectoryInfo(txtFolderMP3.Text)
        Dim fSongArray() As FileInfo = dMP3.GetFiles("*.mp3")
        Dim iCurrent As Integer

        Dim sArtistArray() As String
        Dim sArtistName As String

        Dim dStart As Date = Date.Now

        If chkAll.Checked = True Then
            pbrProgress.Value = 30
            lstArtists.Items.Add("All files in MP3 folder")
            pbrProgress.Value = 50
            Dim sFiles() As String = FilterArtists("", fSongArray)
            pbrProgress.Value = 80
            Call WritePL(sFiles, txtFolderPL.Text & "FullPlaylist", CType(cmbFormat.SelectedIndex, PLType))
            pbrProgress.Value = 100
        Else
            pbrProgress.Maximum = fSongArray.GetUpperBound(0)

            For iCurrent = 0 To fSongArray.GetUpperBound(0)
                pbrProgress.Value = iCurrent

                sArtistName = fSongArray(iCurrent).Name

                If sArtistName.IndexOf(" - ") > -1 Then
                    sArtistName = sArtistName.Substring(0, sArtistName.IndexOf(" - ") + 2)
                    sArtistArray = FilterArtists(sArtistName, fSongArray)

                    If sArtistArray.GetUpperBound(0) >= nudSongs.Value Then
                        Call WritePL(sArtistArray, txtFolderPL.Text & sArtistName.Substring(0, sArtistName.Length - 2).Trim, CType(cmbFormat.SelectedIndex, PLType))
                        lstArtists.Items.Add(sArtistName.Substring(0, sArtistName.Length - 2))
                    End If

                    iCurrent = iCurrent + sArtistArray.GetUpperBound(0) + 1
                End If
            Next
        End If
        Dim dEnd As Date = Date.Now
        Dim tTimeTaken As TimeSpan = dEnd.UtcNow.Subtract(dStart)

        MessageBox.Show("Process completed successfully. There were no errors." & vbLf & vbLf & _
            "Stats:" & vbLf & "Time taken (ms): " & tTimeTaken.TotalMilliseconds & vbLf & _
            "  Files processed: " & fSongArray.GetUpperBound(0) & vbLf & _
            "  Playlists created: " & lstArtists.Items.Count & vbLf & vbLf & _
            "  Reverb :: (c) 2003 tHe_cLeanER", "Complete", MessageBoxButtons.OK, MessageBoxIcon.Information)

    End Sub

    Function FilterArtists(ByVal sName As String, ByRef fFileArray() As FileInfo) As String()
        Dim fFile As FileInfo
        Dim sFileList As String

        sName = sName.ToLower

        For Each fFile In fFileArray
            If fFile.Name.Length >= sName.Length Then
                If fFile.Name.Substring(0, sName.Length).ToLower = sName Then
                    sFileList &= fFile.FullName & vbLf
                End If
            End If
        Next

        sFileList = sFileList.Substring(0, sFileList.Length - 1)
        Return sFileList.Split(CChar(vbLf))

    End Function

    Sub WritePL(ByVal sArray() As String, ByVal sFilename As String, ByVal pFormat As PLType)

        Select Case pFormat

            Case PLType.pM3U
                Dim fPL As StreamWriter = New StreamWriter(sFilename & ".m3u", False)
                Dim sMP3 As String

                For Each sMP3 In sArray
                    fPL.WriteLine(sMP3)
                Next

                fPL.Close()

            Case PLType.pASX
                Dim fPL As StreamWriter = New StreamWriter(sFilename & ".asx", False)
                Dim sMP3 As String

                fPL.WriteLine("<ASX Version = ""3.0"" >")
                fPL.WriteLine(vbTab & "<Param Name = ""Name"" Value = ""Reverb Generated PL - ASX Format - http://thecleaner.publication.org.uk/reverb"" />")
                fPL.WriteLine(vbTab & "<Param Name = ""AllowShuffle"" Value = ""yes"" />")

                For Each sMP3 In sArray
                    fPL.WriteLine(vbTab & "<Entry>")
                    fPL.WriteLine(vbTab & vbTab & "<Param Name = ""name"" Value = """ & smp3 & """ />")
                    fPL.WriteLine(vbTab & vbTab & "<ref href = """ & RemovePath(smp3) & """ />")
                    fPL.WriteLine(vbTab & "</Entry>")
                Next

                fpl.WriteLine("</asx>")

                fPL.Close()

            Case PLType.p3MP
                Dim fPL As StreamWriter = New StreamWriter(sFilename & ".3mp", False)
                Dim iCurrent As Integer

                fPL.WriteLine("[Full]")
                For iCurrent = 0 To sArray.GetUpperBound(0)
                    fpl.WriteLine(iCurrent + 1 & "=" & sArray(iCurrent))
                Next

                fPL.WriteLine("[Cosmetic]")
                For iCurrent = 0 To sArray.GetUpperBound(0)
                    fpl.WriteLine(iCurrent + 1 & "=" & RemovePath(sArray(iCurrent)))
                Next

                fPL.WriteLine("[Tracks]")
                fPL.WriteLine("Number=" & sArray.GetUpperBound(0) + 1)

                fpl.Close()

            Case PLType.pWPL
                Dim fPL As StreamWriter = New StreamWriter(sFilename & ".wpl", False)
                Dim sMP3 As String

                fpl.WriteLine("<?wpl version=""1.0""?>")
                fpl.WriteLine("<smil>")
                fpl.WriteLine(vbTab & "<head>")
                fpl.WriteLine(vbTab & vbTab & "<meta name=""Generator"" content=""Generated by Reverb :: http://thecleaner.publication.org.uk/reverb""/>")
                fpl.WriteLine(vbTab & vbTab & "<title>My Playlist - Reverb</title>")
                fpl.WriteLine(vbTab & "</head>")
                fpl.WriteLine(vbTab & "<body>")
                fpl.WriteLine(vbTab & vbTab & "<seq>")

                For Each sMP3 In sArray
                    fpl.WriteLine(vbTab & vbTab & vbTab & "<media src=""" & smp3 & """/>")
                Next

                fpl.WriteLine(vbTab & vbTab & "</seq>")
                fpl.WriteLine(vbTab & "</body>")
                fpl.WriteLine("</smil>")

                fpl.Close()

            Case PLType.pPLS
                Dim fPL As StreamWriter = New StreamWriter(sFilename & ".pls", False)
                Dim iCurrent As Integer

                fpl.WriteLine("[Playlist]")
                fpl.WriteLine("numberofentries=" & sArray.GetUpperBound(0))

                For iCurrent = 0 To sArray.GetUpperBound(0)
                    fpl.WriteLine("File" & iCurrent + 1 & "=" & sArray(icurrent))
                    fpl.WriteLine("Title" & iCurrent + 1 & "=" & RemovePath(sArray(icurrent)))
                Next

                fpl.Close()

            Case PLType.pHTM
                Dim fPL As StreamWriter = New StreamWriter(sFilename & ".htm", False)
                Dim sMP3 As String

                fpl.WriteLine("<html>")
                fpl.WriteLine(vbTab & "<head>")
                fpl.WriteLine(vbTab & vbTab & "<title>Reverb Generated Playlist</title>")
                fpl.WriteLine(vbTab & "</head>")
                fpl.WriteLine(vbTab & "<body leftmargin=50 bgcolor=""" & GenColor() & """ link=""black"" alink=""black"" vlink=""black"">")

                fpl.WriteLine(vbTab & vbTab & "<font face=""tahoma"" size=5>HTML playlist :: Click a song to play it in your default player.</font><p><hr><p>")

                For Each sMP3 In sArray
                    fpl.WriteLine(vbTab & vbTab & "&nbsp;&nbsp;&nbsp;<font face=""tahoma"" size=3><a href=""file://" & smp3.Replace("\", "/") & """>" & RemovePath(sMp3) & "</a></font><br><br>")
                Next

                fpl.WriteLine(vbTab & vbTab & "<font face=""tahoma"" size=2>Created by Reverb :: <a href=""http://thecleaner.publication.org.uk/reverb"">Web Site (Updates, source code etc)</a> :: (c) 2003 tHe_cLeanER</font>")
                fpl.WriteLine(vbTab & "</body>")
                fpl.WriteLine("</html>")

                fpl.Close()

            Case PLType.pTXT
                Dim fPL As StreamWriter = New StreamWriter(sFilename & ".txt", False)
                Dim sMP3 As String

                For Each sMP3 In sArray
                    fpl.WriteLine(sMp3)
                Next

                fpl.WriteLine(vbCrLf & vbCrLf & "Created by Reverb :: http://thecleaner.publication.org.uk/reverb - Web Site (Updates, source code etc) :: (c) 2003 tHe_cLeanER")
                fpl.Close()
        End Select
    End Sub

    Function GenColor() As String
        Dim rLetter As Random = New Random()
        Dim iLetter1 As Integer = rLetter.Next(0, 6)
        Dim iLetter2 As Integer = rLetter.Next(0, 6)
        Dim iLetter3 As Integer = rLetter.Next(0, 6)
        Dim cArray() As String = {"A", "B", "C", "D", "E", "F", "G"}

        Return "#C4" & cArray(iLetter1) & cArray(iLetter2) & cArray(iLetter3) & "5"

    End Function

    Function RemovePath(ByVal sFilename As String) As String
        Return sFilename.Substring(InStrRev(sFilename, "\")).Replace(".mp3", "")
    End Function

    Private Sub frmMain_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        Call Shutdown()
    End Sub

    Private Sub lnkReverb_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkReverb.LinkClicked
        Try
            Shell("explorer http://thecleaner.publication.org.uk/reverb")
        Catch
            MessageBox.Show("Could not open internet site: http://thecleaner.publication.org.uk/reverb", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
        End Try
    End Sub

    Private Sub chkAll_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkAll.CheckedChanged
        Dim bEnable As Boolean

        If chkAll.Checked = False Then
            bEnable = True
        End If

        lblMin.Visible = bEnable
        nudSongs.Visible = bEnable

    End Sub
End Class


Class BrowseForFolder
    Inherits System.Windows.Forms.Design.FolderNameEditor
    Dim bDialog As New FolderBrowser()

    Public Function BrowseDialog(ByVal sTitle As String) As String
        With bDialog
            .Style = FolderBrowserStyles.RestrictToSubfolders
            .StartLocation = FolderBrowserFolder.MyComputer
            .Description = sTitle
            .ShowDialog()
            BrowseDialog = .DirectoryPath()

            If BrowseDialog.Substring(BrowseDialog.Length - 1, 1) <> "\" Then
                BrowseDialog &= "\"
            End If

            Return BrowseDialog
        End With
    End Function
End Class
