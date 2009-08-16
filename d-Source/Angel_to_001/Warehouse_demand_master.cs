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
	public partial class Warehouse_demand_master : Form
	{
        public string _username;
		
		public string _where_clause;
		public string _warehouse_demand_master_car_id;
		public string _warehouse_demand_master_state_number;
		public string _warehouse_demand_master_car_mark_sname;
		public string _warehouse_demand_master_car_model_sname;
        public string _warehouse_demand_master_car_organization_id;
        public string _warehouse_demand_master_car_organization_sname;
		public string _warehouse_demand_master_employee_recieve_id;
		public string _warehouse_demand_master_fio_employee_recieve;
		public string _warehouse_demand_master_employee_head_id;
		public string _warehouse_demand_master_fio_employee_head;
		public string _warehouse_demand_master_employee_worker_id;
		public string _warehouse_demand_master_fio_employee_worker;
		public string _warehouse_demand_master_wrh_demand_master_type_id;
		public string _warehouse_demand_master_wrh_demand_master_type_sname;
		public string _warehouse_demand_master_organization_giver_id;
		public string _warehouse_demand_master_organization_giver_sname;
		public string _warehouse_demand_master_wrh_order_master_id;
		public string _warehouse_demand_master_wrh_order_master_number;
		//Состояние формы: 4 - Требования на основе заказа-наряда
		public byte _warehouse_demand_master_form_state;
		
		private bool _is_valid = true;
		
		
		public Warehouse_demand_master()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
			
			start_dateTimePicker.Value = DateTime.Now.AddDays(-7.0);

			p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
			

			end_dateTimePicker.Value = DateTime.Now;

			p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
		}

		private void uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
		}

		
		void Warehouse_demand_masterLoad(object sender, EventArgs e)
		{

            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
			
			this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.Filter = this._where_clause;
			try
			{
				this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				System.Windows.Forms.MessageBox.Show(ex.Message);
			}
			//Если у нас мастер форма используется для создание требования по заказу-наряду
			//то добавим еще одну строку, в которую впишем шапку требования
			if ( _warehouse_demand_master_form_state == 4)
			{
				this.Insert_by_orderToolStripMenuItem.Enabled = true;

				//if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount != 1)
				//{
				/*this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.AddNew();
				//}
				
				if ( _warehouse_demand_master_state_number != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
						= _warehouse_demand_master_state_number;
				}
				
				if ( _warehouse_demand_master_car_id != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
						= _warehouse_demand_master_car_id;
				}
				
				if ( _warehouse_demand_master_car_mark_sname != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
						= _warehouse_demand_master_car_mark_sname;
				}
				
				
				if ( _warehouse_demand_master_car_model_sname != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
						= _warehouse_demand_master_car_model_sname;
				}
				
				
				if ( _warehouse_demand_master_wrh_demand_master_type_id != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
						= _warehouse_demand_master_wrh_demand_master_type_id;
				}
				
				if ( _warehouse_demand_master_wrh_demand_master_type_sname != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
						= _warehouse_demand_master_wrh_demand_master_type_sname;
				}
				
				
				if ( _warehouse_demand_master_wrh_order_master_id != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
						= _warehouse_demand_master_wrh_order_master_id;
				}
				
				if ( _warehouse_demand_master_wrh_order_master_number != "")
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
						= _warehouse_demand_master_wrh_order_master_number;
				}
				this.EditToolStripMenuItemClick(sender, e);*/
			}
		}
		
		void Start_dateTimePickerValueChanged(object sender, EventArgs e)
		{
			try
			{
				p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
				
				this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				// System.Windows.Forms.MessageBox.Show(ex.Message);
			}
		}
		
		void End_dateTimePickerValueChanged(object sender, EventArgs e)
		{
			try
			{
				p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
				
				this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				// System.Windows.Forms.MessageBox.Show(ex.Message);
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
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
			using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
			{
				Warehouse_demand_detailForm.Text = "Вставка -";
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = "";
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = "";
				
				Warehouse_demand_detailForm.ShowDialog(this);
				if (Warehouse_demand_detailForm.DialogResult == DialogResult.OK)
				{
                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount == 1)
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.AddNew();
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.AddNew();
                    }
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_id;
					}

					if (Warehouse_demand_detailForm.Warehouse_demand_master_state_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_state_number;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_number;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker;
					}
					
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_date_created != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_date_created;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_master_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_master_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number;
						
					}

                    if (Warehouse_demand_detailForm.Warehouse_demand_master_is_verified != "")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value
                            = Warehouse_demand_detailForm.Warehouse_demand_master_is_verified;

                    }
					
					

				}
			}
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
			{
				Warehouse_demand_detailForm.Text = "Редактирование -";
				
				Warehouse_demand_detailForm._warehouse_demand_master_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_car_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_car_mark_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_car_model_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_date_created = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_head = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_employee_head_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_recieve = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_employee_recieve_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_worker = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_employee_worker_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_form_state = 2;
				Warehouse_demand_detailForm._warehouse_demand_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_state_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString();
                Warehouse_demand_detailForm._warehouse_demand_master_is_verified = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value.ToString();
				
				Warehouse_demand_detailForm.ShowDialog(this);
				if (Warehouse_demand_detailForm.DialogResult == DialogResult.OK)
				{
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_id;
					}

					if (Warehouse_demand_detailForm.Warehouse_demand_master_state_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_state_number;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_number;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker;
					}
					
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_date_created != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_date_created;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number;
						
					}

                    if (Warehouse_demand_detailForm.Warehouse_demand_master_is_verified != "")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value
                            = Warehouse_demand_detailForm.Warehouse_demand_master_is_verified;

                    }

				}
			}
		}
		
		void DeleteToolStripMenuItemClick(object sender, EventArgs e)
		{
			using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
			{
				Warehouse_demand_detailForm._warehouse_demand_master_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_car_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_car_mark_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_car_model_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_date_created = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_head = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_employee_head_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_recieve = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_employee_recieve_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_worker = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_employee_worker_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_form_state = 3;
				Warehouse_demand_detailForm._warehouse_demand_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_state_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
				Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString();
                Warehouse_demand_detailForm._warehouse_demand_master_is_verified = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value.ToString();
				Warehouse_demand_detailForm.ShowDialog(this);
				if (Warehouse_demand_detailForm.DialogResult == DialogResult.OK)
				{
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.RemoveCurrent();
					//_is_valid = false;
					//Ok_Toggle(false);
				}
			}
		}
		
		void UspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					//this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
				     == this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount)
				    &&(this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
					    == this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount)
					{
						this.DeleteToolStripMenuItem.Enabled = false;
						this.Insert_OldToolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;
						
						
					}
					else
					{
						this.DeleteToolStripMenuItem.Enabled = true;
						this.Insert_OldToolStripMenuItem.Enabled = true;
                        this.EditToolStripMenuItem.Enabled = true;
						
					}
				}
				

			}
			catch (Exception Appe)
			{
			}
		}
		
		void UspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void Insert_OldToolStripMenuItemClick(object sender, EventArgs e)
		{
			using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
			{
				Warehouse_demand_detailForm.Text = "Вставка -";
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = "";
				Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = "";
				//Попробуем взять данные из имеющегося требования
				try
				{
					Warehouse_demand_detailForm._warehouse_demand_master_car_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_car_mark_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_car_model_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_head = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_employee_head_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_recieve = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_employee_recieve_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_worker = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_employee_worker_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_form_state = 1;
					Warehouse_demand_detailForm._warehouse_demand_master_state_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString();
					Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value.ToString();
					
					
				}
				catch
				{}

				Warehouse_demand_detailForm.ShowDialog(this);
				if (Warehouse_demand_detailForm.DialogResult == DialogResult.OK)
				{
                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount == 1)
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.AddNew();
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.AddNew();
                    }
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_id;
					}

					if (Warehouse_demand_detailForm.Warehouse_demand_master_state_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_state_number;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_number;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker;
					}
					
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_date_created != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_date_created;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_master_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_master_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id;
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id;
						
					}
					
					if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number != "")
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
							= Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number;
						
					}
					
					

				}
			}
		}
		
		void Button_cancelClick(object sender, EventArgs e)
		{
			
		}
        
        void Insert_by_orderToolStripMenuItemClick(object sender, EventArgs e)
        {
                         
                                using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
                                {
                                    Warehouse_demand_detailForm.Text = "Вставка на основе з/н -";
                                    Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = "";
                                    Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = "";

                                    //Попробуем взять данные из переменных формы
                                    try
                                    {
                                        Warehouse_demand_detailForm._warehouse_demand_master_car_id = _warehouse_demand_master_car_id;
                                        Warehouse_demand_detailForm._warehouse_demand_master_car_mark_sname = _warehouse_demand_master_car_mark_sname;
                                        Warehouse_demand_detailForm._warehouse_demand_master_car_model_sname = _warehouse_demand_master_car_model_sname;
                                        Warehouse_demand_detailForm._warehouse_demand_master_form_state = 4;
                                        Warehouse_demand_detailForm._warehouse_demand_master_state_number = _warehouse_demand_master_state_number;
                                        Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = _warehouse_demand_master_wrh_demand_master_type_id;
                                        Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = _warehouse_demand_master_wrh_demand_master_type_sname;
                                        Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_id = _warehouse_demand_master_wrh_order_master_id;
                                        Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_number = _warehouse_demand_master_wrh_order_master_number;
                                        Warehouse_demand_detailForm._warehouse_demand_master_car_organization_id = _warehouse_demand_master_car_organization_id;
                                        Warehouse_demand_detailForm._warehouse_demand_master_car_organization_name = _warehouse_demand_master_car_organization_sname;

                                        Warehouse_demand_detailForm._warehouse_demand_master_employee_head_id = _warehouse_demand_master_wrh_demand_master_type_id;
                                        Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_head = _warehouse_demand_master_wrh_demand_master_type_sname;
                                        Warehouse_demand_detailForm._warehouse_demand_master_employee_recieve_id = _warehouse_demand_master_wrh_order_master_id;
                                        Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_recieve = _warehouse_demand_master_wrh_order_master_number;
                                        Warehouse_demand_detailForm._warehouse_demand_master_employee_worker_id = _warehouse_demand_master_car_organization_id;
                                        Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_worker = _warehouse_demand_master_car_organization_sname;
                                    }
                                    catch
                                    { }

                                    Warehouse_demand_detailForm.ShowDialog(this);
                                    if (Warehouse_demand_detailForm.DialogResult == DialogResult.OK)
                                    {
                                        // if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount == 1)
                                        //  {
                                        //      this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.AddNew();
                                        //     this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.RemoveCurrent();
                                        //  }
                                        //  else
                                        //  {
                                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.AddNew();
                                        //  }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_car_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_car_id;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_state_number != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_state_number;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_number != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_number;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker;
                                        }


                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_date_created != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_date_created;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_master_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_master_id;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id;
                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id;

                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname;

                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id;

                                        }

                                        if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number != "")
                                        {
                                            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
                                                = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number;

                                        }



                                    }
                                
                            }
        }

        private void button_find_Click(object sender, EventArgs e)
        {
            try
            {

                this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                // System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие закрытых требований и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Columns[e.ColumnIndex].Name == "is_verified")
                {

                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[this.is_verified.Index].Value.ToString() == "Проверен")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightGreen;
                    }

                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[this.is_verified.Index].Value.ToString() == "Корректировка")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Purple;
                    }

                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[this.is_verified.Index].Value.ToString() == "Не проверен")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.DefaultCellStyle.BackColor;


                    }


                }
            }
            catch (Exception Appe)
            { }
        }
	}
}
