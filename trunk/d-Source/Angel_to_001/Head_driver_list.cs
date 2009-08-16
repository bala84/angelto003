using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using iTextSharp.text.pdf;

namespace Angel_to_001
{
    public partial class Head_driver_list : Form
    {
        public string _username;

        //Принимаемые значения
        //Переменная валидности формы
        private bool _is_valid = true;
        //Переменная свитч работы background
        private byte _work_switch = 1;
        private int _doc_count = 1;
        public string _driver_list_id;
        public string _driver_list_date_created;
        public string _driver_list_number;
        public string _driver_list_car_id;
        public string _driver_list_car_type_id;
        public string _driver_list_state_number;
        public string _driver_list_car_mark_model_name;
        public string _driver_list_employee1_id;
        public string _driver_list_employee2_id;
        public string _driver_list_fuel_norm;
        public string _driver_list_fact_start_duty;
        public string _driver_list_fact_end_duty;
        public string _driver_list_driver_list_state_id;
        public string _driver_list_type_id;
        public string _driver_list_organization_id;
        public string _driver_list_organization_sname;
        public string _driver_list_fuel_type_id;
        public string _driver_list_fuel_exp;
        public string _driver_list_speedometer_start_indctn;
        public string _driver_list_speedometer_end_indctn;
        public string _driver_list_fuel_start_left;
        public string _driver_list_fuel_end_left;
        public string _driver_list_fuel_gived;
        public string _driver_list_fuel_return;
        public string _driver_list_fuel_addtnl_exp;
        public string _driver_list_run;
        public string _driver_list_fuel_consumption;
        public string _driver_list_fio_driver1;
        public string _driver_list_fio_driver2;
        public string _driver_list_condition_id;
        public string _driver_list_last_run;
        public string _driver_list_last_date_created;
        public string _driver_list_driver_passport;
        public string _driver_list_fuel_type_sname;
        public string _driver_list_fuel_type_class;
        //Переменная текущего состояния формы
        //1 - Вставка, 2 - Редактирование, 3 - Удаление
        public byte _form_state;

        public bool _is_counted = false;

        Acrobat Printfile = new Acrobat();
        private string _filled_file = "";

        public string Ar_path = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Ar_path"];
        public string Printer_name = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_name"];
        public string Printer_spool = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Spool_path"];
        public string Printer_device = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_device"]; 


        //Отдаваемые значения
        public string Driver_list_id
        {
            get { return this.idTextBox.Text; }
        }
        public string Driver_list_sys_status
        {
            get { return this.sys_statusTextBox.Text; }
        }
        public string Driver_list_sys_comment
        {
            get { return this.sys_commentTextBox.Text; }
        }
        public string Driver_list_sys_date_modified
        {
            get { return this.sys_date_modifiedDateTimePicker.Text; }
        }
        public string Driver_list_sys_date_created
        {
            get { return this.sys_date_createdDateTimePicker.Text; }
        }
        public string Driver_list_sys_user_modified
        {
            get { return this.sys_user_modifiedTextBox.Text; }
        }
        public string Driver_list_sys_user_created
        {
            get { return this.sys_user_createdTextBox.Text; }
        }
        public string Driver_list_date_created
        {
            get { return this.date_createdDateTimePicker.Text; }
        }
        public string Driver_list_number
        {
            get
            { return this.numberTextBox.Text; }
        }
        public string Driver_list_car_id
        {
            get { return this.car_idTextBox.Text; }
        }

        public string Driver_list_state_number
        {
            get { return this.car_comboBox.Text; }
        }

        public string Driver_list_car_mark_model_name
        {
            get { return this.car_mark_model_nameTextBox.Text; }
        }

        public string Driver_list_employee1_id
        {
            get { return this.employee1_idTextBox.Text; }
        }

        public string Driver_list_employee2_id
        {
            get { return this.employee2_idTextBox.Text; }
        }

        public string Driver_list_fuel_norm
        {
            get { return this.fuel_normTextBox.Text; }

        }
        public string Driver_list_fact_start_duty
        {
            get { return this.start_datedateTimePicker.Text; }
        }


        public string Driver_list_fact_end_duty
        {
            get { return this.end_datedateTimePicker.Text; }
        }

        public string Driver_list_driver_list_state_id
        {
            get { return this.driver_list_state_idTextBox.Text; }
        }

        public string Driver_list_driver_list_type_id
        {
            get { return this.driver_list_type_idTextBox.Text; }
        }


        public string Driver_list_organization_id
        {
            get { return this.organization_idTextBox.Text; }
        }


        public string Driver_list_fuel_type_id
        {
            get { return this.fuel_type_idTextBox.Text; }
        }


        public string Driver_list_fuel_exp
        {
            get { return this.fuel_expTextBox.Text; }
        }


        public string Driver_list_speedometer_start_indctn
        {
            get { return this.speedometer_start_indctnTextBox.Text; }

        }
        public string Driver_list_speedometer_end_indctn
        {
            get { return this.speedometer_end_indctnTextBox.Text; }
        }

        public string Driver_list_fuel_start_left
        {
            get { return this.fuel_start_leftTextBox.Text; }
        }
        public string Driver_list_fuel_end_left
        {
            get { return this.fuel_end_leftTextBox.Text; }
        }
        public string Driver_list_fuel_gived
        {
            get { return this.fuel_givedTextBox.Text; }
        }
        public string Driver_list_fuel_return
        {
            get { return this.fuel_returnTextBox.Text; }
        }
        public string Driver_list_run
        {
            get { return this.runTextBox.Text; }
        }
        public string Driver_list_fuel_consumption
        {
            get { return this.fuel_consumptionTextBox.Text; }
        }
        //  public string Driver_list_fio_driver1
        // {
        //     get { return this.fio_driver1TextBox.Text; }
        // }

        /// public string Driver_list_condition_id
        // {
        //     get { return this.condition_idtextBox.Text; }
        // }

        // public string Driver_list_last_run
        //  {
        //     get { return this.last_runtextBox.Text; }
        // }



        //public string Driver_list_last_date_created
        //{
        //    get
        //    {
        //        return this.last_date_createdtextBox.Text;
        //    }
        //}

        public Head_driver_list()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void uspVDRV_DRIVER_LIST_SelectByIdBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            //Сохраняем форму - используем переменные для проверки на нулл

            Nullable<decimal> v_id = new Nullable<decimal>();
            Nullable<decimal> v_car_id = new Nullable<decimal>();
            Nullable<decimal> v_driver_list_state_id = new Nullable<decimal>();
            Nullable<decimal> v_driver_list_type_id = new Nullable<decimal>();
            Nullable<decimal> v_condition_id = new Nullable<decimal>();
            Nullable<decimal> v_fuel_exp = new Nullable<decimal>();
            Nullable<decimal> v_fuel_type_id = new Nullable<decimal>();
            Nullable<long> v_number = new Nullable<long>();
            Nullable<decimal> v_organization_id = new Nullable<decimal>();
            Nullable<decimal> v_employee1_id = new Nullable<decimal>();
            Nullable<decimal> v_employee2_id = new Nullable<decimal>();
            Nullable<decimal> v_speedometer_start_indctn = new Nullable<decimal>();
            Nullable<decimal> v_speedometer_end_indctn = new Nullable<decimal>();
            Nullable<decimal> v_fuel_start_left = new Nullable<decimal>();
            Nullable<decimal> v_fuel_end_left = new Nullable<decimal>();
            Nullable<decimal> v_fuel_gived = new Nullable<decimal>();
            Nullable<decimal> v_fuel_return = new Nullable<decimal>();
            Nullable<decimal> v_fuel_addtnl_exp = new Nullable<decimal>();
            Nullable<decimal> v_last_run = new Nullable<decimal>();
            Nullable<decimal> v_run = new Nullable<decimal>();
            Nullable<decimal> v_fuel_consumption = new Nullable<decimal>();
            Nullable<decimal> v_employee_id = new Nullable<decimal>();
            Nullable<DateTime> v_last_date_created = new Nullable<DateTime>();
            int v_power_trailer_consumption = 0;

             //Если заполнены необходмые поля - сохраняем
            if ((this.date_createdDateTimePicker.Text != "")
                  && (this.employee1_idTextBox.Text != "")
                  && (this.car_idTextBox.Text != "")
                  && (this.start_datedateTimePicker.Text != "")
                 // && (this.mechcomboBox.Text != "")
                  && (this.numberTextBox.Text != "")
                 //&& (this.organization_idTextBox.Text != "")
                //  && (this.speedometer_start_indctnTextBox.Text != "")
                  && (this.fuel_start_leftTextBox.Text != "")
                 )
            {
                try
                {
                    if (this.idTextBox.Text != "")
                    {
                        v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
                    }
                    this.Validate();
                    if (this._form_state == 3)
                    {
                    }
                    else
                    {
                        if (this.numberTextBox.Text != "")
                        {
                            v_number = (long)Convert.ChangeType(this.numberTextBox.Text, typeof(long));
                        }

                        v_car_id = (decimal)Convert.ChangeType(this.car_idTextBox.Text, typeof(decimal));

                        if (this.condition_idTextBox.Text != "")
                        {
                            v_condition_id = (decimal)Convert.ChangeType(this.condition_idTextBox.Text, typeof(decimal));
                        }
                        v_driver_list_state_id = (decimal)Convert.ChangeType(this.driver_list_state_idTextBox.Text, typeof(decimal));
                        if (this.driver_list_type_idTextBox.Text != "")
                        {
                            v_driver_list_type_id = (decimal)Convert.ChangeType(this.driver_list_type_idTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_expTextBox.Text != "")
                        {
                            v_fuel_exp = (decimal)Convert.ChangeType(this.fuel_expTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_type_idTextBox.Text != "")
                        {
                            v_fuel_type_id = (decimal)Convert.ChangeType(this.fuel_type_idTextBox.Text, typeof(decimal));
                        }
                        if (this.organization_idTextBox.Text != "")
                        {
                            v_organization_id = (decimal)Convert.ChangeType(this.organization_idTextBox.Text, typeof(decimal));
                        }
                        v_employee1_id = (decimal)Convert.ChangeType(this.employee1_idTextBox.Text, typeof(decimal));
                        if (this.employee2_idTextBox.Text != "")
                        {
                            v_employee2_id = (decimal)Convert.ChangeType(this.employee2_idTextBox.Text, typeof(decimal));
                        }
                        if (this.speedometer_start_indctnTextBox.Text != "")
                        {
                            v_speedometer_start_indctn = (decimal)Convert.ChangeType(this.speedometer_start_indctnTextBox.Text, typeof(decimal));
                        }
                        if (this.speedometer_end_indctnTextBox.Text != "")
                        {
                            v_speedometer_end_indctn = (decimal)Convert.ChangeType(this.speedometer_end_indctnTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_start_leftTextBox.Text != "")
                        {
                            v_fuel_start_left = (decimal)Convert.ChangeType(this.fuel_start_leftTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_end_leftTextBox.Text != "")
                        {
                            v_fuel_end_left = (decimal)Convert.ChangeType(this.fuel_end_leftTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_givedTextBox.Text != "")
                        {
                            v_fuel_gived = (decimal)Convert.ChangeType(this.fuel_givedTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_returnTextBox.Text != "")
                        {
                            v_fuel_return = (decimal)Convert.ChangeType(this.fuel_returnTextBox.Text, typeof(decimal));
                        }
                        // if (this.fuel_addtnl_expTextBox.Text != "")
                        // {
                        //    v_fuel_addtnl_exp = (decimal)Convert.ChangeType(this.f.Text, typeof(decimal));
                        //}
                        if (this.last_runtextBox.Text != "")
                        {
                            v_last_run = (decimal)Convert.ChangeType(this.last_runtextBox.Text, typeof(decimal));
                        }
                        if (this.runTextBox.Text != "")
                        {
                            v_run = (decimal)Convert.ChangeType(this.runTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_consumptionTextBox.Text != "")
                        {
                            v_fuel_consumption = (decimal)Convert.ChangeType(this.fuel_consumptionTextBox.Text, typeof(decimal));
                        }
                        //Попробуем сохранить механика
                        try
                        {
                            if (this.mechcomboBox.SelectedValue.ToString() != "")
                            {
                                v_employee_id = (decimal)Convert.ChangeType(this.mechcomboBox.ValueMember.ToString(), typeof(decimal));
                            }
                        }
                        catch { }
                        if (this.last_date_createdDateTimePicker.Text != "")
                        {
                            v_last_date_created = (DateTime)Convert.ChangeType(this.last_date_createdDateTimePicker.Text, typeof(DateTime));
                        }
                        //Энергоустановка
                        if (this.pw_counttextBox.Text != "")
                        {
                            v_power_trailer_consumption = (int)Convert.ChangeType(this.pw_counttextBox.Text, typeof(int));
                        }

                        this.Validate();
                        this.uspVDRV_DRIVER_LIST_SelectByIdBindingSource.EndEdit();
                        this.uspVDRV_DRIVER_LIST_SelectByIdTableAdapter.Update(ref v_id
                                                                   , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime)))
                                                                   , v_number
                                                                   , v_car_id
                                                                   , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.start_datedateTimePicker.Text, typeof(DateTime)))
                                                                   , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.end_datedateTimePicker.Text, typeof(DateTime)))
                                                                   , v_driver_list_state_id
                                                                   , v_driver_list_type_id
                                                                   , v_fuel_exp
                                                                   , v_fuel_type_id
                                                                   , v_organization_id
                                                                   , v_employee1_id
                                                                   , v_employee2_id
                                                                   , v_speedometer_start_indctn
                                                                   , v_speedometer_end_indctn
                                                                   , v_fuel_start_left
                                                                   , v_fuel_end_left
                                                                   , v_fuel_gived
                                                                   , v_fuel_return
                                                                   , v_fuel_addtnl_exp
                                                                   , v_last_run
                                                                   , v_run
                                                                   , v_fuel_consumption
                                                                   , ref v_condition_id
                                                                   , this.edit_statetextBox.Text
                                                                   , v_employee_id
                                                                   , v_last_date_created
                                                                   , v_power_trailer_consumption
                                                                   , this.sys_commentTextBox.Text
                                                                   , this.sys_user_modifiedTextBox.Text);
                    }
                    if (this._form_state != 3)
                    {
                        this.idTextBox.Text = v_id.ToString();
                        this.p_idToolStripTextBox.Text = v_id.ToString();
                        // Just.Prepare_Detail(dataGridViewTextBoxColumn21.Index, this.utfVDRV_TRAILERDataGridView.Rows, this.idTextBox.Text);
                        //this.utfVDRV_TRAILERTableAdapter.Update(this.aNGEL_TO_001_Driver_trailer.utfVDRV_TRAILER);

                    }
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(true);
                    _is_valid = true;
                    //if (this._form_state != 3)
                    //{/*
                    //this.UspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(sender, e);

                    //}
                }
                catch (SqlException Sqle)
                {

                    switch (Sqle.Number)
                    {
                        //  case 515:
                        //    MessageBox.Show("Необходимо заполнить все обязательные поля!");
                        //   break;

                        case 547:
                            MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись! "
                                            + "Проверьте, что у данного автомобиля нет состояния и путевых листов. ");
                            break;

                        case 2601:
                            MessageBox.Show("Такой '№ Путевого листа' уже существует");
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
                MessageBox.Show("Укажите, пожалуйста , номер п/л, показание спидометра и водителя, который есть в справочнике");
            }

        }

        private void Ok_Toggle(bool v_result)
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

        private void fillToolStripButton_Click(object sender, EventArgs e)
        {
            //try
            //{
            //    this.uspVDRV_DRIVER_LIST_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_type_idToolStripTextBox.Text, typeof(decimal))))));
            //}
            //catch (System.Exception ex)
            //{
            //    System.Windows.Forms.MessageBox.Show(ex.Message);
            //}

        }

        private void Head_driver_list_Load(object sender, EventArgs e)
        {
            try
            {
                this.Text = this.Text + " путевой лист";

                if ((_driver_list_id != "")
                   && (_driver_list_id != null))
                {
                    this.idTextBox.Text = _driver_list_id;
                    this.p_idToolStripTextBox.Text = _driver_list_id;
                }

                if ((_driver_list_car_type_id != "")
                   && (_driver_list_car_type_id != null))
                {
                    this.p_car_type_idToolStripTextBox.Text = _driver_list_car_type_id;
                }

                if ((_driver_list_car_id != "")
                  && (_driver_list_car_id != null))
                {
                    this.car_idTextBox.Text = _driver_list_car_id;
                    this.p_car_idToolStripTextBox.Text = _driver_list_car_id;
                }

                p_start_dateToolStripTextBox.Text = this.start_datedateTimePicker.Value.ToShortDateString();
                p_end_dateToolStripTextBox.Text = this.end_datedateTimePicker.Value.ToShortDateString();

                p_searchtextBox.Text = DBNull.Value.ToString();
                p_search_typetextBox.Text = Const.Pt_search.ToString();
                p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
                this.utfVPRT_EMPLOYEEBindingSource1.Filter = "employee_type_id=" + Const.Emp_type_mech_id.ToString()
                                                            + " or employee_type_id=" + Const.Emp_type_mech_manager_id.ToString();

                this.utfVPRT_EMPLOYEEBindingSource3.Filter = "employee_type_id=" + Const.Emp_type_mech_id.ToString()
                                            + " or employee_type_id=" + Const.Emp_type_mech_manager_id.ToString();
                try
                {
                    this.utfVCAR_CARTableAdapter.Fill(this.aNGEL_TO_001_Car.utfVCAR_CAR, p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short))))), DateTime.Now);
                    this.utfVPRT_EMPLOYEETableAdapter.Fill(this.aNGEL_TO_001_Employee.utfVPRT_EMPLOYEE, p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short))))), DateTime.Now);
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }

                if ((_driver_list_car_mark_model_name != "")
                   && (_driver_list_car_mark_model_name != null))
                {
                    this.car_mark_model_nameTextBox.Text = _driver_list_car_mark_model_name;
                }
                if ((_driver_list_condition_id != "")
                  && (_driver_list_condition_id != null))
                {
                    this.condition_idTextBox.Text = _driver_list_condition_id;
                }
                if ((_driver_list_date_created != "")
                  && (_driver_list_date_created != null))
                {
                    this.date_createdDateTimePicker.Text = _driver_list_date_created;
                }
                if ((_driver_list_driver_list_state_id != "")
                  && (_driver_list_driver_list_state_id != null))
                {
                    this.driver_list_state_idTextBox.Text = _driver_list_driver_list_state_id;
                }
                else
                {
                    this.driver_list_state_idTextBox.Text = Const.Opened_driver_list_state_id.ToString();
                }



                if ((_driver_list_fact_end_duty != "")
                  && (_driver_list_fact_end_duty != null))
                {
                    this.end_datedateTimePicker.Text = _driver_list_fact_end_duty;
                }

                if ((_driver_list_fact_start_duty != "")
                  && (_driver_list_fact_start_duty != null))
                {
                    this.start_datedateTimePicker.Text = _driver_list_fact_start_duty;
                }

                if ((_driver_list_fio_driver1 != "")
                  && (_driver_list_fio_driver1 != null))
                {
                    this.drivercomboBox.Text = _driver_list_fio_driver1;
                }

                if ((_driver_list_employee1_id != "")
                  && (_driver_list_employee1_id != null))
                {
                    this.employee1_idTextBox.Text = _driver_list_employee1_id;
                }

                if ((_driver_list_fuel_consumption != "")
                  && (_driver_list_fuel_consumption != null))
                {
                    this.fuel_consumptionTextBox.Text = _driver_list_fuel_consumption;
                }

                if ((_driver_list_fuel_end_left != "")
                  && (_driver_list_fuel_end_left != null))
                {
                    this.fuel_end_leftTextBox.Text = _driver_list_fuel_end_left;
                }

  

                if ((_driver_list_fuel_exp != "")
                  && (_driver_list_fuel_exp != null))
                {
                    this.fuel_expTextBox.Text = _driver_list_fuel_exp;
                }

                if ((_driver_list_fuel_gived != "")
                  && (_driver_list_fuel_gived != null))
                {
                    this.fuel_givedTextBox.Text = _driver_list_fuel_gived;
                }

                if ((_driver_list_fuel_norm != "")
                  && (_driver_list_fuel_norm != null))
                {
                    this.fuel_normTextBox.Text = _driver_list_fuel_norm;
                }

                if ((_driver_list_fuel_return != "")
                  && (_driver_list_fuel_return != null))
                {
                    this.fuel_returnTextBox.Text = _driver_list_fuel_return;
                }

                if ((_driver_list_fuel_start_left != "")
                  && (_driver_list_fuel_start_left != null))
                {
                    this.fuel_start_leftTextBox.Text = _driver_list_fuel_start_left;
                }

                if ((_driver_list_fuel_type_id != "")
                  && (_driver_list_fuel_type_id != null))
                {
                    this.fuel_type_idTextBox.Text = _driver_list_fuel_type_id;
                }
                if ((_driver_list_last_date_created != "")
                  && (_driver_list_last_date_created != null))
                {
                    this.last_date_createdDateTimePicker.Text = _driver_list_last_date_created;
                }

                if ((_driver_list_last_run != "")
                  && (_driver_list_last_run != null))
                {
                    this.Text = _driver_list_last_date_created;
                }

                if ((_driver_list_speedometer_start_indctn != "")
                  && (_driver_list_speedometer_start_indctn != null))
                {
                    this.speedometer_start_indctnTextBox.Text = _driver_list_speedometer_start_indctn;
                }
                if ((_driver_list_speedometer_end_indctn != "")
                  && (_driver_list_speedometer_end_indctn != null))
                {
                    this.speedometer_end_indctnTextBox.Text = _driver_list_speedometer_end_indctn;
                }
                if ((_driver_list_fuel_end_left != "")
                 && (_driver_list_fuel_end_left != null))
                {
                    this.fuel_end_leftTextBox.Text = _driver_list_fuel_end_left;
                }
                if ((_driver_list_type_id != "")
                 && (_driver_list_type_id != null))
                {
                    this.driver_list_type_idTextBox.Text = _driver_list_type_id;
                }
                if ((_driver_list_state_number != "")
                 && (_driver_list_state_number != null))
                {
                    this.car_comboBox.Text = _driver_list_state_number;
                }
                if ((_driver_list_number != "")
                 && (_driver_list_number != null))
                {
                    this.numberTextBox.Text = _driver_list_number;
                }

                if ((_driver_list_organization_id != "")
                 && (_driver_list_organization_id != null))
                {
                    this.organization_idTextBox.Text = _driver_list_organization_id;
                }

                if ((_driver_list_organization_sname != "")
                 && (_driver_list_organization_sname != null))
                {
                    this.organization_snameTextBox.Text = _driver_list_organization_sname;
                }
                if ((_driver_list_driver_passport != "")
                 && (_driver_list_driver_passport != null))
                {
                    this.driver_licensetextBox.Text = _driver_list_driver_passport;
                }
                if ((_driver_list_fuel_type_sname != "")
                 && (_driver_list_fuel_type_sname != null))
                {
                    this.fuel_type_snametextBox.Text = _driver_list_fuel_type_sname;
                }
                this.addtnl_driver_comboBox.Text = "";
                this.addtnl_mechcomboBox.Text = "";
                this.mechcomboBox.Text = "";
                //Если форма в состоянии закрытия, включим элементы подсчета
                if (this._form_state == 4)
                {
                    this.speedometer_end_indctnTextBox.Enabled = true;
                    this.speedometer_end_indctnTextBox.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
                    this.fuel_returnTextBox.Enabled = true;
                    this.pw_counttextBox.Enabled = true;
                    this.fuel_expTextBox.Enabled = true;
                    this.fuel_end_leftTextBox.Enabled = true;
                    this.fuel_consumptionTextBox.Enabled = true;
                    this.runTextBox.Enabled = true;
                    this.end_datedateTimePicker.Enabled = true;
                    this.fuel_end_leftTextBox.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
                    this.end_datedateTimePicker.Value = DateTime.Now;
                    this.end_datedateTimePicker.Enabled = true;
                    this.date_createdDateTimePicker.Enabled = false;
                    this.numberTextBox.Enabled = false;
                    this.car_comboBox.Enabled = false;
                    this.drivercomboBox.Enabled = false;
                }
            }
            catch { }

        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.uspVDRV_DRIVER_LIST_SelectByIdBindingNavigatorSaveItem_Click(sender, e);
            if ((this._form_state == 1)|(_form_state == 2))
            {
                this.print_document();
            }
        }

        private void car_comboBox_SelectionChangeCommitted(object sender, EventArgs e)
        {
            try
            {

                try
                {
                    if (this.car_comboBox.Text != "")
                    {
                        this.car_idTextBox.Text = this.car_comboBox.SelectedValue.ToString();
                        this.p_car_idToolStripTextBox.Text = this.car_comboBox.SelectedValue.ToString();
                    }
                }
                catch { }
                //try
                //{
                this.uspVDRV_DRIVER_LIST_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                this.uspVCAR_CAR_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001_Car_SelectById.uspVCAR_CAR_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                //}
                //catch (System.Exception ex)
                //{
                //    System.Windows.Forms.MessageBox.Show(ex.Message);
                // }
                //Если у нас нет еще открытых путевых листов, то обработаем выбор машины

                if (this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.RowCount < 2)
                {
                    //  try
                    //  {
                    this.uspVDRV_DRIVER_PLAN_Select_DriverByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_Select_DriverById, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                    // }
                    // catch (System.Exception ex)
                    // {
                    //     System.Windows.Forms.MessageBox.Show(ex.Message);
                    // }
                    this.fuel_type_idTextBox.Text = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn60.Index].Value.ToString();
                    this.driver_list_type_idTextBox.Text = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn78.Index].Value.ToString();
                    this.speedometer_start_indctnTextBox.Text = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn69.Index].Value.ToString();
                    this.fuel_start_leftTextBox.Text = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn72.Index].Value.ToString();
                    this.fuel_normTextBox.Text = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn64.Index].Value.ToString();
                    this.organization_idTextBox.Text = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn76.Index].Value.ToString();
                    this.fuel_type_snametextBox.Text = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn61.Index].Value.ToString();
                    try
                    {
                        if (this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString() != "")
                        {
                            this.drivercomboBox.Text = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString();
                            this.employee1_idTextBox.Text = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn88.Index].Value.ToString();
                            this.driver_licensetextBox.Text = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[driver_license.Index].Value.ToString(); 
                        }
                    }
                    catch { }

                    if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn78.Index].Value.ToString() != "")
                         && (this.organization_idTextBox.Text != ""))
                    {
                        this.numberTextBox.Text
                        = Just.Get_driver_list_number((decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn78.Index].Value.ToString(), typeof(decimal))
                                                      , (decimal)Convert.ChangeType(this.organization_idTextBox.Text, typeof(decimal)));
                    }
                    this.Ok_Toggle(true);
                    _is_valid = true;

                }
                else
                {
                    MessageBox.Show("У этого автомобиля уже есть открытый путевой лист, сначала закройте его");
                    this.Ok_Toggle(false);
                    _is_valid = false;
                }
            }
            catch { }
        }

        private void mechcomboBox_SelectedValueChanged(object sender, EventArgs e)
        {
            try
            {
                if (this.mechcomboBox.Text != "")
                {
                    this.employee_idtextBox.Text = this.mechcomboBox.SelectedValue.ToString();
                }
            }
            catch { }
        }

        private void drivercomboBox_SelectedValueChanged(object sender, EventArgs e)
        {
            try
            {
                if (this.drivercomboBox.Text != "")
                {
                    this.employee1_idTextBox.Text = this.drivercomboBox.SelectedValue.ToString();
                    try
                    {
                        this.uspVPRT_Employee_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVPRT_Employee_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.employee1_idTextBox.Text, typeof(decimal))))));
                    }
                    catch (System.Exception ex)
                    {
                    }
                    if (this.uspVPRT_Employee_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value.ToString() != "")
                    {
                        this.driver_licensetextBox.Text = this.uspVPRT_Employee_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value.ToString();
                    }
                    else
                    {
                        this.driver_licensetextBox.Text = "";
                    }
                }

            }
            catch { }
        }

               //Функция подсчета данных формы
        private void counttoolStripButton_Click(object sender, EventArgs e)
        {
            int v_run = 0
                , v_consumption = 0
                , v_fuel_end_left_wo_addtn_exps = 0
                , v_fuel_end_left_with_addtn_exps = 0
                , v_consumption_wo_addtn_exps = 0
                , v_power_trailer_consumption = 0
                , v_speedometer_end_indctn = 0
                , v_speedometer_start_indctn = 0
                , v_fuel_start_left = 0
                , v_fuel_gived = 0
                , v_fuel_return = 0;
            decimal v_fuel_norm = 0
                , v_100km_consumption = 0;


            try
            {
                //Пройдем по прицепам и найдем показатели расходов
                if (this.speedometer_end_indctnTextBox.Text != "")
                {
                    //Энергоустановка
                    if (this.pw_counttextBox.Text != "")
                    {
                        v_power_trailer_consumption = (int)Convert.ChangeType(this.pw_counttextBox.Text, typeof(int));
                    }
                    //Проверим поля
                    if (this.speedometer_end_indctnTextBox.Text != "")
                    {
                        v_speedometer_end_indctn = (int)Convert.ChangeType(this.speedometer_end_indctnTextBox.Text, typeof(int));
                    }
                    if (this.speedometer_start_indctnTextBox.Text != "")
                    {
                        v_speedometer_start_indctn = (int)Convert.ChangeType(this.speedometer_start_indctnTextBox.Text, typeof(int));
                    }
                    if (this.fuel_normTextBox.Text != "")
                    {
                        v_fuel_norm = (decimal)Convert.ChangeType(this.fuel_normTextBox.Text, typeof(decimal));
                    }
                    if (this.fuel_start_leftTextBox.Text != "")
                    {
                        v_fuel_start_left = (int)Convert.ChangeType(this.fuel_start_leftTextBox.Text, typeof(int));
                    }

                    if (this.fuel_givedTextBox.Text != "")
                    {
                        v_fuel_gived = (int)Convert.ChangeType(this.fuel_givedTextBox.Text, typeof(int));
                    }
                    if (this.fuel_returnTextBox.Text != "")
                    {
                        v_fuel_return = (int)Convert.ChangeType(this.fuel_returnTextBox.Text, typeof(int));
                    }
                    //Формула пробега
                    v_run = v_speedometer_end_indctn - v_speedometer_start_indctn;
                    //Формула расхода топлива
                    v_consumption_wo_addtn_exps = Convert.ToInt32(((v_run * v_fuel_norm) / 100).ToString("0"), 10);
                    //Остаток топлива при въезде без прицепов и механизмов
                    v_fuel_end_left_wo_addtn_exps =
                        (v_fuel_start_left + v_fuel_gived)
                        - v_fuel_return
                        - v_consumption_wo_addtn_exps;
                    v_fuel_end_left_with_addtn_exps =
                        v_fuel_end_left_wo_addtn_exps
                        - v_power_trailer_consumption;

                    v_consumption = v_consumption_wo_addtn_exps + v_power_trailer_consumption;
                    //Если новые пробег не равен старому, мы должны сохранить старый пробег
                    /* if (this.runTextBox.Text != v_run.ToString())
                     {
                         this.last_runtextBox.Text = this.runTextBox.Text;

                     }
                     //Если изменилась дата выхода - запишем старую дату для корректировки отчета
                     if ((_driver_list_date_created != "")
                         && (_driver_list_date_created != null))
                     {

                         this.last_date_createdDateTimePicker.Text =
                             _driver_list_date_created;

                     }
                     else
                     {
                         this.last_date_createdDateTimePicker.Text = "";
                     }*/

                    //Приведем к формату вычисленные значения
                    this.runTextBox.Text = v_run.ToString("0");
                    this.fuel_consumptionTextBox.Text = v_consumption.ToString("0");
                    this.fuel_consumption_wo_addtn_exps_textBox.Text = v_consumption_wo_addtn_exps.ToString("0");
                    //Расчитаем расход на сто километров
                    // v_consumption_wo_addtn_exps = (int)Convert.ChangeType(this.fuel_consumption_wo_addtn_exps_textBox.Text, typeof(int));
                    if (v_run != 0)
                    {
                        v_100km_consumption = ((decimal)Convert.ChangeType(v_consumption_wo_addtn_exps, typeof(decimal))
                                               / (decimal)Convert.ChangeType(v_run, typeof(decimal))) * 100;
                    }
                    else
                    {
                        v_100km_consumption = 0;
                    }

                    this.fuel_expTextBox.Text = v_100km_consumption.ToString("0.###");
                    this.fuel_end_leftTextBox.Text = v_fuel_end_left_with_addtn_exps.ToString("0");
                    //this.fact_start_dutyTextBox.Text = this.fact_start_duty_date_visible_textBox.Text + " " + this.fact_start_duty_time_visible_textBox.Text;
                    //this.fact_end_dutyTextBox.Text = this.fact_end_duty_date_visible_textBox.Text + " " + this.fact_end_duty_time_visible_textBox.Text;

                    _is_counted = Check_Items();

                    if (_is_counted)
                    {
                        Ok_Toggle(true);
                        // this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = true;
                    }
                    else
                    {
                        Ok_Toggle(false);
                        // this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = false;
                    }
                }
            }
            catch (Exception Appe)
            {
                MessageBox.Show("Указаны некорректные значения показаний или расходов топлива");
               // MessageBox.Show(Appe.Message);
                Ok_Toggle(false);
                //  this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = false;
            }
        }


        private bool Is_Fio_Driver1_Valid()
        {
            bool v_result = false;
            try
            {
               // MessageBox.Show(this.drivercomboBox.FindStringExact(this.drivercomboBox.Text, 0).ToString());
                if (this.employee1_idTextBox.Text != "")

                {
                    v_result = true;
                    //Ok_Toggle(true);
                }
                else
                {
                    //Ok_Toggle(false);
                }
            }
            catch
            {
            }

            return v_result;
        }

        private bool Is_State_Number_Valid()
        {
            bool v_result = false;

            if (this.car_comboBox.Text.Length != 0)
            {
                v_result = true;
                //Ok_Toggle(true);
            }
            else
            {
                //Ok_Toggle(false);
            }
            return v_result;
        }

        private bool Is_Fuel_Norm_Valid()
        {
            bool v_result = false;

            if (this.fuel_normTextBox.Text.Length != 0)
            {
                v_result = true;
                //Ok_Toggle(true);
            }
            else
            {
                //Ok_Toggle(false);
            }

            return v_result;
        }

        private bool Is_Fuel_End_Left_Valid()
        {
            bool v_result = false; decimal v_fuel_end_left;
            try
            {
                v_fuel_end_left = (decimal)Convert.ChangeType(this.fuel_end_leftTextBox.Text, typeof(decimal));
            }
            catch
            {
                v_fuel_end_left = -1;
            }

            if (v_fuel_end_left >= 0)
            {
                v_result = true;
                //Ok_Toggle(true);
            }
            else
            {
                //Ok_Toggle(false);
            }

            return v_result;
        }

        private bool Is_Fuel_Exp_Valid()
        {
            decimal v_fuel_norm = 0, v_fuel_exp = 0;
            bool v_result = false;
            try
            {
                v_fuel_norm = (decimal)Convert.ChangeType(this.fuel_normTextBox.Text, typeof(decimal));
                v_fuel_exp = (decimal)Convert.ChangeType(this.fuel_expTextBox.Text, typeof(decimal));
            }
            catch
            { }

            if ((v_fuel_norm >= v_fuel_exp) && (v_fuel_exp > 0))
            {
                v_result = true;
                //Ok_Toggle(true);
            }
            else
            {
                //Ok_Toggle(false);
            }

            return v_result;
        }

        private bool Is_Fuel_Start_Valid()
        {
            decimal v_fuel_start_left = 0;
            bool v_result = false;
            try
            {
                v_fuel_start_left = (decimal)Convert.ChangeType(this.fuel_start_leftTextBox.Text, typeof(decimal));
                v_result = true;
            }
            catch
            { }

            return v_result;
        }

        private bool Is_Fuel_Gived_Valid()
        {
            decimal v_fuel_gived = 0;
            bool v_result = false;
            try
            {
                v_fuel_gived = (decimal)Convert.ChangeType(this.fuel_givedTextBox.Text, typeof(decimal));
                v_result = true;
            }
            catch
            { }

            return v_result;
        }

        private bool Is_Fuel_Returned_Valid()
        {
            decimal v_fuel_return = 0;
            bool v_result = false;
            try
            {
                v_fuel_return = (decimal)Convert.ChangeType(this.fuel_returnTextBox.Text, typeof(decimal));
                v_result = true;
            }
            catch
            { }

            return v_result;
        }


        private bool Is_Number_Valid()
        {
            decimal v_number = 0;
            bool v_result = false;
            try
            {
                v_number = (decimal)Convert.ChangeType(this.numberTextBox.Text, typeof(decimal));
                v_result = true;
            }
            catch
            { }

            return v_result;
        }

        private bool Is_Start_Indication_Valid()
        {
            decimal v_speedometer_start_indctn = 0;
            bool v_result = false;
            try
            {
                v_speedometer_start_indctn = (decimal)Convert.ChangeType(this.speedometer_start_indctnTextBox.Text, typeof(decimal));
                v_result = true;
            }
            catch
            { }

            return v_result;
        }

        private bool Is_Start_Duty_Valid()
        {
            DateTime v_start_duty;
            bool v_result = false;
            try
            {
                v_start_duty = (DateTime)Convert.ChangeType(this.start_datedateTimePicker.ToString(), typeof(DateTime));
                v_result = true;
            }
            catch
            { }

            return v_result;
        }

        private bool Is_Indication_Valid()
        {
            decimal v_speedometer_start_indctn = 0, v_speedometer_end_indctn = 0;
            bool v_result = false;
            try
            {
                v_speedometer_start_indctn = (decimal)Convert.ChangeType(this.speedometer_start_indctnTextBox.Text, typeof(decimal));
                v_speedometer_end_indctn = (decimal)Convert.ChangeType(this.speedometer_end_indctnTextBox.Text, typeof(decimal));
            }
            catch
            { }

            if (v_speedometer_end_indctn > v_speedometer_start_indctn)
            {
                v_result = true;
                //Ok_Toggle(true);
            }
            else
            {
                //Ok_Toggle(false);
            }

            return v_result;
        }

        private bool Is_Datetime_Duty_Valid()
        {
            DateTime v_fact_start_duty = DateTime.Now, v_fact_end_duty = DateTime.Now;
            bool v_result = false;
            try
            {
                v_fact_start_duty = (DateTime)Convert.ChangeType(this.start_datedateTimePicker.Text, typeof(DateTime));
                v_fact_end_duty = (DateTime)Convert.ChangeType(this.end_datedateTimePicker.Text, typeof(DateTime));
            }
            catch
            {
                MessageBox.Show("Указан неверный формат времени выезда и въезда");
            }

            if (v_fact_end_duty > v_fact_start_duty)
            {
                v_result = true;
                //Ok_Toggle(true);
            }
            else
            {
                //Ok_Toggle(false);
            }

            return v_result;
        }

        private void date_createdDateTimePicker_ValueChanged(object sender, EventArgs e)
        {
              //При смене даты создания, попробуем проверить водителя по плану
            //и проверить даты выхода и въезда
            try
            {
             if (this._form_state != 4)
              {
                  if ((this.car_idTextBox.Text != "")
                      && (this.date_createdDateTimePicker.Text != ""))
                  {
                      this.p_car_idToolStripTextBox.Text
                          = this.car_idTextBox.Text;
                      this.p_start_dateToolStripTextBox.Text
                          = this.date_createdDateTimePicker.Text;
                      //Загрузим водителя по плану
                      try
                      {
                          this.uspVDRV_DRIVER_PLAN_Select_DriverByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_Select_DriverById, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(this.p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));

                      }
                      catch (System.Exception ex)
                      {
                          System.Windows.Forms.MessageBox.Show(ex.Message);
                      }

                      //MessageBox.Show(this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString());
                      try
                      {
                          this.drivercomboBox.Text
                              = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString();
                          this.employee1_idTextBox.Text
                              = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn88.Index].Value.ToString();

                      }
                      catch
                      {
                          this.drivercomboBox.Text = "";
                          this.employee1_idTextBox.Text = "";
                      }
                  }

                }
            }
            catch { }
            //Пробуем обновить значения дат
            try
            {
                if (this._form_state != 4)
                {
                    this.start_datedateTimePicker.Text =
                        this.date_createdDateTimePicker.Text.Substring(0, 10) +
                        this.start_datedateTimePicker.Text.Substring(10, 6)
                        ;

                    this.end_datedateTimePicker.Text =
                        this.date_createdDateTimePicker.Text.Substring(0, 10) +
                        this.end_datedateTimePicker.Text.Substring(10, 6)
                        ;
                }

            }
            catch { }
            
           // _is_valid &= false;
           // Ok_Toggle(_is_valid);
        
        }

        //Функция проверяет элементы на правильность заполнения
        private bool Check_Items()
        {
            bool v_is_counted = true;

            //Проверим элементы на выполнение условий
            v_is_counted &= Is_State_Number_Valid();
            if (Is_State_Number_Valid())
            {
                this.State_Number_errorProvider.SetError(this.car_comboBox, "");
                this.car_comboBox.BackColor
                    = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            }
            else
            {
                this.State_Number_errorProvider.SetError(this.car_comboBox, "Необходимо ввести '№ СТП'");
                this.car_comboBox.BackColor
                    = Color.Red;
            }
            v_is_counted &= Is_Fio_Driver1_Valid();
            if (Is_Fio_Driver1_Valid())
            {
                this.Fio_Driver1_errorProvider.SetError(this.drivercomboBox, "");
                this.drivercomboBox.BackColor
                    = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            }
            else
            {
                this.Fio_Driver1_errorProvider.SetError(this.drivercomboBox, "Необходимо ввести 'Водителя'");
                this.drivercomboBox.BackColor
                    = Color.Red;
            }

            //Проверим элементы на выполнение условий
            v_is_counted &= Is_Fuel_Norm_Valid();
            if (Is_Fuel_Norm_Valid())
            {
                this.Fuel_norm_errorProvider.SetError(this.fuel_normTextBox, "");
                this.fuel_normTextBox.BackColor
                    = System.Drawing.SystemColors.Control;
            }
            else
            {
                this.Fuel_norm_errorProvider.SetError(this.fuel_normTextBox, "Неуказана норма расхода. Вы завели норму в справочнике?");
                this.fuel_normTextBox.BackColor
                    = Color.Red;
            }

            //v_is_counted &= Is_Fuel_Exp_Valid();
            if (Is_Fuel_Exp_Valid())
            {
                this.fuel_expTextBox.ForeColor
                    = Color.Black;
                this.Fuel_exp_errorProvider.SetError(this.fuel_expTextBox, "");

            }
            else
            {
                this.fuel_expTextBox.ForeColor
                    = Color.Red;
                this.Fuel_exp_errorProvider.SetError(this.fuel_expTextBox, "Проверьте расход");
                //Закроем флаг ошибки, для того, чтобы можно было выйти из формы
            }

            v_is_counted &= Is_Fuel_End_Left_Valid();
            if (Is_Fuel_End_Left_Valid())
            {

                this.fuel_end_leftTextBox.ForeColor
                    = Color.Black;
                this.Fuel_end_left_errorProvider.SetError(this.fuel_end_leftTextBox, "");

            }
            else
            {
                this.fuel_end_leftTextBox.ForeColor
                    = Color.Red;
                this.Fuel_end_left_errorProvider.SetError(this.fuel_end_leftTextBox, "Проверьте остаток топлива");
            }
            v_is_counted &= Is_Indication_Valid();
            if (Is_Indication_Valid())
            {
                this.speedometer_end_indctnTextBox.ForeColor
                    = Color.Black;
                this.Indication_errorProvider.SetError(this.speedometer_end_indctnTextBox, "");

            }
            else
            {
                this.speedometer_end_indctnTextBox.ForeColor
                    = Color.Red;
                this.Indication_errorProvider.SetError(this.speedometer_end_indctnTextBox, "Проверьте пробег");

            }
            v_is_counted &= Is_Datetime_Duty_Valid();
            if (Is_Datetime_Duty_Valid())
            {
                this.start_datedateTimePicker.ForeColor
                    = Color.Black;
                //this.fact_start_duty_time_visible_textBox.ForeColor
                //    = Color.Black;
                this.end_datedateTimePicker.ForeColor
                    = Color.Black;
                //this.fact_end_duty_time_visible_textBox.ForeColor
                //    = Color.Black;
                this.Datetime_duty_errorProvider.SetError(this.end_datedateTimePicker, "");

            }
            else
            {
                this.start_datedateTimePicker.ForeColor
                    = Color.Red;
                //this.fact_start_duty_time_visible_textBox.ForeColor
                //    = Color.Red;
                this.end_datedateTimePicker.ForeColor
                    = Color.Red;
                //this.fact_end_duty_time_visible_textBox.ForeColor
                //    = Color.Red;
                this.Datetime_duty_errorProvider.SetError(this.end_datedateTimePicker, "Проверьте дату");

            }
            v_is_counted &= Is_Fuel_Returned_Valid();
            if (Is_Fuel_Returned_Valid())
            {

                this.fuel_returnTextBox.ForeColor
                    = Color.Black;
                this.Fuel_returnerrorProvider.SetError(this.fuel_returnTextBox, "");

            }
            else
            {
                this.fuel_returnTextBox.ForeColor
                    = Color.Red;
                this.Fuel_returnerrorProvider.SetError(this.fuel_returnTextBox, "Проверьте возврат топлива");
            }


            return v_is_counted;
        }

        private void speedometer_start_indctnTextBox_TextChanged(object sender, EventArgs e)
        {
            int v_number;
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
            else
            {
                _is_valid = this.Check_start_items();
                this.Ok_Toggle(_is_valid);
            }

        }

        private void start_datedateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            DateTime v_number;
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
            else
            {
                _is_valid = this.Check_start_items();
                this.Ok_Toggle(_is_valid);
            }
        }

        private void end_datedateTimePicker_ValueChanged(object sender, EventArgs e)
        {

            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }

        }

        private void speedometer_end_indctnTextBox_TextChanged(object sender, EventArgs e)
        {
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
        }

        private void fuel_start_leftTextBox_TextChanged(object sender, EventArgs e)
        {
            int v_number;
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
            else
            {
                _is_valid = this.Check_start_items();
                this.Ok_Toggle(_is_valid);
            }
        }

        private void fuel_givedTextBox_TextChanged(object sender, EventArgs e)
        {
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
            else
            {
                _is_valid = this.Check_start_items();
                this.Ok_Toggle(_is_valid);
            }
        }

        private void runTextBox_TextChanged(object sender, EventArgs e)
        {

        }

        private void fuel_consumptionTextBox_TextChanged(object sender, EventArgs e)
        {

        }

        private void fuel_returnTextBox_TextChanged(object sender, EventArgs e)
        {
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
        }

        private void pw_counttextBox_TextChanged(object sender, EventArgs e)
        {
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
        }

        public void print_document()
        {
        //Напечатаем в зависимости от типа формы путевку
            string filled_file = "";
            string v_number = "";
            string v_datetime = "";
            string v_org_wo_address = "";
            string v_car_mark_model = "";
            string v_state_number = "";
            string v_driver_fio = "";
            string v_driver_passport = "";
            string v_speedometer_start_indctn = "";
            string v_speedometer_end_indctn = "";
            string v_dependent_on = "диспетчера";
            string v_usage_area_1 = "Москва";
            string v_usage_area_2 = "Московская область";
            string v_fuel_start_left = "";
            string v_fuel_end_left = "";
            string v_fuel_norm = "";
            string v_fuel_exp = "";
            string v_fact_start_duty_time = "";
            string v_fact_end_duty_time = "";
            string v_fuel_gived = "";
            string v_date = "";
            string v_monthyear = "";
            string v_plan_day = "";
            string v_plan_month = "";
            string v_plan_hour = "08";
            string v_plan_min = "00";
            string v_adtnl_driver_fio = "";
            string v_mech_fio = "";
            string v_adtnl_mech_fio = "";
            string v_fuel_type_sname = "";
            Acrobat Printfile = new Acrobat();

            if (this.numberTextBox.Text != "")
            {
                v_number = this.numberTextBox.Text;
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_datetime = this.date_createdDateTimePicker.Text;
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_date = this.date_createdDateTimePicker.Text.Substring(0,2);
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_monthyear = this.date_createdDateTimePicker.Value.ToLongDateString().ToString().Substring(2
                                                            ,this.date_createdDateTimePicker.Value.ToLongDateString().ToString().Length - 2);
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_plan_day = this.date_createdDateTimePicker.Value.Day.ToString();
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_plan_month = this.date_createdDateTimePicker.Value.Month.ToString();
            }
            if (this.organization_snameTextBox.Text != "")
            {
                v_org_wo_address = "ООО " + @"""" + this.organization_snameTextBox.Text + @"""";
            }
            if (this.car_mark_model_nameTextBox.Text != "")
            {
                v_car_mark_model = this.car_mark_model_nameTextBox.Text;
            }
            if (this.car_comboBox.Text != "")
            {
                v_state_number = this.car_comboBox.Text;
            }

            if (this.addtnl_driver_comboBox.Text != "")
            {
                v_adtnl_driver_fio = this.addtnl_driver_comboBox.Text;
            }

            if (this.drivercomboBox.Text != "")
            {
                v_driver_fio = this.drivercomboBox.Text;
            }
            if (this.speedometer_start_indctnTextBox.Text != "")
            {
                v_speedometer_start_indctn = this.speedometer_start_indctnTextBox.Text;
            }
            if (this.speedometer_end_indctnTextBox.Text != "")
            {
                v_speedometer_end_indctn = this.speedometer_end_indctnTextBox.Text;
            }
            if (this.fuel_start_leftTextBox.Text != "")
            {
                v_fuel_start_left = this.fuel_start_leftTextBox.Text;
            }
            if (this.fuel_end_leftTextBox.Text != "")
            {
                v_fuel_end_left = this.fuel_end_leftTextBox.Text;
            }
            if (this.fuel_normTextBox.Text != "")
            {
                v_fuel_norm = this.fuel_normTextBox.Text;
            }
            if (this.fuel_expTextBox.Text != "")
            {
                v_fuel_exp = this.fuel_expTextBox.Text;
            }
            if (this.start_datedateTimePicker.Text != "")
            {
                v_fact_start_duty_time = this.start_datedateTimePicker.Text.Substring(11, 5);
            }
            if ((this.end_datedateTimePicker.Text != "")
                && (this.end_datedateTimePicker.Text != this.start_datedateTimePicker.Text))
            {
                v_fact_end_duty_time = this.end_datedateTimePicker.Text.Substring(11, 5);
            }
            if (this.fuel_givedTextBox.Text != "")
            {
                v_fuel_gived = this.fuel_givedTextBox.Text;
            }
            if (this.mechcomboBox.Text != "")
            {
                v_mech_fio = this.mechcomboBox.Text;
            }

            if (this.addtnl_mechcomboBox.Text != "")
            {
                v_adtnl_mech_fio = this.addtnl_mechcomboBox.Text;
            }

            if (this.driver_licensetextBox.Text != "")
            {
                v_driver_passport = this.driver_licensetextBox.Text;
            }

            if (this.fuel_type_snametextBox.Text != "")
            {
                v_fuel_type_sname = this.fuel_type_snametextBox.Text;
            }

            //Легковой автомобиль
            if (this.driver_list_type_idTextBox.Text == Const.Car_driver_list_type_id.ToString())
            {
                
                _filled_file = Printfile.Auto3_form_fill(v_number
                                                        , v_datetime
                                                        , v_org_wo_address
                                                        , v_car_mark_model
                                                        , v_state_number
                                                        , v_driver_fio
                                                        , v_driver_passport
                                                        , ""
                                                        , v_speedometer_start_indctn
                                                        , v_speedometer_end_indctn
                                                        , v_dependent_on
                                                        , v_usage_area_1
                                                        , v_usage_area_2
                                                        , v_fuel_start_left
                                                        , v_fuel_end_left
                                                        , v_fuel_norm
                                                        , v_fuel_exp
                                                        , v_fact_start_duty_time
                                                        , v_fact_end_duty_time
                                                        , v_fuel_gived
                                                        , v_fuel_type_sname
                                                        , ""
                                                        , v_adtnl_mech_fio
                                                        , v_mech_fio
                                                        , v_adtnl_driver_fio);
            }
            //Грузовой автомобиль
            if (this.driver_list_type_idTextBox.Text == Const.Freight_driver_list_type_id.ToString())
            {
                
                _filled_file = Printfile.Auto4p_form_fill(v_number
                                                        , v_date
                                                        , v_monthyear
                                                        , v_org_wo_address
                                                        , v_car_mark_model
                                                        , v_state_number
                                                        , v_driver_fio
                                                        , v_driver_passport
                                                        , ""
                                                        , v_speedometer_start_indctn
                                                        , v_speedometer_end_indctn
                                                        , v_dependent_on
                                                        , v_usage_area_1
                                                        , v_usage_area_2
                                                        , v_fuel_start_left
                                                        , v_fuel_end_left
                                                        , v_fuel_norm
                                                        , v_fuel_exp
                                                        , v_fact_start_duty_time
                                                        , v_fact_end_duty_time
                                                        , v_fuel_gived
                                                        , v_plan_day
                                                        , v_plan_month
                                                        , v_plan_hour
                                                        , v_plan_min
                                                        , v_fuel_type_sname
                                                        , ""
                                                        , v_adtnl_mech_fio
                                                        , v_mech_fio
                                                        , v_adtnl_driver_fio);
            }
              //  Printfile.Form_print(this.Ar_path, filled_file, this.Printer_name);
            this.backgroundWorker1.RunWorkerAsync();
            
        
        }
        //Печать бланков
        private void printToolStripButton_Click(object sender, EventArgs e)
        {
            using (Print_blank Print_blankForm = new Print_blank())
            {
                Print_blankForm.ShowDialog(this);
                if (Print_blankForm.DialogResult == DialogResult.OK)
                {

                    //Легковой автомобиль
                    if (Print_blankForm.Print_blank_driver_list_type_id == Const.Car_driver_list_type_id.ToString())
                    {
                        _filled_file = "forms\\avto_3_blank.pdf";
                        

                        //Printfile.Form_print(this.Ar_path, "forms\\avto_3_blank.pdf", this.Printer_name);
                    }
                    //Грузовой автомобиль
                    if (Print_blankForm.Print_blank_driver_list_type_id == Const.Freight_driver_list_type_id.ToString())
                    {
                        _filled_file = "forms\\avto_4p_blank.pdf";
                       // Printfile.Form_print(this.Ar_path, "forms\\avto_4p_blank.pdf", this.Printer_name);
                    }
                    _doc_count = (int)Convert.ChangeType(Print_blankForm.Print_blank_number, typeof(int));
                    _work_switch = 2;
                    this.backgroundWorker1.RunWorkerAsync();
                }
            }
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            if (this._work_switch == 1)
            {
                Printfile.Form_print(this.Ar_path, _filled_file, this.Printer_name);
                //Printfile.Form_gs_print_pages_count(Application.StartupPath + "\\" + _filled_file, this.Printer_spool, this.Printer_device, "1", "1", 1);
            }
            if (this._work_switch == 2)
            {
                Printfile.Form_blank_print(this.Ar_path, _filled_file, this.Printer_name, _doc_count);
                //Printfile.Form_gs_print_pages_count(Application.StartupPath + "\\" + _filled_file, this.Printer_spool, this.Printer_device, "2", "2", _doc_count);
            }
        }

        private void drivercomboBox_ValueMemberChanged(object sender, EventArgs e)
        {

        }

        private bool Check_start_items()
        {
            bool v_is_counted = true;

            v_is_counted &= Is_Fio_Driver1_Valid();
            if (Is_Fio_Driver1_Valid())
            {
                this.Fio_Driver1_errorProvider.SetError(this.drivercomboBox, "");
                this.drivercomboBox.BackColor
                    = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            }
            else
            {
                this.Fio_Driver1_errorProvider.SetError(this.drivercomboBox, "Необходимо ввести 'Водителя'");
                this.drivercomboBox.BackColor
                    = Color.Red;
            }


            v_is_counted &= Is_Fuel_Start_Valid();
            if (Is_Fuel_Start_Valid())
            {

                this.fuel_start_leftTextBox.ForeColor
                    = Color.Black;
                this.Fuel_end_left_errorProvider.SetError(this.fuel_start_leftTextBox, "");

            }
            else
            {
                this.fuel_start_leftTextBox.ForeColor
                    = Color.Red;
                this.Fuel_end_left_errorProvider.SetError(this.fuel_start_leftTextBox, "Проверьте остаток топлива");
            }
            v_is_counted &= Is_Start_Indication_Valid();
            if (Is_Start_Indication_Valid())
            {
                this.speedometer_start_indctnTextBox.ForeColor
                    = Color.Black;
                this.Indication_errorProvider.SetError(this.speedometer_start_indctnTextBox, "");

            }
            else
            {
                this.speedometer_start_indctnTextBox.ForeColor
                    = Color.Red;
                this.Indication_errorProvider.SetError(this.speedometer_start_indctnTextBox, "Проверьте пробег");

            }

            v_is_counted &= Is_Number_Valid();
            if (Is_Number_Valid())
            {
                this.numberTextBox.ForeColor
                    = Color.Black;
                this.Indication_errorProvider.SetError(this.numberTextBox, "");

            }
            else
            {
                this.numberTextBox.ForeColor
                    = Color.Red;
                this.Indication_errorProvider.SetError(this.numberTextBox, "Проверьте номер путевки");

            }

            v_is_counted &= Is_Fuel_Gived_Valid();
            if (Is_Fuel_Gived_Valid())
            {
                this.fuel_givedTextBox.ForeColor
                    = Color.Black;
                this.Indication_errorProvider.SetError(this.fuel_givedTextBox, "");

            }
            else
            {
                this.fuel_givedTextBox.ForeColor
                    = Color.Red;
                this.Indication_errorProvider.SetError(this.fuel_givedTextBox, "Проверьте выдачу топлива");

            }


            return v_is_counted;
        }

        private void numberTextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid = Check_start_items();
            this.Ok_Toggle(_is_valid);
        }

        private void drivercomboBox_TextChanged(object sender, EventArgs e)
        {
            if (this._form_state == 4)
            {
                this.counttoolStripButton_Click(sender, e);
            }
            else
            {
                _is_valid = this.Check_start_items();
                this.Ok_Toggle(_is_valid);
            }
        }



    }
}
