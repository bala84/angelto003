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
	public partial class Ts_type_detail : Form
	{
        public string _username;

		public string _ts_type_master_id;
		public string _ts_type_master_short_name;
		public string _ts_type_master_full_name;
		public string _ts_type_master_periodicity;
		public string _ts_type_master_car_mark_id;
		public string _ts_type_master_car_mark_model_name;
		public string _ts_type_master_car_model_id;
		public string _ts_type_master_tolerance;
		public string _ts_type_master_car_mark_sname;
		public string _ts_type_master_car_model_sname;

        public string _ts_type_master_repair_type_master_kind_id;

        public string _ts_type_master_repair_type_master_kind_sname;

		//Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
		public byte _ts_type_master_form_state;

		//public string _ts_type_master_child_ts_type_array;

		//private string _ts_type_master_child_ts_type_array_tmp = "";
		
		private bool _is_valid = true;




		

		public Ts_type_detail()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}

		
		

		public string Ts_type_master_id
		{
			get { return this.idTextBox.Text; }
		}
		public string Ts_type_master_short_name
		{
			get { return this.short_nameTextBox.Text; }
		}
		public string Ts_type_master_full_name
		{
			get { return this.full_nameTextBox.Text; }
		}
		public string Ts_type_master_periodicity
		{
			get { return this.periodicityTextBox.Text; }
		}
		public string Ts_type_master_car_mark_id
		{
			get { return this.car_mark_idTextBox.Text; }
		}

		public string Ts_type_master_car_mark_model_name
		{
			get { return this.car_mark_model_nameTextBox.Text; }
		}

		public string Ts_type_master_car_model_id
		{
			get { return this.car_model_idTextBox.Text; }
		}

		public string Ts_type_master_tolerance
		{
			get { return this.toleranceTextBox.Text; }
		}

		public string Ts_type_master_car_mark_sname
		{
			get { return this.car_mark_snameTextBox.Text; }
		}

		public string Ts_type_master_car_model_sname
		{
			get { return this.car_model_snameTextBox.Text; }
		}

        public string Ts_type_master_repair_type_master_kind_id
        {
            get { return this.repair_type_kind_idtextBox.Text; }
        }

        public string Ts_type_master_repair_type_master_kind_sname
        {
            get { return this.repair_type_kindtextBox.Text; }
        }


		private void utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
			

			Nullable<decimal> v_id = new Nullable<decimal>();
			Nullable<decimal> v_parent_id = new Nullable<decimal>();
            Nullable<decimal> v_repair_type_master_kind_id = new Nullable<decimal>();
			string v_code = "";
			Nullable<int> v_time_to_repair_in_minutes = new Nullable<int>();
			
			if   ((this.short_nameTextBox.Text != "")
			      &&(this.periodicityTextBox.Text != "")
			      &&(this.toleranceTextBox.Text != "")
			      &&(this.car_mark_snameTextBox.Text != "")
			      &&(this.car_model_snameTextBox.Text != "")
			     )
			{
				try
				{
					if (this.idTextBox.Text != "")
					{
						v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
					}
					this.Validate();
					this.uspVCAR_TS_TYPE_MASTER_SelectAllBindingSource.EndEdit();
					this.uspVCAR_TS_TYPE_MASTER_SelectByParent_IdBindingSource.EndEdit();
					this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
					
					if (this._ts_type_master_form_state == 3)
					{
						this.uspVCAR_TS_TYPE_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))));
					}
					else
					{
						if (this.p_parent_idToolStripTextBox.Text != "")
						{
							
							v_parent_id	= (decimal)Convert.ChangeType(this.p_parent_idToolStripTextBox.Text, typeof(decimal));
						}

                        if (this.codeTextBox.Text != "")
                        {

                            v_code = this.codeTextBox.Text;
                        }

                        if (this.time_to_repair_in_minutesTextBox.Text != "")
                        {

                            v_time_to_repair_in_minutes = (int)Convert.ChangeType(this.time_to_repair_in_minutesTextBox.Text, typeof(int));
                        }

                        if (this.repair_type_kind_idtextBox.Text != "")
                        {

                            v_repair_type_master_kind_id = (decimal)Convert.ChangeType(this.repair_type_kind_idtextBox.Text, typeof(decimal));
                        }

						this.uspVCAR_TS_TYPE_MASTER_SelectAllTableAdapter.Update(ref v_id
						                                                         ,this.short_nameTextBox.Text
						                                                         ,this.short_nameTextBox.Text
						                                                         ,new System.Nullable<int> ((int)Convert.ChangeType(this.periodicityTextBox.Text, typeof(int)))
						                                                         ,new System.Nullable<decimal> ((decimal)Convert.ChangeType(this.car_mark_idTextBox.Text, typeof(decimal)))
						                                                         ,new System.Nullable<decimal> ((decimal)Convert.ChangeType(this.car_model_idTextBox.Text, typeof(decimal)))
						                                                         ,new System.Nullable<short> ((short)Convert.ChangeType(this.toleranceTextBox.Text, typeof(short)))
						                                                         ,v_parent_id
						                                                         ,v_code
						                                                         ,v_time_to_repair_in_minutes
                                                                                 ,v_repair_type_master_kind_id
						                                                         ,this.sys_commentTextBox.Text
						                                                         ,this.sys_user_modifiedTextBox.Text);
					}
					if (this._ts_type_master_form_state != 3)
					{
						this.idTextBox.Text = v_id.ToString();
						this.p_repair_type_master_idToolStripTextBox.Text = v_id.ToString();
						Just.Prepare_Detail(this.dataGridViewTextBoxColumn13.Index, this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.Rows, v_id.ToString());
						Just.Prepare_Detail(this.dataGridViewTextBoxColumn21.Index, this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.Rows, v_id.ToString());
						this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdTableAdapter.Update(this.ANGEL_TO_001.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_Id);
						this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idTableAdapter.Update(this.ANGEL_TO_001.uspVCAR_TS_TYPE_RELATION_SelectByParent_id);
					}
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(true);
					_is_valid = true;
					if (this._ts_type_master_form_state != 3)
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
							MessageBox.Show("Такой 'Вид ТО' или 'Деталь' в этом ТО уже существует");
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

		private void Ts_type_detail_Load(object sender, EventArgs e)
		{
			

			this.Text = this.Text + " вид ТО";
			if ((_ts_type_master_id != "")
			    && (_ts_type_master_id != null))
			{
				this.idTextBox.Text = _ts_type_master_id;
				this.p_repair_type_master_idToolStripTextBox.Text = _ts_type_master_id;
				this.p_parent_idToolStripTextBox.Text = _ts_type_master_id;
			}
			if ((_ts_type_master_short_name != "")
			    && (_ts_type_master_short_name != null))
			{
				this.short_nameTextBox.Text = _ts_type_master_short_name;
			}
			if ((_ts_type_master_periodicity != "")
			    && (_ts_type_master_periodicity != null))
			{
				this.periodicityTextBox.Text = _ts_type_master_periodicity;
			}
			if ((_ts_type_master_car_mark_id != "")
			    && (_ts_type_master_car_mark_id != null))
			{
				this.car_mark_idTextBox.Text = _ts_type_master_car_mark_id;
			}
			if ((_ts_type_master_car_mark_model_name != "")
			    && (_ts_type_master_car_mark_model_name != null))
			{
				this.car_mark_model_nameTextBox.Text = _ts_type_master_car_mark_model_name;
			}
			if ((_ts_type_master_car_model_id != "")
			    && (_ts_type_master_car_model_id != null))
			{
				this.car_model_idTextBox.Text = _ts_type_master_car_model_id;
			}
			if ((_ts_type_master_tolerance != "")
			    && (_ts_type_master_tolerance != null))
			{
				this.toleranceTextBox.Text = _ts_type_master_tolerance;
			}
			if ((_ts_type_master_car_mark_sname != "")
			    && (_ts_type_master_car_mark_sname != null))
			{
				this.car_mark_snameTextBox.Text = _ts_type_master_car_mark_sname;
			}
			if ((_ts_type_master_car_model_sname != "")
			    && (_ts_type_master_car_model_sname != null))
			{
				this.car_model_snameTextBox.Text = _ts_type_master_car_model_sname;
			}

            if (_ts_type_master_repair_type_master_kind_id != "")
            {
                this.repair_type_kind_idtextBox.Text = _ts_type_master_repair_type_master_kind_id;
            }

            if (_ts_type_master_repair_type_master_kind_sname != "")
            {
                this.repair_type_kindtextBox.Text = _ts_type_master_repair_type_master_kind_sname;
            }

			if (this.periodicityTextBox.Text == "")
			{
				this.periodicityTextBox.Text = "0";
			}

			if (this.toleranceTextBox.Text == "")
			{
				this.toleranceTextBox.Text = "0";
			}
			if (this.p_parent_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idTableAdapter.Fill(this.ANGEL_TO_001.uspVCAR_TS_TYPE_RELATION_SelectByParent_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_parent_idToolStripTextBox.Text, typeof(decimal))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			
			if (this.p_repair_type_master_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.ANGEL_TO_001.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_type_master_idToolStripTextBox.Text, typeof(decimal))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			
			if (_ts_type_master_form_state == 3)
			{
				this.BackColor = Color.Red;
				this.utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem.Enabled = false;
				this.periodicityTextBox.Enabled = false;
				this.short_nameTextBox.Enabled = false;
				this.toleranceTextBox.Enabled = false;
				this.button_mark.Enabled = false;
				this.button_model.Enabled = false;
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
				this.contextMenuStrip1.Enabled = false;
				_is_valid = false;
				Ok_Toggle(true);
			}
			else
			{
				this.BackColor = System.Drawing.SystemColors.Control;
				this.utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem.Enabled = true;
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


		private void button_mark_Click(object sender, EventArgs e)
		{
			using (Car_mark Car_markForm = new Car_mark())
			{
				Car_markForm.ShowDialog(this);
				if (Car_markForm.DialogResult == DialogResult.OK)
				{

					this.car_mark_snameTextBox.Text
						= Car_markForm.Mark_short_name;
					this.car_mark_idTextBox.Text
						= Car_markForm.Mark_id;
				}
			}
		}

		private void button_model_Click(object sender, EventArgs e)
		{
			using (Car_model Car_modelForm = new Car_model())
			{
				Car_modelForm.Mark_id
					= this.car_mark_idTextBox.Text;
				Car_modelForm.Mark_short_name
					= this.car_mark_snameTextBox.Text;
				Car_modelForm.ShowDialog(this);
				if (Car_modelForm.DialogResult == DialogResult.OK)
				{

					this.car_model_snameTextBox.Text
						= Car_modelForm.Model_short_name;
					this.car_model_idTextBox.Text
						= Car_modelForm.Model_id;
				}
			}
		}


		private void short_nameTextBox_Validated(object sender, EventArgs e)
		{
			if (Is_Short_Name_Valid())
			{
				this.Short_name_errorProvider.SetError(this.short_nameTextBox, "");
				this.short_nameTextBox.BackColor
					= System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
			}
			else
			{
				this.Short_name_errorProvider.SetError(this.short_nameTextBox, "Необходимо ввести 'Вид ТО'");
				this.short_nameTextBox.BackColor
					= Color.Red;
			}
			
		}


		private void periodicityTextBox_Validated(object sender, EventArgs e)
		{
			if (Is_Periodicity_Valid())
			{
				this.Periodicity_errorProvider.SetError(this.periodicityTextBox, "");
				this.periodicityTextBox.BackColor
					= System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
			}
			else
			{
				this.Periodicity_errorProvider.SetError(this.periodicityTextBox, "Необходимо ввести 'Периодичность'");
				this.periodicityTextBox.BackColor
					= Color.Red;
			}
			
		}

		private void toleranceTextBox_Validated(object sender, EventArgs e)
		{
			if (Is_Tolerance_Valid())
			{
				this.Tolerance_errorProvider.SetError(this.toleranceTextBox, "");
				this.toleranceTextBox.BackColor
					= System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
			}
			else
			{
				this.Tolerance_errorProvider.SetError(this.toleranceTextBox, "Необходимо ввести 'Допуск'");
				this.toleranceTextBox.BackColor
					= Color.Red;
			}


		}

		private void car_mark_snameTextBox_Validated(object sender, EventArgs e)
		{

			if (Is_Car_Mark_Valid())
			{
				this.Car_mark_errorProvider.SetError(this.car_mark_snameTextBox, "");
				this.car_mark_snameTextBox.BackColor
					= System.Drawing.SystemColors.Control;
			}
			else
			{
				this.Car_mark_errorProvider.SetError(this.car_mark_snameTextBox, "Необходимо ввести 'Марку'");
				this.car_mark_snameTextBox.BackColor
					= Color.Red;
			}

		}

		private void car_model_snameTextBox_Validated(object sender, EventArgs e)
		{

			if (Is_Car_Model_Valid())
			{
				this.Car_model_errorProvider.SetError(this.car_model_snameTextBox, "");
				this.car_model_snameTextBox.BackColor
					= System.Drawing.SystemColors.Control;
			}
			else
			{
				this.Car_model_errorProvider.SetError(this.car_model_snameTextBox, "Необходимо ввести 'Модель'");
				this.car_model_snameTextBox.BackColor
					= Color.Red;
			}

		}

		private bool Is_Short_Name_Valid()
		{
			return (this.short_nameTextBox.Text.Length != 0);
		}

		private bool Is_Periodicity_Valid()
		{
			return (this.periodicityTextBox.Text.Length != 0);
		}

		private bool Is_Car_Model_Valid()
		{
			return (this.car_model_snameTextBox.Text.Length != 0);
		}

		private bool Is_Car_Mark_Valid()
		{
			return (this.car_mark_snameTextBox.Text.Length != 0);
		}

		private bool Is_Tolerance_Valid()
		{
			return (this.toleranceTextBox.Text.Length != 0);
		}

		private void button_ok_Click(object sender, EventArgs e)
		{
			//this.Validate();
			if (_is_valid == false)
			{
				this.utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem_Click(sender, e);
			}
			
		}

		private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
		{
			if (this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.RowCount != 1)
			{
				this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idBindingSource.AddNew();
			}

		}

		private void EditToolStripMenuItem_Click(object sender, EventArgs e)
		{
			try
			{
				this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.BeginEdit(false);

				using (Ts_type Ts_typeForm = new Ts_type())
				{
					if ((_ts_type_master_id != null) && (_ts_type_master_id != ""))
					{
						Ts_typeForm._where_clause = "id <> " + _ts_type_master_id;
					}
					Ts_typeForm.ShowDialog(this);
					if (Ts_typeForm.DialogResult == DialogResult.OK)
					{

						this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Ts_typeForm.Ts_type_id;
						this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
							= Ts_typeForm.Ts_type_sname;
						/*if ((_ts_type_master_id != null) && (_ts_type_master_id != ""))
						{
							this.uspVCAR_TS_TYPE_MASTER_SelectByParent_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21/.Index].Value
								= _ts_type_master_id;
						}*/
						/*_ts_type_master_child_ts_type_array_tmp =
							_ts_type_master_child_ts_type_array_tmp + "<id>"
							+ this.uspVCAR_TS_TYPE_MASTER_SelectByParent_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString() + "</id>";*/

						//MessageBox.Show(this.uspVCAR_TS_TYPE_MASTER_SelectByParent_IdDataGridView.CurrentRow.Index.ToString());
					}
				}
			}
			catch (Exception Appe)
			{ }

		}

		private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
		{
			this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idBindingSource.RemoveCurrent();

		}


		
		void Insert2toolStripMenuItemClick(object sender, EventArgs e)
		{
			if (this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1)
			{
				this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdBindingSource.AddNew();
			}

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void Edit2toolStripMenuItemClick(object sender, EventArgs e)
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
		
		void Delete2toolStripMenuItemClick(object sender, EventArgs e)
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
					this.contextMenuStrip2.Enabled = false;
				}
				else
				{
					this.contextMenuStrip2.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
					    == this.uspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
					{
						this.Delete2toolStripMenuItem.Enabled = false;
						
						
					}
					else
					{
						this.Delete2toolStripMenuItem.Enabled = true;
						
					}
				}
				

			}
			catch (Exception Appe)
			{
			}

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
		
		void UspVRPR_REPAIR_TYPE_DETAIL_SelectByMaster_IdDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
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

		
		void UspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.CurrentRow.Index + 1)
				     == this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.RowCount)
				    && (this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.CurrentRow.Index + 1)
					    == this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.RowCount)
					{
						// this.InsertToolStripMenuItem.Enabled = false;
						this.DeleteToolStripMenuItem.Enabled = false;
					}
					else
					{
						// this.InsertToolStripMenuItem.Enabled = true;
						this.DeleteToolStripMenuItem.Enabled = true;
					}
				}
				
			}
			catch (Exception Appe)
			{
			}
			
		}
		
		void UspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.CurrentRow.Index + 1)
				    != this.uspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void UspVCAR_TS_TYPE_RELATION_SelectByParent_idDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void button_repair_type_kind_Click(object sender, EventArgs e)
        {
            using (Repair_type_kind_chooser Repair_type_kind_chooserForm = new Repair_type_kind_chooser())
            {
                Repair_type_kind_chooserForm._where_clause = "id = " + Const.Addtnl_to_repair_type.ToString()
                                                            + " or id = " + Const.To_repair_type.ToString();
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
