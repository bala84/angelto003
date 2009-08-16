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
    public partial class Good_category : Form
    {
        public string _username;

    	private bool _is_valid = true;
    	private DataGridViewSelectedRowCollection _selected_rows;
    	
		public string Good_category_id
        {
            get { return this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }

        public string Good_category_good_mark
        {
            get { return this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }
        
        public string Good_category_sname
        {


            get { string v_car_model_sname = ""; 
                 
                  if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[car_model_sname.Index].Value.ToString() != "")
                    {
                        v_car_model_sname = " ( " + this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[car_model_sname.Index].Value.ToString() + " )";
                    }
  

                  return this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString() + v_car_model_sname; }
        }
        
        public string Good_category_unit
        {
            get { return this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[unit.Index].Value.ToString(); }
        }
    	
        public Good_category()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {

        	try
            {

 					this.Validate();
           		 	this.uspVWRH_GOOD_CATEGORY_SelectAllBindingSource.EndEdit();
            		this.uspVWRH_GOOD_CATEGORY_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_GOOD_CATEGORY_SelectAll);
                   	//_is_valid &= this.Check_Items();
                    this.Ok_Toggle(true);
                    _is_valid = true;
                    this.UspVWRH_GOOD_CATEGORY_SelectAllDataGridViewCurrentCellChanged(sender, e);
                    /*this.uspVWRH_GOOD_CATEGORY_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_GOOD_CATEGORY_SelectAll
                                                                     , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                     , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                     , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));*/
         
            }
            catch (SqlException Sqle)
            {

                switch (Sqle.Number)
                {
                    case 515:
                        MessageBox.Show("Необходимо заполнить все обязательные поля!");
                        break;

                    case 547:
                        MessageBox.Show( "Необходимо удалить все данные, которые ссылаются на данную запись! "
                                        +"Проверьте, что данный товар не используется. ");
                        this.uspVWRH_GOOD_CATEGORY_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_GOOD_CATEGORY_SelectAll
                                                                 ,((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                 , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                 , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

						break;

                    case 2601:
                        MessageBox.Show("Такой 'Товар' уже существует");
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

        private void Good_category_Load(object sender, EventArgs e)
        {
        	//заполним пока поле поиска первой буквой алфавита
         //TODO: обработка наиболее частых поисков
        	p_searchtextBox.Text = "";
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
            // TODO: This line of code loads data into the 'aNGEL_TO_001.uspVWRH_GOOD_CATEGORY_SelectAll' table. You can move, or remove it, as needed.
           
                this.uspVWRH_GOOD_CATEGORY_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_GOOD_CATEGORY_SelectAll
                                                                     , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                     , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                     , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            
        }
        
        void InsertToolStripMenuItemClick(object sender, EventArgs e)
        {
            if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.RowCount == 1)
            {
                this.uspVWRH_GOOD_CATEGORY_SelectAllBindingSource.AddNew();
                this.uspVWRH_GOOD_CATEGORY_SelectAllBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVWRH_GOOD_CATEGORY_SelectAllBindingSource.AddNew();
            }

                _is_valid &= false;
                Ok_Toggle(_is_valid);
        	
        }
        
        void EditToolStripMenuItemClick(object sender, EventArgs e)
        {
        	 this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.BeginEdit(false);
            if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn15")
            {
                using (Good_category_type Good_category_typeForm = new Good_category_type())
                {
                    Good_category_typeForm.ShowDialog(this);
                    if (Good_category_typeForm.DialogResult == DialogResult.OK)
                    {

                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.Value
                            = Good_category_typeForm.Good_category_type_short_name;
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                            = Good_category_typeForm.Good_category_type_id;
                        _is_valid &= false;
               			Ok_Toggle(_is_valid);
                    }
                }
            }
            if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn16")
            {
                using (Organization OrganizationForm = new Organization())
                {
                    OrganizationForm.ShowDialog(this);
                    if (OrganizationForm.DialogResult == DialogResult.OK)
                    {

                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.Value
                            = OrganizationForm.Org_sname;
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                            = OrganizationForm.Org_id;
                        _is_valid &= false;
               			Ok_Toggle(_is_valid);
                    }
                }
            }

            if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "car_mark_sname")
            {
                using (Car_mark Car_markForm = new Car_mark())
                {
                    Car_markForm.ShowDialog(this);
                    if (Car_markForm.DialogResult == DialogResult.OK)
                    {

                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.Value
                            = Car_markForm.Mark_short_name;
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[car_mark_id.Index].Value
                            = Car_markForm.Mark_id;
                        _is_valid &= false;
                        Ok_Toggle(_is_valid);
                    }
                }
            }

            if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "car_model_sname")
            {
                try
                {
                    if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[car_mark_sname.Index].Value.ToString() != "")
                    {
                        using (Car_model Car_modelForm = new Car_model())
                        {
                            Car_modelForm.Mark_short_name
                                = this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[car_mark_sname.Index].Value.ToString();

                            Car_modelForm.Mark_id = this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[car_mark_id.Index].Value.ToString();

                            Car_modelForm.ShowDialog(this);
                            if (Car_modelForm.DialogResult == DialogResult.OK)
                            {

                                this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.Value
                                    = Car_modelForm.Model_short_name;
                                this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[car_model_id.Index].Value
                                    = Car_modelForm.Model_id;
                                _is_valid &= false;
                                Ok_Toggle(_is_valid);
                            }
                        }
                    }
                }
                catch { }
            }
        	
        }
        
        void DeleteToolStripMenuItemClick(object sender, EventArgs e)
        {
        	this.uspVWRH_GOOD_CATEGORY_SelectAllBindingSource.RemoveCurrent();
            _is_valid &= false;
            Ok_Toggle(_is_valid);  
        }
        
        void UspVWRH_GOOD_CATEGORY_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
        {
        	 
        }

        
        void Button_okClick(object sender, EventArgs e)
        {
            this.uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem_Click(sender, e);
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
        
        
        
        void Piece_ToolStripMenuItemClick(object sender, EventArgs e)
        {
        	this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.Value
              = this.Piece_ToolStripMenuItem.Text;
        }
        
        void Litre_ToolStripMenuItemClick(object sender, EventArgs e)
        {
        	this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.Value
              = this.Litre_ToolStripMenuItem.Text;
        }
        
        void Kg_ToolStripMenuItemClick(object sender, EventArgs e)
        {
         	this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.Value
              = this.Kg_ToolStripMenuItem.Text;       	
        }
        
        void PasteToolStripMenuItemClick(object sender, EventArgs e)
        {
        	int[] v_row_index_array = new int[1] { -1};
            try
            {
                
                for (int i = 0; i <= _selected_rows.Count - 1; i++)
                {
                  
                    int v_is_row_index_found = Array.BinarySearch(v_row_index_array, _selected_rows[i].Index);

                    if (v_is_row_index_found >= 0)
                    {}
                    else
                    {
                       // MessageBox.Show(_selected_rows[i].Index.ToString());
                        Array.Resize(ref v_row_index_array, v_row_index_array.Length + 1);
                        v_row_index_array.SetValue(_selected_rows[i].Index, v_row_index_array.Length - 1);
                        this.InsertToolStripMenuItemClick(sender, e);
                    }
                    //for (int j = 0; j <= _selected_rows[i].Cells.Count - 1; i++)
                   // {
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].ColumnIndex].Value
                                = _selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].Value;
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].ColumnIndex].Value
                                = _selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].Value;
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].ColumnIndex].Value
                                = _selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].Value;
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[unit.Index].ColumnIndex].Value
                                = _selected_rows[i].Cells[unit.Index].Value;
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].ColumnIndex].Value
                                = _selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].Value;
                        
                 
                        this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value = DBNull.Value;
                       // }
                        
                }
                this.pasteToolStripMenuItem.Enabled = false;
                _selected_rows = null;
            }
            catch (Exception Appe)
            {
                MessageBox.Show(Appe.Message);
            }
        }
        
        void CopyToolStripMenuItemClick(object sender, EventArgs e)
        {
        	try
            {
                _selected_rows = this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.SelectedRows;
                this.pasteToolStripMenuItem.Enabled = true;
            }
            catch (Exception Appe)
            { }
        }
        
        
        void Button_findClick(object sender, EventArgs e)
        {
        	this.uspVWRH_GOOD_CATEGORY_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_GOOD_CATEGORY_SelectAll
                                                                 ,((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                 , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                 , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

        }
        

        private void uspVWRH_GOOD_CATEGORY_SelectAllDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Index + 1)
                         != this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.RowCount)
                {
                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void uspVWRH_GOOD_CATEGORY_SelectAllDataGridView_SelectionChanged(object sender, EventArgs e)
        {
            if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.SelectedRows.Count > 0)
            {
                this.copyToolStripMenuItem.Enabled = true;
            }
            else
            {
                this.copyToolStripMenuItem.Enabled = false;
            }
        }

        private void uspVWRH_GOOD_CATEGORY_SelectAllDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void uspVWRH_GOOD_CATEGORY_SelectAllDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { }

            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVWRH_GOOD_CATEGORY_SelectAllDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Index + 1)
                        != this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Index + 1)
                    == this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.RowCount)
                    && (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentRow.Index + 1)
                        == this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.RowCount)
                    {
                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.Quantity_type_toolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;

                    }
                    else
                    {
                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.Quantity_type_toolStripMenuItem.Enabled = true;
                        this.EditToolStripMenuItem.Enabled = true;
                    }
                }

                //Добавим пункт меню для работы с сезонами
                if (this.uspVWRH_GOOD_CATEGORY_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "unit")
                {
                    this.Quantity_type_toolStripMenuItem.Visible = true;
                    //А "Редактировать" выключаем
                    this.EditToolStripMenuItem.Visible = false;
                }
                else
                {
                    this.Quantity_type_toolStripMenuItem.Visible = false;
                    this.EditToolStripMenuItem.Visible = true;
                }

            }
            catch (Exception Appe)
            {
            }
        }
    }
}
