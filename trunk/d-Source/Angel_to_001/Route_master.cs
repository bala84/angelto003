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
    public partial class Route_master : Form
    {
        public string _username;
    	
    	private bool _is_valid = true;
    	
    	public string Route_master_id
		{
			get { return this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
		}
		
		public string Route_master_sname
		{
			get { return this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
		}
    	
        public Route_master()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void Route_master_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAll' table. You can move, or remove it, as needed.
            this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAll);

        }
        
        void InsertToolStripMenuItemClick(object sender, EventArgs e)
        {
		   using (Route_detail Route_detailForm = new Route_detail())
			{
				Route_detailForm.Text = "Вставка -"; 
				
				Route_detailForm.ShowDialog(this);
				if (Route_detailForm.DialogResult == DialogResult.OK)
				{
                    if (this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.RowCount == 1)
                    {
                        this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllBindingSource.AddNew();
                        this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllBindingSource.AddNew();
                    }
					
					if (Route_detailForm.Route_master_master_id != "")
					{
						this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
							= Route_detailForm.Route_master_master_id;
					}

					if (Route_detailForm.Route_master_master_sname != "")
					{
						this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Route_detailForm.Route_master_master_sname;
					}
				}
			}
        }
        
        void DeleteToolStripMenuItemClick(object sender, EventArgs e)
        {
        	using (Route_detail Route_detailForm = new Route_detail())
			{
				Route_detailForm._route_master_form_state = 3;
				Route_detailForm._route_master_master_id = this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
				Route_detailForm._route_master_master_sname = this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
				
				Route_detailForm.ShowDialog(this);
				if (Route_detailForm.DialogResult == DialogResult.OK)
				{
					this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllBindingSource.RemoveCurrent();
					//_is_valid = false;
					//Ok_Toggle(false);
				}
			} 
        }
        
        void UspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
        {
        	 try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                        != this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                    == this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.RowCount)
                    &&(this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                        == this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.RowCount)
                    {
                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;
                       
                    }
                    else
                    {
                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.EditToolStripMenuItem.Enabled = true;
                    }
                }

            }
            catch (Exception Appe)
            {
            }
        }
        
        void UspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
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
        
        
        void UspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
        	try
            {
                if ((this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                         != this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.RowCount)
                {
                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }
        
        void UspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
        {
        	try
			{
				throw e.Exception;
			}
			catch(Exception Appe)
			{
				MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
			}
        }
        
        
        void EditToolStripMenuItemClick(object sender, EventArgs e)
        {
        	using (Route_detail Route_detailForm = new Route_detail())
			{
				Route_detailForm.Text = "Редактирование -"; 
				
				Route_detailForm._route_master_form_state = 2;
				Route_detailForm._route_master_master_id = this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
				Route_detailForm._route_master_master_sname = this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
				
				
				Route_detailForm.ShowDialog(this);
				if (Route_detailForm.DialogResult == DialogResult.OK)
				{
					
					if (Route_detailForm.Route_master_master_id != "")
					{
						this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
							= Route_detailForm.Route_master_master_id;
					}

					if (Route_detailForm.Route_master_master_sname != "")
					{
						this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Route_detailForm.Route_master_master_sname;
					}
				}
			}
        }
    }
}
        
      
