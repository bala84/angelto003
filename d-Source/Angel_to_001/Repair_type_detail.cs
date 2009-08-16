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
	public partial class Repair_type_detail : Form
	{
        public string _username;

		public string Repair_type_master_id
		{
			get { return this.idTextBox.Text; }
		}
		public string Repair_type_master_short_name
		{
			get { return this.short_nameTextBox.Text; }
		}
		public string Repair_type_master_full_name
		{
			get { return this.full_nameTextBox.Text; }
		}
		public string Repair_type_master_code
		{
			get { return this.codeTextBox.Text; }
		}
		public string Repair_type_master_time_to_repair_in_minutes
		{
			get { return this.time_to_repair_in_minutesTextBox.Text; }
		}

        public string Repair_type_master_is_ts
        {
            get { return this.is_tstextBox.Text; }
        }

        public string Repair_type_master_repair_type_master_kind_id
        {
            get { return this.repair_type_kind_idtextBox.Text; }
        }

        public string Repair_type_master_repair_type_master_kind_sname
        {
            get { return this.repair_type_kindtextBox.Text; }
        }
		
		public string _repair_type_master_id;
		public string _repair_type_master_short_name;
		public string _repair_type_master_full_name;
		public string _repair_type_master_code;
		public string _repair_type_master_time_to_repair_in_minutes;
        public string _repair_type_master_is_ts;

        public string _repair_type_master_repair_type_master_kind_id;

        public string _repair_type_master_repair_type_master_kind_sname;
		
		private bool _is_valid = true;
		//Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
		public byte _repair_type_master_form_state;
		
		public Repair_type_detail()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}
		
		//Процедура подготовки детальной таблицы для записи
		void Prepare_Detail ()
		{
			try
			{
				foreach(DataGridViewRow currentRow in this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.Rows)
				{
					currentRow.Cells[dataGridViewTextBoxColumn13.Index].Value = this.idTextBox.Text;
				}
			}
			catch{}
		}

		private void uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
			
			

			Nullable<decimal> v_id = new Nullable<decimal>();
			Nullable<int> v_time_to_repair_in_minutes = new Nullable<int>();
            Nullable<decimal> v_repair_type_master_kind_id = new Nullable<decimal>();
			
			if   ((this.short_nameTextBox.Text != ""))
			{
				try
				{
					if (this.idTextBox.Text != "")
					{
						v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
					}
					this.Validate();
					this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllBindingSource.EndEdit();
					this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
					
					if (this._repair_type_master_form_state == 3)
					{
                        this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))), "-", _username);
					}
					else
					{
						if (this.time_to_repair_in_minutesTextBox.Text != "")
						{
							 v_time_to_repair_in_minutes = (int)Convert.ChangeType(this.time_to_repair_in_minutesTextBox.Text, typeof(int));
						}

                        if (this.repair_type_kind_idtextBox.Text != "")
                        {
                            v_repair_type_master_kind_id = (decimal)Convert.ChangeType(this.repair_type_kind_idtextBox.Text, typeof(decimal));
                        }
						this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllTableAdapter.Update(ref v_id
						                                                             ,this.short_nameTextBox.Text
						                                                             ,this.short_nameTextBox.Text
						                                                             ,this.codeTextBox.Text
						                                                             ,v_time_to_repair_in_minutes
                                                                                     ,v_repair_type_master_kind_id
						                                                             ,this.sys_commentTextBox.Text
						                                                             ,this.sys_user_modifiedTextBox.Text);
					}
					if (this._repair_type_master_form_state != 3)
					{
						this.idTextBox.Text = v_id.ToString();
						this.p_repair_type_master_idToolStripTextBox.Text = v_id.ToString();
						this.Prepare_Detail();
						this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdTableAdapter.Update(this.aNGEL_TO_001.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_Id);
					}
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(true);
					_is_valid = true;
					if (this._repair_type_master_form_state != 3)
					{
						this.UspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(sender, e);
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
                            MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись!");
                            break;

						case 2601:
							MessageBox.Show("Такая 'Деталь' уже существует");
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


		private void Repair_type_detail_Load(object sender, EventArgs e)
		{
			// TODO: This line of code loads data into the 'aNGEL_TO_001.uspVRPR_REPAIR_TYPE_MASTER_SelectAll' table. You can move, or remove it, as needed.
			//   this.uspVRPR_REPAIR_TYPE_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_TYPE_MASTER_SelectAll);
			
			
			if (_repair_type_master_id != "")
			{
				this.idTextBox.Text = _repair_type_master_id;
				this.p_repair_type_master_idToolStripTextBox.Text = _repair_type_master_id;
			}
			
			if (_repair_type_master_code != "")
			{
				this.codeTextBox.Text = _repair_type_master_code;
			}
			
			if (_repair_type_master_short_name != "")
			{
				this.short_nameTextBox.Text = _repair_type_master_short_name;
			}
			
			if (_repair_type_master_full_name != "")
			{
				this.full_nameTextBox.Text = _repair_type_master_full_name;
			}
			
			if (_repair_type_master_time_to_repair_in_minutes != "")
			{
				this.time_to_repair_in_minutesTextBox.Text = _repair_type_master_time_to_repair_in_minutes;
			}

            if (_repair_type_master_is_ts != "")
            {
                this.is_tstextBox.Text = _repair_type_master_is_ts;
            }

            if (_repair_type_master_repair_type_master_kind_id != "")
            {
                this.repair_type_kind_idtextBox.Text = _repair_type_master_repair_type_master_kind_id;
            }

            if (_repair_type_master_repair_type_master_kind_sname != "")
            {
                this.repair_type_kindtextBox.Text = _repair_type_master_repair_type_master_kind_sname;
            }
			
			this.Text = this.Text + " вид ремонта";
			
			if (this.p_repair_type_master_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_type_master_idToolStripTextBox.Text, typeof(decimal))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			if (_repair_type_master_form_state == 3)
			{
				this.BackColor = Color.Red;
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = false;
				this.codeTextBox.Enabled = false;
				this.short_nameTextBox.Enabled = false;
				this.time_to_repair_in_minutesTextBox.Enabled = false;
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
				this.contextMenuStrip1.Enabled = false;
				this._is_valid = false;
				Ok_Toggle(true);
			}
			else
			{
				this.BackColor = System.Drawing.SystemColors.Control;
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = true;
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
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click(sender, e);
			}
		}
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
			if (this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1)
			{
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingSource.AddNew();
			}

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.BeginEdit(false);
				if ((this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn9")
				    ||(this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn10")
				    ||(this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11"))
				{
					using (Good_category Good_categoryForm = new Good_category())
					{
						Good_categoryForm.ShowDialog(this);
						if (Good_categoryForm.DialogResult == DialogResult.OK)
						{

							this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
								= Good_categoryForm.Good_category_good_mark;
							this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
								= Good_categoryForm.Good_category_sname;
							this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
								= Good_categoryForm.Good_category_unit;
							this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
								= Good_categoryForm.Good_category_id;
							_is_valid &= false;
							Ok_Toggle(_is_valid);
						}
					}
				}
			}
			catch (Exception Appe)
			{}
		}
		
		void DeleteToolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				     == this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				    &&(this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
					    == this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
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
		
		void UspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
			_is_valid = false;
			Ok_Toggle(_is_valid);
		}
		
		void CodeTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid = false;
			Ok_Toggle(_is_valid);
		}
		
		void Time_to_repair_in_minutesTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid = false;
			Ok_Toggle(_is_valid);
		}

        private void uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingNavigator_RefreshItems(object sender, EventArgs e)
        {

        }

        private void button_cancel_Click(object sender, EventArgs e)
        {

        }

        private void button_repair_type_kind_Click(object sender, EventArgs e)
        {
            using (Repair_type_kind_chooser Repair_type_kind_chooserForm = new Repair_type_kind_chooser())
            {
                if (this.is_tstextBox.Text == "1")
                {
                    Repair_type_kind_chooserForm._where_clause = "id = " + Const.Addtnl_to_repair_type.ToString()
                                                                + " or id = " + Const.To_repair_type.ToString();
                }
                else
                {
                    Repair_type_kind_chooserForm._where_clause = "id = " + Const.Addtnl_repair_type.ToString()
                                                               + " or id = " + Const.Common_repair_type.ToString();
                }

                Repair_type_kind_chooserForm.ShowDialog(this);
                if (Repair_type_kind_chooserForm.DialogResult == DialogResult.OK)
                {

                    this.repair_type_kind_idtextBox.Text
                        = Repair_type_kind_chooserForm.Repair_type_kind_id;
                    this.repair_type_kindtextBox.Text
                        = Repair_type_kind_chooserForm.Repair_type_kind_short_name;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
                }
            }
        }
	}
}
