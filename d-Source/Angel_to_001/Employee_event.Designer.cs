namespace Angel_to_001
{
    partial class Employee_event
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Employee_event));
            this.end_dateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.start_dateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.button_find = new System.Windows.Forms.Button();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.p_searchtextBox = new System.Windows.Forms.TextBox();
            this.aNGEL_TO_001 = new Angel_to_001.ANGEL_TO_001();
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter = new Angel_to_001.ANGEL_TO_001TableAdapters.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter();
            this.fillToolStrip = new System.Windows.Forms.ToolStrip();
            this.p_date_startedToolStripLabel = new System.Windows.Forms.ToolStripLabel();
            this.p_date_startedToolStripTextBox = new System.Windows.Forms.ToolStripTextBox();
            this.p_date_endedToolStripLabel = new System.Windows.Forms.ToolStripLabel();
            this.p_date_endedToolStripTextBox = new System.Windows.Forms.ToolStripTextBox();
            this.p_StrToolStripLabel = new System.Windows.Forms.ToolStripLabel();
            this.p_StrToolStripTextBox = new System.Windows.Forms.ToolStripTextBox();
            this.fillToolStripButton = new System.Windows.Forms.ToolStripButton();
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView = new System.Windows.Forms.DataGridView();
            this.id = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_status = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_comment = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_date_modified = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_date_created = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_user_modified = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_user_created = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.employee_id = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.short_FIO = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.events = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.date_started = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.date_ended = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.lastname = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.name = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.surname = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.birthdate = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.InsertToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.choose_eventToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.payable_holiday_eventToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.not_payable_holiday_eventToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.termination_eventToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.EditToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.DeleteToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.button_ok = new System.Windows.Forms.Button();
            this.button_cancel = new System.Windows.Forms.Button();
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator = new System.Windows.Forms.BindingNavigator(this.components);
            this.toolStripLabel1 = new System.Windows.Forms.ToolStripLabel();
            this.toolStripButton1 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton2 = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripTextBox1 = new System.Windows.Forms.ToolStripTextBox();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripButton3 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton4 = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem = new System.Windows.Forms.ToolStripButton();
            this.p_Top_n_by_RanktextBox = new System.Windows.Forms.TextBox();
            this.p_search_typetextBox = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.aNGEL_TO_001)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource)).BeginInit();
            this.fillToolStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView)).BeginInit();
            this.contextMenuStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator)).BeginInit();
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.SuspendLayout();
            this.SuspendLayout();
            // 
            // end_dateTimePicker
            // 
            this.end_dateTimePicker.CustomFormat = "dd.MM.YYYY";
            this.end_dateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.end_dateTimePicker.Location = new System.Drawing.Point(523, 30);
            this.end_dateTimePicker.Name = "end_dateTimePicker";
            this.end_dateTimePicker.Size = new System.Drawing.Size(85, 20);
            this.end_dateTimePicker.TabIndex = 33;
            this.end_dateTimePicker.ValueChanged += new System.EventHandler(this.end_dateTimePicker_ValueChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(411, 34);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(94, 13);
            this.label2.TabIndex = 35;
            this.label2.Text = "Дата события по";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(200, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(94, 13);
            this.label1.TabIndex = 34;
            this.label1.Text = "Дата  события  с";
            // 
            // start_dateTimePicker
            // 
            this.start_dateTimePicker.CustomFormat = "dd.MM.YYYY";
            this.start_dateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.start_dateTimePicker.Location = new System.Drawing.Point(303, 30);
            this.start_dateTimePicker.Name = "start_dateTimePicker";
            this.start_dateTimePicker.Size = new System.Drawing.Size(83, 20);
            this.start_dateTimePicker.TabIndex = 32;
            this.start_dateTimePicker.Value = new System.DateTime(2008, 3, 7, 0, 0, 0, 0);
            this.start_dateTimePicker.ValueChanged += new System.EventHandler(this.start_dateTimePicker_ValueChanged);
            // 
            // button_find
            // 
            this.button_find.ImageKey = "viewer6_large.ico";
            this.button_find.ImageList = this.imageList1;
            this.button_find.Location = new System.Drawing.Point(164, 30);
            this.button_find.Name = "button_find";
            this.button_find.Size = new System.Drawing.Size(30, 20);
            this.button_find.TabIndex = 31;
            this.button_find.UseVisualStyleBackColor = true;
            this.button_find.Click += new System.EventHandler(this.button_find_Click);
            // 
            // imageList1
            // 
            this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "Check File_large.ico");
            this.imageList1.Images.SetKeyName(1, "uncheck_large.ico");
            this.imageList1.Images.SetKeyName(2, "viewer6_large.ico");
            this.imageList1.Images.SetKeyName(3, "Check File_large2.ico");
            this.imageList1.Images.SetKeyName(4, "Uncheck File_large2.ico");
            // 
            // p_searchtextBox
            // 
            this.p_searchtextBox.Location = new System.Drawing.Point(12, 30);
            this.p_searchtextBox.Name = "p_searchtextBox";
            this.p_searchtextBox.Size = new System.Drawing.Size(139, 20);
            this.p_searchtextBox.TabIndex = 30;
            // 
            // aNGEL_TO_001
            // 
            this.aNGEL_TO_001.DataSetName = "ANGEL_TO_001";
            this.aNGEL_TO_001.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource
            // 
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.DataMember = "uspVPRT_EMPLOYEE_EVENT_SelectAll";
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.DataSource = this.aNGEL_TO_001;
            // 
            // uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter
            // 
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter.ClearBeforeFill = true;
            // 
            // fillToolStrip
            // 
            this.fillToolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.p_date_startedToolStripLabel,
            this.p_date_startedToolStripTextBox,
            this.p_date_endedToolStripLabel,
            this.p_date_endedToolStripTextBox,
            this.p_StrToolStripLabel,
            this.p_StrToolStripTextBox,
            this.fillToolStripButton});
            this.fillToolStrip.Location = new System.Drawing.Point(0, 0);
            this.fillToolStrip.Name = "fillToolStrip";
            this.fillToolStrip.Size = new System.Drawing.Size(625, 25);
            this.fillToolStrip.TabIndex = 37;
            this.fillToolStrip.Text = "fillToolStrip";
            this.fillToolStrip.Visible = false;
            // 
            // p_date_startedToolStripLabel
            // 
            this.p_date_startedToolStripLabel.Name = "p_date_startedToolStripLabel";
            this.p_date_startedToolStripLabel.Size = new System.Drawing.Size(86, 22);
            this.p_date_startedToolStripLabel.Text = "p_date_started:";
            // 
            // p_date_startedToolStripTextBox
            // 
            this.p_date_startedToolStripTextBox.Name = "p_date_startedToolStripTextBox";
            this.p_date_startedToolStripTextBox.Size = new System.Drawing.Size(100, 25);
            // 
            // p_date_endedToolStripLabel
            // 
            this.p_date_endedToolStripLabel.Name = "p_date_endedToolStripLabel";
            this.p_date_endedToolStripLabel.Size = new System.Drawing.Size(81, 22);
            this.p_date_endedToolStripLabel.Text = "p_date_ended:";
            // 
            // p_date_endedToolStripTextBox
            // 
            this.p_date_endedToolStripTextBox.Name = "p_date_endedToolStripTextBox";
            this.p_date_endedToolStripTextBox.Size = new System.Drawing.Size(100, 25);
            // 
            // p_StrToolStripLabel
            // 
            this.p_StrToolStripLabel.Name = "p_StrToolStripLabel";
            this.p_StrToolStripLabel.Size = new System.Drawing.Size(37, 22);
            this.p_StrToolStripLabel.Text = "p_Str:";
            // 
            // p_StrToolStripTextBox
            // 
            this.p_StrToolStripTextBox.Name = "p_StrToolStripTextBox";
            this.p_StrToolStripTextBox.Size = new System.Drawing.Size(100, 25);
            // 
            // fillToolStripButton
            // 
            this.fillToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.fillToolStripButton.Name = "fillToolStripButton";
            this.fillToolStripButton.Size = new System.Drawing.Size(23, 22);
            this.fillToolStripButton.Text = "Fill";
            // 
            // uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView
            // 
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.AutoGenerateColumns = false;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.id,
            this.sys_status,
            this.sys_comment,
            this.sys_date_modified,
            this.sys_date_created,
            this.sys_user_modified,
            this.sys_user_created,
            this.employee_id,
            this.short_FIO,
            this.events,
            this.date_started,
            this.date_ended,
            this.lastname,
            this.name,
            this.surname,
            this.birthdate});
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.ContextMenuStrip = this.contextMenuStrip1;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.DataSource = this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.Location = new System.Drawing.Point(12, 76);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.Name = "uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView";
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.Size = new System.Drawing.Size(596, 338);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.TabIndex = 37;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CellValueChanged);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CellBeginEdit);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentCellChanged += new System.EventHandler(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CurrentCellChanged);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.DataError += new System.Windows.Forms.DataGridViewDataErrorEventHandler(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_DataError);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CellContentClick);
            // 
            // id
            // 
            this.id.DataPropertyName = "id";
            this.id.HeaderText = "id";
            this.id.Name = "id";
            this.id.Visible = false;
            this.id.Width = 40;
            // 
            // sys_status
            // 
            this.sys_status.DataPropertyName = "sys_status";
            this.sys_status.HeaderText = "sys_status";
            this.sys_status.Name = "sys_status";
            this.sys_status.Visible = false;
            this.sys_status.Width = 81;
            // 
            // sys_comment
            // 
            this.sys_comment.DataPropertyName = "sys_comment";
            this.sys_comment.HeaderText = "sys_comment";
            this.sys_comment.Name = "sys_comment";
            this.sys_comment.Visible = false;
            this.sys_comment.Width = 96;
            // 
            // sys_date_modified
            // 
            this.sys_date_modified.DataPropertyName = "sys_date_modified";
            this.sys_date_modified.HeaderText = "sys_date_modified";
            this.sys_date_modified.Name = "sys_date_modified";
            this.sys_date_modified.Visible = false;
            this.sys_date_modified.Width = 119;
            // 
            // sys_date_created
            // 
            this.sys_date_created.DataPropertyName = "sys_date_created";
            this.sys_date_created.HeaderText = "sys_date_created";
            this.sys_date_created.Name = "sys_date_created";
            this.sys_date_created.Visible = false;
            this.sys_date_created.Width = 116;
            // 
            // sys_user_modified
            // 
            this.sys_user_modified.DataPropertyName = "sys_user_modified";
            this.sys_user_modified.HeaderText = "sys_user_modified";
            this.sys_user_modified.Name = "sys_user_modified";
            this.sys_user_modified.Visible = false;
            this.sys_user_modified.Width = 118;
            // 
            // sys_user_created
            // 
            this.sys_user_created.DataPropertyName = "sys_user_created";
            this.sys_user_created.HeaderText = "sys_user_created";
            this.sys_user_created.Name = "sys_user_created";
            this.sys_user_created.Visible = false;
            this.sys_user_created.Width = 115;
            // 
            // employee_id
            // 
            this.employee_id.DataPropertyName = "employee_id";
            this.employee_id.HeaderText = "employee_id";
            this.employee_id.Name = "employee_id";
            this.employee_id.Visible = false;
            this.employee_id.Width = 91;
            // 
            // short_FIO
            // 
            this.short_FIO.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells;
            this.short_FIO.DataPropertyName = "short_FIO";
            this.short_FIO.HeaderText = "ФИО";
            this.short_FIO.Name = "short_FIO";
            this.short_FIO.ReadOnly = true;
            this.short_FIO.Width = 59;
            // 
            // events
            // 
            this.events.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells;
            this.events.DataPropertyName = "event";
            this.events.HeaderText = "Событие";
            this.events.Name = "events";
            this.events.ReadOnly = true;
            this.events.Width = 76;
            // 
            // date_started
            // 
            this.date_started.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.AllCells;
            this.date_started.DataPropertyName = "date_started";
            this.date_started.HeaderText = "Дата начала";
            this.date_started.Name = "date_started";
            this.date_started.ReadOnly = true;
            this.date_started.Width = 96;
            // 
            // date_ended
            // 
            this.date_ended.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.date_ended.DataPropertyName = "date_ended";
            this.date_ended.HeaderText = "Дата окончания";
            this.date_ended.Name = "date_ended";
            this.date_ended.ReadOnly = true;
            // 
            // lastname
            // 
            this.lastname.DataPropertyName = "lastname";
            this.lastname.HeaderText = "lastname";
            this.lastname.Name = "lastname";
            this.lastname.Visible = false;
            this.lastname.Width = 74;
            // 
            // name
            // 
            this.name.DataPropertyName = "name";
            this.name.HeaderText = "name";
            this.name.Name = "name";
            this.name.Visible = false;
            this.name.Width = 58;
            // 
            // surname
            // 
            this.surname.DataPropertyName = "surname";
            this.surname.HeaderText = "surname";
            this.surname.Name = "surname";
            this.surname.Visible = false;
            this.surname.Width = 72;
            // 
            // birthdate
            // 
            this.birthdate.DataPropertyName = "birthdate";
            this.birthdate.HeaderText = "birthdate";
            this.birthdate.Name = "birthdate";
            this.birthdate.Visible = false;
            this.birthdate.Width = 73;
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.InsertToolStripMenuItem,
            this.choose_eventToolStripMenuItem,
            this.EditToolStripMenuItem,
            this.DeleteToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.RenderMode = System.Windows.Forms.ToolStripRenderMode.Professional;
            this.contextMenuStrip1.Size = new System.Drawing.Size(176, 92);
            // 
            // InsertToolStripMenuItem
            // 
            this.InsertToolStripMenuItem.Name = "InsertToolStripMenuItem";
            this.InsertToolStripMenuItem.Size = new System.Drawing.Size(175, 22);
            this.InsertToolStripMenuItem.Text = "Создать";
            this.InsertToolStripMenuItem.Click += new System.EventHandler(this.InsertToolStripMenuItem_Click);
            // 
            // choose_eventToolStripMenuItem
            // 
            this.choose_eventToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.payable_holiday_eventToolStripMenuItem,
            this.not_payable_holiday_eventToolStripMenuItem,
            this.termination_eventToolStripMenuItem});
            this.choose_eventToolStripMenuItem.Name = "choose_eventToolStripMenuItem";
            this.choose_eventToolStripMenuItem.Size = new System.Drawing.Size(175, 22);
            this.choose_eventToolStripMenuItem.Text = "Выбрать событие";
            this.choose_eventToolStripMenuItem.Visible = false;
            // 
            // payable_holiday_eventToolStripMenuItem
            // 
            this.payable_holiday_eventToolStripMenuItem.Name = "payable_holiday_eventToolStripMenuItem";
            this.payable_holiday_eventToolStripMenuItem.Size = new System.Drawing.Size(210, 22);
            this.payable_holiday_eventToolStripMenuItem.Text = "Оплачиваемый отпуск";
            this.payable_holiday_eventToolStripMenuItem.Click += new System.EventHandler(this.payable_holiday_eventToolStripMenuItem_Click);
            // 
            // not_payable_holiday_eventToolStripMenuItem
            // 
            this.not_payable_holiday_eventToolStripMenuItem.Name = "not_payable_holiday_eventToolStripMenuItem";
            this.not_payable_holiday_eventToolStripMenuItem.Size = new System.Drawing.Size(210, 22);
            this.not_payable_holiday_eventToolStripMenuItem.Text = "Неоплачиваемый отпуск";
            this.not_payable_holiday_eventToolStripMenuItem.Click += new System.EventHandler(this.not_payable_holiday_eventToolStripMenuItem_Click);
            // 
            // termination_eventToolStripMenuItem
            // 
            this.termination_eventToolStripMenuItem.Name = "termination_eventToolStripMenuItem";
            this.termination_eventToolStripMenuItem.Size = new System.Drawing.Size(210, 22);
            this.termination_eventToolStripMenuItem.Text = "Увольнение";
            this.termination_eventToolStripMenuItem.Click += new System.EventHandler(this.termination_eventToolStripMenuItem_Click);
            // 
            // EditToolStripMenuItem
            // 
            this.EditToolStripMenuItem.Name = "EditToolStripMenuItem";
            this.EditToolStripMenuItem.Size = new System.Drawing.Size(175, 22);
            this.EditToolStripMenuItem.Text = "Редактировать";
            this.EditToolStripMenuItem.Click += new System.EventHandler(this.EditToolStripMenuItem_Click);
            // 
            // DeleteToolStripMenuItem
            // 
            this.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem";
            this.DeleteToolStripMenuItem.Size = new System.Drawing.Size(175, 22);
            this.DeleteToolStripMenuItem.Text = "Удалить";
            this.DeleteToolStripMenuItem.Click += new System.EventHandler(this.DeleteToolStripMenuItem_Click);
            // 
            // button_ok
            // 
            this.button_ok.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.button_ok.ImageKey = "Check File_large2.ico";
            this.button_ok.ImageList = this.imageList1;
            this.button_ok.Location = new System.Drawing.Point(571, 429);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(37, 23);
            this.button_ok.TabIndex = 40;
            this.button_ok.UseVisualStyleBackColor = true;
            this.button_ok.Click += new System.EventHandler(this.button_ok_Click);
            // 
            // button_cancel
            // 
            this.button_cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button_cancel.ImageKey = "Uncheck File_large2.ico";
            this.button_cancel.ImageList = this.imageList1;
            this.button_cancel.Location = new System.Drawing.Point(528, 429);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(37, 23);
            this.button_cancel.TabIndex = 39;
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator
            // 
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.AddNewItem = null;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.BindingSource = this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.CountItem = this.toolStripLabel1;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.CountItemFormat = "из {0}";
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.DeleteItem = null;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.Dock = System.Windows.Forms.DockStyle.None;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripButton1,
            this.toolStripButton2,
            this.toolStripSeparator1,
            this.toolStripTextBox1,
            this.toolStripLabel1,
            this.toolStripSeparator2,
            this.toolStripButton3,
            this.toolStripButton4,
            this.toolStripSeparator3,
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem});
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.Location = new System.Drawing.Point(242, 429);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.MoveFirstItem = this.toolStripButton1;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.MoveLastItem = this.toolStripButton4;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.MoveNextItem = this.toolStripButton3;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.MovePreviousItem = this.toolStripButton2;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.Name = "uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator";
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.PositionItem = this.toolStripTextBox1;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.Size = new System.Drawing.Size(232, 25);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.TabIndex = 41;
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.Text = "bindingNavigator1";
            // 
            // toolStripLabel1
            // 
            this.toolStripLabel1.Name = "toolStripLabel1";
            this.toolStripLabel1.Size = new System.Drawing.Size(37, 22);
            this.toolStripLabel1.Text = "из {0}";
            this.toolStripLabel1.ToolTipText = "Количество записей";
            // 
            // toolStripButton1
            // 
            this.toolStripButton1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton1.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton1.Image")));
            this.toolStripButton1.Name = "toolStripButton1";
            this.toolStripButton1.RightToLeftAutoMirrorImage = true;
            this.toolStripButton1.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton1.Text = "Move first";
            this.toolStripButton1.ToolTipText = "Первый элемент";
            // 
            // toolStripButton2
            // 
            this.toolStripButton2.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton2.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton2.Image")));
            this.toolStripButton2.Name = "toolStripButton2";
            this.toolStripButton2.RightToLeftAutoMirrorImage = true;
            this.toolStripButton2.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton2.Text = "Move previous";
            this.toolStripButton2.ToolTipText = "Предыдущий элемент";
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripTextBox1
            // 
            this.toolStripTextBox1.AccessibleName = "Position";
            this.toolStripTextBox1.AutoSize = false;
            this.toolStripTextBox1.Name = "toolStripTextBox1";
            this.toolStripTextBox1.Size = new System.Drawing.Size(50, 21);
            this.toolStripTextBox1.Text = "0";
            this.toolStripTextBox1.ToolTipText = "Текущая позиция";
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripButton3
            // 
            this.toolStripButton3.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton3.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton3.Image")));
            this.toolStripButton3.Name = "toolStripButton3";
            this.toolStripButton3.RightToLeftAutoMirrorImage = true;
            this.toolStripButton3.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton3.Text = "Move next";
            this.toolStripButton3.ToolTipText = "Следующий элемент";
            // 
            // toolStripButton4
            // 
            this.toolStripButton4.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton4.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton4.Image")));
            this.toolStripButton4.Name = "toolStripButton4";
            this.toolStripButton4.RightToLeftAutoMirrorImage = true;
            this.toolStripButton4.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton4.Text = "Move last";
            this.toolStripButton4.ToolTipText = "Последний элемент";
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(6, 25);
            // 
            // utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem
            // 
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.Image = ((System.Drawing.Image)(resources.GetObject("utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.Image")));
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.Name = "utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem";
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.Size = new System.Drawing.Size(23, 22);
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.Text = "Save Data";
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.ToolTipText = "Сохранить";
            this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem.Click += new System.EventHandler(this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem_Click);
            // 
            // p_Top_n_by_RanktextBox
            // 
            this.p_Top_n_by_RanktextBox.Location = new System.Drawing.Point(317, 4);
            this.p_Top_n_by_RanktextBox.Name = "p_Top_n_by_RanktextBox";
            this.p_Top_n_by_RanktextBox.Size = new System.Drawing.Size(100, 20);
            this.p_Top_n_by_RanktextBox.TabIndex = 44;
            this.p_Top_n_by_RanktextBox.Visible = false;
            // 
            // p_search_typetextBox
            // 
            this.p_search_typetextBox.Location = new System.Drawing.Point(210, 5);
            this.p_search_typetextBox.Name = "p_search_typetextBox";
            this.p_search_typetextBox.Size = new System.Drawing.Size(100, 20);
            this.p_search_typetextBox.TabIndex = 43;
            this.p_search_typetextBox.Visible = false;
            // 
            // Employee_event
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(625, 466);
            this.Controls.Add(this.p_Top_n_by_RanktextBox);
            this.Controls.Add(this.p_search_typetextBox);
            this.Controls.Add(this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.button_cancel);
            this.Controls.Add(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView);
            this.Controls.Add(this.end_dateTimePicker);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.start_dateTimePicker);
            this.Controls.Add(this.button_find);
            this.Controls.Add(this.p_searchtextBox);
            this.Controls.Add(this.fillToolStrip);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Employee_event";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Отпуск и увольнение сотрудников";
            this.Load += new System.EventHandler(this.Employee_event_Load);
            ((System.ComponentModel.ISupportInitialize)(this.aNGEL_TO_001)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource)).EndInit();
            this.fillToolStrip.ResumeLayout(false);
            this.fillToolStrip.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView)).EndInit();
            this.contextMenuStrip1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator)).EndInit();
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.ResumeLayout(false);
            this.uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DateTimePicker end_dateTimePicker;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DateTimePicker start_dateTimePicker;
        private System.Windows.Forms.Button button_find;
        private System.Windows.Forms.TextBox p_searchtextBox;
        private ANGEL_TO_001 aNGEL_TO_001;
        private System.Windows.Forms.BindingSource uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource;
        private Angel_to_001.ANGEL_TO_001TableAdapters.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter;
        private System.Windows.Forms.ToolStrip fillToolStrip;
        private System.Windows.Forms.ToolStripLabel p_date_startedToolStripLabel;
        private System.Windows.Forms.ToolStripTextBox p_date_startedToolStripTextBox;
        private System.Windows.Forms.ToolStripLabel p_date_endedToolStripLabel;
        private System.Windows.Forms.ToolStripTextBox p_date_endedToolStripTextBox;
        private System.Windows.Forms.ToolStripLabel p_StrToolStripLabel;
        private System.Windows.Forms.ToolStripTextBox p_StrToolStripTextBox;
        private System.Windows.Forms.ToolStripButton fillToolStripButton;
        private System.Windows.Forms.DataGridView uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView;
        private System.Windows.Forms.Button button_ok;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.BindingNavigator uspVPRT_EMPLOYEE_EVENT_SelectAll_BindingNavigator;
        private System.Windows.Forms.ToolStripLabel toolStripLabel1;
        private System.Windows.Forms.ToolStripButton toolStripButton1;
        private System.Windows.Forms.ToolStripButton toolStripButton2;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripTextBox toolStripTextBox1;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripButton toolStripButton3;
        private System.Windows.Forms.ToolStripButton toolStripButton4;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.ToolStripButton utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.ToolStripMenuItem InsertToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem EditToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem DeleteToolStripMenuItem;
        private System.Windows.Forms.TextBox p_Top_n_by_RanktextBox;
        private System.Windows.Forms.TextBox p_search_typetextBox;
        private System.Windows.Forms.ToolStripMenuItem choose_eventToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem payable_holiday_eventToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem not_payable_holiday_eventToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem termination_eventToolStripMenuItem;
        private System.Windows.Forms.DataGridViewTextBoxColumn id;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_status;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_comment;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_date_modified;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_date_created;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_user_modified;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_user_created;
        private System.Windows.Forms.DataGridViewTextBoxColumn employee_id;
        private System.Windows.Forms.DataGridViewTextBoxColumn short_FIO;
        private System.Windows.Forms.DataGridViewTextBoxColumn events;
        private System.Windows.Forms.DataGridViewTextBoxColumn date_started;
        private System.Windows.Forms.DataGridViewTextBoxColumn date_ended;
        private System.Windows.Forms.DataGridViewTextBoxColumn lastname;
        private System.Windows.Forms.DataGridViewTextBoxColumn name;
        private System.Windows.Forms.DataGridViewTextBoxColumn surname;
        private System.Windows.Forms.DataGridViewTextBoxColumn birthdate;
    }
}