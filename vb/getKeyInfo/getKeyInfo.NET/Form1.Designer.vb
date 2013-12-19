<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class Form1
#Region "Windows Form Designer generated code "
	<System.Diagnostics.DebuggerNonUserCode()> Public Sub New()
		MyBase.New()
		'This call is required by the Windows Form Designer.
		InitializeComponent()
	End Sub
	'Form overrides dispose to clean up the component list.
	<System.Diagnostics.DebuggerNonUserCode()> Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
		If Disposing Then
			If Not components Is Nothing Then
				components.Dispose()
			End If
		End If
		MyBase.Dispose(Disposing)
	End Sub
	'Required by the Windows Form Designer
	Private components As System.ComponentModel.IContainer
	Public ToolTip1 As System.Windows.Forms.ToolTip
	Public WithEvents Text1 As System.Windows.Forms.TextBox
	Public WithEvents Command1 As System.Windows.Forms.Button
	Public WithEvents _Option1_4 As System.Windows.Forms.RadioButton
	Public WithEvents _Option1_3 As System.Windows.Forms.RadioButton
	Public WithEvents _Option1_2 As System.Windows.Forms.RadioButton
	Public WithEvents _Option1_1 As System.Windows.Forms.RadioButton
	Public WithEvents _Option1_0 As System.Windows.Forms.RadioButton
	Public WithEvents txtKeys As System.Windows.Forms.TextBox
	Public WithEvents Label1 As System.Windows.Forms.Label
	Public WithEvents Option1 As Microsoft.VisualBasic.Compatibility.VB6.RadioButtonArray
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.Text1 = New System.Windows.Forms.TextBox
        Me.Command1 = New System.Windows.Forms.Button
        Me._Option1_4 = New System.Windows.Forms.RadioButton
        Me._Option1_3 = New System.Windows.Forms.RadioButton
        Me._Option1_2 = New System.Windows.Forms.RadioButton
        Me._Option1_1 = New System.Windows.Forms.RadioButton
        Me._Option1_0 = New System.Windows.Forms.RadioButton
        Me.txtKeys = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.Option1 = New Microsoft.VisualBasic.Compatibility.VB6.RadioButtonArray(Me.components)
        CType(Me.Option1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Text1
        '
        Me.Text1.AcceptsReturn = True
        Me.Text1.BackColor = System.Drawing.SystemColors.Window
        Me.Text1.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.Text1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Text1.ForeColor = System.Drawing.SystemColors.WindowText
        Me.Text1.Location = New System.Drawing.Point(24, 80)
        Me.Text1.MaxLength = 0
        Me.Text1.Name = "Text1"
        Me.Text1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Text1.Size = New System.Drawing.Size(313, 19)
        Me.Text1.TabIndex = 0
        '
        'Command1
        '
        Me.Command1.BackColor = System.Drawing.SystemColors.Control
        Me.Command1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Command1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Command1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Command1.Location = New System.Drawing.Point(184, 32)
        Me.Command1.Name = "Command1"
        Me.Command1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Command1.Size = New System.Drawing.Size(57, 25)
        Me.Command1.TabIndex = 1
        Me.Command1.Text = "List"
        Me.Command1.UseVisualStyleBackColor = False
        '
        '_Option1_4
        '
        Me._Option1_4.BackColor = System.Drawing.SystemColors.Control
        Me._Option1_4.Cursor = System.Windows.Forms.Cursors.Default
        Me._Option1_4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me._Option1_4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Option1.SetIndex(Me._Option1_4, CType(4, Short))
        Me._Option1_4.Location = New System.Drawing.Point(0, 64)
        Me._Option1_4.Name = "_Option1_4"
        Me._Option1_4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._Option1_4.Size = New System.Drawing.Size(169, 17)
        Me._Option1_4.TabIndex = 7
        Me._Option1_4.TabStop = True
        Me._Option1_4.Tag = "&H80000003"
        Me._Option1_4.Text = "HKEY_USERS"
        Me._Option1_4.UseVisualStyleBackColor = False
        '
        '_Option1_3
        '
        Me._Option1_3.BackColor = System.Drawing.SystemColors.Control
        Me._Option1_3.Cursor = System.Windows.Forms.Cursors.Default
        Me._Option1_3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me._Option1_3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Option1.SetIndex(Me._Option1_3, CType(3, Short))
        Me._Option1_3.Location = New System.Drawing.Point(0, 48)
        Me._Option1_3.Name = "_Option1_3"
        Me._Option1_3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._Option1_3.Size = New System.Drawing.Size(169, 17)
        Me._Option1_3.TabIndex = 6
        Me._Option1_3.TabStop = True
        Me._Option1_3.Tag = "&H80000002"
        Me._Option1_3.Text = "HKEY_LOCAL_MACHINE"
        Me._Option1_3.UseVisualStyleBackColor = False
        '
        '_Option1_2
        '
        Me._Option1_2.BackColor = System.Drawing.SystemColors.Control
        Me._Option1_2.Cursor = System.Windows.Forms.Cursors.Default
        Me._Option1_2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me._Option1_2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Option1.SetIndex(Me._Option1_2, CType(2, Short))
        Me._Option1_2.Location = New System.Drawing.Point(0, 32)
        Me._Option1_2.Name = "_Option1_2"
        Me._Option1_2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._Option1_2.Size = New System.Drawing.Size(169, 17)
        Me._Option1_2.TabIndex = 5
        Me._Option1_2.TabStop = True
        Me._Option1_2.Tag = "&H80000001"
        Me._Option1_2.Text = "HKEY_CURRENT_USER"
        Me._Option1_2.UseVisualStyleBackColor = False
        '
        '_Option1_1
        '
        Me._Option1_1.BackColor = System.Drawing.SystemColors.Control
        Me._Option1_1.Cursor = System.Windows.Forms.Cursors.Default
        Me._Option1_1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me._Option1_1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Option1.SetIndex(Me._Option1_1, CType(1, Short))
        Me._Option1_1.Location = New System.Drawing.Point(0, 16)
        Me._Option1_1.Name = "_Option1_1"
        Me._Option1_1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._Option1_1.Size = New System.Drawing.Size(169, 17)
        Me._Option1_1.TabIndex = 4
        Me._Option1_1.TabStop = True
        Me._Option1_1.Tag = "&H80000005"
        Me._Option1_1.Text = "HKEY_CURRENT_MACHINE"
        Me._Option1_1.UseVisualStyleBackColor = False
        '
        '_Option1_0
        '
        Me._Option1_0.BackColor = System.Drawing.SystemColors.Control
        Me._Option1_0.Cursor = System.Windows.Forms.Cursors.Default
        Me._Option1_0.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me._Option1_0.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Option1.SetIndex(Me._Option1_0, CType(0, Short))
        Me._Option1_0.Location = New System.Drawing.Point(0, 0)
        Me._Option1_0.Name = "_Option1_0"
        Me._Option1_0.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._Option1_0.Size = New System.Drawing.Size(169, 17)
        Me._Option1_0.TabIndex = 3
        Me._Option1_0.TabStop = True
        Me._Option1_0.Tag = "&H80000000"
        Me._Option1_0.Text = "HKEY_CLASSES_ROOT"
        Me._Option1_0.UseVisualStyleBackColor = False
        '
        'txtKeys
        '
        Me.txtKeys.AcceptsReturn = True
        Me.txtKeys.BackColor = System.Drawing.SystemColors.Window
        Me.txtKeys.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtKeys.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtKeys.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtKeys.Location = New System.Drawing.Point(0, 112)
        Me.txtKeys.MaxLength = 0
        Me.txtKeys.Multiline = True
        Me.txtKeys.Name = "txtKeys"
        Me.txtKeys.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtKeys.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtKeys.Size = New System.Drawing.Size(345, 185)
        Me.txtKeys.TabIndex = 2
        Me.txtKeys.TabStop = False
        Me.txtKeys.WordWrap = False
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(0, 80)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(25, 17)
        Me.Label1.TabIndex = 8
        Me.Label1.Text = "Key:"
        '
        'Option1
        '
        '
        'Form1
        '
        Me.AcceptButton = Me.Command1
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 14.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(391, 274)
        Me.Controls.Add(Me.Text1)
        Me.Controls.Add(Me.Command1)
        Me.Controls.Add(Me._Option1_4)
        Me.Controls.Add(Me._Option1_3)
        Me.Controls.Add(Me._Option1_2)
        Me.Controls.Add(Me._Option1_1)
        Me.Controls.Add(Me._Option1_0)
        Me.Controls.Add(Me.txtKeys)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(76, 101)
        Me.Name = "Form1"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.StartPosition = System.Windows.Forms.FormStartPosition.Manual
        Me.Text = "getKeyInfo"
        CType(Me.Option1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
#End Region 
End Class