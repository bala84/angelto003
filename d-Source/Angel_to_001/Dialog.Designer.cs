/*
 * Created by SharpDevelop.
 * User: ?????????????
 * Date: 15.04.2008
 * Time: 7:08
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
namespace Angel_to_001
{
	partial class Dialog
	{
		/// <summary>
		/// Designer variable used to keep track of non-visual components.
		/// </summary>
		private System.ComponentModel.IContainer components = null;
		
		/// <summary>
		/// Disposes resources used by the form.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing) {
				if (components != null) {
					components.Dispose();
				}
			}
			base.Dispose(disposing);
		}
		
		/// <summary>
		/// This method is required for Windows Forms designer support.
		/// Do not change the method contents inside the source code editor. The Forms designer might
		/// not be able to load this method if it was changed manually.
		/// </summary>
		private void InitializeComponent()
		{
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Dialog));
            this.label1 = new System.Windows.Forms.Label();
            this.button_ok = new System.Windows.Forms.Button();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.button_cancel = new System.Windows.Forms.Button();
            this.errorProvider1 = new System.Windows.Forms.ErrorProvider(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(36, 3);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(184, 60);
            this.label1.TabIndex = 0;
            this.label1.Text = "label1";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // button_ok
            // 
            this.button_ok.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.button_ok.ImageKey = "Check File_large2.ico";
            this.button_ok.ImageList = this.imageList1;
            this.button_ok.Location = new System.Drawing.Point(139, 66);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(37, 23);
            this.button_ok.TabIndex = 58;
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
            this.imageList1.Images.SetKeyName(5, "car.ico");
            // 
            // button_cancel
            // 
            this.button_cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button_cancel.ImageKey = "Uncheck File_large2.ico";
            this.button_cancel.ImageList = this.imageList1;
            this.button_cancel.Location = new System.Drawing.Point(76, 66);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(37, 23);
            this.button_cancel.TabIndex = 57;
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // errorProvider1
            // 
            this.errorProvider1.ContainerControl = this;
            // 
            // Dialog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(258, 108);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.button_cancel);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Dialog";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.DialogLoad);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.ResumeLayout(false);

		}
		private System.Windows.Forms.Button button_cancel;
		private System.Windows.Forms.ImageList imageList1;
		private System.Windows.Forms.Button button_ok;
		private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ErrorProvider errorProvider1;
	}
}
