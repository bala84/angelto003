/*
 * Created by SharpDevelop.
 * Date: 04.04.2008
 * Time: 8:10
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

using System;
using System.Drawing;
using System.Windows.Forms;
using System.Diagnostics;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace Angel_to_001
{
	/// <summary>
	/// Description of Report_setup.
	/// </summary>
	public partial class Report_setup : Form
	{
        public string _username;

		public string _report_name = "";
		
		public Report_setup()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			//this.button_ok.DialogResult = DialogResult.OK;
			// this.button_cancel.DialogResult = DialogResult.Cancel;
			// this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
			
			this.start_date_dateTimePicker.Value = DateTime.Now.AddDays(-7.0);
			
			this.end_date_dateTimePicker.Value = DateTime.Now;
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		private void Report_Name_Generate (string p_report_name)
		{
			switch (p_report_name)
			{
				case "Car_work_hour_amount":
					this.Text = "Отчет по рабочим часам автомобилей";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label7.Visible = true;
					break;
				case "Car_work_km_amount":
					this.Text = "Отчет по суммарному пробегу автомобилей";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label7.Visible = true;
					break;
				case "Car_work_exit_amount":
					this.Text = "Отчет по количеству выходов автомобилей";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label7.Visible = true;
					break;
				case "Car_work_fuel_cnmptn_amount":
					this.Text = "Отчет по расходу топлива автомобилей";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label7.Visible = true;
					break;
				case "Wrh_demand":
					this.Text = "Отчет  о требованиях на выдачу товара";
					this.start_date_dateTimePicker.Value = DateTime.Now;
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[2].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this._report_name = "Wrh_demand_day";
					this.wrh_demand_master_typecomboBox.Visible = true;
					this.label4.Visible = true;
					this.wrh_demand_master_typecomboBox.Text = this.wrh_demand_master_typecomboBox.Items[0].ToString();
					this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_car_id.ToString();
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label7.Visible = true;
                    this.label10.Visible = true;
                    this.good_categorytextBox.Visible = true;
                    this.button_good_category.Visible = true;
					break;
				case "Employee_work_hour_amount":
					this.Text = "Табель учета рабочего времени водителей";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.label7.Visible = true;
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label6.Enabled = false;
					this.report_group_comboBox.Enabled = false;
					this.label8.Visible = true;
					this.table_typecomboBox.Text = this.table_typecomboBox.Items[0].ToString();
					this.table_typecomboBox.Visible = true;
					break;
				case "Car_summary":
					this.Text = "Суммарный отчет по машинам";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label7.Visible = true;
					break;
				case "Warehouse_item_day":
					this.Text = "Оборотная ведомость по складу";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.report_group_comboBox.Enabled = false;
					this.label9.Visible = true;
					this.warehouse_type_snametextBox.Visible = true;
					this.button_warehouse_type.Visible = true;
					break;
				case "Driver_list":
					this.Text = "Отчет о путевых листах";
					this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
					this.report_type_comboBox.Enabled = false;
					this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
					this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
					this.organization_nametextBox.Visible = true;
					this.button_organization.Visible = true;
					this.label7.Visible = true;	
					break;
                case "Wrh_order_master":
                    this.Text = "Отчет о заказах-нарядах";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_type_comboBox.Enabled = false;
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.organization_nametextBox.Visible = true;
                    this.button_organization.Visible = true;
                    this.label7.Visible = true;
                    break;
                case "Car_repair_time_day":
                    this.Text = "Отчет о времени ремонта машин";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_type_comboBox.Enabled = false;
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.organization_nametextBox.Visible = true;
                    this.button_organization.Visible = true;
                    this.label7.Visible = true;
                    break;

                case "Car_between_repair_time_day":
                    this.Text = "Отчет о времени наработки на отказ машин";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_type_comboBox.Enabled = false;
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.organization_nametextBox.Visible = true;
                    this.button_organization.Visible = true;
                    this.label7.Visible = true;
                    break;

                case "Car_between_repair_time_day_ato":
                    this.Text = "Отчет о времени наработки на отказ после ТО машин";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_type_comboBox.Enabled = false;
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.organization_nametextBox.Visible = true;
                    this.button_organization.Visible = true;
                    this.label7.Visible = true;
                    break;

                case "Repair_by_car_amount":
                    this.Text = "Отчет о количестве ремонтов по машинам";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_type_comboBox.Enabled = false;
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.organization_nametextBox.Visible = true;
                    this.button_organization.Visible = true;
                    this.label7.Visible = true;
                    break;

                case "Employee_work_hour_amount_mech":
                    this.Text = "Табель учета рабочего времени механиков";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.label7.Visible = true;
                    this.organization_nametextBox.Visible = true;
                    this.button_organization.Visible = true;
                    this.label6.Enabled = false;
                    this.report_group_comboBox.Enabled = false;
                    this.label8.Visible = true;
                    this.table_typecomboBox.Text = this.table_typecomboBox.Items[0].ToString();
                    this.table_typecomboBox.Visible = true;
                    break;

                case "Car_wrh_item_price":
                    this.Text = "Отчет о суммарных затратах на а/з машин";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_type_comboBox.Enabled = false;
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.organization_nametextBox.Visible = true;
                    this.button_organization.Visible = true;
                    this.label7.Visible = true;
                    break;

                case "Warehouse_item_oa_day":
                    this.Text = "Отчет о количестве выданных товаров по складу";
                    this.report_type_comboBox.Text = this.report_type_comboBox.Items[0].ToString();
                    this.report_kind_comboBox.Text = this.report_kind_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Text = this.report_group_comboBox.Items[0].ToString();
                    this.report_group_comboBox.Enabled = false;
                    this.label9.Visible = true;
                    this.warehouse_type_snametextBox.Visible = true;
                    this.button_warehouse_type.Visible = true;
                    break;
					
			}
		}
		
		void Report_setupLoad(object sender, EventArgs e)
		{
			this.Report_Name_Generate (_report_name);
			
		}
		
		void Button_okClick(object sender, EventArgs e)
		{
			try
			{
				ConnectionStringSettings settings;
				settings =
					ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_REPORTS_ConnectionString"];
				string v_report_kind_name = Report_Kind_Name_Generate(this.report_kind_comboBox.Text);
				string v_start_date = @"""" + this.start_date_dateTimePicker.Text + @"""";
				string v_end_date = @"""" + this.end_date_dateTimePicker.Text + @"""";
				string v_conn_string = @"""" + settings.ConnectionString + @"""";
				string v_conn_driver = @"""" + settings.ProviderName + @"""";
				string v_car_kind_id;
				string v_car_kind_sname;
				string v_car_mark_id;
				string v_car_mark_sname;
				string v_car_id;
				string v_state_number;
				string v_wrh_demand_master_type_id;
				string v_wrh_demand_master_type_sname;
				string v_employee_recieve_id;
				string v_employee_recieve_fio;
				string v_organization_id;
				string v_organization_sname;
				string v_employee_type_id;
				string v_employee_type_sname;
                string v_good_category_id;
                string v_good_category_sname;
				string v_report_type;
				
				
				if (this.car_kind_idtextBox.Text != "")
				{
					v_car_kind_id = @" """ + this.car_kind_idtextBox.Text + @"""";
				}
				else
				{
					v_car_kind_id = @" """ + " " + @"""";
				}
				
				if (this.car_kindtextBox.Text != "")
				{
					v_car_kind_sname = @" """ + this.car_kindtextBox.Text + @"""";
				}
				else
				{
					v_car_kind_sname = @" """ + " " + @"""";
				}
				
				if (this.car_mark_idtextBox.Text != "")
				{
					v_car_mark_id = @" """ + this.car_mark_idtextBox.Text + @"""";
				}
				else
				{
					v_car_mark_id = @" """ + " " + @"""";
				}
				
				if (this.car_marktextBox.Text != "")
				{
					v_car_mark_sname = @" """ + this.car_marktextBox.Text + @"""";
				}
				else
				{
					v_car_mark_sname = @" """ + " " + @"""";
				}
				
				if (this.car_idtextBox.Text != "")
				{
					v_car_id = @" """ + this.car_idtextBox.Text + @"""";
				}
				else
				{
					v_car_id = @" """ + " " + @"""";
				}
				
				if (this.state_numbertextBox.Text != "")
				{
					v_state_number = @" """ + this.state_numbertextBox.Text + @"""";
				}
				else
				{
					v_state_number = @" """ + " " + @"""";
				}
				
				v_wrh_demand_master_type_id = @" """ + " " + @"""";
				v_wrh_demand_master_type_sname = @" """ + " " + @"""";
				
				v_employee_recieve_id = @" """ + " " + @"""";
				v_employee_recieve_fio = @" """ + " " + @"""";
				

				if (this.organization_idtextBox.Text != "")
				{
					v_organization_id = @" """ + this.organization_idtextBox.Text + @"""";
				}
				else
				{
					v_organization_id = @" """ + " " + @"""";
				}
				
				
				if (this.organization_nametextBox.Text != "")
				{
					v_organization_sname = @" """ + this.organization_nametextBox.Text + @"""";
				}
				else
				{
					v_organization_sname = @" """ + " " + @"""";
				}
				
				v_employee_type_id = @" """ + " " + @"""";
				v_employee_type_sname = @" """ + " " + @"""";
				
				
				if (this.table_typecomboBox.SelectedIndex == 1)
				{
					v_report_type = @" """ + "HR" + @"""";
				}
				else
				{
					v_report_type = @" """ + " " + @"""";
				}

                if (this.good_categorytextBox.Text != "")
                {
                    v_good_category_sname = @" """ + this.good_categorytextBox.Text + @"""";
                }
                else
                {
                    v_good_category_sname = @" """ + " " + @"""";
                }

                if (this.good_category_idtextBox.Text != "")
                {
                    v_good_category_id = @" """ + this.good_category_idtextBox.Text + @"""";
                }
                else
                {
                    v_good_category_id = @" """ + " " + @"""";
                }
				
				
				
				
				if (settings != null)
				{
					
					Process Proc = new Process();
                    this.verify_textBox.Text = "java " + "-jar reports\\Angel_to_001_reports_fat.jar fill " + "reports\\" + this._report_name + ".jasper "
                                         + v_conn_string + " " + v_conn_driver + " " + v_start_date + " " + v_end_date
                                         + v_car_kind_id + v_car_kind_sname + v_car_mark_id + v_car_mark_sname + v_car_id + v_state_number
                                         + v_wrh_demand_master_type_id + v_wrh_demand_master_type_sname + v_employee_recieve_id + v_employee_recieve_fio
                                         + v_organization_id + v_organization_sname + v_employee_type_id + v_employee_type_sname
                                         + v_report_type + v_good_category_id + v_good_category_sname;
					//MessageBox.Show(v_car_kind_id);
					//MessageBox.Show(this.verify_textBox.Text);
					Proc = Process.Start("java", "-jar reports\\Angel_to_001_reports_fat.jar fill " + "reports\\" + this._report_name + ".jasper "
					                     + v_conn_string + " " + v_conn_driver + " " + v_start_date + " " + v_end_date
					                     + v_car_kind_id + v_car_kind_sname + v_car_mark_id + v_car_mark_sname + v_car_id + v_state_number
					                     + v_wrh_demand_master_type_id + v_wrh_demand_master_type_sname + v_employee_recieve_id + v_employee_recieve_fio
                                         + v_organization_id + v_organization_sname + v_employee_type_id + v_employee_type_sname
                                         + v_report_type + v_good_category_id + v_good_category_sname
					                    );
					Proc.WaitForExit();
					Proc = Process.Start("java", "-jar -Xmx100m reports\\Angel_to_001_reports_fat.jar " + v_report_kind_name + " "
					                     + "reports\\" + this._report_name + ".jrprint "
					                     + v_conn_string + " " + v_conn_driver + " " + v_start_date + " " + v_end_date
					                     + v_car_kind_id + v_car_kind_sname + v_car_mark_id + v_car_mark_sname + v_car_id + v_state_number
					                     + v_wrh_demand_master_type_id + v_wrh_demand_master_type_sname + v_employee_recieve_id + v_employee_recieve_fio
                                         + v_organization_id + v_organization_sname + v_employee_type_id + v_employee_type_sname
                                         + v_report_type + v_good_category_id + v_good_category_sname
					                    );
                    this.verifytextBox2.Text = "java " + "-jar -Xmx100m reports\\Angel_to_001_reports_fat.jar " + v_report_kind_name + " "
                                         + "reports\\" + this._report_name + ".jrprint "
                                         + v_conn_string + " " + v_conn_driver + " " + v_start_date + " " + v_end_date
                                         + v_car_kind_id + v_car_kind_sname + v_car_mark_id + v_car_mark_sname + v_car_id + v_state_number
                                         + v_wrh_demand_master_type_id + v_wrh_demand_master_type_sname + v_employee_recieve_id + v_employee_recieve_fio
                                         + v_organization_id + v_organization_sname + v_employee_type_id + v_employee_type_sname
                                         + v_report_type + v_good_category_id + v_good_category_sname;
					Proc.WaitForExit();
				}
			}
			catch{}
		}
		string Report_Kind_Name_Generate(string p_value)
		{
			if (p_value.ToLower() == "excel")
			{
				p_value = "xls";
			}
			return p_value.ToLower();
		}
		
		void Report_type_comboBoxSelectedIndexChanged(object sender, EventArgs e)
		{
			if(this.report_type_comboBox.SelectedIndex == 0)
			{
				if (this._report_name == "Wrh_demand_day")
				{
					if (this.wrh_demand_master_typecomboBox.SelectedIndex == 0)
					{
						this._report_name = "Wrh_demand_month";
					}
					if ((this.wrh_demand_master_typecomboBox.SelectedIndex == 1)
					    ||(this.wrh_demand_master_typecomboBox.SelectedIndex == 2)
					    ||(this.wrh_demand_master_typecomboBox.SelectedIndex == 3))
					{
						this._report_name = "Wrh_demand_month_by_reciever";
					}
				}
				
			}
			if(this.report_type_comboBox.SelectedIndex == 2)
			{
				if ((this._report_name == "Wrh_demand_month")
				    ||(this._report_name == "Wrh_demand_month_by_reciever"))
				{
					this._report_name = "Wrh_demand_day";
				}
				
			}
		}
		void Report_group_comboBoxSelectedIndexChanged(object sender, EventArgs e)
		{
			//MessageBox.Show(this.report_group_comboBox.SelectedItem.ToString());
			if(this.report_group_comboBox.SelectedIndex == 1)
			{
				this.car_marklabel.Visible = true;
				this.car_marktextBox.Visible = true;
				this.button_car_mark.Visible = true;
			}
			else
			{
				this.car_marklabel.Visible = false;
				this.car_marktextBox.Visible = false;
				this.button_car_mark.Visible = false;
				this.car_marktextBox.Text = "";
				this.car_mark_idtextBox.Text = "";
			}
			
			if(this.report_group_comboBox.SelectedIndex == 2)
			{
				this.car_kindlabel.Visible = true;
				this.car_kindtextBox.Visible = true;
				this.button_car_kind.Visible = true;
			}
			else
			{
				this.car_kindlabel.Visible = false;
				this.car_kindtextBox.Visible = false;
				this.button_car_kind.Visible = false;
				this.car_kindtextBox.Text = "";
				this.car_kind_idtextBox.Text = "";
			}
			if(this.report_group_comboBox.SelectedIndex == 3)
			{
				this.carlabel.Visible = true;
				this.state_numbertextBox.Visible = true;
				this.button_car.Visible = true;
			}
			else
			{
				this.carlabel.Visible = false;
				this.state_numbertextBox.Visible = false;
				this.button_car.Visible = false;
				this.state_numbertextBox.Text = "";
				this.car_idtextBox.Text = "";
			}
		}
		
		void Button_car_kindClick(object sender, EventArgs e)
		{
			using (Car_kind_chooser Car_kindForm = new Car_kind_chooser())
			{
				Car_kindForm.ShowDialog(this);
				if (Car_kindForm.DialogResult == DialogResult.OK)
				{

					this.car_kindtextBox.Text
						= Car_kindForm.Car_kind_short_name;
					this.car_kind_idtextBox.Text
						= Car_kindForm.Car_kind_id;
				}
			}
		}
		
		void Button_car_markClick(object sender, EventArgs e)
		{
			using (Car_mark Car_markForm = new Car_mark())
			{
				Car_markForm.ShowDialog(this);
				if (Car_markForm.DialogResult == DialogResult.OK)
				{

					this.car_marktextBox.Text
						= Car_markForm.Mark_short_name;
					this.car_mark_idtextBox.Text
						= Car_markForm.Mark_id;
				}
			}
		}
		
		void Button_carClick(object sender, EventArgs e)
		{
			using (Car CarForm = new Car())
			{
				CarForm.ShowDialog(this);
				if (CarForm.DialogResult == DialogResult.OK)
				{

					this.car_idtextBox.Text
						= CarForm.Car_id;
					this.state_numbertextBox.Text
						= CarForm.Car_state_number;
				}
			}
		}
		
		void Wrh_demand_master_typecomboBoxSelectedIndexChanged(object sender, EventArgs e)
		{
			if (this.wrh_demand_master_typecomboBox.SelectedIndex == 1)
			{
				this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_worker_id.ToString();
				if (this.report_type_comboBox.SelectedIndex == 0)
				{
					this._report_name = "Wrh_demand_month_by_reciever";
				}
				if (this.report_type_comboBox.SelectedIndex == 2)
				{
					this._report_name = "Wrh_demand_day";
				}
				
			}
			if (this.wrh_demand_master_typecomboBox.SelectedIndex == 0)
			{
				this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_car_id.ToString();
				if (this.report_type_comboBox.SelectedIndex == 0)
				{
					this._report_name = "Wrh_demand_month";
				}
				if (this.report_type_comboBox.SelectedIndex == 2)
				{
					this._report_name = "Wrh_demand_day";
				}
			}
			
			if (this.wrh_demand_master_typecomboBox.SelectedIndex == 2)
			{
				this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_expense_id.ToString();
				if (this.report_type_comboBox.SelectedIndex == 0)
				{
					this._report_name = "Wrh_demand_month";
				}
				if (this.report_type_comboBox.SelectedIndex == 2)
				{
					this._report_name = "Wrh_demand_day";
				}
			}
			
			if (this.wrh_demand_master_typecomboBox.SelectedIndex == 3)
			{
				this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_motor_id.ToString();
				if (this.report_type_comboBox.SelectedIndex == 0)
				{
					this._report_name = "Wrh_demand_month";
				}
				if (this.report_type_comboBox.SelectedIndex == 2)
				{
					this._report_name = "Wrh_demand_day";
				}
			}
			
		}
		
		void Button_organizationClick(object sender, EventArgs e)
		{
			using (Organization OrganizationForm = new Organization())
			{
				OrganizationForm.ShowDialog(this);
				if (OrganizationForm.DialogResult == DialogResult.OK)
				{

					this.organization_idtextBox.Text
						= OrganizationForm.Org_id;
					this.organization_nametextBox.Text
						= OrganizationForm.Org_sname;
				}
			}
		}
		
		void Table_typecomboBoxSelectedIndexChanged(object sender, EventArgs e)
		{
		}
		
		void Button_warehouse_typeClick(object sender, EventArgs e)
		{
			using (Warehouse_type Warehouse_typeForm = new Warehouse_type())
			{
				Warehouse_typeForm.ShowDialog(this);
				if (Warehouse_typeForm.DialogResult == DialogResult.OK)
				{

					this.warehouse_type_idtextBox.Text
						= Warehouse_typeForm.Warehouse_type_id;
					this.warehouse_type_snametextBox.Text
						= Warehouse_typeForm.Warehouse_type_short_name;
				}
			}
			
		}

        private void label10_Click(object sender, EventArgs e)
        {

        }

        private void button_good_category_Click(object sender, EventArgs e)
        {
            using (Good_category Good_categoryForm = new Good_category())
            {
                Good_categoryForm.ShowDialog(this);
                if (Good_categoryForm.DialogResult == DialogResult.OK)
                {

                    this.good_category_idtextBox.Text
                        = Good_categoryForm.Good_category_id;
                    this.good_categorytextBox.Text
                        = Good_categoryForm.Good_category_sname;
                }
            }
        }
		
	}
}
