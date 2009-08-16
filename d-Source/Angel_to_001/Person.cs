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
    public partial class Person : Form
    {

        public string _username;
        private bool _is_valid = true;

        public Person()
        {
            InitializeComponent();

            button_ok.DialogResult = DialogResult.OK;
            button_cancel.DialogResult = DialogResult.Cancel;
        }
        //Укажем фамилию для интересующей нас колонки
        public string Person_lastname
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString(); }
        }

        //Укажем индекс для интересующей нас колонки
        public string Person_name
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString(); }
        }

        //Укажем индекс для интересующей нас колонки
        public string Person_surname
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString(); }
        }

        //Укажем индекс для интересующей нас колонки
        public string Person_sex
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }
        //Укажем индекс для интересующей нас колонки
        public string Person_birthdate
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString(); }
        }
        //Укажем индекс для интересующей нас колонки
        public string Person_mobile_phone
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString(); }
        }
        //Укажем индекс для интересующей нас колонки
        public string Person_home_phone
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString(); }
        }
        //Укажем индекс для интересующей нас колонки
        public string Person_work_phone
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString(); }
        }
        //Укажем индекс для интересующей нас колонки
        public string Id
        {
            get { return this.utfVPRT_PERSONDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }

        private void utfVPRT_PERSONBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
                this.utfVPRT_PERSONBindingSource.EndEdit();
                this.utfVPRT_PERSONTableAdapter.Update(this.ANGEL_TO_001_Person.utfVPRT_PERSON);
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
                    this.utfVPRT_PERSONTableAdapter.Fill(this.ANGEL_TO_001_Person.utfVPRT_PERSON
                     , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                     , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                     , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

                }
                if (Sqle.Number == 2601)
                {
                    MessageBox.Show("Такое 'Физ. лицо' уже существует");
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

        private void Person_Load(object sender, EventArgs e)
        {

            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
            
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Person.utfVPRT_PERSON' table. You can move, or remove it, as needed.
            this.utfVPRT_PERSONTableAdapter.Fill(this.ANGEL_TO_001_Person.utfVPRT_PERSON
                , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

        }

        private void utfVPRT_PERSONDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.utfVPRT_PERSONDataGridView.CurrentRow.Index + 1)
                    == this.utfVPRT_PERSONDataGridView.RowCount)
                    && (this.utfVPRT_PERSONDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.utfVPRT_PERSONDataGridView.CurrentRow.Index + 1)
                        == this.utfVPRT_PERSONDataGridView.RowCount)
                    {

                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.Date_choosertoolStripMenuItem.Enabled = false;

                    }
                    else
                    {

                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.Date_choosertoolStripMenuItem.Enabled = true;
                    }
                }
                //Добавим пункт меню для работы с календарем
                if (this.utfVPRT_PERSONDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn10")
                {
                    this.Date_choosertoolStripMenuItem.Visible = true;
                }
                else
                {
                    this.Date_choosertoolStripMenuItem.Visible = false;
                }
            }
            catch (Exception Appe)
            {
            }
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.utfVPRT_PERSONDataGridView.RowCount == 1)
            {
                this.utfVPRT_PERSONBindingSource.AddNew();
                this.utfVPRT_PERSONBindingSource.RemoveCurrent();
            }
            else
            {
                this.utfVPRT_PERSONBindingSource.AddNew();
            }
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVPRT_PERSONBindingSource.RemoveCurrent();
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }

        private void Date_choosertoolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Date_chooser Date_chooserForm = new Date_chooser())
            {
                Date_chooserForm.ShowDialog(this);
                if (Date_chooserForm.DialogResult == DialogResult.OK)
                {
                    this.utfVPRT_PERSONDataGridView.CurrentCell.Value
                        = Date_chooserForm.Short_date_value;
                    _is_valid = false;
                    Ok_Toggle(_is_valid);
                }
            }
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.utfVPRT_PERSONBindingNavigatorSaveItem_Click(sender, e);
        }

        private void button_find_Click(object sender, EventArgs e)
        {
            this.utfVPRT_PERSONTableAdapter.Fill(this.ANGEL_TO_001_Person.utfVPRT_PERSON
            , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
            , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
            , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

        }

        private void utfVPRT_PERSONDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }
    }
}
