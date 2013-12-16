' Author    : Justin Yates                                                  '
' Program   : File Shredder - History Eraser .NET                           '
' VB ver    : VB2003.NET                                                    '
' Purpose   : Shred files so their content can't be recovered and           '
'             to clean various traces on your computer.                     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' *** Internet Explorer and Visual Studio must be closed when cleaning, *** '
' *** or your history folder won't clear.                               *** '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Note      : Most "Cleaning" programs out there and all the ones 
'             on PSC DO NOT clean index.dat. Index.dat is a file 
'             which keeps track of websites you visit. Cleaning 
'             your cookies, temp internet & history does not clean
'             index.dat, so all your traces still exist, but you
'             just don't know they do. You can't delete this file using 
'             standard delete methods, but deleting it with API will 
'             force the OS to create a new one which is clean.
'             This file can be found in three places.
'
' The three index.dat files are located at:                         
' Cookies\index.dat                                                 
' History\History.IE5\index.dat                                     
' Temporary Internet Files\Content.IE5\index.dat  

' Acknowledgements - 1. Eduardo Morcillo for his URL History Interfaces library.
'                       http://www.mvps.org/emorcillo/en/index.shtml
'                    2. MSDN 
'                       http://msdn.microsoft.com

Option Explicit On 

Imports System.IO
Imports System.Resources

Public Class frmMain
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
    Friend WithEvents NotifyIconShredder As System.Windows.Forms.NotifyIcon
    Friend WithEvents ContextMenuShredder As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuSpe As System.Windows.Forms.MenuItem
    Friend WithEvents miShow As System.Windows.Forms.MenuItem
    Friend WithEvents miExit As System.Windows.Forms.MenuItem
    Friend WithEvents imlIcons As System.Windows.Forms.ImageList
    Friend WithEvents imlTVIcons As System.Windows.Forms.ImageList
    Friend WithEvents miCleanIE As System.Windows.Forms.MenuItem
    Friend WithEvents miCleanSelected As System.Windows.Forms.MenuItem
    Friend WithEvents tvExplorer As System.Windows.Forms.TreeView
    Friend WithEvents lvFiles As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents btnShredFD As System.Windows.Forms.Button
    Friend WithEvents btnShred As System.Windows.Forms.Button
    Friend WithEvents lblDescription As System.Windows.Forms.Label
    Friend WithEvents btnSelectNone As System.Windows.Forms.Button
    Friend WithEvents btnClean As System.Windows.Forms.Button
    Friend WithEvents btnSelectall As System.Windows.Forms.Button
    Friend WithEvents lvClean As System.Windows.Forms.CheckedListBox
    Friend WithEvents picShredder As System.Windows.Forms.PictureBox
    Friend WithEvents btnOptions As System.Windows.Forms.Button
    Friend WithEvents btnAbout As System.Windows.Forms.Button
    Friend WithEvents picMin As System.Windows.Forms.PictureBox
    Friend WithEvents picClose As System.Windows.Forms.PictureBox
    Friend WithEvents picMinHover As System.Windows.Forms.PictureBox
    Friend WithEvents picCloseHover As System.Windows.Forms.PictureBox
    Friend WithEvents picMinDown As System.Windows.Forms.PictureBox
    Friend WithEvents picCloseDown As System.Windows.Forms.PictureBox
    Friend WithEvents picIcon As System.Windows.Forms.PictureBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmMain))
        Me.imlTVIcons = New System.Windows.Forms.ImageList(Me.components)
        Me.imlIcons = New System.Windows.Forms.ImageList(Me.components)
        Me.NotifyIconShredder = New System.Windows.Forms.NotifyIcon(Me.components)
        Me.ContextMenuShredder = New System.Windows.Forms.ContextMenu
        Me.miShow = New System.Windows.Forms.MenuItem
        Me.miCleanIE = New System.Windows.Forms.MenuItem
        Me.miCleanSelected = New System.Windows.Forms.MenuItem
        Me.mnuSpe = New System.Windows.Forms.MenuItem
        Me.miExit = New System.Windows.Forms.MenuItem
        Me.tvExplorer = New System.Windows.Forms.TreeView
        Me.lvFiles = New System.Windows.Forms.ListView
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.btnShredFD = New System.Windows.Forms.Button
        Me.btnShred = New System.Windows.Forms.Button
        Me.lblDescription = New System.Windows.Forms.Label
        Me.btnSelectNone = New System.Windows.Forms.Button
        Me.btnClean = New System.Windows.Forms.Button
        Me.btnSelectall = New System.Windows.Forms.Button
        Me.lvClean = New System.Windows.Forms.CheckedListBox
        Me.picShredder = New System.Windows.Forms.PictureBox
        Me.btnOptions = New System.Windows.Forms.Button
        Me.btnAbout = New System.Windows.Forms.Button
        Me.picMin = New System.Windows.Forms.PictureBox
        Me.picClose = New System.Windows.Forms.PictureBox
        Me.picMinHover = New System.Windows.Forms.PictureBox
        Me.picCloseHover = New System.Windows.Forms.PictureBox
        Me.picMinDown = New System.Windows.Forms.PictureBox
        Me.picCloseDown = New System.Windows.Forms.PictureBox
        Me.picIcon = New System.Windows.Forms.PictureBox
        Me.SuspendLayout()
        '
        'imlTVIcons
        '
        Me.imlTVIcons.ColorDepth = System.Windows.Forms.ColorDepth.Depth32Bit
        Me.imlTVIcons.ImageSize = CType(resources.GetObject("imlTVIcons.ImageSize"), System.Drawing.Size)
        Me.imlTVIcons.ImageStream = CType(resources.GetObject("imlTVIcons.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlTVIcons.TransparentColor = System.Drawing.Color.Transparent
        '
        'imlIcons
        '
        Me.imlIcons.ColorDepth = System.Windows.Forms.ColorDepth.Depth32Bit
        Me.imlIcons.ImageSize = CType(resources.GetObject("imlIcons.ImageSize"), System.Drawing.Size)
        Me.imlIcons.TransparentColor = System.Drawing.Color.Transparent
        '
        'NotifyIconShredder
        '
        Me.NotifyIconShredder.ContextMenu = Me.ContextMenuShredder
        Me.NotifyIconShredder.Icon = CType(resources.GetObject("NotifyIconShredder.Icon"), System.Drawing.Icon)
        Me.NotifyIconShredder.Text = resources.GetString("NotifyIconShredder.Text")
        Me.NotifyIconShredder.Visible = CType(resources.GetObject("NotifyIconShredder.Visible"), Boolean)
        '
        'ContextMenuShredder
        '
        Me.ContextMenuShredder.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.miShow, Me.miCleanIE, Me.miCleanSelected, Me.mnuSpe, Me.miExit})
        Me.ContextMenuShredder.RightToLeft = CType(resources.GetObject("ContextMenuShredder.RightToLeft"), System.Windows.Forms.RightToLeft)
        '
        'miShow
        '
        Me.miShow.Enabled = CType(resources.GetObject("miShow.Enabled"), Boolean)
        Me.miShow.Index = 0
        Me.miShow.Shortcut = CType(resources.GetObject("miShow.Shortcut"), System.Windows.Forms.Shortcut)
        Me.miShow.ShowShortcut = CType(resources.GetObject("miShow.ShowShortcut"), Boolean)
        Me.miShow.Text = resources.GetString("miShow.Text")
        Me.miShow.Visible = CType(resources.GetObject("miShow.Visible"), Boolean)
        '
        'miCleanIE
        '
        Me.miCleanIE.Enabled = CType(resources.GetObject("miCleanIE.Enabled"), Boolean)
        Me.miCleanIE.Index = 1
        Me.miCleanIE.Shortcut = CType(resources.GetObject("miCleanIE.Shortcut"), System.Windows.Forms.Shortcut)
        Me.miCleanIE.ShowShortcut = CType(resources.GetObject("miCleanIE.ShowShortcut"), Boolean)
        Me.miCleanIE.Text = resources.GetString("miCleanIE.Text")
        Me.miCleanIE.Visible = CType(resources.GetObject("miCleanIE.Visible"), Boolean)
        '
        'miCleanSelected
        '
        Me.miCleanSelected.Enabled = CType(resources.GetObject("miCleanSelected.Enabled"), Boolean)
        Me.miCleanSelected.Index = 2
        Me.miCleanSelected.Shortcut = CType(resources.GetObject("miCleanSelected.Shortcut"), System.Windows.Forms.Shortcut)
        Me.miCleanSelected.ShowShortcut = CType(resources.GetObject("miCleanSelected.ShowShortcut"), Boolean)
        Me.miCleanSelected.Text = resources.GetString("miCleanSelected.Text")
        Me.miCleanSelected.Visible = CType(resources.GetObject("miCleanSelected.Visible"), Boolean)
        '
        'mnuSpe
        '
        Me.mnuSpe.Enabled = CType(resources.GetObject("mnuSpe.Enabled"), Boolean)
        Me.mnuSpe.Index = 3
        Me.mnuSpe.Shortcut = CType(resources.GetObject("mnuSpe.Shortcut"), System.Windows.Forms.Shortcut)
        Me.mnuSpe.ShowShortcut = CType(resources.GetObject("mnuSpe.ShowShortcut"), Boolean)
        Me.mnuSpe.Text = resources.GetString("mnuSpe.Text")
        Me.mnuSpe.Visible = CType(resources.GetObject("mnuSpe.Visible"), Boolean)
        '
        'miExit
        '
        Me.miExit.Enabled = CType(resources.GetObject("miExit.Enabled"), Boolean)
        Me.miExit.Index = 4
        Me.miExit.Shortcut = CType(resources.GetObject("miExit.Shortcut"), System.Windows.Forms.Shortcut)
        Me.miExit.ShowShortcut = CType(resources.GetObject("miExit.ShowShortcut"), Boolean)
        Me.miExit.Text = resources.GetString("miExit.Text")
        Me.miExit.Visible = CType(resources.GetObject("miExit.Visible"), Boolean)
        '
        'tvExplorer
        '
        Me.tvExplorer.AccessibleDescription = resources.GetString("tvExplorer.AccessibleDescription")
        Me.tvExplorer.AccessibleName = resources.GetString("tvExplorer.AccessibleName")
        Me.tvExplorer.Anchor = CType(resources.GetObject("tvExplorer.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.tvExplorer.BackColor = System.Drawing.Color.Silver
        Me.tvExplorer.BackgroundImage = CType(resources.GetObject("tvExplorer.BackgroundImage"), System.Drawing.Image)
        Me.tvExplorer.Dock = CType(resources.GetObject("tvExplorer.Dock"), System.Windows.Forms.DockStyle)
        Me.tvExplorer.Enabled = CType(resources.GetObject("tvExplorer.Enabled"), Boolean)
        Me.tvExplorer.Font = CType(resources.GetObject("tvExplorer.Font"), System.Drawing.Font)
        Me.tvExplorer.ImageIndex = CType(resources.GetObject("tvExplorer.ImageIndex"), Integer)
        Me.tvExplorer.ImageList = Me.imlTVIcons
        Me.tvExplorer.ImeMode = CType(resources.GetObject("tvExplorer.ImeMode"), System.Windows.Forms.ImeMode)
        Me.tvExplorer.Indent = CType(resources.GetObject("tvExplorer.Indent"), Integer)
        Me.tvExplorer.ItemHeight = CType(resources.GetObject("tvExplorer.ItemHeight"), Integer)
        Me.tvExplorer.Location = CType(resources.GetObject("tvExplorer.Location"), System.Drawing.Point)
        Me.tvExplorer.Name = "tvExplorer"
        Me.tvExplorer.RightToLeft = CType(resources.GetObject("tvExplorer.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.tvExplorer.SelectedImageIndex = CType(resources.GetObject("tvExplorer.SelectedImageIndex"), Integer)
        Me.tvExplorer.Size = CType(resources.GetObject("tvExplorer.Size"), System.Drawing.Size)
        Me.tvExplorer.TabIndex = CType(resources.GetObject("tvExplorer.TabIndex"), Integer)
        Me.tvExplorer.Text = resources.GetString("tvExplorer.Text")
        Me.tvExplorer.Visible = CType(resources.GetObject("tvExplorer.Visible"), Boolean)
        '
        'lvFiles
        '
        Me.lvFiles.AccessibleDescription = resources.GetString("lvFiles.AccessibleDescription")
        Me.lvFiles.AccessibleName = resources.GetString("lvFiles.AccessibleName")
        Me.lvFiles.Alignment = CType(resources.GetObject("lvFiles.Alignment"), System.Windows.Forms.ListViewAlignment)
        Me.lvFiles.Anchor = CType(resources.GetObject("lvFiles.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.lvFiles.BackColor = System.Drawing.Color.Silver
        Me.lvFiles.BackgroundImage = CType(resources.GetObject("lvFiles.BackgroundImage"), System.Drawing.Image)
        Me.lvFiles.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader1, Me.ColumnHeader2, Me.ColumnHeader3})
        Me.lvFiles.Dock = CType(resources.GetObject("lvFiles.Dock"), System.Windows.Forms.DockStyle)
        Me.lvFiles.Enabled = CType(resources.GetObject("lvFiles.Enabled"), Boolean)
        Me.lvFiles.Font = CType(resources.GetObject("lvFiles.Font"), System.Drawing.Font)
        Me.lvFiles.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable
        Me.lvFiles.ImeMode = CType(resources.GetObject("lvFiles.ImeMode"), System.Windows.Forms.ImeMode)
        Me.lvFiles.LabelWrap = CType(resources.GetObject("lvFiles.LabelWrap"), Boolean)
        Me.lvFiles.Location = CType(resources.GetObject("lvFiles.Location"), System.Drawing.Point)
        Me.lvFiles.MultiSelect = False
        Me.lvFiles.Name = "lvFiles"
        Me.lvFiles.RightToLeft = CType(resources.GetObject("lvFiles.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.lvFiles.Size = CType(resources.GetObject("lvFiles.Size"), System.Drawing.Size)
        Me.lvFiles.SmallImageList = Me.imlIcons
        Me.lvFiles.TabIndex = CType(resources.GetObject("lvFiles.TabIndex"), Integer)
        Me.lvFiles.Text = resources.GetString("lvFiles.Text")
        Me.lvFiles.View = System.Windows.Forms.View.Details
        Me.lvFiles.Visible = CType(resources.GetObject("lvFiles.Visible"), Boolean)
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = resources.GetString("ColumnHeader1.Text")
        Me.ColumnHeader1.TextAlign = CType(resources.GetObject("ColumnHeader1.TextAlign"), System.Windows.Forms.HorizontalAlignment)
        Me.ColumnHeader1.Width = CType(resources.GetObject("ColumnHeader1.Width"), Integer)
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = resources.GetString("ColumnHeader2.Text")
        Me.ColumnHeader2.TextAlign = CType(resources.GetObject("ColumnHeader2.TextAlign"), System.Windows.Forms.HorizontalAlignment)
        Me.ColumnHeader2.Width = CType(resources.GetObject("ColumnHeader2.Width"), Integer)
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = resources.GetString("ColumnHeader3.Text")
        Me.ColumnHeader3.TextAlign = CType(resources.GetObject("ColumnHeader3.TextAlign"), System.Windows.Forms.HorizontalAlignment)
        Me.ColumnHeader3.Width = CType(resources.GetObject("ColumnHeader3.Width"), Integer)
        '
        'btnShredFD
        '
        Me.btnShredFD.AccessibleDescription = resources.GetString("btnShredFD.AccessibleDescription")
        Me.btnShredFD.AccessibleName = resources.GetString("btnShredFD.AccessibleName")
        Me.btnShredFD.Anchor = CType(resources.GetObject("btnShredFD.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.btnShredFD.BackgroundImage = CType(resources.GetObject("btnShredFD.BackgroundImage"), System.Drawing.Image)
        Me.btnShredFD.Dock = CType(resources.GetObject("btnShredFD.Dock"), System.Windows.Forms.DockStyle)
        Me.btnShredFD.Enabled = CType(resources.GetObject("btnShredFD.Enabled"), Boolean)
        Me.btnShredFD.FlatStyle = CType(resources.GetObject("btnShredFD.FlatStyle"), System.Windows.Forms.FlatStyle)
        Me.btnShredFD.Font = CType(resources.GetObject("btnShredFD.Font"), System.Drawing.Font)
        Me.btnShredFD.Image = CType(resources.GetObject("btnShredFD.Image"), System.Drawing.Image)
        Me.btnShredFD.ImageAlign = CType(resources.GetObject("btnShredFD.ImageAlign"), System.Drawing.ContentAlignment)
        Me.btnShredFD.ImageIndex = CType(resources.GetObject("btnShredFD.ImageIndex"), Integer)
        Me.btnShredFD.ImeMode = CType(resources.GetObject("btnShredFD.ImeMode"), System.Windows.Forms.ImeMode)
        Me.btnShredFD.Location = CType(resources.GetObject("btnShredFD.Location"), System.Drawing.Point)
        Me.btnShredFD.Name = "btnShredFD"
        Me.btnShredFD.RightToLeft = CType(resources.GetObject("btnShredFD.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.btnShredFD.Size = CType(resources.GetObject("btnShredFD.Size"), System.Drawing.Size)
        Me.btnShredFD.TabIndex = CType(resources.GetObject("btnShredFD.TabIndex"), Integer)
        Me.btnShredFD.Text = resources.GetString("btnShredFD.Text")
        Me.btnShredFD.TextAlign = CType(resources.GetObject("btnShredFD.TextAlign"), System.Drawing.ContentAlignment)
        Me.btnShredFD.Visible = CType(resources.GetObject("btnShredFD.Visible"), Boolean)
        '
        'btnShred
        '
        Me.btnShred.AccessibleDescription = resources.GetString("btnShred.AccessibleDescription")
        Me.btnShred.AccessibleName = resources.GetString("btnShred.AccessibleName")
        Me.btnShred.Anchor = CType(resources.GetObject("btnShred.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.btnShred.BackgroundImage = CType(resources.GetObject("btnShred.BackgroundImage"), System.Drawing.Image)
        Me.btnShred.Dock = CType(resources.GetObject("btnShred.Dock"), System.Windows.Forms.DockStyle)
        Me.btnShred.Enabled = CType(resources.GetObject("btnShred.Enabled"), Boolean)
        Me.btnShred.FlatStyle = CType(resources.GetObject("btnShred.FlatStyle"), System.Windows.Forms.FlatStyle)
        Me.btnShred.Font = CType(resources.GetObject("btnShred.Font"), System.Drawing.Font)
        Me.btnShred.Image = CType(resources.GetObject("btnShred.Image"), System.Drawing.Image)
        Me.btnShred.ImageAlign = CType(resources.GetObject("btnShred.ImageAlign"), System.Drawing.ContentAlignment)
        Me.btnShred.ImageIndex = CType(resources.GetObject("btnShred.ImageIndex"), Integer)
        Me.btnShred.ImeMode = CType(resources.GetObject("btnShred.ImeMode"), System.Windows.Forms.ImeMode)
        Me.btnShred.Location = CType(resources.GetObject("btnShred.Location"), System.Drawing.Point)
        Me.btnShred.Name = "btnShred"
        Me.btnShred.RightToLeft = CType(resources.GetObject("btnShred.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.btnShred.Size = CType(resources.GetObject("btnShred.Size"), System.Drawing.Size)
        Me.btnShred.TabIndex = CType(resources.GetObject("btnShred.TabIndex"), Integer)
        Me.btnShred.Text = resources.GetString("btnShred.Text")
        Me.btnShred.TextAlign = CType(resources.GetObject("btnShred.TextAlign"), System.Drawing.ContentAlignment)
        Me.btnShred.Visible = CType(resources.GetObject("btnShred.Visible"), Boolean)
        '
        'lblDescription
        '
        Me.lblDescription.AccessibleDescription = resources.GetString("lblDescription.AccessibleDescription")
        Me.lblDescription.AccessibleName = resources.GetString("lblDescription.AccessibleName")
        Me.lblDescription.Anchor = CType(resources.GetObject("lblDescription.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.lblDescription.AutoSize = CType(resources.GetObject("lblDescription.AutoSize"), Boolean)
        Me.lblDescription.BackColor = System.Drawing.Color.Silver
        Me.lblDescription.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.lblDescription.Dock = CType(resources.GetObject("lblDescription.Dock"), System.Windows.Forms.DockStyle)
        Me.lblDescription.Enabled = CType(resources.GetObject("lblDescription.Enabled"), Boolean)
        Me.lblDescription.Font = CType(resources.GetObject("lblDescription.Font"), System.Drawing.Font)
        Me.lblDescription.ForeColor = System.Drawing.Color.Black
        Me.lblDescription.Image = CType(resources.GetObject("lblDescription.Image"), System.Drawing.Image)
        Me.lblDescription.ImageAlign = CType(resources.GetObject("lblDescription.ImageAlign"), System.Drawing.ContentAlignment)
        Me.lblDescription.ImageIndex = CType(resources.GetObject("lblDescription.ImageIndex"), Integer)
        Me.lblDescription.ImeMode = CType(resources.GetObject("lblDescription.ImeMode"), System.Windows.Forms.ImeMode)
        Me.lblDescription.Location = CType(resources.GetObject("lblDescription.Location"), System.Drawing.Point)
        Me.lblDescription.Name = "lblDescription"
        Me.lblDescription.RightToLeft = CType(resources.GetObject("lblDescription.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.lblDescription.Size = CType(resources.GetObject("lblDescription.Size"), System.Drawing.Size)
        Me.lblDescription.TabIndex = CType(resources.GetObject("lblDescription.TabIndex"), Integer)
        Me.lblDescription.Text = resources.GetString("lblDescription.Text")
        Me.lblDescription.TextAlign = CType(resources.GetObject("lblDescription.TextAlign"), System.Drawing.ContentAlignment)
        Me.lblDescription.Visible = CType(resources.GetObject("lblDescription.Visible"), Boolean)
        '
        'btnSelectNone
        '
        Me.btnSelectNone.AccessibleDescription = resources.GetString("btnSelectNone.AccessibleDescription")
        Me.btnSelectNone.AccessibleName = resources.GetString("btnSelectNone.AccessibleName")
        Me.btnSelectNone.Anchor = CType(resources.GetObject("btnSelectNone.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.btnSelectNone.BackgroundImage = CType(resources.GetObject("btnSelectNone.BackgroundImage"), System.Drawing.Image)
        Me.btnSelectNone.Dock = CType(resources.GetObject("btnSelectNone.Dock"), System.Windows.Forms.DockStyle)
        Me.btnSelectNone.Enabled = CType(resources.GetObject("btnSelectNone.Enabled"), Boolean)
        Me.btnSelectNone.FlatStyle = CType(resources.GetObject("btnSelectNone.FlatStyle"), System.Windows.Forms.FlatStyle)
        Me.btnSelectNone.Font = CType(resources.GetObject("btnSelectNone.Font"), System.Drawing.Font)
        Me.btnSelectNone.Image = CType(resources.GetObject("btnSelectNone.Image"), System.Drawing.Image)
        Me.btnSelectNone.ImageAlign = CType(resources.GetObject("btnSelectNone.ImageAlign"), System.Drawing.ContentAlignment)
        Me.btnSelectNone.ImageIndex = CType(resources.GetObject("btnSelectNone.ImageIndex"), Integer)
        Me.btnSelectNone.ImeMode = CType(resources.GetObject("btnSelectNone.ImeMode"), System.Windows.Forms.ImeMode)
        Me.btnSelectNone.Location = CType(resources.GetObject("btnSelectNone.Location"), System.Drawing.Point)
        Me.btnSelectNone.Name = "btnSelectNone"
        Me.btnSelectNone.RightToLeft = CType(resources.GetObject("btnSelectNone.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.btnSelectNone.Size = CType(resources.GetObject("btnSelectNone.Size"), System.Drawing.Size)
        Me.btnSelectNone.TabIndex = CType(resources.GetObject("btnSelectNone.TabIndex"), Integer)
        Me.btnSelectNone.Text = resources.GetString("btnSelectNone.Text")
        Me.btnSelectNone.TextAlign = CType(resources.GetObject("btnSelectNone.TextAlign"), System.Drawing.ContentAlignment)
        Me.btnSelectNone.Visible = CType(resources.GetObject("btnSelectNone.Visible"), Boolean)
        '
        'btnClean
        '
        Me.btnClean.AccessibleDescription = resources.GetString("btnClean.AccessibleDescription")
        Me.btnClean.AccessibleName = resources.GetString("btnClean.AccessibleName")
        Me.btnClean.Anchor = CType(resources.GetObject("btnClean.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.btnClean.BackgroundImage = CType(resources.GetObject("btnClean.BackgroundImage"), System.Drawing.Image)
        Me.btnClean.Dock = CType(resources.GetObject("btnClean.Dock"), System.Windows.Forms.DockStyle)
        Me.btnClean.Enabled = CType(resources.GetObject("btnClean.Enabled"), Boolean)
        Me.btnClean.FlatStyle = CType(resources.GetObject("btnClean.FlatStyle"), System.Windows.Forms.FlatStyle)
        Me.btnClean.Font = CType(resources.GetObject("btnClean.Font"), System.Drawing.Font)
        Me.btnClean.Image = CType(resources.GetObject("btnClean.Image"), System.Drawing.Image)
        Me.btnClean.ImageAlign = CType(resources.GetObject("btnClean.ImageAlign"), System.Drawing.ContentAlignment)
        Me.btnClean.ImageIndex = CType(resources.GetObject("btnClean.ImageIndex"), Integer)
        Me.btnClean.ImeMode = CType(resources.GetObject("btnClean.ImeMode"), System.Windows.Forms.ImeMode)
        Me.btnClean.Location = CType(resources.GetObject("btnClean.Location"), System.Drawing.Point)
        Me.btnClean.Name = "btnClean"
        Me.btnClean.RightToLeft = CType(resources.GetObject("btnClean.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.btnClean.Size = CType(resources.GetObject("btnClean.Size"), System.Drawing.Size)
        Me.btnClean.TabIndex = CType(resources.GetObject("btnClean.TabIndex"), Integer)
        Me.btnClean.Text = resources.GetString("btnClean.Text")
        Me.btnClean.TextAlign = CType(resources.GetObject("btnClean.TextAlign"), System.Drawing.ContentAlignment)
        Me.btnClean.Visible = CType(resources.GetObject("btnClean.Visible"), Boolean)
        '
        'btnSelectall
        '
        Me.btnSelectall.AccessibleDescription = resources.GetString("btnSelectall.AccessibleDescription")
        Me.btnSelectall.AccessibleName = resources.GetString("btnSelectall.AccessibleName")
        Me.btnSelectall.Anchor = CType(resources.GetObject("btnSelectall.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.btnSelectall.BackgroundImage = CType(resources.GetObject("btnSelectall.BackgroundImage"), System.Drawing.Image)
        Me.btnSelectall.Dock = CType(resources.GetObject("btnSelectall.Dock"), System.Windows.Forms.DockStyle)
        Me.btnSelectall.Enabled = CType(resources.GetObject("btnSelectall.Enabled"), Boolean)
        Me.btnSelectall.FlatStyle = CType(resources.GetObject("btnSelectall.FlatStyle"), System.Windows.Forms.FlatStyle)
        Me.btnSelectall.Font = CType(resources.GetObject("btnSelectall.Font"), System.Drawing.Font)
        Me.btnSelectall.Image = CType(resources.GetObject("btnSelectall.Image"), System.Drawing.Image)
        Me.btnSelectall.ImageAlign = CType(resources.GetObject("btnSelectall.ImageAlign"), System.Drawing.ContentAlignment)
        Me.btnSelectall.ImageIndex = CType(resources.GetObject("btnSelectall.ImageIndex"), Integer)
        Me.btnSelectall.ImeMode = CType(resources.GetObject("btnSelectall.ImeMode"), System.Windows.Forms.ImeMode)
        Me.btnSelectall.Location = CType(resources.GetObject("btnSelectall.Location"), System.Drawing.Point)
        Me.btnSelectall.Name = "btnSelectall"
        Me.btnSelectall.RightToLeft = CType(resources.GetObject("btnSelectall.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.btnSelectall.Size = CType(resources.GetObject("btnSelectall.Size"), System.Drawing.Size)
        Me.btnSelectall.TabIndex = CType(resources.GetObject("btnSelectall.TabIndex"), Integer)
        Me.btnSelectall.Text = resources.GetString("btnSelectall.Text")
        Me.btnSelectall.TextAlign = CType(resources.GetObject("btnSelectall.TextAlign"), System.Drawing.ContentAlignment)
        Me.btnSelectall.Visible = CType(resources.GetObject("btnSelectall.Visible"), Boolean)
        '
        'lvClean
        '
        Me.lvClean.AccessibleDescription = resources.GetString("lvClean.AccessibleDescription")
        Me.lvClean.AccessibleName = resources.GetString("lvClean.AccessibleName")
        Me.lvClean.Anchor = CType(resources.GetObject("lvClean.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.lvClean.BackColor = System.Drawing.Color.Silver
        Me.lvClean.BackgroundImage = CType(resources.GetObject("lvClean.BackgroundImage"), System.Drawing.Image)
        Me.lvClean.ColumnWidth = CType(resources.GetObject("lvClean.ColumnWidth"), Integer)
        Me.lvClean.Dock = CType(resources.GetObject("lvClean.Dock"), System.Windows.Forms.DockStyle)
        Me.lvClean.Enabled = CType(resources.GetObject("lvClean.Enabled"), Boolean)
        Me.lvClean.Font = CType(resources.GetObject("lvClean.Font"), System.Drawing.Font)
        Me.lvClean.HorizontalExtent = CType(resources.GetObject("lvClean.HorizontalExtent"), Integer)
        Me.lvClean.HorizontalScrollbar = CType(resources.GetObject("lvClean.HorizontalScrollbar"), Boolean)
        Me.lvClean.ImeMode = CType(resources.GetObject("lvClean.ImeMode"), System.Windows.Forms.ImeMode)
        Me.lvClean.IntegralHeight = CType(resources.GetObject("lvClean.IntegralHeight"), Boolean)
        Me.lvClean.Location = CType(resources.GetObject("lvClean.Location"), System.Drawing.Point)
        Me.lvClean.Name = "lvClean"
        Me.lvClean.RightToLeft = CType(resources.GetObject("lvClean.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.lvClean.ScrollAlwaysVisible = CType(resources.GetObject("lvClean.ScrollAlwaysVisible"), Boolean)
        Me.lvClean.Size = CType(resources.GetObject("lvClean.Size"), System.Drawing.Size)
        Me.lvClean.TabIndex = CType(resources.GetObject("lvClean.TabIndex"), Integer)
        Me.lvClean.Visible = CType(resources.GetObject("lvClean.Visible"), Boolean)
        '
        'picShredder
        '
        Me.picShredder.AccessibleDescription = resources.GetString("picShredder.AccessibleDescription")
        Me.picShredder.AccessibleName = resources.GetString("picShredder.AccessibleName")
        Me.picShredder.Anchor = CType(resources.GetObject("picShredder.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picShredder.BackColor = System.Drawing.Color.Transparent
        Me.picShredder.BackgroundImage = CType(resources.GetObject("picShredder.BackgroundImage"), System.Drawing.Image)
        Me.picShredder.Dock = CType(resources.GetObject("picShredder.Dock"), System.Windows.Forms.DockStyle)
        Me.picShredder.Enabled = CType(resources.GetObject("picShredder.Enabled"), Boolean)
        Me.picShredder.Font = CType(resources.GetObject("picShredder.Font"), System.Drawing.Font)
        Me.picShredder.Image = CType(resources.GetObject("picShredder.Image"), System.Drawing.Image)
        Me.picShredder.ImeMode = CType(resources.GetObject("picShredder.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picShredder.Location = CType(resources.GetObject("picShredder.Location"), System.Drawing.Point)
        Me.picShredder.Name = "picShredder"
        Me.picShredder.RightToLeft = CType(resources.GetObject("picShredder.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picShredder.Size = CType(resources.GetObject("picShredder.Size"), System.Drawing.Size)
        Me.picShredder.SizeMode = CType(resources.GetObject("picShredder.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picShredder.TabIndex = CType(resources.GetObject("picShredder.TabIndex"), Integer)
        Me.picShredder.TabStop = False
        Me.picShredder.Text = resources.GetString("picShredder.Text")
        Me.picShredder.Visible = CType(resources.GetObject("picShredder.Visible"), Boolean)
        '
        'btnOptions
        '
        Me.btnOptions.AccessibleDescription = resources.GetString("btnOptions.AccessibleDescription")
        Me.btnOptions.AccessibleName = resources.GetString("btnOptions.AccessibleName")
        Me.btnOptions.Anchor = CType(resources.GetObject("btnOptions.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.btnOptions.BackgroundImage = CType(resources.GetObject("btnOptions.BackgroundImage"), System.Drawing.Image)
        Me.btnOptions.Dock = CType(resources.GetObject("btnOptions.Dock"), System.Windows.Forms.DockStyle)
        Me.btnOptions.Enabled = CType(resources.GetObject("btnOptions.Enabled"), Boolean)
        Me.btnOptions.FlatStyle = CType(resources.GetObject("btnOptions.FlatStyle"), System.Windows.Forms.FlatStyle)
        Me.btnOptions.Font = CType(resources.GetObject("btnOptions.Font"), System.Drawing.Font)
        Me.btnOptions.Image = CType(resources.GetObject("btnOptions.Image"), System.Drawing.Image)
        Me.btnOptions.ImageAlign = CType(resources.GetObject("btnOptions.ImageAlign"), System.Drawing.ContentAlignment)
        Me.btnOptions.ImageIndex = CType(resources.GetObject("btnOptions.ImageIndex"), Integer)
        Me.btnOptions.ImeMode = CType(resources.GetObject("btnOptions.ImeMode"), System.Windows.Forms.ImeMode)
        Me.btnOptions.Location = CType(resources.GetObject("btnOptions.Location"), System.Drawing.Point)
        Me.btnOptions.Name = "btnOptions"
        Me.btnOptions.RightToLeft = CType(resources.GetObject("btnOptions.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.btnOptions.Size = CType(resources.GetObject("btnOptions.Size"), System.Drawing.Size)
        Me.btnOptions.TabIndex = CType(resources.GetObject("btnOptions.TabIndex"), Integer)
        Me.btnOptions.Text = resources.GetString("btnOptions.Text")
        Me.btnOptions.TextAlign = CType(resources.GetObject("btnOptions.TextAlign"), System.Drawing.ContentAlignment)
        Me.btnOptions.Visible = CType(resources.GetObject("btnOptions.Visible"), Boolean)
        '
        'btnAbout
        '
        Me.btnAbout.AccessibleDescription = resources.GetString("btnAbout.AccessibleDescription")
        Me.btnAbout.AccessibleName = resources.GetString("btnAbout.AccessibleName")
        Me.btnAbout.Anchor = CType(resources.GetObject("btnAbout.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.btnAbout.BackgroundImage = CType(resources.GetObject("btnAbout.BackgroundImage"), System.Drawing.Image)
        Me.btnAbout.Dock = CType(resources.GetObject("btnAbout.Dock"), System.Windows.Forms.DockStyle)
        Me.btnAbout.Enabled = CType(resources.GetObject("btnAbout.Enabled"), Boolean)
        Me.btnAbout.FlatStyle = CType(resources.GetObject("btnAbout.FlatStyle"), System.Windows.Forms.FlatStyle)
        Me.btnAbout.Font = CType(resources.GetObject("btnAbout.Font"), System.Drawing.Font)
        Me.btnAbout.Image = CType(resources.GetObject("btnAbout.Image"), System.Drawing.Image)
        Me.btnAbout.ImageAlign = CType(resources.GetObject("btnAbout.ImageAlign"), System.Drawing.ContentAlignment)
        Me.btnAbout.ImageIndex = CType(resources.GetObject("btnAbout.ImageIndex"), Integer)
        Me.btnAbout.ImeMode = CType(resources.GetObject("btnAbout.ImeMode"), System.Windows.Forms.ImeMode)
        Me.btnAbout.Location = CType(resources.GetObject("btnAbout.Location"), System.Drawing.Point)
        Me.btnAbout.Name = "btnAbout"
        Me.btnAbout.RightToLeft = CType(resources.GetObject("btnAbout.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.btnAbout.Size = CType(resources.GetObject("btnAbout.Size"), System.Drawing.Size)
        Me.btnAbout.TabIndex = CType(resources.GetObject("btnAbout.TabIndex"), Integer)
        Me.btnAbout.Text = resources.GetString("btnAbout.Text")
        Me.btnAbout.TextAlign = CType(resources.GetObject("btnAbout.TextAlign"), System.Drawing.ContentAlignment)
        Me.btnAbout.Visible = CType(resources.GetObject("btnAbout.Visible"), Boolean)
        '
        'picMin
        '
        Me.picMin.AccessibleDescription = resources.GetString("picMin.AccessibleDescription")
        Me.picMin.AccessibleName = resources.GetString("picMin.AccessibleName")
        Me.picMin.Anchor = CType(resources.GetObject("picMin.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picMin.BackColor = System.Drawing.Color.Transparent
        Me.picMin.BackgroundImage = CType(resources.GetObject("picMin.BackgroundImage"), System.Drawing.Image)
        Me.picMin.Dock = CType(resources.GetObject("picMin.Dock"), System.Windows.Forms.DockStyle)
        Me.picMin.Enabled = CType(resources.GetObject("picMin.Enabled"), Boolean)
        Me.picMin.Font = CType(resources.GetObject("picMin.Font"), System.Drawing.Font)
        Me.picMin.Image = CType(resources.GetObject("picMin.Image"), System.Drawing.Image)
        Me.picMin.ImeMode = CType(resources.GetObject("picMin.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picMin.Location = CType(resources.GetObject("picMin.Location"), System.Drawing.Point)
        Me.picMin.Name = "picMin"
        Me.picMin.RightToLeft = CType(resources.GetObject("picMin.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picMin.Size = CType(resources.GetObject("picMin.Size"), System.Drawing.Size)
        Me.picMin.SizeMode = CType(resources.GetObject("picMin.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picMin.TabIndex = CType(resources.GetObject("picMin.TabIndex"), Integer)
        Me.picMin.TabStop = False
        Me.picMin.Text = resources.GetString("picMin.Text")
        Me.picMin.Visible = CType(resources.GetObject("picMin.Visible"), Boolean)
        '
        'picClose
        '
        Me.picClose.AccessibleDescription = resources.GetString("picClose.AccessibleDescription")
        Me.picClose.AccessibleName = resources.GetString("picClose.AccessibleName")
        Me.picClose.Anchor = CType(resources.GetObject("picClose.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picClose.BackColor = System.Drawing.Color.Transparent
        Me.picClose.BackgroundImage = CType(resources.GetObject("picClose.BackgroundImage"), System.Drawing.Image)
        Me.picClose.Dock = CType(resources.GetObject("picClose.Dock"), System.Windows.Forms.DockStyle)
        Me.picClose.Enabled = CType(resources.GetObject("picClose.Enabled"), Boolean)
        Me.picClose.Font = CType(resources.GetObject("picClose.Font"), System.Drawing.Font)
        Me.picClose.Image = CType(resources.GetObject("picClose.Image"), System.Drawing.Image)
        Me.picClose.ImeMode = CType(resources.GetObject("picClose.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picClose.Location = CType(resources.GetObject("picClose.Location"), System.Drawing.Point)
        Me.picClose.Name = "picClose"
        Me.picClose.RightToLeft = CType(resources.GetObject("picClose.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picClose.Size = CType(resources.GetObject("picClose.Size"), System.Drawing.Size)
        Me.picClose.SizeMode = CType(resources.GetObject("picClose.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picClose.TabIndex = CType(resources.GetObject("picClose.TabIndex"), Integer)
        Me.picClose.TabStop = False
        Me.picClose.Text = resources.GetString("picClose.Text")
        Me.picClose.Visible = CType(resources.GetObject("picClose.Visible"), Boolean)
        '
        'picMinHover
        '
        Me.picMinHover.AccessibleDescription = resources.GetString("picMinHover.AccessibleDescription")
        Me.picMinHover.AccessibleName = resources.GetString("picMinHover.AccessibleName")
        Me.picMinHover.Anchor = CType(resources.GetObject("picMinHover.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picMinHover.BackColor = System.Drawing.Color.Transparent
        Me.picMinHover.BackgroundImage = CType(resources.GetObject("picMinHover.BackgroundImage"), System.Drawing.Image)
        Me.picMinHover.Dock = CType(resources.GetObject("picMinHover.Dock"), System.Windows.Forms.DockStyle)
        Me.picMinHover.Enabled = CType(resources.GetObject("picMinHover.Enabled"), Boolean)
        Me.picMinHover.Font = CType(resources.GetObject("picMinHover.Font"), System.Drawing.Font)
        Me.picMinHover.Image = CType(resources.GetObject("picMinHover.Image"), System.Drawing.Image)
        Me.picMinHover.ImeMode = CType(resources.GetObject("picMinHover.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picMinHover.Location = CType(resources.GetObject("picMinHover.Location"), System.Drawing.Point)
        Me.picMinHover.Name = "picMinHover"
        Me.picMinHover.RightToLeft = CType(resources.GetObject("picMinHover.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picMinHover.Size = CType(resources.GetObject("picMinHover.Size"), System.Drawing.Size)
        Me.picMinHover.SizeMode = CType(resources.GetObject("picMinHover.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picMinHover.TabIndex = CType(resources.GetObject("picMinHover.TabIndex"), Integer)
        Me.picMinHover.TabStop = False
        Me.picMinHover.Text = resources.GetString("picMinHover.Text")
        Me.picMinHover.Visible = CType(resources.GetObject("picMinHover.Visible"), Boolean)
        '
        'picCloseHover
        '
        Me.picCloseHover.AccessibleDescription = resources.GetString("picCloseHover.AccessibleDescription")
        Me.picCloseHover.AccessibleName = resources.GetString("picCloseHover.AccessibleName")
        Me.picCloseHover.Anchor = CType(resources.GetObject("picCloseHover.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picCloseHover.BackColor = System.Drawing.Color.Transparent
        Me.picCloseHover.BackgroundImage = CType(resources.GetObject("picCloseHover.BackgroundImage"), System.Drawing.Image)
        Me.picCloseHover.Dock = CType(resources.GetObject("picCloseHover.Dock"), System.Windows.Forms.DockStyle)
        Me.picCloseHover.Enabled = CType(resources.GetObject("picCloseHover.Enabled"), Boolean)
        Me.picCloseHover.Font = CType(resources.GetObject("picCloseHover.Font"), System.Drawing.Font)
        Me.picCloseHover.Image = CType(resources.GetObject("picCloseHover.Image"), System.Drawing.Image)
        Me.picCloseHover.ImeMode = CType(resources.GetObject("picCloseHover.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picCloseHover.Location = CType(resources.GetObject("picCloseHover.Location"), System.Drawing.Point)
        Me.picCloseHover.Name = "picCloseHover"
        Me.picCloseHover.RightToLeft = CType(resources.GetObject("picCloseHover.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picCloseHover.Size = CType(resources.GetObject("picCloseHover.Size"), System.Drawing.Size)
        Me.picCloseHover.SizeMode = CType(resources.GetObject("picCloseHover.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picCloseHover.TabIndex = CType(resources.GetObject("picCloseHover.TabIndex"), Integer)
        Me.picCloseHover.TabStop = False
        Me.picCloseHover.Text = resources.GetString("picCloseHover.Text")
        Me.picCloseHover.Visible = CType(resources.GetObject("picCloseHover.Visible"), Boolean)
        '
        'picMinDown
        '
        Me.picMinDown.AccessibleDescription = resources.GetString("picMinDown.AccessibleDescription")
        Me.picMinDown.AccessibleName = resources.GetString("picMinDown.AccessibleName")
        Me.picMinDown.Anchor = CType(resources.GetObject("picMinDown.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picMinDown.BackColor = System.Drawing.Color.Transparent
        Me.picMinDown.BackgroundImage = CType(resources.GetObject("picMinDown.BackgroundImage"), System.Drawing.Image)
        Me.picMinDown.Dock = CType(resources.GetObject("picMinDown.Dock"), System.Windows.Forms.DockStyle)
        Me.picMinDown.Enabled = CType(resources.GetObject("picMinDown.Enabled"), Boolean)
        Me.picMinDown.Font = CType(resources.GetObject("picMinDown.Font"), System.Drawing.Font)
        Me.picMinDown.Image = CType(resources.GetObject("picMinDown.Image"), System.Drawing.Image)
        Me.picMinDown.ImeMode = CType(resources.GetObject("picMinDown.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picMinDown.Location = CType(resources.GetObject("picMinDown.Location"), System.Drawing.Point)
        Me.picMinDown.Name = "picMinDown"
        Me.picMinDown.RightToLeft = CType(resources.GetObject("picMinDown.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picMinDown.Size = CType(resources.GetObject("picMinDown.Size"), System.Drawing.Size)
        Me.picMinDown.SizeMode = CType(resources.GetObject("picMinDown.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picMinDown.TabIndex = CType(resources.GetObject("picMinDown.TabIndex"), Integer)
        Me.picMinDown.TabStop = False
        Me.picMinDown.Text = resources.GetString("picMinDown.Text")
        Me.picMinDown.Visible = CType(resources.GetObject("picMinDown.Visible"), Boolean)
        '
        'picCloseDown
        '
        Me.picCloseDown.AccessibleDescription = resources.GetString("picCloseDown.AccessibleDescription")
        Me.picCloseDown.AccessibleName = resources.GetString("picCloseDown.AccessibleName")
        Me.picCloseDown.Anchor = CType(resources.GetObject("picCloseDown.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picCloseDown.BackColor = System.Drawing.Color.Transparent
        Me.picCloseDown.BackgroundImage = CType(resources.GetObject("picCloseDown.BackgroundImage"), System.Drawing.Image)
        Me.picCloseDown.Dock = CType(resources.GetObject("picCloseDown.Dock"), System.Windows.Forms.DockStyle)
        Me.picCloseDown.Enabled = CType(resources.GetObject("picCloseDown.Enabled"), Boolean)
        Me.picCloseDown.Font = CType(resources.GetObject("picCloseDown.Font"), System.Drawing.Font)
        Me.picCloseDown.Image = CType(resources.GetObject("picCloseDown.Image"), System.Drawing.Image)
        Me.picCloseDown.ImeMode = CType(resources.GetObject("picCloseDown.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picCloseDown.Location = CType(resources.GetObject("picCloseDown.Location"), System.Drawing.Point)
        Me.picCloseDown.Name = "picCloseDown"
        Me.picCloseDown.RightToLeft = CType(resources.GetObject("picCloseDown.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picCloseDown.Size = CType(resources.GetObject("picCloseDown.Size"), System.Drawing.Size)
        Me.picCloseDown.SizeMode = CType(resources.GetObject("picCloseDown.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picCloseDown.TabIndex = CType(resources.GetObject("picCloseDown.TabIndex"), Integer)
        Me.picCloseDown.TabStop = False
        Me.picCloseDown.Text = resources.GetString("picCloseDown.Text")
        Me.picCloseDown.Visible = CType(resources.GetObject("picCloseDown.Visible"), Boolean)
        '
        'picIcon
        '
        Me.picIcon.AccessibleDescription = resources.GetString("picIcon.AccessibleDescription")
        Me.picIcon.AccessibleName = resources.GetString("picIcon.AccessibleName")
        Me.picIcon.Anchor = CType(resources.GetObject("picIcon.Anchor"), System.Windows.Forms.AnchorStyles)
        Me.picIcon.BackColor = System.Drawing.Color.Transparent
        Me.picIcon.BackgroundImage = CType(resources.GetObject("picIcon.BackgroundImage"), System.Drawing.Image)
        Me.picIcon.Dock = CType(resources.GetObject("picIcon.Dock"), System.Windows.Forms.DockStyle)
        Me.picIcon.Enabled = CType(resources.GetObject("picIcon.Enabled"), Boolean)
        Me.picIcon.Font = CType(resources.GetObject("picIcon.Font"), System.Drawing.Font)
        Me.picIcon.Image = CType(resources.GetObject("picIcon.Image"), System.Drawing.Image)
        Me.picIcon.ImeMode = CType(resources.GetObject("picIcon.ImeMode"), System.Windows.Forms.ImeMode)
        Me.picIcon.Location = CType(resources.GetObject("picIcon.Location"), System.Drawing.Point)
        Me.picIcon.Name = "picIcon"
        Me.picIcon.RightToLeft = CType(resources.GetObject("picIcon.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.picIcon.Size = CType(resources.GetObject("picIcon.Size"), System.Drawing.Size)
        Me.picIcon.SizeMode = CType(resources.GetObject("picIcon.SizeMode"), System.Windows.Forms.PictureBoxSizeMode)
        Me.picIcon.TabIndex = CType(resources.GetObject("picIcon.TabIndex"), Integer)
        Me.picIcon.TabStop = False
        Me.picIcon.Text = resources.GetString("picIcon.Text")
        Me.picIcon.Visible = CType(resources.GetObject("picIcon.Visible"), Boolean)
        '
        'frmMain
        '
        Me.AccessibleDescription = resources.GetString("$this.AccessibleDescription")
        Me.AccessibleName = resources.GetString("$this.AccessibleName")
        Me.AutoScaleBaseSize = CType(resources.GetObject("$this.AutoScaleBaseSize"), System.Drawing.Size)
        Me.AutoScroll = CType(resources.GetObject("$this.AutoScroll"), Boolean)
        Me.AutoScrollMargin = CType(resources.GetObject("$this.AutoScrollMargin"), System.Drawing.Size)
        Me.AutoScrollMinSize = CType(resources.GetObject("$this.AutoScrollMinSize"), System.Drawing.Size)
        Me.BackColor = System.Drawing.Color.AliceBlue
        Me.BackgroundImage = CType(resources.GetObject("$this.BackgroundImage"), System.Drawing.Image)
        Me.ClientSize = CType(resources.GetObject("$this.ClientSize"), System.Drawing.Size)
        Me.ControlBox = False
        Me.Controls.Add(Me.picIcon)
        Me.Controls.Add(Me.picMin)
        Me.Controls.Add(Me.picClose)
        Me.Controls.Add(Me.picMinHover)
        Me.Controls.Add(Me.picCloseHover)
        Me.Controls.Add(Me.btnAbout)
        Me.Controls.Add(Me.btnOptions)
        Me.Controls.Add(Me.picShredder)
        Me.Controls.Add(Me.lblDescription)
        Me.Controls.Add(Me.btnSelectNone)
        Me.Controls.Add(Me.btnClean)
        Me.Controls.Add(Me.btnSelectall)
        Me.Controls.Add(Me.lvClean)
        Me.Controls.Add(Me.tvExplorer)
        Me.Controls.Add(Me.lvFiles)
        Me.Controls.Add(Me.btnShredFD)
        Me.Controls.Add(Me.btnShred)
        Me.Controls.Add(Me.picCloseDown)
        Me.Controls.Add(Me.picMinDown)
        Me.Enabled = CType(resources.GetObject("$this.Enabled"), Boolean)
        Me.Font = CType(resources.GetObject("$this.Font"), System.Drawing.Font)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.ImeMode = CType(resources.GetObject("$this.ImeMode"), System.Windows.Forms.ImeMode)
        Me.Location = CType(resources.GetObject("$this.Location"), System.Drawing.Point)
        Me.MaximizeBox = False
        Me.MaximumSize = CType(resources.GetObject("$this.MaximumSize"), System.Drawing.Size)
        Me.MinimizeBox = False
        Me.MinimumSize = CType(resources.GetObject("$this.MinimumSize"), System.Drawing.Size)
        Me.Name = "frmMain"
        Me.RightToLeft = CType(resources.GetObject("$this.RightToLeft"), System.Windows.Forms.RightToLeft)
        Me.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide
        Me.StartPosition = CType(resources.GetObject("$this.StartPosition"), System.Windows.Forms.FormStartPosition)
        Me.Text = resources.GetString("$this.Text")
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Enum CleanListItems
        clAcrobat = 0
        clIEHistory = 1
        clIECookies = 2
        clMSPaint = 3
        clMSRun = 4
        clCache = 5
        clMediaPlayer = 6
        clRecentDocs = 7
        clTemp = 8
        clWinRAR = 9
        clWinZip = 10
    End Enum

    Private Enum DriveType
        Unknown = 0
        NoRoot = 1
        Removeable = 2
        Fixed = 3
        Remote = 4
        Cdrom = 5
        Ramdisk = 6
    End Enum

    Private CleanList As CleanListItems
    Private CleanDescription(10) As String

    Private myShredder As New Shredder
    Private myReg As New Registry
    Private myIconExtractor As New ExtractFileIcon
    Private blnExplorerFirstOpened As Boolean
    Private blnExplorerClosed As Boolean
    Private icFireIcon As Icon

    Private tmrExporerOpened As New Timer
    Private tmrExporerClosed As New Timer
    Private tmrStartUp As New Timer

    Private Declare Function GetDriveType Lib "kernel32" Alias "GetDriveTypeA" (ByVal nDrive As String) As Integer
    Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As IntPtr, ByVal wMsg As Integer, ByVal wParam As Integer, ByVal lParam As Integer) As Integer
    Private Declare Sub ReleaseCapture Lib "user32" ()

    Const WM_NCLBUTTONDOWN = &HA1
    Const HTCAPTION = 2

    Shared Sub Main()
        ' In order to get XP styles.
        Application.EnableVisualStyles()
        Application.DoEvents()
        Application.Run(New frmMain)
        ' I prefer to do this under Public Sub New(), but then the treeview icons don't show.
    End Sub

    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim strCommandArg() As String

        AddHandler tmrExporerOpened.Tick, AddressOf myTimerExporerOpenedTick
        AddHandler tmrExporerClosed.Tick, AddressOf myTimerExporerClosedTick
        AddHandler tmrStartUp.Tick, AddressOf myTimerStartUpTick

        Me.Cursor = Cursors.WaitCursor
        Application.DoEvents()
        NotifyIconShredder.Icon = Me.Icon ' Set the icon.
        NotifyIconShredder.Text = "Shredder" ' Set the tooltip text.

        strCommandArg = Environment.GetCommandLineArgs()
        If UBound(strCommandArg) > 0 Then
            If strCommandArg(1) = "-min" Then ' Check if shredder must start minimized to tray.
                Me.WindowState = FormWindowState.Minimized
                ' I use a timer to hide the from, because if you hide it here, when you show the form
                ' from the context menu it will not paint properly.
                tmrStartUp.Interval = 500
                tmrStartUp.Start()
            End If
        End If

        LoadDrives()
        GetOptions()
        LoadArrayDescriptions()
        LoadList()
        Me.Opacity = MyOptions.Transparency
        tvExplorer.SelectedNode = tvExplorer.Nodes(0)
        tmrExporerClosed.Interval = 1000
        tmrExporerOpened.Interval = 1000
        ' Check if any auto monitoring is required.
        If MyOptions.AutoCleanCache Or MyOptions.AutoCleanIE Then
            tmrExporerOpened.Start()
        End If
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub LoadDrives()
        Dim tvNode As TreeNode
        Dim strDrive As String
        Dim strDrives() As String

        strDrives = Directory.GetLogicalDrives
        tvExplorer.BeginUpdate()
        tvNode = tvExplorer.Nodes.Add("My Documents")
        tvNode.ImageIndex = 7
        tvNode.SelectedImageIndex = 7
        Try
            For Each strDrive In strDrives
                tvExplorer.SelectedNode = Nothing
                tvNode = tvExplorer.Nodes.Add(RemoveBackSlash(strDrive))
                Select Case GetDriveType(strDrive)
                    Case DriveType.Unknown, DriveType.NoRoot, DriveType.Fixed
                        tvNode.ImageIndex = 3
                        tvNode.SelectedImageIndex = 3
                    Case DriveType.Remote
                        tvNode.ImageIndex = 5
                        tvNode.SelectedImageIndex = 5
                    Case DriveType.Removeable
                        tvNode.ImageIndex = 4
                        tvNode.SelectedImageIndex = 4
                    Case DriveType.Cdrom
                        tvNode.ImageIndex = 2
                        tvNode.SelectedImageIndex = 2
                    Case DriveType.Ramdisk
                        tvNode.ImageIndex = 6
                        tvNode.SelectedImageIndex = 6
                End Select
            Next
        Catch ex As Exception

        End Try
        tvExplorer.EndUpdate()
    End Sub

    ' Populate the array.
    Private Sub LoadArrayDescriptions()
        CleanDescription(CleanList.clAcrobat) = "Removes the history of PDF files that you have viewed recently with Adobe Acrobat 5, 6 or 7."
        CleanDescription(CleanList.clIEHistory) = "Removes Internet Explorer history and typed URLs."
        CleanDescription(CleanList.clIECookies) = "Removes Internet Explorer cookies."
        CleanDescription(CleanList.clMSPaint) = "Clears recent files list of Microsoft Paint."
        CleanDescription(CleanList.clMSRun) = "Removes the history of commands that you have entered in the Run feature."
        CleanDescription(CleanList.clCache) = "Clears Temporary Internet Folder (cache) which is created by Internet Explorer when you visit web sites."
        CleanDescription(CleanList.clMediaPlayer) = "Clears recent files list of Windows Media Player."
        CleanDescription(CleanList.clRecentDocs) = "Clears the list of recent documents opened on this computer."
        CleanDescription(CleanList.clTemp) = "Removes all items in the windows temp folder. (wasted space)"
        CleanDescription(CleanList.clWinRAR) = "Clears the history of items compressed/extracted by WinRAR"
        CleanDescription(CleanList.clWinZip) = "Clears the history of items compressed/extracted by Winzip"
    End Sub

    ' Add all the items to list box.
    Private Sub LoadList()
        With lvClean.Items
            .Clear()
            .Add("Adobe Acrobat Reader", MyOptions.clAcrobat)
            .Add("Internet Explorer History", MyOptions.clIEHistory)
            .Add("Internet Explorer Cookies", MyOptions.clIECookies)
            .Add("Microsoft Paint", MyOptions.clMSPaint)
            .Add("Start Menu Run", MyOptions.clMSRun)
            .Add("Temporary Internet Files (cache)", MyOptions.clCache)
            .Add("Windows Media Player", MyOptions.clMediaPlayer)
            .Add("Windows Recent Documents", MyOptions.clRecentDocs)
            .Add("Windows Temporary Files", MyOptions.clTemp)
            .Add("WinRAR", MyOptions.clWinRAR)
            .Add("Winzip", MyOptions.clWinZip)
        End With
    End Sub

    Private Sub FillFileBox(ByVal myPath As String)
        Try
            If myPath.StartsWith("My Documents") Then myPath = AddBackSlash(Path.GetDirectoryName(Environment.GetFolderPath(Environment.SpecialFolder.Personal))) & myPath
            Dim i As Integer
            Dim di As New DirectoryInfo(AddBackSlash(myPath))
            Dim fiArr As FileInfo() = di.GetFiles()
            Dim f As FileInfo

            lvFiles.Items.Clear()
            imlIcons.Images.Clear()
            i = 0
            For Each f In fiArr
                lvFiles.Items.Add(f.Name, myIconExtractor.GetIconFromFile(f, imlIcons))
                If f.Length / 1024 > 1 Then
                    lvFiles.Items(i).SubItems.Add(Format(CInt(f.Length / 1024), "#,##0") & " KB") ' Note 1 KB = 1024 bytes.
                Else
                    lvFiles.Items(i).SubItems.Add("1 KB")
                End If
                lvFiles.Items(i).SubItems.Add(Format(f.LastWriteTime, "yyyy/MM/dd"))
                i += 1
            Next
        Catch ex As Exception

        End Try
    End Sub

    Private Sub frmMain_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        ' If minimized button clicked, hide the form and show the icon in the system tray.
        If Me.WindowState = FormWindowState.Minimized Then
            NotifyIconShredder.Visible = True ' Show the icon.
            Me.Hide() ' Hide the form.
        End If
    End Sub

    Private Sub miShow_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles miShow.Click
        ' Show the form and hide the icon in the system tray.
        Me.Show()
        NotifyIconShredder.Visible = False
        Me.WindowState = FormWindowState.Normal ' Restore the window.
        Me.Focus()
    End Sub

    Private Sub miExit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles miExit.Click
        Me.Close()
    End Sub

    Private Sub frmMain_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        NotifyIconShredder.Dispose() ' Remove the icon from the system tray.
        tmrExporerClosed.Dispose()
        tmrExporerOpened.Dispose()
        SaveOptions()
        Application.Exit()
    End Sub

    Private Sub CleanItem(ByVal myItem As Integer)
        Select Case myItem
            Case CleanList.clAcrobat
                myShredder.CleanAcrobat()
            Case CleanList.clIEHistory
                myShredder.CleanHistory()
            Case CleanList.clIECookies
                myShredder.CleanCookies()
            Case CleanList.clMSPaint
                myShredder.CleanPaint()
            Case CleanList.clMSRun
                myShredder.CleanRun()
            Case CleanList.clCache
                myShredder.CleanInternetCache()
            Case CleanList.clMediaPlayer
                myShredder.CleanMediaPlayer()
            Case CleanList.clRecentDocs
                myShredder.CleanRecentDocs()
            Case CleanList.clTemp
                myShredder.CleanTempFolder(MyOptions.OverwriteNumber)
            Case CleanList.clWinRAR
                myShredder.CleanWinRAR()
            Case CleanList.clWinZip
                myShredder.CleanWinzip()
        End Select
    End Sub

    Private Sub CheckListItemsState()
        Select Case lvClean.SelectedIndex
            Case CleanList.clAcrobat
                MyOptions.clAcrobat = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clIEHistory
                MyOptions.clIEHistory = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clIECookies
                MyOptions.clIECookies = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clMSPaint
                MyOptions.clMSPaint = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clMSRun
                MyOptions.clMSRun = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clCache
                MyOptions.clCache = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clMediaPlayer
                MyOptions.clMediaPlayer = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clRecentDocs
                MyOptions.clRecentDocs = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clTemp
                MyOptions.clTemp = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clWinRAR
                MyOptions.clWinRAR = IsChecked(lvClean.SelectedIndex)
            Case CleanList.clWinZip
                MyOptions.clWinZip = IsChecked(lvClean.SelectedIndex)
        End Select
    End Sub

    Private Function IsChecked(ByVal SelIndex As Integer) As Boolean
        If lvClean.GetItemCheckState(SelIndex) = CheckState.Checked Then
            Return True
        Else
            Return False
        End If
    End Function

    Private Sub NotifyIconShredder_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles NotifyIconShredder.DoubleClick
        If Me.WindowState = FormWindowState.Minimized Then miShow_Click(sender, e)
    End Sub

    Private Sub myTimerExporerOpenedTick(ByVal myObject As Object, ByVal myEventArgs As EventArgs)
        blnExplorerFirstOpened = GetProcessStatus("iexplore")
        If blnExplorerFirstOpened Then
            tmrExporerOpened.Stop()
            tmrExporerClosed.Start()
        End If
    End Sub

    Private Sub myTimerExporerClosedTick(ByVal myObject As Object, ByVal myEventArgs As EventArgs)
        blnExplorerClosed = GetProcessStatus("iexplore")
        If blnExplorerClosed = False Then
            tmrExporerClosed.Stop()

            NotifyIconShredder.Icon = GetEmbeddedIcon("Shredder.Fire.ico")
            Application.DoEvents()
            System.Threading.Thread.Sleep(500) ' To allow the icon to be seen, otherwise it can be too fast to see.
            If MyOptions.AutoCleanCache Then
                myShredder.CleanCookies()
                myShredder.CleanInternetCache()
            End If
            If MyOptions.AutoCleanIE Then
                myShredder.CleanHistory()
            End If
            NotifyIconShredder.Icon = Me.Icon
            ' Start checking for first instance of internet explorer again.
            tmrExporerOpened.Start()
        End If
    End Sub

    Private Sub myTimerStartUpTick(ByVal myObject As Object, ByVal myEventArgs As EventArgs)
        tmrStartUp.Stop()
        Me.Hide() 'Hide the form (don't show it in taskbar).
    End Sub

    Private Sub miCleanIE_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles miCleanIE.Click
        myShredder.CleanCookies()
        myShredder.CleanInternetCache()
        myShredder.CleanHistory()
    End Sub

    Private Sub miCleanSelected_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles miCleanSelected.Click
        Dim i As Integer

        Me.Cursor = Cursors.WaitCursor
        For i = 0 To lvClean.Items.Count - 1
            If lvClean.GetItemCheckState(i) = CheckState.Checked Then
                CleanItem(i)
            End If
        Next
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub lvClean_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvClean.SelectedIndexChanged
        lblDescription.Text = CleanDescription(lvClean.SelectedIndex)
        CheckListItemsState()
    End Sub

    Private Sub btnSelectall_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSelectall.Click
        Dim i As Integer

        For i = 0 To lvClean.Items.Count - 1
            lvClean.SetItemChecked(i, True)
        Next
        MyOptions.clAcrobat = True
        MyOptions.clCache = True
        MyOptions.clIECookies = True
        MyOptions.clIEHistory = True
        MyOptions.clMediaPlayer = True
        MyOptions.clMSPaint = True
        MyOptions.clMSRun = True
        MyOptions.clRecentDocs = True
        MyOptions.clTemp = True
        MyOptions.clWinRAR = True
        MyOptions.clWinZip = True
    End Sub

    Private Sub btnSelectNone_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSelectNone.Click
        Dim i As Integer

        For i = 0 To lvClean.Items.Count - 1
            lvClean.SetItemChecked(i, False)
        Next
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
    End Sub

    Private Sub btnClean_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClean.Click
        Dim i As Integer

        Me.Cursor = Cursors.WaitCursor
        btnClean.Enabled = False
        btnSelectall.Enabled = False
        btnSelectNone.Enabled = False
        Application.DoEvents()
        For i = 0 To lvClean.Items.Count - 1
            If lvClean.GetItemCheckState(i) = CheckState.Checked Then
                CleanItem(i)
            End If
        Next
        btnClean.Enabled = True
        btnSelectall.Enabled = True
        btnSelectNone.Enabled = True
        Me.Cursor = Cursors.Default
        MessageBox.Show("Selected items have been cleaned", "Shredder", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub lvClean_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvClean.DoubleClick
        CheckListItemsState()
    End Sub

    Private Sub frmMain_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles MyBase.MouseMove
        MoveForm(e)
    End Sub

    Private Sub MoveForm(ByVal e As System.Windows.Forms.MouseEventArgs)
        Dim lngReturnValue As Integer

        Try
            If e.Button = MouseButtons.Left Then
                ReleaseCapture()
                'Send a 'left mouse button down on caption'-message to our form
                lngReturnValue = SendMessage(Me.ActiveForm.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0&)
            End If
        Catch ex As Exception

        End Try
    End Sub

    Private Sub btnShred_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnShred.Click
        Dim i As Integer

        For i = 0 To lvFiles.Items.Count - 1
            If lvFiles.Items(i).Selected Then Exit For
        Next
        If i = lvFiles.Items.Count Then Exit Sub
        If MessageBox.Show("Delete " & lvFiles.Items(i).Text & "?", "Shred file", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            Me.Cursor = Cursors.WaitCursor
            btnShred.Enabled = False
            myShredder.ShredFile(myShredder.CheckPath(tvExplorer.SelectedNode.FullPath) & lvFiles.Items(i).Text, MyOptions.OverwriteNumber, True)
            FillFileBox(tvExplorer.SelectedNode.FullPath)
            btnShred.Enabled = True
            Me.Cursor = Cursors.Default
        End If
    End Sub

    Private Sub btnShredFD_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnShredFD.Click
        If MessageBox.Show("Delete " & tvExplorer.SelectedNode.FullPath & "?", "Shred folder", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            Me.Cursor = Cursors.WaitCursor
            Application.DoEvents()
            btnShredFD.Enabled = False
            myShredder.ShredFolder(tvExplorer.SelectedNode.FullPath, MyOptions.OverwriteNumber)
            tvExplorer.SelectedNode = tvExplorer.SelectedNode.Parent
            btnShredFD.Enabled = True
            Me.Cursor = Cursors.Default
        End If
    End Sub

    Private Sub tvExplorer_AfterSelect(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles tvExplorer.AfterSelect
        Dim tvNode As TreeNode
        Dim strFolder As String
        Dim strFolders() As String
        Dim DI As DirectoryInfo

        Me.Cursor = Cursors.WaitCursor
        tvExplorer.BeginUpdate()
        Try
            e.Node.Nodes.Clear() ' Remove any existing nodes, and then added them back. This needs to be done to pick up any new folders.
            If e.Node.Text = "My Documents" Then
                strFolders = Directory.GetDirectories(AddBackSlash(Environment.GetFolderPath(Environment.SpecialFolder.Personal)))
            Else
                If e.Node.FullPath.StartsWith("My Documents") Then
                    strFolders = Directory.GetDirectories(AddBackSlash(Path.GetDirectoryName(Environment.GetFolderPath(Environment.SpecialFolder.Personal))) & e.Node.FullPath)
                Else
                    strFolders = Directory.GetDirectories(AddBackSlash(e.Node.FullPath))
                End If
            End If
            For Each strFolder In strFolders
                DI = New DirectoryInfo(strFolder)
                tvNode = tvExplorer.SelectedNode
                tvNode.Nodes.Add(DI.Name)
            Next
        Catch ex As Exception

        End Try
        tvExplorer.EndUpdate()
        FillFileBox(AddBackSlash(e.Node.FullPath))
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub picShredder_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picShredder.MouseMove
        MoveForm(e)
    End Sub

    Private Sub btnOptions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOptions.Click
        Dim myOptionsForm As New frmOptions

        myOptionsForm.ShowDialog()
        Me.Opacity = MyOptions.Transparency
        If MyOptions.AutoCleanCache Or MyOptions.AutoCleanIE Then
            If tmrExporerOpened.Enabled = False And tmrExporerOpened.Enabled = False Then
                tmrExporerOpened.Start()
            End If
        Else
            If tmrExporerOpened.Enabled Then
                tmrExporerOpened.Stop()
            End If
            If tmrExporerClosed.Enabled Then
                tmrExporerClosed.Stop()
            End If
        End If
    End Sub

    Private Sub btnAbout_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAbout.Click
        Dim myAboutForm As New frmAbout

        myAboutForm.ShowDialog()
    End Sub

    Private Sub picClose_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picClose.MouseMove
        picCloseHover.Visible = True
        picCloseDown.Visible = False
        picClose.Visible = False
    End Sub

    Private Sub picCloseHover_MouseLeave(ByVal sender As Object, ByVal e As System.EventArgs) Handles picCloseHover.MouseLeave
        picClose.Visible = True
        picCloseHover.Visible = False
        picCloseDown.Visible = False
    End Sub

    Private Sub picCloseHover_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picCloseHover.MouseDown
        picCloseDown.Visible = True
        picCloseHover.Visible = False
        picClose.Visible = False
    End Sub

    Private Sub picCloseHover_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picCloseHover.MouseUp
        picCloseDown.Visible = False
        picCloseHover.Visible = False
        picClose.Visible = True
        Me.Close()
    End Sub

    Private Sub picMin_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picMin.MouseMove
        picMinHover.Visible = True
        picMinDown.Visible = False
        picMin.Visible = False
    End Sub

    Private Sub picMinHover_MouseLeave(ByVal sender As Object, ByVal e As System.EventArgs) Handles picMinHover.MouseLeave
        picMin.Visible = True
        picMinDown.Visible = False
        picMinHover.Visible = False
    End Sub

    Private Sub picMinHover_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picMinHover.MouseDown
        picMinDown.Visible = True
        picMinHover.Visible = False
        picMin.Visible = False
    End Sub

    Private Sub picMinHover_MouseUp(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picMinHover.MouseUp
        picMin.Visible = True
        picMinDown.Visible = False
        picMinHover.Visible = False
        Me.WindowState = FormWindowState.Minimized
    End Sub

    Private Sub picIcon_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles picIcon.MouseMove
        MoveForm(e)
    End Sub
End Class
