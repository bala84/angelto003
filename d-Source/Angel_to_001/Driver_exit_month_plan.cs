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
	public partial class Driver_exit_month_plan : Form
	{
        public string _username;

		private bool _is_valid = true;
		public string _row_month_index;
		private DataGridViewSelectedRowCollection _selected_rows;
		
		public Driver_exit_month_plan()
		{
			InitializeComponent();
			//Вынесем из designer инициализацию главных кнопок - чтобы не пропали(баг VS)
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}

//		private void uspVDRV_MONTH_PLAN_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
//		{
//			this.Validate();
//			this.uspVDRV_MONTH_PLAN_SelectAllBindingSource.EndEdit();
//			this.uspVDRV_MONTH_PLAN_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVDRV_MONTH_PLAN_SelectAll);
//
//		}


		private void Driver_exit_month_plan_Load(object sender, EventArgs e)
		{
			//MessageBox.Show(DateTime.Now.Month.ToString());
			p_start_dateToolStripTextBox.Text = "01." + "01." + DateTime.Now.Year.ToString();
			p_end_dateToolStripTextBox.Text = "31." + "12." + DateTime.Now.Year.ToString() + " 23:59:59";
			p_start_dateToolStripTextBox1.Text = "01." + DateTime.Now.Month.ToString() + "." + DateTime.Now.Year.ToString();
			p_end_dateToolStripTextBox1.Text = DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month) + "." + DateTime.Now.Month.ToString() + "." + DateTime.Now.Year.ToString() + " 23:59:59";
			
			try
			{
				this.uspVDRV_MONTH_PLAN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_MONTH_PLAN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))));
				this.uspVDRV_DRIVER_PLAN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime))))));
			}
			catch (System.Exception ex)
			{
				System.Windows.Forms.MessageBox.Show(ex.Message);
			}
			
			
			/*foreach(DataGridViewRow currentRow in this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.Rows)
			{
				try
				{
					MessageBox.Show(currentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString());
					if (currentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString() == "Июнь")
					{
						this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.Rows[0].Selected = false;
						this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.Rows[currentRow.Index].Selected = true;
						this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.Se;
					}
				}
				catch
				{
				}
			}*/
			

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

		private void uspVDRV_DRIVER_PLAN_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
			try
			{
				this.Validate();
				this.uspVDRV_DRIVER_PLAN_SelectAllBindingSource.EndEdit();
				this.uspVDRV_MONTH_PLAN_SelectAllBindingSource.EndEdit();
				
				this.uspVDRV_MONTH_PLAN_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVDRV_MONTH_PLAN_SelectAll);
				
				//Just.Prepare_Detail(dataGridViewTextBoxColumn58.Index, this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.Rows, this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value.ToString());
				this.uspVDRV_DRIVER_PLAN_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_SelectAll);
				this.Ok_Toggle(true);
				_is_valid = true;
				
				this.UspVDRV_MONTH_PLAN_SelectAllDataGridViewCurrentCellChanged(sender, e);
				
				this.UspVDRV_DRIVER_PLAN_SelectAllDataGridViewCurrentCellChanged(sender, e);
			}
			catch (SqlException Sqle)
			{

				switch (Sqle.Number)
				{
					case 515:
						MessageBox.Show("Необходимо заполнить все обязательные поля!");
						break;

					case 2601:
						MessageBox.Show("Такой 'План' уже существует");
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

		

		
		void Button_okClick(object sender, EventArgs e)
		{
			if (_is_valid == false)
			{
				this.uspVDRV_DRIVER_PLAN_SelectAllBindingNavigatorSaveItem_Click(sender, e);
			}
		}
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
			if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.Focused == true)
			{
                if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount == 1)
                {
                    this.uspVDRV_DRIVER_PLAN_SelectAllBindingSource.AddNew();
                    this.uspVDRV_DRIVER_PLAN_SelectAllBindingSource.RemoveCurrent();
                }
                else
                {
                    this.uspVDRV_DRIVER_PLAN_SelectAllBindingSource.AddNew();
                }
                this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn58.Index].Value
                = this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value.ToString();
			}
			
			if (this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.Focused == true)
			{
                if (this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.RowCount == 1)
                {
                    this.uspVDRV_MONTH_PLAN_SelectAllBindingSource.AddNew();
                    this.uspVDRV_MONTH_PLAN_SelectAllBindingSource.RemoveCurrent();
                }
                else
                {
                    this.uspVDRV_MONTH_PLAN_SelectAllBindingSource.AddNew();
                }
			}

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{//Выведем формы для выбора значений
			try
			{
				if (this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.Focused == true)
				{
					this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.BeginEdit(false);
					if (this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn26")
					{
						using (Date_chooser Date_chooserForm = new Date_chooser())
						{
							Date_chooserForm._date_chooser_format_type = "Custom";
							Date_chooserForm._date_chooser_format = "01.MM.yyyy";
							Date_chooserForm.ShowDialog(this);
							if (Date_chooserForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value
									= Date_chooserForm.Month_name;
								this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value
									= Date_chooserForm.Month_index;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
					
				}
				
				if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.Focused == true)
				{
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.BeginEdit(false);
					if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn9")
					{
						using (Car CarForm = new Car())
						{
							CarForm.ShowDialog(this);
							if (CarForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
									= CarForm.Car_state_number;
								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
									= CarForm.Car_id;
								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
									= "07:00";
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
					if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn10")
					{
						using (Date_chooser Date_chooserForm = new Date_chooser())
						{
							Date_chooserForm._date_chooser_format_type = "Custom";
							Date_chooserForm._date_chooser_format = "HH:00";
							Date_chooserForm.ShowDialog(this);
							if (Date_chooserForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
									= Date_chooserForm.Hour;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
					if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn12")
					{
						using (Employee EmployeeForm = new Employee())
						{
							EmployeeForm.ShowDialog(this);
							if (EmployeeForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
									= EmployeeForm.Employee_short_fio;
								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
									= EmployeeForm.Employee_id;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
					if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn14")
					{
						using (Employee EmployeeForm = new Employee())
						{
							EmployeeForm.ShowDialog(this);
							if (EmployeeForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
									= EmployeeForm.Employee_short_fio;
								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
									= EmployeeForm.Employee_id;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
					if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn16")
					{
						using (Employee EmployeeForm = new Employee())
						{
							EmployeeForm.ShowDialog(this);
							if (EmployeeForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
									= EmployeeForm.Employee_short_fio;
								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
									= EmployeeForm.Employee_id;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
					if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn18")
					{
						using (Employee EmployeeForm = new Employee())
						{
							EmployeeForm.ShowDialog(this);
							if (EmployeeForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
									= EmployeeForm.Employee_short_fio;
								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
									= EmployeeForm.Employee_id;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
					
					if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn61")
					{
						using (Organization OrganizationForm = new Organization())
						{
							OrganizationForm.ShowDialog(this);
							if (OrganizationForm.DialogResult == DialogResult.OK)
							{

								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn60.Index].Value
									= OrganizationForm.Org_id;
								this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn61.Index].Value
									= OrganizationForm.Org_sname;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
                    this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn58.Index].Value
                        = this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value.ToString();
				}
			}
			catch (Exception Appe)
			{}
		}
		
		
		void DeleteToolStripMenuItemClick(object sender, EventArgs e)
		{
			if (this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.Focused == true)
			{
				this.uspVDRV_MONTH_PLAN_SelectAllBindingSource.RemoveCurrent();
			}
			if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.Focused == true)
			{
				this.uspVDRV_DRIVER_PLAN_SelectAllBindingSource.RemoveCurrent();
			}
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVDRV_MONTH_PLAN_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			//Обработаем элементы контекстного меню
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
				    != this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					//this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
				     == this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.RowCount)
				    &&(this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
					    == this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.RowCount)
					{
						this.DeleteToolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;
						
						
					}
					else
					{
						this.DeleteToolStripMenuItem.Enabled = true;
                        this.DeleteToolStripMenuItem.Enabled = true;
						
					}
				}
				

			}
			catch (Exception Appe)
			{
			}
			
			try
			{
				//При смене месяца выведем соответствующий план
				string v_curr_month_index = this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value.ToString();
				if ((_row_month_index != "")
				    && (_row_month_index != v_curr_month_index))
				{
					p_start_dateToolStripTextBox1.Text = "01." + v_curr_month_index + "." + DateTime.Now.Year.ToString();
					p_end_dateToolStripTextBox1.Text = DateTime.DaysInMonth(DateTime.Now.Year, (Int32)Convert.ChangeType(v_curr_month_index, typeof(Int32))) + "." + v_curr_month_index + "." + DateTime.Now.Year.ToString() + " 23:59:59";
					
					
					try
					{
						
						this.uspVDRV_DRIVER_PLAN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime))))));
					}
					catch (System.Exception ex)
					{
						System.Windows.Forms.MessageBox.Show(ex.Message);
					}
                    if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount != 1)
                    {
                        this.fill_by_curr_monthtoolStripButton.Enabled = false;
                    }
                    else
                    {
                        this.fill_by_curr_monthtoolStripButton.Enabled = true;
                    }
				}
				
			}
			catch{}
		}
		
		void UspVDRV_DRIVER_PLAN_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			//Обработаем элементы контекстного меню
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
				    != this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
				     == this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount)
				    &&(this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
					    == this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount)
					{
						this.DeleteToolStripMenuItem.Enabled = false;
						
						
					}
					else
					{
						this.DeleteToolStripMenuItem.Enabled = true;
						
					}
				}


                if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount != 1)
                {
                    this.fill_by_curr_monthtoolStripButton.Enabled = false;
                }
                else
                {
                    this.fill_by_curr_monthtoolStripButton.Enabled = true;
                }


			}
			catch (Exception Appe)
			{
			}
		}
		
		void UspVDRV_MONTH_PLAN_SelectAllDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
            try
            {
                this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn24.Index].Value
                = this._username;
            }
            catch { }
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVDRV_DRIVER_PLAN_SelectAllDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
            try
            {
                this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { }
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVDRV_MONTH_PLAN_SelectAllDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
				    != this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVDRV_DRIVER_PLAN_SelectAllDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Index + 1)
				    != this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVDRV_MONTH_PLAN_SelectAllDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void UspVDRV_DRIVER_PLAN_SelectAllDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void UspVDRV_MONTH_PLAN_SelectAllDataGridViewRowLeave(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				_row_month_index = this.uspVDRV_MONTH_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value.ToString();
			}
			catch {}
		}
		
		
		void CopyToolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{
				_selected_rows = this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.SelectedRows;
				this.pasteToolStripMenuItem.Enabled = true;
			}
			catch (Exception Appe)
			{ }
		}
		
		void UspVDRV_DRIVER_PLAN_SelectAllDataGridViewSelectionChanged(object sender, EventArgs e)
		{
			if (this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.SelectedRows.Count > 0)
			{
				this.copyToolStripMenuItem.Enabled = true;
			}
			else
			{
				this.copyToolStripMenuItem.Enabled = false;
			}
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
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn11.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn11.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn13.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn13.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn14.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn14.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn15.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn15.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn16.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn16.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn17.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn17.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn18.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn18.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn58.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn58.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn60.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn60.Index].Value;
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn61.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn61.Index].Value;
					
					this.uspVDRV_DRIVER_PLAN_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value = DBNull.Value;
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

        private void fill_by_curr_monthtoolStripButton_Click(object sender, EventArgs e)
        {
            Just.Insert_new_driver_plan_by_curr_month();

            this.uspVDRV_MONTH_PLAN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_MONTH_PLAN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))));
        }
	}
}
