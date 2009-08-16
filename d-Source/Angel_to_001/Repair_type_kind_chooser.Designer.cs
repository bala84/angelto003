namespace Angel_to_001
{
    partial class Repair_type_kind_chooser
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Repair_type_kind_chooser));
            this.button_ok = new System.Windows.Forms.Button();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.button_cancel = new System.Windows.Forms.Button();
            this.ok_toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.cancel_toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView = new System.Windows.Forms.DataGridView();
            this.id = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_status = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_comment = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_date_modified = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_date_created = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_user_modified = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sys_user_created = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.short_name = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.full_name = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.aNGEL_TO_001 = new Angel_to_001.ANGEL_TO_001();
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllTableAdapter = new Angel_to_001.ANGEL_TO_001TableAdapters.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllTableAdapter();
            ((System.ComponentModel.ISupportInitialize)(this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.aNGEL_TO_001)).BeginInit();
            this.SuspendLayout();
            // 
            // button_ok
            // 
            this.button_ok.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.button_ok.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.button_ok.ImageKey = "Check File_large2.ico";
            this.button_ok.ImageList = this.imageList1;
            this.button_ok.Location = new System.Drawing.Point(190, 278);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(37, 23);
            this.button_ok.TabIndex = 20;
            this.ok_toolTip.SetToolTip(this.button_ok, "Ок");
            this.button_ok.UseVisualStyleBackColor = true;
            // 
            // imageList1
            // 
            this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "viewer6_large.ico");
            this.imageList1.Images.SetKeyName(1, "Check File_large.ico");
            this.imageList1.Images.SetKeyName(2, "uncheck_large.ico");
            this.imageList1.Images.SetKeyName(3, "Check File_large2.ico");
            this.imageList1.Images.SetKeyName(4, "Uncheck File_large2.ico");
            // 
            // button_cancel
            // 
            this.button_cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button_cancel.ImageKey = "Uncheck File_large2.ico";
            this.button_cancel.ImageList = this.imageList1;
            this.button_cancel.Location = new System.Drawing.Point(127, 278);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(37, 23);
            this.button_cancel.TabIndex = 19;
            this.cancel_toolTip.SetToolTip(this.button_cancel, "Отмена");
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView
            // 
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.AutoGenerateColumns = false;
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.id,
            this.sys_status,
            this.sys_comment,
            this.sys_date_modified,
            this.sys_date_created,
            this.sys_user_modified,
            this.sys_user_created,
            this.short_name,
            this.full_name});
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.DataSource = this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource;
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.Location = new System.Drawing.Point(22, 34);
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.Name = "uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView";
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.Size = new System.Drawing.Size(301, 226);
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.TabIndex = 21;
            // 
            // id
            // 
            this.id.DataPropertyName = "id";
            this.id.HeaderText = "id";
            this.id.Name = "id";
            this.id.Visible = false;
            // 
            // sys_status
            // 
            this.sys_status.DataPropertyName = "sys_status";
            this.sys_status.HeaderText = "sys_status";
            this.sys_status.Name = "sys_status";
            this.sys_status.Visible = false;
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
            // short_name
            // 
            this.short_name.DataPropertyName = "short_name";
            this.short_name.HeaderText = "Наименование";
            this.short_name.Name = "short_name";
            this.short_name.ReadOnly = true;
            // 
            // full_name
            // 
            this.full_name.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.full_name.DataPropertyName = "full_name";
            this.full_name.HeaderText = "full_name";
            this.full_name.Name = "full_name";
            this.full_name.Visible = false;
            // 
            // uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource
            // 
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource.DataMember = "uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAll";
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource.DataSource = this.aNGEL_TO_001;
            // 
            // aNGEL_TO_001
            // 
            this.aNGEL_TO_001.DataSetName = "ANGEL_TO_001";
            this.aNGEL_TO_001.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllTableAdapter
            // 
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllTableAdapter.ClearBeforeFill = true;
            // 
            // Repair_type_kind_chooser
            // 
            this.AcceptButton = this.button_ok;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.CancelButton = this.button_cancel;
            this.ClientSize = new System.Drawing.Size(345, 315);
            this.Controls.Add(this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.button_cancel);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Repair_type_kind_chooser";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Выбрать тип ремонта";
            this.Load += new System.EventHandler(this.Repair_type_kind_chooser_Load);
            ((System.ComponentModel.ISupportInitialize)(this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.aNGEL_TO_001)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button_ok;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.ToolTip ok_toolTip;
        private System.Windows.Forms.ToolTip cancel_toolTip;
        private ANGEL_TO_001 aNGEL_TO_001;
        private System.Windows.Forms.BindingSource uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource;
        private Angel_to_001.ANGEL_TO_001TableAdapters.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllTableAdapter uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllTableAdapter;
        private System.Windows.Forms.DataGridView uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView;
        private System.Windows.Forms.DataGridViewTextBoxColumn id;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_status;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_comment;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_date_modified;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_date_created;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_user_modified;
        private System.Windows.Forms.DataGridViewTextBoxColumn sys_user_created;
        private System.Windows.Forms.DataGridViewTextBoxColumn short_name;
        private System.Windows.Forms.DataGridViewTextBoxColumn full_name;
    }
}