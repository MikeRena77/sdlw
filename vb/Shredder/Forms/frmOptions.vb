Option Explicit On 

Public Class frmOptions
    Inherits System.Windows.Forms.Form

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
    Friend WithEvents btnBack As System.Windows.Forms.Button
    Friend WithEvents tbrOverwrite As System.Windows.Forms.TrackBar
    Friend WithEvents tbrTransparency As System.Windows.Forms.TrackBar
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents cbxAutoCache As System.Windows.Forms.CheckBox
    Friend WithEvents cbxAutoIE As System.Windows.Forms.CheckBox
    Friend WithEvents cbxStartup As System.Windows.Forms.CheckBox
    Friend WithEvents gbxOther As System.Windows.Forms.GroupBox
    Friend WithEvents gbxOverwrite As System.Windows.Forms.GroupBox
    Friend WithEvents gbxTransparency As System.Windows.Forms.GroupBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnBack = New System.Windows.Forms.Button
        Me.gbxOverwrite = New System.Windows.Forms.GroupBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.tbrOverwrite = New System.Windows.Forms.TrackBar
        Me.gbxTransparency = New System.Windows.Forms.GroupBox
        Me.tbrTransparency = New System.Windows.Forms.TrackBar
        Me.gbxOther = New System.Windows.Forms.GroupBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.cbxAutoCache = New System.Windows.Forms.CheckBox
        Me.cbxAutoIE = New System.Windows.Forms.CheckBox
        Me.cbxStartup = New System.Windows.Forms.CheckBox
        Me.gbxOverwrite.SuspendLayout()
        CType(Me.tbrOverwrite, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.gbxTransparency.SuspendLayout()
        CType(Me.tbrTransparency, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.gbxOther.SuspendLayout()
        Me.SuspendLayout()
        '
        'btnBack
        '
        Me.btnBack.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnBack.Location = New System.Drawing.Point(336, 160)
        Me.btnBack.Name = "btnBack"
        Me.btnBack.Size = New System.Drawing.Size(72, 24)
        Me.btnBack.TabIndex = 0
        Me.btnBack.Text = "Back"
        '
        'gbxOverwrite
        '
        Me.gbxOverwrite.Controls.Add(Me.Label2)
        Me.gbxOverwrite.Controls.Add(Me.Label1)
        Me.gbxOverwrite.Controls.Add(Me.tbrOverwrite)
        Me.gbxOverwrite.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.gbxOverwrite.Location = New System.Drawing.Point(16, 8)
        Me.gbxOverwrite.Name = "gbxOverwrite"
        Me.gbxOverwrite.Size = New System.Drawing.Size(216, 72)
        Me.gbxOverwrite.TabIndex = 1
        Me.gbxOverwrite.TabStop = False
        Me.gbxOverwrite.Text = "Overwrite data n times"
        '
        'Label2
        '
        Me.Label2.ForeColor = System.Drawing.Color.Blue
        Me.Label2.Location = New System.Drawing.Point(24, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(24, 16)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "5"
        '
        'Label1
        '
        Me.Label1.ForeColor = System.Drawing.Color.Blue
        Me.Label1.Location = New System.Drawing.Point(184, 48)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(24, 16)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "15"
        '
        'tbrOverwrite
        '
        Me.tbrOverwrite.LargeChange = 2
        Me.tbrOverwrite.Location = New System.Drawing.Point(16, 16)
        Me.tbrOverwrite.Maximum = 15
        Me.tbrOverwrite.Minimum = 5
        Me.tbrOverwrite.Name = "tbrOverwrite"
        Me.tbrOverwrite.Size = New System.Drawing.Size(192, 45)
        Me.tbrOverwrite.TabIndex = 0
        Me.tbrOverwrite.Value = 5
        '
        'gbxTransparency
        '
        Me.gbxTransparency.Controls.Add(Me.tbrTransparency)
        Me.gbxTransparency.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.gbxTransparency.Location = New System.Drawing.Point(14, 88)
        Me.gbxTransparency.Name = "gbxTransparency"
        Me.gbxTransparency.Size = New System.Drawing.Size(218, 64)
        Me.gbxTransparency.TabIndex = 2
        Me.gbxTransparency.TabStop = False
        Me.gbxTransparency.Text = "Transparency"
        '
        'tbrTransparency
        '
        Me.tbrTransparency.LargeChange = 1
        Me.tbrTransparency.Location = New System.Drawing.Point(16, 16)
        Me.tbrTransparency.Minimum = 5
        Me.tbrTransparency.Name = "tbrTransparency"
        Me.tbrTransparency.Size = New System.Drawing.Size(192, 45)
        Me.tbrTransparency.TabIndex = 0
        Me.tbrTransparency.Value = 5
        '
        'gbxOther
        '
        Me.gbxOther.Controls.Add(Me.Label3)
        Me.gbxOther.Controls.Add(Me.cbxAutoCache)
        Me.gbxOther.Controls.Add(Me.cbxAutoIE)
        Me.gbxOther.Controls.Add(Me.cbxStartup)
        Me.gbxOther.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.gbxOther.Location = New System.Drawing.Point(240, 8)
        Me.gbxOther.Name = "gbxOther"
        Me.gbxOther.Size = New System.Drawing.Size(168, 144)
        Me.gbxOther.TabIndex = 13
        Me.gbxOther.TabStop = False
        Me.gbxOther.Text = "Other"
        '
        'Label3
        '
        Me.Label3.ForeColor = System.Drawing.Color.Blue
        Me.Label3.Location = New System.Drawing.Point(16, 96)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(144, 40)
        Me.Label3.TabIndex = 16
        Me.Label3.Text = "Auto clean will clean items when last instance of Internet Explorer is closed."
        '
        'cbxAutoCache
        '
        Me.cbxAutoCache.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.cbxAutoCache.Location = New System.Drawing.Point(16, 72)
        Me.cbxAutoCache.Name = "cbxAutoCache"
        Me.cbxAutoCache.Size = New System.Drawing.Size(128, 16)
        Me.cbxAutoCache.TabIndex = 15
        Me.cbxAutoCache.Text = "Auto clean IE cache"
        '
        'cbxAutoIE
        '
        Me.cbxAutoIE.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.cbxAutoIE.Location = New System.Drawing.Point(16, 48)
        Me.cbxAutoIE.Name = "cbxAutoIE"
        Me.cbxAutoIE.Size = New System.Drawing.Size(120, 16)
        Me.cbxAutoIE.TabIndex = 14
        Me.cbxAutoIE.Text = "Auto clean IE"
        '
        'cbxStartup
        '
        Me.cbxStartup.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.cbxStartup.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cbxStartup.ForeColor = System.Drawing.Color.Black
        Me.cbxStartup.Location = New System.Drawing.Point(16, 24)
        Me.cbxStartup.Name = "cbxStartup"
        Me.cbxStartup.Size = New System.Drawing.Size(136, 16)
        Me.cbxStartup.TabIndex = 13
        Me.cbxStartup.Text = "Run at Windows startup"
        '
        'frmOptions
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(418, 192)
        Me.ControlBox = False
        Me.Controls.Add(Me.gbxOther)
        Me.Controls.Add(Me.gbxTransparency)
        Me.Controls.Add(Me.gbxOverwrite)
        Me.Controls.Add(Me.btnBack)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.Name = "frmOptions"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Options"
        Me.gbxOverwrite.ResumeLayout(False)
        CType(Me.tbrOverwrite, System.ComponentModel.ISupportInitialize).EndInit()
        Me.gbxTransparency.ResumeLayout(False)
        CType(Me.tbrTransparency, System.ComponentModel.ISupportInitialize).EndInit()
        Me.gbxOther.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private myShredder As New Shredder
    Private myReg As New Registry
    Private OptionsTooltip As New ToolTip

    Private Sub btnBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBack.Click
        MyOptions.OverwriteNumber = tbrOverwrite.Value
        MyOptions.Transparency = tbrTransparency.Value / 10
        Me.Close()
    End Sub

    Private Sub frmOptions_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        tbrOverwrite.Value = MyOptions.OverwriteNumber
        tbrTransparency.Value = MyOptions.Transparency * 10
        gbxOverwrite.Text = "Overwrite data " & tbrOverwrite.Value & " times"

        If myReg.GetString(Microsoft.Win32.Registry.CurrentUser, "Software\Microsoft\Windows\CurrentVersion\Run", "Shredder") = "0" Then
            cbxStartup.Checked = False
        Else
            cbxStartup.Checked = True
        End If
        cbxAutoCache.Checked = MyOptions.AutoCleanCache
        cbxAutoIE.Checked = MyOptions.AutoCleanIE

        OptionsTooltip.SetToolTip(cbxStartup, "Run Shredder when Windows starts.")
        OptionsTooltip.SetToolTip(cbxAutoCache, "Auto clean Internet Explorer cache when last instance of Internet Eplorer is closed.")
        OptionsTooltip.SetToolTip(cbxAutoIE, "Auto clean Internet Explorer history when last instance of Internet Eplorer is closed.")

        Me.Text = "Options for: " & Environment.UserName
    End Sub

    Private Sub tbrOverwrite_Scroll(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tbrOverwrite.Scroll
        gbxOverwrite.Text = "Overwrite data " & tbrOverwrite.Value & " times"
    End Sub

    Private Sub cbxAutoIE_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbxAutoIE.CheckedChanged
        If cbxAutoIE.CheckState = CheckState.Checked Then
            MyOptions.AutoCleanIE = True
        Else
            MyOptions.AutoCleanIE = False
        End If
    End Sub

    Private Sub cbxAutoCache_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbxAutoCache.CheckedChanged
        If cbxAutoCache.CheckState = CheckState.Checked Then
            MyOptions.AutoCleanCache = True
        Else
            MyOptions.AutoCleanCache = False
        End If
    End Sub

    Private Sub cbxStartup_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cbxStartup.CheckedChanged
        If cbxStartup.Checked Then
            ' Create registry key to start shredder when windows boots up.
            myReg.SetString(Microsoft.Win32.Registry.CurrentUser, "Software\Microsoft\Windows\CurrentVersion\Run", "Shredder", myShredder.CheckPath(Application.StartupPath) & "Shredder.exe -min")
        Else
            ' Remove the registry key.
            myReg.DeleteValue(Microsoft.Win32.Registry.CurrentUser, "Software\Microsoft\Windows\CurrentVersion\Run", "Shredder")
        End If
    End Sub
End Class
