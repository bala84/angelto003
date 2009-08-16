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
    public partial class Warehouse_type : Form
    {
        public string _username;

    	private bool _is_valid = true;
    	
    	//Укажем id для интересующей нас колонки
        public string Warehouse_type_id
        {
            get { return this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }
        //Укажем название для интересующей нас колонки
        public string Warehouse_type_short_name
        {
            get { return this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }
    	 
        public Warehouse_type()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void uspVWRH_WAREHOUSE_TYPE_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
           try
            {

            		this.Validate();
            		this.uspVWRH_WAREHOUSE_TYPE_SelectAllBindingSource.EndEdit();
            		this.uspVWRH_WAREHOUSE_TYPE_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WAREHOUSE_TYPE_SelectAll);
                   	//_is_valid &= this.Check_Items();
                    this.Ok_Toggle(true);
                    _is_valid = true;
                    UspVWRH_WAREHOUSE_TYPE_SelectAllDataGridViewCurrentCellChanged(sender, e);
         
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
                                        +"Проверьте, что данный склад не используется. ");
                        this.uspVWRH_WAREHOUSE_TYPE_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WAREHOUSE_TYPE_SelectAll);
						break;

                    case 2601:
                        MessageBox.Show("Такой 'Склад' уже существует");
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

        private void Warehouse_type_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001.uspVWRH_WAREHOUSE_TYPE_SelectAll' table. You can move, or remove it, as needed.
            this.uspVWRH_WAREHOUSE_TYPE_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WAREHOUSE_TYPE_SelectAll);

        }
        
        void InsertToolStripMenuItemClick(object sender, EventArgs e)
        {
            if (this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.RowCount == 1)
            {
                this.uspVWRH_WAREHOUSE_TYPE_SelectAllBindingSource.AddNew();
                this.uspVWRH_WAREHOUSE_TYPE_SelectAllBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVWRH_WAREHOUSE_TYPE_SelectAllBindingSource.AddNew();
            }

                _is_valid &= false;
                Ok_Toggle(_is_valid);
        }
        
        void DeleteToolStripMenuItemClick(object sender, EventArgs e)
        {
        	this.uspVWRH_WAREHOUSE_TYPE_SelectAllBindingSource.RemoveCurrent();
            _is_valid &= false;
            Ok_Toggle(_is_valid);   
        }
        
        void UspVWRH_WAREHOUSE_TYPE_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
        {
        	  try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.CurrentRow.Index + 1)
                        != this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.CurrentRow.Index + 1)
                    == this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.RowCount)
                    &&(this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.CurrentRow.Index + 1)
                        == this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.RowCount)
                    {
                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.InsertToolStripMenuItem.Enabled = false;
                       
                    }
                    else
                    {
                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.InsertToolStripMenuItem.Enabled = true;
                    }
                }

            }
            catch (Exception Appe)
            {
            }
        }
        
        void UspVWRH_WAREHOUSE_TYPE_SelectAllDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
        	_is_valid &= false;
            Ok_Toggle(_is_valid);
        }
        
        void Button_okClick(object sender, EventArgs e)
        {
            this.uspVWRH_WAREHOUSE_TYPE_SelectAllBindingNavigatorSaveItem_Click(sender, e);
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
        
        void UspVWRH_WAREHOUSE_TYPE_SelectAllDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
        	            //Если это не последняя строка, то проверим содержимое
            try
            {
                if ((this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.CurrentRow.Index + 1)
                         != this.uspVWRH_WAREHOUSE_TYPE_SelectAllDataGridView.RowCount)
                {
                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }
        
        void UspVWRH_WAREHOUSE_TYPE_SelectAllDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
        {
          try
            {
                throw e.Exception;
            }
            catch(Exception Appe)
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
        
        void Button_findClick(object sender, EventArgs e)
        {
        	
        }
    }
}
