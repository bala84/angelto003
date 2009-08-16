/*
 * Created by SharpDevelop.
 * User: ?????????????
 * Date: 04.04.2008
 * Time: 8:10
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
namespace Angel_to_001
{
	partial class Report_setup
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Report_setup));
            this.label4 = new System.Windows.Forms.Label();
            this.button_ok = new System.Windows.Forms.Button();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.button_cancel = new System.Windows.Forms.Button();
            this.cancel_toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.ok_toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.start_date_dateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.end_date_dateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.report_type_comboBox = new System.Windows.Forms.ComboBox();
            this.report_kind_comboBox = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.report_group_comboBox = new System.Windows.Forms.ComboBox();
            this.car_kindtextBox = new System.Windows.Forms.TextBox();
            this.car_kindlabel = new System.Windows.Forms.Label();
            this.button_car_kind = new System.Windows.Forms.Button();
            this.button_car_mark = new System.Windows.Forms.Button();
            this.car_marklabel = new System.Windows.Forms.Label();
            this.car_marktextBox = new System.Windows.Forms.TextBox();
            this.car_kind_idtextBox = new System.Windows.Forms.TextBox();
            this.car_mark_idtextBox = new System.Windows.Forms.TextBox();
            this.button_car = new System.Windows.Forms.Button();
            this.carlabel = new System.Windows.Forms.Label();
            this.state_numbertextBox = new System.Windows.Forms.TextBox();
            this.car_idtextBox = new System.Windows.Forms.TextBox();
            this.wrh_demamd_master_type_idtextBox = new System.Windows.Forms.TextBox();
            this.wrh_demand_master_typecomboBox = new System.Windows.Forms.ComboBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.button_organization = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.organization_nametextBox = new System.Windows.Forms.TextBox();
            this.organization_idtextBox = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.table_typecomboBox = new System.Windows.Forms.ComboBox();
            this.button_warehouse_type = new System.Windows.Forms.Button();
            this.label9 = new System.Windows.Forms.Label();
            this.warehouse_type_snametextBox = new System.Windows.Forms.TextBox();
            this.warehouse_type_idtextBox = new System.Windows.Forms.TextBox();
            this.verify_textBox = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.good_category_idtextBox = new System.Windows.Forms.TextBox();
            this.button_good_category = new System.Windows.Forms.Button();
            this.label10 = new System.Windows.Forms.Label();
            this.good_categorytextBox = new System.Windows.Forms.TextBox();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.verifytextBox2 = new System.Windows.Forms.TextBox();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label4.Location = new System.Drawing.Point(12, 189);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(91, 13);
            this.label4.TabIndex = 107;
            this.label4.Text = "Тип требования:";
            this.label4.Visible = false;
            // 
            // button_ok
            // 
            this.button_ok.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.button_ok.ImageKey = "Check File_large2.ico";
            this.button_ok.ImageList = this.imageList1;
            this.button_ok.Location = new System.Drawing.Point(172, 259);
            this.button_ok.Name = "button_ok";
            this.button_ok.Size = new System.Drawing.Size(37, 23);
            this.button_ok.TabIndex = 22;
            this.button_ok.UseVisualStyleBackColor = true;
            this.button_ok.Click += new System.EventHandler(this.Button_okClick);
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
            this.button_cancel.Location = new System.Drawing.Point(108, 259);
            this.button_cancel.Name = "button_cancel";
            this.button_cancel.Size = new System.Drawing.Size(37, 23);
            this.button_cancel.TabIndex = 23;
            this.button_cancel.UseVisualStyleBackColor = true;
            // 
            // start_date_dateTimePicker
            // 
            this.start_date_dateTimePicker.CustomFormat = "dd.MM.yyyy";
            this.start_date_dateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.start_date_dateTimePicker.Location = new System.Drawing.Point(13, 33);
            this.start_date_dateTimePicker.Name = "start_date_dateTimePicker";
            this.start_date_dateTimePicker.Size = new System.Drawing.Size(90, 20);
            this.start_date_dateTimePicker.TabIndex = 25;
            // 
            // end_date_dateTimePicker
            // 
            this.end_date_dateTimePicker.CustomFormat = "dd.MM.yyyy";
            this.end_date_dateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.end_date_dateTimePicker.Location = new System.Drawing.Point(157, 33);
            this.end_date_dateTimePicker.Name = "end_date_dateTimePicker";
            this.end_date_dateTimePicker.Size = new System.Drawing.Size(85, 20);
            this.end_date_dateTimePicker.TabIndex = 26;
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(13, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(100, 18);
            this.label1.TabIndex = 27;
            this.label1.Text = "Дата начала отчета:";
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(156, 13);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(100, 18);
            this.label2.TabIndex = 28;
            this.label2.Text = "Дата окончания отчета:";
            // 
            // report_type_comboBox
            // 
            this.report_type_comboBox.AutoCompleteCustomSource.AddRange(new string[] {
            "В разрезе месяца",
            "В разрезе года",
            "В разрезе дня"});
            this.report_type_comboBox.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest;
            this.report_type_comboBox.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.report_type_comboBox.FormattingEnabled = true;
            this.report_type_comboBox.Items.AddRange(new object[] {
            "По месяцу",
            "За год",
            "За день"});
            this.report_type_comboBox.Location = new System.Drawing.Point(13, 87);
            this.report_type_comboBox.Name = "report_type_comboBox";
            this.report_type_comboBox.Size = new System.Drawing.Size(131, 21);
            this.report_type_comboBox.TabIndex = 29;
            this.report_type_comboBox.SelectedIndexChanged += new System.EventHandler(this.Report_type_comboBoxSelectedIndexChanged);
            // 
            // report_kind_comboBox
            // 
            this.report_kind_comboBox.AutoCompleteCustomSource.AddRange(new string[] {
            "Excel",
            "CSV",
            "PDF",
            "RTF",
            "HTML",
            "XML"});
            this.report_kind_comboBox.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest;
            this.report_kind_comboBox.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.report_kind_comboBox.Enabled = false;
            this.report_kind_comboBox.FormattingEnabled = true;
            this.report_kind_comboBox.Items.AddRange(new object[] {
            "Excel",
            "CSV",
            "PDF",
            "RTF",
            "HTML",
            "XML"});
            this.report_kind_comboBox.Location = new System.Drawing.Point(13, 168);
            this.report_kind_comboBox.Name = "report_kind_comboBox";
            this.report_kind_comboBox.Size = new System.Drawing.Size(131, 21);
            this.report_kind_comboBox.TabIndex = 30;
            // 
            // label3
            // 
            this.label3.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label3.Location = new System.Drawing.Point(12, 150);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(100, 15);
            this.label3.TabIndex = 31;
            this.label3.Text = "Вид отчета:";
            // 
            // report_group_comboBox
            // 
            this.report_group_comboBox.AutoCompleteCustomSource.AddRange(new string[] {
            "По автоколонне в целом",
            "По марке",
            "По типу автомобиля",
            "По № СТП"});
            this.report_group_comboBox.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest;
            this.report_group_comboBox.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.report_group_comboBox.FormattingEnabled = true;
            this.report_group_comboBox.Items.AddRange(new object[] {
            "По автоколонне в целом",
            "По марке",
            "По типу автомобиля",
            "По № СТП"});
            this.report_group_comboBox.Location = new System.Drawing.Point(156, 87);
            this.report_group_comboBox.Name = "report_group_comboBox";
            this.report_group_comboBox.Size = new System.Drawing.Size(152, 21);
            this.report_group_comboBox.TabIndex = 32;
            this.report_group_comboBox.SelectedIndexChanged += new System.EventHandler(this.Report_group_comboBoxSelectedIndexChanged);
            // 
            // car_kindtextBox
            // 
            this.car_kindtextBox.Location = new System.Drawing.Point(146, 62);
            this.car_kindtextBox.Name = "car_kindtextBox";
            this.car_kindtextBox.Size = new System.Drawing.Size(119, 20);
            this.car_kindtextBox.TabIndex = 33;
            this.car_kindtextBox.Visible = false;
            // 
            // car_kindlabel
            // 
            this.car_kindlabel.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.car_kindlabel.Location = new System.Drawing.Point(147, 48);
            this.car_kindlabel.Name = "car_kindlabel";
            this.car_kindlabel.Size = new System.Drawing.Size(100, 11);
            this.car_kindlabel.TabIndex = 34;
            this.car_kindlabel.Text = "Тип автомобиля";
            this.car_kindlabel.Visible = false;
            // 
            // button_car_kind
            // 
            this.button_car_kind.BackColor = System.Drawing.SystemColors.Control;
            this.button_car_kind.ImageKey = "car.ico";
            this.button_car_kind.ImageList = this.imageList1;
            this.button_car_kind.Location = new System.Drawing.Point(270, 64);
            this.button_car_kind.Name = "button_car_kind";
            this.button_car_kind.Size = new System.Drawing.Size(26, 19);
            this.button_car_kind.TabIndex = 95;
            this.button_car_kind.UseVisualStyleBackColor = false;
            this.button_car_kind.Visible = false;
            this.button_car_kind.Click += new System.EventHandler(this.Button_car_kindClick);
            // 
            // button_car_mark
            // 
            this.button_car_mark.BackColor = System.Drawing.SystemColors.Control;
            this.button_car_mark.ImageKey = "car.ico";
            this.button_car_mark.ImageList = this.imageList1;
            this.button_car_mark.Location = new System.Drawing.Point(272, 64);
            this.button_car_mark.Name = "button_car_mark";
            this.button_car_mark.Size = new System.Drawing.Size(26, 19);
            this.button_car_mark.TabIndex = 98;
            this.button_car_mark.UseVisualStyleBackColor = false;
            this.button_car_mark.Visible = false;
            this.button_car_mark.Click += new System.EventHandler(this.Button_car_markClick);
            // 
            // car_marklabel
            // 
            this.car_marklabel.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.car_marklabel.Location = new System.Drawing.Point(144, 48);
            this.car_marklabel.Name = "car_marklabel";
            this.car_marklabel.Size = new System.Drawing.Size(121, 13);
            this.car_marklabel.TabIndex = 97;
            this.car_marklabel.Text = "Марка автомобиля";
            this.car_marklabel.Visible = false;
            // 
            // car_marktextBox
            // 
            this.car_marktextBox.Location = new System.Drawing.Point(146, 62);
            this.car_marktextBox.Name = "car_marktextBox";
            this.car_marktextBox.Size = new System.Drawing.Size(119, 20);
            this.car_marktextBox.TabIndex = 96;
            this.car_marktextBox.Visible = false;
            // 
            // car_kind_idtextBox
            // 
            this.car_kind_idtextBox.Location = new System.Drawing.Point(281, 137);
            this.car_kind_idtextBox.Name = "car_kind_idtextBox";
            this.car_kind_idtextBox.Size = new System.Drawing.Size(13, 20);
            this.car_kind_idtextBox.TabIndex = 99;
            this.car_kind_idtextBox.Visible = false;
            // 
            // car_mark_idtextBox
            // 
            this.car_mark_idtextBox.Location = new System.Drawing.Point(300, 137);
            this.car_mark_idtextBox.Name = "car_mark_idtextBox";
            this.car_mark_idtextBox.Size = new System.Drawing.Size(13, 20);
            this.car_mark_idtextBox.TabIndex = 100;
            this.car_mark_idtextBox.Visible = false;
            // 
            // button_car
            // 
            this.button_car.BackColor = System.Drawing.SystemColors.Control;
            this.button_car.ImageKey = "car.ico";
            this.button_car.ImageList = this.imageList1;
            this.button_car.Location = new System.Drawing.Point(271, 62);
            this.button_car.Name = "button_car";
            this.button_car.Size = new System.Drawing.Size(26, 19);
            this.button_car.TabIndex = 103;
            this.button_car.UseVisualStyleBackColor = false;
            this.button_car.Visible = false;
            this.button_car.Click += new System.EventHandler(this.Button_carClick);
            // 
            // carlabel
            // 
            this.carlabel.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.carlabel.Location = new System.Drawing.Point(144, 48);
            this.carlabel.Name = "carlabel";
            this.carlabel.Size = new System.Drawing.Size(121, 13);
            this.carlabel.TabIndex = 102;
            this.carlabel.Text = "№ СТП";
            this.carlabel.Visible = false;
            // 
            // state_numbertextBox
            // 
            this.state_numbertextBox.Location = new System.Drawing.Point(146, 63);
            this.state_numbertextBox.Name = "state_numbertextBox";
            this.state_numbertextBox.Size = new System.Drawing.Size(119, 20);
            this.state_numbertextBox.TabIndex = 101;
            this.state_numbertextBox.Visible = false;
            // 
            // car_idtextBox
            // 
            this.car_idtextBox.Location = new System.Drawing.Point(300, 163);
            this.car_idtextBox.Name = "car_idtextBox";
            this.car_idtextBox.Size = new System.Drawing.Size(13, 20);
            this.car_idtextBox.TabIndex = 104;
            this.car_idtextBox.Visible = false;
            // 
            // wrh_demamd_master_type_idtextBox
            // 
            this.wrh_demamd_master_type_idtextBox.Location = new System.Drawing.Point(281, 163);
            this.wrh_demamd_master_type_idtextBox.Name = "wrh_demamd_master_type_idtextBox";
            this.wrh_demamd_master_type_idtextBox.Size = new System.Drawing.Size(11, 20);
            this.wrh_demamd_master_type_idtextBox.TabIndex = 106;
            this.wrh_demamd_master_type_idtextBox.Visible = false;
            // 
            // wrh_demand_master_typecomboBox
            // 
            this.wrh_demand_master_typecomboBox.FormattingEnabled = true;
            this.wrh_demand_master_typecomboBox.Items.AddRange(new object[] {
            "По машине",
            "Для механиков",
            "Расход",
            "Моторный цех"});
            this.wrh_demand_master_typecomboBox.Location = new System.Drawing.Point(13, 205);
            this.wrh_demand_master_typecomboBox.Name = "wrh_demand_master_typecomboBox";
            this.wrh_demand_master_typecomboBox.Size = new System.Drawing.Size(131, 21);
            this.wrh_demand_master_typecomboBox.TabIndex = 105;
            this.wrh_demand_master_typecomboBox.Visible = false;
            this.wrh_demand_master_typecomboBox.SelectedIndexChanged += new System.EventHandler(this.Wrh_demand_master_typecomboBoxSelectedIndexChanged);
            // 
            // label5
            // 
            this.label5.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label5.Location = new System.Drawing.Point(13, 69);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(100, 15);
            this.label5.TabIndex = 108;
            this.label5.Text = "Тип отчета:";
            // 
            // label6
            // 
            this.label6.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label6.Location = new System.Drawing.Point(156, 69);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(100, 15);
            this.label6.TabIndex = 109;
            this.label6.Text = "Фильтр отчета:";
            // 
            // button_organization
            // 
            this.button_organization.ImageKey = "car.ico";
            this.button_organization.ImageList = this.imageList1;
            this.button_organization.Location = new System.Drawing.Point(118, 126);
            this.button_organization.Name = "button_organization";
            this.button_organization.Size = new System.Drawing.Size(26, 19);
            this.button_organization.TabIndex = 112;
            this.button_organization.UseVisualStyleBackColor = true;
            this.button_organization.Visible = false;
            this.button_organization.Click += new System.EventHandler(this.Button_organizationClick);
            // 
            // label7
            // 
            this.label7.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label7.Location = new System.Drawing.Point(12, 111);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(121, 13);
            this.label7.TabIndex = 111;
            this.label7.Text = "Организация";
            this.label7.Visible = false;
            // 
            // organization_nametextBox
            // 
            this.organization_nametextBox.Location = new System.Drawing.Point(13, 126);
            this.organization_nametextBox.Name = "organization_nametextBox";
            this.organization_nametextBox.Size = new System.Drawing.Size(100, 20);
            this.organization_nametextBox.TabIndex = 110;
            this.organization_nametextBox.Visible = false;
            // 
            // organization_idtextBox
            // 
            this.organization_idtextBox.Location = new System.Drawing.Point(281, 189);
            this.organization_idtextBox.Name = "organization_idtextBox";
            this.organization_idtextBox.Size = new System.Drawing.Size(11, 20);
            this.organization_idtextBox.TabIndex = 113;
            this.organization_idtextBox.Visible = false;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label8.Location = new System.Drawing.Point(156, 152);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(67, 13);
            this.label8.TabIndex = 115;
            this.label8.Text = "Тип табеля:";
            this.label8.Visible = false;
            // 
            // table_typecomboBox
            // 
            this.table_typecomboBox.FormattingEnabled = true;
            this.table_typecomboBox.Items.AddRange(new object[] {
            "Обычный",
            "Для отдела кадров(HR)"});
            this.table_typecomboBox.Location = new System.Drawing.Point(146, 105);
            this.table_typecomboBox.Name = "table_typecomboBox";
            this.table_typecomboBox.Size = new System.Drawing.Size(152, 21);
            this.table_typecomboBox.TabIndex = 114;
            this.table_typecomboBox.Visible = false;
            this.table_typecomboBox.SelectedIndexChanged += new System.EventHandler(this.Table_typecomboBoxSelectedIndexChanged);
            // 
            // button_warehouse_type
            // 
            this.button_warehouse_type.BackColor = System.Drawing.SystemColors.Control;
            this.button_warehouse_type.ImageKey = "car.ico";
            this.button_warehouse_type.ImageList = this.imageList1;
            this.button_warehouse_type.Location = new System.Drawing.Point(270, 64);
            this.button_warehouse_type.Name = "button_warehouse_type";
            this.button_warehouse_type.Size = new System.Drawing.Size(26, 19);
            this.button_warehouse_type.TabIndex = 118;
            this.button_warehouse_type.UseVisualStyleBackColor = false;
            this.button_warehouse_type.Visible = false;
            this.button_warehouse_type.Click += new System.EventHandler(this.Button_warehouse_typeClick);
            // 
            // label9
            // 
            this.label9.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label9.Location = new System.Drawing.Point(146, 48);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(121, 13);
            this.label9.TabIndex = 117;
            this.label9.Text = "Склад";
            this.label9.Visible = false;
            // 
            // warehouse_type_snametextBox
            // 
            this.warehouse_type_snametextBox.Location = new System.Drawing.Point(146, 63);
            this.warehouse_type_snametextBox.Name = "warehouse_type_snametextBox";
            this.warehouse_type_snametextBox.Size = new System.Drawing.Size(119, 20);
            this.warehouse_type_snametextBox.TabIndex = 116;
            this.warehouse_type_snametextBox.Visible = false;
            // 
            // warehouse_type_idtextBox
            // 
            this.warehouse_type_idtextBox.Location = new System.Drawing.Point(300, 189);
            this.warehouse_type_idtextBox.Name = "warehouse_type_idtextBox";
            this.warehouse_type_idtextBox.Size = new System.Drawing.Size(11, 20);
            this.warehouse_type_idtextBox.TabIndex = 119;
            this.warehouse_type_idtextBox.Visible = false;
            // 
            // verify_textBox
            // 
            this.verify_textBox.Location = new System.Drawing.Point(3, 166);
            this.verify_textBox.Multiline = true;
            this.verify_textBox.Name = "verify_textBox";
            this.verify_textBox.Size = new System.Drawing.Size(290, 20);
            this.verify_textBox.TabIndex = 120;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.textBox1);
            this.panel1.Controls.Add(this.good_category_idtextBox);
            this.panel1.Controls.Add(this.button_good_category);
            this.panel1.Controls.Add(this.verify_textBox);
            this.panel1.Controls.Add(this.table_typecomboBox);
            this.panel1.Controls.Add(this.label10);
            this.panel1.Controls.Add(this.warehouse_type_snametextBox);
            this.panel1.Controls.Add(this.good_categorytextBox);
            this.panel1.Controls.Add(this.car_marktextBox);
            this.panel1.Controls.Add(this.button_warehouse_type);
            this.panel1.Controls.Add(this.car_kindtextBox);
            this.panel1.Controls.Add(this.state_numbertextBox);
            this.panel1.Controls.Add(this.car_marklabel);
            this.panel1.Controls.Add(this.button_car_kind);
            this.panel1.Controls.Add(this.car_kindlabel);
            this.panel1.Controls.Add(this.carlabel);
            this.panel1.Controls.Add(this.button_car);
            this.panel1.Controls.Add(this.button_car_mark);
            this.panel1.Controls.Add(this.label9);
            this.panel1.Location = new System.Drawing.Point(9, 62);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(304, 191);
            this.panel1.TabIndex = 121;
            // 
            // good_category_idtextBox
            // 
            this.good_category_idtextBox.Location = new System.Drawing.Point(271, 152);
            this.good_category_idtextBox.Name = "good_category_idtextBox";
            this.good_category_idtextBox.Size = new System.Drawing.Size(11, 20);
            this.good_category_idtextBox.TabIndex = 122;
            this.good_category_idtextBox.Visible = false;
            // 
            // button_good_category
            // 
            this.button_good_category.ImageKey = "car.ico";
            this.button_good_category.ImageList = this.imageList1;
            this.button_good_category.Location = new System.Drawing.Point(271, 105);
            this.button_good_category.Name = "button_good_category";
            this.button_good_category.Size = new System.Drawing.Size(26, 19);
            this.button_good_category.TabIndex = 124;
            this.button_good_category.UseVisualStyleBackColor = true;
            this.button_good_category.Visible = false;
            this.button_good_category.Click += new System.EventHandler(this.button_good_category_Click);
            // 
            // label10
            // 
            this.label10.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.label10.Location = new System.Drawing.Point(144, 87);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(121, 13);
            this.label10.TabIndex = 123;
            this.label10.Text = "Товар";
            this.label10.Visible = false;
            this.label10.Click += new System.EventHandler(this.label10_Click);
            // 
            // good_categorytextBox
            // 
            this.good_categorytextBox.Location = new System.Drawing.Point(146, 105);
            this.good_categorytextBox.Name = "good_categorytextBox";
            this.good_categorytextBox.Size = new System.Drawing.Size(119, 20);
            this.good_categorytextBox.TabIndex = 122;
            this.good_categorytextBox.Visible = false;
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(6, 84);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(290, 20);
            this.textBox1.TabIndex = 125;
            // 
            // verifytextBox2
            // 
            this.verifytextBox2.Location = new System.Drawing.Point(15, 288);
            this.verifytextBox2.Multiline = true;
            this.verifytextBox2.Name = "verifytextBox2";
            this.verifytextBox2.Size = new System.Drawing.Size(290, 20);
            this.verifytextBox2.TabIndex = 122;
            // 
            // Report_setup
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(322, 336);
            this.Controls.Add(this.verifytextBox2);
            this.Controls.Add(this.warehouse_type_idtextBox);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.organization_idtextBox);
            this.Controls.Add(this.button_organization);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.organization_nametextBox);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.wrh_demamd_master_type_idtextBox);
            this.Controls.Add(this.wrh_demand_master_typecomboBox);
            this.Controls.Add(this.car_idtextBox);
            this.Controls.Add(this.car_mark_idtextBox);
            this.Controls.Add(this.car_kind_idtextBox);
            this.Controls.Add(this.report_group_comboBox);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.report_kind_comboBox);
            this.Controls.Add(this.report_type_comboBox);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.end_date_dateTimePicker);
            this.Controls.Add(this.start_date_dateTimePicker);
            this.Controls.Add(this.button_ok);
            this.Controls.Add(this.button_cancel);
            this.Controls.Add(this.panel1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Report_setup";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Построить отчет";
            this.Load += new System.EventHandler(this.Report_setupLoad);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.TextBox verify_textBox;
		private System.Windows.Forms.Button button_warehouse_type;
		private System.Windows.Forms.TextBox warehouse_type_idtextBox;
		private System.Windows.Forms.TextBox warehouse_type_snametextBox;
		private System.Windows.Forms.Label label9;
		private System.Windows.Forms.ComboBox table_typecomboBox;
		private System.Windows.Forms.Label label8;
		private System.Windows.Forms.TextBox organization_idtextBox;
		private System.Windows.Forms.TextBox organization_nametextBox;
		private System.Windows.Forms.Label label7;
		private System.Windows.Forms.Button button_organization;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.ComboBox wrh_demand_master_typecomboBox;
		private System.Windows.Forms.TextBox wrh_demamd_master_type_idtextBox;
		private System.Windows.Forms.TextBox car_idtextBox;
		private System.Windows.Forms.Label carlabel;
		private System.Windows.Forms.TextBox state_numbertextBox;
		private System.Windows.Forms.Button button_car;
		private System.Windows.Forms.TextBox car_mark_idtextBox;
		private System.Windows.Forms.TextBox car_kind_idtextBox;
		private System.Windows.Forms.TextBox car_marktextBox;
		private System.Windows.Forms.Label car_marklabel;
		private System.Windows.Forms.Button button_car_mark;
		private System.Windows.Forms.Button button_car_kind;
		private System.Windows.Forms.Label car_kindlabel;
		private System.Windows.Forms.TextBox car_kindtextBox;
		private System.Windows.Forms.ComboBox report_group_comboBox;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.ComboBox report_kind_comboBox;
		private System.Windows.Forms.ComboBox report_type_comboBox;
		private System.Windows.Forms.DateTimePicker end_date_dateTimePicker;
		private System.Windows.Forms.DateTimePicker start_date_dateTimePicker;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ToolTip ok_toolTip;
		private System.Windows.Forms.ToolTip cancel_toolTip;
		private System.Windows.Forms.Button button_cancel;
		private System.Windows.Forms.ImageList imageList1;
		private System.Windows.Forms.Button button_ok;
        private System.Windows.Forms.Button button_good_category;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.TextBox good_categorytextBox;
        private System.Windows.Forms.TextBox good_category_idtextBox;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TextBox verifytextBox2;
	}
}
