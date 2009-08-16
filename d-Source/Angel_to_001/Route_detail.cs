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
	public partial class Route_detail : Form
	{
        public string _username;

		private bool _is_valid = true;
		//Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
		public byte _route_master_form_state;
		public string _route_master_master_id;
		public string _route_master_master_sname;
		
		public string Route_master_master_id
		{
			get { return this.idTextBox.Text; }
		}
		
		public string Route_master_master_sname
		{
			get { return this.short_nameTextBox.Text; }
		}
		
		public Route_detail()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}
		

		private void uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
			
			Nullable<decimal> v_id = new Nullable<decimal>();
			Nullable<decimal> v_car_id = new Nullable<decimal> ();
			
			if   (this.short_nameTextBox.Text != "")
				
			{
				try
				{
					if (this.idTextBox.Text != "")
					{
						v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
					}
					this.Validate();
					this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllBindingSource.EndEdit();
					this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingSource.EndEdit();
					if (this._route_master_form_state == 3)
					{
						this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal)))
                                                                                       , "-", _username);
					}
					else
					{
						
						this.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAllTableAdapter.Update(ref v_id
						                                                               ,this.short_nameTextBox.Text
						                                                               ,this.full_nameTextBox.Text
						                                                               ,this.sys_commentTextBox.Text
						                                                               ,this.sys_user_modifiedTextBox.Text);
					}
					if (this._route_master_form_state != 3)
					{
						this.idTextBox.Text = v_id.ToString();
						this.p_ts_type_route_master_idToolStripTextBox.Text = v_id.ToString();
						Just.Prepare_Detail(dataGridViewTextBoxColumn10.Index, this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.Rows, this.idTextBox.Text);
						this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idTableAdapter.Update(this.aNGEL_TO_001.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_id);
					}
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(true);
					_is_valid = true;
					if (this._route_master_form_state != 3)
					{
						this.UspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridViewCurrentCellChanged(sender, e);
					}
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
							                +"Проверьте, что у данной очередности нет заведенного состояния. ");
							if (this.p_ts_type_route_master_idToolStripTextBox.Text != "")
							{
								try
								{
									this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idTableAdapter.Fill(this.aNGEL_TO_001.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_ts_type_route_master_idToolStripTextBox.Text, typeof(decimal))))));
								}
								catch (System.Exception ex)
								{
									System.Windows.Forms.MessageBox.Show(ex.Message);
								}
							}
							break;

						case 2601:
							MessageBox.Show("Такая 'Очередность' уже существует");
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
		}

		private void fillToolStripButton_Click(object sender, EventArgs e)
		{


		}

		private void Route_detail_Load(object sender, EventArgs e)
		{
			// TODO: This line of code loads data into the 'aNGEL_TO_001.uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAll' table. You can move, or remove it, as needed.
			
			if ( _route_master_master_id != "")
			{
				this.idTextBox.Text = _route_master_master_id;
				this.p_ts_type_route_master_idToolStripTextBox.Text = _route_master_master_id;
			}
			
			if ( _route_master_master_sname != "")
			{
				this.short_nameTextBox.Text = _route_master_master_sname;
			}
			
			this.Text = this.Text + " очередность ТО";
			
			if (this.p_ts_type_route_master_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idTableAdapter.Fill(this.aNGEL_TO_001.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_ts_type_route_master_idToolStripTextBox.Text, typeof(decimal))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			
			if (_route_master_form_state == 3)
			{
				this.BackColor = Color.Red;
				this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingNavigatorSaveItem.Enabled = false;
				this.short_nameTextBox.Enabled = false;
				this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.Enabled = false;
				this.contextMenuStrip1.Enabled = false;
				Ok_Toggle(true);
			}
			else
			{
				this.BackColor = System.Drawing.SystemColors.Control;
				this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingNavigatorSaveItem.Enabled = true;
				Ok_Toggle(_is_valid);
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
		
		
		void Button_okClick(object sender, EventArgs e)
		{
			if (_is_valid == false)
			{
				this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingNavigatorSaveItem_Click(sender, e);
			}
		}
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
            if (this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.RowCount == 1)
            {
                this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingSource.AddNew();
                this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingSource.AddNew();
            }

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{
				this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.BeginEdit(false);
				
				if (this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn8")
				{
					using (Ts_type Ts_typeForm = new Ts_type())
					{
						Ts_typeForm.ShowDialog(this);
						if (Ts_typeForm.DialogResult == DialogResult.OK)
						{

							this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
								= Ts_typeForm.Ts_type_sname;
							this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
								= Ts_typeForm.Ts_type_id;
							_is_valid &= false;
							Ok_Toggle(_is_valid);
						}
					}
				}
			}
			catch
			{}
		}
		
		void DeleteToolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.CurrentRow.Index + 1)
				    != this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.CurrentRow.Index + 1)
				     == this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.RowCount)
				    &&(this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.CurrentRow.Index + 1)
					    == this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.RowCount)
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
		
		void UspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.CurrentRow.Index + 1)
				    != this.uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_idDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void Short_nameTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
	}
}
