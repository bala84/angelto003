namespace SerialPortTerminal
{
  partial class frmTerminal
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null))
      {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.components = new System.ComponentModel.Container();
        System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmTerminal));
        this.rtfTerminal = new System.Windows.Forms.RichTextBox();
        this.txtSendData = new System.Windows.Forms.TextBox();
        this.lblSend = new System.Windows.Forms.Label();
        this.btnSend = new System.Windows.Forms.Button();
        this.cmbPortName = new System.Windows.Forms.ComboBox();
        this.cmbBaudRate = new System.Windows.Forms.ComboBox();
        this.rbHex = new System.Windows.Forms.RadioButton();
        this.rbText = new System.Windows.Forms.RadioButton();
        this.gbMode = new System.Windows.Forms.GroupBox();
        this.lblComPort = new System.Windows.Forms.Label();
        this.lblBaudRate = new System.Windows.Forms.Label();
        this.label1 = new System.Windows.Forms.Label();
        this.cmbParity = new System.Windows.Forms.ComboBox();
        this.lblDataBits = new System.Windows.Forms.Label();
        this.cmbDataBits = new System.Windows.Forms.ComboBox();
        this.lblStopBits = new System.Windows.Forms.Label();
        this.cmbStopBits = new System.Windows.Forms.ComboBox();
        this.btnOpenPort = new System.Windows.Forms.Button();
        this.gbPortSettings = new System.Windows.Forms.GroupBox();
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator = new System.Windows.Forms.BindingNavigator(this.components);
        this.bindingNavigatorAddNewItem = new System.Windows.Forms.ToolStripButton();
        this.bindingNavigatorCountItem = new System.Windows.Forms.ToolStripLabel();
        this.bindingNavigatorDeleteItem = new System.Windows.Forms.ToolStripButton();
        this.bindingNavigatorMoveFirstItem = new System.Windows.Forms.ToolStripButton();
        this.bindingNavigatorMovePreviousItem = new System.Windows.Forms.ToolStripButton();
        this.bindingNavigatorSeparator = new System.Windows.Forms.ToolStripSeparator();
        this.bindingNavigatorPositionItem = new System.Windows.Forms.ToolStripTextBox();
        this.bindingNavigatorSeparator1 = new System.Windows.Forms.ToolStripSeparator();
        this.bindingNavigatorMoveNextItem = new System.Windows.Forms.ToolStripButton();
        this.bindingNavigatorMoveLastItem = new System.Windows.Forms.ToolStripButton();
        this.bindingNavigatorSeparator2 = new System.Windows.Forms.ToolStripSeparator();
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem = new System.Windows.Forms.ToolStripButton();
        this.fillToolStrip = new System.Windows.Forms.ToolStrip();
        this.p_start_dateToolStripLabel = new System.Windows.Forms.ToolStripLabel();
        this.p_start_dateToolStripTextBox = new System.Windows.Forms.ToolStripTextBox();
        this.p_end_dateToolStripLabel = new System.Windows.Forms.ToolStripLabel();
        this.p_end_dateToolStripTextBox = new System.Windows.Forms.ToolStripTextBox();
        this.fillToolStripButton = new System.Windows.Forms.ToolStripButton();
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView = new System.Windows.Forms.DataGridView();
        this.label2 = new System.Windows.Forms.Label();
        this.action_textBox = new System.Windows.Forms.TextBox();
        this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn6 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn7 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn8 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn9 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.dataGridViewTextBoxColumn10 = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.uspVSYS_SERIAL_LOG_SelectAllBindingSource = new System.Windows.Forms.BindingSource(this.components);
        this.angel_to_serialDataSet = new SerialPortTerminal.angel_to_serialDataSet();
        this.uspVSYS_SERIAL_LOG_SelectAllTableAdapter = new SerialPortTerminal.angel_to_serialDataSetTableAdapters.uspVSYS_SERIAL_LOG_SelectAllTableAdapter();
        this.tableAdapterManager = new SerialPortTerminal.angel_to_serialDataSetTableAdapters.TableAdapterManager();
        this.gbMode.SuspendLayout();
        this.gbPortSettings.SuspendLayout();
        ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator)).BeginInit();
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.SuspendLayout();
        this.fillToolStrip.SuspendLayout();
        ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_SERIAL_LOG_SelectAllDataGridView)).BeginInit();
        ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_SERIAL_LOG_SelectAllBindingSource)).BeginInit();
        ((System.ComponentModel.ISupportInitialize)(this.angel_to_serialDataSet)).BeginInit();
        this.SuspendLayout();
        // 
        // rtfTerminal
        // 
        this.rtfTerminal.Location = new System.Drawing.Point(12, 31);
        this.rtfTerminal.Name = "rtfTerminal";
        this.rtfTerminal.Size = new System.Drawing.Size(844, 263);
        this.rtfTerminal.TabIndex = 0;
        this.rtfTerminal.Text = "";
        // 
        // txtSendData
        // 
        this.txtSendData.Location = new System.Drawing.Point(111, 300);
        this.txtSendData.Name = "txtSendData";
        this.txtSendData.ReadOnly = true;
        this.txtSendData.Size = new System.Drawing.Size(664, 20);
        this.txtSendData.TabIndex = 2;
        // 
        // lblSend
        // 
        this.lblSend.AutoSize = true;
        this.lblSend.Location = new System.Drawing.Point(12, 303);
        this.lblSend.Name = "lblSend";
        this.lblSend.Size = new System.Drawing.Size(93, 13);
        this.lblSend.TabIndex = 1;
        this.lblSend.Text = "Проверка связи:";
        // 
        // btnSend
        // 
        this.btnSend.Location = new System.Drawing.Point(781, 297);
        this.btnSend.Name = "btnSend";
        this.btnSend.Size = new System.Drawing.Size(75, 23);
        this.btnSend.TabIndex = 3;
        this.btnSend.Text = "Проверить";
        this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
        // 
        // cmbPortName
        // 
        this.cmbPortName.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
        this.cmbPortName.Enabled = false;
        this.cmbPortName.FormattingEnabled = true;
        this.cmbPortName.Items.AddRange(new object[] {
            "COM1",
            "COM2",
            "COM3",
            "COM4",
            "COM5",
            "COM6"});
        this.cmbPortName.Location = new System.Drawing.Point(13, 35);
        this.cmbPortName.Name = "cmbPortName";
        this.cmbPortName.Size = new System.Drawing.Size(67, 21);
        this.cmbPortName.TabIndex = 1;
        // 
        // cmbBaudRate
        // 
        this.cmbBaudRate.Enabled = false;
        this.cmbBaudRate.FormattingEnabled = true;
        this.cmbBaudRate.Items.AddRange(new object[] {
            "300",
            "600",
            "1200",
            "2400",
            "4800",
            "9600",
            "14400",
            "28800",
            "36000",
            "115000"});
        this.cmbBaudRate.Location = new System.Drawing.Point(86, 35);
        this.cmbBaudRate.Name = "cmbBaudRate";
        this.cmbBaudRate.Size = new System.Drawing.Size(69, 21);
        this.cmbBaudRate.TabIndex = 3;
        this.cmbBaudRate.Validating += new System.ComponentModel.CancelEventHandler(this.cmbBaudRate_Validating);
        // 
        // rbHex
        // 
        this.rbHex.AutoSize = true;
        this.rbHex.Checked = true;
        this.rbHex.Location = new System.Drawing.Point(12, 39);
        this.rbHex.Name = "rbHex";
        this.rbHex.Size = new System.Drawing.Size(44, 17);
        this.rbHex.TabIndex = 1;
        this.rbHex.TabStop = true;
        this.rbHex.Text = "Hex";
        this.rbHex.CheckedChanged += new System.EventHandler(this.rbHex_CheckedChanged);
        // 
        // rbText
        // 
        this.rbText.AutoSize = true;
        this.rbText.Enabled = false;
        this.rbText.Location = new System.Drawing.Point(12, 19);
        this.rbText.Name = "rbText";
        this.rbText.Size = new System.Drawing.Size(46, 17);
        this.rbText.TabIndex = 0;
        this.rbText.Text = "Text";
        this.rbText.CheckedChanged += new System.EventHandler(this.rbText_CheckedChanged);
        // 
        // gbMode
        // 
        this.gbMode.Controls.Add(this.rbText);
        this.gbMode.Controls.Add(this.rbHex);
        this.gbMode.Location = new System.Drawing.Point(545, 351);
        this.gbMode.Name = "gbMode";
        this.gbMode.Size = new System.Drawing.Size(68, 64);
        this.gbMode.TabIndex = 5;
        this.gbMode.TabStop = false;
        // 
        // lblComPort
        // 
        this.lblComPort.AutoSize = true;
        this.lblComPort.Location = new System.Drawing.Point(12, 19);
        this.lblComPort.Name = "lblComPort";
        this.lblComPort.Size = new System.Drawing.Size(56, 13);
        this.lblComPort.TabIndex = 0;
        this.lblComPort.Text = "COM Port:";
        // 
        // lblBaudRate
        // 
        this.lblBaudRate.AutoSize = true;
        this.lblBaudRate.Location = new System.Drawing.Point(85, 19);
        this.lblBaudRate.Name = "lblBaudRate";
        this.lblBaudRate.Size = new System.Drawing.Size(61, 13);
        this.lblBaudRate.TabIndex = 2;
        this.lblBaudRate.Text = "Baud Rate:";
        // 
        // label1
        // 
        this.label1.AutoSize = true;
        this.label1.Location = new System.Drawing.Point(163, 19);
        this.label1.Name = "label1";
        this.label1.Size = new System.Drawing.Size(36, 13);
        this.label1.TabIndex = 4;
        this.label1.Text = "Parity:";
        // 
        // cmbParity
        // 
        this.cmbParity.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
        this.cmbParity.Enabled = false;
        this.cmbParity.FormattingEnabled = true;
        this.cmbParity.Items.AddRange(new object[] {
            "None",
            "Even",
            "Odd"});
        this.cmbParity.Location = new System.Drawing.Point(161, 35);
        this.cmbParity.Name = "cmbParity";
        this.cmbParity.Size = new System.Drawing.Size(60, 21);
        this.cmbParity.TabIndex = 5;
        // 
        // lblDataBits
        // 
        this.lblDataBits.AutoSize = true;
        this.lblDataBits.Location = new System.Drawing.Point(229, 19);
        this.lblDataBits.Name = "lblDataBits";
        this.lblDataBits.Size = new System.Drawing.Size(53, 13);
        this.lblDataBits.TabIndex = 6;
        this.lblDataBits.Text = "Data Bits:";
        // 
        // cmbDataBits
        // 
        this.cmbDataBits.Enabled = false;
        this.cmbDataBits.FormattingEnabled = true;
        this.cmbDataBits.Items.AddRange(new object[] {
            "7",
            "8",
            "9"});
        this.cmbDataBits.Location = new System.Drawing.Point(227, 35);
        this.cmbDataBits.Name = "cmbDataBits";
        this.cmbDataBits.Size = new System.Drawing.Size(60, 21);
        this.cmbDataBits.TabIndex = 7;
        this.cmbDataBits.Validating += new System.ComponentModel.CancelEventHandler(this.cmbDataBits_Validating);
        // 
        // lblStopBits
        // 
        this.lblStopBits.AutoSize = true;
        this.lblStopBits.Location = new System.Drawing.Point(295, 19);
        this.lblStopBits.Name = "lblStopBits";
        this.lblStopBits.Size = new System.Drawing.Size(52, 13);
        this.lblStopBits.TabIndex = 8;
        this.lblStopBits.Text = "Stop Bits:";
        // 
        // cmbStopBits
        // 
        this.cmbStopBits.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
        this.cmbStopBits.Enabled = false;
        this.cmbStopBits.FormattingEnabled = true;
        this.cmbStopBits.Items.AddRange(new object[] {
            "1",
            "2",
            "3"});
        this.cmbStopBits.Location = new System.Drawing.Point(293, 35);
        this.cmbStopBits.Name = "cmbStopBits";
        this.cmbStopBits.Size = new System.Drawing.Size(65, 21);
        this.cmbStopBits.TabIndex = 9;
        // 
        // btnOpenPort
        // 
        this.btnOpenPort.Location = new System.Drawing.Point(785, 385);
        this.btnOpenPort.Name = "btnOpenPort";
        this.btnOpenPort.Size = new System.Drawing.Size(75, 23);
        this.btnOpenPort.TabIndex = 6;
        this.btnOpenPort.Text = "&Открыть порт";
        this.btnOpenPort.Click += new System.EventHandler(this.btnOpenPort_Click);
        // 
        // gbPortSettings
        // 
        this.gbPortSettings.Controls.Add(this.lblComPort);
        this.gbPortSettings.Controls.Add(this.cmbPortName);
        this.gbPortSettings.Controls.Add(this.lblStopBits);
        this.gbPortSettings.Controls.Add(this.cmbBaudRate);
        this.gbPortSettings.Controls.Add(this.cmbStopBits);
        this.gbPortSettings.Controls.Add(this.lblBaudRate);
        this.gbPortSettings.Controls.Add(this.lblDataBits);
        this.gbPortSettings.Controls.Add(this.cmbParity);
        this.gbPortSettings.Controls.Add(this.cmbDataBits);
        this.gbPortSettings.Controls.Add(this.label1);
        this.gbPortSettings.Location = new System.Drawing.Point(54, 351);
        this.gbPortSettings.Name = "gbPortSettings";
        this.gbPortSettings.Size = new System.Drawing.Size(370, 64);
        this.gbPortSettings.TabIndex = 4;
        this.gbPortSettings.TabStop = false;
        this.gbPortSettings.Text = "Настройки & порта";
        // 
        // uspVSYS_SERIAL_LOG_SelectAllBindingNavigator
        // 
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.AddNewItem = this.bindingNavigatorAddNewItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.BindingSource = this.uspVSYS_SERIAL_LOG_SelectAllBindingSource;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.CountItem = this.bindingNavigatorCountItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.DeleteItem = this.bindingNavigatorDeleteItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.bindingNavigatorMoveFirstItem,
            this.bindingNavigatorMovePreviousItem,
            this.bindingNavigatorSeparator,
            this.bindingNavigatorPositionItem,
            this.bindingNavigatorCountItem,
            this.bindingNavigatorSeparator1,
            this.bindingNavigatorMoveNextItem,
            this.bindingNavigatorMoveLastItem,
            this.bindingNavigatorSeparator2,
            this.bindingNavigatorAddNewItem,
            this.bindingNavigatorDeleteItem,
            this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem});
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.Location = new System.Drawing.Point(0, 0);
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.MoveFirstItem = this.bindingNavigatorMoveFirstItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.MoveLastItem = this.bindingNavigatorMoveLastItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.MoveNextItem = this.bindingNavigatorMoveNextItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.MovePreviousItem = this.bindingNavigatorMovePreviousItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.Name = "uspVSYS_SERIAL_LOG_SelectAllBindingNavigator";
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.PositionItem = this.bindingNavigatorPositionItem;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.Size = new System.Drawing.Size(611, 25);
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.TabIndex = 8;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.Text = "bindingNavigator1";
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.Visible = false;
        // 
        // bindingNavigatorAddNewItem
        // 
        this.bindingNavigatorAddNewItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        this.bindingNavigatorAddNewItem.Image = ((System.Drawing.Image)(resources.GetObject("bindingNavigatorAddNewItem.Image")));
        this.bindingNavigatorAddNewItem.Name = "bindingNavigatorAddNewItem";
        this.bindingNavigatorAddNewItem.RightToLeftAutoMirrorImage = true;
        this.bindingNavigatorAddNewItem.Size = new System.Drawing.Size(23, 22);
        this.bindingNavigatorAddNewItem.Text = "Add new";
        // 
        // bindingNavigatorCountItem
        // 
        this.bindingNavigatorCountItem.Name = "bindingNavigatorCountItem";
        this.bindingNavigatorCountItem.Size = new System.Drawing.Size(45, 22);
        this.bindingNavigatorCountItem.Text = "для {0}";
        this.bindingNavigatorCountItem.ToolTipText = "Total number of items";
        // 
        // bindingNavigatorDeleteItem
        // 
        this.bindingNavigatorDeleteItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        this.bindingNavigatorDeleteItem.Image = ((System.Drawing.Image)(resources.GetObject("bindingNavigatorDeleteItem.Image")));
        this.bindingNavigatorDeleteItem.Name = "bindingNavigatorDeleteItem";
        this.bindingNavigatorDeleteItem.RightToLeftAutoMirrorImage = true;
        this.bindingNavigatorDeleteItem.Size = new System.Drawing.Size(23, 22);
        this.bindingNavigatorDeleteItem.Text = "Delete";
        // 
        // bindingNavigatorMoveFirstItem
        // 
        this.bindingNavigatorMoveFirstItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        this.bindingNavigatorMoveFirstItem.Image = ((System.Drawing.Image)(resources.GetObject("bindingNavigatorMoveFirstItem.Image")));
        this.bindingNavigatorMoveFirstItem.Name = "bindingNavigatorMoveFirstItem";
        this.bindingNavigatorMoveFirstItem.RightToLeftAutoMirrorImage = true;
        this.bindingNavigatorMoveFirstItem.Size = new System.Drawing.Size(23, 22);
        this.bindingNavigatorMoveFirstItem.Text = "Move first";
        // 
        // bindingNavigatorMovePreviousItem
        // 
        this.bindingNavigatorMovePreviousItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        this.bindingNavigatorMovePreviousItem.Image = ((System.Drawing.Image)(resources.GetObject("bindingNavigatorMovePreviousItem.Image")));
        this.bindingNavigatorMovePreviousItem.Name = "bindingNavigatorMovePreviousItem";
        this.bindingNavigatorMovePreviousItem.RightToLeftAutoMirrorImage = true;
        this.bindingNavigatorMovePreviousItem.Size = new System.Drawing.Size(23, 22);
        this.bindingNavigatorMovePreviousItem.Text = "Move previous";
        // 
        // bindingNavigatorSeparator
        // 
        this.bindingNavigatorSeparator.Name = "bindingNavigatorSeparator";
        this.bindingNavigatorSeparator.Size = new System.Drawing.Size(6, 25);
        // 
        // bindingNavigatorPositionItem
        // 
        this.bindingNavigatorPositionItem.AccessibleName = "Position";
        this.bindingNavigatorPositionItem.AutoSize = false;
        this.bindingNavigatorPositionItem.Name = "bindingNavigatorPositionItem";
        this.bindingNavigatorPositionItem.Size = new System.Drawing.Size(50, 21);
        this.bindingNavigatorPositionItem.Text = "0";
        this.bindingNavigatorPositionItem.ToolTipText = "Current position";
        // 
        // bindingNavigatorSeparator1
        // 
        this.bindingNavigatorSeparator1.Name = "bindingNavigatorSeparator1";
        this.bindingNavigatorSeparator1.Size = new System.Drawing.Size(6, 25);
        // 
        // bindingNavigatorMoveNextItem
        // 
        this.bindingNavigatorMoveNextItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        this.bindingNavigatorMoveNextItem.Image = ((System.Drawing.Image)(resources.GetObject("bindingNavigatorMoveNextItem.Image")));
        this.bindingNavigatorMoveNextItem.Name = "bindingNavigatorMoveNextItem";
        this.bindingNavigatorMoveNextItem.RightToLeftAutoMirrorImage = true;
        this.bindingNavigatorMoveNextItem.Size = new System.Drawing.Size(23, 22);
        this.bindingNavigatorMoveNextItem.Text = "Move next";
        // 
        // bindingNavigatorMoveLastItem
        // 
        this.bindingNavigatorMoveLastItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        this.bindingNavigatorMoveLastItem.Image = ((System.Drawing.Image)(resources.GetObject("bindingNavigatorMoveLastItem.Image")));
        this.bindingNavigatorMoveLastItem.Name = "bindingNavigatorMoveLastItem";
        this.bindingNavigatorMoveLastItem.RightToLeftAutoMirrorImage = true;
        this.bindingNavigatorMoveLastItem.Size = new System.Drawing.Size(23, 22);
        this.bindingNavigatorMoveLastItem.Text = "Move last";
        // 
        // bindingNavigatorSeparator2
        // 
        this.bindingNavigatorSeparator2.Name = "bindingNavigatorSeparator2";
        this.bindingNavigatorSeparator2.Size = new System.Drawing.Size(6, 25);
        // 
        // uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem
        // 
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem.Image = ((System.Drawing.Image)(resources.GetObject("uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem.Image")));
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem.Name = "uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem";
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem.Size = new System.Drawing.Size(23, 22);
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem.Text = "Save Data";
        // 
        // fillToolStrip
        // 
        this.fillToolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.p_start_dateToolStripLabel,
            this.p_start_dateToolStripTextBox,
            this.p_end_dateToolStripLabel,
            this.p_end_dateToolStripTextBox,
            this.fillToolStripButton});
        this.fillToolStrip.Location = new System.Drawing.Point(0, 25);
        this.fillToolStrip.Name = "fillToolStrip";
        this.fillToolStrip.Size = new System.Drawing.Size(804, 25);
        this.fillToolStrip.TabIndex = 9;
        this.fillToolStrip.Text = "fillToolStrip";
        this.fillToolStrip.Visible = false;
        // 
        // p_start_dateToolStripLabel
        // 
        this.p_start_dateToolStripLabel.Name = "p_start_dateToolStripLabel";
        this.p_start_dateToolStripLabel.Size = new System.Drawing.Size(74, 22);
        this.p_start_dateToolStripLabel.Text = "p_start_date:";
        // 
        // p_start_dateToolStripTextBox
        // 
        this.p_start_dateToolStripTextBox.Name = "p_start_dateToolStripTextBox";
        this.p_start_dateToolStripTextBox.Size = new System.Drawing.Size(100, 25);
        // 
        // p_end_dateToolStripLabel
        // 
        this.p_end_dateToolStripLabel.Name = "p_end_dateToolStripLabel";
        this.p_end_dateToolStripLabel.Size = new System.Drawing.Size(69, 22);
        this.p_end_dateToolStripLabel.Text = "p_end_date:";
        // 
        // p_end_dateToolStripTextBox
        // 
        this.p_end_dateToolStripTextBox.Name = "p_end_dateToolStripTextBox";
        this.p_end_dateToolStripTextBox.Size = new System.Drawing.Size(100, 25);
        // 
        // fillToolStripButton
        // 
        this.fillToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
        this.fillToolStripButton.Name = "fillToolStripButton";
        this.fillToolStripButton.Size = new System.Drawing.Size(23, 22);
        this.fillToolStripButton.Text = "Fill";
        // 
        // uspVSYS_SERIAL_LOG_SelectAllDataGridView
        // 
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.AutoGenerateColumns = false;
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn1,
            this.dataGridViewTextBoxColumn2,
            this.dataGridViewTextBoxColumn3,
            this.dataGridViewTextBoxColumn4,
            this.dataGridViewTextBoxColumn5,
            this.dataGridViewTextBoxColumn6,
            this.dataGridViewTextBoxColumn7,
            this.dataGridViewTextBoxColumn8,
            this.dataGridViewTextBoxColumn9,
            this.dataGridViewTextBoxColumn10});
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.DataSource = this.uspVSYS_SERIAL_LOG_SelectAllBindingSource;
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.Location = new System.Drawing.Point(511, 358);
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.Name = "uspVSYS_SERIAL_LOG_SelectAllDataGridView";
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.Size = new System.Drawing.Size(26, 21);
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.TabIndex = 10;
        this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.Visible = false;
        // 
        // label2
        // 
        this.label2.AutoSize = true;
        this.label2.Location = new System.Drawing.Point(51, 328);
        this.label2.Name = "label2";
        this.label2.Size = new System.Drawing.Size(54, 13);
        this.label2.TabIndex = 11;
        this.label2.Text = "Событие:";
        // 
        // action_textBox
        // 
        this.action_textBox.Location = new System.Drawing.Point(111, 325);
        this.action_textBox.Name = "action_textBox";
        this.action_textBox.ReadOnly = true;
        this.action_textBox.Size = new System.Drawing.Size(745, 20);
        this.action_textBox.TabIndex = 12;
        // 
        // dataGridViewTextBoxColumn1
        // 
        this.dataGridViewTextBoxColumn1.DataPropertyName = "id";
        this.dataGridViewTextBoxColumn1.HeaderText = "id";
        this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
        // 
        // dataGridViewTextBoxColumn2
        // 
        this.dataGridViewTextBoxColumn2.DataPropertyName = "sys_status";
        this.dataGridViewTextBoxColumn2.HeaderText = "sys_status";
        this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
        // 
        // dataGridViewTextBoxColumn3
        // 
        this.dataGridViewTextBoxColumn3.DataPropertyName = "sys_date_created";
        this.dataGridViewTextBoxColumn3.HeaderText = "sys_date_created";
        this.dataGridViewTextBoxColumn3.Name = "dataGridViewTextBoxColumn3";
        // 
        // dataGridViewTextBoxColumn4
        // 
        this.dataGridViewTextBoxColumn4.DataPropertyName = "sys_date_modified";
        this.dataGridViewTextBoxColumn4.HeaderText = "sys_date_modified";
        this.dataGridViewTextBoxColumn4.Name = "dataGridViewTextBoxColumn4";
        // 
        // dataGridViewTextBoxColumn5
        // 
        this.dataGridViewTextBoxColumn5.DataPropertyName = "sys_user_modified";
        this.dataGridViewTextBoxColumn5.HeaderText = "sys_user_modified";
        this.dataGridViewTextBoxColumn5.Name = "dataGridViewTextBoxColumn5";
        // 
        // dataGridViewTextBoxColumn6
        // 
        this.dataGridViewTextBoxColumn6.DataPropertyName = "sys_user_created";
        this.dataGridViewTextBoxColumn6.HeaderText = "sys_user_created";
        this.dataGridViewTextBoxColumn6.Name = "dataGridViewTextBoxColumn6";
        // 
        // dataGridViewTextBoxColumn7
        // 
        this.dataGridViewTextBoxColumn7.DataPropertyName = "sys_comment";
        this.dataGridViewTextBoxColumn7.HeaderText = "sys_comment";
        this.dataGridViewTextBoxColumn7.Name = "dataGridViewTextBoxColumn7";
        // 
        // dataGridViewTextBoxColumn8
        // 
        this.dataGridViewTextBoxColumn8.DataPropertyName = "date_created";
        this.dataGridViewTextBoxColumn8.HeaderText = "date_created";
        this.dataGridViewTextBoxColumn8.Name = "dataGridViewTextBoxColumn8";
        // 
        // dataGridViewTextBoxColumn9
        // 
        this.dataGridViewTextBoxColumn9.DataPropertyName = "device_name";
        this.dataGridViewTextBoxColumn9.HeaderText = "device_name";
        this.dataGridViewTextBoxColumn9.Name = "dataGridViewTextBoxColumn9";
        // 
        // dataGridViewTextBoxColumn10
        // 
        this.dataGridViewTextBoxColumn10.DataPropertyName = "message_code";
        this.dataGridViewTextBoxColumn10.HeaderText = "message_code";
        this.dataGridViewTextBoxColumn10.Name = "dataGridViewTextBoxColumn10";
        // 
        // uspVSYS_SERIAL_LOG_SelectAllBindingSource
        // 
        this.uspVSYS_SERIAL_LOG_SelectAllBindingSource.DataMember = "uspVSYS_SERIAL_LOG_SelectAll";
        this.uspVSYS_SERIAL_LOG_SelectAllBindingSource.DataSource = this.angel_to_serialDataSet;
        // 
        // angel_to_serialDataSet
        // 
        this.angel_to_serialDataSet.DataSetName = "angel_to_serialDataSet";
        this.angel_to_serialDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
        // 
        // uspVSYS_SERIAL_LOG_SelectAllTableAdapter
        // 
        this.uspVSYS_SERIAL_LOG_SelectAllTableAdapter.ClearBeforeFill = true;
        // 
        // tableAdapterManager
        // 
        this.tableAdapterManager.BackupDataSetBeforeUpdate = false;
        this.tableAdapterManager.UpdateOrder = SerialPortTerminal.angel_to_serialDataSetTableAdapters.TableAdapterManager.UpdateOrderOption.InsertUpdateDelete;
        this.tableAdapterManager.uspVSYS_SERIAL_LOG_SelectAllTableAdapter = this.uspVSYS_SERIAL_LOG_SelectAllTableAdapter;
        // 
        // frmTerminal
        // 
        this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
        this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
        this.AutoScroll = true;
        this.AutoSize = true;
        this.ClientSize = new System.Drawing.Size(868, 418);
        this.Controls.Add(this.action_textBox);
        this.Controls.Add(this.label2);
        this.Controls.Add(this.uspVSYS_SERIAL_LOG_SelectAllDataGridView);
        this.Controls.Add(this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator);
        this.Controls.Add(this.fillToolStrip);
        this.Controls.Add(this.gbPortSettings);
        this.Controls.Add(this.btnOpenPort);
        this.Controls.Add(this.gbMode);
        this.Controls.Add(this.btnSend);
        this.Controls.Add(this.lblSend);
        this.Controls.Add(this.txtSendData);
        this.Controls.Add(this.rtfTerminal);
        this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
        this.MinimumSize = new System.Drawing.Size(559, 288);
        this.Name = "frmTerminal";
        this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
        this.Text = "Терминал COM порта";
        this.Load += new System.EventHandler(this.frmTerminal_Load);
        this.Shown += new System.EventHandler(this.frmTerminal_Shown);
        this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmTerminal_FormClosing);
        this.gbMode.ResumeLayout(false);
        this.gbMode.PerformLayout();
        this.gbPortSettings.ResumeLayout(false);
        this.gbPortSettings.PerformLayout();
        ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator)).EndInit();
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.ResumeLayout(false);
        this.uspVSYS_SERIAL_LOG_SelectAllBindingNavigator.PerformLayout();
        this.fillToolStrip.ResumeLayout(false);
        this.fillToolStrip.PerformLayout();
        ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_SERIAL_LOG_SelectAllDataGridView)).EndInit();
        ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_SERIAL_LOG_SelectAllBindingSource)).EndInit();
        ((System.ComponentModel.ISupportInitialize)(this.angel_to_serialDataSet)).EndInit();
        this.ResumeLayout(false);
        this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.RichTextBox rtfTerminal;
    private System.Windows.Forms.TextBox txtSendData;
    private System.Windows.Forms.Label lblSend;
    private System.Windows.Forms.Button btnSend;
    private System.Windows.Forms.ComboBox cmbPortName;
    private System.Windows.Forms.ComboBox cmbBaudRate;
    private System.Windows.Forms.RadioButton rbHex;
    private System.Windows.Forms.RadioButton rbText;
    private System.Windows.Forms.GroupBox gbMode;
    private System.Windows.Forms.Label lblComPort;
    private System.Windows.Forms.Label lblBaudRate;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.ComboBox cmbParity;
    private System.Windows.Forms.Label lblDataBits;
    private System.Windows.Forms.ComboBox cmbDataBits;
    private System.Windows.Forms.Label lblStopBits;
    private System.Windows.Forms.ComboBox cmbStopBits;
    private System.Windows.Forms.Button btnOpenPort;
    private System.Windows.Forms.GroupBox gbPortSettings;
    private angel_to_serialDataSet angel_to_serialDataSet;
    private System.Windows.Forms.BindingSource uspVSYS_SERIAL_LOG_SelectAllBindingSource;
    private SerialPortTerminal.angel_to_serialDataSetTableAdapters.uspVSYS_SERIAL_LOG_SelectAllTableAdapter uspVSYS_SERIAL_LOG_SelectAllTableAdapter;
    private SerialPortTerminal.angel_to_serialDataSetTableAdapters.TableAdapterManager tableAdapterManager;
    private System.Windows.Forms.BindingNavigator uspVSYS_SERIAL_LOG_SelectAllBindingNavigator;
    private System.Windows.Forms.ToolStripButton bindingNavigatorAddNewItem;
    private System.Windows.Forms.ToolStripLabel bindingNavigatorCountItem;
    private System.Windows.Forms.ToolStripButton bindingNavigatorDeleteItem;
    private System.Windows.Forms.ToolStripButton bindingNavigatorMoveFirstItem;
    private System.Windows.Forms.ToolStripButton bindingNavigatorMovePreviousItem;
    private System.Windows.Forms.ToolStripSeparator bindingNavigatorSeparator;
    private System.Windows.Forms.ToolStripTextBox bindingNavigatorPositionItem;
    private System.Windows.Forms.ToolStripSeparator bindingNavigatorSeparator1;
    private System.Windows.Forms.ToolStripButton bindingNavigatorMoveNextItem;
    private System.Windows.Forms.ToolStripButton bindingNavigatorMoveLastItem;
    private System.Windows.Forms.ToolStripSeparator bindingNavigatorSeparator2;
    private System.Windows.Forms.ToolStripButton uspVSYS_SERIAL_LOG_SelectAllBindingNavigatorSaveItem;
    private System.Windows.Forms.ToolStrip fillToolStrip;
    private System.Windows.Forms.ToolStripLabel p_start_dateToolStripLabel;
    private System.Windows.Forms.ToolStripTextBox p_start_dateToolStripTextBox;
    private System.Windows.Forms.ToolStripLabel p_end_dateToolStripLabel;
    private System.Windows.Forms.ToolStripTextBox p_end_dateToolStripTextBox;
    private System.Windows.Forms.ToolStripButton fillToolStripButton;
    private System.Windows.Forms.DataGridView uspVSYS_SERIAL_LOG_SelectAllDataGridView;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn4;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn6;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn7;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn8;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn9;
    private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn10;
    private System.Windows.Forms.Label label2;
    private System.Windows.Forms.TextBox action_textBox;
  }
}

