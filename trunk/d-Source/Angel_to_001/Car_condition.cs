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
    public partial class Car_condition : Form
    {
        private bool _is_valid;
        public string _username;
        private string _is_old_speedometer_verfied = "";

        private string _sent_to = "N";

        Acrobat Printfile = new Acrobat();
        private string _filled_file = "";

        public string Ar_path = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Ar_path"];
        public string Printer_name = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_name"];
        public string Printer_spool = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Spool_path"];
        public string Printer_device = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Printer_device"];

        //Переменная свитч работы background
        private byte _work_switch = 1;
        private int _doc_count = 1;


        public Car_condition()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void utfVCAR_CAR_CONDITIONBindingNavigator1SaveItem1_Click(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
                this.uspVCAR_CONDITION_SelectCarBindingSource.EndEdit();
                this.uspVCAR_CONDITION_SelectFreightBindingSource.EndEdit();
                this.uspVCAR_CONDITION_SelectCarTableAdapter.Update(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar);
                this.uspVCAR_CONDITION_SelectFreightTableAdapter.Update(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight);
                Ok_Toggle(true);
            }

            catch (SqlException Sqle)
            {
                switch (Sqle.Number)
                {
                    case 515:
                        MessageBox.Show("Необходимо заполнить все обязательные поля!");
                        break;

                    case 547:
                        MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись!");
                        //MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                        //MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                        //MessageBox.Show("Источник: " + Sqle.Source.ToString());
                        this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                          , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                          , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                          , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
                        this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                              , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                              , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                              , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
                        break;


                    default:
                        MessageBox.Show("Ошибка");
                        MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                        MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                        MessageBox.Show("Источник: " + Sqle.Source.ToString());
                        break;
                }
            }
            catch (Exception Appe)
            {
            }
        }

        private void Car_condition_Load(object sender, EventArgs e)
        {
            start_dateTimePicker.Value = DateTime.Now.AddDays(-7.0);

            p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
            p_start_dateToolStripTextBox1.Text = start_dateTimePicker.Value.ToShortDateString();

            end_dateTimePicker.Value = DateTime.Now;

            p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
            p_end_dateToolStripTextBox1.Text = end_dateTimePicker.Value.ToShortDateString();

            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();

            //this.addtnl_ts_car.Visible = false;
            //this.addtnl_ts_freight.Visible = false;


            try
            {
                this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
                this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                      , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                      , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                      , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.utfVCAR_CAR_CONDITIONBindingNavigator1SaveItem1_Click(sender, e);
        }


        private void uspVCAR_CONDITION_SelectFreightDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {


            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                this.uspVCAR_CONDITION_SelectCarDataGridView.BeginEdit(false);

                this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn39.Index].Value
                    = "E";

                if (this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn14")
                {
                    using (Employee EmployeeForm = new Employee())
                    {
                        EmployeeForm.ShowDialog(this);
                        if (EmployeeForm.DialogResult == DialogResult.OK)
                        {

                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentCell.Value
                                = EmployeeForm.Employee_fio;
                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                                = EmployeeForm.Employee_id;
                            Ok_Toggle(false);
                        }
                    }
                }


            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                this.uspVCAR_CONDITION_SelectFreightDataGridView.BeginEdit(false);


                this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn40.Index].Value
                    = "E";

                if (this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn32")
                {
                    using (Employee EmployeeForm = new Employee())
                    {
                        EmployeeForm.ShowDialog(this);
                        if (EmployeeForm.DialogResult == DialogResult.OK)
                        {

                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentCell.Value
                                = EmployeeForm.Employee_fio;
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value
                                = EmployeeForm.Employee_id;
                            Ok_Toggle(false);
                        }
                    }
                }

            }

        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                try
                {
                    this.uspVCAR_CONDITION_SelectCarBindingSource.RemoveCurrent();
                }
                catch { }
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                try
                {
                    this.uspVCAR_CONDITION_SelectFreightBindingSource.RemoveCurrent();
                }
                catch { }
            }
            Ok_Toggle(false);
        }

        private void uspVCAR_CONDITION_SelectCarDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
           
        }

        private void uspVCAR_CONDITION_SelectFreightDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
           
        }

        private void uspVCAR_CONDITION_SelectCarDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            //Проставим режим перезаписи пробега
            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn39.Index].Value
                = "E";
            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn51.Index].Value
                = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value;
            Ok_Toggle(false);
        }

        private void uspVCAR_CONDITION_SelectFreightDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            //Проставим режим перезаписи пробега
            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn40.Index].Value
                = "E";
            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn52.Index].Value
                = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn36.Index].Value;
            Ok_Toggle(false);
        }

        private void send_to_ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string v_order_number = "";
            string v_ts_type_sname = "";

            _is_old_speedometer_verfied = "";



            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                if (this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString()
                    == Const.On_duty_id.ToString())
                {
                    using (Dialog DialogForm = new Dialog())
                    {
                        DialogForm._dialog_form_state = 1;
                        DialogForm._dialog_label = "У этого автомобиля не закрыт путевой лист (показание спидометра в заявке будет старым). Продолжить?";
                        DialogForm.ShowDialog(this);

                        if (DialogForm.DialogResult == DialogResult.OK)
                        {
                            _is_old_speedometer_verfied = "Y";
                        }
                        else
                        {
                            _is_old_speedometer_verfied = "N";
                        }

                    }
                }
                if ((_is_old_speedometer_verfied == "Y")
                   ||(_is_old_speedometer_verfied == ""))
                {
                    using (Dialog DialogForm = new Dialog())
                    {
                        DialogForm._dialog_form_state = 2;
                        DialogForm._dialog_label = "Отправить на ТО?";
                        DialogForm.ShowDialog(this);
                        if (DialogForm.DialogResult == DialogResult.OK)
                        {
                            _sent_to = "Y";
                            v_order_number = Get_order_number(_sent_to);

                            //using (Ts_type Ts_typeForm = new Ts_type())
                            //{

                            //Ts_typeForm._where_clause = "car_mark_id = "
                            //	+ this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn57.Index].Value.ToString()
                            //	+ " and car_model_id = "
                            //	+ this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value.ToString();
                            //Ts_typeForm.ShowDialog(this);
                            //if (Ts_typeForm.DialogResult == DialogResult.OK)
                            //{



                            //}
                            //}
                        }
                        else
                        {
                            _sent_to = "N";
                            v_order_number = Get_order_number(_sent_to);
                        }
                    }
                    using (Head_order Head_orderForm = new Head_order())
                    {
                        Head_orderForm._head_order_number = v_order_number;
                        Head_orderForm._head_order_car_id = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                        Head_orderForm._head_order_run = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
                        Head_orderForm._head_order_fuel_end_left = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn43.Index].Value.ToString();
                        Head_orderForm._head_order_state_number = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
                        Head_orderForm._head_order_car_mark_model_sname = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
                        Head_orderForm._head_order_speedometer_end_indctn = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn47.Index].Value.ToString();
                        Head_orderForm._head_order_ts_type_sname = v_ts_type_sname;
                        Head_orderForm.ShowDialog(this);
                        if (Head_orderForm.DialogResult == DialogResult.OK)
                        {
                            
                        }
                      //  this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                      //          = Const.In_repair_zone_id;
                      //  this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                      //      = Const.In_repair_zone_name;
                        /*if (this._sent_to == "Y")
                        {
                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn37.Index].Value
                                = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value;
                            v_ts_type_sname = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();

                            //this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value = DBNull.Value;
                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value = DBNull.Value;

                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.DefaultCellStyle.BackColor
                                = Color.White;
                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn53.Index].Value = 0;
                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn49.Index].Value
                                = "Y";

                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn55.Index].Value
                                = 0;
                        }*/
                        Ok_Toggle(false);
                    }

               }
              //  else
              //  {
                //    MessageBox.Show("У этого автомобиля не закрыт путевой лист. Сначала закройте путевой лист");
               // }
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
               if (this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value.ToString()
                    == Const.On_duty_id.ToString())
                {
                    using (Dialog DialogForm = new Dialog())
                    {
                        DialogForm._dialog_form_state = 1;
                        DialogForm._dialog_label = "У этого автомобиля не закрыт путевой лист (показание спидометра в заявке будет старым). Продолжить?";
                        DialogForm.ShowDialog(this);

                        if (DialogForm.DialogResult == DialogResult.OK)
                        {
                            _is_old_speedometer_verfied = "Y";
                        }
                        else
                        {
                            _is_old_speedometer_verfied = "N";
                        }

                    }
                }
                if ((_is_old_speedometer_verfied == "Y")
                   ||(_is_old_speedometer_verfied == ""))
                {
                    using (Dialog DialogForm = new Dialog())
                    {
                        DialogForm._dialog_form_state = 2;
                        DialogForm._dialog_label = "Отправить на ТО?";
                        DialogForm.ShowDialog(this);
                        if (DialogForm.DialogResult == DialogResult.OK)
                        {
                            _sent_to = "Y";
                            v_order_number = Get_order_number(_sent_to);

                            //using (Ts_type Ts_typeForm = new Ts_type())
                            //{


                            //Ts_typeForm._where_clause = "car_mark_id = "
                            //	+ this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn58.Index].Value.ToString()
                            //	+ " and car_model_id = "
                            //	+ this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn60.Index].Value.ToString();
                            //Ts_typeForm.ShowDialog(this);
                            //if (Ts_typeForm.DialogResult == DialogResult.OK)
                            //{



                            //}
                            //}
                        }
                        else
                        {
                            _sent_to = "N";
                            v_order_number = Get_order_number(_sent_to);
                        }
                    }
                    using (Head_order Head_orderForm = new Head_order())
                    {
                        Head_orderForm._head_order_number = v_order_number;
                        Head_orderForm._head_order_car_id = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
                        Head_orderForm._head_order_run = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn36.Index].Value.ToString();
                        Head_orderForm._head_order_fuel_end_left = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn44.Index].Value.ToString();
                        Head_orderForm._head_order_state_number = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
                        Head_orderForm._head_order_car_mark_model_sname = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
                        Head_orderForm._head_order_speedometer_end_indctn = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn48.Index].Value.ToString();
                        Head_orderForm._head_order_ts_type_sname = v_ts_type_sname;
                        Head_orderForm.ShowDialog(this);
                        if (Head_orderForm.DialogResult == DialogResult.OK)
                        {
                            

                        }
                       // this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value
                       //         = Const.In_repair_zone_id;
                     //  this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value
                        //    = Const.In_repair_zone_name;
                       /* if (this._sent_to == "Y")
                        {
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn38.Index].Value
                                = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value;


                            v_ts_type_sname = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();
                            //this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value = DBNull.Value;
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value = DBNull.Value;

                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.DefaultCellStyle.BackColor
                                = Color.White;
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn54.Index].Value = 0;

                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn50.Index].Value
                                = "Y";

                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn56.Index].Value
                                = 0;
                        }*/
                        Ok_Toggle(false);
                    }
                }
             //   else
            //    {
             //       MessageBox.Show("У этого автомобиля не закрыт путевой лист. Сначала закройте путевой лист");
              //  }

            }

            this.utfVCAR_CAR_CONDITIONBindingNavigator1SaveItem1_Click(sender, e);

            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn49.Index].Value
                    = "N";
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn50.Index].Value
                    = "N";
            }
            this.utfVCAR_CAR_CONDITIONBindingNavigator1SaveItem1_Click(sender, e);

            // this.Car_condition_Load(sender, e);
        }


        private void uspVCAR_CONDITION_SelectCarDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {//Проверим наличие предстоящего ТО и перепробег и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVCAR_CONDITION_SelectCarDataGridView.Columns[e.ColumnIndex].Name == "dataGridViewTextBoxColumn55")
                {
                    if (
                        (decimal)Convert.ChangeType(this.uspVCAR_CONDITION_SelectCarDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn53.Index].Value.ToString(), typeof(decimal)) > 0)
                    {
                        this.uspVCAR_CONDITION_SelectCarDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Red;
                    }
                    else
                    {
                        if ((bool)Convert.ChangeType(e.Value.ToString(), typeof(bool)))
                        {
                            this.uspVCAR_CONDITION_SelectCarDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                                = Color.Yellow;

                        }
                        else
                        {
                            this.uspVCAR_CONDITION_SelectCarDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                                = this.uspVCAR_CONDITION_SelectCarDataGridView.DefaultCellStyle.BackColor;

                        }
                    }


                }
            }
            catch (Exception Appe)
            { }

        }

        private void uspVCAR_CONDITION_SelectFreightDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие предстоящего ТО и перепробег и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Columns[e.ColumnIndex].Name == "dataGridViewTextBoxColumn56")
                {

                    if ((decimal)Convert.ChangeType(this.uspVCAR_CONDITION_SelectFreightDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn54.Index].Value.ToString(), typeof(decimal)) > 0)
                    {
                        this.uspVCAR_CONDITION_SelectFreightDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Red;
                    }
                    else
                    {
                        if ((bool)Convert.ChangeType(e.Value.ToString(), typeof(bool)))
                        {
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                                = Color.Yellow;

                        }
                        else
                        {
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                                = this.uspVCAR_CONDITION_SelectFreightDataGridView.DefaultCellStyle.BackColor;

                        }
                    }


                }
            }
            catch (Exception Appe)
            { }

        }

        private void button_find_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
                this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                      , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                      , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                      , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void uspVCAR_CONDITION_SelectCarDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                throw e.Exception;
            }
            catch (Exception Appe)
            {
                switch (Appe.Message)
                {
                    case "Input string was not in a correct format.":
                        MessageBox.Show("Неверный формат числа, укажите запятую вместо точки");
                        break;

                    default:
                        MessageBox.Show(Appe.Message);
                        break;
                }
            }
        }

        private void uspVCAR_CONDITION_SelectFreightDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                throw e.Exception;
            }
            catch (Exception Appe)
            {
                switch (Appe.Message)
                {
                    case "Input string was not in a correct format.":
                        MessageBox.Show("Неверный формат числа, укажите запятую вместо точки");
                        break;

                    default:
                        MessageBox.Show(Appe.Message);
                        break;
                }
            }
        }

        private void last_ts_typeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                using (Last_ts_type Last_ts_typeForm = new Last_ts_type())
                {

                    Last_ts_typeForm._last_ts_type_car_id
                        = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                    Last_ts_typeForm.ShowDialog(this);
                    //if (Car_markForm.DialogResult == DialogResult.OK)
                    //{

                    //    this.utfVCAR_CARDataGridView.CurrentCell.Value
                    //        = Car_markForm.Mark_short_name;
                    //    this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                    //        = Car_markForm.Mark_id;
                    //}
                }
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                using (Last_ts_type Last_ts_typeForm = new Last_ts_type())
                {
                    Last_ts_typeForm._last_ts_type_car_id
                        = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
                    Last_ts_typeForm.ShowDialog(this);
                    //if (Car_markForm.DialogResult == DialogResult.OK)
                    //{

                    //    this.utfVCAR_CARDataGridView.CurrentCell.Value
                    //        = Car_markForm.Mark_short_name;
                    //    this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                    //        = Car_markForm.Mark_id;
                    //}
                }
            }
            //_is_valid &= false;
            //Ok_Toggle(_is_valid);
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
        //Функция получения номера заказа - наряда
        string Get_order_number(string p_sent_to)
        {
            string v_number = "";
            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("dbo.uspVWRH_WRH_ORDER_SEQ_Generate",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_sent_to", SqlDbType.Char, 1);
                        parameter.Value = p_sent_to;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_number", SqlDbType.VarChar, 20);

                        parameter.Direction = ParameterDirection.Output;

                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {

                            v_number = AuthenticationCommand.Parameters["@p_number"].Value.ToString();

                            reader.Close();
                            connection.Close();

                        }
                        finally
                        {
                            // Always call Close when done reading.
                            reader.Close();
                            connection.Close();
                        }
                    }
                }
                catch (SqlException Sqle)
                {
                    MessageBox.Show("Ошибка подключения");
                    MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                    MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                    MessageBox.Show("Источник: " + Sqle.Source.ToString());

                }
            }
            return v_number;
        }

        private void open_dltoolStripMenuItem_Click(object sender, EventArgs e)
        {
            string v_car_mark_model_name = "";
            string v_car_type_id = "";
            string v_condition_id = "";
            string v_state_number = "";
            string v_speedometer_start_indctn = "";
            string v_fuel_start_left = "";
            DateTime v_date_created = DateTime.Now;

            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                v_car_mark_model_name = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
                v_car_type_id = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
                v_condition_id = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                v_state_number = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
                v_speedometer_start_indctn = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn47.Index].Value.ToString();
                v_fuel_start_left = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn43.Index].Value.ToString();


            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
                v_car_mark_model_name = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
                v_car_type_id = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn35.Index].Value.ToString();
                v_condition_id = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
                v_state_number = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
                v_speedometer_start_indctn = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn48.Index].Value.ToString();
                v_fuel_start_left = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn44.Index].Value.ToString();


            }

            try
            {
                //this.uspVDRV_DRIVER_LIST_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                this.uspVCAR_CAR_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001_Car_SelectById.uspVCAR_CAR_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                this.uspVDRV_DRIVER_PLAN_Select_DriverByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_Select_DriverById, v_date_created, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                this.uspVDRV_DRIVER_LIST_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

            if (this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.RowCount < 2)
            {


                using (Head_driver_list Head_driver_listForm = new Head_driver_list())
                {
                    Head_driver_listForm.Text = "Открыть";
                    Head_driver_listForm._driver_list_car_id
                        = this.p_car_idToolStripTextBox.Text;
                    Head_driver_listForm._driver_list_car_mark_model_name
                        = v_car_mark_model_name;
                    Head_driver_listForm._driver_list_car_type_id
                        = v_car_type_id;
                    Head_driver_listForm._driver_list_condition_id
                        = v_condition_id;
                    Head_driver_listForm._driver_list_state_number
                        = v_state_number;
                    Head_driver_listForm._driver_list_speedometer_start_indctn
                        = v_speedometer_start_indctn;
                    Head_driver_listForm._driver_list_fuel_start_left
                        = v_fuel_start_left;
                    Head_driver_listForm._driver_list_type_id
                        = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn142.Index].Value.ToString();
                    Head_driver_listForm._driver_list_fuel_type_id
                        = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn124.Index].Value.ToString();
                    Head_driver_listForm._driver_list_fuel_norm
                        = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value.ToString();
                    Head_driver_listForm._driver_list_organization_id
                        = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn140.Index].Value.ToString();
                    Head_driver_listForm._driver_list_organization_sname
                        = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn141.Index].Value.ToString();
                    Head_driver_listForm._driver_list_fuel_type_sname
                        = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn125.Index].Value.ToString();

                    Head_driver_listForm._form_state = 1;
                    try
                    {
                        Head_driver_listForm._driver_list_fio_driver1
                           = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn153.Index].Value.ToString();
                        Head_driver_listForm._driver_list_employee1_id
                          = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn152.Index].Value.ToString();
                        Head_driver_listForm._driver_list_driver_passport
                          = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[driver_license.Index].Value.ToString();
                    }
                    catch { }

                    if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn142.Index].Value.ToString() != "")
                         && (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn140.Index].Value.ToString() != ""))
                    {
                        Head_driver_listForm._driver_list_number
                        = Just.Get_driver_list_number((decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn142.Index].Value.ToString(), typeof(decimal))
                                                      , (decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn140.Index].Value.ToString(), typeof(decimal)));
                    }
                    Head_driver_listForm.Text = "Открыть";

                    Head_driver_listForm.ShowDialog(this);

                    if (Head_driver_listForm.DialogResult == DialogResult.OK)
                    {
                        if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
                        {
                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                                = Const.On_duty_id;
                            this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                                = Const.On_duty_name;
                            try
                            {
                                this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                            }
                            catch (System.Exception ex)
                            {
                                System.Windows.Forms.MessageBox.Show(ex.Message);
                            }
                        }
                        if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
                        {
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value
                                = Const.On_duty_id;
                            this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value
                                = Const.On_duty_name;
                            try
                            {

                                this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                                      , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                      , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                      , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                            }
                            catch (System.Exception ex)
                            {
                                System.Windows.Forms.MessageBox.Show(ex.Message);
                            }
                        }
                    }
                }
            }
            else
            {
                MessageBox.Show("У этого автомобиля уже есть открытый путевой лист, сначала закройте его");
            }
        }

        private void close_dltoolStripMenuItem_Click(object sender, EventArgs e)
        {
          
            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
            }

            try
            {
                this.uspVDRV_DRIVER_LIST_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

            using (Head_driver_list Head_driver_listForm = new Head_driver_list())
            {
                Head_driver_listForm.Text = "Закрыть";
                Head_driver_listForm._driver_list_car_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn75.Index].Value.ToString();
                Head_driver_listForm._driver_list_car_mark_model_name
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn77.Index].Value.ToString();

                Head_driver_listForm._driver_list_condition_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn103.Index].Value.ToString();
                Head_driver_listForm._driver_list_date_created
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn73.Index].Value.ToString();
                Head_driver_listForm._driver_list_driver_list_state_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn85.Index].Value.ToString();
                Head_driver_listForm._driver_list_employee1_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn78.Index].Value.ToString();
                Head_driver_listForm._driver_list_fact_end_duty
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn84.Index].Value.ToString();
                Head_driver_listForm._driver_list_fact_start_duty
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn83.Index].Value.ToString();
                Head_driver_listForm._driver_list_fio_driver1
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn80.Index].Value.ToString();


                Head_driver_listForm._driver_list_fuel_gived
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn98.Index].Value.ToString();
                Head_driver_listForm._driver_list_fuel_norm
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn82.Index].Value.ToString();
                Head_driver_listForm._driver_list_fuel_start_left
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn96.Index].Value.ToString();
                Head_driver_listForm._driver_list_fuel_type_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn91.Index].Value.ToString();
                Head_driver_listForm._driver_list_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn65.Index].Value.ToString();
                Head_driver_listForm._driver_list_last_date_created
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn156.Index].Value.ToString();
                Head_driver_listForm._driver_list_number
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn74.Index].Value.ToString();
                Head_driver_listForm._driver_list_organization_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString();
                Head_driver_listForm._driver_list_run
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn101.Index].Value.ToString();
                Head_driver_listForm._driver_list_speedometer_end_indctn
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn95.Index].Value.ToString();
                Head_driver_listForm._driver_list_speedometer_start_indctn
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn94.Index].Value.ToString();
                Head_driver_listForm._driver_list_state_number
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn76.Index].Value.ToString();
                Head_driver_listForm._driver_list_type_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn87.Index].Value.ToString();
                Head_driver_listForm._form_state = 4;
                Head_driver_listForm.ShowDialog(this);
                if (Head_driver_listForm.DialogResult == DialogResult.OK)
                {
                    if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
                    {
                        this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                            = Const.In_garage_id;
                        this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                            = Const.In_garage_name;
                        try
                        {
                            this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                              , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                              , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                              , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }
                    }
                    if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
                    {
                        this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value
                            = Const.In_garage_id;
                        this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value
                            = Const.In_garage_name;
                        try
                        {

                            this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }
                    }
                }
            }

        }

        private void print_prev_dltoolStripMenuItem_Click(object sender, EventArgs e)
        {

            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
            }

            try
            {
                this.uspVDRV_DRIVER_LIST_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

            using (Head_driver_list Head_driver_listForm = new Head_driver_list())
            {
                Head_driver_listForm.Text = "Напечатать предыдущий";
                Head_driver_listForm._driver_list_car_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn75.Index].Value.ToString();
                Head_driver_listForm._driver_list_car_mark_model_name
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn77.Index].Value.ToString();

                Head_driver_listForm._driver_list_condition_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn103.Index].Value.ToString();
                Head_driver_listForm._driver_list_date_created
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn73.Index].Value.ToString();
                Head_driver_listForm._driver_list_driver_list_state_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn85.Index].Value.ToString();
                Head_driver_listForm._driver_list_employee1_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn78.Index].Value.ToString();
                Head_driver_listForm._driver_list_fact_end_duty
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn84.Index].Value.ToString();
                Head_driver_listForm._driver_list_fact_start_duty
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn83.Index].Value.ToString();
                Head_driver_listForm._driver_list_fio_driver1
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn80.Index].Value.ToString();


                Head_driver_listForm._driver_list_fuel_gived
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn98.Index].Value.ToString();
                Head_driver_listForm._driver_list_fuel_norm
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn82.Index].Value.ToString();
                Head_driver_listForm._driver_list_fuel_start_left
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn96.Index].Value.ToString();
                Head_driver_listForm._driver_list_fuel_type_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn91.Index].Value.ToString();
                Head_driver_listForm._driver_list_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn65.Index].Value.ToString();
                Head_driver_listForm._driver_list_last_date_created
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn156.Index].Value.ToString();
                Head_driver_listForm._driver_list_number
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn74.Index].Value.ToString();
                Head_driver_listForm._driver_list_organization_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString();
                Head_driver_listForm._driver_list_organization_sname
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn90.Index].Value.ToString();
                Head_driver_listForm._driver_list_run
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn101.Index].Value.ToString();
                Head_driver_listForm._driver_list_speedometer_end_indctn
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn95.Index].Value.ToString();
                Head_driver_listForm._driver_list_speedometer_start_indctn
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn94.Index].Value.ToString();
                Head_driver_listForm._driver_list_state_number
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn76.Index].Value.ToString();
                Head_driver_listForm._driver_list_type_id
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn87.Index].Value.ToString();
                Head_driver_listForm._driver_list_driver_passport
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn66.Index].Value.ToString();
                Head_driver_listForm._driver_list_fuel_type_sname
                    = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn92.Index].Value.ToString();
                Head_driver_listForm._form_state = 2;
                Head_driver_listForm.ShowDialog(this);
                if (Head_driver_listForm.DialogResult == DialogResult.OK)
                {
                    if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
                    {
                        try
                        {
                            this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                              , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                              , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                              , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }
                    }
                    if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
                    {
                        try
                        {

                            this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }
                    }
                }
            }
 

        }

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
            if (this._work_switch == 2)
            {
                Printfile.Form_blank_print(this.Ar_path, _filled_file, this.Printer_name, _doc_count);
                //Printfile.Form_gs_print_pages_count(Application.StartupPath + "\\" + _filled_file, this.Printer_spool, this.Printer_device, "2", "2", _doc_count);
            }
        }

        private void verify_open_orderToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Warehouse_order Warehouse_orderForm = new Warehouse_order())
            {
                Warehouse_orderForm._where_clause = "order_state = 'Открыт'";
                Warehouse_orderForm.ShowDialog(this);
                if (Warehouse_orderForm.DialogResult == DialogResult.OK)
                {
                    try
                    {
                        this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                          , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                          , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                          , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                    }
                    catch (System.Exception ex)
                    {
                        System.Windows.Forms.MessageBox.Show(ex.Message);
                    }
                    try
                    {

                        this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                              , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                              , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                              , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                    }
                    catch (System.Exception ex)
                    {
                        System.Windows.Forms.MessageBox.Show(ex.Message);
                    }
                }
            }
        }

        private void delete_wrong_dlToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Dialog DialogForm = new Dialog())
            {
                DialogForm._dialog_form_state = 2;
                DialogForm._dialog_label = "Вы уверены, что хотите удалить ошибочный путевой лист?";
                DialogForm.ShowDialog(this);
                if (DialogForm.DialogResult == DialogResult.OK)
                {
                    string v_id = "";
                    System.Configuration.ConnectionStringSettings settings;
                    settings =
                        System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
                    if (settings != null)
                    {

                        if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
                        {
                            this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                        }

                        if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
                        {
                            this.p_car_idToolStripTextBox.Text = this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
                        }

                        try
                        {
                            this.uspVDRV_DRIVER_LIST_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }

                        v_id = this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn65.Index].Value.ToString();


                        // Подключение к БД
                        try
                        {
                            using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                            {
                                SqlCommand AuthenticationCommand = new SqlCommand("dbo.uspVDRV_DRIVER_LIST_Delete_OpenById",
                                                                                  connection);
                                AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                                //Добавление параметров для процедуры
                                SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                                    "@p_id", SqlDbType.Decimal);
                                parameter.Value = v_id;

                                connection.Open();

                                SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                                try
                                {
                                    if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
                                    {
                                        this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                                            = Const.In_garage_id;
                                        this.uspVCAR_CONDITION_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                                            = Const.In_garage_name;
                                        try
                                        {
                                            this.uspVCAR_CONDITION_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Condition_car.uspVCAR_CONDITION_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                              , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                              , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                              , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                                        }
                                        catch (System.Exception ex)
                                        {
                                            System.Windows.Forms.MessageBox.Show(ex.Message);
                                        }
                                    }
                                    if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
                                    {
                                        this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value
                                            = Const.In_garage_id;
                                        this.uspVCAR_CONDITION_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value
                                            = Const.In_garage_name;
                                        try
                                        {

                                            this.uspVCAR_CONDITION_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Condition_freight.uspVCAR_CONDITION_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
                                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                                        }
                                        catch (System.Exception ex)
                                        {
                                            System.Windows.Forms.MessageBox.Show(ex.Message);
                                        }
                                    }

                                    reader.Close();
                                    connection.Close();

                                }
                                finally
                                {
                                    // Always call Close when done reading.
                                    reader.Close();
                                    connection.Close();
                                }
                            }
                        }
                        catch (SqlException Sqle)
                        {
                            MessageBox.Show("Ошибка подключения");
                            MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                            MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                            MessageBox.Show("Источник: " + Sqle.Source.ToString());

                        }
                    }

                }
            }

        }

        private void start_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {

        }

        private void view_repairstoolStripButton_Click(object sender, EventArgs e)
        {
            using (Car_repair_type_given Car_repair_type_givenForm = new Car_repair_type_given())
            {
                Car_repair_type_givenForm.ShowDialog(this);
                if (Car_repair_type_givenForm.DialogResult == DialogResult.OK)
                { }
            }
        }

        private void row_status_closeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
             {
                 this.uspVCAR_CONDITION_SelectCarDataGridView.RowsDefaultCellStyle.WrapMode = DataGridViewTriState.False;
               //  this.addtnl_ts_car.Visible = false;
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                this.uspVCAR_CONDITION_SelectFreightDataGridView.RowsDefaultCellStyle.WrapMode = DataGridViewTriState.False;
               // this.addtnl_ts_freight.Visible = false; 
            }
            this.row_status_openToolStripMenuItem.Visible = true;
            this.row_status_closeToolStripMenuItem.Visible = false;
        }

        private void row_status_openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVCAR_CONDITION_SelectCarDataGridView.Focused == true)
            {
                this.uspVCAR_CONDITION_SelectCarDataGridView.RowsDefaultCellStyle.WrapMode = DataGridViewTriState.True;
               // this.addtnl_ts_car.Visible = true;
               // this.addtnl_ts_car.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            }

            if (this.uspVCAR_CONDITION_SelectFreightDataGridView.Focused == true)
            {
                this.uspVCAR_CONDITION_SelectFreightDataGridView.RowsDefaultCellStyle.WrapMode = DataGridViewTriState.True;
              //  this.addtnl_ts_freight.Visible = true;
               // this.addtnl_ts_freight.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            }
            this.row_status_openToolStripMenuItem.Visible = false;
            this.row_status_closeToolStripMenuItem.Visible = true;
        }



    }
}


