Option Explicit On 

Public Class frmAbout
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
    Friend WithEvents lblAbout1 As System.Windows.Forms.Label
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents gbxAbout As System.Windows.Forms.GroupBox
    Friend WithEvents lblAbout2 As System.Windows.Forms.Label
    Friend WithEvents lblAuthor As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmAbout))
        Me.gbxAbout = New System.Windows.Forms.GroupBox
        Me.PictureBox1 = New System.Windows.Forms.PictureBox
        Me.lblAbout2 = New System.Windows.Forms.Label
        Me.lblAuthor = New System.Windows.Forms.Label
        Me.lblAbout1 = New System.Windows.Forms.Label
        Me.btnBack = New System.Windows.Forms.Button
        Me.gbxAbout.SuspendLayout()
        Me.SuspendLayout()
        '
        'gbxAbout
        '
        Me.gbxAbout.Controls.Add(Me.PictureBox1)
        Me.gbxAbout.Controls.Add(Me.lblAbout2)
        Me.gbxAbout.Controls.Add(Me.lblAuthor)
        Me.gbxAbout.Controls.Add(Me.lblAbout1)
        Me.gbxAbout.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.gbxAbout.Location = New System.Drawing.Point(8, 8)
        Me.gbxAbout.Name = "gbxAbout"
        Me.gbxAbout.Size = New System.Drawing.Size(320, 208)
        Me.gbxAbout.TabIndex = 0
        Me.gbxAbout.TabStop = False
        '
        'PictureBox1
        '
        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
        Me.PictureBox1.Location = New System.Drawing.Point(16, 16)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(280, 56)
        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
        Me.PictureBox1.TabIndex = 3
        Me.PictureBox1.TabStop = False
        '
        'lblAbout2
        '
        Me.lblAbout2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblAbout2.Location = New System.Drawing.Point(8, 184)
        Me.lblAbout2.Name = "lblAbout2"
        Me.lblAbout2.Size = New System.Drawing.Size(304, 16)
        Me.lblAbout2.TabIndex = 2
        Me.lblAbout2.Text = "This program is freeware and comes with no guarantees."
        '
        'lblAuthor
        '
        Me.lblAuthor.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblAuthor.Location = New System.Drawing.Point(8, 88)
        Me.lblAuthor.Name = "lblAuthor"
        Me.lblAuthor.Size = New System.Drawing.Size(168, 16)
        Me.lblAuthor.TabIndex = 1
        Me.lblAuthor.Text = "Author: Justin Yates"
        '
        'lblAbout1
        '
        Me.lblAbout1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblAbout1.Location = New System.Drawing.Point(8, 112)
        Me.lblAbout1.Name = "lblAbout1"
        Me.lblAbout1.Size = New System.Drawing.Size(304, 72)
        Me.lblAbout1.TabIndex = 0
        Me.lblAbout1.Text = "This program shreds files and folders. Cleans History, Temporary Internet files, " & _
        "Cookies, Temp folder, Media player recent file list, Paint recent file list, Rec" & _
        "ent documents, Run menu, WinRar, Winzip and the 3 INDEX.DAT files which also sto" & _
        "re your personal activities."
        '
        'btnBack
        '
        Me.btnBack.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnBack.Location = New System.Drawing.Point(256, 224)
        Me.btnBack.Name = "btnBack"
        Me.btnBack.Size = New System.Drawing.Size(72, 24)
        Me.btnBack.TabIndex = 1
        Me.btnBack.Text = "Back"
        '
        'frmAbout
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(338, 256)
        Me.ControlBox = False
        Me.Controls.Add(Me.btnBack)
        Me.Controls.Add(Me.gbxAbout)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "frmAbout"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "About Shredder"
        Me.gbxAbout.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBack.Click
        Me.Close()
    End Sub
End Class
