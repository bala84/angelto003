/*
 * Created by SharpDevelop.
 * User: Администратор
 * Date: 17.02.2008
 * Time: 13:04
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

using System;
using System.Drawing;
using System.Windows.Forms;

namespace Angel_to_001
{
	/// <summary>
	/// Description of MainMenu.
	/// </summary>
	public partial class MainMenu : Form
	{
        //Переменная для хранения имени пользователя 
        public string _username;

		public MainMenu()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}

        private void treeView1_NodeMouseDoubleClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            
        	if (this.treeView1.SelectedNode.Name == "Warehouse_order")
            {
                using (Warehouse_order Warehouse_orderForm = new Warehouse_order())
                {
                    Warehouse_orderForm._username = _username;
                    this.Visible = false;
                    Warehouse_orderForm.ShowDialog(this);
                };
                this.Visible = true;
            }
        	if (this.treeView1.SelectedNode.Name == "Warehouse_demand")
            {
                using (Warehouse_demand_master Warehouse_demand_masterForm = new Warehouse_demand_master())
                {
                    Warehouse_demand_masterForm._username = _username;
                    this.Visible = false;
                    Warehouse_demand_masterForm.ShowDialog(this);
                };
                this.Visible = true;
            }
        	//Выводим справочник сотрудников при выборе соответствующей ноды
            if (this.treeView1.SelectedNode.Name == "Employee")
            {
                using (Employee EmployeeForm = new Employee())
                {
                    EmployeeForm._username = _username;
                    this.Visible = false;
                    EmployeeForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            //Выводим справочник организаций при выборе соответствующей ноды
            if (this.treeView1.SelectedNode.Name == "Organization")
            {
                using (Organization OrganizationForm = new Organization())
                {
                    OrganizationForm._username = _username;
                    this.Visible = false;
                    OrganizationForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            //Выводим справочник физ. лиц при выборе соответствующей ноды
            if (this.treeView1.SelectedNode.Name == "Person")
            {
                using (Person PersonForm = new Person())
                {
                    PersonForm._username = _username;
                    this.Visible = false;
                    PersonForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            //Выводим справочник автомобилей при выборе соответствующей ноды
            if (this.treeView1.SelectedNode.Name == "Car")
            {
                using (Car CarForm = new Car())
                {
                    CarForm._username = _username;
                    this.Visible = false;
                    CarForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Car condition")
            {
                using (Car_condition Car_conditionForm = new Car_condition())
                {
                    Car_conditionForm._username = _username;
                    this.Visible = false;
                    Car_conditionForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Ts type")
            {
                using (Ts_type Ts_typeForm = new Ts_type())
                {
                    Ts_typeForm._username = _username;
                    this.Visible = false;
                    Ts_typeForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Car mark")
            {
                using (Car_mark Car_markForm = new Car_mark())
                {
                    Car_markForm._username = _username;
                    this.Visible = false;
                    Car_markForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Fuel type")
            {
                using (Fuel_type Fuel_typeForm = new Fuel_type())
                {
                    Fuel_typeForm._username = _username;
                    this.Visible = false;
                    Fuel_typeForm.ShowDialog(this);
                };
                this.Visible = true;
            }

            if (this.treeView1.SelectedNode.Name == "Driver list")
            {
                using (Driver_list_master Driver_list_masterForm = new Driver_list_master())
                {
                    Driver_list_masterForm._username = _username;
                    this.Visible = false;
                    Driver_list_masterForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Warehouse_type")
            {
                using (Warehouse_type Warehouse_typeForm = new Warehouse_type())
                {
                    Warehouse_typeForm._username = _username;
                    this.Visible = false;
                    Warehouse_typeForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Good_category_type")
            {
                using (Good_category_type Good_category_typeForm = new Good_category_type())
                {
                    Good_category_typeForm._username = _username;
                    this.Visible = false;
                    Good_category_typeForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            
            if (this.treeView1.SelectedNode.Name == "Good_category")
            {
                using (Good_category Good_categoryForm = new Good_category())
                {
                    Good_categoryForm._username = _username;
                    this.Visible = false;
                    Good_categoryForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            
            if (this.treeView1.SelectedNode.Name == "Warehouse_item")
            {
                using (Warehouse_item Warehouse_itemForm = new Warehouse_item())
                {
                    Warehouse_itemForm._username = _username;
                    this.Visible = false;
                    Warehouse_itemForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Warehouse_income")
            {
                using (Warehouse_income_master Warehouse_incomeForm = new Warehouse_income_master())
                {
                    Warehouse_incomeForm._username = _username;
                    this.Visible = false;
                    Warehouse_incomeForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Repair_type_master")
            {
                using (Repair_type_master Repair_type_masterForm = new Repair_type_master())
                {
                    Repair_type_masterForm._username = _username;
                    this.Visible = false;
                    Repair_type_masterForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Serial_log")
            {
                using (Serial_log Serial_logForm = new Serial_log())
                {
                    Serial_logForm._username = _username;
                    this.Visible = false;
                    Serial_logForm.ShowDialog(this);  
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Driver_exit_month_plan")
            {
                using (Driver_exit_month_plan Driver_exit_month_planForm = new Driver_exit_month_plan())
                {
                    Driver_exit_month_planForm._username = _username;
                    this.Visible = false;
                    Driver_exit_month_planForm.ShowDialog(this);
                };
                this.Visible = true;
            }
            if (this.treeView1.SelectedNode.Name == "Driver_plan_detail")
            {
                using (Driver_plan_detail Driver_plan_detailForm = new Driver_plan_detail())
                {
                    Driver_plan_detailForm._username = _username;
                    this.Visible = false;
                    Driver_plan_detailForm.ShowDialog(this);
                };
                this.Visible = true;
            }
             if (this.treeView1.SelectedNode.Name == "Load_warehouse_item")
            {
                using (Load_warehouse_item Load_warehouse_itemForm = new Load_warehouse_item())
                {
                    Load_warehouse_itemForm._username = _username;
                    this.Visible = false;
                    Load_warehouse_itemForm.ShowDialog(this);
                };
                this.Visible = true;
            }
             if (this.treeView1.SelectedNode.Name == "Employee_event")
             {
                 using (Employee_event Employee_eventForm = new Employee_event())
                 {
                     Employee_eventForm._username = _username;
                     this.Visible = false;
                     Employee_eventForm.ShowDialog(this);
                 };
                 this.Visible = true;
             }
             if (this.treeView1.SelectedNode.Name == "Return_reason_type")
             {
                 using (Return_reason_type Return_reason_typeForm = new Return_reason_type())
                 {
                     Return_reason_typeForm._username = _username;
                     this.Visible = false;
                     Return_reason_typeForm.ShowDialog(this);
                 };
                 this.Visible = true;
             }
             if (this.treeView1.SelectedNode.Name == "Noexit_reason_type")
             {
                 using (Noexit_reason_type Noexit_reason_typeForm = new Noexit_reason_type())
                 {
                     Noexit_reason_typeForm._username = _username;
                     this.Visible = false;
                     Noexit_reason_typeForm.ShowDialog(this);
                 };
                 this.Visible = true;
             }
             if (this.treeView1.SelectedNode.Name == "Car_return_reason_detail")
             {
                 using (Car_return_reason_detail Car_return_reason_detailForm = new Car_return_reason_detail())
                 {
                     Car_return_reason_detailForm._username = _username;
                     this.Visible = false;
                     Car_return_reason_detailForm.ShowDialog(this);
                 };
                 this.Visible = true;
             }
             if (this.treeView1.SelectedNode.Name == "Car_noexit_reason_detail")
             {
                 using (Car_noexit_reason_detail Car_noexit_reason_detailForm = new Car_noexit_reason_detail())
                 {
                     Car_noexit_reason_detailForm._username = _username;
                     this.Visible = false;
                     Car_noexit_reason_detailForm.ShowDialog(this);
                 };
                 this.Visible = true;
             }
             if (this.treeView1.SelectedNode.Name == "Wrh_income_order_master")
             {
                 using (Wrh_income_order_master Wrh_income_order_masterForm = new Wrh_income_order_master())
                 {
                     Wrh_income_order_masterForm._username = _username;
                     this.Visible = false;
                     Wrh_income_order_masterForm.ShowDialog(this);
                 };
                 this.Visible = true;
             }
             if (this.treeView1.SelectedNode.Name == "Options")
             {
                 using (Options OptionsForm = new Options())
                 {
                     OptionsForm._username = _username;
                     this.Visible = false;
                     OptionsForm.ShowDialog(this);
                 };
                 this.Visible = true;
             }
            if  ((this.treeView1.SelectedNode.Name == "Car_work_hour_amount")
            	||(this.treeView1.SelectedNode.Name == "Car_work_km_amount")
            	||(this.treeView1.SelectedNode.Name == "Car_work_exit_amount")
           		 ||(this.treeView1.SelectedNode.Name == "Car_work_fuel_cnmptn_amount")
           		 ||(this.treeView1.SelectedNode.Name == "Wrh_demand")
           		 ||(this.treeView1.SelectedNode.Name == "Employee_work_hour_amount")
           		 ||(this.treeView1.SelectedNode.Name == "Warehouse_item_day")
           		 ||(this.treeView1.SelectedNode.Name == "Car_summary")
           		 ||(this.treeView1.SelectedNode.Name == "Driver_list")
                || (this.treeView1.SelectedNode.Name == "Wrh_order_master")
                || (this.treeView1.SelectedNode.Name == "Car_repair_time_day")
                || (this.treeView1.SelectedNode.Name == "Car_between_repair_time_day")
                || (this.treeView1.SelectedNode.Name == "Car_between_repair_time_day_ato")
                || (this.treeView1.SelectedNode.Name == "Repair_by_car_amount")
                || (this.treeView1.SelectedNode.Name == "Employee_work_hour_amount_mech")
                || (this.treeView1.SelectedNode.Name == "Car_wrh_item_price")
                || (this.treeView1.SelectedNode.Name == "Warehouse_item_oa_day"))
            {
                using (Report_setup Report_setupForm = new Report_setup())
                {	
                	if (this.treeView1.SelectedNode.Name == "Car_work_hour_amount")
                	{
                		Report_setupForm._report_name = "Car_work_hour_amount";
                	}
                	if (this.treeView1.SelectedNode.Name == "Car_work_km_amount")
                	{
                		Report_setupForm._report_name = "Car_work_km_amount";
                	}
                	if (this.treeView1.SelectedNode.Name == "Car_work_exit_amount")
                	{
                		Report_setupForm._report_name = "Car_work_exit_amount";
                	}
                	if (this.treeView1.SelectedNode.Name == "Car_work_fuel_cnmptn_amount")
                	{
                		Report_setupForm._report_name = "Car_work_fuel_cnmptn_amount";
                	}
                	
                	if (this.treeView1.SelectedNode.Name == "Wrh_demand")
                	{
                		Report_setupForm._report_name = "Wrh_demand";
                	}
                	
                	if (this.treeView1.SelectedNode.Name == "Employee_work_hour_amount")
                	{
                		Report_setupForm._report_name = "Employee_work_hour_amount";
                	}
                	
                	if (this.treeView1.SelectedNode.Name == "Warehouse_item_day")
                	{
                		Report_setupForm._report_name = "Warehouse_item_day";
                	}
                	
                	if (this.treeView1.SelectedNode.Name == "Car_summary")
                	{
                		Report_setupForm._report_name = "Car_summary";
                	}
                	
                	if (this.treeView1.SelectedNode.Name == "Driver_list")
                	{
                		Report_setupForm._report_name = "Driver_list";
                	}

                    if (this.treeView1.SelectedNode.Name == "Wrh_order_master")
                    {
                        Report_setupForm._report_name = "Wrh_order_master";
                    }

                    if (this.treeView1.SelectedNode.Name == "Car_repair_time_day")
                    {
                        Report_setupForm._report_name = "Car_repair_time_day";
                    }

                    if (this.treeView1.SelectedNode.Name == "Car_between_repair_time_day")
                    {
                        Report_setupForm._report_name = "Car_between_repair_time_day";
                    }

                    if (this.treeView1.SelectedNode.Name == "Car_between_repair_time_day_ato")
                    {
                        Report_setupForm._report_name = "Car_between_repair_time_day_ato";
                    }

                    if (this.treeView1.SelectedNode.Name == "Repair_by_car_amount")
                    {
                        Report_setupForm._report_name = "Repair_by_car_amount";
                    }

                    if (this.treeView1.SelectedNode.Name == "Employee_work_hour_amount_mech")
                    {
                        Report_setupForm._report_name = "Employee_work_hour_amount_mech";
                    }

                    if (this.treeView1.SelectedNode.Name == "Car_wrh_item_price")
                    {
                        Report_setupForm._report_name = "Car_wrh_item_price";
                    }

                    if (this.treeView1.SelectedNode.Name == "Warehouse_item_oa_day")
                    {
                        Report_setupForm._report_name = "Warehouse_item_oa_day";
                    }
                    this.Visible = false;
                	Report_setupForm.ShowDialog(this);
                };
                this.Visible = true;
            }
        }

        private void treeView1_AfterSelect(object sender, TreeViewEventArgs e)
        {

        }

	}
}
