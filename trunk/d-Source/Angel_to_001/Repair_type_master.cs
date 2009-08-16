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
    public partial class Repair_type_master : Form
    {
        public string _username;

    	
    	//Укажем id для интересующей нас колонки
        public string Repair_type_master_id
        {
            get { return this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }

        //Укажем название для интересующей нас колонки
        public string Repair_type_master_sname
        {
            get { return this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }

        //Укажем название для интересующей нас колонки
        public string Repair_type_master_mark_sname
        {
            get { return this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString(); }
        }

        //Укажем название для интересующей нас колонки
        public string Repair_type_master_model_sname
        {
            get { return this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString(); }
        }

        public string _repair_type_master_mark_sname;
        public string _repair_type_master_model_sname;
        public string _where_clause = "";

    	private bool _is_valid = true;

    	
        public Repair_type_master()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
        }

        private void uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            

//        	try
//        	{
//        		
//        		this.Validate();
//        		this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingSource.EndEdit();
//        		this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVRPR_REPAIR_TYPE_MASTER_SelectAll);
//        		//_is_valid &= this.Check_Items();
//        		this.Ok_Toggle(_is_valid);
//        		_is_valid = true;
//        		this.UspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridViewCurrentCellChanged(sender, e);
//        	}
//        	catch (SqlException Sqle)
//        	{
//
//        		switch (Sqle.Number)
//        		{
//        			case 515:
//        				MessageBox.Show("Необходимо заполнить все обязательные поля!");
//        				break;
//
//        			case 2601:
//        				MessageBox.Show("Такой 'Приходный документ' уже существует");
//        				break;
//
//        			default:
//        				MessageBox.Show("Ошибка");
//        				MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
//        				MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
//        				MessageBox.Show("Источник: " + Sqle.Source.ToString());
//        				break;
//        		}
//
//        		this.Ok_Toggle(false);
//        		_is_valid = false;
//
//        	}
//
//        	catch (Exception Appe)
//        	{
//        		MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
//        		this.Ok_Toggle(false);
//        		_is_valid = false;
//        	}
//        	
        	
        }

        private void Repair_type_master_Load(object sender, EventArgs e)
        {
            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
            if ( ((this._repair_type_master_mark_sname != "")
                && (this._repair_type_master_mark_sname != null)) 
               &&((this._repair_type_master_model_sname != "")
                &&(this._repair_type_master_model_sname != null)))
            {
                this._where_clause = "(car_mark_sname = '" + this._repair_type_master_mark_sname
                                    + "' and car_model_sname = '" + this._repair_type_master_model_sname
                                    + "') or (car_mark_sname is null and car_model_sname is null)";  
            }
            this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingSource.Filter = this._where_clause;



            // TODO: This line of code loads data into the 'aNGEL_TO_001.uspVRPR_REPAIR_TYPE_MASTER_SelectAll' table. You can move, or remove it, as needed.
            this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_TYPE_MASTER_SelectAll
                                                                         , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

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
        
        void InsertToolStripMenuItemClick(object sender, EventArgs e)
        {
        	 using (Repair_type_detail Repair_type_detailForm = new Repair_type_detail())
            {
                Repair_type_detailForm.Text = "Вставка -";
                Repair_type_detailForm.ShowDialog(this);
                if (Repair_type_detailForm.DialogResult == DialogResult.OK)
                {
                    if (this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.RowCount == 1)
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingSource.AddNew();
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingSource.AddNew();
                    }

                    if (Repair_type_detailForm.Repair_type_master_short_name != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                        = Repair_type_detailForm.Repair_type_master_short_name;
                    }
                    if (Repair_type_detailForm.Repair_type_master_full_name != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                        = Repair_type_detailForm.Repair_type_master_full_name;
                    }
                    if (Repair_type_detailForm.Repair_type_master_code != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                        = Repair_type_detailForm.Repair_type_master_code;
                    }
                    if (Repair_type_detailForm.Repair_type_master_time_to_repair_in_minutes != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                        = Repair_type_detailForm.Repair_type_master_time_to_repair_in_minutes;
                    }
                    
                     if (Repair_type_detailForm.Repair_type_master_id != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
                        = Repair_type_detailForm.Repair_type_master_id;
                    }

                     if (Repair_type_detailForm.Repair_type_master_is_ts != "")
                     {
                         this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_ts.Index].Value
                         = Repair_type_detailForm.Repair_type_master_is_ts;
                     }

                     if (Repair_type_detailForm.Repair_type_master_repair_type_master_kind_id != "")
                     {
                         this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value
                         = Repair_type_detailForm.Repair_type_master_repair_type_master_kind_id;
                     }

                     if (Repair_type_detailForm.Repair_type_master_repair_type_master_kind_sname != "")
                     {
                         this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value
                         = Repair_type_detailForm.Repair_type_master_repair_type_master_kind_sname;
                     }
                             
					//_is_valid &= false;
					//Ok_Toggle(_is_valid);
                }

            }

        }
        
        void EditToolStripMenuItemClick(object sender, EventArgs e)
        {
        	using (Repair_type_detail Repair_type_detailForm = new Repair_type_detail())
        	{
        		Repair_type_detailForm.Text = "Редактирование -";
        		
        		Repair_type_detailForm._repair_type_master_id = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_short_name = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_full_name = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_code = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_time_to_repair_in_minutes = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
                Repair_type_detailForm._repair_type_master_is_ts = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_ts.Index].Value.ToString();
                Repair_type_detailForm._repair_type_master_repair_type_master_kind_id = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value.ToString();
                Repair_type_detailForm._repair_type_master_repair_type_master_kind_sname = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value.ToString();
        		
        	 	Repair_type_detailForm.ShowDialog(this);
        		if (Repair_type_detailForm.DialogResult == DialogResult.OK)
        		{
        			if (Repair_type_detailForm.Repair_type_master_short_name != "")
        			{
        				this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
        					= Repair_type_detailForm.Repair_type_master_short_name;
        			}
        			if (Repair_type_detailForm.Repair_type_master_full_name != "")
        			{
        				this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
        					= Repair_type_detailForm.Repair_type_master_full_name;
        			}
        			if (Repair_type_detailForm.Repair_type_master_code != "")
        			{
        				this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
        					= Repair_type_detailForm.Repair_type_master_code;
        			}
        			if (Repair_type_detailForm.Repair_type_master_time_to_repair_in_minutes != "")
        			{
        				this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
        					= Repair_type_detailForm.Repair_type_master_time_to_repair_in_minutes;
        			}
                    if (Repair_type_detailForm.Repair_type_master_is_ts != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_ts.Index].Value
                        = Repair_type_detailForm.Repair_type_master_is_ts;
                    }


                    if (Repair_type_detailForm.Repair_type_master_repair_type_master_kind_id != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value
                        = Repair_type_detailForm.Repair_type_master_repair_type_master_kind_id;
                    }

                    if (Repair_type_detailForm.Repair_type_master_repair_type_master_kind_sname != "")
                    {
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value
                        = Repair_type_detailForm.Repair_type_master_repair_type_master_kind_sname;
                    }
        			
        			//_is_valid = false;
        			//Ok_Toggle(false);
        		}
        	}
        }
        
        void DeleteToolStripMenuItemClick(object sender, EventArgs e)
        {        	 
        	using (Repair_type_detail Repair_type_detailForm = new Repair_type_detail())
            {
                Repair_type_detailForm.Text = "Удаление -";
                Repair_type_detailForm._repair_type_master_form_state = 3;            
              	Repair_type_detailForm._repair_type_master_id = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_short_name = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_full_name = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_code = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
        		Repair_type_detailForm._repair_type_master_time_to_repair_in_minutes = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
                Repair_type_detailForm._repair_type_master_is_ts = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_ts.Index].Value.ToString();
                Repair_type_detailForm._repair_type_master_repair_type_master_kind_id = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value.ToString();
                Repair_type_detailForm._repair_type_master_repair_type_master_kind_sname = this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value.ToString();
                Repair_type_detailForm.ShowDialog(this);
                if (Repair_type_detailForm.DialogResult == DialogResult.OK)
                {
                	this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingSource.RemoveCurrent();
                    //_is_valid = false;
                    //Ok_Toggle(false);
                }
            }
        }
        
        void UspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
        {
        }
        
        void UspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
        	//_is_valid &= false;
			//Ok_Toggle(_is_valid);
        }
        
        void Button_okClick(object sender, EventArgs e)
        {
//        	if (_is_valid == false)
//			{
//				this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingNavigatorSaveItem_Click(sender, e);
//			}
        }
        
        void UspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
        	try
			{
				if ((this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
				    != this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridView.RowCount)
				{
					
					//this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
        }
        
 
        
        void UspVRPR_REPAIR_TYPE_MASTER_SelectAllDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void button_find_Click(object sender, EventArgs e)
        {
             this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_TYPE_MASTER_SelectAll
                                                                         , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
        }
    }
}
