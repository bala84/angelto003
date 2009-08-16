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
	public partial class Warehouse_item : Form
	{
        public string _username;
		
		private bool _is_valid = true;
		
		public Warehouse_item()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}

		private void uspVWRH_WAREHOUSE_ITEM_SelectByType_idBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
			if (//(this.p_good_category_type_idToolStripTextBox.Text != "")
			    // &&
			    (this.p_warehouse_type_idToolStripTextBox.Text != "")
			   )
			{
				try
				{

					this.Validate();
					this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idBindingSource.EndEdit();
					this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WAREHOUSE_ITEM_SelectByType_id);
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
					_is_valid = true;
					this.UspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridViewCurrentCellChanged(sender, e);
					
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
							P_good_category_type_idToolStripTextBoxTextChanged(sender, e);
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
					MessageBox.Show("Ошибка");
					MessageBox.Show("Сообщение: " + Appe.Message);
				}
			}
		}

		
		void Button_warehouse_typeClick(object sender, EventArgs e)
		{
			using (Warehouse_type Warehouse_typeForm = new Warehouse_type())
			{
				Warehouse_typeForm.ShowDialog(this);
				if (Warehouse_typeForm.DialogResult == DialogResult.OK)
				{

					this.warehouse_type_name_textBox.Text
						= Warehouse_typeForm.Warehouse_type_short_name;
					this.p_warehouse_type_idToolStripTextBox.Text
						= Warehouse_typeForm.Warehouse_type_id;
				}
			}
		}
		
		void Button_good_category_typeClick(object sender, EventArgs e)
		{
			using (Good_category_type Good_category_typeForm = new Good_category_type())
			{
				Good_category_typeForm.ShowDialog(this);
				if (Good_category_typeForm.DialogResult == DialogResult.OK)
				{

					this.good_category_type_name_textBox.Text
						= Good_category_typeForm.Good_category_type_short_name;
					this.p_good_category_type_idToolStripTextBox.Text
						= Good_category_typeForm.Good_category_type_id;
				}
			}
		}
		
		
		void P_good_category_type_idToolStripTextBoxTextChanged(object sender, EventArgs e)
		{
			
			System.Nullable<decimal> v_organization_id = new System.Nullable<decimal>();
			if (this.organization_idtextBox.Text != "")
			{
				v_organization_id = (decimal)Convert.ChangeType(this.organization_idtextBox.Text, typeof(decimal));
			}
			//this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idBindingNavigatorSaveItem_Click (sender, e);
			if ((this.p_good_category_type_idToolStripTextBox.Text != "")
			    &&(this.p_warehouse_type_idToolStripTextBox.Text != ""))
			{
				try
				{
					this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WAREHOUSE_ITEM_SelectByType_id
					                                                             , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_type_idToolStripTextBox.Text, typeof(decimal)))))
					                                                             , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_warehouse_type_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                 , v_organization_id
					                                                             , this.p_searchtextBox.Text
					                                                             , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
					                                                             , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			
			
		}
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
			if (this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.RowCount != 1)
			{
				this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idBindingSource.AddNew();
			}

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.BeginEdit(false);
			if ((this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11")
			    ||(this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn12")
			    ||(this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13"))
			{
				using (Good_category Good_categoryForm = new Good_category())
				{
					Good_categoryForm.ShowDialog(this);
					if (Good_categoryForm.DialogResult == DialogResult.OK)
					{

						this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Good_categoryForm.Good_category_good_mark;
						this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Good_categoryForm.Good_category_sname;
						this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
							= Good_categoryForm.Good_category_unit;
						this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
							= Good_categoryForm.Good_category_id;
						this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= this.p_warehouse_type_idToolStripTextBox.Text;
						_is_valid &= false;
						Ok_Toggle(_is_valid);
					}
				}
			}
		}
		
		void DeleteToolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void UspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Index + 1)
				     == this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.RowCount)
				    &&(this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Index + 1)
					    == this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.RowCount)
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
		
		void UspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void Button_okClick(object sender, EventArgs e)
		{
			this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idBindingNavigatorSaveItem_Click(sender, e);
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
		
		void UspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridView.RowCount)
				{
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVWRH_WAREHOUSE_ITEM_SelectByType_idDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
			P_good_category_type_idToolStripTextBoxTextChanged(sender, e);
			P_warehouse_type_idToolStripTextBoxTextChanged(sender, e);
		}
		
		void Warehouse_itemLoad(object sender, EventArgs e)
		{//заполним пока поле поиска первой буквой алфавита
			//TODO: обработка наиболее частых поисков
			p_searchtextBox.Text = "";
			p_search_typetextBox.Text = Const.Pt_search.ToString();
			p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
		}
		
		void P_warehouse_type_idToolStripTextBoxTextChanged(object sender, EventArgs e)
		{
			System.Nullable<decimal> v_good_category_type_id = new System.Nullable<decimal>();
			System.Nullable<decimal> v_organization_id = new System.Nullable<decimal>();
			if (p_good_category_type_idToolStripTextBox.Text != "")
			{
				v_good_category_type_id = (decimal)Convert.ChangeType(p_good_category_type_idToolStripTextBox.Text, typeof(decimal));
			}
			if (this.organization_idtextBox.Text != "")
			{
				v_organization_id = (decimal)Convert.ChangeType(this.organization_idtextBox.Text, typeof(decimal));
			}
			
			if (this.p_warehouse_type_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WAREHOUSE_ITEM_SelectByType_id
					                                                             , v_good_category_type_id
					                                                             , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_warehouse_type_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                 , v_organization_id
					                                                             ,((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
					                                                             , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
					                                                             , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
					                                                             );
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
		}
		
		void Button_organizationClick(object sender, EventArgs e)
		{
			using (Organization OrganizationForm = new Organization())
			{
				OrganizationForm.ShowDialog(this);
				if (OrganizationForm.DialogResult == DialogResult.OK)
				{

					this.organization_snametextBox.Text
						= OrganizationForm.Org_sname;
					this.organization_idtextBox.Text
						= OrganizationForm.Org_id;
				}
			}
		}
		
		void Button_clear_orgClick(object sender, EventArgs e)
		{
			this.organization_snametextBox.Text
				= "";
			this.organization_idtextBox.Text
				= "";
		}
		
		
		
		void Organization_idtextBoxTextChanged(object sender, EventArgs e)
		{
			System.Nullable<decimal> v_good_category_type_id = new System.Nullable<decimal>();
			System.Nullable<decimal> v_organization_id = new System.Nullable<decimal>();
			if (p_good_category_type_idToolStripTextBox.Text != "")
			{
				v_good_category_type_id = (decimal)Convert.ChangeType(p_good_category_type_idToolStripTextBox.Text, typeof(decimal));
			}
			if (this.organization_idtextBox.Text != "")
			{
				v_organization_id = (decimal)Convert.ChangeType(this.organization_idtextBox.Text, typeof(decimal));
			}
			
			if (this.p_warehouse_type_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVWRH_WAREHOUSE_ITEM_SelectByType_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WAREHOUSE_ITEM_SelectByType_id
					                                                             , v_good_category_type_id
					                                                             , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_warehouse_type_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                 , v_organization_id
                                                                                 ,((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
					                                                             , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
					                                                             , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
					                                                             );
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
		}
	}
}
