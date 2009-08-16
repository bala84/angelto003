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
    public partial class Fuel_type : Form
    {
        public string _username;
        private bool _is_valid = true;

        public Fuel_type()
        {
            InitializeComponent();
        }


        //Укажем id для интересующей нас колонки
        public string Fuel_type_id
        {
            get { return this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }
        //Укажем название для интересующей нас колонки
        public string Fuel_type_short_name
        {
            get { return this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }
        //Укажем норму для интересующей нас колонки
        public string Fuel_type_norm
        {
            get { return this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString(); }
        }


        //private void utfVCAR_FUEL_TYPEBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        //{
        //    this.Validate();
        //    this.utfVCAR_FUEL_TYPEBindingSource.EndEdit();
        //    this.utfVCAR_FUEL_TYPETableAdapter.Update(this.ANGEL_TO_001_Fuel_type.utfVCAR_FUEL_TYPE);

        //}

        private void Fuel_type_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Fuel_type.utfVCAR_FUEL_TYPE' table. You can move, or remove it, as needed.
            this.utfVCAR_FUEL_TYPETableAdapter.Fill(this.ANGEL_TO_001_Fuel_type.utfVCAR_FUEL_TYPE);
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Fuel_type.utfVCAR_FUEL_TYPE' table. You can move, or remove it, as needed.
           // this.utfVCAR_FUEL_TYPETableAdapter.Fill(this.ANGEL_TO_001_Fuel_type.utfVCAR_FUEL_TYPE);

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

        private void utfVCAR_FUEL_TYPEBindingNavigatorSaveItem_Click_1(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
                this.utfVCAR_FUEL_TYPEBindingSource.EndEdit();
                this.utfVCAR_FUEL_TYPETableAdapter.Update(this.ANGEL_TO_001_Fuel_type.utfVCAR_FUEL_TYPE);
                this.Ok_Toggle(true);
                _is_valid = true;
            }
            catch (SqlException Sqle)
            {   //not null sql exception
                switch (Sqle.Number)
                {
                    case 515:
                        MessageBox.Show("Необходимо заполнить все обязательные поля!");
                        break;

                    case 547:
                        MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись!");
                        this.utfVCAR_FUEL_TYPETableAdapter.Fill(this.ANGEL_TO_001_Fuel_type.utfVCAR_FUEL_TYPE);
                        break;

                    case 2601:
                        MessageBox.Show("Такой 'Тип топлива' уже существует");
                        break;

                    default:
                        MessageBox.Show("Ошибка");
                        MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                        MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                        MessageBox.Show("Источник: " + Sqle.Source.ToString());
                        break;
                        this.Ok_Toggle(false);
                        _is_valid = false;
                }
            }
            catch (Exception Appe)
            {
                this.Ok_Toggle(false);
                _is_valid = false;
            }
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.utfVCAR_FUEL_TYPEDataGridView.RowCount == 1)
            {
                this.utfVCAR_FUEL_TYPEBindingSource.AddNew();
                this.utfVCAR_FUEL_TYPEBindingSource.RemoveCurrent();
            }
            else
            {
                this.utfVCAR_FUEL_TYPEBindingSource.AddNew();
            }
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_FUEL_TYPEBindingSource.RemoveCurrent();
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

        private void utfVCAR_FUEL_TYPEDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Index + 1)
                    == this.utfVCAR_FUEL_TYPEDataGridView.RowCount)
                    &&(this.utfVCAR_FUEL_TYPEDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Index + 1)
                        == this.utfVCAR_FUEL_TYPEDataGridView.RowCount)
                    {
                        this.EditToolStripMenuItem.Enabled = false;
                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.SeasontoolStripMenuItem.Enabled = false;
                    }
                    else
                    {
                        this.EditToolStripMenuItem.Enabled = true;
                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.SeasontoolStripMenuItem.Enabled = true;
                    }
                }
                //Добавим пункт меню для работы с сезонами
                if (this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn14")
                {
                    this.SeasontoolStripMenuItem.Visible = true;
                    //А "Редактировать" выключаем
                    this.EditToolStripMenuItem.Visible = false;
                }
                else
                {
                    this.SeasontoolStripMenuItem.Visible = false;
                    this.EditToolStripMenuItem.Visible = true;
                }
            }
            catch (Exception Appe)
            {
            }
        }
        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_FUEL_TYPEDataGridView.BeginEdit(false);
            if (this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn16")
            {
                using (Car_mark Car_markForm = new Car_mark())
                {
                    Car_markForm.ShowDialog(this);
                    if (Car_markForm.DialogResult == DialogResult.OK)
                    {

                        this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.Value
                            = Car_markForm.Mark_short_name;
                        this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                            = Car_markForm.Mark_id;
                        _is_valid = false;
                        Ok_Toggle(_is_valid);
                    }
                }
            }
            if (this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn17")
            {
                using (Car_model Car_modelForm = new Car_model())
                {
                    Car_modelForm.Mark_short_name
                        = this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();

                    Car_modelForm.Mark_id = this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();

                    Car_modelForm.ShowDialog(this);
                    if (Car_modelForm.DialogResult == DialogResult.OK)
                    {

                        this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.Value
                            = Car_modelForm.Model_short_name;
                        this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                            = Car_modelForm.Model_id;
                        _is_valid = false;
                        Ok_Toggle(_is_valid);
                    }
                }
            }
        }

        private void WinterToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.Value
              = "Зима";
        }

        private void SpringToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.Value
              = "Весна";
        }

        private void SummerToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.Value
              = "Лето";
        }

        private void AutumnToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_FUEL_TYPEDataGridView.CurrentCell.Value
              = "Осень";
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.utfVCAR_FUEL_TYPEBindingNavigatorSaveItem_Click_1(sender, e);
        }

        private void utfVCAR_FUEL_TYPEDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void utfVCAR_FUEL_TYPEDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void utfVCAR_FUEL_TYPEDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.utfVCAR_FUEL_TYPEDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { }

            _is_valid = false;
            Ok_Toggle(_is_valid);
        }
    }     
}
