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
	public partial class Warehouse_income_detail : Form
	{
        public string _username;
		
		private bool _is_valid = true;

        public string _warehouse_income_master_id;
        public string _warehouse_income_master_number;
        public string _warehouse_income_master_organization_id;
        public string _warehouse_income_master_organization_name;
        public string _warehouse_income_master_warehouse_type_id;
        public string _warehouse_income_master_warehouse_type_sname;
        public string _warehouse_income_master_organization_recieve_id;
        public string _warehouse_income_master_organization_recieve_name;
        public string _warehouse_income_master_date_created;
        public string _warehouse_income_master_total;
        public string _warehouse_income_master_summa;
        public string _warehouse_income_master_is_verified;
        public string _warehouse_income_master_account_type;

        //Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
        public byte _warehouse_income_detail_form_state;


        public string Warehouse_income_master_id
        {
            get { return this.idTextBox.Text; }
        }

        public string Warehouse_income_master_number
        {
            get { return this.numberTextBox.Text; }
        }

        public string Warehouse_income_master_organization_id
        {
            get { return this.organization_idTextBox.Text; }
        }

        public string Warehouse_income_master_organization_name
        {
            get { return this.organization_sname_textBox.Text; }
        }

        public string Warehouse_income_master_warehouse_type_id
        {
            get { return this.warehouse_type_idTextBox.Text; }
        }

        public string Warehouse_income_master_warehouse_type_sname
        {
            get { return this.warehouse_type_snametextBox.Text; }
        }

        public string Warehouse_income_master_organization_recieve_id
        {
            get { return this.org_recieve_idtextBox.Text; }
        }

        public string Warehouse_income_master_organization_recieve_name
        {
            get { return this.org_recievetextBox.Text; }
        }


        public string Warehouse_income_master_date_created
        {
            get { return this.date_createdDateTimePicker.Text; }
        }



        public string Warehouse_income_master_summa
        {
            get { return this.sumtextBox.Text; }
        }

        public string Warehouse_income_master_is_verified
        {
            get { return this.wrh_income_state_nameComboBox.Text; }
        }

        public string Warehouse_income_master_account_type
        {
            get { return this.account_typecomboBox.Text; }
        }




        public string Warehouse_income_master_total
        {
            get { return this.totalTextBox.Text; }
        }
		
		
		
		public Warehouse_income_detail()
		{
			InitializeComponent();
			
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}


		private void Wrh_income_Load(object sender, EventArgs e)
		{
            this.Text = this.Text + " приходный документ";

            this.account_typecomboBox.Text = "Цена без НДС";
            this.wrh_income_state_nameComboBox.Text = "Не проверен";


            if ((_warehouse_income_master_id != "")
               && (_warehouse_income_master_id  != null))
            {
                this.idTextBox.Text = _warehouse_income_master_id;
                this.p_wrh_income_master_idToolStripTextBox.Text = _warehouse_income_master_id;
            }

            if ((_warehouse_income_master_number != "")
               && (_warehouse_income_master_number != null))
            {
                this.numberTextBox.Text = _warehouse_income_master_number;
            }

            if ((_warehouse_income_master_organization_id != "")
                && (_warehouse_income_master_organization_id != null))
            {
                this.organization_idTextBox.Text = _warehouse_income_master_organization_id;
            }
            if ((_warehouse_income_master_organization_name != "")
                && (_warehouse_income_master_organization_name != null))
            {
                this.organization_sname_textBox.Text = _warehouse_income_master_organization_name;
            }

            if ((_warehouse_income_master_organization_recieve_id != "")
                && (_warehouse_income_master_organization_recieve_id != null))
            {
                this.org_recieve_idtextBox.Text = _warehouse_income_master_organization_recieve_id;
            }
            if ((_warehouse_income_master_organization_recieve_name != "")
                && (_warehouse_income_master_organization_recieve_name != null))
            {
                this.org_recievetextBox.Text = _warehouse_income_master_organization_recieve_name;
            }

            if (( _warehouse_income_master_warehouse_type_id != "")
                && (_warehouse_income_master_warehouse_type_id != null))
            {
                this.warehouse_type_idTextBox.Text = _warehouse_income_master_warehouse_type_id;
            }
            if ((_warehouse_income_master_warehouse_type_sname != "")
                && (_warehouse_income_master_warehouse_type_sname != null))
            {
                this.warehouse_type_snametextBox.Text = _warehouse_income_master_warehouse_type_sname;
            }
            if ((_warehouse_income_master_date_created != "")
                && (_warehouse_income_master_date_created != null))
            {
                this.date_createdDateTimePicker.Text = _warehouse_income_master_date_created;
            }
            if ((_warehouse_income_master_summa != "")
                && (_warehouse_income_master_summa != null))
            {
                this.sumtextBox.Text = _warehouse_income_master_summa;
            }
            if ((_warehouse_income_master_total != "")
                && (_warehouse_income_master_total != null))
            {
                this.totalTextBox.Text = _warehouse_income_master_total;
            }

            if ((_warehouse_income_master_is_verified != "")
                && (_warehouse_income_master_is_verified != null))
            {
                this.wrh_income_state_nameComboBox.Text = _warehouse_income_master_is_verified;
            }

            if ((_warehouse_income_master_account_type != "")
               &&(_warehouse_income_master_account_type != null))
            {
                this.account_typecomboBox.Text = _warehouse_income_master_account_type;
            }


            if (this.p_wrh_income_master_idToolStripTextBox.Text != "")
            {
                try
                {
                    this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_wrh_income_master_idToolStripTextBox.Text, typeof(decimal))))));
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }
            }

            if (_warehouse_income_detail_form_state == 3)
            {
                this.BackColor = Color.Red;
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = false;
                this.numberTextBox.Enabled = false;
                this.date_createdDateTimePicker.Enabled = false;
                this.org_recievetextBox.Enabled = false;
                this.button_organization.Enabled = false;
                this.organization_sname_textBox.Enabled = false;
                this.button_org_recieve.Enabled = false;
                this.warehouse_type_snametextBox.Enabled = false;
                this.button_warehouse_type.Enabled = false;
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
                this.sumtextBox.Enabled = false;
                this.taxtextBox.Enabled = false;
                this.totalTextBox.Enabled = false;
                this.contextMenuStrip1.Enabled = false;
                this.wrh_income_state_nameComboBox.Enabled = false;
                this.account_typecomboBox.Enabled = false;
                Ok_Toggle(true);
            }
            else
            {
                this.BackColor = System.Drawing.SystemColors.Control;
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = true;
                Ok_Toggle(_is_valid);
            }
            //Если форма в режиме редактирования - запомним загруженные значения склада и получателя
                this.last_organization_recieve_idtextBox.Text = _warehouse_income_master_organization_recieve_id;
                this.last_warehouse_type_idtextBox.Text = _warehouse_income_master_warehouse_type_id;
		}

		
		void Button_organizationClick(object sender, EventArgs e)
		{
			
			using (Organization OrganizationForm = new Organization())
			{
				OrganizationForm.ShowDialog(this);
				if (OrganizationForm.DialogResult == DialogResult.OK)
				{

					this.organization_idTextBox.Text
						= OrganizationForm.Org_id;
					this.organization_sname_textBox.Text
						= OrganizationForm.Org_sname;
					_is_valid &= false;
					Ok_Toggle(_is_valid);
				}
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
		
		void Button_warehouse_typeClick(object sender, EventArgs e)
		{
			using (Warehouse_type Warehouse_typeForm = new Warehouse_type())
			{
				Warehouse_typeForm.ShowDialog(this);
				if (Warehouse_typeForm.DialogResult == DialogResult.OK)
				{

					this.warehouse_type_idTextBox.Text
						= Warehouse_typeForm.Warehouse_type_id;
					this.warehouse_type_snametextBox.Text
						= Warehouse_typeForm.Warehouse_type_short_name;
					_is_valid &= false;
					Ok_Toggle(_is_valid);
				}
			}
		}
		
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
            if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount == 1)
            {
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.AddNew();
            }

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.BeginEdit(false);
			if ((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn14")
			    ||(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn15")
			    ||(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn16"))
			{
				using (Good_category Good_categoryForm = new Good_category())
				{
					Good_categoryForm.ShowDialog(this);
					if (Good_categoryForm.DialogResult == DialogResult.OK)
					{

                        //Если первая строка, то вставка одной записи должна быть
                        //почему-то вставляет две записи при cell read only
                       /* if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount == 1)
                        {
                            this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                            this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
                        }*/

						this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
							= Good_categoryForm.Good_category_good_mark;
						this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Good_categoryForm.Good_category_sname;
						this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Good_categoryForm.Good_category_unit;
						this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
							= Good_categoryForm.Good_category_id;
						_is_valid &= false;
						Ok_Toggle(_is_valid);
					}
				}
			}
		}
		
		void DeleteToolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				     == this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				    &&(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
					    == this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount)
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
		
		void UspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void Button_okClick(object sender, EventArgs e)
		{
			if (_is_valid == false)
			{
				this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingNavigatorSaveItemClick(sender, e);
			}
		}
		
		void UspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		//Процедура подсчета сумм в детальной таблице
		void Warehouse_income_calculate()
		{  
			decimal v_price;
			decimal v_amount;
			decimal v_total_sum = 0;
			decimal v_tax = 0.18m;
			
			if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString()
			    != "")
			{	v_price = (decimal)Convert.ChangeType(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString(), typeof(decimal));
			}
			else
			{
				v_price = 0;
			}
			if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString()
			    != "")
            {
                v_amount = (decimal)Convert.ChangeType(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString(), typeof(decimal));
			}
			else
			{
				v_amount = 0;
			}
			//Сумма в строке равна количеству умноженному на цену с учетом налогов
			this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
				= ((v_price
                   *v_amount) + (v_price*v_amount*v_tax)).ToString("0.##");
			//Сумма по всем строкам
			for (int i = 0; i <= this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows.Count - 2; i++)
			{
				if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows[i].Cells[dataGridViewTextBoxColumn17.Index].Value.ToString()
				    != "")
				{
					v_total_sum = v_total_sum
						+ (decimal)Convert.ChangeType(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows[i].Cells[dataGridViewTextBoxColumn17.Index].Value.ToString(), typeof(decimal));
			
				}
				else
				{
					v_total_sum = v_total_sum + 0;
				}
			}
			
			this.sumtextBox.Text = v_total_sum.ToString("0.##");
			//Прибавим налог
			if (this.taxtextBox.Text != "")
			{
				v_tax = (decimal)Convert.ChangeType(this.taxtextBox.Text, typeof(decimal));
			}
			else
			{
				this.taxtextBox.Text = v_tax.ToString();
			}
			
			//v_total_sum = v_total_sum + (v_total_sum*v_tax);
			
			this.totalTextBox.Text = v_total_sum.ToString("0.##");
			
		}

        //Процедура подсчета цен в детальной таблице и общей суммы
        void Warehouse_income_calculate_back()
        {
            decimal v_sum;
            decimal v_amount;
            decimal v_total_sum = 0;
            decimal v_tax = 0.18m;

            //Прибавим налог
            if (this.taxtextBox.Text != "")
            {
                v_tax = (decimal)Convert.ChangeType(this.taxtextBox.Text, typeof(decimal));
            }
            else
            {
                this.taxtextBox.Text = v_tax.ToString();
            }

            if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString()
                != "")
            {
                v_sum = (decimal)Convert.ChangeType(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString(), typeof(decimal));
            }
            else
            {
                v_sum = 0;
            }
            if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString()
                != "")
            {
                v_amount = (decimal)Convert.ChangeType(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString(), typeof(decimal));
            }
            else
            {
                v_amount = 0;
            }
            //Сумма в строке равна количеству умноженному на цену
            this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                = (v_sum
                   / (v_amount * (v_tax + 1))).ToString("0.##");
            //Сумма по всем строкам
            for (int i = 0; i <= this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows.Count - 2; i++)
            {
                if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows[i].Cells[dataGridViewTextBoxColumn17.Index].Value.ToString()
                    != "")
                {
                    v_total_sum = v_total_sum
                        + (decimal)Convert.ChangeType(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows[i].Cells[dataGridViewTextBoxColumn17.Index].Value.ToString(), typeof(decimal));

                }
                else
                {
                    v_total_sum = v_total_sum + 0;
                }
            }

            this.sumtextBox.Text = v_total_sum.ToString("0.##");


          //  v_total_sum = v_total_sum + (v_total_sum * v_tax);

            this.totalTextBox.Text = v_total_sum.ToString("0.##");

        }
		
		void UspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridViewCellEndEdit(object sender, DataGridViewCellEventArgs e)
		{
			if ((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13")
			    ||(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11"))
			{
				this.Warehouse_income_calculate();
			}
            if ((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn17"))
            {
                this.Warehouse_income_calculate_back();
            }
		}
		//Процедура подготовки детальной таблицы для записи 
        void Prepare_Detail(string p_last_organization_recieve_id, string p_last_warehouse_type_id)
		{
			 foreach(DataGridViewRow currentRow in this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows)
			 {
			 	currentRow.Cells[dataGridViewTextBoxColumn8.Index].Value = this.idTextBox.Text;
                if (this._warehouse_income_detail_form_state == 2)
                {
                    currentRow.Cells[this.last_organization_recieve_id.Index].Value = p_last_organization_recieve_id;
                    currentRow.Cells[this.last_warehouse_type_id.Index].Value = p_last_warehouse_type_id;
                }
                    
    		 }
		}

		
		void uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingNavigatorSaveItemClick(object sender, EventArgs e)
		{
			Nullable<decimal> v_id = new Nullable<decimal>();
            string v_last_organization_recieve_id = "";
            string v_last_warehouse_type_id = "";
			
			if ((this.numberTextBox.Text != "")
			    &&(this.date_createdDateTimePicker.Text != "")
			    &&(this.organization_idTextBox.Text != "")
			    &&(this.warehouse_type_idTextBox.Text != "")
			    &&(this.totalTextBox.Text != "")
			    &&(this.org_recieve_idtextBox.Text != ""))
			{
				try
				{
					if (this.idTextBox.Text != "")
					{
						v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
					}
                    if (this.last_organization_recieve_idtextBox.Text != "")
                    {
                        v_last_organization_recieve_id = this.last_organization_recieve_idtextBox.Text;
                    }
                    if (this.last_warehouse_type_idtextBox.Text != "")
                    {
                        v_last_warehouse_type_id = this.last_warehouse_type_idtextBox.Text;
                    }
					this.Validate();
					this.uspVWRH_WRH_INCOME_MASTER_SelectAllBindingSource.EndEdit();
					this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
                    if (this._warehouse_income_detail_form_state == 3)
                    {
                        this.uspVWRH_WRH_INCOME_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))), "-", _username);
                    }
                    else
                    {
                        this.uspVWRH_WRH_INCOME_MASTER_SelectAllTableAdapter.Update(ref v_id
                                                                                    , this.numberTextBox.Text
                                                                                    , (decimal)Convert.ChangeType(this.organization_idTextBox.Text, typeof(decimal))
                                                                                    , (decimal)Convert.ChangeType(this.warehouse_type_idTextBox.Text, typeof(decimal))
                                                                                    , (DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime))
                                                                                    , (decimal)Convert.ChangeType(this.totalTextBox.Text, typeof(decimal))
                                                                                    , (decimal)Convert.ChangeType(this.sumtextBox.Text, typeof(decimal))
                                                                                    , (decimal)Convert.ChangeType(this.org_recieve_idtextBox.Text, typeof(decimal))
                                                                                    , this.wrh_income_state_nameComboBox.Text
                                                                                    , this.account_typecomboBox.Text
                                                                                    , this.sys_commentTextBox.Text
                                                                                    , this.sys_user_modifiedTextBox.Text);
                        this.idTextBox.Text = v_id.ToString();
                        this.Prepare_Detail(v_last_organization_recieve_id, v_last_warehouse_type_id);
                        this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_Id);
                    }
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
					_is_valid = true;
					this.UspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(sender, e);
				}
				catch (SqlException Sqle)
				{

					switch (Sqle.Number)
					{
							case 515:
							MessageBox.Show("Необходимо заполнить все обязательные поля!");
							break;

						case 2601:
							MessageBox.Show("Такой 'Приходный документ' уже существует, либо такой товар уже указан в списке товаров");
							break;

                        case 50000:
                            MessageBox.Show(Sqle.Message.ToString());
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
					MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
					this.Ok_Toggle(false);
					_is_valid = false;
				}
			}
			else
			{
				MessageBox.Show("Проверьте, что вы заполнили поля: 'Номер документа', 'Поставщик', 'Склад - получатель', 'Организация - получатель', 'Дата создания', 'Итог' ");
			}
		}
        
        void Button_org_recieveClick(object sender, EventArgs e)
        {
        	using (Organization OrganizationForm = new Organization())
			{
				OrganizationForm.ShowDialog(this);
				if (OrganizationForm.DialogResult == DialogResult.OK)
				{

					this.org_recieve_idtextBox.Text
						= OrganizationForm.Org_id;
					this.org_recievetextBox.Text
						= OrganizationForm.Org_sname;
					_is_valid &= false;
					Ok_Toggle(_is_valid);
				}
			}
        }

        private void organization_sname_textBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void warehouse_type_snametextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void numberTextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void org_recievetextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void sumtextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void taxtextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void totalTextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void wrh_income_state_nameComboBox_SelectedValueChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void account_typecomboBox_SelectedValueChanged(object sender, EventArgs e)
        {
            if (this.account_typecomboBox.Text == "Цена без НДС")
            {
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Columns[this.dataGridViewTextBoxColumn17.Index].Visible = false;

            }
            else
            {
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Columns[this.dataGridViewTextBoxColumn17.Index].Visible = true;
            }

            if (this.account_typecomboBox.Text == "Сумма с НДС")
            {
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Columns[this.dataGridViewTextBoxColumn13.Index].Visible = false;

            }
            else
            {
                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Columns[this.dataGridViewTextBoxColumn13.Index].Visible = true;
            }
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }


	}
}
