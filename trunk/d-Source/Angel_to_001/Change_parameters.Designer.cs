namespace Angel_to_001
{
    partial class Change_parameters
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Change_parameters));
            this.server_nametextBox = new System.Windows.Forms.TextBox();
            this.db_nametextBox = new System.Windows.Forms.TextBox();
            this.usernametextBox = new System.Windows.Forms.TextBox();
            this.button_cancel = new System.Windows.Forms.Button();
            this.button_ok = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.username_pwdmaskedTextBox = new System.Windows.Forms.MaskedTextBox();
            this.printer_nametextBox = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.ar_nametextBox = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.button_save = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // server_nametextBox
            // 
            this.server_nametextBox.Location = new System.Drawing.Point(41, 52);
            this.server_nametextBox.Name = "server_nametextBox";
            this.server_nametextBox.Size = new System.Drawing.Size(270, 20);
            this.server_nametextBox.TabIndex = 0;
            // 
            // db_nametextBox
            // 
            this.db_nametextBox.Location = new System.Drawing.Point(41, 96);
            this.db_nametextBox.Name = "db_nametextBox";
            this.db_nametextBox.Size = new System.Drawing.Size(270, 20);
            this.db_nametextBox.TabIndex = 1;
            // 
            // usernametextBox
            // 
            this.usernametextBox.Location = new System.Drawing.Point(41, 147);
            this.usernametextBox.Name = "usernametextBox";
            this.usernametextBox.Size = new System.Drawing.Size(270, 20);
            this.usernametextBox.TabIndex = 2;
            // 
            // button_cancel
            // 
            this.button_cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button_cancel.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.button_cancel.Location = new System.Drawing.Point(26, 355);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(77, 23);
            this.button_cancel.TabIndex = 10;
            this.button_cancel.Text = "Отмена";
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // button_ok
            // 
            this.button_ok.Enabled = false;
            this.button_ok.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.button_ok.Location = new System.Drawing.Point(252, 355);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(77, 23);
            this.button_ok.TabIndex = 9;
            this.button_ok.Text = "OK";
            this.button_ok.UseVisualStyleBackColor = true;
            this.button_ok.Click += new System.EventHandler(this.button_ok_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(38, 36);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(111, 13);
            this.label1.TabIndex = 11;
            this.label1.Text = "Имя/IP сервера БД:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(38, 80);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(51, 13);
            this.label2.TabIndex = 12;
            this.label2.Text = "Имя БД:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(38, 131);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(125, 13);
            this.label3.TabIndex = 13;
            this.label3.Text = "Имя пользователя БД:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(38, 180);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(141, 13);
            this.label4.TabIndex = 14;
            this.label4.Text = "Пароль пользователя БД:";
            // 
            // username_pwdmaskedTextBox
            // 
            this.username_pwdmaskedTextBox.Location = new System.Drawing.Point(41, 197);
            this.username_pwdmaskedTextBox.Name = "username_pwdmaskedTextBox";
            this.username_pwdmaskedTextBox.PasswordChar = '*';
            this.username_pwdmaskedTextBox.Size = new System.Drawing.Size(270, 20);
            this.username_pwdmaskedTextBox.TabIndex = 15;
            this.username_pwdmaskedTextBox.MaskInputRejected += new System.Windows.Forms.MaskInputRejectedEventHandler(this.maskedTextBox1_MaskInputRejected);
            // 
            // printer_nametextBox
            // 
            this.printer_nametextBox.Location = new System.Drawing.Point(41, 257);
            this.printer_nametextBox.Name = "printer_nametextBox";
            this.printer_nametextBox.Size = new System.Drawing.Size(270, 20);
            this.printer_nametextBox.TabIndex = 18;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(38, 241);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(144, 13);
            this.label6.TabIndex = 19;
            this.label6.Text = "Имя локального принтера:";
            // 
            // ar_nametextBox
            // 
            this.ar_nametextBox.Location = new System.Drawing.Point(41, 310);
            this.ar_nametextBox.Name = "ar_nametextBox";
            this.ar_nametextBox.Size = new System.Drawing.Size(270, 20);
            this.ar_nametextBox.TabIndex = 20;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(38, 294);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(210, 13);
            this.label7.TabIndex = 21;
            this.label7.Text = "Путь установки Adobe Acrobat Reader 8:";
            // 
            // button_save
            // 
            this.button_save.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.button_save.Location = new System.Drawing.Point(118, 355);
            this.button_save.Name = "button_save";
            this.button_save.Size = new System.Drawing.Size(121, 23);
            this.button_save.TabIndex = 22;
            this.button_save.Text = "Сохранить";
            this.button_save.UseVisualStyleBackColor = true;
            this.button_save.Click += new System.EventHandler(this.button_save_Click);
            // 
            // Change_parameters
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(353, 400);
            this.Controls.Add(this.button_save);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.ar_nametextBox);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.printer_nametextBox);
            this.Controls.Add(this.username_pwdmaskedTextBox);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.button_cancel);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.usernametextBox);
            this.Controls.Add(this.db_nametextBox);
            this.Controls.Add(this.server_nametextBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Change_parameters";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Изменить настройки программы";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox server_nametextBox;
        private System.Windows.Forms.TextBox db_nametextBox;
        private System.Windows.Forms.TextBox usernametextBox;
        private System.Windows.Forms.Button button_cancel;
        private System.Windows.Forms.Button button_ok;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.MaskedTextBox username_pwdmaskedTextBox;
        private System.Windows.Forms.TextBox printer_nametextBox;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox ar_nametextBox;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Button button_save;
    }
}