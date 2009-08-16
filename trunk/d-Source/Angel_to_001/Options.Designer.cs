namespace Angel_to_001
{
    partial class Options
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
            System.Windows.Forms.TreeNode treeNode1 = new System.Windows.Forms.TreeNode("Общие настройки");
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Options));
            this.treeView1 = new System.Windows.Forms.TreeView();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.fillToolStrip = new System.Windows.Forms.ToolStrip();
            this.p_subsystemToolStripLabel = new System.Windows.Forms.ToolStripLabel();
            this.p_subsystemToolStripTextBox = new System.Windows.Forms.ToolStripTextBox();
            this.fillToolStripButton = new System.Windows.Forms.ToolStripButton();
            this.uspVSYS_CONST_SelectBySubsystemDataGridView = new System.Windows.Forms.DataGridView();
            this.button_ok = new System.Windows.Forms.Button();
            this.imageList2 = new System.Windows.Forms.ImageList(this.components);
            this.button_cancel = new System.Windows.Forms.Button();
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator = new System.Windows.Forms.BindingNavigator(this.components);
            this.bindingNavigatorCountItem = new System.Windows.Forms.ToolStripLabel();
            this.bindingNavigatorMoveFirstItem = new System.Windows.Forms.ToolStripButton();
            this.bindingNavigatorMovePreviousItem = new System.Windows.Forms.ToolStripButton();
            this.bindingNavigatorSeparator = new System.Windows.Forms.ToolStripSeparator();
            this.bindingNavigatorPositionItem = new System.Windows.Forms.ToolStripTextBox();
            this.bindingNavigatorSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.bindingNavigatorMoveNextItem = new System.Windows.Forms.ToolStripButton();
            this.bindingNavigatorMoveLastItem = new System.Windows.Forms.ToolStripButton();
            this.bindingNavigatorSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem = new System.Windows.Forms.ToolStripButton();
            this.uspVSYS_CONST_SelectBySubsystemBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.aNGEL_TO_001 = new Angel_to_001.ANGEL_TO_001();
            this.uspVSYS_CONST_SelectBySubsystemTableAdapter = new Angel_to_001.ANGEL_TO_001TableAdapters.uspVSYS_CONST_SelectBySubsystemTableAdapter();
            this.sys_status = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.datatype = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_comment = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_date_modified = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_date_created = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_user_modified = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_user_created = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.name = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.id = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.description = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.subsystem = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fillToolStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_CONST_SelectBySubsystemDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_CONST_SelectBySubsystemBindingNavigator)).BeginInit();
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_CONST_SelectBySubsystemBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.aNGEL_TO_001)).BeginInit();
            this.SuspendLayout();
            // 
            // treeView1
            // 
            this.treeView1.ImageIndex = 0;
            this.treeView1.ImageList = this.imageList1;
            this.treeView1.Location = new System.Drawing.Point(12, 22);
            this.treeView1.Name = "treeView1";
            treeNode1.Name = "General_options";
            treeNode1.Text = "Общие настройки";
            this.treeView1.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode1});
            this.treeView1.SelectedImageIndex = 0;
            this.treeView1.Size = new System.Drawing.Size(288, 457);
            this.treeView1.TabIndex = 0;
            this.treeView1.DoubleClick += new System.EventHandler(this.treeView1_DoubleClick);
            // 
            // imageList1
            // 
            this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "");
            this.imageList1.Images.SetKeyName(1, "");
            this.imageList1.Images.SetKeyName(2, "");
            this.imageList1.Images.SetKeyName(3, "");
            // 
            // fillToolStrip
            // 
            this.fillToolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.p_subsystemToolStripLabel,
            this.p_subsystemToolStripTextBox,
            this.fillToolStripButton});
            this.fillToolStrip.Location = new System.Drawing.Point(0, 25);
            this.fillToolStrip.Name = "fillToolStrip";
            this.fillToolStrip.Size = new System.Drawing.Size(846, 25);
            this.fillToolStrip.TabIndex = 2;
            this.fillToolStrip.Text = "fillToolStrip";
            this.fillToolStrip.Visible = false;
            // 
            // p_subsystemToolStripLabel
            // 
            this.p_subsystemToolStripLabel.Name = "p_subsystemToolStripLabel";
            this.p_subsystemToolStripLabel.Size = new System.Drawing.Size(74, 22);
            this.p_subsystemToolStripLabel.Text = "p_subsystem:";
            // 
            // p_subsystemToolStripTextBox
            // 
            this.p_subsystemToolStripTextBox.Name = "p_subsystemToolStripTextBox";
            this.p_subsystemToolStripTextBox.Size = new System.Drawing.Size(100, 25);
            // 
            // fillToolStripButton
            // 
            this.fillToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.fillToolStripButton.Name = "fillToolStripButton";
            this.fillToolStripButton.Size = new System.Drawing.Size(23, 22);
            this.fillToolStripButton.Text = "Fill";
            // 
            // uspVSYS_CONST_SelectBySubsystemDataGridView
            // 
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.AutoGenerateColumns = false;
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.sys_status,
            this.datatype,
            this.sys_comment,
            this.sys_date_modified,
            this.sys_date_created,
            this.sys_user_modified,
            this.sys_user_created,
            this.name,
            this.id,
            this.description,
            this.subsystem});
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.DataSource = this.uspVSYS_CONST_SelectBySubsystemBindingSource;
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.Location = new System.Drawing.Point(323, 22);
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.Name = "uspVSYS_CONST_SelectBySubsystemDataGridView";
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.Size = new System.Drawing.Size(593, 415);
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.TabIndex = 3;
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.CellValueChanged += new System.Windows.Forms.DataGridViewCellEventHandler(this.uspVSYS_CONST_SelectBySubsystemDataGridView_CellValueChanged);
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.uspVSYS_CONST_SelectBySubsystemDataGridView_CellBeginEdit);
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.CurrentCellChanged += new System.EventHandler(this.uspVSYS_CONST_SelectBySubsystemDataGridView_CurrentCellChanged);
            this.uspVSYS_CONST_SelectBySubsystemDataGridView.DataError += new System.Windows.Forms.DataGridViewDataErrorEventHandler(this.uspVSYS_CONST_SelectBySubsystemDataGridView_DataError);
            // 
            // button_ok
            // 
            this.button_ok.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.button_ok.ImageKey = "Check File_large2.ico";
            this.button_ok.ImageList = this.imageList2;
            this.button_ok.Location = new System.Drawing.Point(879, 456);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(37, 23);
            this.button_ok.TabIndex = 19;
            this.button_ok.UseVisualStyleBackColor = true;
            // 
            // imageList2
            // 
            this.imageList2.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList2.ImageStream")));
            this.imageList2.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList2.Images.SetKeyName(0, "viewer6_large.ico");
            this.imageList2.Images.SetKeyName(1, "Check File_large.ico");
            this.imageList2.Images.SetKeyName(2, "uncheck_large.ico");
            this.imageList2.Images.SetKeyName(3, "Check File_large2.ico");
            this.imageList2.Images.SetKeyName(4, "Uncheck File_large2.ico");
            // 
            // button_cancel
            // 
            this.button_cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button_cancel.ImageKey = "Uncheck File_large2.ico";
            this.button_cancel.ImageList = this.imageList2;
            this.button_cancel.Location = new System.Drawing.Point(836, 456);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(37, 23);
            this.button_cancel.TabIndex = 18;
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // uspVSYS_CONST_SelectBySubsystemBindingNavigator
            // 
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.AddNewItem = null;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.BindingSource = this.uspVSYS_CONST_SelectBySubsystemBindingSource;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.CountItem = this.bindingNavigatorCountItem;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.CountItemFormat = "из {0}";
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.DeleteItem = null;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.Dock = System.Windows.Forms.DockStyle.None;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.bindingNavigatorMoveFirstItem,
            this.bindingNavigatorMovePreviousItem,
            this.bindingNavigatorSeparator,
            this.bindingNavigatorPositionItem,
            this.bindingNavigatorCountItem,
            this.bindingNavigatorSeparator1,
            this.bindingNavigatorMoveNextItem,
            this.bindingNavigatorMoveLastItem,
            this.bindingNavigatorSeparator2,
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem});
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.Location = new System.Drawing.Point(588, 456);
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.MoveFirstItem = this.bindingNavigatorMoveFirstItem;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.MoveLastItem = this.bindingNavigatorMoveLastItem;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.MoveNextItem = this.bindingNavigatorMoveNextItem;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.MovePreviousItem = this.bindingNavigatorMovePreviousItem;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.Name = "uspVSYS_CONST_SelectBySubsystemBindingNavigator";
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.PositionItem = this.bindingNavigatorPositionItem;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.Size = new System.Drawing.Size(232, 25);
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.TabIndex = 17;
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.Text = "bindingNavigator1";
            // 
            // bindingNavigatorCountItem
            // 
            this.bindingNavigatorCountItem.Name = "bindingNavigatorCountItem";
            this.bindingNavigatorCountItem.Size = new System.Drawing.Size(37, 22);
            this.bindingNavigatorCountItem.Text = "из {0}";
            this.bindingNavigatorCountItem.ToolTipText = "Total number of items";
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
            // uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem
            // 
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem.Image = ((System.Drawing.Image)(resources.GetObject("uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem.Image")));
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem.Name = "uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem";
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem.Size = new System.Drawing.Size(23, 22);
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem.Text = "Save Data";
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem.Click += new System.EventHandler(this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem_Click);
            // 
            // uspVSYS_CONST_SelectBySubsystemBindingSource
            // 
            this.uspVSYS_CONST_SelectBySubsystemBindingSource.DataMember = "uspVSYS_CONST_SelectBySubsystem";
            this.uspVSYS_CONST_SelectBySubsystemBindingSource.DataSource = this.aNGEL_TO_001;
            // 
            // aNGEL_TO_001
            // 
            this.aNGEL_TO_001.DataSetName = "ANGEL_TO_001";
            this.aNGEL_TO_001.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // uspVSYS_CONST_SelectBySubsystemTableAdapter
            // 
            this.uspVSYS_CONST_SelectBySubsystemTableAdapter.ClearBeforeFill = true;
            // 
            // sys_status
            // 
            this.sys_status.DataPropertyName = "sys_status";
            this.sys_status.HeaderText = "sys_status";
            this.sys_status.Name = "sys_status";
            this.sys_status.Visible = false;
            // 
            // datatype
            // 
            this.datatype.DataPropertyName = "datatype";
            this.datatype.HeaderText = "datatype";
            this.datatype.Name = "datatype";
            this.datatype.Visible = false;
            // 
            // sys_comment
            // 
            this.sys_comment.DataPropertyName = "sys_comment";
            this.sys_comment.HeaderText = "sys_comment";
            this.sys_comment.Name = "sys_comment";
            this.sys_comment.Visible = false;
            // 
            // sys_date_modified
            // 
            this.sys_date_modified.DataPropertyName = "sys_date_modified";
            this.sys_date_modified.HeaderText = "sys_date_modified";
            this.sys_date_modified.Name = "sys_date_modified";
            this.sys_date_modified.Visible = false;
            // 
            // sys_date_created
            // 
            this.sys_date_created.DataPropertyName = "sys_date_created";
            this.sys_date_created.HeaderText = "sys_date_created";
            this.sys_date_created.Name = "sys_date_created";
            this.sys_date_created.Visible = false;
            // 
            // sys_user_modified
            // 
            this.sys_user_modified.DataPropertyName = "sys_user_modified";
            this.sys_user_modified.HeaderText = "sys_user_modified";
            this.sys_user_modified.Name = "sys_user_modified";
            this.sys_user_modified.Visible = false;
            // 
            // sys_user_created
            // 
            this.sys_user_created.DataPropertyName = "sys_user_created";
            this.sys_user_created.HeaderText = "sys_user_created";
            this.sys_user_created.Name = "sys_user_created";
            this.sys_user_created.Visible = false;
            // 
            // name
            // 
            this.name.DataPropertyName = "name";
            this.name.HeaderText = "Наименование";
            this.name.Name = "name";
            this.name.ReadOnly = true;
            // 
            // id
            // 
            this.id.DataPropertyName = "id";
            this.id.HeaderText = "Значение";
            this.id.Name = "id";
            // 
            // description
            // 
            this.description.DataPropertyName = "description";
            this.description.HeaderText = "Описание";
            this.description.Name = "description";
            // 
            // subsystem
            // 
            this.subsystem.DataPropertyName = "subsystem";
            this.subsystem.HeaderText = "subsystem";
            this.subsystem.Name = "subsystem";
            this.subsystem.Visible = false;
            // 
            // Options
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(928, 504);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.button_cancel);
            this.Controls.Add(this.uspVSYS_CONST_SelectBySubsystemBindingNavigator);
            this.Controls.Add(this.uspVSYS_CONST_SelectBySubsystemDataGridView);
            this.Controls.Add(this.fillToolStrip);
            this.Controls.Add(this.treeView1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Options";
            this.Text = "Настройки";
            this.Load += new System.EventHandler(this.Options_Load);
            this.fillToolStrip.ResumeLayout(false);
            this.fillToolStrip.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_CONST_SelectBySubsystemDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_CONST_SelectBySubsystemBindingNavigator)).EndInit();
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.ResumeLayout(false);
            this.uspVSYS_CONST_SelectBySubsystemBindingNavigator.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.uspVSYS_CONST_SelectBySubsystemBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.aNGEL_TO_001)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TreeView treeView1;
        private System.Windows.Forms.ImageList imageList1;
        private ANGEL_TO_001 aNGEL_TO_001;
        private System.Windows.Forms.BindingSource uspVSYS_CONST_SelectBySubsystemBindingSource;
        private Angel_to_001.ANGEL_TO_001TableAdapters.uspVSYS_CONST_SelectBySubsystemTableAdapter uspVSYS_CONST_SelectBySubsystemTableAdapter;
        private System.Windows.Forms.ToolStrip fillToolStrip;
        private System.Windows.Forms.ToolStripLabel p_subsystemToolStripLabel;
        private System.Windows.Forms.ToolStripTextBox p_subsystemToolStripTextBox;
        private System.Windows.Forms.ToolStripButton fillToolStripButton;
        private System.Windows.Forms.DataGridView uspVSYS_CONST_SelectBySubsystemDataGridView;
        private System.Windows.Forms.Button button_ok;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.BindingNavigator uspVSYS_CONST_SelectBySubsystemBindingNavigator;
        private System.Windows.Forms.ToolStripLabel bindingNavigatorCountItem;
        private System.Windows.Forms.ToolStripButton bindingNavigatorMoveFirstItem;
        private System.Windows.Forms.ToolStripButton bindingNavigatorMovePreviousItem;
        private System.Windows.Forms.ToolStripSeparator bindingNavigatorSeparator;
        private System.Windows.Forms.ToolStripTextBox bindingNavigatorPositionItem;
        private System.Windows.Forms.ToolStripSeparator bindingNavigatorSeparator1;
        private System.Windows.Forms.ToolStripButton bindingNavigatorMoveNextItem;
        private System.Windows.Forms.ToolStripButton bindingNavigatorMoveLastItem;
        private System.Windows.Forms.ToolStripSeparator bindingNavigatorSeparator2;
        private System.Windows.Forms.ToolStripButton uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem;
        private System.Windows.Forms.ImageList imageList2;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_status;
        private System.Windows.Forms.DataGridViewTextBoxColumn datatype;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_comment;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_date_modified;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_date_created;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_user_modified;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_user_created;
        private System.Windows.Forms.DataGridViewTextBoxColumn name;
        private System.Windows.Forms.DataGridViewTextBoxColumn id;
        private System.Windows.Forms.DataGridViewTextBoxColumn description;
        private System.Windows.Forms.DataGridViewTextBoxColumn subsystem;
    }
}