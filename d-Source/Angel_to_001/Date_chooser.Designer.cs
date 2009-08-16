namespace Angel_to_001
{
    partial class Date_chooser
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Date_chooser));
            this.button_ok = new System.Windows.Forms.Button();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.button_cancel = new System.Windows.Forms.Button();
            this.dateTimePicker1 = new System.Windows.Forms.DateTimePicker();
            this.ok_toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.cancel_toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.SuspendLayout();
            // 
            // button_ok
            // 
            this.button_ok.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.button_ok.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.button_ok.ImageKey = "Check File_large2.ico";
            this.button_ok.ImageList = this.imageList1;
            this.button_ok.Location = new System.Drawing.Point(125, 63);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(37, 23);
            this.button_ok.TabIndex = 18;
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
            this.imageList1.Images.SetKeyName(3, "Uncheck File_large2.ico");
            this.imageList1.Images.SetKeyName(4, "Check File_large2.ico");
            // 
            // button_cancel
            // 
            this.button_cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button_cancel.ImageKey = "Uncheck File_large2.ico";
            this.button_cancel.ImageList = this.imageList1;
            this.button_cancel.Location = new System.Drawing.Point(62, 63);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(37, 23);
            this.button_cancel.TabIndex = 17;
            this.cancel_toolTip.SetToolTip(this.button_cancel, "Отмена");
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // dateTimePicker1
            // 
            this.dateTimePicker1.CustomFormat = "";
            this.dateTimePicker1.Location = new System.Drawing.Point(12, 25);
            this.dateTimePicker1.Name = "dateTimePicker1";
            this.dateTimePicker1.Size = new System.Drawing.Size(200, 20);
            this.dateTimePicker1.TabIndex = 19;
            // 
            // Date_chooser
            // 
            this.AcceptButton = this.button_ok;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.CancelButton = this.button_cancel;
            this.ClientSize = new System.Drawing.Size(226, 96);
            this.Controls.Add(this.dateTimePicker1);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.button_cancel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Date_chooser";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Выбрать дату";
            this.Load += new System.EventHandler(this.Date_chooserLoad);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button_ok;
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.DateTimePicker dateTimePicker1;
        private System.Windows.Forms.ToolTip ok_toolTip;
        private System.Windows.Forms.ToolTip cancel_toolTip;
    }
}