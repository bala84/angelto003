using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Angel_to_001
{
    public partial class Head_order : Form
    {
        public string _username;
        public string _head_order_car_id;
        public string _head_order_number;
        public string _head_order_fio_reciever;
        public string _head_order_fio_reciever_id;
        public string _head_order_driver;
        public string _head_order_state_number;
        public string _head_order_run;
        public string _head_order_fuel_end_left;
        public string _head_order_malfunction_desc;
        public string _head_order_car_mark_model_sname;
        public decimal _head_order_wrh_order_master_type_id = Const.Wrh_order_master_type_car_id;
        public string _head_order_ts_type_sname;
        public string _head_order_speedometer_end_indctn;

        private bool _is_valid = true;
        //Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
        public byte _head_order_form_state;


        Acrobat Printfile = new Acrobat();
        private string _filled_file = "";

        public string Ar_path = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Ar_path"];
        public string Printer_name = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_name"];
        public string Printer_spool = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Spool_path"];
        public string Printer_device = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_device"];




        public Head_order()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }


        private void uspVWRH_WRH_ORDER_MASTER_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {


            this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_MASTER_SelectAll);

            Nullable<decimal> v_id = new Nullable<decimal>();
            Nullable<decimal> v_car_id = new Nullable<decimal>();
            Nullable<decimal> v_repair_type_id = new Nullable<decimal>();
            Nullable<decimal> v_employee_head_id = new Nullable<decimal>();
            Nullable<decimal> v_employee_worker_id = new Nullable<decimal>();
            Nullable<decimal> v_repair_zone_master_id = new Nullable<decimal>();
            Nullable<decimal> v_employee_output_id = new Nullable<decimal>();

            if ((this.numberTextBox.Text != "")
                  && (this.employee_recieve_idTextBox.Text != "")
                  && (this.date_createdDateTimePicker.Text != "")
                  && (this.car_idTextBox.Text != "")
                  && (this.state_numberTextBox.Text != "")
                // &&(this.car_mark_snameTextBox.Text != "")
                //  &&(this.car_model_snameTextBox.Text != "")
                  && (this.runTextBox.Text != "")
                  && (this.malfunction_descTextBox.Text != "")
                //   &&(this.driver_textBox.Text != "")
                 )
            {
                try
                {
                    if (this.idTextBox.Text != "")
                    {
                        v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
                    }
                    this.Validate();
                    this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingSource.EndEdit();

                    if (this._head_order_form_state == 3)
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal)))
                                                                                  , "-", _username);
                    }
                    else
                    {

                        v_car_id = (decimal)Convert.ChangeType(this.car_idTextBox.Text, typeof(decimal));


                        if (this.repair_type_idTextBox.Text != "")
                        {
                            v_repair_type_id = (decimal)Convert.ChangeType(this.repair_type_idTextBox.Text, typeof(decimal));
                        }
                        //TODO: перепутаны названия вып. механика и водителя
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Update(ref v_id
                                                                                   , this.numberTextBox.Text
                                                                                   , v_car_id
                                                                                   , new System.Nullable<decimal>((decimal)Convert.ChangeType(this.driver_idtextBox.Text, typeof(decimal)))
                                                                                   , v_employee_head_id
                                                                                   , new System.Nullable<decimal>((decimal)Convert.ChangeType(this.employee_recieve_idTextBox.Text, typeof(decimal)))
                                                                                   , v_employee_output_id
                                                                                   , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime)))
                                                                                   , "Открыт"
                                                                                   , v_repair_type_id
                                                                                   , this.malfunction_descTextBox.Text
                                                                                   , v_repair_zone_master_id
                                                                                   , _head_order_wrh_order_master_type_id
                                                                                   , new System.Nullable<decimal>((decimal)Convert.ChangeType(this.runTextBox.Text, typeof(decimal)))
                                                                                   , this.sys_commentTextBox.Text
                                                                                   , this.sys_user_modifiedTextBox.Text);
                    }
                    this.idTextBox.Text = v_id.ToString();
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(true);
                    _is_valid = true;
                }
                catch (SqlException Sqle)
                {

                    switch (Sqle.Number)
                    {
                        case 515:
                            MessageBox.Show("Необходимо заполнить все обязательные поля!");
                            break;

                        case 2601:
                            MessageBox.Show("Такой 'Заказ - наряд' уже существует. Проверьте номер");
                            break;

                        default:
                            MessageBox.Show("Ошибка");
                            MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                            MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                            MessageBox.Show("Источник: " + Sqle.Source.ToString());
                            break;
                    }

                    this.Ok_Toggle(false);
                    _is_valid = false;

                }

                catch (Exception Appe)
                {
                    MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
                    this.Ok_Toggle(false);
                    _is_valid = false;
                }
            }
            else
            {
                MessageBox.Show("Необходимо ввести поля 'Выпускающий механик', 'Водитель СТП', 'Неисправности со слов механика СТП'!");
            }

        }




        void Button_recieverClick(object sender, EventArgs e)
        {
            using (Employee EmployeeForm = new Employee())
            {
                EmployeeForm.ShowDialog(this);
                if (EmployeeForm.DialogResult == DialogResult.OK)
                {

                    this.fIO_employee_recieveTextBox.Text
                        = EmployeeForm.Employee_short_fio;
                    this.employee_recieve_idTextBox.Text
                        = EmployeeForm.Employee_id;
                }
            }
        }

        void Head_orderLoad(object sender, EventArgs e)
        {
            if (_head_order_driver != "")
            {
                this.driver_textBox.Text = _head_order_driver;
            }

            if (_head_order_run != "")
            {
                this.runTextBox.Text = _head_order_run;
            }

            if (_head_order_state_number != "")
            {
                this.state_numberTextBox.Text = _head_order_state_number;
            }

            if (_head_order_car_id != "")
            {
                this.car_idTextBox.Text = _head_order_car_id;
            }
            if (_head_order_number != "")
            {
                this.numberTextBox.Text = _head_order_number;
            }
            if (_head_order_ts_type_sname != "")
            {
                this.Text = this.Text + " - " + _head_order_ts_type_sname;
            }

            if (_head_order_fuel_end_left != "")
            {
                this.fuel_end_lefttextBox.Text = _head_order_fuel_end_left;
            }

            if (_head_order_speedometer_end_indctn != "")
            {
                this.speedomter_end_indctntextBox.Text = _head_order_speedometer_end_indctn;
            }

            if (_head_order_car_mark_model_sname != "")
            {
                this.car_mark_model_snametextBox.Text = _head_order_car_mark_model_sname;
            }

            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();

            this.utfVPRT_EMPLOYEEBindingSource1.Filter = "employee_type_id=" + Const.Emp_type_mech_id.ToString()
                                            + " or employee_type_id=" + Const.Emp_type_mech_manager_id.ToString();



            this.utfVPRT_EMPLOYEETableAdapter.Fill(this.ANGEL_TO_001_Employee.utfVPRT_EMPLOYEE, ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                   , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                   , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                   , DateTime.Now);
        }

        void Ok_Toggle(bool v_result)
        {
            if (v_result)
            {
                this.button_ok.Enabled = true;
            }
            else
            {
                this.button_ok.Enabled = false;
            }
        }

        void Button_okClick(object sender, EventArgs e)
        {
            if (_is_valid == false)
            {
                this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingNavigatorSaveItem_Click(sender, e);
            }
            if (this.to_printcheckBox.Checked == true)
            {
                this.print_document();
            }

        }

        void NumberTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void FIO_employee_headTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Malfunction_descTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void TextBox1TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);

        }

        void RunTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Button_driverClick(object sender, EventArgs e)
        {
            using (Employee EmployeeForm = new Employee())
            {
                EmployeeForm.ShowDialog(this);
                if (EmployeeForm.DialogResult == DialogResult.OK)
                {

                    this.driver_textBox.Text
                        = EmployeeForm.Employee_short_fio;
                    this.driver_idtextBox.Text
                        = EmployeeForm.Employee_id;
                }
            }
        }

        void Button_repair_zoneClick(object sender, EventArgs e)
        {
            if (_is_valid == false)
            {
                this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingNavigatorSaveItem_Click(sender, e);
            }
        }

        void DrivercomboBoxFormat(object sender, ListControlConvertEventArgs e)
        {

        }

        void P_Top_n_by_RanktextBoxTextChanged(object sender, EventArgs e)
        {

        }

        void MechcomboBoxSelectedValueChanged(object sender, EventArgs e)
        {
            try
            {
                if (this.mechcomboBox.Text != "")
                {
                    this.employee_recieve_idTextBox.Text = this.mechcomboBox.SelectedValue.ToString();
                }
            }
            catch { }
        }

        void DrivercomboBoxSelectedValueChanged(object sender, EventArgs e)
        {
            try
            {
                if (this.drivercomboBox.Text != "")
                {
                    this.driver_idtextBox.Text = this.drivercomboBox.SelectedValue.ToString();
                }
            }
            catch { }
        }

        public void print_document()
        {
            //Напечатаем заявку
            string v_number = "";
            string v_date = "";
            string v_time = "";
            string v_car_mark_model = "";
            string v_state_number = "";
            string v_driver_fio = "";
            string v_mech_fio = "";
            string v_run = "";
            string v_fuel_end_left = "";
            string v_malfunc_desc = "";
            string v_speedometer_end_indctn = "";

            Acrobat Printfile = new Acrobat();

            if (this.numberTextBox.Text != "")
            {
                v_number = this.numberTextBox.Text;
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_date = this.date_createdDateTimePicker.Text.Substring(0, 8);
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_time = this.date_createdDateTimePicker.Text.Substring(9, 5);
            }
            if (this.car_mark_model_snametextBox.Text != "")
            {
                v_car_mark_model = this.car_mark_model_snametextBox.Text;
            }
            if (this.state_numberTextBox.Text != "")
            {
                v_state_number = this.state_numberTextBox.Text;
            }

            if (this.drivercomboBox.Text != "")
            {
                v_driver_fio = this.drivercomboBox.Text;
            }
            if (this.runTextBox.Text != "")
            {
                v_run = this.runTextBox.Text;
            }
            if (this.fuel_end_lefttextBox.Text != "")
            {
                v_fuel_end_left = this.fuel_end_lefttextBox.Text;
            }
            if (this.mechcomboBox.Text != "")
            {
                v_mech_fio = this.mechcomboBox.Text;
            }

            if (this.malfunction_descTextBox.Text != "")
            {
                v_malfunc_desc = this.malfunction_descTextBox.Text;
            }

            if (this.speedomter_end_indctntextBox.Text != "")
            {
                v_speedometer_end_indctn = this.speedomter_end_indctntextBox.Text;
            }

            _filled_file = Printfile.Order_form_fill(v_number
                                                     , v_date
                                                     , v_time
                                                     , v_car_mark_model
                                                     , v_state_number
                                                     , v_driver_fio
                                                     , v_mech_fio
                                                     , v_run
                                                     , v_fuel_end_left
                                                     , v_malfunc_desc
                                                     , v_speedometer_end_indctn);

            //  Printfile.Form_print(this.Ar_path, filled_file, this.Printer_name);
            this.backgroundWorker1.RunWorkerAsync();

        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            Printfile.Form_print(this.Ar_path, _filled_file, this.Printer_name);
        }


    }
}


