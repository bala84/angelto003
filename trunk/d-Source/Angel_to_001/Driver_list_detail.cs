using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using iTextSharp.text.pdf;

namespace Angel_to_001
{
    public partial class Driver_list_detail : Form
    {
        //Принимаемые значения
        //Переменная валидности формы
        public string _username;

        private bool _is_valid = true;
        public string _driver_list_id;
        public string _driver_list_date_created;
        public string _driver_list_number;
        public string _driver_list_car_id;
        public string _driver_list_state_number;
        public string _driver_list_car_mark_model_name;
        public string _driver_list_employee1_id;
        public string _driver_list_employee2_id;
        public string _driver_list_fuel_norm;
        public string _driver_list_fact_start_duty;
        public string _driver_list_fact_end_duty;
        public string _driver_list_driver_list_state_id;
        public string _driver_list_driver_list_state_name;
        public string _driver_list_type_name;
        public string _driver_list_type_id;
        public string _driver_list_organization_id;
        public string _driver_list_org_name;
        public string _driver_list_fuel_type_id;
        public string _driver_list_fuel_type_name;
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
        public string _driver_list_employee_id;
        public string _driver_list_last_date_created;
        public string _error_text;
        public string _start_run;
        //Переменная текущего состояния формы
        //1 - Вставка, 2 - Редактирование, 3 - Удаление
        public byte _form_state;
        public bool _is_counted = false;
        public bool _org_name_validated = false;
        public bool _fio_driver1_validated = false;
        public bool _state_number_validated = false;
        public bool _fuel_norm_validated = false;
        public bool _fuel_exp_validated = false;
        public bool _indication_validated = false;
        public bool _datetime_duty_validated = false;
        public bool _fuel_end_left_validated = false;

        Acrobat Printfile = new Acrobat();
        private string _filled_file = "";

        public string Ar_path = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Ar_path"];
        public string Printer_name = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_name"];
        public string Printer_spool = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Spool_path"];
        public string Printer_device = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_device"]; 

        public Driver_list_detail()
        {
            InitializeComponent();


        }
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
            get { return this.state_numberTextBox.Text; }
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
            get { return this.dateTimePicker1.Text; }
        }


        public string Driver_list_fact_end_duty
        {
            get { return this.dateTimePicker2.Text; }
        }

        public string Driver_list_driver_list_state_id
        {
            get { return this.driver_list_state_idTextBox.Text; }
        }

        public string Driver_list_driver_list_state_name
        {
            get { return this.driver_list_state_nameComboBox.Text; }
        }

        public string Driver_list_driver_list_type_id
        {
            get { return this.driver_list_type_idTextBox.Text; }
        }

        public string Driver_list_driver_list_type_name
        {
            get { return this.driver_list_type_nameTextBox.Text; }
        }

        public string Driver_list_organization_id
        {
            get { return this.organization_idTextBox.Text; }
        }


        public string Driver_list_org_name
        {
            get { return this.org_nameTextBox.Text; }
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
        public string Driver_list_fuel_addtnl_exp
        {
            get { return this.fuel_addtnl_expTextBox.Text; }
        }
        public string Driver_list_run
        {
            get { return this.runTextBox.Text; }
        }
        public string Driver_list_fuel_consumption
        {
            get { return this.fuel_consumptionTextBox.Text; }
        }
        public string Driver_list_fio_driver1
        {
            get { return this.fio_driver1TextBox.Text; }
        }
        public string Driver_list_fio_driver2
        {
            get { return this.fio_driver2TextBox.Text; }
        }

        public string Driver_list_condition_id
        {
            get { return this.condition_idtextBox.Text; }
        }

        public string Driver_list_last_run
        {
            get { return this.last_runtextBox.Text; }
        }

        public string Driver_list_edit_state
        {
            get { return this.edit_statetextBox.Text; }
        }

        public string Driver_list_employee_id
        {
            get { return this.employee_idTextBox.Text; }
        }

        public string Driver_list_last_date_created
        {
            get
            {
                return this.last_date_createdtextBox.Text;
            }
        }

        private void utfVDRV_DRIVER_LISTBindingNavigatorSaveItem_Click(object sender, EventArgs e)
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
                     string    v_edit_state = "";
                        int   v_power_trailer_consumption = 0;

            //Если заполнены необходмые поля - сохраняем
            if ((this.date_createdDateTimePicker.Text != "")
                  && (this.fio_driver1TextBox.Text != "")
                  && (this.car_idTextBox.Text != "")
                  && (this.dateTimePicker1.Text != "")
                  && (this.dateTimePicker2.Text != "")
                  && (this.fuel_type_idTextBox.Text != "")
                  && (this.driver_list_type_idTextBox.Text != "")
                  && (this.driver_list_state_idTextBox.Text != "")
                 )
            {
                try
                {
                    if (this.idTextBox.Text != "")
                    {
                        v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
                    }
                    this.Validate();
                    this.uspVDRV_DRIVER_LIST_SelectByIdBindingSource.EndEdit();
                    this.utfVDRV_TRAILERBindingSource.EndEdit();
                    if (this._form_state == 3)
                    {
                        //this.utfVDRV_TRAILERTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(this.p_device_idToolStripTextBox.Text, typeof(decimal))), new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))));
                        //this.u.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))));
                    }
                    else
                    {
                        if (this.numberTextBox.Text != "")
                        {
                            v_number = (long)Convert.ChangeType(this.numberTextBox.Text, typeof(long));
                        }
                        v_car_id = (decimal)Convert.ChangeType(this.car_idTextBox.Text, typeof(decimal));

                        if (this.condition_idtextBox.Text != "")
                        {
                            v_condition_id = (decimal)Convert.ChangeType(this.condition_idtextBox.Text, typeof(decimal));
                        }
                        v_driver_list_state_id = (decimal)Convert.ChangeType(this.driver_list_state_idTextBox.Text, typeof(decimal));
                        v_driver_list_type_id = (decimal)Convert.ChangeType(this.driver_list_type_idTextBox.Text, typeof(decimal));
                        v_fuel_exp = (decimal)Convert.ChangeType(this.fuel_expTextBox.Text, typeof(decimal));
                        v_fuel_type_id = (decimal)Convert.ChangeType(this.fuel_type_idTextBox.Text, typeof(decimal));
                        v_organization_id = (decimal)Convert.ChangeType(this.organization_idTextBox.Text, typeof(decimal));
                        v_employee1_id = (decimal)Convert.ChangeType(this.employee1_idTextBox.Text, typeof(decimal));
                        if (this.employee2_idTextBox.Text != "")
                        {
                            v_employee2_id = (decimal)Convert.ChangeType(this.employee2_idTextBox.Text, typeof(decimal));
                        }
                        v_speedometer_start_indctn = (decimal)Convert.ChangeType(this.speedometer_start_indctnTextBox.Text, typeof(decimal));
                        v_speedometer_end_indctn = (decimal)Convert.ChangeType(this.speedometer_end_indctnTextBox.Text, typeof(decimal));
                        v_fuel_start_left = (decimal)Convert.ChangeType(this.fuel_start_leftTextBox.Text, typeof(decimal));
                        v_fuel_end_left = (decimal)Convert.ChangeType(this.fuel_end_leftTextBox.Text, typeof(decimal));
                        if (this.fuel_givedTextBox.Text != "")
                        {
                            v_fuel_gived = (decimal)Convert.ChangeType(this.fuel_givedTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_returnTextBox.Text != "")
                        {
                            v_fuel_return = (decimal)Convert.ChangeType(this.fuel_returnTextBox.Text, typeof(decimal));
                        }
                        if (this.fuel_addtnl_expTextBox.Text != "")
                        {
                            v_fuel_addtnl_exp = (decimal)Convert.ChangeType(this.fuel_addtnl_expTextBox.Text, typeof(decimal));
                        }
                        if (this.last_runtextBox.Text != "")
                        {
                            v_last_run = (decimal)Convert.ChangeType(this.last_runtextBox.Text, typeof(decimal));
                        }
                        v_run = (decimal)Convert.ChangeType(this.runTextBox.Text, typeof(decimal));
                        v_fuel_consumption = (decimal)Convert.ChangeType(this.fuel_consumptionTextBox.Text, typeof(decimal));
                        if (this.employee_idTextBox.Text != "")
                        {
                            v_employee_id = (decimal)Convert.ChangeType(this.employee_idTextBox.Text, typeof(decimal));
                        }
                        if (this.last_date_createdtextBox.Text != "")
                        {
                            v_last_date_created = (DateTime)Convert.ChangeType(this.last_date_createdtextBox.Text, typeof(DateTime));
                        }
                        if (this.edit_statetextBox.Text != "")
                        {
                            v_edit_state = this.edit_statetextBox.Text;
                        }

                        //Энергоустановка
                        v_power_trailer_consumption =
                        Trailer_Consumption_Count(Const.Power_trailer_id);

                        this.uspVDRV_DRIVER_LIST_SelectByIdTableAdapter.Update(ref v_id
                                                                               , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime)))
                                                                               , v_number
                                                                               , v_car_id
                                                                               , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.dateTimePicker1.Text, typeof(DateTime)))
                                                                               , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.dateTimePicker2.Text, typeof(DateTime)))
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
                                                                               , v_edit_state
                                                                               , v_employee_id
                                                                               , v_last_date_created
                                                                               , v_power_trailer_consumption
                                                                               , this.sys_commentTextBox.Text
                                                                               , this._username);




                    }
                    if (this._form_state != 3)
                    {
                        this.idTextBox.Text = v_id.ToString();
                        this.p_driver_list_idToolStripTextBox.Text = v_id.ToString();
                        Just.Prepare_Detail(dataGridViewTextBoxColumn21.Index, this.utfVDRV_TRAILERDataGridView.Rows, this.idTextBox.Text);
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
                        case 515:
                            MessageBox.Show("Необходимо заполнить все обязательные поля!");
                            break;

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
        }

        private void Driver_list_detail_Load(object sender, EventArgs e)
        {
            if (_driver_list_run != "")
            {
                _start_run = _driver_list_run;
            }
            else
            {
                _start_run = "";
            }
            //Выключим кнопку при работе в вставке и редактировании
            if ((_form_state == 1) || (_form_state == 2))
            {
                this.button_ok.Enabled = false;
                this.driver_list_state_nameComboBox.Text = "Закрыт";
            }

            if (_form_state == 3)
            {
                this.BackColor = Color.Red;
            }
            else
            {
                this.BackColor = System.Drawing.SystemColors.Control;
            }

            if (_form_state == 2)
            {

                this.edit_statetextBox.Text = "E";

              //  this.button_car.Enabled = false;
             //   this.button_organization.Enabled = false;
            }

            this.Text = this.Text + " путевой лист";
            this.driver_list_type_nameTextBox.Text = this._driver_list_type_name;
            this.driver_list_type_idTextBox.Text = this._driver_list_type_id;

            this.p_device_idToolStripTextBox.Text = Const.Power_trailer_id.ToString();


            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = false;
            //Заполняем поля из переменных
            if ((_driver_list_id != "")
                && (_driver_list_id != null))
            {
                this.idTextBox.Text = _driver_list_id;
                this.p_driver_list_idToolStripTextBox.Text = _driver_list_id;
            }
            if ((_driver_list_date_created != "")
                && (_driver_list_date_created != null))
            {
                this.date_createdDateTimePicker.Text = _driver_list_date_created;
            }
            if ((_driver_list_number != "")
                && (_driver_list_number != null))
            {
                this.numberTextBox.Text = _driver_list_number;
            }
            if ((_driver_list_car_id != "")
                && (_driver_list_car_id != null))
            {
                this.car_idTextBox.Text = _driver_list_car_id;
            }
            if ((_driver_list_state_number != "")
                && (_driver_list_state_number != null))
            {
                this.state_numberTextBox.Text = _driver_list_state_number;
            }
            if ((_driver_list_car_mark_model_name != "")
                && (_driver_list_car_mark_model_name != null))
            {
                this.car_mark_model_nameTextBox.Text = _driver_list_car_mark_model_name;
            }
            if ((_driver_list_employee1_id != "")
                && (_driver_list_employee1_id != null))
            {
                this.employee1_idTextBox.Text = _driver_list_employee1_id;
            }
            if ((_driver_list_employee2_id != "")
                && (_driver_list_employee2_id != null))
            {
                this.employee2_idTextBox.Text = _driver_list_employee2_id;
            }
            if ((_driver_list_fuel_norm != "")
                && (_driver_list_fuel_norm != null))
            {
                this.fuel_normTextBox.Text = _driver_list_fuel_norm;
            }
            if ((_driver_list_fact_start_duty != "")
                && (_driver_list_fact_start_duty != null))
            {
                this.dateTimePicker1.Text =
                    ((DateTime)Convert.ChangeType(_driver_list_fact_start_duty, typeof(DateTime))).ToString();
                //this.fact_start_duty_time_visible_textBox.Text =
                //   ((DateTime)Convert.ChangeType(_driver_list_fact_start_duty, typeof(DateTime))).ToShortTimeString();
            }
            if ((_driver_list_fact_end_duty != "")
                && (_driver_list_fact_end_duty != null))
            {
                this.dateTimePicker2.Text =
                    ((DateTime)Convert.ChangeType(_driver_list_fact_end_duty, typeof(DateTime))).ToString();
                //this.fact_end_duty_time_visible_textBox.Text =
                //            ((DateTime)Convert.ChangeType(_driver_list_fact_end_duty, typeof(DateTime))).ToShortTimeString();

            }
            if ((_driver_list_driver_list_state_id != "")
                && (_driver_list_driver_list_state_id != null))
            {
                this.driver_list_state_idTextBox.Text = _driver_list_driver_list_state_id;
            }
            if ((_driver_list_organization_id != "")
                && (_driver_list_organization_id != null))
            {
                this.organization_idTextBox.Text = _driver_list_organization_id;
            }
            if ((_driver_list_org_name != "")
                && (_driver_list_org_name != null))
            {
                this.org_nameTextBox.Text = _driver_list_org_name;
            }
            if ((_driver_list_fuel_type_id != "")
                && (_driver_list_fuel_type_id != null))
            {
                this.fuel_type_idTextBox.Text = _driver_list_fuel_type_id;
            }
            if ((_driver_list_fuel_type_name != "")
                && (_driver_list_fuel_type_name != null))
            {
                this.fuel_type_nameTextBox.Text = _driver_list_fuel_type_name;
            }
            if ((_driver_list_fuel_exp != "")
                && (_driver_list_fuel_exp != null))
            {
                this.fuel_expTextBox.Text = _driver_list_fuel_exp;
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
            if ((_driver_list_fuel_start_left != "")
                && (_driver_list_fuel_start_left != null))
            {
                this.fuel_start_leftTextBox.Text = _driver_list_fuel_start_left;
            }
            if ((_driver_list_fuel_end_left != "")
                && (_driver_list_fuel_end_left != null))
            {
                this.fuel_end_leftTextBox.Text = _driver_list_fuel_end_left;
            }
            if ((_driver_list_fuel_gived != "")
                && (_driver_list_fuel_gived != null))
            {
                this.fuel_givedTextBox.Text = _driver_list_fuel_gived;
            }
            if ((_driver_list_fuel_return != "")
                && (_driver_list_fuel_return != null))
            {
                this.fuel_returnTextBox.Text = _driver_list_fuel_return;
            }
            if ((_driver_list_fuel_addtnl_exp != "")
                && (_driver_list_fuel_addtnl_exp != null))
            {
                this.fuel_addtnl_expTextBox.Text = _driver_list_fuel_addtnl_exp;
            }
            if ((_driver_list_run != "")
                && (_driver_list_run != null))
            {
                this.runTextBox.Text = _driver_list_run;
            }
            if ((_driver_list_fuel_consumption != "")
                && (_driver_list_fuel_consumption != null))
            {
                this.fuel_consumptionTextBox.Text = _driver_list_fuel_consumption;
            }
            if ((_driver_list_fio_driver1 != "")
                && (_driver_list_fio_driver1 != null))
            {
                this.fio_driver1TextBox.Text = _driver_list_fio_driver1;
            }
            if ((_driver_list_fio_driver2 != "")
                && (_driver_list_fio_driver2 != null))
            {
                this.fio_driver2TextBox.Text = _driver_list_fio_driver2;
            }

            if ((_driver_list_condition_id != "")
                && (_driver_list_condition_id != null))
            {
                this.condition_idtextBox.Text = _driver_list_condition_id;
            }

            if ((_driver_list_employee_id != "")
                && (_driver_list_employee_id != null))
            {
                this.employee_idTextBox.Text = _driver_list_employee_id;
            }

            if ((_driver_list_last_date_created != "")
                && (_driver_list_last_date_created != null))
            {
                this.last_date_createdtextBox.Text = _driver_list_last_date_created;
            }
            else
            {
                this.last_date_createdtextBox.Text = this.date_createdDateTimePicker.Text;
            }




            if (this.driver_list_state_idTextBox.Text == Const.Closed_driver_list_state_id.ToString())
            {
                this.driver_list_state_nameComboBox.Text = "Закрыт";
            }
            else
            {
                this.driver_list_state_nameComboBox.Text = "Открыт";

            }

            if ((p_device_idToolStripTextBox.Text != "")
                && (p_driver_list_idToolStripTextBox.Text != ""))
            {
                try
                {
                    this.utfVDRV_TRAILERTableAdapter.Fill(this.aNGEL_TO_001_Driver_trailer.utfVDRV_TRAILER, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_device_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_driver_list_idToolStripTextBox.Text, typeof(decimal))))));
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }
            }

            //Если не выбралось не одной записи - нужно проставить по умолчанию "Энергоустановку"
            if ((this.utfVDRV_TRAILERDataGridView.Rows.Count - 1) == 0)
            {
                this.utfVDRV_TRAILERBindingSource.AddNew();
                this.utfVDRV_TRAILERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
                    = Const.Power_trailer;
                this.utfVDRV_TRAILERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
                    = Const.Power_trailer_id;
                this.utfVDRV_TRAILERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
                    = "0";
            }

        }

        private void button_driver_list_type_Click(object sender, EventArgs e)
        {
            using (Driver_list_type Driver_list_typeForm = new Driver_list_type())
            {
                Driver_list_typeForm.ShowDialog(this);
                if (Driver_list_typeForm.DialogResult == DialogResult.OK)
                {
                    this.driver_list_type_nameTextBox.Text = Driver_list_typeForm.Driver_list_type_sname;
                    this.driver_list_type_idTextBox.Text = Driver_list_typeForm.Driver_list_type_id;
                }
            }

        }

        private void button_organization_Click(object sender, EventArgs e)
        {
            using (Organization OrganizationForm = new Organization())
            {
                OrganizationForm.ShowDialog(this);
                if (OrganizationForm.DialogResult == DialogResult.OK)
                {
                    this.org_nameTextBox.Text = OrganizationForm.Org_sname;
                    this.organization_idTextBox.Text = OrganizationForm.Org_id;
                    if (this.car_idTextBox.Text != "")
                    {
                        this.p_car_idToolStripTextBox.Text
                            = this.car_idTextBox.Text;
                        //Загрузим тип автомобиля
                        try
                        {

                            this.uspVCAR_CAR_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001_Car_SelectById.uspVCAR_CAR_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }

                        if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn70.Index].Value.ToString() != "")
                                   && (this.organization_idTextBox.Text != ""))
                        {
                            this.numberTextBox.Text
                            = Just.Get_driver_list_number((decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn70.Index].Value.ToString(), typeof(decimal))
                                                          , (decimal)Convert.ChangeType(this.organization_idTextBox.Text, typeof(decimal)));
                        }
                    }
                }
            }
        }

        private void button_car_Click(object sender, EventArgs e)
        {
            using (Car CarForm = new Car())
            {
                CarForm.ShowDialog(this);
                if (CarForm.DialogResult == DialogResult.OK)
                {
                    this.state_numberTextBox.Text = CarForm.Car_state_number;
                    this.car_mark_model_nameTextBox.Text = CarForm.Car_mark_model_sname;
                    this.car_idTextBox.Text = CarForm.Car_id;
                    this.p_car_idToolStripTextBox.Text = CarForm.Car_id;
                    this.fuel_type_idTextBox.Text = CarForm.Car_fuel_type_id;
                    this.fuel_type_nameTextBox.Text = CarForm.Car_fuel_type_sname;
                    this.fuel_normTextBox.Text = CarForm.Car_fuel_norm;
                    //Поставим начальное показание спидометра равное
                    //последнему показанию спидометра
                    this.speedometer_start_indctnTextBox.Text = CarForm.Car_speedometer_end_indctn;
                    //Укажем id condition
                    this.condition_idtextBox.Text = CarForm.Car_condition_id;
                    //Укажем остаток топлива
                    this.fuel_start_leftTextBox.Text = CarForm.Car_fuel_end_left;
                    //Ид механика
                    this.employee_idTextBox.Text = CarForm.Car_employee_id;
                    //При смене автомобиля, попробуем проверить организацию по плану
                    try
                    {
                        if ((this.car_idTextBox.Text != "")
                            && (this.date_createdDateTimePicker.Text != ""))
                        {
                            this.p_car_idToolStripTextBox.Text
                                = this.car_idTextBox.Text;
                            this.p_date_createdToolStripTextBox.Text
                                = this.date_createdDateTimePicker.Text;
                            //Загрузим организацию по плану
                            try
                            {
                                this.uspVDRV_DRIVER_PLAN_Select_DriverByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_Select_DriverById, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_createdToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                                this.uspVCAR_CAR_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001_Car_SelectById.uspVCAR_CAR_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                            }
                            catch (System.Exception ex)
                            {
                                System.Windows.Forms.MessageBox.Show(ex.Message);
                            }

                            //MessageBox.Show(this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString());
                            try
                            {
                                if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn44.Index].Value.ToString() != "")
                                && (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn68.Index].Value.ToString() != ""))
                                {
                                    this.numberTextBox.Text
                                    = Just.Get_driver_list_number((decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn70.Index].Value.ToString(), typeof(decimal))
                                                                  , (decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn68.Index].Value.ToString(), typeof(decimal)));
                                }
                                using (Dialog DialogForm = new Dialog())
                                {
                                    DialogForm._dialog_label = "Изменить водителя и организацию в соответствии с планом?";
                                    DialogForm.ShowDialog(this);
                                    if (DialogForm.DialogResult == DialogResult.OK)
                                    {
                                        this.organization_idTextBox.Text
                                            = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn68.Index].Value.ToString();
                                        this.org_nameTextBox.Text
                                            = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn69.Index].Value.ToString();
                                        this.fio_driver1TextBox.Text
                                            = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
                                        this.employee1_idTextBox.Text
                                            = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();

                                    }
                                }
                            }
                            catch(ApplicationException Appe)
                            {
                               
                                this.organization_idTextBox.Text = "";
                                this.org_nameTextBox.Text = "";
                                this.fio_driver1TextBox.Text = "";
                                this.employee1_idTextBox.Text = "";

                            }


                        }
                    }
                    catch { }
                }
            }
        }

        private void button_fuel_type_Click(object sender, EventArgs e)
        {
            using (Fuel_type Fuel_typeForm = new Fuel_type())
            {
                Fuel_typeForm.ShowDialog(this);
                if (Fuel_typeForm.DialogResult == DialogResult.OK)
                {
                    this.fuel_type_nameTextBox.Text = Fuel_typeForm.Fuel_type_short_name;
                    this.fuel_type_idTextBox.Text = Fuel_typeForm.Fuel_type_id;
                    this.fuel_normTextBox.Text = Fuel_typeForm.Fuel_type_norm;
                }
            }
        }

        private void button_driver1_Click(object sender, EventArgs e)
        {
            using (Employee EmployeeForm = new Employee())
            {
                EmployeeForm.ShowDialog(this);
                if (EmployeeForm.DialogResult == DialogResult.OK)
                {
                    this.employee1_idTextBox.Text = EmployeeForm.Employee_id;
                    this.fio_driver1TextBox.Text = EmployeeForm.Employee_short_fio;
                }
            }
        }

        private void button_driver2_Click(object sender, EventArgs e)
        {
            using (Employee EmployeeForm = new Employee())
            {
                EmployeeForm.ShowDialog(this);
                if (EmployeeForm.DialogResult == DialogResult.OK)
                {
                    this.employee2_idTextBox.Text = EmployeeForm.Employee_id;
                    this.fio_driver2TextBox.Text = EmployeeForm.Employee_fio;
                }
            }
        }
        //Функция проверяет элементы на правильность заполнения
        private bool Check_Items()
        {
            bool v_is_counted = true;

            v_is_counted &= Is_Org_Name_Valid();
            if (Is_Org_Name_Valid())
            {
                this.Org_name_errorProvider.SetError(this.org_nameTextBox, "");
                this.org_nameTextBox.BackColor
                    = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            }
            else
            {
                this.Org_name_errorProvider.SetError(this.org_nameTextBox, "Необходимо ввести 'Организацию'");
                this.org_nameTextBox.BackColor
                    = Color.Red;
            }
            //Проверим элементы на выполнение условий
            v_is_counted &= Is_State_Number_Valid();
            if (Is_State_Number_Valid())
            {
                this.State_Number_errorProvider.SetError(this.state_numberTextBox, "");
                this.state_numberTextBox.BackColor
                    = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            }
            else
            {
                this.State_Number_errorProvider.SetError(this.state_numberTextBox, "Необходимо ввести '№ СТП'");
                this.state_numberTextBox.BackColor
                    = Color.Red;
            }
            v_is_counted &= Is_Fio_Driver1_Valid();
            if (Is_Fio_Driver1_Valid())
            {
                this.Fio_Driver1_errorProvider.SetError(this.fio_driver1TextBox, "");
                this.fio_driver1TextBox.BackColor
                    = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            }
            else
            {
                this.Fio_Driver1_errorProvider.SetError(this.fio_driver1TextBox, "Необходимо ввести 'Водителя'");
                this.fio_driver1TextBox.BackColor
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
                this.dateTimePicker1.ForeColor
                    = Color.Black;
                //this.fact_start_duty_time_visible_textBox.ForeColor
                //    = Color.Black;
                this.dateTimePicker2.ForeColor
                    = Color.Black;
                //this.fact_end_duty_time_visible_textBox.ForeColor
                //    = Color.Black;
                this.Datetime_duty_errorProvider.SetError(this.dateTimePicker2, "");

            }
            else
            {
                this.dateTimePicker1.ForeColor
                    = Color.Red;
                //this.fact_start_duty_time_visible_textBox.ForeColor
                //    = Color.Red;
                this.dateTimePicker2.ForeColor
                    = Color.Red;
                //this.fact_end_duty_time_visible_textBox.ForeColor
                //    = Color.Red;
                this.Datetime_duty_errorProvider.SetError(this.dateTimePicker2, "Проверьте дату");

            }


            return v_is_counted;
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
                this.utfVDRV_TRAILERDataGridView.EndEdit();
                //Пройдем по прицепам и найдем показатели расходов

                //Энергоустановка
                v_power_trailer_consumption =
                    Trailer_Consumption_Count(Const.Power_trailer_id);
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
                v_consumption_wo_addtn_exps = Convert.ToInt16(((v_run * v_fuel_norm) / 100).ToString("0"), 10);
                //Остаток топлива при въезде без прицепов и механизмов
                v_fuel_end_left_wo_addtn_exps =
                    (v_fuel_start_left + v_fuel_gived)
                    - v_fuel_return
                    - v_consumption_wo_addtn_exps;
                v_fuel_end_left_with_addtn_exps =
                    v_fuel_end_left_wo_addtn_exps
                    - v_power_trailer_consumption;

                v_consumption = v_consumption_wo_addtn_exps + v_power_trailer_consumption;
                //Если новый пробег не равен старому, мы должны сохранить старый пробег
                if ((v_run.ToString() != _start_run) && (_start_run != ""))
                {
                    this.last_runtextBox.Text = _start_run;

                }
                else
                {
                    if ((this.edit_statetextBox.Text == "E") && (_start_run != ""))
                    {
                        this.last_runtextBox.Text = "0";
                    }
                }
                //Если изменилась дата выхода - запишем старую дату для корректировки отчета
                if ((_driver_list_date_created != "")
                    && (_driver_list_date_created != null))
                {

                    this.last_date_createdtextBox.Text =
                        _driver_list_date_created;

                }
                else
                {
                    this.last_date_createdtextBox.Text = "";
                }

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
                    this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = true;
                }
                else
                {
                    Ok_Toggle(false);
                    this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = false;
                }
            }
            catch (Exception Appe)
            {
                MessageBox.Show("Указаны некорректные значения показаний или расходов топлива");
                MessageBox.Show(Appe.Message);
                Ok_Toggle(false);
                this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = false;
            }
        }


        private void driver_list_state_nameComboBox_SelectedValueChanged(object sender, EventArgs e)
        {
            if (this.driver_list_state_nameComboBox.Text == "Открыт")
            {
                this.driver_list_state_idTextBox.Text = Const.Opened_driver_list_state_id.ToString();
            }
            if (this.driver_list_state_nameComboBox.Text == "Закрыт")
            {
                this.driver_list_state_idTextBox.Text = Const.Closed_driver_list_state_id.ToString();
            }
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            if (_is_valid == false)
            {
                this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem_Click(sender, e);
            }
        }



        private bool Is_Org_Name_Valid()
        {
            bool v_result = false;

            if (this.org_nameTextBox.Text.Length != 0)
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

        private bool Is_Fio_Driver1_Valid()
        {
            bool v_result = false;

            if (this.fio_driver1TextBox.Text.Length != 0)
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

        private bool Is_State_Number_Valid()
        {
            bool v_result = false;

            if (this.state_numberTextBox.Text.Length != 0)
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
                v_fact_start_duty = (DateTime)Convert.ChangeType(this.dateTimePicker1.Text, typeof(DateTime));
                v_fact_end_duty = (DateTime)Convert.ChangeType(this.dateTimePicker2.Text, typeof(DateTime));
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
        private void Ok_Toggle(bool v_result)
        {
            if (v_result)
            { this.button_ok.Enabled = true; }
            else
            { this.button_ok.Enabled = false; }
        }
        //Функция подсчета прицепов и механизмов
        int Trailer_Consumption_Count(byte p_trailer_type)
        {
            int v_return_value = 0;
            int v_before_index = 0;

            v_before_index = this.utfVDRV_TRAILERDataGridView.CurrentRow.Index;
            //this.utfVDRV_TRAILERDataGridView.CurrentRow.Selected = false;
            //this.utfVDRV_TRAILERDataGridView.Rows[0].Selected = true;
            for (int i = 0; i <= this.utfVDRV_TRAILERDataGridView.Rows.Count - 2; i++)
            {
                this.utfVDRV_TRAILERDataGridView.Rows[i].Selected = true;
                if (p_trailer_type == Const.Power_trailer_id)
                {
                    if (this.utfVDRV_TRAILERDataGridView.Rows[i].Cells[dataGridViewTextBoxColumn19.Index].Value.ToString()
                        == Const.Power_trailer)
                    {
                        try
                        {
                            if (this.utfVDRV_TRAILERDataGridView.Rows[i].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() != "")
                            {
                                v_return_value = (int)Convert.ChangeType(this.utfVDRV_TRAILERDataGridView.Rows[i].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString(), typeof(int));
                            }
                        }
                        catch
                        {
                            MessageBox.Show("Указан неверный формат моточасов 'Энергоустановки'");
                        }
                    }
                }
                else
                {
                    v_return_value = 0;
                }
            }
            this.utfVDRV_TRAILERDataGridView.Rows[v_before_index].Selected = true;
            return v_return_value;
        }



        void NumberTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Date_createdDateTimePickerValueChanged(object sender, EventArgs e)
        {
            //При смене даты создания, попробуем проверить водителя по плану
            //и проверить даты выхода и въезда
            try
            {
                if ((this.car_idTextBox.Text != "")
                    && (this.date_createdDateTimePicker.Text != ""))
                {
                    this.p_car_idToolStripTextBox.Text
                        = this.car_idTextBox.Text;
                    this.p_date_createdToolStripTextBox.Text
                        = this.date_createdDateTimePicker.Text;
                    //Загрузим водителя по плану
                    try
                    {
                        this.uspVDRV_DRIVER_PLAN_Select_DriverByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_Select_DriverById, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_createdToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));

                    }
                    catch (System.Exception ex)
                    {
                        System.Windows.Forms.MessageBox.Show(ex.Message);
                    }

                    //MessageBox.Show(this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString());
                    try
                    {
                        this.fio_driver1TextBox.Text
                            = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
                        this.employee1_idTextBox.Text
                            = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();

                    }
                    catch
                    {
                        this.fio_driver1TextBox.Text = "";
                        this.employee1_idTextBox.Text = "";
                    }


                }
            }
            catch { }
            //Пробуем обновить значения дат
            try
            {
                this.dateTimePicker1.Text =
                    this.date_createdDateTimePicker.Text.Substring(0, 10) +
                    this.dateTimePicker1.Text.Substring(10, 6)
                    ;

                this.dateTimePicker2.Text =
                    this.date_createdDateTimePicker.Text.Substring(0, 10) +
                    this.dateTimePicker2.Text.Substring(10, 6)
                    ;

            }
            catch { }
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        //Смена значенией полей означает валидность формы в false
        void Driver_list_type_nameTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Org_nameTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void State_numberTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Car_mark_model_nameTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Fuel_type_nameTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Fuel_expTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Fio_driver1TextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void Fio_driver2TextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        void DateTimePicker1ValueChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void Speedometer_start_indctnTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void Fuel_start_leftTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void DateTimePicker2ValueChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void Speedometer_end_indctnTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void Fuel_end_leftTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void Fuel_givedTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void RunTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void Fuel_consumptionTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        void Fuel_returnTextBoxTextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;

        }

        void UtfVDRV_TRAILERDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
            this.utfVDRV_DRIVER_LISTBindingNavigatorSaveItem.Enabled = _is_valid;
        }

        private void printDocument1_PrintPage(object sender, System.Drawing.Printing.PrintPageEventArgs e)
        {
        }

        private void printToolStripButton_Click(object sender, EventArgs e)
        {//Напечатаем в зависимости от типа формы путевку
            
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
                v_date = this.date_createdDateTimePicker.Text.Substring(0,2);
            }
            if (this.date_createdDateTimePicker.Text != "")
            {
                v_datetime = this.date_createdDateTimePicker.Text;
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
            if (this.org_nameTextBox.Text != "")
            {
                v_org_wo_address = "ООО " + @"""" + this.org_nameTextBox.Text + @"""";
            }
            if (this.car_mark_model_nameTextBox.Text != "")
            {
                v_car_mark_model = this.car_mark_model_nameTextBox.Text;
            }
            if (this.state_numberTextBox.Text != "")
            {
                v_state_number = this.state_numberTextBox.Text;
            }
            if (this.fio_driver1TextBox.Text != "")
            {
                v_driver_fio = this.fio_driver1TextBox.Text;
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
            if (this.dateTimePicker1.Text != "")
            {
                v_fact_start_duty_time = this.dateTimePicker1.Text.Substring(11, 5);
            }
            if ((this.dateTimePicker2.Text != "")
                && (this.dateTimePicker2.Text != this.dateTimePicker1.Text))
            {
                v_fact_end_duty_time = this.dateTimePicker2.Text.Substring(11, 5);
            }
            if (this.fuel_givedTextBox.Text != "")
            {
                v_fuel_gived = this.fuel_givedTextBox.Text;
            }

          //  if (this.mechcomboBox.Text != "")
          //  {
          //      v_mech_fio = this.mechcomboBox.Text;
         //   }


          //  if (this.addtnl_mechcomboBox.Text != "")
          //  {
          //      v_adtnl_mech_fio = this.addtnl_mechcomboBox.Text;
           // }

            if (this.fuel_type_nameTextBox.Text != "")
            {
                v_fuel_type_sname = this.fuel_type_nameTextBox.Text;
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
                                                        , ""//v_fact_end_duty_time
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
                                                        , v_datetime
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
                                                        , ""//v_fact_end_duty_time
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
           // MessageBox.Show(Application.StartupPath);
            this.backgroundWorker1.RunWorkerAsync();

        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
          //  Printfile.Form_gs_print(Application.StartupPath + "\\" + _filled_file, this.Printer_spool, this.Printer_device); 
            Printfile.Form_print(this.Ar_path, _filled_file, this.Printer_name);
        }

    }
}
