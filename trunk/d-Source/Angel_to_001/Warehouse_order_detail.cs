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
	public partial class Warehouse_order_detail : Form
	{
        public string _username;
		public string _warehouse_order_master_id;
		public string _warehouse_order_master_car_id;
		public string _warehouse_order_master_number;
		public string _warehouse_order_master_fio_reciever;
		public string _warehouse_order_master_fio_reciever_id;
		public string _warehouse_order_master_fio_head;
		public string _warehouse_order_master_fio_head_id;
		public string _warehouse_order_master_fio_worker;
		public string _warehouse_order_master_fio_worker_id;
		public string _warehouse_order_master_fio_employee_output;
		public string _warehouse_order_master_fio_employee_output_id;
		public string _warehouse_order_master_order_state;
		public string _warehouse_order_master_date_created;
		public string _warehouse_order_master_state_number;
		public string _warehouse_order_master_car_mark;
		public string _warehouse_order_master_car_model;
		public string _warehouse_order_master_run;
		public string _warehouse_order_master_repair_type_id;
		public string _warehouse_order_master_repair_type_sname;
		public string _warehouse_order_master_malfunction_desc;
		public string _warehouse_order_master_wrh_order_master_type_id;
		public string _warehouse_order_master_wrh_order_master_type_sname;
        public string _warehouse_order_master_car_organization_id;
        public string _warehouse_order_master_car_organization_sname;

		//Переменные для работы с рем. зоной
		public string _warehouse_order_master_repair_zone_master_id;
		public string _warehouse_order_master_date_started;
		public string _warehouse_order_master_date_ended;
		public string _warehouse_order_master_malfunction_disc;
		public string _warehouse_order_master_repair_type_sn;
		
		private bool _is_valid = true;
        private bool _is_correct_ts = true;
        private bool _is_all_parts_verified = true;
        private bool _is_all_items_verified = true;
        private string _is_all_demands_verified = "Y";
		//Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление 5 - Просмотр
		public byte _warehouse_order_master_form_state;
		
		public string Warehouse_order_master_id
		{
			get { return this.idTextBox.Text; }
		}
		
		public string Warehouse_order_master_car_id
		{
			get { return this.car_idTextBox.Text; }
		}
		
		public string Warehouse_order_master_number
		{
			get { return this.numberTextBox.Text; }
		}
		
		public string Warehouse_order_master_fio_reciever
		{
			get { return this.fIO_employee_recieveTextBox.Text; }
		}
		
		public string Warehouse_order_master_fio_reciever_id
		{
			get { return this.employee_recieve_idTextBox.Text; }
		}
		
		public string Warehouse_order_master_fio_head
		{
			get { return this.fIO_employee_headTextBox.Text; }
		}
		public string Warehouse_order_master_fio_head_id
		{
			get { return this.employee_head_idTextBox.Text; }
		}
		
		public string Warehouse_order_master_fio_worker
		{
			get { return this.fIO_employee_workerTextBox.Text; }
		}
		
		public string Warehouse_order_master_fio_worker_id
		{
			get { return this.employee_worker_idTextBox.Text; }
		}
		
		public string Warehouse_order_master_fio_employee_output
		{
			get { return this.fio_employee_outputtextBox.Text; }
		}
		
		public string Warehouse_order_master_fio_employee_output_id
		{
			get { return this.employee_output_idtextBox.Text; }
		}
		
		public string Warehouse_order_master_order_state
		{
			get { return this.order_stateComboBox.Text; }
		}
		
		public string Warehouse_order_master_date_created
		{
			get { return this.date_createdDateTimePicker.Text; }
		}
		
		public string Warehouse_order_master_state_number
		{
			get { return this.state_numberTextBox.Text; }
		}
		
		
		public string Warehouse_order_master_car_mark
		{
			get { return this.car_mark_snameTextBox.Text; }
		}
		public string Warehouse_order_master_car_model
		{
			get { return this.car_model_snameTextBox.Text; }
		}
		public string Warehouse_order_master_run
		{
			get { return this.runTextBox.Text; }
		}
		
		public string Warehouse_order_master_repair_type_sname
		{
			get { return this.repair_type_snameTextBox.Text; }
		}
		public string Warehouse_order_master_repair_type_id
		{
			get { return this.repair_type_idTextBox.Text; }
		}
		
		
		
		public string Warehouse_order_master_repair_zone_master_id
		{
			get { return this.idTextBox1.Text; }
		}
		
		public string Warehouse_order_master_date_started
		{
			get { return this.date_startedtextBox.Text; }
		}
		
		public string Warehouse_order_master_date_ended
		{
			get { return this.date_endedtextBox.Text; }
		}
		
		public string Warehouse_order_master_malfunction_disc
		{
			get { return this.malfunction_discTextBox.Text; }
		}
		
		public string Warehouse_order_malfunction_desc
		{
			get { return this.malfunction_descTextBox.Text; }
		}
		
		public string Warehouse_order_master_wrh_order_master_type_id
		{
			get { return this.wrh_order_master_type_idtextBox.Text; }
		}
		public string Warehouse_order_master_wrh_order_master_type_sname
		{
			get { return this.wrh_order_master_typecomboBox.Text; }
		}

        public string Warehouse_order_master_car_organization_id
        {
            get { return this.car_organization_idtextBox.Text; }
        }
        public string Warehouse_order_master_car_organization_sname
        {
            get { return this.car_organization_snametextBox.Text; }
        }
		
		public Warehouse_order_detail()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}
		//Процедура подготовки детальной таблицы для записи
		void Prepare_Detail (int master_id_index, DataGridViewRowCollection dgvRows, string v_master_id)
		{
			foreach(DataGridViewRow currentRow in dgvRows)
			{
				currentRow.Cells[master_id_index].Value = v_master_id;
			}
		}

        //Процедура проверки правильности заведения ТО
        void Check_ts(DataGridViewRowCollection dgvRows)
        {
            string v_is_correct_ts = "Y";
            foreach (DataGridViewRow currentRow in dgvRows)
            {
                try
                {
                    v_is_correct_ts = Just.Сheck_ts((decimal)Convert.ChangeType(this.car_idTextBox.Text, typeof(decimal))
                                                    , (decimal)Convert.ChangeType(currentRow.Cells[dataGridViewTextBoxColumn30.Index], typeof(decimal))
                                                    , (DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime)));

                }
                catch { }
                if (v_is_correct_ts == "N")
                {
                    _is_correct_ts &= false;
                }
                else
                {
                    _is_correct_ts &= true;
                }
            }
        }
        //Проверим, что у нас списан товар, если мы собираемся закрыт заказ
        void Check_parts()
        {
            if (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1)
            {
                foreach (DataGridViewRow currentRow in this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Rows)
                {
                    try
                    {
                        if (currentRow.Cells[dataGridViewTextBoxColumn36.Index].Value.ToString() != "")
                        {
                            if ((decimal)Convert.ChangeType(currentRow.Cells[dataGridViewTextBoxColumn36.Index].Value.ToString(), typeof(decimal)) != 0)
                            {
                                _is_all_parts_verified &= false;

                            }
                            else
                            {
                                _is_all_parts_verified &= true;
                            }
                        }
                        else
                        {
                            _is_all_parts_verified &= false;
                        }

                    }
                    catch { }
                }
            }
        }

		void Button_recieverClick(object sender, EventArgs e)
		{
			using (Employee EmployeeForm = new Employee())
			{
				EmployeeForm.ShowDialog(this);
				if (EmployeeForm.DialogResult == DialogResult.OK)
				{

					this.fIO_employee_recieveTextBox.Text
						= EmployeeForm.Employee_short_fio;
					this.employee_recieve_idTextBox.Text
						= EmployeeForm.Employee_id;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
				}
			}
		}
		
		void Button_headClick(object sender, EventArgs e)
		{
			using (Employee EmployeeForm = new Employee())
			{
                EmployeeForm._where_clause = "employee_type_id = " + Const.Emp_type_header_id.ToString();
				EmployeeForm.ShowDialog(this);
				if (EmployeeForm.DialogResult == DialogResult.OK)
				{

					this.fIO_employee_headTextBox.Text
						= EmployeeForm.Employee_short_fio;
					this.employee_head_idTextBox.Text
						= EmployeeForm.Employee_id;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
				}
			}
		}
		
		void Button_mechClick(object sender, EventArgs e)
		{
			using (Employee EmployeeForm = new Employee())
			{
				EmployeeForm.ShowDialog(this);
				if (EmployeeForm.DialogResult == DialogResult.OK)
				{

					this.fIO_employee_workerTextBox.Text
						= EmployeeForm.Employee_short_fio;
					this.employee_worker_idTextBox.Text
						= EmployeeForm.Employee_id;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
				}
			}
		}
		
		void Button_repair_typeClick(object sender, EventArgs e)
		{
			using (Repair_type_master Repair_type_masterForm = new Repair_type_master())
			{
				Repair_type_masterForm.ShowDialog(this);
				if (Repair_type_masterForm.DialogResult == DialogResult.OK)
				{

					this.repair_type_snameTextBox.Text
						= Repair_type_masterForm.Repair_type_master_sname;
					this.repair_type_idTextBox.Text
						= Repair_type_masterForm.Repair_type_master_id;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
				}
			}
		}
		
		void Warehouse_order_detailLoad(object sender, EventArgs e)
		{
            DateTime v_date_started;
            DateTime v_date_ended;

            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();

            p_start_dateToolStripTextBox2.Text = DateTime.Now.AddYears(-100).ToShortDateString();


            p_end_dateToolStripTextBox2.Text = DateTime.Now.ToShortDateString();
            


			if ( _warehouse_order_master_id != "")
			{
				this.idTextBox.Text = _warehouse_order_master_id;
				this.p_wrh_order_master_idToolStripTextBox.Text = _warehouse_order_master_id;
			}
			
			if (_warehouse_order_master_car_id != "")
			{
				this.car_idTextBox.Text = _warehouse_order_master_car_id;
			}
			
			if (_warehouse_order_master_number != "")
			{
				this.numberTextBox.Text = _warehouse_order_master_number;
			}
			
			if (_warehouse_order_master_fio_reciever != "")
			{
				this.fIO_employee_recieveTextBox.Text = _warehouse_order_master_fio_reciever;
			}
			
			if (_warehouse_order_master_fio_reciever_id != "")
			{
				this.employee_recieve_idTextBox.Text = _warehouse_order_master_fio_reciever_id;
			}
			
			if (_warehouse_order_master_fio_head != "")
			{
				this.fIO_employee_headTextBox.Text = _warehouse_order_master_fio_head;
			}
			
			if (_warehouse_order_master_fio_head_id != "")
			{
				this.employee_head_idTextBox.Text = _warehouse_order_master_fio_head_id;
			}
			
			if (_warehouse_order_master_fio_worker != "")
			{
				this.fIO_employee_workerTextBox.Text = _warehouse_order_master_fio_worker;
			}
			
			if (_warehouse_order_master_fio_worker_id != "")
			{
				this.employee_worker_idTextBox.Text = _warehouse_order_master_fio_worker_id;
			}
			
			if (_warehouse_order_master_order_state != "")
			{
				this.order_stateComboBox.Text = _warehouse_order_master_order_state;
			}
			
			if (_warehouse_order_master_date_created != "")
			{
				this.date_createdDateTimePicker.Text = _warehouse_order_master_date_created;
			}
			
			if (_warehouse_order_master_state_number != "")
			{
				this.state_numberTextBox.Text = _warehouse_order_master_state_number;
			}
			
			if (_warehouse_order_master_car_mark != "")
			{
				this.car_mark_snameTextBox.Text = _warehouse_order_master_car_mark;
			}
			
			if (_warehouse_order_master_car_model != "")
			{
				this.car_model_snameTextBox.Text = _warehouse_order_master_car_model;
			}
			
			if (_warehouse_order_master_run != "")
			{
				this.runTextBox.Text = _warehouse_order_master_run;
			}
			
			if (_warehouse_order_master_repair_type_id != "")
			{
				this.repair_type_idTextBox.Text = _warehouse_order_master_repair_type_id;
			}
			
			if (_warehouse_order_master_repair_type_sname != "")
			{
				this.repair_type_snameTextBox.Text = _warehouse_order_master_repair_type_sname;
			}
			
			if (_warehouse_order_master_malfunction_desc != "")
			{
				this.malfunction_descTextBox.Text = _warehouse_order_master_malfunction_desc;
			}
			
			if (_warehouse_order_master_repair_zone_master_id != "")
			{
				this.idTextBox1.Text = _warehouse_order_master_repair_zone_master_id;
				this.p_repair_zone_master_idToolStripTextBox.Text = _warehouse_order_master_repair_zone_master_id;
			}
			
			if (_warehouse_order_master_date_started != "")
			{
                try
                {
                    v_date_started = (DateTime)Convert.ChangeType(this._warehouse_order_master_date_started, typeof(DateTime));

                    this.date_startedtextBox.Text = v_date_started.ToShortDateString() + " " + v_date_started.ToShortTimeString();
                }
                catch { }
			}
			
			
			if (_warehouse_order_master_date_ended != "")
            {
                try
                {
                    v_date_ended = (DateTime)Convert.ChangeType(this._warehouse_order_master_date_ended, typeof(DateTime));
                    this.date_endedtextBox.Text = v_date_ended.ToShortDateString() + " " + v_date_ended.ToShortTimeString();
                }
                catch { }
			}
			
			if (_warehouse_order_master_malfunction_disc != "")
			{
				this.malfunction_discTextBox.Text = _warehouse_order_master_malfunction_disc;
			}
			
			
			if (_warehouse_order_master_fio_employee_output_id != "")
			{
				this.employee_output_idtextBox.Text = _warehouse_order_master_fio_employee_output_id;
			}
			
			if (_warehouse_order_master_fio_employee_output != "")
			{
				this.fio_employee_outputtextBox.Text = _warehouse_order_master_fio_employee_output;
			}
			
			if (_warehouse_order_master_wrh_order_master_type_id != "")
			{
				this.wrh_order_master_type_idtextBox.Text = _warehouse_order_master_wrh_order_master_type_id;
			}
			
			
			if (_warehouse_order_master_wrh_order_master_type_sname != "")
			{
				this.wrh_order_master_typecomboBox.Text = _warehouse_order_master_wrh_order_master_type_sname;
			}

            if (_warehouse_order_master_car_organization_id != "")
            {
                this.car_organization_idtextBox.Text = _warehouse_order_master_car_organization_id;
            }


            if (_warehouse_order_master_car_organization_sname != "")
            {
                this.car_organization_snametextBox.Text = _warehouse_order_master_car_organization_sname;
            }
			
			
			
			this.Text = this.Text + " заказ - наряд";
			
			if (this.order_stateComboBox.Text == "")
			{
				this.order_stateComboBox.Text = this.order_stateComboBox.Items[0].ToString();
			}
			
			if (this.wrh_order_master_typecomboBox.Text == "")
			{
				this.wrh_order_master_typecomboBox.Text = this.wrh_order_master_typecomboBox.Items[0].ToString();
			}


			
			if (this.p_wrh_order_master_idToolStripTextBox.Text != "")
			{
				try
				{

                    this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.Filter = "wrh_order_master_id="
                    + this.p_wrh_order_master_idToolStripTextBox.Text;

					this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_order_master_idToolStripTextBox.Text, typeof(decimal))))), 1);
					this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_order_master_idToolStripTextBox.Text, typeof(decimal))))));
                    this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox2.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox2.Text, typeof(System.DateTime)))))
                                                                          , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                          , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                          , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			
			if (this.p_repair_zone_master_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_zone_master_idToolStripTextBox.Text, typeof(decimal))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			
			if (_warehouse_order_master_form_state == 3)
			{
				this.BackColor = Color.Red;
				this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = false;
				this.numberTextBox.Enabled = false;
				this.button_reciever.Enabled = false;
				this.button_head.Enabled = false;
				this.button_mech.Enabled = false;
				this.order_stateComboBox.Enabled = false;
				this.date_createdDateTimePicker.Enabled = false;
				this.button_repair_type.Enabled = false;
				this.malfunction_descTextBox.Enabled = false;
				this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
				this.date_startedtextBox.Enabled = false;
				this.date_endedtextBox.Enabled = false;
				this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
				this.contextMenuStrip1.Enabled = false;
                this.contextMenuStrip4.Enabled = false;
                this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Enabled = false;
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Enabled = false;
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource1.Enabled = false;
                this.uspVWRH_WRH_DEMAND_MASTER_SelectAllbindingNavigator.Enabled = false;
				Ok_Toggle(true);
			}
			else
			{
				this.BackColor = System.Drawing.SystemColors.Control;
				this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = true;
				Ok_Toggle(_is_valid);
			}
			if (_warehouse_order_master_form_state == 1)
			{
				this.open_demandToolStripMenuItem.Enabled = false;
			}
            //Если у нас состояние формы - просмотр - то лишь дадим посмотреть форму
            if (_warehouse_order_master_form_state == 5)
            {
                this.date_createdDateTimePicker.Enabled = false;
                this.button_car.Enabled = false;
                this.button_datestarted.Enabled = false;
                this.button_dateended.Enabled = false;
                this.button_employee_output.Enabled = false;
                this.button_head.Enabled = false;
                this.button_mech.Enabled = false;
                this.button_reciever.Enabled = false;
                this.order_stateComboBox.Enabled = false;
                this.contextMenuStrip1.Enabled = false;
                this.contextMenuStrip2.Enabled = false;
                this.contextMenuStrip3.Enabled = false;
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.Enabled = false;
                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
                this.counttoolStripButton.Enabled = false;
                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = false;
                this.malfunction_descTextBox.Enabled = false;
                this.malfunction_discTextBox.Enabled = false;
                this.wrh_order_master_typecomboBox.Enabled = false;
                this.start_repairtoolStripButton.Enabled = false;
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
				this.UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItemClick(sender, e);
			}
		}
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
            if (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.RowCount == 1)
            {
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.AddNew();
            }

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{
				this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.BeginEdit(false);
				if ((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn113")
				    ||(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn114")
				   // ||(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn112")
                    || (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn110"))
				{
					using (Good_category Good_categoryForm = new Good_category())
					{
						Good_categoryForm.ShowDialog(this);
						if (Good_categoryForm.DialogResult == DialogResult.OK)
						{

                          /*  //Если первая строка, то вставка одной записи должна быть
                            //почему-то вставляет две записи при cell read only
                            if (this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.RowCount == 1)
                            {
                                this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.AddNew();
                                this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.RemoveCurrent();
                            }*/

							this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn113.Index].Value
								= Good_categoryForm.Good_category_good_mark;
							this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value
								= Good_categoryForm.Good_category_sname;
							this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn112.Index].Value
								= Good_categoryForm.Good_category_unit;
							this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn111.Index].Value
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
			this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			this.contextMenuStrip1.Visible = false;
			
		}
		
		void UspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn6.Index].Value
             = _username;
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void NumberTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void FIO_employee_recieveTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void FIO_employee_headTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void FIO_employee_workerTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Order_stateComboBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Date_createdDateTimePickerValueChanged(object sender, EventArgs e)
		{
            //Пробуем обновить значения дат
            try
            {
                this.date_startedtextBox.Text =
                    this.date_startedtextBox.Text.Substring(0, 10) +
                    this.date_startedtextBox.Text.Substring(10, 6)
                    ;

                this.date_endedtextBox.Text =
                    this.date_endedtextBox.Text.Substring(0, 10) +
                    this.date_endedtextBox.Text.Substring(10, 6)
                    ;

            }
            catch { }
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		
		void Malfunction_descTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Repair_type_snameTextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Button_carClick(object sender, EventArgs e)
		{
			
			using (Car CarForm = new Car())
			{
				CarForm.ShowDialog(this);
				if (CarForm.DialogResult == DialogResult.OK)
				{
                    this.state_numberTextBox.Text = CarForm.Car_state_number;
                    this.car_mark_snameTextBox.Text = CarForm.Car_mark;
                    this.car_model_snameTextBox.Text = CarForm.Car_model;
                    this.car_idTextBox.Text = CarForm.Car_id;
                    this.runTextBox.Text = CarForm.Car_run;
                    this.car_organization_idtextBox.Text = CarForm.Car_organization_id;
                    this.car_organization_snametextBox.Text = CarForm.Car_organization_sname;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);

                    /*try
                    {
                        this.uspVDRV_DRIVER_LIST_SelectByCar_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_LIST_SelectByCar_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(CarForm.Car_id, typeof(decimal))))));
                    }
                    catch (System.Exception ex)
                    {
                        System.Windows.Forms.MessageBox.Show(ex.Message);
                    }
                    if (this.uspVDRV_DRIVER_LIST_SelectByCar_IdDataGridView.RowCount < 2)
                    {
                        this.state_numberTextBox.Text = CarForm.Car_state_number;
                        this.car_mark_snameTextBox.Text = CarForm.Car_mark;
                        this.car_model_snameTextBox.Text = CarForm.Car_model;
                        this.car_idTextBox.Text = CarForm.Car_id;
                        this.runTextBox.Text = CarForm.Car_run;
                    }
                    else
                    {
                        MessageBox.Show("У этого автомобиля не закрыт путевой лист. Сначала закройте путевой лист");
                    }*/

				}
			}
			
		}



		
		
		void Insert2toolStripMenuItemClick(object sender, EventArgs e)
		{

            if (this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.RowCount == 1)
            {
                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
                //

                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value =
                "-//-";
                

            }
            else
            {
                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingSource.AddNew();

                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value =
                "-//-";

            }

			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Edit2toolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.BeginEdit(false);
			try
			{
				if (this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn35")
				{
					using (Employee EmployeeForm = new Employee())
					{
                        EmployeeForm._where_clause = "organization_id = " + Const.Org_rmz_id.ToString();
						EmployeeForm.ShowDialog(this);
						if (EmployeeForm.DialogResult == DialogResult.OK)
						{

							this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value
								= EmployeeForm.Employee_id;
							this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn35.Index].Value
								= EmployeeForm.Employee_short_fio;
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
			this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				     == this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				    &&(this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1))
				{
					this.contextMenuStrip2.Enabled = false;
				}
				else
				{
					this.contextMenuStrip2.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
					    == this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
					{
						this.Delete2toolStripMenuItem.Enabled = false;
                        this.Edit2toolStripMenuItem.Enabled = false;
						//this.Insert2toolStripMenuItem.Enabled = false;
						
						
					}
					else
					{
						this.Delete2toolStripMenuItem.Enabled = true;
                        this.Edit2toolStripMenuItem.Enabled = true;
						//this.Insert2toolStripMenuItem.Enabled = true;
						
					}
                    if ((int)Convert.ChangeType(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn36.Index].Value, typeof(int)) < 0)
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
		
		void UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
			
		}
		
		void UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
            //MessageBox.Show("1");
            this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
                = _username;
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void Button_employee_outputClick(object sender, EventArgs e)
		{
			using (Employee EmployeeForm = new Employee())
			{
                EmployeeForm._where_clause = "employee_type_id = " + Const.Emp_type_mech_id.ToString() 
                                               + " or employee_type_id = " + Const.Emp_type_mech_manager_id.ToString();
				EmployeeForm.ShowDialog(this);
				if (EmployeeForm.DialogResult == DialogResult.OK)
				{

					this.fio_employee_outputtextBox.Text
						= EmployeeForm.Employee_short_fio;
					this.employee_output_idtextBox.Text
						= EmployeeForm.Employee_id;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
				}
			}
		}
		
		void Fio_employee_outputtextBoxTextChanged(object sender, EventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		
		void Wrh_order_master_typecomboBoxTextChanged(object sender, EventArgs e)
		{
			if (this.wrh_order_master_typecomboBox.SelectedIndex == 0)
			{
				this.wrh_order_master_type_idtextBox.Text = Const.Wrh_order_master_type_car_id.ToString();
				
				this.runTextBox.Visible = true;
				this.car_mark_snameTextBox.Visible = true;
				this.car_model_snameTextBox.Visible = true;
				this.state_numberTextBox.Visible = true;
				this.button_car.Visible = true;
				this.car_mark_snameLabel.Visible = true;
				this.car_model_snameLabel.Visible = true;
				this.state_numberLabel.Visible = true;
				this.runLabel.Visible = true;
			}
			if ((this.wrh_order_master_typecomboBox.SelectedIndex == 1)
			    ||(this.wrh_order_master_typecomboBox.SelectedIndex == 2)
			    ||(this.wrh_order_master_typecomboBox.SelectedIndex == 3))
			{
				if (this.wrh_order_master_typecomboBox.SelectedIndex == 1)
				{
					this.wrh_order_master_type_idtextBox.Text = Const.Wrh_order_master_type_worker_id.ToString();
				}
				if (this.wrh_order_master_typecomboBox.SelectedIndex == 2)
				{
					this.wrh_order_master_type_idtextBox.Text = Const.Wrh_order_master_type_expense_id.ToString();
				}
				if (this.wrh_order_master_typecomboBox.SelectedIndex == 3)
				{
					this.wrh_order_master_type_idtextBox.Text = Const.Wrh_order_master_type_motor_id.ToString();
				}
				this.state_numberTextBox.Visible = false;
				this.car_mark_snameTextBox.Visible = false;
				this.car_model_snameTextBox.Visible = false;
				this.button_car.Visible = false;
				this.runTextBox.Visible = false;
				this.state_numberLabel.Visible = false;
				this.car_mark_snameLabel.Visible = false;
				this.car_model_snameLabel.Visible = false;
				this.runLabel.Visible = false;
			}
		}

		
		
		void Insert3toolStripMenuItemClick(object sender, EventArgs e)
		{
			/*if (this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount != 1)
			{
				this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.AddNew();
			}*/

            if (this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount == 1)
            {
                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.AddNew();
                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.AddNew();
            }
          /*  add_default_bill(this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString()
                             , this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value.ToString()
                             );*/
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void Edit3toolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{   
                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.BeginEdit(false);
				if (this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn31")
				{
					using (Repair_type_master Repair_type_masterForm = new Repair_type_master())
					{
                        Repair_type_masterForm._repair_type_master_mark_sname = this.car_mark_snameTextBox.Text;
                        Repair_type_masterForm._repair_type_master_model_sname = this.car_model_snameTextBox.Text;
						Repair_type_masterForm.ShowDialog(this);
						if (Repair_type_masterForm.DialogResult == DialogResult.OK)
						{
                            //Апдейта на этой таблице нет нормального - поэтому имитируем апдейт
                            //удаляем и вставляем новую запись, если старая конечно была непустой
                            try
                            {
                                if (this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value.ToString() != "")
                                {
                                    this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.RemoveCurrent();
                                    this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.AddNew();
                                }
                            }
                            catch { }

                            if ((Repair_type_masterForm.Repair_type_master_mark_sname != "") && (Repair_type_masterForm.Repair_type_master_model_sname != ""))
                            {
                                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value
                                  = Repair_type_masterForm.Repair_type_master_sname + " - " + Repair_type_masterForm.Repair_type_master_mark_sname + " - " + Repair_type_masterForm.Repair_type_master_model_sname;
                            }
                            else
                            {
                                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value
                                 = Repair_type_masterForm.Repair_type_master_sname;
                            }
                           this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
								= Repair_type_masterForm.Repair_type_master_id;
							//Если первая строка, то вставка одной записи должна быть
							//почему-то вставляет две записи при cell read only
							if (this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount == 1)
							{
								this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.AddNew();
								this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.RemoveCurrent();
							}

                            add_default_bill(this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString()
                             , this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value.ToString()
                             );

							_is_valid &= false;
							Ok_Toggle(_is_valid);
						}
					}
				}
			}
			catch (Exception Appe)
			{}
		}
		
		void Delete3toolStripMenuItemClick(object sender, EventArgs e)
		{
			this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void UspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void UspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				if ((this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount)
				{
					
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}
		
		void UspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Index + 1)
				     == this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount)
				    &&(this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount != 1))
				{
					this.contextMenuStrip3.Enabled = false;
				}
				else
				{
					this.contextMenuStrip3.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.CurrentRow.Index + 1)
					    == this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.RowCount)
					{
						this.Delete3toolStripMenuItem.Enabled = false;
						//this.Insert3toolStripMenuItem.Enabled = false;
                        this.Edit3toolStripMenuItem.Enabled = false;
						
						
					}
					else
					{
						this.Delete3toolStripMenuItem.Enabled = true;
						//this.Insert3toolStripMenuItem.Enabled = true;
                        this.Edit3toolStripMenuItem.Enabled = true;
						
					}
				}
				

			}
			catch (Exception Appe)
			{
			}
		}
		
		
		void UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItemClick(object sender, EventArgs e)
        {

            Nullable<decimal> v_id = new Nullable<decimal>();
            Nullable<decimal> v_car_id = new Nullable<decimal>();
            Nullable<decimal> v_repair_type_id = new Nullable<decimal>();
            Nullable<decimal> v_repair_zone_master_id = new Nullable<decimal>();
            Nullable<decimal> v_employee_output_id = new Nullable<decimal>();
            Nullable<decimal> v_employee_head_id = new Nullable<decimal>();
            Nullable<DateTime> v_date_started = new Nullable<DateTime>();
            Nullable<DateTime> v_date_ended = new Nullable<DateTime>();
            Nullable<decimal> v_employee_worker_id = new Nullable<decimal>();
            Nullable<decimal> v_run = new Nullable<decimal>();

            //Обнулим проверку правильного ТО и запчастей
            _is_correct_ts = true;
            _is_all_parts_verified = true;
            _is_all_items_verified = true;
            _is_all_demands_verified = "Y";



            //Проверим списание запчастей, если собираемся закрыть заявку
            if (((this._warehouse_order_master_form_state != 3)
                &&(this.order_stateComboBox.Text == "Закрыт"))
                || ((this._warehouse_order_master_form_state != 3)
                &&(this.order_stateComboBox.Text == "Обработан")))
            {
                this.Check_parts();
                _is_all_items_verified = this.Check_Items();
                _is_all_demands_verified = Just.Check_correct_demand((decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal)));

            }


            //Проверим правильность указания ТО
           // if (this._warehouse_order_master_form_state != 3)
           // {
          //      this.Check_ts(this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.Rows);
          //  }
            if ((this.numberTextBox.Text != "")
                  && (this.employee_recieve_idTextBox.Text != "")
                // &&(this.employee_head_idTextBox.Text != "")
                  && (this.employee_worker_idTextBox.Text != "")
                  && (this.date_createdDateTimePicker.Text != "")
                //&&(this.fio_employee_outputtextBox.Text != "")
                //   &&(this.state_numberTextBox.Text != "")
                // &&(this.car_mark_snameTextBox.Text != "")
                //  &&(this.car_model_snameTextBox.Text != "")
                //   &&(this.runTextBox.Text != "")
                  && (this.malfunction_descTextBox.Text != "")
                //&&(this.date_startedDateTimePicker.Text != "")
                //&&(this.date_endedDateTimePicker.Text != "")
                //   &&(this.repair_type_idTextBox.Text != "")
                  && (this._is_correct_ts == true)
                  && (this._is_all_parts_verified == true)
                  && (this._is_all_items_verified == true)
                  && (this._is_all_demands_verified == "Y")
                 )
            {
                try
                {
                    if (this.wrh_order_master_type_idtextBox.Text != Const.Wrh_order_master_type_car_id.ToString())
                    {
                        this.car_idTextBox.Text = "";
                        this.state_numberTextBox.Text = "";
                        this.car_mark_snameTextBox.Text = "";
                        this.car_model_snameTextBox.Text = "";
                    }
                   if (this.idTextBox.Text != "")
                    {
                        v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
                    }
                    if (this.idTextBox1.Text != "")
                    {
                        v_repair_zone_master_id = (decimal)Convert.ChangeType(this.idTextBox1.Text, typeof(decimal));
                    }
                    this.Validate();
                    this.uspVWRH_WRH_ORDER_MASTER_SelectAllBindingSource.EndEdit();
                    this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
                    this.uspVRPR_REPAIR_ZONE_MASTER_SelectByIdBindingSource.EndEdit();
                    this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
                    this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idBindingSource.EndEdit();
                    if (this._warehouse_order_master_form_state == 3)
                    {
                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal)))
                                                                                   , "-", _username);
                        this.uspVRPR_REPAIR_ZONE_MASTER_SelectByIdTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_repair_zone_master_id, typeof(decimal))), "-", _username);
                    }
                    else
                    {
                        if (this.car_idTextBox.Text != "")
                        {
                            v_car_id = (decimal)Convert.ChangeType(this.car_idTextBox.Text, typeof(decimal));
                        }

                        if (this.repair_type_idTextBox.Text != "")
                        {
                            v_repair_type_id = (decimal)Convert.ChangeType(this.repair_type_idTextBox.Text, typeof(decimal));
                        }

                        if (this.employee_output_idtextBox.Text != "")
                        {
                            v_employee_output_id = (decimal)Convert.ChangeType(this.employee_output_idtextBox.Text, typeof(decimal));
                        }

                        if (this.employee_head_idTextBox.Text != "")
                        {
                            v_employee_head_id = (decimal)Convert.ChangeType(this.employee_head_idTextBox.Text, typeof(decimal));
                        }

                        if ((this.date_startedtextBox.Text != "")
                            && (this.date_startedtextBox.Text.Length > 11))
                        {
                            v_date_started = (DateTime)Convert.ChangeType(this.date_startedtextBox.Text, typeof(DateTime));
                        }

                        if ((this.date_endedtextBox.Text != "")
                            && (this.date_endedtextBox.Text.Length > 11))
                        {
                            v_date_ended = (DateTime)Convert.ChangeType(this.date_endedtextBox.Text, typeof(DateTime));
                        }
                        if (this.employee_worker_idTextBox.Text != "")
                        {
                            v_employee_worker_id = (decimal)Convert.ChangeType(this.employee_worker_idTextBox.Text, typeof(decimal));
                        }

                        if (this.runTextBox.Text != "")
                        {
                            v_run = (decimal)Convert.ChangeType(this.runTextBox.Text, typeof(decimal));
                        }

                        //Сохраним рем зону, если она есть в форме

                        this.uspVRPR_REPAIR_ZONE_MASTER_SelectByIdTableAdapter.Update(ref v_repair_zone_master_id
                                                                                      , v_car_id
                                                                                      , v_employee_head_id
                                                                                      , v_employee_worker_id
                                                                                      , v_date_started
                                                                                      , v_date_ended
                                                                                      , v_repair_type_id
                                                                                      , this.malfunction_discTextBox.Text
                                                                                      , v_id
                                                                                      , this.sys_commentTextBox1.Text
                                                                                      , _username);

                        if (this._warehouse_order_master_form_state != 3)
                        {
                            this.idTextBox1.Text = v_repair_zone_master_id.ToString();
                            this.p_repair_zone_master_idToolStripTextBox.Text = v_repair_zone_master_id.ToString();
                            if (this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.Rows.Count > 1)
                            {
                                this.Prepare_Detail(dataGridViewTextBoxColumn21.Index, this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.Rows, this.idTextBox1.Text);
                            }
                            // MessageBox.Show(this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString());
                            this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdTableAdapter.Update(this.aNGEL_TO_001.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_Id);
                        }
                        if (this._warehouse_order_master_form_state != 3)
                        {
                            //TODO: добавить current cell changed
                        }


                        this.uspVWRH_WRH_ORDER_MASTER_SelectAllTableAdapter.Update(ref v_id
                                                                                   , this.numberTextBox.Text
                                                                                   , v_car_id
                                                                                   , new System.Nullable<decimal>((decimal)Convert.ChangeType(this.employee_recieve_idTextBox.Text, typeof(decimal)))
                                                                                   , v_employee_head_id
                                                                                   , new System.Nullable<decimal>((decimal)Convert.ChangeType(this.employee_worker_idTextBox.Text, typeof(decimal)))
                                                                                   , v_employee_output_id
                                                                                   , new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime)))
                                                                                   , this.order_stateComboBox.Text
                                                                                   , v_repair_type_id
                                                                                   , this.malfunction_descTextBox.Text
                                                                                   , v_repair_zone_master_id
                                                                                   , new System.Nullable<decimal>((decimal)Convert.ChangeType(this.wrh_order_master_type_idtextBox.Text, typeof(decimal)))
                                                                                   , v_run
                                                                                   , this.sys_commentTextBox.Text
                                                                                   , _username);




                    }
                    if (this._warehouse_order_master_form_state != 3)
                    {
                        this.idTextBox.Text = v_id.ToString();
                        this.p_wrh_order_master_idToolStripTextBox.Text = v_id.ToString();
                        this.Prepare_Detail(dataGridViewTextBoxColumn8.Index, this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Rows, this.idTextBox.Text);
                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id);
                        //ORDER_DETAIL_REPAIR_TYPE
                        this.Prepare_Detail(dataGridViewTextBoxColumn32.Index, this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.Rows, this.idTextBox.Text);
                        this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_id);
                    }
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(true);
                    _is_valid = true;
                    if (this._warehouse_order_master_form_state != 3)
                    {
                        this.UspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(sender, e);
                        this.UspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridViewCurrentCellChanged(sender, e);
                    }
                    if (this._warehouse_order_master_form_state == 1)
                    {
                        this.open_demandToolStripMenuItem.Enabled = true;
                    }
                }
                catch (SqlException Sqle)
                {

                    switch (Sqle.Number)
                    {
                        case 515:
                            MessageBox.Show(  "Необходимо заполнить все обязательные поля! "
                                            + "Проверьте, что Вы заполнили все поля выделенные желтым цветом. "
                                            + "Также посмотрите, что указано количество товаров (если есть товар) "
                                            + "и указан(ы) механик(и), часы в таблице выполненных работ (если есть записи в выполненных работах).");
                            break;

                        case 2601:
                            MessageBox.Show("Такой 'Заказ-наряд' или 'Деталь' в этом заказе уже существует");
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
                if ((this.numberTextBox.Text == "")
                  || (this.employee_recieve_idTextBox.Text == "")
                  || (this.employee_worker_idTextBox.Text == "")
                  || (this.date_createdDateTimePicker.Text == "")
                  || (this.malfunction_descTextBox.Text == ""))
                {
                    MessageBox.Show("Необходимо ввести поля 'Получатель',  'Кто выписал з/н', 'Дата поступления', 'Описание неисправности', 'Механик'.");
                }
                else
                {
                    if (_is_all_items_verified == false)
                    {
                        MessageBox.Show("Проверьте, что у вас не указаны одинаковые показатели даты начала ремонта и окончания");
                    }
                    else
                    {
                        if (_is_all_parts_verified == false)
                        {
                            MessageBox.Show("Нельзя указать у заказа-наряда статусы ('Обработан','Закрыт'), если у вас неправильно списаны запчасти");
                        }
                        else
                        {
                            if (_is_all_demands_verified != "Y")
                            {
                                MessageBox.Show("Нельзя указать статус 'Закрыт','Обработан', если еще не проверены все требования.");
                            }
                        }
                    }
                }
                
                  
            }


        }
		//Пересчет выданных товаров
		void CounttoolStripButtonClick(object sender, EventArgs e)
		{
			if (_is_valid == false)
			{
				this.UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItemClick(sender, e);
			}
			if (_is_valid == true)
			{
				if (this.p_wrh_order_master_idToolStripTextBox.Text != "")
				{
					try
					{
						this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_order_master_idToolStripTextBox.Text, typeof(decimal))))), 1);
					}
					catch (System.Exception ex)
					{
						System.Windows.Forms.MessageBox.Show(ex.Message);
					}
				}
			}
			
		}
		
		void Open_demandToolStripMenuItemClick(object sender, EventArgs e)
		{
			if (this.p_wrh_order_master_idToolStripTextBox.Text != "")
			{
                this.CounttoolStripButtonClick(sender, e);
                if (_is_valid == true)
                {

                    using (Warehouse_demand_master Warehouse_demand_masterForm = new Warehouse_demand_master())
                    {
                        {
                            Warehouse_demand_masterForm._where_clause = "wrh_order_master_id="
                                + this.p_wrh_order_master_idToolStripTextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_form_state = 4;
                            Warehouse_demand_masterForm._warehouse_demand_master_wrh_order_master_id
                                = this.idTextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_wrh_order_master_number
                                = this.numberTextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_wrh_demand_master_type_id
                                = this.wrh_order_master_type_idtextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_wrh_demand_master_type_sname
                                = this.wrh_order_master_typecomboBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_state_number
                                = this.state_numberTextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_car_mark_sname
                                = this.car_mark_snameTextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_car_model_sname
                                = this.car_model_snameTextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_car_organization_id
                                = this.car_organization_idtextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_car_organization_sname
                                = this.car_organization_snametextBox.Text;
                            Warehouse_demand_masterForm._warehouse_demand_master_car_id
                                = this.car_idTextBox.Text;
                            Warehouse_demand_masterForm.ShowDialog(this);


                        }
                    }
                    this.CounttoolStripButtonClick(sender, e);

                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
                }
			}
		}

        private void order_stateComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.order_stateComboBox.SelectedItem.ToString() == "Открыт")
            {
                this.date_createdDateTimePicker.Enabled = false;
                this.button_car.Enabled = false;
                this.button_datestarted.Enabled = false;
                this.button_dateended.Enabled = false;
                this.button_employee_output.Enabled = false;
                this.button_head.Enabled = false;
                this.button_mech.Enabled = false;
                this.button_reciever.Enabled = false;
                this.order_stateComboBox.Enabled = false;
                this.contextMenuStrip1.Enabled = false;
                this.contextMenuStrip2.Enabled = false;
                this.contextMenuStrip3.Enabled = false;
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.Enabled = false;
                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
                this.counttoolStripButton.Enabled = false;
                //this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = false;
                this.malfunction_descTextBox.Enabled = false;
                this.malfunction_discTextBox.Enabled = false;
                this.wrh_order_master_typecomboBox.Enabled = false;
                this.start_repairtoolStripButton.Enabled = true;
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Enabled = false;
                this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Enabled = false;
                this.contextMenuStrip4.Enabled = false;
            }
            else
            {
                this.date_createdDateTimePicker.Enabled = true;
                this.button_car.Enabled = true;
                this.button_datestarted.Enabled = true;
                this.button_dateended.Enabled = true;
                this.button_employee_output.Enabled = true;
                this.button_head.Enabled = true;
                this.button_mech.Enabled = true;
                this.button_reciever.Enabled = true;
                this.order_stateComboBox.Enabled = true;
                this.contextMenuStrip1.Enabled = true;
                this.contextMenuStrip2.Enabled = true;
                this.contextMenuStrip3.Enabled = true;
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Enabled = true;
                this.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_idDataGridView.Enabled = true;
                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.Enabled = true;
                this.counttoolStripButton.Enabled = true;
                //this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = true;
                this.malfunction_descTextBox.Enabled = true;
                this.malfunction_discTextBox.Enabled = true;
                this.wrh_order_master_typecomboBox.Enabled = true;
                this.start_repairtoolStripButton.Enabled = false;
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Enabled = true;
                this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Enabled = true;
                this.contextMenuStrip4.Enabled = true;
            }
            if (this.order_stateComboBox.SelectedItem.ToString() == "Корректировка")
            {
                this.runTextBox.Enabled = true;
                this.runTextBox.ReadOnly = false;
            }
            else
            {
                this.runTextBox.Enabled = false;
                this.runTextBox.ReadOnly = true;
            }
        }

        private void lookup_wrh_itemToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Warehouse_item Warehouse_itemForm = new Warehouse_item())
            {
                {

                    Warehouse_itemForm.ShowDialog(this);


                }
            }
        }


        private void choose_by_rpr_typeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.BeginEdit(false);
                if ((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn113")
                    || (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn114")
                    || (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn115")
                   || (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn112")
                    || (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn110"))
                {
                    using (Repair_bill_master Repair_bill_masterForm = new Repair_bill_master())
                    {
                        Repair_bill_masterForm.ShowDialog(this);
                        if (Repair_bill_masterForm.DialogResult == DialogResult.OK)
                        {

                            this.p_repair_bill_master_idToolStripTextBox.Text = Repair_bill_masterForm.Repair_bill_master_id;

                            try
                            {
                                this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_bill_master_idToolStripTextBox.Text, typeof(decimal))))));
                            }
                            catch (System.Exception ex)
                            {
                                System.Windows.Forms.MessageBox.Show(ex.Message);
                            }
                           // MessageBox.Show(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn115.Index].OwningColumn.HeaderText);
                           // MessageBox.Show(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn112.Index].OwningColumn.HeaderText);

                            foreach (DataGridViewRow currentRow in this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.Rows)
                            {
                                try
                                {
                                    if ((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentRow.Cells[dataGridViewTextBoxColumn111.Index].Value.ToString() == "")
                                       && currentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString() != "")
                                    {
                                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
                                    }
                                    if (currentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString() != "")
                                    {
                                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn111.Index].Value
                                            = currentRow.Cells[dataGridViewTextBoxColumn88.Index].Value.ToString();
                                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn113.Index].Value
                                            = currentRow.Cells[dataGridViewTextBoxColumn90.Index].Value.ToString();
                                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value
                                            = currentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString();
                                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn112.Index].Value
                                            = currentRow.Cells[dataGridViewTextBoxColumn91.Index].Value.ToString();
                                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn115.Index].Value
                                            = currentRow.Cells[dataGridViewTextBoxColumn86.Index].Value.ToString();
                                    }
                                }
                                catch { }
                            }

                            _is_valid &= false;
                            Ok_Toggle(_is_valid);
                        }
                    }
                }
            }
            catch { }
        }
        //Проверим наличие списка запчастей для ремонта по умолчанию
        //и подставим данные о запчастях и наименовании работ 
        private void add_default_bill(string p_repair_type_master_id, string p_repair_type_master_name)
        {

            try
            {
                this.uspVRPR_REPAIR_BILL_MASTER_SelectDefaultBy_Repair_type_master_idTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_MASTER_SelectDefaultBy_Repair_type_master_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_type_master_id, typeof(decimal))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            //Если есть запись о значении по умолчанию заполним наименование работ
            //и сведения о запчастях
            if (this.uspVRPR_REPAIR_BILL_MASTER_SelectDefaultBy_Repair_type_master_idDataGridView.RowCount > 1)
            {
               // if (this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1)
              //  {
                    this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingSource.AddNew();
              //  }

                this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
                    = p_repair_type_master_name;

                //

                this.p_repair_bill_master_idToolStripTextBox.Text
                    = this.uspVRPR_REPAIR_BILL_MASTER_SelectDefaultBy_Repair_type_master_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn92.Index].Value.ToString();

                try
                {
                    this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_bill_master_idToolStripTextBox.Text, typeof(decimal))))));
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }

                foreach (DataGridViewRow currentRow in this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.Rows)
                {
                    try
                    {
                        if  (currentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString() != "")
                        {
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                        }
                        if (currentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString() != "")
                        {
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                                = currentRow.Cells[dataGridViewTextBoxColumn88.Index].Value.ToString();
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                                = currentRow.Cells[dataGridViewTextBoxColumn90.Index].Value.ToString();
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                                = currentRow.Cells[dataGridViewTextBoxColumn89.Index].Value.ToString();
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                                = currentRow.Cells[dataGridViewTextBoxColumn91.Index].Value.ToString();
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                                = currentRow.Cells[dataGridViewTextBoxColumn86.Index].Value.ToString();
                        }
                        if (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount == 1)
                        {
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
                        }
                    }
                    catch { }
                }
            }
            _is_valid &= false;
            Ok_Toggle(_is_valid);

            
        }

        private void start_repairtoolStripButton_Click(object sender, EventArgs e)
        {
            this.date_startedtextBox.Text = "";
            this.date_endedtextBox.Text = "";
            //this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingSource.AddNew();
           // this.uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value =
            //    "-//-";
            this.order_stateComboBox.Text = "Взят на ремонт, сведений о необх. запчастях нет";
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void button_datestarted_Click(object sender, EventArgs e)
        {
            using (Date_chooser Date_chooserForm = new Date_chooser())
            {
                Date_chooserForm._date_chooser_format_type = "Custom";
                Date_chooserForm._date_chooser_format = "dd.MM.yyyy HH:mm";
                Date_chooserForm.ShowDialog(this);
                if (Date_chooserForm.DialogResult == DialogResult.OK)
                {
                    this.date_startedtextBox.Text = Date_chooserForm.Short_date_value + " " + Date_chooserForm.Short_time_value;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
                }
            }
            
        }

        private void button_dateended_Click(object sender, EventArgs e)
        {
            using (Date_chooser Date_chooserForm = new Date_chooser())
            {
                Date_chooserForm._date_chooser_format_type = "Custom";
                Date_chooserForm._date_chooser_format = "dd.MM.yyyy HH:mm";
                Date_chooserForm.ShowDialog(this);
                if (Date_chooserForm.DialogResult == DialogResult.OK)
                {
                    this.date_endedtextBox.Text = Date_chooserForm.Short_date_value + " " + Date_chooserForm.Short_time_value;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
                }
            }
            
        }

        private void cancel_ordertoolStripButton_Click(object sender, EventArgs e)
        {
            this.order_stateComboBox.Text = "Отклонен";
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {//Проверим выданное количество по складу -  отметим минусовые значения серым цветом
            try
            {
                if ((int)Convert.ChangeType(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn36.Index].Value, typeof(int)) < 0)
                {
                    this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Red;
                }
                else
                {
                    this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.DefaultCellStyle.BackColor;
                }
            }
            catch (Exception Appe)
            { }
        }

        private bool Is_Datetime_Duty_Valid()
        {
            DateTime v_fact_start_duty = DateTime.Now, v_fact_end_duty = DateTime.Now;
            bool v_result = false;
            try
            {
                v_fact_start_duty = (DateTime)Convert.ChangeType(this.date_startedtextBox.Text, typeof(DateTime));
            }
            catch
            {
                //MessageBox.Show("Указан неверный формат времени начала ремонта");
            }

            try
            {
                v_fact_end_duty = (DateTime)Convert.ChangeType(this.date_endedtextBox.Text, typeof(DateTime));
            }
            catch
            {
               // MessageBox.Show("Указан неверный формат времени окончания ремонта");
            }

            if (v_fact_end_duty > v_fact_start_duty)
            {
                v_result = true;
                //Ok_Toggle(true);
            }
            else
            {
                //Ok_Toggle(false);
            }

            return v_result;
        }

        //Функция проверяет элементы на правильность заполнения
        private bool Check_Items()
        {
            bool v_is_counted = true;

            v_is_counted &= Is_Datetime_Duty_Valid();
            if (Is_Datetime_Duty_Valid())
            {
                this.date_startedDateTimePicker.ForeColor
                    = Color.Black;
                //this.fact_start_duty_time_visible_textBox.ForeColor
                //    = Color.Black;
                this.date_endedDateTimePicker.ForeColor
                    = Color.Black;
                //this.fact_end_duty_time_visible_textBox.ForeColor
                //    = Color.Black;
                this.Datetime_duty_errorProvider.SetError(this.date_endedDateTimePicker, "");

            }
            else
            {
                this.date_startedDateTimePicker.ForeColor
                    = Color.Red;
                //this.fact_start_duty_time_visible_textBox.ForeColor
                //    = Color.Red;
                this.date_endedDateTimePicker.ForeColor
                    = Color.Red;
                //this.fact_end_duty_time_visible_textBox.ForeColor
                //    = Color.Red;
                this.Datetime_duty_errorProvider.SetError(this.date_endedDateTimePicker, "Проверьте время и дату");

            }


            return v_is_counted;
        }

        private void uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentRow.Cells[dataGridViewTextBoxColumn108.Index].Value
             = _username;
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentRow.Index + 1)
                    != this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.RowCount)
                {

                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentRow.Index + 1)
                    != this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой
                if (((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentRow.Index + 1)
                     == this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.RowCount)
                    && (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.CurrentRow.Index + 1)
                        == this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.RowCount)
                    {
                        this.DeleteToolStripMenuItem.Enabled = false;
                        //this.InsertToolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;


                    }
                    else
                    {
                        this.DeleteToolStripMenuItem.Enabled = true;
                        //this.InsertToolStripMenuItem.Enabled = true;
                        this.EditToolStripMenuItem.Enabled = true;


                    }
                    if (this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.RowCount == 1)
                    {
                        this.open_demandToolStripMenuItem.Enabled = false;
                    }
                    else
                    {
                        this.open_demandToolStripMenuItem.Enabled = true;
                    }
                }


            }
            catch (Exception Appe)
            {
            }
        }

        private void uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                throw e.Exception;
            }
            catch (Exception Appe)
            {
                MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
            }
        }

        private void uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим выданное количество по складу -  отметим минусовые значения серым цветом
            try
            {
                if ((int)Convert.ChangeType(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn116.Index].Value, typeof(int)) < 0)
                {
                    this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Red;
                }
                else
                {
                    if ((int)Convert.ChangeType(this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn116.Index].Value, typeof(int)) > 0)
                    {
                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightYellow;
                    }
                    else
                    {
                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView1.DefaultCellStyle.BackColor;
                    }
                }
            }
            catch (Exception Appe)
            { }
        }

        private void counttoolStripButton1_Click(object sender, EventArgs e)
        {
            if (_is_valid == false)
            {
                this.UspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_IdBindingNavigatorSaveItemClick(sender, e);
            }
            if (_is_valid == true)
            {
                if (this.p_wrh_order_master_idToolStripTextBox.Text != "")
                {
                    try
                    {
                        this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_order_master_idToolStripTextBox.Text, typeof(decimal))))), 1);
                    }
                    catch (System.Exception ex)
                    {
                        System.Windows.Forms.MessageBox.Show(ex.Message);
                    }
                }
            }
        }

        private void fillToolStripButton8_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime))))), p_StrToolStripTextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

        }

        private void uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView_CurrentCellChanged(object sender, EventArgs e)
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
                    && (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip4.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip4.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                        == this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.RowCount)
                    {
                        this.DeletetoolStripMenuItem4.Enabled = false;
                       // this.InsertToolStripMenuItem4.Enabled = false;
                        this.EdittoolStripMenuItem4.Enabled = false;


                    }
                    else
                    {
                        this.DeletetoolStripMenuItem4.Enabled = true;
                      //  this.InsertToolStripMenuItem4.Enabled = true;
                        this.EdittoolStripMenuItem4.Enabled = true;

                    }
                }


            }
            catch (Exception Appe)
            {
            }
        }

        private void uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                throw e.Exception;
            }
            catch (Exception Appe)
            {
                MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
            }
        }

        private void uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие закрытых требований и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Columns[e.ColumnIndex].Name == "dataGridViewTextBoxColumn145")
                {

                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[this.dataGridViewTextBoxColumn145.Index].Value.ToString() == "Проверен")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightGreen;
                    }

                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[this.dataGridViewTextBoxColumn145.Index].Value.ToString() == "Корректировка")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Purple;
                    }

                    if (this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[this.dataGridViewTextBoxColumn145.Index].Value.ToString() == "Не проверен")
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.DefaultCellStyle.BackColor;


                    }


                }
            }
            catch (Exception Appe)
            { }
        }

        private void InsertToolStripMenuItem4_Click(object sender, EventArgs e)
        {
             this.CounttoolStripButtonClick(sender, e);
             if (_is_valid == true)
             {

                 using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
                 {
                     Warehouse_demand_detailForm.Text = "Вставка на основе з/н -";
                     Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = "";
                     Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = "";

                     //Попробуем взять данные из переменных формы
                     try
                     {

                         Warehouse_demand_detailForm._warehouse_demand_master_car_id = car_idTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_car_mark_sname = this.car_mark_snameTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_car_model_sname = this.car_model_snameTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_form_state = 4;
                         Warehouse_demand_detailForm._warehouse_demand_master_state_number = this.state_numberTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = this.wrh_order_master_type_idtextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = this.wrh_order_master_typecomboBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_id = this.idTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_number = this.numberTextBox.Text;

                         Warehouse_demand_detailForm._warehouse_demand_master_employee_head_id = this.employee_head_idTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_head = this.fIO_employee_headTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_employee_recieve_id = this.employee_recieve_idTextBox.Text;

                         Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_recieve = this.fIO_employee_recieveTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_employee_worker_id = this.employee_worker_idTextBox.Text;
                         Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_worker = this.fIO_employee_workerTextBox.Text;
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
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn125.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_car_id;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_state_number != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn126.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_state_number;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn127.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_number != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn129.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_number;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn130.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn131.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn132.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn133.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn134.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn135.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker;
                         }


                         if (Warehouse_demand_detailForm.Warehouse_demand_master_date_created != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn136.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_date_created;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_master_id != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn118.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_master_id;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn138.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn137.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id;
                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn139.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id;

                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn140.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname;

                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn141.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id;

                         }

                         if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn142.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number;

                         }


                         if (Warehouse_demand_detailForm.Warehouse_demand_master_is_verified != "")
                         {
                             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn145.Index].Value
                                 = Warehouse_demand_detailForm.Warehouse_demand_master_is_verified;

                         }


                         this.CounttoolStripButtonClick(sender, e);

                         _is_valid &= false;
                         Ok_Toggle(_is_valid);
                     }
                 }
             }
             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.Filter = "wrh_order_master_id="
                 + this.p_wrh_order_master_idToolStripTextBox.Text;
             this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox2.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox2.Text, typeof(System.DateTime)))))
                                                       , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                       , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                       , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));

        }

        private void EdittoolStripMenuItem4_Click(object sender, EventArgs e)
        {
              this.CounttoolStripButtonClick(sender, e);
              if (_is_valid == true)
              {


                  using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
                  {
                      Warehouse_demand_detailForm.Text = "Редактирование -";

                      Warehouse_demand_detailForm._warehouse_demand_master_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn118.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_car_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn125.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_car_mark_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn127.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_car_model_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_date_created = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn136.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_head = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn133.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_employee_head_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn132.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_recieve = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn131.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_employee_recieve_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn130.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_worker = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn135.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_employee_worker_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn134.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_form_state = 2;
                      Warehouse_demand_detailForm._warehouse_demand_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn129.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_state_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn126.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn137.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn138.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn139.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn140.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn141.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn142.Index].Value.ToString();
                      Warehouse_demand_detailForm._warehouse_demand_master_is_verified = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn145.Index].Value.ToString();

                      Warehouse_demand_detailForm.ShowDialog(this);
                      if (Warehouse_demand_detailForm.DialogResult == DialogResult.OK)
                      {

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_car_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn125.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_car_id;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_state_number != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn126.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_state_number;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn127.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_car_mark_sname;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_car_model_sname;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_number != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn129.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_number;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn130.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_employee_recieve_id;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn131.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_recieve;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn132.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_employee_head_id;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn133.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_head;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn134.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_employee_worker_id;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn135.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_fio_employee_worker;
                          }


                          if (Warehouse_demand_detailForm.Warehouse_demand_master_date_created != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn136.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_date_created;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_master_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn118.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_master_id;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn138.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_sname;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn137.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_demand_master_type_id;
                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn139.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_id;

                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn140.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_organization_giver_sname;

                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn141.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_id;

                          }

                          if (Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn142.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_wrh_order_master_number;

                          }


                          if (Warehouse_demand_detailForm.Warehouse_demand_master_is_verified != "")
                          {
                              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn145.Index].Value
                                  = Warehouse_demand_detailForm.Warehouse_demand_master_is_verified;

                          }

                          this.CounttoolStripButtonClick(sender, e);

                          _is_valid &= false;
                          Ok_Toggle(_is_valid);



                      }
                  }
              }
              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.Filter = "wrh_order_master_id="
                + this.p_wrh_order_master_idToolStripTextBox.Text;
              this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox2.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox2.Text, typeof(System.DateTime)))))
                                                        , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
        }

        private void DeletetoolStripMenuItem4_Click(object sender, EventArgs e)
        {
            this.CounttoolStripButtonClick(sender, e);
            if (_is_valid == true)
            {

                using (Warehouse_demand_detail Warehouse_demand_detailForm = new Warehouse_demand_detail())
                {
                    Warehouse_demand_detailForm.Text = "Удаление -";

                    Warehouse_demand_detailForm._warehouse_demand_master_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn118.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_car_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn125.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_car_mark_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn127.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_car_model_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_date_created = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn136.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_head = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn133.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_employee_head_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn132.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_recieve = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn131.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_employee_recieve_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn130.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_fio_employee_worker = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn135.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_employee_worker_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn134.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_form_state = 3;
                    Warehouse_demand_detailForm._warehouse_demand_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn129.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_state_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn126.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn137.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_detail_wrh_demand_master_type_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn138.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn139.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_organization_giver_sname = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn140.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_id = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn141.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_wrh_order_master_number = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn142.Index].Value.ToString();
                    Warehouse_demand_detailForm._warehouse_demand_master_is_verified = this.uspVWRH_WRH_DEMAND_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn145.Index].Value.ToString();
                    Warehouse_demand_detailForm.ShowDialog(this);
                    if (Warehouse_demand_detailForm.DialogResult == DialogResult.OK)
                    {
                        this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.RemoveCurrent();
                        //_is_valid = false;
                        //Ok_Toggle(false);

                        this.CounttoolStripButtonClick(sender, e);

                        _is_valid &= false;
                        Ok_Toggle(_is_valid);

                    }
                }
            }
            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.Filter = "wrh_order_master_id="
                + this.p_wrh_order_master_idToolStripTextBox.Text;
            this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox2.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox2.Text, typeof(System.DateTime)))))
                                                      , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                      , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                      , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
        }

   	
	}
}
