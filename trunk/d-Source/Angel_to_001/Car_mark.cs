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
    public partial class Car_mark : Form
    {
        public string _username;

        public Car_mark()
        {
            InitializeComponent();
        }

        //Укажем id для модели
        public string Model_id;

        //Укажем название для модели
        public string Model_short_name;

        //Укажем id для интересующей нас колонки
        public string Mark_id
        {
            get { return utfVCAR_CAR_MARKDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
           // set { Car_mark_id = value; }
        }
        //Укажем название для интересующей нас колонки
        public string Mark_short_name
        {
            get { return utfVCAR_CAR_MARKDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
            //set { Car_mark_short_name = value; }
        }


        private bool _is_valid = true;


        private void utfVCAR_CAR_MARKBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
                this.utfVCAR_CAR_MARKBindingSource.EndEdit();
                this.utfVCAR_CAR_MARKTableAdapter.Update(this.ANGEL_TO_001.uspVCAR_CAR_MARK_SelectAll);
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
                    this.utfVCAR_CAR_MARKTableAdapter.Fill(this.ANGEL_TO_001.uspVCAR_CAR_MARK_SelectAll);

                }
                if (Sqle.Number == 2601)
                {
                    MessageBox.Show("Такая 'Марка' уже существует");
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

        private void Car_mark_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Car_mark.utfVCAR_CAR_MARK' table. You can move, or remove it, as needed.
            this.utfVCAR_CAR_MARKTableAdapter.Fill(this.ANGEL_TO_001.uspVCAR_CAR_MARK_SelectAll);

        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.utfVCAR_CAR_MARKDataGridView.RowCount == 1)
            {
                this.utfVCAR_CAR_MARKBindingSource.AddNew();
                this.utfVCAR_CAR_MARKBindingSource.RemoveCurrent();
            }
            else
            {
                this.utfVCAR_CAR_MARKBindingSource.AddNew();
            }
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }


        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_CAR_MARKBindingSource.RemoveCurrent();
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

        private void utfVCAR_CAR_MARKDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {

        }

        private void utfVCAR_CAR_MARKDataGridView_CellValidated(object sender, DataGridViewCellEventArgs e)
        {
            if ((this.utfVCAR_CAR_MARKDataGridView.CurrentRow.Index + 1)
               != this.utfVCAR_CAR_MARKDataGridView.RowCount)
            {
                if (Is_Short_name_Valid())
                {
                    this.Short_name_errorProvider.SetError(this.utfVCAR_CAR_MARKDataGridView, "");
                    this.utfVCAR_CAR_MARKDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
                        = Color.White;
                }
                else
                {
                    this.Short_name_errorProvider.SetError(this.utfVCAR_CAR_MARKDataGridView, "Необходимо ввести краткое наименование");
                    this.utfVCAR_CAR_MARKDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
                        = Color.Red;
                }

            }
        }
        // Functions to verify data.
        private bool Is_Short_name_Valid()
        {
            return (this.utfVCAR_CAR_MARKDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString().Length != 0);
        }

        private void utfVCAR_CAR_MARKDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if ((this.utfVCAR_CAR_MARKDataGridView.CurrentRow.Index + 1)
                 != this.utfVCAR_CAR_MARKDataGridView.RowCount)
            {
                if (this.utfVCAR_CAR_MARKDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewbuttonColumn1")
                {

                    if (this.utfVCAR_CAR_MARKDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString()
                        != "")
                    {
                        this.utfVCAR_CAR_MARKBindingNavigatorSaveItem_Click(sender, e);

                        using (Car_model Car_modelForm = new Car_model())
                        {
                            Car_modelForm.Mark_short_name = Mark_short_name;
                            Car_modelForm.Mark_id = Mark_id;
                            Car_modelForm.ShowDialog(this);
                            if (Car_modelForm.DialogResult == DialogResult.OK)
                            {
                                Model_id = Car_modelForm.Model_id;
                                Model_short_name = Car_modelForm.Model_short_name;
                            }
                        }
                    }
                }
            }
        }

        private void utfVCAR_CAR_MARKBindingNavigator_RefreshItems(object sender, EventArgs e)
        {

        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.utfVCAR_CAR_MARKBindingNavigatorSaveItem_Click(sender, e);
        }

        private void utfVCAR_CAR_MARKDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void utfVCAR_CAR_MARKDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.utfVCAR_CAR_MARKDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { } 
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

    }
}
