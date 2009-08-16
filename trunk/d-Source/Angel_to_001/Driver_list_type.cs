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
    public partial class Driver_list_type : Form
    {
        public string _username;

        public Driver_list_type()
        {
            InitializeComponent();
        }
        //Укажем индекс для интересующей нас колонки
        public string Driver_list_type_id
        {
            get { return this.utfVDRV_DRIVER_LIST_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }

        //Укажем имя для интересующей нас колонки
        public string Driver_list_type_sname
        {
            get { return this.utfVDRV_DRIVER_LIST_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }

        private void utfVDRV_DRIVER_LIST_TYPEBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
                this.utfVDRV_DRIVER_LIST_TYPEBindingSource.EndEdit();
                this.utfVDRV_DRIVER_LIST_TYPETableAdapter.Update(this.aNGEL_TO_001_Driver_list_type.utfVDRV_DRIVER_LIST_TYPE);
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
                    this.utfVDRV_DRIVER_LIST_TYPETableAdapter.Fill(this.aNGEL_TO_001_Driver_list_type.utfVDRV_DRIVER_LIST_TYPE);


                }
                if (Sqle.Number == 2601)
                {
                    MessageBox.Show("Такой 'Тип путевого листа' уже существует");
                }
            }
        }

        private void Driver_list_type_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Driver_list_type.utfVDRV_DRIVER_LIST_TYPE' table. You can move, or remove it, as needed.
            this.utfVDRV_DRIVER_LIST_TYPETableAdapter.Fill(this.aNGEL_TO_001_Driver_list_type.utfVDRV_DRIVER_LIST_TYPE);

        }

        private void utfVDRV_DRIVER_LIST_TYPEDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.utfVDRV_DRIVER_LIST_TYPEDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { }
        }
    }
}
