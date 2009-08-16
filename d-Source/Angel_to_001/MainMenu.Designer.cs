/*
 * Created by SharpDevelop.
 * User: Администратор
 * Date: 17.02.2008
 * Time: 13:04
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
namespace Angel_to_001
{
	partial class MainMenu
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
            System.Windows.Forms.TreeNode treeNode1 = new System.Windows.Forms.TreeNode("Заказ-наряд");
            System.Windows.Forms.TreeNode treeNode2 = new System.Windows.Forms.TreeNode("Заявка на закупку а/з");
            System.Windows.Forms.TreeNode treeNode3 = new System.Windows.Forms.TreeNode("Добавить товар");
            System.Windows.Forms.TreeNode treeNode4 = new System.Windows.Forms.TreeNode("Содержимое склада");
            System.Windows.Forms.TreeNode treeNode5 = new System.Windows.Forms.TreeNode("Склад", new System.Windows.Forms.TreeNode[] {
            treeNode2,
            treeNode3,
            treeNode4});
            System.Windows.Forms.TreeNode treeNode6 = new System.Windows.Forms.TreeNode("Путевые листы");
            System.Windows.Forms.TreeNode treeNode7 = new System.Windows.Forms.TreeNode("Общее состояние автомобилей");
            System.Windows.Forms.TreeNode treeNode8 = new System.Windows.Forms.TreeNode("Состояние автопарка", new System.Windows.Forms.TreeNode[] {
            treeNode7});
            System.Windows.Forms.TreeNode treeNode9 = new System.Windows.Forms.TreeNode("Категории товаров");
            System.Windows.Forms.TreeNode treeNode10 = new System.Windows.Forms.TreeNode("Организации");
            System.Windows.Forms.TreeNode treeNode11 = new System.Windows.Forms.TreeNode("Склады");
            System.Windows.Forms.TreeNode treeNode12 = new System.Windows.Forms.TreeNode("Сотрудники");
            System.Windows.Forms.TreeNode treeNode13 = new System.Windows.Forms.TreeNode("Товары");
            System.Windows.Forms.TreeNode treeNode14 = new System.Windows.Forms.TreeNode("Справочники", new System.Windows.Forms.TreeNode[] {
            treeNode9,
            treeNode10,
            treeNode11,
            treeNode12,
            treeNode13});
            System.Windows.Forms.TreeNode treeNode15 = new System.Windows.Forms.TreeNode("Настройки");
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainMenu));
            this.treeView1 = new System.Windows.Forms.TreeView();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.helpProvider1 = new System.Windows.Forms.HelpProvider();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // treeView1
            // 
            this.treeView1.BackColor = System.Drawing.Color.LightGoldenrodYellow;
            this.treeView1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.treeView1.HotTracking = true;
            this.treeView1.ImageIndex = 0;
            this.treeView1.ImageList = this.imageList1;
            this.treeView1.Location = new System.Drawing.Point(12, 103);
            this.treeView1.Name = "treeView1";
            treeNode1.Name = "Warehouse_order";
            treeNode1.Text = "Заказ-наряд";
            treeNode2.Name = "Wrh_income_order_master";
            treeNode2.Text = "Заявка на закупку а/з";
            treeNode3.Name = "Warehouse_income";
            treeNode3.Text = "Добавить товар";
            treeNode4.Name = "Warehouse_item";
            treeNode4.Text = "Содержимое склада";
            treeNode5.Name = "Warehouse";
            treeNode5.Text = "Склад";
            treeNode6.Name = "Driver list";
            treeNode6.Text = "Путевые листы";
            treeNode7.Name = "Car condition";
            treeNode7.Text = "Общее состояние автомобилей";
            treeNode8.Name = "Car condition_full";
            treeNode8.SelectedImageIndex = 1;
            treeNode8.Text = "Состояние автопарка";
            treeNode9.Name = "Good_category_type";
            treeNode9.Text = "Категории товаров";
            treeNode10.Name = "Organization";
            treeNode10.SelectedImageIndex = 1;
            treeNode10.Text = "Организации";
            treeNode11.Name = "Warehouse_type";
            treeNode11.Text = "Склады";
            treeNode12.Name = "Employee";
            treeNode12.SelectedImageIndex = 1;
            treeNode12.Text = "Сотрудники";
            treeNode13.Name = "Good_category";
            treeNode13.Text = "Товары";
            treeNode14.Name = "Dictionaries";
            treeNode14.SelectedImageIndex = 1;
            treeNode14.Text = "Справочники";
            treeNode15.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(0)))), ((int)(((byte)(64)))));
            treeNode15.Name = "Options";
            treeNode15.Text = "Настройки";
            this.treeView1.Nodes.AddRange(new System.Windows.Forms.TreeNode[] {
            treeNode1,
            treeNode5,
            treeNode6,
            treeNode8,
            treeNode14,
            treeNode15});
            this.treeView1.SelectedImageIndex = 0;
            this.treeView1.ShowNodeToolTips = true;
            this.treeView1.Size = new System.Drawing.Size(335, 350);
            this.treeView1.TabIndex = 0;
            this.treeView1.NodeMouseDoubleClick += new System.Windows.Forms.TreeNodeMouseClickEventHandler(this.treeView1_NodeMouseDoubleClick);
            this.treeView1.AfterSelect += new System.Windows.Forms.TreeViewEventHandler(this.treeView1_AfterSelect);
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
            // pictureBox1
            // 
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(69, 12);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(219, 85);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.pictureBox1.TabIndex = 1;
            this.pictureBox1.TabStop = false;
            // 
            // MainMenu
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.ClientSize = new System.Drawing.Size(359, 465);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.treeView1);
            this.HelpButton = true;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MainMenu";
            this.Text = "Главное меню";
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);

		}
		private System.Windows.Forms.HelpProvider helpProvider1;
		private System.Windows.Forms.TreeView treeView1;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.ImageList imageList1;
		
		
	}
}
