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
	public partial class Warehouse_income : Form
	{
        public string _username;
		
		private bool _is_valid = true;
		
		
		public Warehouse_income()
		{
			InitializeComponent();
			
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}


		private void Wrh_income_Load(object sender, EventArgs e)
		{
			// TODO: This line of code loads data into the 'aNGEL_TO_001.uspVWRH_WRH_INCOME_MASTER_SelectAll' table. You can move, or remove it, as needed.
			//this.uspVWRH_WRH_INCOME_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_MASTER_SelectAll);
//			try
			//            {
			//                this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_income_master_idToolStripTextBox.Text, typeof(decimal))))));
			//            }
			//            catch (System.Exception ex)
			//            {
			//                System.Windows.Forms.MessageBox.Show(ex.Message);
			//            }
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
			if (this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1)
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
			short   v_amount;
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
			{	v_amount = (short)Convert.ChangeType(this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString(), typeof(short));
			}
			else
			{
				v_amount = 0;
			}
			//Сумма в строке равна количеству умноженному на цену
			this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
				= (v_price
				   * v_amount).ToString("0.##");
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
			
			v_total_sum = v_total_sum + (v_total_sum*v_tax);
			
			this.totalTextBox.Text = v_total_sum.ToString("0.##");
			
		}
		
		void UspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridViewCellEndEdit(object sender, DataGridViewCellEventArgs e)
		{
			if ((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13")
			    ||((this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11")))
			{
				this.Warehouse_income_calculate();
			}
		}
		//Процедура подготовки детальной таблицы для записи 
		void Prepare_Detail ()
		{
			 foreach(DataGridViewRow currentRow in this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdDataGridView.Rows)
			 {
			 	currentRow.Cells[dataGridViewTextBoxColumn8.Index].Value = this.idTextBox.Text;
    		 }
		}
		
		void uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingNavigatorSaveItemClick(object sender, EventArgs e)
		{
			Nullable<decimal> v_id = new Nullable<decimal>();
			
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
					this.Validate();
					this.uspVWRH_WRH_INCOME_MASTER_SelectAllBindingSource.EndEdit();
					this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
					this.uspVWRH_WRH_INCOME_MASTER_SelectAllTableAdapter.Update(ref v_id
					                                                            ,this.numberTextBox.Text
					                                                            ,(decimal)Convert.ChangeType(this.organization_idTextBox.Text, typeof(decimal))
					                                                            ,(decimal)Convert.ChangeType(this.warehouse_type_idTextBox.Text, typeof(decimal))
					                                                            ,(DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime))
					                                                            ,(decimal)Convert.ChangeType(this.totalTextBox.Text, typeof(decimal))
					                                                            ,(decimal)Convert.ChangeType(this.org_recieve_idtextBox.Text, typeof(decimal))
					                                                            ,this.sys_commentTextBox.Text
					                                                            ,this.sys_user_modifiedTextBox.Text);
					this.idTextBox.Text = v_id.ToString();
					this.Prepare_Detail();
					this.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_IdTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_Id);
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
							MessageBox.Show("Такой 'Приходный документ' уже существует");
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
	}
}
