using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Angel_to_001
{
    public partial class Car_detail : Form
    {
        public string _username;

        //Принимаемые значения
        //Переменная валидности формы
        private bool _is_valid = true;
        public string _car_id;
        public string _state_number;
        public string _last_speedometer_idctn;
        public string _speedometer_idctn;
        public string _begin_mntnc_date;
        public string _car_type_id;
        public string _car_type_sname;
        public string _car_state_id;
        public string _car_state_sname;
        public string _car_mark_id;
        public string _car_mark_sname;
        public string _car_model_id;
        public string _car_model_sname;
        public string _fuel_type_id;
        public string _fuel_type_sname;
        public string _car_kind_id;
        public string _car_kind_sname;
        public string _fuel_norm;
        public string _last_begin_run;
        public string _begin_run;
        public string _run;
        public string _speedometer_start_indctn;
        public string _speedometer_end_indctn;
        public string _condition_id;
        public string _fuel_start_left;
        public string _fuel_end_left;
        public string _employee_id;
        public string _last_ts_verified;
        public string _card_number;
        public string _organization_id;
        public string _organization_sname;
        public string _driver_list_type_id;
        public string _driver_list_type_sname;
        public string _car_passport;
        //Переменная текущего состояния формы
        //1 - Вставка, 2 - Редактирование, 3 - Удаление
        public byte _form_state;

        //Отдаваемые значения
        public string Car_id
        {
            get { return this.idTextBox.Text; }
        }
        public string State_number
        {
            get { return this.state_numberTextBox.Text; }
        }
        public string Last_speedometer_idctn
        {
            get { return this.last_speedometer_idctnTextBox.Text; }
        }
        public string Speedometer_idctn
        {
            get { return this.speedometer_idctnTextBox.Text; }
        }
        public string Begin_mntnc_date
        {
            get { return this.begin_mntnc_dateDateTimePicker.Text; }
        }
        public string Car_type_id
        {
            get { return this.car_type_idTextBox.Text; }
        }
        public string Car_type_sname
        {
            get { return this.car_type_snameTextBox.Text; }
        }
        public string Car_state_id
        {
            get { return this.car_state_idTextBox.Text; }
        }
        public string Car_state_sname
        {
            get { return this.car_state_snameTextBox.Text; }
        }
        public string Car_mark_id
        {
            get { return this.car_mark_idTextBox.Text; }
        }
        public string Car_mark_sname
        {
            get { return this.car_mark_snameTextBox.Text; }
        }
        public string Car_model_id
        {
            get { return this.car_model_idTextBox.Text; }
        }
        public string Car_model_sname
        {
            get { return this.car_model_snameTextBox.Text; }
        }
        public string Fuel_type_id
        {
            get { return this.fuel_type_idTextBox.Text; }
        }
        public string Fuel_type_sname
        {
            get { return this.fuel_type_snameTextBox.Text; }
        }
        public string Car_kind_id
        {
            get { return this.car_kind_idTextBox.Text; }
        }
        public string Car_kind_sname
        {
            get { return this.car_kind_snameTextBox.Text; }
        }
        public string Fuel_norm
        {
            get { return this.fuel_normTextBox.Text; }
        }
        public string Last_begin_run
        {
            get { return this.last_begin_runTextBox.Text; }
        }
        public string Begin_run
        {
            get { return this.begin_runTextBox.Text; }
        }
        public string Run
        {
            get { return this.runTextBox.Text; }
        }
        public string Speedometer_start_indctn
        {
            get { return this.speedometer_start_indctnTextBox.Text; }
        }
        public string Speedometer_end_indctn
        {
            get { return this.speedometer_end_indctnTextBox.Text; }
        }
        public string Condition_id
        {
            get { return this.condition_idTextBox.Text; }
        }
        public string Fuel_start_left
        {
            get { return this.fuel_start_leftTextBox.Text; }
        }
        public string Fuel_end_left
        {
            get { return this.fuel_end_leftTextBox.Text; }
        }
        public string Employee_id
        {
            get { return this.employee_idTextBox.Text; }
        }
        public string Last_ts_verified
        {
            get { return this.last_ts_verifiedTextBox.Text; }
        }
        public string Card_number
        {
            get { return this.card_numberTextBox.Text; }
        }
        public string Organization_id
        {
            get { return this.organization_idTextBox.Text; }
        }
        public string Organization_sname
        {
            get { return this.organization_snameTextBox.Text; }
        }
        public string Driver_list_type_id
        {
            get { return this.driver_list_type_idTextBox.Text; }
        }
        public string Driver_list_type_sname
        {
            get { return this.driver_list_type_snameTextBox.Text; }
        }
        public string Car_passport
        {
            get { return this.car_passportTextBox.Text; }
        }
        public Car_detail()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void uspVCAR_CAR_SelectByIdBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            Nullable<decimal> v_id = new Nullable<decimal>();
            Nullable<decimal> v_condition_id = new Nullable<decimal>();
            Nullable<decimal> v_last_speedomter_idctn = new Nullable<decimal>();
            Nullable<decimal> v_speedomter_idctn = new Nullable<decimal>();
            Nullable<decimal> v_last_begin_run = new Nullable<decimal>();
            Nullable<decimal> v_begin_run = new Nullable<decimal>();
            Nullable<decimal> v_run = new Nullable<decimal>();
            Nullable<decimal> v_speedometer_start_indctn = new Nullable<decimal>();
            Nullable<decimal> v_speedometer_end_indctn = new Nullable<decimal>();
            Nullable<decimal> v_fuel_start_left = new Nullable<decimal>();
            Nullable<decimal> v_fuel_end_left = new Nullable<decimal>();
            Nullable<decimal> v_employee_id = new Nullable<decimal>();
            Nullable<decimal> v_organization_id = new Nullable<decimal>();
            Nullable<decimal> v_driver_list_type_id = new Nullable<decimal>();
            Nullable<decimal> v_car_type_id = new Nullable<decimal>();
            Nullable<decimal> v_car_state_id = new Nullable<decimal>();
            Nullable<decimal> v_car_mark_id = new Nullable<decimal>();
            Nullable<decimal> v_car_model_id = new Nullable<decimal>();
            Nullable<DateTime> v_begin_mntnc_date = new Nullable<DateTime>();
            Nullable<decimal> v_fuel_type_id = new Nullable<decimal>();
            Nullable<decimal> v_car_kind_id = new Nullable<decimal>();
            try
            {
                if (this.idTextBox.Text != "")
                {
                    v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
                }
                if (this.condition_idTextBox.Text != "")
                {
                    v_condition_id = (decimal)Convert.ChangeType(this.condition_idTextBox.Text, typeof(decimal));
                }

                if (this.last_speedometer_idctnTextBox.Text != "")
                {
                    v_last_speedomter_idctn = (decimal)Convert.ChangeType(this.last_speedometer_idctnTextBox.Text, typeof(decimal));
                }

                if (this.speedometer_idctnTextBox.Text != "")
                {
                    v_speedomter_idctn = (decimal)Convert.ChangeType(this.speedometer_idctnTextBox.Text, typeof(decimal));
                }

                if (this.last_begin_runTextBox.Text != "")
                {
                    v_last_begin_run = (decimal)Convert.ChangeType(this.last_begin_runTextBox.Text, typeof(decimal));
                }

                if (this.begin_runTextBox.Text != "")
                {
                    v_begin_run = (decimal)Convert.ChangeType(this.begin_runTextBox.Text, typeof(decimal));
                }

                if (this.runTextBox.Text != "")
                {
                    v_run = (decimal)Convert.ChangeType(this.runTextBox.Text, typeof(decimal));
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

                if (this.employee_idTextBox.Text != "")
                {
                    v_employee_id = (decimal)Convert.ChangeType(this.employee_idTextBox.Text, typeof(decimal));
                }

                if (this.organization_idTextBox.Text != "")
                {
                    v_organization_id = (decimal)Convert.ChangeType(this.organization_idTextBox.Text, typeof(decimal));
                }

                if (this.driver_list_type_idTextBox.Text != "")
                {
                    v_driver_list_type_id = (decimal)Convert.ChangeType(this.driver_list_type_idTextBox.Text, typeof(decimal));
                }

                if (this.car_type_idTextBox.Text != "")
                {
                    v_car_type_id = (decimal)Convert.ChangeType(this.car_type_idTextBox.Text, typeof(decimal));
                }

                if (this.car_state_idTextBox.Text != "")
                {
                    v_car_state_id = (decimal)Convert.ChangeType(this.car_state_idTextBox.Text, typeof(decimal));
                }

                if (this.car_mark_idTextBox.Text != "")
                {
                    v_car_mark_id = (decimal)Convert.ChangeType(this.car_mark_idTextBox.Text, typeof(decimal));
                }
                if (this.car_model_idTextBox.Text != "")
                {
                    v_car_model_id = (decimal)Convert.ChangeType(this.car_model_idTextBox.Text, typeof(decimal));
                }

                if (this.begin_mntnc_dateDateTimePicker.Text != "")
                {
                    v_begin_mntnc_date = (DateTime)Convert.ChangeType(this.begin_mntnc_dateDateTimePicker.Text, typeof(DateTime));
                }
                if (this.fuel_type_idTextBox.Text != "")
                {
                    v_fuel_type_id = (decimal)Convert.ChangeType(this.fuel_type_idTextBox.Text, typeof(decimal));
                }
                if (this.car_kind_idTextBox.Text != "")
                {
                    v_car_kind_id = (decimal)Convert.ChangeType(this.car_kind_idTextBox.Text, typeof(decimal));
                }
                this.Validate();
                this.uspVCAR_CAR_SelectByIdBindingSource.EndEdit();
                if (this._form_state == 3)
                {
                    this.uspVCAR_CAR_SelectByIdTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))), "-", _username);
                }
                else
                {
                    this.uspVCAR_CAR_SelectByIdTableAdapter.Update(ref v_id
                                                                  , this.state_numberTextBox.Text
                                                                  , v_last_speedomter_idctn
                                                                  , v_speedomter_idctn
                                                                  , v_car_type_id
                                                                  , v_car_state_id
                                                                  , v_car_mark_id
                                                                  , v_car_model_id
                                                                  , v_begin_mntnc_date
                                                                  , v_fuel_type_id
                                                                  , v_car_kind_id
                                                                  , v_last_begin_run
                                                                  , v_begin_run
                                                                  , v_run
                                                                  , v_speedometer_start_indctn
                                                                  , v_speedometer_end_indctn
                                                                  , v_fuel_start_left
                                                                  , v_fuel_end_left
                                                                  , ref v_condition_id
                                                                  , v_employee_id
                                                                  , this.card_numberTextBox.Text
                                                                  , v_organization_id
                                                                  , v_driver_list_type_id
                                                                  , this.car_passportTextBox.Text
                                                                  , this.sys_commentTextBox.Text
                                                                  , _username);

                    if (v_id.ToString() != "")
                    {
                        this.idTextBox.Text = v_id.ToString();
                    }
                    if (v_condition_id.ToString() != "")
                    {
                        this.condition_idTextBox.Text = v_condition_id.ToString();
                    }
                }
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

                    case 547:
                        MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись! ");
                        break;

                    case 2601:
                        MessageBox.Show("Такой '№ автомобиля' уже существует");
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

        private void fillToolStripButton_Click(object sender, EventArgs e)
        {
            //try
            //{
            //    this.uspVCAR_CAR_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001_Car_SelectById.uspVCAR_CAR_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_idToolStripTextBox.Text, typeof(decimal))))));
            //}
            //catch (System.Exception ex)
            //{
            //    System.Windows.Forms.MessageBox.Show(ex.Message);
            //}

        }

        private void Car_detail_Load(object sender, EventArgs e)
        {

            //Выключим кнопку при работе в вставке и редактировании
            if ((_form_state == 1) || (_form_state == 2))
            {
                this.button_ok.Enabled = false;
            }



            if ((_car_id != "")
                && (_car_id != null))
            {
                this.idTextBox.Text = _car_id;
            }

            if ((_state_number != "")
                 && (_state_number != null))
            {
                this.state_numberTextBox.Text = _state_number;
            }

            if ((_last_speedometer_idctn != "")
                 && (_last_speedometer_idctn != null))
            {
                this.last_speedometer_idctnTextBox.Text = _last_speedometer_idctn;
            }

            if ((_speedometer_idctn != "")
                && (_speedometer_idctn != null))
            {
                this.speedometer_idctnTextBox.Text = _speedometer_idctn;
            }

            if ((_begin_mntnc_date != "")
                 && (_begin_mntnc_date != null))
            {
                this.begin_mntnc_dateDateTimePicker.Text = _begin_mntnc_date;
            }
            if ((_car_type_id != "")
                 && (_car_type_id != null))
            {
                this.car_type_idTextBox.Text = _car_type_id;
            }
            if ((_car_type_sname != "")
                 && (_car_type_sname != null))
            {
                this.car_type_snameTextBox.Text = _car_type_sname;
            }
            if ((_car_state_id != "")
                 && (_car_state_id != null))
            {
                this.car_state_idTextBox.Text = _car_state_id;
            }

            if ((_car_state_sname != "")
                 && (_car_state_sname != null))
            {
                this.car_state_snameTextBox.Text = _car_state_sname;
            }


            if ((_car_mark_id != "")
                 && (_car_mark_id != null))
            {
                this.car_mark_idTextBox.Text = _car_mark_id;
            }

            if ((_car_mark_sname != "")
                 && (_car_mark_sname != null))
            {
                this.car_mark_snameTextBox.Text = _car_mark_sname;
            }

            if ((_car_model_id != "")
                 && (_car_model_id != null))
            {
                this.car_model_idTextBox.Text = _car_model_id;
            }

            if ((_car_model_sname != "")
                 && (_car_model_sname != null))
            {
                this.car_model_snameTextBox.Text = _car_model_sname;
            }

            if ((_fuel_type_id != "")
               && (_fuel_type_id != null))
            {
                this.fuel_type_idTextBox.Text = _fuel_type_id;
            }

            if ((_fuel_type_sname != "")
               && (_fuel_type_sname != null))
            {
                this.fuel_type_snameTextBox.Text = _fuel_type_sname;
            }


            if ((_car_kind_id != "")
               && (_car_kind_id != null))
            {
                this.car_kind_idTextBox.Text = _car_kind_id;
            }

            if ((_car_kind_sname != "")
               && (_car_kind_sname != null))
            {
                this.car_kind_snameTextBox.Text = _car_kind_sname;
            }

            if ((_fuel_norm != "")
                && (_fuel_norm != null))
            {
                this.fuel_normTextBox.Text = _fuel_norm;
            }

            if ((_last_begin_run != "")
               && (_last_begin_run != null))
            {
                this.last_begin_runTextBox.Text = _last_begin_run;
            }

            if ((_begin_run != "")
               && (_begin_run != null))
            {
                this.begin_runTextBox.Text = _begin_run;
            }

            if ((_run != "")
               && (_run != null))
            {
                this.runTextBox.Text = _run;
            }

            if ((_speedometer_start_indctn != "")
                && (_speedometer_start_indctn != null))
            {
                this.speedometer_start_indctnTextBox.Text = _speedometer_start_indctn;
            }


            if ((_speedometer_end_indctn != "")
                 && (_speedometer_end_indctn != null))
            {
                this.speedometer_end_indctnTextBox.Text = _speedometer_end_indctn;
            }


            if ((_condition_id != "")
                && (_condition_id != null))
            {
                this.condition_idTextBox.Text = _condition_id;
            }

            if ((_fuel_start_left != "")
                && (_fuel_start_left != null))
            {
                this.fuel_start_leftTextBox.Text = _fuel_start_left;
            }


            if ((_fuel_end_left != "")
                && (_fuel_end_left != null))
            {
                this.fuel_end_leftTextBox.Text = _fuel_end_left;
            }

            if ((_employee_id != "")
                && (_employee_id != null))
            {
                this.employee_idTextBox.Text = _employee_id;
            }


            if ((_last_ts_verified != "")
                 && (_last_ts_verified != null))
            {
                this.last_ts_verifiedTextBox.Text = _last_ts_verified;
            }

            if ((_card_number != "")
                && (_card_number != null))
            {
                this.card_numberTextBox.Text = _card_number;
            }


            if ((_organization_id != "")
                && (_organization_id != null))
            {
                this.organization_idTextBox.Text = _organization_id;
            }

            if ((_organization_sname != "")
                && (_organization_sname != null))
            {
                this.organization_snameTextBox.Text = _organization_sname;
            }


            if ((_driver_list_type_id != "")
                && (_driver_list_type_id != null))
            {
                this.driver_list_type_idTextBox.Text = _driver_list_type_id;
            }

            if ((_driver_list_type_sname != "")
                && (_driver_list_type_sname != null))
            {
                this.driver_list_type_snameTextBox.Text = _driver_list_type_sname;
            }

            if ((_car_passport != "")
            && (_car_passport != null))
            {
                this.car_passportTextBox.Text = _car_passport;
            }

            this.Text = this.Text + " автомобиля";

            if (_form_state == 3)
            {
                this.BackColor = Color.Red;
                this.uspVCAR_CAR_SelectByIdBindingNavigatorSaveItem.Enabled = false;
                this.button_ok.Enabled = true;
            }
            else
            {
                this.BackColor = System.Drawing.SystemColors.Control;
            }

        }

        private void button_organization_Click(object sender, EventArgs e)
        {
            using (Organization OrganizationForm = new Organization())
            {
                OrganizationForm.ShowDialog(this);
                if (OrganizationForm.DialogResult == DialogResult.OK)
                {
                    this.organization_snameTextBox.Text = OrganizationForm.Org_sname;
                    this.organization_idTextBox.Text = OrganizationForm.Org_id;
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
                    this.fuel_type_snameTextBox.Text = Fuel_typeForm.Fuel_type_short_name;
                    this.fuel_type_idTextBox.Text = Fuel_typeForm.Fuel_type_id;
                }
            }
        }

        private void button_car_mark_Click(object sender, EventArgs e)
        {
            using (Car_mark Car_markForm = new Car_mark())
            {
                Car_markForm.ShowDialog(this);
                if (Car_markForm.DialogResult == DialogResult.OK)
                {
                    this.car_mark_snameTextBox.Text = Car_markForm.Mark_short_name;
                    this.car_mark_idTextBox.Text = Car_markForm.Mark_id;
                }
            }
        }

        private void button_car_model_Click(object sender, EventArgs e)
        {
            using (Car_model Car_modelForm = new Car_model())
            {
                Car_modelForm.Mark_short_name = this.car_mark_snameTextBox.Text;
                Car_modelForm.Mark_id = this.car_mark_idTextBox.Text;
                Car_modelForm.ShowDialog(this);
                if (Car_modelForm.DialogResult == DialogResult.OK)
                {
                    this.car_model_snameTextBox.Text = Car_modelForm.Model_short_name;
                    this.car_model_idTextBox.Text = Car_modelForm.Model_id;
                }
            }
        }

        private void button_car_kind_Click(object sender, EventArgs e)
        {
            using (Car_kind_chooser Car_kind_chooserForm = new Car_kind_chooser())
            {
                Car_kind_chooserForm.ShowDialog(this);
                if (Car_kind_chooserForm.DialogResult == DialogResult.OK)
                {
                    this.car_kind_snameTextBox.Text = Car_kind_chooserForm.Car_kind_short_name;
                    this.car_kind_idTextBox.Text = Car_kind_chooserForm.Car_kind_id;
                }
            }
        }

        private void button_car_type_Click(object sender, EventArgs e)
        {
            using (Car_type_chooser Car_type_chooserForm = new Car_type_chooser())
            {
                Car_type_chooserForm.ShowDialog(this);
                if (Car_type_chooserForm.DialogResult == DialogResult.OK)
                {
                    this.car_type_snameTextBox.Text = Car_type_chooserForm.Car_type_short_name;
                    this.car_type_idTextBox.Text = Car_type_chooserForm.Car_type_id;
                }
            }
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

        private void button_driver_list_type_Click(object sender, EventArgs e)
        {
            using (Driver_list_type Driver_list_typeForm = new Driver_list_type())
            {
                Driver_list_typeForm.ShowDialog(this);
                if (Driver_list_typeForm.DialogResult == DialogResult.OK)
                {
                    this.driver_list_type_snameTextBox.Text = Driver_list_typeForm.Driver_list_type_sname;
                    this.driver_list_type_idTextBox.Text = Driver_list_typeForm.Driver_list_type_id;
                }
            }
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            if (_is_valid == false)
            {
                this.uspVCAR_CAR_SelectByIdBindingNavigatorSaveItem_Click(sender, e);
            }
        }

       /* private bool Check_Items()
        {
            bool v_is_valid = true;

            v_is_valid &= Is_Car_Kind_Name_Valid();
            if (Is_Car_Kind_Name_Valid())
            {
                this.Car_kind_sname_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Car_kind_sname_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Вид'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Style.BackColor
                    = Color.Red;
            }

            v_is_valid &= Is_Begin_Run_Valid();
            if (Is_Begin_Run_Valid())
            {
                this.Begin_run_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Begin_run_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 15);
                this.Begin_run_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Пробег'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Style.BackColor
                    = Color.Red;
            }

            v_is_valid &= Is_State_Number_Valid();
            if (Is_State_Number_Valid())
            {
                this.State_number_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.State_number_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
                this.State_number_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести '№ СТП'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
                    = Color.Red;
            }

            v_is_valid &= Is_Begin_Idctn_Valid();
            if (Is_Begin_Idctn_Valid())
            {
                this.Begin_idctn_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Begin_idctn_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Показание'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Style.BackColor
                    = Color.Red;
            }

            v_is_valid &= Is_Begin_Mntnc_Date_Valid();
            if (Is_Begin_Mntnc_Date_Valid())
            {
                this.Begin_mntnc_date_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Begin_mntnc_date_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 15);
                this.Begin_mntnc_date_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Дату начала эксплуатации'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Style.BackColor
                    = Color.Red;
            }

            v_is_valid &= Is_Car_Type_Valid();
            if (Is_Car_Type_Valid())
            {
                this.Car_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Car_type_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
                this.Car_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Тип'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Style.BackColor
                    = Color.Red;
            }

            v_is_valid &= Is_Car_Mark_Valid();
            if (Is_Car_Mark_Valid())
            {
                this.Car_mark_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Car_mark_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Марку'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Style.BackColor
                    = Color.Red;
            }


            v_is_valid &= Is_Car_Model_Valid();
            if (Is_Car_Model_Valid())
            {
                this.Car_model_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Car_model_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 15);
                this.Car_model_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Модель'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Style.BackColor
                    = Color.Red;
            }


            v_is_valid &= Is_Fuel_Type_Valid();
            if (Is_Fuel_Type_Valid())
            {
                this.Fuel_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Style.BackColor
                    = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
            }
            else
            {
                this.Fuel_type_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
                this.Fuel_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Тип топлива'");
                this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Style.BackColor
                    = Color.Red;
            }

            /*v_is_valid &= Is_Last_Ts_Type_Valid();
                if (Is_Last_Ts_Type_Valid())
                {
                    this.Last_ts_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                    this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Style.BackColor
                        = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
                }
                else
                {
                    //this.Last_ts_type_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
                    this.Last_ts_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести предыдущее ТО");
                    this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Style.BackColor
                        = Color.Red;
                }*/



        //    return v_is_valid;

      //  }*/

        private void car_mark_snameTextBox_TextChanged(object sender, EventArgs e)
        {
            if (this.car_mark_snameTextBox.Text != "")
            {
                this.button_car_model.Enabled = true;
            }
            else
            {
                this.button_car_model.Enabled = false;
            }
            this.Ok_Toggle(false);
            _is_valid = false;

        }

        private void organization_snameTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void state_numberTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void runTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void speedometer_end_indctnTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void begin_mntnc_dateDateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void fuel_type_snameTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void card_numberTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void driver_list_type_snameTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void car_passportTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void car_model_snameTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void car_kind_snameTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }

        private void car_type_snameTextBox_TextChanged(object sender, EventArgs e)
        {
            this.Ok_Toggle(false);
            _is_valid = false;
        }
    }
}
