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
    public partial class Last_ts_type : Form
    {
        public string _username;

        private bool _is_valid = true;

        public string _last_ts_type_car_id;
        public string _last_ts_type_car_state_number;

        //Укажем id для интересующей нас колонки
        public string Last_ts_type_id
        {
            get { return this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }
        
        public Last_ts_type()
        {
            InitializeComponent();
            button_ok.DialogResult = DialogResult.OK;
            button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel; 
        
        }

        private void uspVCAR_LAST_TS_TYPE_SelectByCar_IdBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {

                this.Validate();
                this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdBindingSource.EndEdit();
                this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdTableAdapter.Update(this.aNGEL_TO_001_Last_ts_type.uspVCAR_LAST_TS_TYPE_SelectByCar_Id);
                this.Ok_Toggle(_is_valid);
                _is_valid = true;
                this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView_CurrentCellChanged(sender, e);
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
                        try
                        {
                            this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001_Last_ts_type.uspVCAR_LAST_TS_TYPE_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }
                        break;

                    case 2601:
                        MessageBox.Show("Такое 'Прошедшее ТО' уже существует");
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
            { }

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

        private void Last_ts_type_Load(object sender, EventArgs e)
        {
            //MessageBox.Show(_last_ts_type_car_id);
            this.p_car_idToolStripTextBox.Text = _last_ts_type_car_id;
            try
            {
                this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001_Last_ts_type.uspVCAR_LAST_TS_TYPE_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.RowCount != 1)
            {
                this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdBindingSource.AddNew();
            }
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.BeginEdit(false);

            if (this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11")
            {
               // MessageBox.Show(this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString());
                using (Ts_type Ts_typeForm = new Ts_type())
                {
                    if ((this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString() != "")
                        && (this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString()) != "")
                    {
                        Ts_typeForm._where_clause = "car_mark_id = "
                            + this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString()
                            + " and car_model_id = "
                            + this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
                    }
                    Ts_typeForm.ShowDialog(this);
                    if (Ts_typeForm.DialogResult == DialogResult.OK)
                    {

                        this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentCell.Value
                            = Ts_typeForm.Ts_type_sname;
                        this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                            = Ts_typeForm.Ts_type_id;
                    }
                }
            }
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Index + 1)
                        != this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Index + 1)
                    == this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.RowCount)
                    && (this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                }

            }
            catch (Exception Appe)
            {
            }
        }

        private void uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {

            this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                = p_car_idToolStripTextBox.Text;
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            //Если это не последняя строка, то проверим содержимое
            try
            {
                if ((this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.CurrentRow.Index + 1)
                         != this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdBindingNavigatorSaveItem_Click(sender, e);
        }

        private void uspVCAR_LAST_TS_TYPE_SelectByCar_IdDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVCAR_LAST_TS_TYPE_SelectByCar_IdBindingSource.RemoveCurrent();
            _is_valid &= false;
            Ok_Toggle(_is_valid);   
        }
    }
}
