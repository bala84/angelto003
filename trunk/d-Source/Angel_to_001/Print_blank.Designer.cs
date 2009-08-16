namespace Angel_to_001
{
    partial class Print_blank
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Print_blank));
            this.button_ok = new System.Windows.Forms.Button();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.button_cancel = new System.Windows.Forms.Button();
            this.form3_radioButton = new System.Windows.Forms.RadioButton();
            this.form4p_radioButton = new System.Windows.Forms.RadioButton();
            this.numbertextBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.driver_list_type_idtextBox = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // button_ok
            // 
            this.button_ok.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.button_ok.ImageKey = "Check File_large2.ico";
            this.button_ok.ImageList = this.imageList1;
            this.button_ok.Location = new System.Drawing.Point(134, 108);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(37, 23);
            this.button_ok.TabIndex = 114;
            this.button_ok.UseVisualStyleBackColor = true;
            this.button_ok.Click += new System.EventHandler(this.button_ok_Click);
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
            this.imageList1.Images.SetKeyName(5, "car.ico");
            // 
            // button_cancel
            // 
            this.button_cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button_cancel.ImageKey = "Uncheck File_large2.ico";
            this.button_cancel.ImageList = this.imageList1;
            this.button_cancel.Location = new System.Drawing.Point(95, 108);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(37, 23);
            this.button_cancel.TabIndex = 113;
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // form3_radioButton
            // 
            this.form3_radioButton.AutoSize = true;
            this.form3_radioButton.Location = new System.Drawing.Point(46, 33);
            this.form3_radioButton.Name = "form3_radioButton";
            this.form3_radioButton.Size = new System.Drawing.Size(82, 17);
            this.form3_radioButton.TabIndex = 115;
            this.form3_radioButton.TabStop = true;
            this.form3_radioButton.Text = "Форма №3";
            this.form3_radioButton.UseVisualStyleBackColor = true;
            this.form3_radioButton.CheckedChanged += new System.EventHandler(this.form3_radioButton_CheckedChanged);
            // 
            // form4p_radioButton
            // 
            this.form4p_radioButton.AutoSize = true;
            this.form4p_radioButton.Checked = true;
            this.form4p_radioButton.Location = new System.Drawing.Point(46, 71);
            this.form4p_radioButton.Name = "form4p_radioButton";
            this.form4p_radioButton.Size = new System.Drawing.Size(90, 17);
            this.form4p_radioButton.TabIndex = 116;
            this.form4p_radioButton.TabStop = true;
            this.form4p_radioButton.Text = "Форма №4П";
            this.form4p_radioButton.UseVisualStyleBackColor = true;
            this.form4p_radioButton.CheckedChanged += new System.EventHandler(this.form4p_radioButton_CheckedChanged);
            // 
            // numbertextBox
            // 
            this.numbertextBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.numbertextBox.Location = new System.Drawing.Point(161, 50);
            this.numbertextBox.Name = "numbertextBox";
            this.numbertextBox.Size = new System.Drawing.Size(62, 20);
            this.numbertextBox.TabIndex = 117;
            this.numbertextBox.TextChanged += new System.EventHandler(this.numbertextBox_TextChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(148, 33);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(89, 13);
            this.label1.TabIndex = 118;
            this.label1.Text = "Кол-во бланков:";
            // 
            // driver_list_type_idtextBox
            // 
            this.driver_list_type_idtextBox.Location = new System.Drawing.Point(151, 76);
            this.driver_list_type_idtextBox.Name = "driver_list_type_idtextBox";
            this.driver_list_type_idtextBox.Size = new System.Drawing.Size(59, 20);
            this.driver_list_type_idtextBox.TabIndex = 119;
            this.driver_list_type_idtextBox.Visible = false;
            // 
            // Print_blank
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(265, 146);
            this.Controls.Add(this.driver_list_type_idtextBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.numbertextBox);
            this.Controls.Add(this.form4p_radioButton);
            this.Controls.Add(this.form3_radioButton);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.button_cancel);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Print_blank";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Печать бланков";
            this.Load += new System.EventHandler(this.Print_blank_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button_ok;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.RadioButton form3_radioButton;
        private System.Windows.Forms.RadioButton form4p_radioButton;
        private System.Windows.Forms.TextBox numbertextBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox driver_list_type_idtextBox;
    }
}