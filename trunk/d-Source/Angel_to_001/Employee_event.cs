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
    public partial class Employee_event : Form
    {
        public string _username;
        public string _where_clause = "";

        private bool _is_valid = true;

        public Employee_event()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }


        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.RowCount == 1)
            {
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.AddNew();
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.AddNew();
            }

            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.BeginEdit(false);
            try
            {
                if (this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "short_FIO")
                {
                    using (Employee EmployeeForm = new Employee())
                    {
                        EmployeeForm.ShowDialog(this);
                        if (EmployeeForm.DialogResult == DialogResult.OK)
                        {

                            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Cells[employee_id.Index].Value
                                = EmployeeForm.Employee_id;
                            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Cells[short_FIO.Index].Value
                                = EmployeeForm.Employee_short_fio;
                        }
                    }
                }

                if ((this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "date_started")
                || (this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "date_ended"))
                {
                    using (Date_chooser Date_chooserForm = new Date_chooser())
                    {
                        Date_chooserForm.ShowDialog(this);
                        if (Date_chooserForm.DialogResult == DialogResult.OK)
                        {
                            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentCell.Value
                                = Date_chooserForm.Short_date_value;
                        }
                    }
                }
                //
                if (this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.RowCount == 1)
                {
                    this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.AddNew();
                    this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.RemoveCurrent();
                }
                _is_valid &= false;
                Ok_Toggle(_is_valid);
            }
            catch (Exception Appe)
            { }

        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.RemoveCurrent();
            _is_valid &= false;
            Ok_Toggle(_is_valid);
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

        private void uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Index + 1)
                    != this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.RowCount)
                {

                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Index + 1)
                    != this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой
                if (((this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Index + 1)
                     == this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.RowCount)
                    && (this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Index + 1)
                        == this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.RowCount)
                    {
                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;


                    }
                    else
                    {
                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.EditToolStripMenuItem.Enabled = true;

                    }
                    //Добавим пункт меню для работы с событиями
                    if (this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "events")
                    {
                        this.choose_eventToolStripMenuItem.Visible = true;
                        //А "Редактировать" выключаем
                        this.EditToolStripMenuItem.Visible = false;
                    }
                    else
                    {
                        this.choose_eventToolStripMenuItem.Visible = false;
                        this.EditToolStripMenuItem.Visible = true;
                    }
                }


            }
            catch (Exception Appe)
            {
            }
        }

        private void uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                throw e.Exception;
            }
            catch (Exception Appe)
            {
                MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
            }
        }

        private void Employee_event_Load(object sender, EventArgs e)
        {

            start_dateTimePicker.Value = DateTime.Now.AddDays(-7.0);

            this.p_date_startedToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();

            end_dateTimePicker.Value = DateTime.Now;

            this.p_date_endedToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();

            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();

            try
            {
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVPRT_EMPLOYEE_EVENT_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_startedToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_endedToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void start_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {

            try
            {
                this.p_date_startedToolStripTextBox.Text = this.start_dateTimePicker.Value.ToShortDateString();
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVPRT_EMPLOYEE_EVENT_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_startedToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_endedToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void end_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {

            try
            {
                this.p_date_endedToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVPRT_EMPLOYEE_EVENT_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_startedToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_endedToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void button_find_Click(object sender, EventArgs e)
        {

            try
            {
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVPRT_EMPLOYEE_EVENT_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_startedToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_endedToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void payable_holiday_eventToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Cells[events.Index].Value
                = "Оплачиваемый отпуск";
        }

        private void not_payable_holiday_eventToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Cells[events.Index].Value
                = "Неоплачиваемый отпуск";
        }

        private void termination_eventToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Cells[events.Index].Value
                = "Увольнение";
        }


        private void button_ok_Click(object sender, EventArgs e)
        {
            if (this._is_valid == false)
            {
                this.utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem_Click(sender, e);
            }
        }

        private void utfVPRT_EMPLOYEE_EVENTBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllBindingSource.EndEdit();
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVPRT_EMPLOYEE_EVENT_SelectAll);
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
                        MessageBox.Show("Такое 'Событие' уже существует");
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

        private void uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView.CurrentRow.Cells[this.sys_user_modified.Index].Value
                = this._username;
            }
            catch { }
        }

        private void uspVPRT_EMPLOYEE_EVENT_SelectAllDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
