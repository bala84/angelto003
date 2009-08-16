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
    public partial class Employee_type : Form
    {
        public string _username;
        private bool _is_valid = true;

        public Employee_type()
        {
            InitializeComponent();
            button_ok.DialogResult = DialogResult.OK;
            button_cancel.DialogResult = DialogResult.Cancel;
        }
        //Вернем выбранную строку, если необходимо
        public DataGridViewRow Row
        {
            get { return utfVPRT_EMPLOYEE_TYPEDataGridView.CurrentRow; }
        }
        //Укажем индекс для интересующей нас колонки
        public int Job_title_name_index
        {
            get { return dataGridViewTextBoxColumn8.Index; }
        }
        //Укажем индекс для интересующей нас колонки
        public int Id_index
        {
            get { return dataGridViewTextBoxColumn1.Index; }
        }

        private void utfVPRT_EMPLOYEE_TYPEBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
                this.utfVPRT_EMPLOYEE_TYPEBindingSource.EndEdit();
                this.utfVPRT_EMPLOYEE_TYPETableAdapter.Update(this.aNGEL_TO_001_Employee_type.utfVPRT_EMPLOYEE_TYPE);
                this.Ok_Toggle(true);
                _is_valid = true;
            }
            catch (SqlException Sqle)
            {   //not null sql exception
                if (Sqle.Number == 515)
                {
                    MessageBox.Show("Необходимо заполнить все обязательные поля!");
                }
                if (Sqle.Number == 547)
                {
                    MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись!");
                    this.utfVPRT_EMPLOYEE_TYPETableAdapter.Fill(this.aNGEL_TO_001_Employee_type.utfVPRT_EMPLOYEE_TYPE);

                }
                if (Sqle.Number == 2601)
                {
                    MessageBox.Show("Такая 'Должность' уже существует");
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

        private void EMPLOYEE_TYPE_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Employee_type.utfVPRT_EMPLOYEE_TYPE' table. You can move, or remove it, as needed.
            this.utfVPRT_EMPLOYEE_TYPETableAdapter.Fill(this.aNGEL_TO_001_Employee_type.utfVPRT_EMPLOYEE_TYPE);

        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.utfVPRT_EMPLOYEE_TYPEDataGridView.RowCount == 1)
            {
                this.utfVPRT_EMPLOYEE_TYPEBindingSource.AddNew();
                this.utfVPRT_EMPLOYEE_TYPEBindingSource.RemoveCurrent();
            }
            else
            {
                this.utfVPRT_EMPLOYEE_TYPEBindingSource.AddNew();
            }
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVPRT_EMPLOYEE_TYPEBindingSource.RemoveCurrent();
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

        private void utfVPRT_EMPLOYEE_TYPEDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try 
            {
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.utfVPRT_EMPLOYEE_TYPEDataGridView.CurrentRow.Index + 1)
                    == this.utfVPRT_EMPLOYEE_TYPEDataGridView.RowCount)
                    && (this.utfVPRT_EMPLOYEE_TYPEDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.utfVPRT_EMPLOYEE_TYPEDataGridView.CurrentRow.Index + 1)
                        == this.utfVPRT_EMPLOYEE_TYPEDataGridView.RowCount)
                    {
                        
                        this.DeleteToolStripMenuItem.Enabled = false;
                        
                    }
                    else
                    {
                        
                        this.DeleteToolStripMenuItem.Enabled = true;
                       
                    }
                }
            }
            catch (Exception Appe)
            {
            }
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.utfVPRT_EMPLOYEE_TYPEBindingNavigatorSaveItem_Click(sender, e);
        }

        private void contextMenuStrip1_Opening(object sender, CancelEventArgs e)
        {

        }

        private void utfVPRT_EMPLOYEE_TYPEDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.utfVPRT_EMPLOYEE_TYPEDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { }

            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

    }
}
