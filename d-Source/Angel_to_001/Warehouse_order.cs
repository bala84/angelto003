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
	public partial class Warehouse_order : Form
	{
        public string _username;
        public string _where_clause = "order_state <> 'Закрыт'";
		//Укажем id  для интересующей нас колонки
		public string Warehouse_order_id
		{
			get { return this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
		}
		
		public string Warehouse_order_number
		{
			get { return this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString(); }
		}
		
		private bool _is_valid = true;
        //Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление 5 - Просмотр
        public byte _warehouse_order_detail_form_state;
		
		public Warehouse_order()
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

		private void uspVWRH_WRH_ORDER_MASTER_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
		}
		

		
		void Warehouse_orderLoad(object sender, EventArgs e)
		{
            this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingSource.Filter = this._where_clause;
            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
			try
			{
				this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				//System.Windows.Forms.MessageBox.Show(ex.Message);
			}
            if (this._warehouse_order_detail_form_state == 5)
            {
                InsertToolStripMenuItem.Enabled = false;
                DeleteToolStripMenuItem.Enabled = false;
            }
            else
            {
                InsertToolStripMenuItem.Enabled = true;
                DeleteToolStripMenuItem.Enabled = true;
            }
		}
		
		void Start_dateTimePickerValueChanged(object sender, EventArgs e)
		{
			
			try
			{
				p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
				
				this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
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
				
				this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
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
            string v_number = "";
			using (Warehouse_order_detail Warehouse_order_detailForm = new Warehouse_order_detail())
			{
				Warehouse_order_detailForm.Text = "Вставка -";
                Warehouse_order_detailForm._username = _username;
                Warehouse_order_detailForm._warehouse_order_master_form_state = 1;
                v_number = Just.Get_order_number("N");
                Warehouse_order_detailForm._warehouse_order_master_number = v_number;
               
				Warehouse_order_detailForm.ShowDialog(this);
				if (Warehouse_order_detailForm.DialogResult == DialogResult.OK)
				{
                    if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.RowCount == 1)
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingSource.AddNew();
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingSource.AddNew();
                    }

					if (Warehouse_order_detailForm.Warehouse_order_master_state_number != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_state_number;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_car_mark != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_car_mark;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_car_model != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_car_model;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_number != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_number;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_run != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_run;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_worker != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_worker;
					}
					if (Warehouse_order_detailForm.Warehouse_order_malfunction_desc != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_malfunction_desc;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_date_created != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_date_created;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_head != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_head;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_reciever != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_reciever;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_order_state != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_order_state;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_repair_type_sname != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_repair_type_sname;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_car_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_car_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_head_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_head_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_reciever_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_reciever_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_worker_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_worker_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_repair_type_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_repair_type_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_repair_zone_master_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_repair_zone_master_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_date_started != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_date_started;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_date_ended != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_date_ended;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_malfunction_disc != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_malfunction_disc;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_sname != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_sname;
					}

                    if (Warehouse_order_detailForm.Warehouse_order_master_car_organization_id != "")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_id.Index].Value
                            = Warehouse_order_detailForm.Warehouse_order_master_car_organization_id;
                    }

                    if (Warehouse_order_detailForm.Warehouse_order_master_car_organization_sname != "")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_sname.Index].Value
                            = Warehouse_order_detailForm.Warehouse_order_master_car_organization_sname;
                    }
					

				}
			}
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			using (Warehouse_order_detail Warehouse_order_detailForm = new Warehouse_order_detail())
			{
				Warehouse_order_detailForm.Text = "Редактирование -";
                Warehouse_order_detailForm._username = _username;
				
				Warehouse_order_detailForm._warehouse_order_master_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_car_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_car_mark = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_car_model = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_date_created = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_head = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_head_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_reciever = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_reciever_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_worker = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_worker_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
				if (_warehouse_order_detail_form_state != 5)
				{
                    Warehouse_order_detailForm._warehouse_order_master_form_state = 2;
                }
                else
                {
                    Warehouse_order_detailForm._warehouse_order_master_form_state = 5;
                }
				Warehouse_order_detailForm._warehouse_order_master_malfunction_desc = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_number = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_order_state = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_repair_type_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_repair_type_sname = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_run = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_state_number = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_repair_zone_master_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_date_started = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_date_ended = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_malfunction_disc = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_employee_output_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_employee_output = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_wrh_order_master_type_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_wrh_order_master_type_sname = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString();
                Warehouse_order_detailForm._warehouse_order_master_car_organization_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_id.Index].Value.ToString();
                Warehouse_order_detailForm._warehouse_order_master_car_organization_sname = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_sname.Index].Value.ToString();
				Warehouse_order_detailForm.ShowDialog(this);
				if (Warehouse_order_detailForm.DialogResult == DialogResult.OK)
				{
						

					if (Warehouse_order_detailForm.Warehouse_order_master_state_number != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_state_number;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_car_mark != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_car_mark;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_car_model != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_car_model;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_number != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_number;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_run != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_run;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_worker != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_worker;
					}
					if (Warehouse_order_detailForm.Warehouse_order_malfunction_desc != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_malfunction_desc;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_date_created != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_date_created;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_head != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_head;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_reciever != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_reciever;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_repair_type_sname != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_repair_type_sname;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_car_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_car_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_head_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_head_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_reciever_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_reciever_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_worker_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_worker_id;
						
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_order_state != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_order_state;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_repair_type_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_repair_type_id;
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_repair_zone_master_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_repair_zone_master_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_date_started != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_date_started;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_date_ended != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_date_ended;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_malfunction_disc != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_malfunction_disc;
						
					}
					if (Warehouse_order_detailForm.Warehouse_order_master_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_fio_employee_output;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_id != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_id;
					}
					
					if (Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_sname != "")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value
							= Warehouse_order_detailForm.Warehouse_order_master_wrh_order_master_type_sname;
					}
                    if (Warehouse_order_detailForm.Warehouse_order_master_car_organization_id != "")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_id.Index].Value
                            = Warehouse_order_detailForm.Warehouse_order_master_car_organization_id;
                    }

                    if (Warehouse_order_detailForm.Warehouse_order_master_car_organization_sname != "")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_sname.Index].Value
                            = Warehouse_order_detailForm.Warehouse_order_master_car_organization_sname;
                    }
				}
			}
		}
		
		void DeleteToolStripMenuItemClick(object sender, EventArgs e)
		{
			using (Warehouse_order_detail Warehouse_order_detailForm = new Warehouse_order_detail())
			{
				Warehouse_order_detailForm.Text = "Удаление -";
                Warehouse_order_detailForm._username = _username;
				Warehouse_order_detailForm._warehouse_order_master_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_car_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_car_mark = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_car_model = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_date_created = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_head = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_head_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_reciever = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_reciever_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_worker = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_worker_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_form_state = 3;
				Warehouse_order_detailForm._warehouse_order_master_malfunction_desc = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_number = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_order_state = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_repair_type_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_repair_type_sname = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_run = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_state_number = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_repair_zone_master_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_date_started = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_date_ended = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_malfunction_disc = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_employee_output_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_fio_employee_output = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_wrh_order_master_type_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value.ToString();
				Warehouse_order_detailForm._warehouse_order_master_wrh_order_master_type_sname = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString();
                Warehouse_order_detailForm._warehouse_order_master_car_organization_id = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_id.Index].Value.ToString();
                Warehouse_order_detailForm._warehouse_order_master_car_organization_sname = this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[car_organization_sname.Index].Value.ToString();
				
                Warehouse_order_detailForm.ShowDialog(this);
				if (Warehouse_order_detailForm.DialogResult == DialogResult.OK)
				{
					this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingSource.RemoveCurrent();
					//_is_valid = false;
					//Ok_Toggle(false);
				}
			}
		}
		
		void UspVWRH_WRH_ORDER_MASTER_SelectAllDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					//this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
				     == this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.RowCount)
				    &&(this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
				}
				

			}
			catch (Exception Appe)
			{
			}
		}
		
		void UspVWRH_WRH_ORDER_MASTER_SelectAllDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
        
        void UspVWRH_WRH_ORDER_MASTER_SelectAllDataGridViewCellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
        	//Проверим наличие закрытых заказов-нарядов и раскрасим в соответствующий цвет строку
			try
			{
				if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Columns[e.ColumnIndex].Name == "dataGridViewTextBoxColumn20")
				{

					if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() == "Закрыт")
					{
						this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
							= Color.LightGreen;
					}
                    if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() == "Взят на ремонт, сведений о необх. запчастях нет")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightGoldenrodYellow;
                    }
                    if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() == "Взят на ремонт, есть сведения о необх. запчастях")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Yellow;
                    }
                    if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() == "Обработан")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Orange;
                    }
                    if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() == "Отклонен")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Red;
                    }

                    if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() == "Корректировка")
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Purple;
                    }
					
					if (this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() == "Открыт")
                    {
							this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
								= this.uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView.DefaultCellStyle.BackColor;
							
						
					}


				}
			}
			catch (Exception Appe)
			{ }
        }

        private void uspVWRH_WRH_ORDER_MASTER_SelectAllBindingNavigator_RefreshItems(object sender, EventArgs e)
        {

        }

        private void button_find_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                      , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                      , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch { }
        }

        private void uspVWRH_WRH_ORDER_MASTER_SelectAllDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

	}
}
