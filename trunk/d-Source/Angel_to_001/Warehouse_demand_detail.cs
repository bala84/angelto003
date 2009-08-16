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
	public partial class Warehouse_demand_detail : Form
	{
        public string _username;

		public string _warehouse_demand_master_master_id;
		public string _warehouse_demand_master_car_id;
		public string _warehouse_demand_master_state_number;
		public string _warehouse_demand_master_car_mark_sname;
		public string _warehouse_demand_master_car_model_sname;
		public string _warehouse_demand_master_number;
		public string _warehouse_demand_master_employee_recieve_id;
		public string _warehouse_demand_master_fio_employee_recieve;
		public string _warehouse_demand_master_employee_head_id;
		public string _warehouse_demand_master_fio_employee_head;
		public string _warehouse_demand_master_employee_worker_id;
		public string _warehouse_demand_master_fio_employee_worker;
		public string _warehouse_demand_master_date_created;
		public string _warehouse_demand_detail_last_amount;
		public string _warehouse_demand_detail_wrh_demand_master_type_id;
		public string _warehouse_demand_detail_wrh_demand_master_type_sname;
		public string _warehouse_demand_master_organization_giver_id;
		public string _warehouse_demand_master_organization_giver_sname;
        public string _warehouse_demand_master_car_organization_id;
        public string _warehouse_demand_master_car_organization_name;
		public string _warehouse_demand_master_wrh_order_master_id;
		public string _warehouse_demand_master_wrh_order_master_number;
        public string _warehouse_demand_master_is_verified;
		
		
		private bool _is_valid = true;
        private string _old_amount = "";
        private DateTime _old_date_created;
		private DataGridViewSelectedRowCollection _selected_rows;
		//Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
		public byte _warehouse_demand_master_form_state;
		
		public string Warehouse_demand_master_master_id
		{
			get { return this.idTextBox.Text; }
		}
		
		public string Warehouse_demand_master_car_id
		{
			get { return this.car_idTextBox.Text; }
		}
		
		public string Warehouse_demand_master_state_number
		{
			get { return this.state_numberTextBox.Text; }
		}
		
		public string Warehouse_demand_master_car_mark_sname
		{
			get { return this.car_mark_snameTextBox.Text; }
		}
		
		public string Warehouse_demand_master_car_model_sname
		{
			get { return this.car_model_snameTextBox.Text; }
		}
		
		public string Warehouse_demand_master_number
		{
			get { return this.numberTextBox.Text; }
		}
		
		public string Warehouse_demand_master_employee_recieve_id
		{
			get { return this.employee_recieve_idTextBox.Text; }
		}
		
		public string Warehouse_demand_master_fio_employee_recieve
		{
			get { return this.fIO_employee_recieveTextBox.Text; }
		}
		public string Warehouse_demand_master_employee_head_id
		{
			get { return this.employee_head_idTextBox.Text; }
		}
		
		public string Warehouse_demand_master_fio_employee_head
		{
			get { return this.fIO_employee_headTextBox.Text; }
		}
		
		public string Warehouse_demand_master_employee_worker_id
		{
			get { return this.employee_worker_idTextBox.Text; }
		}
		
		public string Warehouse_demand_master_fio_employee_worker
		{
			get { return this.fIO_employee_workerTextBox.Text; }
		}
		
		public string Warehouse_demand_master_date_created
		{
			get { return this.date_createdDateTimePicker.Text; }
		}
		
		public string Warehouse_demand_master_wrh_demand_master_type_id
		{
			get { return this.wrh_demamd_master_type_idtextBox.Text; }
		}
		
		public string Warehouse_demand_master_wrh_demand_master_type_sname
		{
			get { return this.wrh_demand_master_typecomboBox.Text; }
		}
		
		public string Warehouse_demand_master_organization_giver_id
		{
			get { return this.org_giver_idtextBox.Text; }
		}
		
		public string Warehouse_demand_master_organization_giver_sname
		{
			get { return this.org_givertextBox.Text; }
		}
		
		public string Warehouse_demand_master_wrh_order_master_id
		{
			get { return this.order_idtextBox.Text; }
		}
		public string Warehouse_demand_master_wrh_order_master_number
		{
			get { return this.ordertextBox.Text; }
		}

        public string Warehouse_demand_master_is_verified
        {
            get { return this.wrh_demand_state_nameComboBox.Text; }
        }
		
		
		
		public Warehouse_demand_detail()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}
		
		//Процедура подготовки детальной таблицы для записи
        void Prepare_Detail(string p_last_organization_giver_id)
		{
			try
			{
				foreach(DataGridViewRow currentRow in this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.Rows)
				{
					currentRow.Cells[dataGridViewTextBoxColumn8.Index].Value = this.idTextBox.Text;
                    if (this._warehouse_demand_master_form_state == 2)
                    {
                        currentRow.Cells[this.last_organization_giver_id.Index].Value = p_last_organization_giver_id;
                    }
				}
			}
			catch{}
		}


		private void uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
			
			

			Nullable<decimal> v_id = new Nullable<decimal>();
			Nullable<decimal> v_car_id = new Nullable<decimal> ();
			Nullable<long> v_last_amount = new Nullable<long> ();
			Nullable<decimal> v_organization_giver_id = new Nullable<decimal> ();
			Nullable<decimal> v_whr_order_master_id = new Nullable<decimal> ();
            string v_last_organization_giver_id = "";
			if   (//(this.numberTextBox.Text != "")
			      //&&
			      (this.employee_recieve_idTextBox.Text != "")
			      &&(this.employee_head_idTextBox.Text != "")
			      &&(this.employee_worker_idTextBox.Text != "")
			      &&(this.date_createdDateTimePicker.Text != "")
			      &&((this.car_idTextBox.Text != "")&&(this.wrh_demamd_master_type_idtextBox.Text == Const.Wrh_demand_master_type_car_id.ToString())
			         ||(this.wrh_demamd_master_type_idtextBox.Text == Const.Wrh_demand_master_type_worker_id.ToString())
			         ||(this.wrh_demamd_master_type_idtextBox.Text == Const.Wrh_demand_master_type_expense_id.ToString())
			         ||(this.wrh_demamd_master_type_idtextBox.Text == Const.Wrh_demand_master_type_motor_id.ToString()))
			       &&(this.org_giver_idtextBox.Text != "")
			      //&&(this.state_numberTextBox.Text != "")
			      // &&(this.car_mark_snameTextBox.Text != "")
			      //  &&(this.car_model_snameTextBox.Text != "")
			     )
			{
				try
				{
					if (this.wrh_demamd_master_type_idtextBox.Text != Const.Wrh_demand_master_type_car_id.ToString())
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
					
					this.Validate();
					this.uspVWRH_WRH_DEMAND_MASTER_SelectAllBindingSource.EndEdit();
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
					if (this._warehouse_demand_master_form_state == 3)
					{
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))), "-", "-");
					}
					else
					{
						if (this.car_idTextBox.Text != "")
						{
							v_car_id = (decimal)Convert.ChangeType(this.car_idTextBox.Text, typeof(decimal));
						}
						
						if (this.org_giver_idtextBox.Text != "")
						{
							v_organization_giver_id = (decimal)Convert.ChangeType(this.org_giver_idtextBox.Text, typeof(decimal));
						}

						
						if (this.order_idtextBox.Text != "")
						{
							v_whr_order_master_id = (decimal)Convert.ChangeType(this.order_idtextBox.Text, typeof(decimal));
						}

                        if (this.last_organization_giver_idtextBox.Text != "")
                        {
                            v_last_organization_giver_id = this.last_organization_giver_idtextBox.Text;
                        }
						
						
						
						this.uspVWRH_WRH_DEMAND_MASTER_SelectAllTableAdapter.Update(ref v_id
						                                                            ,this.numberTextBox.Text
						                                                            ,v_car_id
						                                                            ,new System.Nullable<decimal>((decimal)Convert.ChangeType(this.employee_recieve_idTextBox.Text, typeof(decimal)))
						                                                            ,new System.Nullable<decimal>((decimal)Convert.ChangeType(this.employee_head_idTextBox.Text, typeof(decimal)))
						                                                            ,new System.Nullable<decimal>((decimal)Convert.ChangeType(this.employee_worker_idTextBox.Text, typeof(decimal)))
						                                                            ,new System.Nullable<DateTime>((DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime)))
						                                                            ,new System.Nullable<decimal>((decimal)Convert.ChangeType(this.wrh_demamd_master_type_idtextBox.Text, typeof(decimal)))
						                                                            ,v_organization_giver_id
						                                                            ,v_whr_order_master_id
                                                                                    ,this.wrh_demand_state_nameComboBox.Text
						                                                            ,this.sys_commentTextBox.Text
						                                                            ,this.sys_user_modifiedTextBox.Text);
					}
					if (this._warehouse_demand_master_form_state != 3)
					{
						this.idTextBox.Text = v_id.ToString();
						this.p_wrh_demand_master_idToolStripTextBox.Text = v_id.ToString();
						this.Prepare_Detail(v_last_organization_giver_id);
						this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_Id);
					}
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(true);
					_is_valid = true;
					if (this._warehouse_demand_master_form_state != 3)
					{
						this.UspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(sender, e);
					}
				}
				catch (SqlException Sqle)
				{

					switch (Sqle.Number)
					{
						case 515:
							MessageBox.Show("Необходимо заполнить все обязательные поля!");
							break;

						case 2601:
							MessageBox.Show("Такой '№ Требования' или 'Товар', указанный в этом требовании, уже существуют");
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
				if (this.wrh_demamd_master_type_idtextBox.Text == Const.Wrh_demand_master_type_car_id.ToString())
				{
					MessageBox.Show("Проверьте, что Вы заполнили поля: 'Кто выдал', 'Кто разрешил', 'Получатель','№ СТП', 'Организация'");
				}
				if (this.wrh_demamd_master_type_idtextBox.Text == Const.Wrh_demand_master_type_worker_id.ToString())
				{
					MessageBox.Show("Проверьте, что Вы заполнили поля: 'Кто выдал', 'Кто разрешил', 'Получатель', 'Организация'");
				}
				
			}

			
		}

		
		void Warehouse_demand_detailLoad(object sender, EventArgs e)
		{
            this.wrh_demand_state_nameComboBox.Text = "Не проверен";

			if (( _warehouse_demand_master_master_id != "")
                &&(_warehouse_demand_master_master_id != null))
			{
				this.idTextBox.Text = _warehouse_demand_master_master_id;
				this.p_wrh_demand_master_idToolStripTextBox.Text = _warehouse_demand_master_master_id;
			}
			
			if (( _warehouse_demand_master_car_id != "")
                &&(_warehouse_demand_master_car_id != null))
			{
				this.car_idTextBox.Text = _warehouse_demand_master_car_id;
			}
			
			if (( _warehouse_demand_master_state_number != "")
                &&(_warehouse_demand_master_state_number != null))
			{
				this.state_numberTextBox.Text = _warehouse_demand_master_state_number;
			}
			
			if (( _warehouse_demand_master_car_mark_sname != "")
                &&(_warehouse_demand_master_car_mark_sname != null))
			{
				this.car_mark_snameTextBox.Text = _warehouse_demand_master_car_mark_sname;
			}
			
			
			if (( _warehouse_demand_master_car_model_sname != "")
                &&(_warehouse_demand_master_car_model_sname != null))
			{
				this.car_model_snameTextBox.Text = _warehouse_demand_master_car_model_sname;
			}
			
			
			if (( _warehouse_demand_master_number != "")
                &&(_warehouse_demand_master_number != null))
			{
				this.numberTextBox.Text = _warehouse_demand_master_number;
			}
			
			if (( _warehouse_demand_master_employee_recieve_id != "")
               &&(_warehouse_demand_master_employee_recieve_id != null))
			{
				this.employee_recieve_idTextBox.Text = _warehouse_demand_master_employee_recieve_id;
			}
			
			
			if (( _warehouse_demand_master_fio_employee_recieve != "")
               &&(_warehouse_demand_master_fio_employee_recieve != null))
			{
				this.fIO_employee_recieveTextBox.Text = _warehouse_demand_master_fio_employee_recieve;
			}
			
			if (( _warehouse_demand_master_employee_head_id != "")
               &&(_warehouse_demand_master_employee_head_id != null))
			{
				this.employee_head_idTextBox.Text = _warehouse_demand_master_employee_head_id;
			}
			if (( _warehouse_demand_master_fio_employee_head != "")
               &&(_warehouse_demand_master_fio_employee_head != null))
			{
				this.fIO_employee_headTextBox.Text = _warehouse_demand_master_fio_employee_head;
			}
			
			if (( _warehouse_demand_master_employee_worker_id != "")
               &&(_warehouse_demand_master_employee_worker_id != null))
			{
				this.employee_worker_idTextBox.Text = _warehouse_demand_master_employee_worker_id;
			}
			
			if (( _warehouse_demand_master_fio_employee_worker != "")
               &&(_warehouse_demand_master_fio_employee_worker != null))
			{
				this.fIO_employee_workerTextBox.Text = _warehouse_demand_master_fio_employee_worker;
			}
			
			if (( _warehouse_demand_master_date_created != "")
               &&(_warehouse_demand_master_date_created != null))
			{
				this.date_createdDateTimePicker.Text = _warehouse_demand_master_date_created;
			}
			
			if (( _warehouse_demand_detail_wrh_demand_master_type_id != "")
               &&(_warehouse_demand_detail_wrh_demand_master_type_id != null))
			{
				this.wrh_demamd_master_type_idtextBox.Text = _warehouse_demand_detail_wrh_demand_master_type_id;
			}
			
			if (( _warehouse_demand_detail_wrh_demand_master_type_sname != "")
                &&(_warehouse_demand_detail_wrh_demand_master_type_sname != null))
			{
				this.wrh_demand_master_typecomboBox.Text = _warehouse_demand_detail_wrh_demand_master_type_sname;
			}

            if ((_warehouse_demand_master_organization_giver_id != "")
                &&(_warehouse_demand_master_organization_giver_id != null))
            {
                this.org_giver_idtextBox.Text = _warehouse_demand_master_organization_giver_id;
            }
                //Попробуем подставить организацию по справочнику автомобилей

                if ( (_warehouse_demand_master_car_organization_id != "")
                       &&(this._warehouse_demand_master_form_state == 4)
                       &&(_warehouse_demand_master_car_organization_id != null))
                {
                    this.org_giver_idtextBox.Text = _warehouse_demand_master_car_organization_id;
                }

            if ((_warehouse_demand_master_organization_giver_sname != "")
                                &&(_warehouse_demand_master_organization_giver_sname != null))
            {
                this.org_givertextBox.Text = _warehouse_demand_master_organization_giver_sname;
            }
           
                if ((_warehouse_demand_master_car_organization_name != "")
                    &&(this._warehouse_demand_master_form_state == 4)
                    &&(_warehouse_demand_master_car_organization_name != null))
                {
                    this.org_givertextBox.Text = _warehouse_demand_master_car_organization_name;
                }
 
			if (( _warehouse_demand_master_wrh_order_master_id != "")
                 &&(_warehouse_demand_master_wrh_order_master_id != null))
			{
				this.order_idtextBox.Text = _warehouse_demand_master_wrh_order_master_id;
			}
			
			if (( _warehouse_demand_master_wrh_order_master_number != "")
                 &&(_warehouse_demand_master_wrh_order_master_number != null))
			{
				this.ordertextBox.Text = _warehouse_demand_master_wrh_order_master_number;
			}

            if ((_warehouse_demand_master_is_verified != "")
                 &&(_warehouse_demand_master_is_verified != null))
            {
                this.wrh_demand_state_nameComboBox.Text = _warehouse_demand_master_is_verified;
            }
			
			
			this.Text = this.Text + " требование";
			
			
			if (this.p_wrh_demand_master_idToolStripTextBox.Text != "")
			{
				try
				{
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_demand_master_idToolStripTextBox.Text, typeof(decimal))))));
				}
				catch (System.Exception ex)
				{
					System.Windows.Forms.MessageBox.Show(ex.Message);
				}
			}
			
			if (_warehouse_demand_master_form_state == 3)
			{
				this.BackColor = Color.Red;
				this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = false;
				this.numberTextBox.Enabled = false;
				this.button_reciever.Enabled = false;
				this.button_head.Enabled = false;
				this.button_worker.Enabled = false;
				this.date_createdDateTimePicker.Enabled = false;
				this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
				this.contextMenuStrip1.Enabled = false;
                this.button_order.Enabled = false;
                this.wrh_demand_state_nameComboBox.Enabled = false;
				Ok_Toggle(true);
			}
			else
			{
				this.BackColor = System.Drawing.SystemColors.Control;
				this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = true;
				Ok_Toggle(_is_valid);
			}
			
			
			if( (_warehouse_demand_detail_wrh_demand_master_type_id == "")
                &&(_warehouse_demand_detail_wrh_demand_master_type_id != null))
			{
				this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_car_id.ToString();
			}
			if ((_warehouse_demand_detail_wrh_demand_master_type_sname == "")
                &&(_warehouse_demand_detail_wrh_demand_master_type_sname!= null))
			{
				this.wrh_demand_master_typecomboBox.Text = Const.Wrh_demand_master_type_car_sname;
			}

                this.last_organization_giver_idtextBox.Text = this.org_giver_idtextBox.Text;
            //Если требование создается по заказу-наряду, то необходимо попытаться добавить товары из з-н
            if (this._warehouse_demand_master_form_state == 4)
            {
                try
                {
                   // this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.BeginEdit(false);
                   

                        this.p_wrh_order_master_idToolStripTextBox.Text = this.order_idtextBox.Text;

                        try
                        {
                            this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_wrh_order_master_idToolStripTextBox.Text, typeof(decimal))))), 2);
                        }
                        catch (System.Exception ex)
                        {
                            System.Windows.Forms.MessageBox.Show(ex.Message);
                        }

                        foreach (DataGridViewRow currentRow in this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdDataGridView.Rows)
                        {
                            try
                            {
                                if (currentRow.Cells[dataGridViewTextBoxColumn38.Index].Value.ToString() != "")
                                {
                                    this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                                
                                    this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                                        = currentRow.Cells[dataGridViewTextBoxColumn38.Index].Value.ToString();
                                    this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                                        = currentRow.Cells[dataGridViewTextBoxColumn40.Index].Value.ToString();
                                    this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                                        = currentRow.Cells[dataGridViewTextBoxColumn41.Index].Value.ToString();
                                    this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                                        = currentRow.Cells[dataGridViewTextBoxColumn42.Index].Value.ToString();
                                    this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                                        = currentRow.Cells[dataGridViewTextBoxColumn39.Index].Value.ToString();
                                }
                            }
                            catch { }
                        }

                        _is_valid &= false;
                        Ok_Toggle(_is_valid);
                    

                }
                catch { }
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
				this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click(sender, e);
			}
		}
		
		void InsertToolStripMenuItemClick(object sender, EventArgs e)
		{
            if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount == 1)
            {
                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.AddNew();
            }

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void EditToolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{
				this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.BeginEdit(false);
				if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11")
				    ||(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn12")
				    ||(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13"))
				{
					using (Good_category Good_categoryForm = new Good_category())
					{
						Good_categoryForm.ShowDialog(this);
						if (Good_categoryForm.DialogResult == DialogResult.OK)
						{
                            if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount == 1)
                            {
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
                            }
                            if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString()
                                != Good_categoryForm.Good_category_id)
                            {
                            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                                    = DBNull.Value;
                            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                                    = "";
                            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.price.Index].Value
                                    = DBNull.Value;
                            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.number.Index].Value
                                    = "";
                            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.wrh_income_detail_id.Index].Value
                                    = DBNull.Value;
                             }

							this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
								= Good_categoryForm.Good_category_good_mark;
							this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
								= Good_categoryForm.Good_category_sname;
							this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
								= Good_categoryForm.Good_category_unit;
							this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
								= Good_categoryForm.Good_category_id;
							_is_valid &= false;
							Ok_Toggle(_is_valid);
						}
					}
				}
				
				if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn15")
				{
					using (Warehouse_type Warehouse_typeForm = new Warehouse_type())
					{
						Warehouse_typeForm.ShowDialog(this);
						if (Warehouse_typeForm.DialogResult == DialogResult.OK)
						{

                            if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString()
                                != Warehouse_typeForm.Warehouse_type_id)
                            {
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.price.Index].Value
                                        = DBNull.Value;
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.number.Index].Value
                                        = "";
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.wrh_income_detail_id.Index].Value
                                        = DBNull.Value;
                            }


							this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
								= Warehouse_typeForm.Warehouse_type_short_name;
							this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
								= Warehouse_typeForm.Warehouse_type_id;
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
			this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridViewCurrentCellChanged(object sender, EventArgs e)
		{
            
			try
			{
				//Если это не последняя строка, то проверим содержимое
				if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				    != this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
				     == this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount)
				    &&(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
					    == this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount)
					{
						this.DeleteToolStripMenuItem.Enabled = false;
						this.EditToolStripMenuItem.Enabled = false;
						
						
					}
					else
					{
						this.DeleteToolStripMenuItem.Enabled = true;
						this.EditToolStripMenuItem.Enabled = true;
						
					}
                    //Отключим выбор по виду ремонта на выборе склада
                    if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                        == "dataGridViewTextBoxColumn15")
                    {
                        this.choose_by_rpr_typeToolStripMenuItem.Visible = false;
                    }
                    else
                    {
                        this.choose_by_rpr_typeToolStripMenuItem.Visible = true;
                    }
                   try
                   {
                    //Включим меню выбора цены при присутствии товара, склада и количества
                    if (((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                        == "dataGridViewTextBoxColumn15")
                        ||(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                        == "price")
                        || (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                        == "number"))
                        &&(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString() != "")
                        && (this.org_givertextBox.Text != "")
                        && (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString() != "")
                        && (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString() != ""))
                    {
                        this.choose_price_wrhToolStripMenuItem.Visible = true;
                    }
                    else
                    {
                        this.choose_price_wrhToolStripMenuItem.Visible = false;
                    }
                   }
                    catch {}

                   try
                   {
                       //Включим меню просмотра прих. документа при присутствии товара
                       if (((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                           == "dataGridViewTextBoxColumn15")
                           || (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                           == "price")
                           || (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                            == "number"))
                           && (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString() != "")
                           && (this.org_givertextBox.Text != "")
                           && (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.wrh_income_detail_id.Index].Value.ToString() != ""))
                       {
                           this.view_wrh_incometoolStripMenuItem.Visible = true;
                           this.clear_wrh_incomeToolStripMenuItem.Visible = true;
                       }
                       else
                       {
                           this.view_wrh_incometoolStripMenuItem.Visible = false;
                           this.clear_wrh_incomeToolStripMenuItem.Visible = false;
                       }
                   }
                   catch { }
				}


				

			}
			catch (Exception Appe)
			{
			}
			try
			{
				if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn10")
				{
					
					if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString() != "")
					{
						this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
					}
				}
			}
			catch {}
          
		}
		
		void UspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridViewCellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
            if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
               == "dataGridViewTextBoxColumn10")
            {
                _old_amount = this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
            }

			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}
		
		void UspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridViewCellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
                if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
                    != this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount)
                {
                    this.Ok_Toggle(_is_valid);
                }
			}
			catch { }
		}
		
		void UspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void Car_model_snameTextBoxTextChanged(object sender, EventArgs e)
		{
			
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Car_mark_snameTextBoxTextChanged(object sender, EventArgs e)
		{
			
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Date_createdDateTimePickerValueChanged(object sender, EventArgs e)
		{
            //Если ид новой организации не равен старому - необходимо обнулить данные по складу
            if (this.date_createdDateTimePicker.Value != _old_date_created)
            {

                foreach (DataGridViewRow currentRow in this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.Rows)
                {
                    try
                    {
                        if ((currentRow.Index + 1) != this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount)
                        {
                            // currentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                            //          = DBNull.Value;
                            // currentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                            //         = "";
                            currentRow.Cells[this.price.Index].Value
                                    = DBNull.Value;
                            currentRow.Cells[this.number.Index].Value
                                    = "";
                            currentRow.Cells[this.wrh_income_detail_id.Index].Value
                                    = DBNull.Value;
                        }


                    }
                    catch { }
                }

            }
            _old_date_created = this.date_createdDateTimePicker.Value;
			_is_valid &= false;
			Ok_Toggle(_is_valid);
			
		}
		
		void Button_headClick(object sender, EventArgs e)
		{
			using (Employee EmployeeForm = new Employee())
			{
				EmployeeForm.ShowDialog(this);
				if (EmployeeForm.DialogResult == DialogResult.OK)
				{

					this.fIO_employee_headTextBox.Text
						= EmployeeForm.Employee_short_fio;
					this.employee_head_idTextBox.Text
						= EmployeeForm.Employee_id;
				}
			}
			
		}
		
		void Button_workerClick(object sender, EventArgs e)
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
				}
			}
			

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
				}
			}
			
		}
		
		void Wrh_demand_master_typecomboBoxTextChanged(object sender, EventArgs e)
		{
			if (this.wrh_demand_master_typecomboBox.SelectedIndex == 0)
			{
				this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_car_id.ToString();
				this.state_numberTextBox.Visible = true;
				this.car_mark_snameTextBox.Visible = true;
				this.car_model_snameTextBox.Visible = true;
				this.button_car.Visible = true;
				this.state_numberLabel.Visible = true;
				this.car_mark_snameLabel.Visible = true;
				this.car_model_snameLabel.Visible = true;
			}
			if ((this.wrh_demand_master_typecomboBox.SelectedIndex == 1)
			    ||(this.wrh_demand_master_typecomboBox.SelectedIndex == 2)
			    ||(this.wrh_demand_master_typecomboBox.SelectedIndex == 3))
			{
				if (this.wrh_demand_master_typecomboBox.SelectedIndex == 1)
				{
					this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_worker_id.ToString();
				}
				if (this.wrh_demand_master_typecomboBox.SelectedIndex == 2)
				{
					this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_expense_id.ToString();
				}
				if (this.wrh_demand_master_typecomboBox.SelectedIndex == 3)
				{
					this.wrh_demamd_master_type_idtextBox.Text = Const.Wrh_demand_master_type_motor_id.ToString();
				}
				this.state_numberTextBox.Visible = false;
				this.car_mark_snameTextBox.Visible = false;
				this.car_model_snameTextBox.Visible = false;
				this.button_car.Visible = false;
				this.state_numberLabel.Visible = false;
				this.car_mark_snameLabel.Visible = false;
				this.car_model_snameLabel.Visible = false;
			}
			
		}
		
		void Button_org_giverClick(object sender, EventArgs e)
		{
			using (Organization OrganizationForm = new Organization())
			{
				OrganizationForm.ShowDialog(this);
				if (OrganizationForm.DialogResult == DialogResult.OK)
				{
                    //Если ид новой организации не равен старому - необходимо обнулить данные по складу
                    if (this.org_giver_idtextBox.Text != OrganizationForm.Org_id)
                    {

                        foreach (DataGridViewRow currentRow in this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.Rows)
                        {
                            try
                            {
                                if ((currentRow.Index + 1) != this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.RowCount)
                                {
                                   // currentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                                   //          = DBNull.Value;
                                   // currentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                                   //         = "";
                                    currentRow.Cells[this.price.Index].Value
                                            = DBNull.Value;
                                    currentRow.Cells[this.number.Index].Value
                                            = "";
                                    currentRow.Cells[this.wrh_income_detail_id.Index].Value
                                            = DBNull.Value;
                                }


                            }
                            catch { }
                        }

                    }
					this.org_giver_idtextBox.Text
						= OrganizationForm.Org_id;
					this.org_givertextBox.Text
						= OrganizationForm.Org_sname;
					_is_valid &= false;
					Ok_Toggle(_is_valid);
				}
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
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].Value;
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].Value;
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].Value;
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn11.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn11.Index].Value;
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].Value;
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn13.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn13.Index].Value;
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn14.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn14.Index].Value;
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn15.Index].ColumnIndex].Value
						= _selected_rows[i].Cells[dataGridViewTextBoxColumn15.Index].Value;
					
					
					this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value = DBNull.Value;
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
		
		void CopyToolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{
				_selected_rows = this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.SelectedRows;
				this.pasteToolStripMenuItem.Enabled = true;
			}
			catch (Exception Appe)
			{ }
		}
		
		void UspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridViewSelectionChanged(object sender, EventArgs e)
		{
			if (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.SelectedRows.Count > 0)
			{
				this.copyToolStripMenuItem.Enabled = true;
			}
			else
			{
				this.copyToolStripMenuItem.Enabled = false;
			}
		}
		
		void Choose_by_rpr_typeToolStripMenuItemClick(object sender, EventArgs e)
		{
			try
			{
				this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.BeginEdit(false);
				if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11")
				    ||(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn12")
				    ||(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13")
				   ||(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn10"))
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
							
							foreach(DataGridViewRow currentRow in this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.Rows)
							{
								try
								{
									if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString() != "")
									   && currentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString() != "")
									{
										this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingSource.AddNew();
									}
									if (currentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString() != "")
									{
										this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
											= currentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
										this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
											= currentRow.Cells[dataGridViewTextBoxColumn28.Index].Value.ToString();
										this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
											= currentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
										this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
											= currentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();
										this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
											= currentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
									}
								}
								catch {}
							}
							
							_is_valid &= false;
							Ok_Toggle(_is_valid);
						}
					}
				}
			}
			catch {}
		}

		private void fillToolStripButton2_Click(object sender, EventArgs e)
		{


		}
        
        void Button_orderClick(object sender, EventArgs e)
        {
        	using (Warehouse_order Warehouse_orderForm = new Warehouse_order())
			{
                Warehouse_orderForm._warehouse_order_detail_form_state = 5;
				Warehouse_orderForm.ShowDialog(this);
				if (Warehouse_orderForm.DialogResult == DialogResult.OK)
				{

					this.order_idtextBox.Text
						= Warehouse_orderForm.Warehouse_order_id;
					this.ordertextBox.Text
						= Warehouse_orderForm.Warehouse_order_number;
					_is_valid &= false;
					Ok_Toggle(_is_valid);
				}
			}
        }

        private void fillToolStripButton3_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_bill_master_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

        }

        private void fillToolStripButton4_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_order_master_idToolStripTextBox.Text, typeof(decimal))))), 2);
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

        }

        private void choose_price_wrhToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Nullable<decimal> v_good_category_id = new Nullable<decimal>();
            Nullable<decimal> v_organization_id = new Nullable<decimal>();
            Nullable<decimal> v_warehouse_type_id = new Nullable<decimal>();
            Nullable<decimal> v_amount_to_give = new Nullable<decimal>();
            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click(sender, e);
            if (_is_valid == true)
            {
                try
                {
                    //Если работаем с ценой - по товару получим приходы по товару
                    if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                        == "price")
                        || (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                        == "dataGridViewTextBoxColumn15")
                        || (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                            == "number"))
                    {
                        v_good_category_id = (decimal)Convert.ChangeType(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString(), typeof(decimal));
                        v_organization_id = (decimal)Convert.ChangeType(this.org_giver_idtextBox.Text, typeof(decimal));
                        v_amount_to_give = (decimal)Convert.ChangeType(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString(), typeof(decimal));
                        v_warehouse_type_id = (decimal)Convert.ChangeType(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString(), typeof(decimal));
                        using (Warehouse_income_list Warehouse_income_listForm = new Warehouse_income_list())
                        {
                            Warehouse_income_listForm._warehouse_income_good_category_id = v_good_category_id.ToString();
                            Warehouse_income_listForm._warehouse_income_organization_id = v_organization_id.ToString();
                            Warehouse_income_listForm._warehouse_income_amount_to_give = v_amount_to_give.ToString();
                            Warehouse_income_listForm._warehouse_income_warehouse_type_id = v_warehouse_type_id.ToString();
                            Warehouse_income_listForm._warehouse_income_end_date = this.date_createdDateTimePicker.Text;
                            if (this.correctPricecheckBox.Checked == false)
                            {
                                Warehouse_income_listForm._warehouse_income_mode = "1";
                            }
                            else
                            {
                                Warehouse_income_listForm._warehouse_income_mode = "2";
                            }

                            Warehouse_income_listForm.ShowDialog(this);
                            if (Warehouse_income_listForm.DialogResult == DialogResult.OK)
                            {

                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[price.Index].Value
                                    = Warehouse_income_listForm.Good_category_price;
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn15.Index].Value
                                    = Warehouse_income_listForm.Warehouse_type_short_name;
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn14.Index].Value
                                    = Warehouse_income_listForm.Warehouse_type_id;
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.wrh_income_detail_id.Index].Value
                                    = Warehouse_income_listForm.Wrh_income_detail_id;
                                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.number.Index].Value
                                    = Warehouse_income_listForm.Wrh_income_number;
                                _is_valid &= false;
                                Ok_Toggle(_is_valid);
                            }
                        }
                    }
                }
                catch { }
            }
        }

        private void org_givertextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void view_wrh_incometoolStripMenuItem_Click(object sender, EventArgs e)
        {
            Nullable<decimal> v_good_category_id = new Nullable<decimal>();
            Nullable<decimal> v_organization_id = new Nullable<decimal>(); 
            Nullable<decimal> v_wrh_income_detail_id = new Nullable<decimal>(); 
            try
            {
                //Если работаем с ценой - по товару получим приходы по товару
                if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                    == "price")
                    ||(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                    == "dataGridViewTextBoxColumn15")
                    || (this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                        == "number"))
                {
                    v_good_category_id = (decimal)Convert.ChangeType(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString(), typeof(decimal));
                    v_organization_id = (decimal)Convert.ChangeType(this.org_giver_idtextBox.Text, typeof(decimal));
                    v_wrh_income_detail_id = (decimal)Convert.ChangeType(this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.wrh_income_detail_id.Index].Value.ToString(), typeof(decimal));
                    using (Warehouse_income_list Warehouse_income_listForm = new Warehouse_income_list())
                    {
                        Warehouse_income_listForm._warehouse_income_good_category_id = v_good_category_id.ToString();
                        Warehouse_income_listForm._warehouse_income_organization_id = v_organization_id.ToString();
                        Warehouse_income_listForm._warehouse_income_detail_id = v_wrh_income_detail_id.ToString();
                        Warehouse_income_listForm._warehouse_income_end_date = this.date_createdDateTimePicker.Text;
                        Warehouse_income_listForm.ShowDialog(this);
                        if (Warehouse_income_listForm.DialogResult == DialogResult.OK)
                        {
                        }
                    }
                }
            }
            catch { }
        }

        private void uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void clear_wrh_incomeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.wrh_income_detail_id.Index].Value
                = DBNull.Value;
            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.number.Index].Value
                = "";

            this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[price.Index].Value
                = DBNull.Value;
           // this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn15.Index].Value
            //    = "";
           // this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn14.Index].Value
           //     = DBNull.Value;

        }

        private void wrh_demand_state_nameComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void wrh_demand_state_nameComboBox_SelectedValueChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if ((this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name
                           == "dataGridViewTextBoxColumn10")
                &&(this._old_amount != this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString()))
            {
                //this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                //        = DBNull.Value;
                //this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
               //         = "";
                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.price.Index].Value
                        = DBNull.Value;
                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.number.Index].Value
                        = "";
                this.uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.wrh_income_detail_id.Index].Value
                        = DBNull.Value;
            }
        }
	}
}
