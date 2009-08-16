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
    public partial class Return_reason_type : Form
    {
        public string _username;

        private bool _is_valid = true;

        public Return_reason_type()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }


        private void Return_reason_type_Load(object sender, EventArgs e)
        {
            // TODO: данная строка кода позволяет загрузить данные в таблицу "aNGEL_TO_001.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAll". При необходимости она может быть перемещена или удалена.
            this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAll);

        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.RowCount == 1)
            {
                this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllBindingSource.AddNew();
                this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllBindingSource.AddNew();
            }

            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllBindingSource.RemoveCurrent();
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

        private void uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.CurrentRow.Index + 1)
                         != this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.RowCount)
                {
                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.CurrentRow.Cells[this.sys_user_modified.Index].Value
                = this._username;
            }
            catch { }

            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.CurrentRow.Index + 1)
                        != this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.CurrentRow.Index + 1)
                    == this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.RowCount)
                    && (this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView.RowCount != 1))
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

        private void uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {

            try
            {

                this.Validate();
                this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllBindingSource.EndEdit();
                this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAll);
                //_is_valid &= this.Check_Items();
                this.Ok_Toggle(true);
                _is_valid = true;
                this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllDataGridView_CurrentCellChanged(sender, e);

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
                                        + "Проверьте, что данный тип причины не используется. ");
                        this.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVCAR_CAR_RETURN_REASON_TYPE_SelectAll);
                        break;

                    case 2601:
                        MessageBox.Show("Такой 'Тип причины' уже существует");
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
                this.Ok_Toggle(false);
                _is_valid = false;
            }
        }


    }
}
