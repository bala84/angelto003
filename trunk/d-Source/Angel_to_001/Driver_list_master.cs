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
	public partial class Driver_list_master : Form
	{
        public string _username;
		public bool _new_car = false;
		public Driver_list_master()
		{
			InitializeComponent();
			//Проставим даты для выбора путевок за актуальный период времени
			start_dateTimePicker.Value = DateTime.Now.AddDays(-3.0);

			p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
			p_start_dateToolStripTextBox1.Text = start_dateTimePicker.Value.ToShortDateString();

			end_dateTimePicker.Value = DateTime.Now;

			p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
			p_end_dateToolStripTextBox1.Text = end_dateTimePicker.Value.ToShortDateString();
			//Проинициализируем кнопки
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
			
		}






		private void Driver_list_master_Load(object sender, EventArgs e)
		{
			p_searchtextBox.Text = DBNull.Value.ToString();
			p_search_typetextBox.Text = Const.Pt_search.ToString();
			p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
			
			
			try
			{
				this.uspVDRV_DRIVER_LIST_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_car.uspVDRV_DRIVER_LIST_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
				                                                    , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                    , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                    , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				this.uspVDRV_DRIVER_LIST_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_freight.uspVDRV_DRIVER_LIST_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
				                                                        , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				System.Windows.Forms.MessageBox.Show(ex.Message);
			}
		}
		//Сохранение формы - Depricated
		private void toolStripButton7_Click(object sender, EventArgs e)
		{
			try
			{
				//  this.Validate();

				//  this.uspVDRV_DRIVER_LIST_SelectCarBindingSource.EndEdit();
				//  this.uspVDRV_DRIVER_LIST_SelectFreightBindingSource.EndEdit();

				//  this.uspVDRV_DRIVER_LIST_SelectCarTableAdapter.Update(this.ANGEL_TO_001_Driver_list_car.uspVDRV_DRIVER_LIST_SelectCar);
				//  this.uspVDRV_DRIVER_LIST_SelectFreightTableAdapter.Update(this.ANGEL_TO_001_Driver_list_freight.uspVDRV_DRIVER_LIST_SelectFreight);

				this.uspVDRV_DRIVER_LIST_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_car.uspVDRV_DRIVER_LIST_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
				                                                    , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                    , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                    , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				this.uspVDRV_DRIVER_LIST_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_freight.uspVDRV_DRIVER_LIST_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
				                                                        , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				Ok_Toggle(true);
			}
			catch (SqlException Sqle)
			{   //not null sql exception
				switch (Sqle.Number)
				{
					case 515:
						MessageBox.Show("Необходимо заполнить все обязательные поля!");
						break;

					case 547:
						MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись! "
						                + "Проверьте, что у данного автомобиля нет состояния и путевых листов. ");
						this.uspVDRV_DRIVER_LIST_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_car.uspVDRV_DRIVER_LIST_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
						                                                    , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
						                                                    , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
						                                                    , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
						this.uspVDRV_DRIVER_LIST_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_freight.uspVDRV_DRIVER_LIST_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
						                                                        , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
						                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
						                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
						break;

					case 2601:
						MessageBox.Show("Такой '№ Путевого листа' уже существует");
						break;

					default:
						MessageBox.Show("Ошибка");
						MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
						MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
						MessageBox.Show("Источник: " + Sqle.Source.ToString());
						break;
				}
				Ok_Toggle(false);
			}
			catch (Exception Appe)
			{ }
		}

		private void uspVDRV_DRIVER_LIST_SelectCarDataGridView_CurrentCellChanged(object sender, EventArgs e)
		{//Обработка контекстного меню
			try
			{
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Index + 1)
				     == this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.RowCount)
				    && (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Index + 1)
					    == this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.RowCount)
					{
						this.EditToolStripMenuItem.Enabled = false;
						 this.DeleteToolStripMenuItem.Enabled = false;
						//this.Insert_newToolStripMenuItem.Enabled = false;

					}
					else
					{
						this.EditToolStripMenuItem.Enabled = true;
					    this.DeleteToolStripMenuItem.Enabled = true;
					//	this.Insert_newToolStripMenuItem.Enabled = true;

					}
				}
			}
			catch (Exception Appe)
			{
			}
		}

		private void uspVDRV_DRIVER_LIST_SelectFreightDataGridView_CurrentCellChanged(object sender, EventArgs e)
		{//Обработка контекстного меню
			try
			{
				//Уберем лишние пункты контекстного меню при работе с "пустой" строкой
				if (((this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Index + 1)
				     == this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.RowCount)
				    && (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.RowCount != 1))
				{
					this.contextMenuStrip1.Enabled = false;
				}
				else
				{
					this.contextMenuStrip1.Enabled = true;
					//Все же выключим лишние пункты меню при работе с пустой строкой
					if ((this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Index + 1)
					    == this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.RowCount)
					{
						this.EditToolStripMenuItem.Enabled = false;
						this.DeleteToolStripMenuItem.Enabled = false;
						//this.Insert_newToolStripMenuItem.Enabled = false;

					}
					else
					{
						this.EditToolStripMenuItem.Enabled = true;
						this.DeleteToolStripMenuItem.Enabled = true;
						//this.Insert_newToolStripMenuItem.Enabled = true;
					}
				}
			}
			catch (Exception Appe)
			{
			}
		}

		private void EditToolStripMenuItem_Click(object sender, EventArgs e)
		{//Выбор "Редактировать" в контекстном меню
			if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Focused == true)
			{
				using (Driver_list_detail Driver_list_detailForm = new Driver_list_detail())
				{
					Driver_list_detailForm.Text = "Редактирование - легковой";
					Driver_list_detailForm._driver_list_type_name = Const.Car_driver_list_type_sname;
					Driver_list_detailForm._driver_list_type_id = Const.Car_driver_list_type_id.ToString();
					Driver_list_detailForm._driver_list_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
					Driver_list_detailForm._driver_list_date_created
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
					Driver_list_detailForm._driver_list_number
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
					Driver_list_detailForm._driver_list_car_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
					Driver_list_detailForm._driver_list_state_number
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
					Driver_list_detailForm._driver_list_car_mark_model_name
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
					Driver_list_detailForm._driver_list_employee1_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
					Driver_list_detailForm._driver_list_employee2_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_norm
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fact_start_duty
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fact_end_duty
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
					Driver_list_detailForm._driver_list_driver_list_state_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
					Driver_list_detailForm._driver_list_driver_list_state_name
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
					Driver_list_detailForm._driver_list_organization_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
					Driver_list_detailForm._driver_list_org_name
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_type_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_type_name
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn73.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_exp
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
					Driver_list_detailForm._driver_list_speedometer_start_indctn
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value.ToString();
					Driver_list_detailForm._driver_list_speedometer_end_indctn
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_start_left
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_end_left
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_gived
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_return
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_addtnl_exp
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value.ToString();
					Driver_list_detailForm._driver_list_run
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn35.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_consumption
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn36.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fio_driver1
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fio_driver2
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
					Driver_list_detailForm._driver_list_condition_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn75.Index].Value.ToString();
					Driver_list_detailForm._driver_list_employee_id
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn81.Index].Value.ToString();
					Driver_list_detailForm._driver_list_last_date_created
						= this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn127.Index].Value.ToString();
					Driver_list_detailForm._form_state = 2;
					Driver_list_detailForm.ShowDialog(this);
					if (Driver_list_detailForm.DialogResult == DialogResult.OK)
					{

						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Driver_list_detailForm.Driver_list_date_created;
						if (Driver_list_detailForm.Driver_list_number != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
								= Driver_list_detailForm.Driver_list_number;
						}
						if (Driver_list_detailForm.Driver_list_car_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
								= Driver_list_detailForm.Driver_list_car_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Driver_list_detailForm.Driver_list_state_number;
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Driver_list_detailForm.Driver_list_car_mark_model_name;
						if (Driver_list_detailForm.Driver_list_employee1_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
								= Driver_list_detailForm.Driver_list_employee1_id;
						}
						if (Driver_list_detailForm.Driver_list_employee2_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
								= Driver_list_detailForm.Driver_list_employee2_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver1;
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver2;
						if (Driver_list_detailForm.Driver_list_fuel_norm != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_norm;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
							= Driver_list_detailForm.Driver_list_fact_start_duty;
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
							= Driver_list_detailForm.Driver_list_fact_end_duty;
						if (Driver_list_detailForm.Driver_list_driver_list_state_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_state_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_state_name;
						if (Driver_list_detailForm.Driver_list_driver_list_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_type_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_type_name;
						if (Driver_list_detailForm.Driver_list_organization_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
								= Driver_list_detailForm.Driver_list_organization_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
							= Driver_list_detailForm.Driver_list_org_name;
						if (Driver_list_detailForm.Driver_list_fuel_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_type_id;
						}
						if (Driver_list_detailForm.Driver_list_fuel_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_exp;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_start_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_start_indctn;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_end_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_end_indctn;
						}
						if (Driver_list_detailForm.Driver_list_fuel_start_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_start_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_end_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_end_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_gived != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_gived;
						}
						if (Driver_list_detailForm.Driver_list_fuel_return != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_return;
						}
						if (Driver_list_detailForm.Driver_list_fuel_addtnl_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_addtnl_exp;
						}
						if (Driver_list_detailForm.Driver_list_run != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn35.Index].Value
								= Driver_list_detailForm.Driver_list_run;
						}
						if (Driver_list_detailForm.Driver_list_fuel_consumption != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn36.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_consumption;
						}
						if (Driver_list_detailForm.Driver_list_condition_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn75.Index].Value
								= Driver_list_detailForm.Driver_list_condition_id;
						}

						if (Driver_list_detailForm.Driver_list_last_run != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn77.Index].Value
								= Driver_list_detailForm.Driver_list_last_run;
						}
						if (Driver_list_detailForm.Driver_list_edit_state != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn79.Index].Value
								= Driver_list_detailForm.Driver_list_edit_state;
						}
						if (Driver_list_detailForm.Driver_list_employee_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn81.Index].Value
								= Driver_list_detailForm.Driver_list_employee_id;
						}
						if (Driver_list_detailForm.Driver_list_last_date_created != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn127.Index].Value
								= Driver_list_detailForm.Driver_list_last_date_created;
						}
						Ok_Toggle(false);
						this.toolStripButton7_Click(sender,  e);
					}

					
					
				}
			}

			if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Focused == true)
			{
				using (Driver_list_detail Driver_list_detailForm = new Driver_list_detail())
				{
					Driver_list_detailForm.Text = "Редактирование - грузовой";
					Driver_list_detailForm._driver_list_type_name = Const.Freight_driver_list_type_sname;
					Driver_list_detailForm._driver_list_type_id = Const.Freight_driver_list_type_id.ToString();
					Driver_list_detailForm._driver_list_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn37.Index].Value.ToString();
					Driver_list_detailForm._driver_list_date_created
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn44.Index].Value.ToString();
					Driver_list_detailForm._driver_list_number
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn45.Index].Value.ToString();
					Driver_list_detailForm._driver_list_car_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn46.Index].Value.ToString();
					Driver_list_detailForm._driver_list_state_number
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn47.Index].Value.ToString();
					Driver_list_detailForm._driver_list_car_mark_model_name
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn48.Index].Value.ToString();
					Driver_list_detailForm._driver_list_employee1_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn49.Index].Value.ToString();
					Driver_list_detailForm._driver_list_employee2_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn50.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_norm
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn53.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fact_start_duty
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn54.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fact_end_duty
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn55.Index].Value.ToString();
					Driver_list_detailForm._driver_list_driver_list_state_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn56.Index].Value.ToString();
					Driver_list_detailForm._driver_list_driver_list_state_name
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn57.Index].Value.ToString();
					Driver_list_detailForm._driver_list_organization_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn60.Index].Value.ToString();
					Driver_list_detailForm._driver_list_org_name
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn61.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_type_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn62.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_type_name
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn74.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_exp
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn63.Index].Value.ToString();
					Driver_list_detailForm._driver_list_speedometer_start_indctn
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn64.Index].Value.ToString();
					Driver_list_detailForm._driver_list_speedometer_end_indctn
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn65.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_start_left
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn66.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_end_left
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn67.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_gived
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn68.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_return
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn69.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_addtnl_exp
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn70.Index].Value.ToString();
					Driver_list_detailForm._driver_list_run
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn71.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fuel_consumption
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn72.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fio_driver1
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn51.Index].Value.ToString();
					Driver_list_detailForm._driver_list_fio_driver2
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn52.Index].Value.ToString();
					Driver_list_detailForm._driver_list_condition_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn76.Index].Value.ToString();
					Driver_list_detailForm._driver_list_employee_id
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn82.Index].Value.ToString();
					Driver_list_detailForm._driver_list_last_date_created
						= this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value.ToString();
					Driver_list_detailForm._form_state = 2;
					
					Driver_list_detailForm.ShowDialog(this);
					if (Driver_list_detailForm.DialogResult == DialogResult.OK)
					{
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn44.Index].Value
							= Driver_list_detailForm.Driver_list_date_created;
						if (Driver_list_detailForm.Driver_list_number != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn45.Index].Value
								= Driver_list_detailForm.Driver_list_number;
						}

						if (Driver_list_detailForm.Driver_list_car_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn46.Index].Value
								= Driver_list_detailForm.Driver_list_car_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn47.Index].Value
							= Driver_list_detailForm.Driver_list_state_number;
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn48.Index].Value
							= Driver_list_detailForm.Driver_list_car_mark_model_name;

						if (Driver_list_detailForm.Driver_list_employee1_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn49.Index].Value
								= Driver_list_detailForm.Driver_list_employee1_id;
						}
						if (Driver_list_detailForm.Driver_list_employee2_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn50.Index].Value
								= Driver_list_detailForm.Driver_list_employee2_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn51.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver1;
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn52.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver2;
						if (Driver_list_detailForm.Driver_list_fuel_norm != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn53.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_norm;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn54.Index].Value
							= Driver_list_detailForm.Driver_list_fact_start_duty;
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn55.Index].Value
							= Driver_list_detailForm.Driver_list_fact_end_duty;
						if (Driver_list_detailForm.Driver_list_driver_list_state_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn56.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_state_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn57.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_state_name;
						if (Driver_list_detailForm.Driver_list_driver_list_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn58.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_type_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_type_name;
						if (Driver_list_detailForm.Driver_list_organization_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn60.Index].Value
								= Driver_list_detailForm.Driver_list_organization_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn61.Index].Value
							= Driver_list_detailForm.Driver_list_org_name;
						if (Driver_list_detailForm.Driver_list_fuel_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn62.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_type_id;
						}
						if (Driver_list_detailForm.Driver_list_fuel_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn63.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_exp;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_start_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn64.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_start_indctn;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_end_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn65.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_end_indctn;
						}
						if (Driver_list_detailForm.Driver_list_fuel_start_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn66.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_start_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_end_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn67.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_end_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_gived != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn68.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_gived;
						}
						if (Driver_list_detailForm.Driver_list_fuel_return != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn69.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_return;
						}
						if (Driver_list_detailForm.Driver_list_fuel_addtnl_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn70.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_addtnl_exp;
						}
						if (Driver_list_detailForm.Driver_list_run != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn71.Index].Value
								= Driver_list_detailForm.Driver_list_run;
						}
						if (Driver_list_detailForm.Driver_list_fuel_consumption != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn72.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_consumption;
						}
						if (Driver_list_detailForm.Driver_list_condition_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn76.Index].Value
								= Driver_list_detailForm.Driver_list_condition_id;
						}

						if (Driver_list_detailForm.Driver_list_last_run != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn78.Index].Value
								= Driver_list_detailForm.Driver_list_last_run;
						}
						if (Driver_list_detailForm.Driver_list_edit_state != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn80.Index].Value
								= Driver_list_detailForm.Driver_list_edit_state;
						}

						if (Driver_list_detailForm.Driver_list_employee_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn82.Index].Value
								= Driver_list_detailForm.Driver_list_employee_id;
						}
						if (Driver_list_detailForm.Driver_list_last_date_created != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value
								= Driver_list_detailForm.Driver_list_last_date_created;
						}
						Ok_Toggle(false);
						this.toolStripButton7_Click(sender,  e);
					}
				}
			}
		}

		private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
		{//Выбор пункта контекстного меню "Создать"

			if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Focused == true)
			{//Если это не новая машина, то попытаемся заполнить шаблонные поля в путевке
				if (_new_car == false)
				{
					if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString()
					    != "")
					{
						this.p_car_idToolStripTextBox.Text =
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();

						fillToolStripButton2_Click(sender, e);
					}
					
					else
					{
						try
						{
							this.uspVCAR_CAR_SelectByIdBindingSource.RemoveCurrent();
						}
						catch
						{ }
					}
					//Если это не новая машина, попробуем заполнить водителя и организацию из плана смен
					if ((this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString()
					     != "")
					    &&(this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString()
					       != ""))
					{
						this.p_car_idToolStripTextBox.Text =
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
						this.p_date_createdToolStripTextBox.Text =
							DateTime.Now.ToShortDateString();

						fillToolStripButton3_Click(sender, e);
					}
					else
					{
						try
						{
							this.uspVDRV_DRIVER_PLAN_Select_DriverByIdBindingSource.RemoveCurrent();
						}
						catch
						{ }
					}
				}
				
				using (Driver_list_detail Driver_list_detailForm = new Driver_list_detail())
				{
					Driver_list_detailForm.Text = "Вставка - легковой";
					Driver_list_detailForm._driver_list_type_name = Const.Car_driver_list_type_sname;
					Driver_list_detailForm._driver_list_type_id = Const.Car_driver_list_type_id.ToString();
					Driver_list_detailForm._form_state = 1;
					//Попытка заполнить шаблонные поля в путевке , если это не новая машина
					if (_new_car == false)
					{
						try
						{
							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn83.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_car_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn83.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn90.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_state_number
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn90.Index].Value.ToString();
							}

							if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn99.Index].Value.ToString()
							     != "")
							    &&
							    (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn101.Index].Value.ToString()
							     != ""))
							{

								Driver_list_detailForm._driver_list_car_mark_model_name
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn99.Index].Value.ToString()
									+ " " + this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn101.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn102.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_type_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn102.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn103.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_type_name
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn103.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn106.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_norm
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn106.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn111.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_speedometer_start_indctn
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn111.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn112.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_condition_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn112.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_start_left
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn115.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_employee_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn115.Index].Value.ToString();
							}

                            if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString()
                                != "")
                            {

                                Driver_list_detailForm._driver_list_organization_id
                                    = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString();
                            }

                            if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_sname.Index].Value.ToString()
                                != "")
                            {

                                Driver_list_detailForm._driver_list_org_name
                                    = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_sname.Index].Value.ToString();
                            }
                            if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value.ToString() != "")
                                && (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString() != ""))
                            {
                                Driver_list_detailForm._driver_list_number
                                = Just.Get_driver_list_number((decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value.ToString(), typeof(decimal))
                                                              , (decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString(), typeof(decimal)));
                            }
                            //Попробуем взять план водителя 
                            try
                            {
                                if (this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn123.Index].Value.ToString()
                                    != "")
                                {

                                    Driver_list_detailForm._driver_list_employee1_id
                                        = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn123.Index].Value.ToString();
                                }

                                if (this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn124.Index].Value.ToString()
                                    != "")
                                {

                                    Driver_list_detailForm._driver_list_fio_driver1
                                        = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn124.Index].Value.ToString();
                                }
                            }
                            catch { }
							

							
						}
						catch { }
					}
					Driver_list_detailForm.ShowDialog(this);
					if (Driver_list_detailForm.DialogResult == DialogResult.OK)
					{

                        if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.RowCount == 1)
                        {
                            this.uspVDRV_DRIVER_LIST_SelectCarBindingSource.AddNew();
                            this.uspVDRV_DRIVER_LIST_SelectCarBindingSource.RemoveCurrent();
                        }
                        else
                        {
                            this.uspVDRV_DRIVER_LIST_SelectCarBindingSource.AddNew();
                        }

						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
							= Driver_list_detailForm.Driver_list_date_created;
						if (Driver_list_detailForm.Driver_list_number != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
								= Driver_list_detailForm.Driver_list_number;
						}
						if (Driver_list_detailForm.Driver_list_car_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
								= Driver_list_detailForm.Driver_list_car_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
							= Driver_list_detailForm.Driver_list_state_number;
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
							= Driver_list_detailForm.Driver_list_car_mark_model_name;
						if (Driver_list_detailForm.Driver_list_employee1_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
								= Driver_list_detailForm.Driver_list_employee1_id;
						}
						if (Driver_list_detailForm.Driver_list_employee2_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
								= Driver_list_detailForm.Driver_list_employee2_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver1;
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver2;
						if (Driver_list_detailForm.Driver_list_fuel_norm != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_norm;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
							= Driver_list_detailForm.Driver_list_fact_start_duty;
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
							= Driver_list_detailForm.Driver_list_fact_end_duty;
						if (Driver_list_detailForm.Driver_list_driver_list_state_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_state_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_state_name;
						if (Driver_list_detailForm.Driver_list_driver_list_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_type_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_type_name;
						if (Driver_list_detailForm.Driver_list_organization_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
								= Driver_list_detailForm.Driver_list_organization_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
							= Driver_list_detailForm.Driver_list_org_name;
						if (Driver_list_detailForm.Driver_list_fuel_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_type_id;
						}
						if (Driver_list_detailForm.Driver_list_fuel_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_exp;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_start_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_start_indctn;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_end_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_end_indctn;
						}
						if (Driver_list_detailForm.Driver_list_fuel_start_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_start_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_end_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_end_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_gived != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_gived;
						}
						if (Driver_list_detailForm.Driver_list_fuel_return != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_return;
						}
						if (Driver_list_detailForm.Driver_list_fuel_addtnl_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn34.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_addtnl_exp;
						}
						if (Driver_list_detailForm.Driver_list_run != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn35.Index].Value
								= Driver_list_detailForm.Driver_list_run;
						}
						if (Driver_list_detailForm.Driver_list_fuel_consumption != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn36.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_consumption;
						}
						if (Driver_list_detailForm.Driver_list_condition_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn75.Index].Value
								= Driver_list_detailForm.Driver_list_condition_id;
						}
						if (Driver_list_detailForm.Driver_list_last_date_created != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn127.Index].Value
								= Driver_list_detailForm.Driver_list_last_date_created;
						}
						Ok_Toggle(false);
						this.toolStripButton7_Click(sender,  e);
					}

				}
			}

			if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Focused == true)
			{
				if (_new_car == false)
				{
					if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn46.Index].Value.ToString()
					    != "")
					{
						this.p_car_idToolStripTextBox.Text =
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn46.Index].Value.ToString();
						fillToolStripButton2_Click(sender, e);
					}
					else
					{
						try
						{
							this.uspVCAR_CAR_SelectByIdBindingSource.RemoveCurrent();
						}
						catch
						{ }
					}
					
					if ((this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn46.Index].Value.ToString()
					     != "")
					    &&(this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn44.Index].Value.ToString()
					       != ""))
					{
						this.p_car_idToolStripTextBox.Text =
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn46.Index].Value.ToString();
						this.p_date_createdToolStripTextBox.Text =
							DateTime.Now.ToShortDateString();

						fillToolStripButton3_Click(sender, e);
					}
					else
					{
						try
						{
							this.uspVDRV_DRIVER_PLAN_Select_DriverByIdBindingSource.RemoveCurrent();
						}
						catch
						{ }
					}
				}
				


				
				using (Driver_list_detail Driver_list_detailForm = new Driver_list_detail())
				{
					Driver_list_detailForm.Text = "Вставка - грузовой";
					Driver_list_detailForm._driver_list_type_name = Const.Freight_driver_list_type_sname;
					Driver_list_detailForm._driver_list_type_id = Const.Freight_driver_list_type_id.ToString();
					Driver_list_detailForm._form_state = 1;
					//Попытка заполнить шаблонные поля в путевке , если это не новая машина
					if (_new_car == false)
					{
						try
						{
							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn83.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_car_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn83.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn90.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_state_number
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn90.Index].Value.ToString();
							}

							if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn99.Index].Value.ToString()
							     != "")
							    &&
							    (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn101.Index].Value.ToString()
							     != ""))
							{

								Driver_list_detailForm._driver_list_car_mark_model_name
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn99.Index].Value.ToString()
									+ " " + this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn101.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn102.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_type_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn102.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn103.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_type_name
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn103.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn106.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_norm
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn106.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn111.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_speedometer_start_indctn
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn111.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn112.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_condition_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn112.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_fuel_start_left
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn114.Index].Value.ToString();
							}

							if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn115.Index].Value.ToString()
							    != "")
							{

								Driver_list_detailForm._driver_list_employee_id
									= this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn115.Index].Value.ToString();
							}

                            if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString()
                                != "")
                            {

                                Driver_list_detailForm._driver_list_organization_id
                                    = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString();
                            }

                            if (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_sname.Index].Value.ToString()
                                != "")
                            {

                                Driver_list_detailForm._driver_list_org_name
                                    = this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_sname.Index].Value.ToString();
                            }
                            //MessageBox.Show(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn94.Index].Value.ToString());
                            //MessageBox.Show(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString());
                            if ((this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value.ToString() != "")
                                && (this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString() != ""))
                            {
                                Driver_list_detailForm._driver_list_number
                                = Just.Get_driver_list_number((decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value.ToString(), typeof(decimal))
                                                              , (decimal)Convert.ChangeType(this.uspVCAR_CAR_SelectByIdDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString(), typeof(decimal)));
                            }
							//Попробуем взять водителя по плану
                            try
                            {
                                if (this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn123.Index].Value.ToString()
                                    != "")
                                {

                                    Driver_list_detailForm._driver_list_employee1_id
                                        = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn123.Index].Value.ToString();
                                }

                                if (this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn124.Index].Value.ToString()
                                    != "")
                                {

                                    Driver_list_detailForm._driver_list_fio_driver1
                                        = this.uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn124.Index].Value.ToString();
                                }
                            }
                            catch { }
							
                        }
						catch {}
					}

					Driver_list_detailForm.ShowDialog(this);
					if (Driver_list_detailForm.DialogResult == DialogResult.OK)
					{
                        if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.RowCount == 1)
                        {
                            this.uspVDRV_DRIVER_LIST_SelectFreightBindingSource.AddNew();
                            this.uspVDRV_DRIVER_LIST_SelectFreightBindingSource.RemoveCurrent();
                        }
                        else
                        {
                            this.uspVDRV_DRIVER_LIST_SelectFreightBindingSource.AddNew();
                        }
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn44.Index].Value
							= Driver_list_detailForm.Driver_list_date_created;
						if (Driver_list_detailForm.Driver_list_number != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn45.Index].Value
								= Driver_list_detailForm.Driver_list_number;
						}
						
						if (Driver_list_detailForm.Driver_list_car_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn46.Index].Value
								= Driver_list_detailForm.Driver_list_car_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn47.Index].Value
							= Driver_list_detailForm.Driver_list_state_number;
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn48.Index].Value
							= Driver_list_detailForm.Driver_list_car_mark_model_name;

						if (Driver_list_detailForm.Driver_list_employee1_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn49.Index].Value
								= Driver_list_detailForm.Driver_list_employee1_id;
						}
						if (Driver_list_detailForm.Driver_list_employee2_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn50.Index].Value
								= Driver_list_detailForm.Driver_list_employee2_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn51.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver1;
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn52.Index].Value
							= Driver_list_detailForm.Driver_list_fio_driver2;
						if (Driver_list_detailForm.Driver_list_fuel_norm != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn53.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_norm;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn54.Index].Value
							= Driver_list_detailForm.Driver_list_fact_start_duty;
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn55.Index].Value
							= Driver_list_detailForm.Driver_list_fact_end_duty;
						if (Driver_list_detailForm.Driver_list_driver_list_state_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn56.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_state_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn57.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_state_name;
						if (Driver_list_detailForm.Driver_list_driver_list_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn58.Index].Value
								= Driver_list_detailForm.Driver_list_driver_list_type_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn59.Index].Value
							= Driver_list_detailForm.Driver_list_driver_list_type_name;
						if (Driver_list_detailForm.Driver_list_organization_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn60.Index].Value
								= Driver_list_detailForm.Driver_list_organization_id;
						}
						this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn61.Index].Value
							= Driver_list_detailForm.Driver_list_org_name;
						if (Driver_list_detailForm.Driver_list_fuel_type_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn62.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_type_id;
						}
						if (Driver_list_detailForm.Driver_list_fuel_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn63.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_exp;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_start_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn64.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_start_indctn;
						}
						if (Driver_list_detailForm.Driver_list_speedometer_end_indctn != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn65.Index].Value
								= Driver_list_detailForm.Driver_list_speedometer_end_indctn;
						}
						if (Driver_list_detailForm.Driver_list_fuel_start_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn66.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_start_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_end_left != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn67.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_end_left;
						}
						if (Driver_list_detailForm.Driver_list_fuel_gived != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn68.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_gived;
						}
						if (Driver_list_detailForm.Driver_list_fuel_return != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn69.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_return;
						}
						if (Driver_list_detailForm.Driver_list_fuel_addtnl_exp != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn70.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_addtnl_exp;
						}
						if (Driver_list_detailForm.Driver_list_run != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn71.Index].Value
								= Driver_list_detailForm.Driver_list_run;
						}
						if (Driver_list_detailForm.Driver_list_fuel_consumption != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn72.Index].Value
								= Driver_list_detailForm.Driver_list_fuel_consumption;
						}
						if (Driver_list_detailForm.Driver_list_condition_id != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn76.Index].Value
								= Driver_list_detailForm.Driver_list_condition_id;
						}
						
						if (Driver_list_detailForm.Driver_list_last_date_created != "")
						{
							this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn128.Index].Value
								= Driver_list_detailForm.Driver_list_last_date_created;
						}
						Ok_Toggle(false);
						this.toolStripButton7_Click(sender,  e);
					}

				}
			}
		}

		private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
		{
            Nullable<decimal> v_car_type_id = new Nullable<decimal>();
            Nullable<DateTime> v_startdatetime = new Nullable<DateTime>();
            Nullable<DateTime> v_enddatetime = new Nullable<DateTime>();
            using (Dialog DialogForm = new Dialog())
            {
                DialogForm._dialog_form_state = 2;
                DialogForm._dialog_label = "Вы уверены, что хотите удалить ошибочный путевой лист?";
                DialogForm.ShowDialog(this);
                if (DialogForm.DialogResult == DialogResult.OK)
                {
                    string v_id = "";
                    System.Configuration.ConnectionStringSettings settings;
                    settings =
                        System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
                    if (settings != null)
                    {

                        if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Focused == true)
                        {
                            v_id = this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                            
                        }

                        if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Focused == true)
                        {
                            v_id = this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn37.Index].Value.ToString();
                        }


                        


                        // Подключение к БД
                        try
                        {
                            using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                            {
                                SqlCommand AuthenticationCommand = new SqlCommand("dbo.uspVDRV_DRIVER_LIST_DeleteById",
                                                                                  connection);
                                AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                                //Добавление параметров для процедуры
                                SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                                    "@p_id", SqlDbType.Decimal);
                                parameter.Value = v_id;

                                connection.Open();

                                SqlDataReader reader = AuthenticationCommand.ExecuteReader();

                                p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
                                p_end_dateToolStripTextBox1.Text = end_dateTimePicker.Value.ToShortDateString();


                                try
                                {
                                    if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Focused == true)
                                    {
                                        this.uspVDRV_DRIVER_LIST_SelectCarBindingSource.RemoveCurrent();
                                    }
                                    if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Focused == true)
                                    {
                                        this.uspVDRV_DRIVER_LIST_SelectFreightBindingSource.RemoveCurrent();
                                    }

                                    reader.Close();
                                    connection.Close();

                                }
                                finally
                                {
                                    // Always call Close when done reading.
                                    reader.Close();
                                    connection.Close();
                                }
                            }
                        }
                        catch (SqlException Sqle)
                        {
                            MessageBox.Show("Ошибка подключения");
                            MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                            MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                            MessageBox.Show("Источник: " + Sqle.Source.ToString());

                        }
                    }

                }
            }
		}

		private void start_dateTimePicker_ValueChanged(object sender, EventArgs e)
		{
			try
			{
				p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
				p_start_dateToolStripTextBox1.Text = start_dateTimePicker.Value.ToShortDateString();

				//MessageBox.Show("1 " + p_start_dateToolStripTextBox.Text);
				//MessageBox.Show("2 " + p_start_dateToolStripTextBox1.Text);
				this.uspVDRV_DRIVER_LIST_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_car.uspVDRV_DRIVER_LIST_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
				                                                    , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                    , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                    , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				this.uspVDRV_DRIVER_LIST_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_freight.uspVDRV_DRIVER_LIST_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
				                                                        , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				// System.Windows.Forms.MessageBox.Show(ex.Message);
			}
		}

		private void end_dateTimePicker_ValueChanged(object sender, EventArgs e)
		{
			try
			{
				p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
				p_end_dateToolStripTextBox1.Text = end_dateTimePicker.Value.ToShortDateString();

				//MessageBox.Show("3 " + p_end_dateToolStripTextBox.Text);
				//MessageBox.Show("4 " + p_end_dateToolStripTextBox1.Text);
				this.uspVDRV_DRIVER_LIST_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_car.uspVDRV_DRIVER_LIST_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
				                                                    , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                    , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                    , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				this.uspVDRV_DRIVER_LIST_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_freight.uspVDRV_DRIVER_LIST_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
				                                                        , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				//System.Windows.Forms.MessageBox.Show(ex.Message);
			}
		}

		private void button_ok_Click(object sender, EventArgs e)
		{
			this.toolStripButton7_Click(sender, e);
		}

		private void fillToolStripButton2_Click(object sender, EventArgs e)
		{
            try
            {

                this.uspVCAR_CAR_SelectByIdTableAdapter.Fill(this.aNGEL_TO_001_Car_SelectById.uspVCAR_CAR_SelectById, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
		}

		private void Insert_newToolStripMenuItem_Click(object sender, EventArgs e)
		{
			_new_car = true;
			this.InsertToolStripMenuItem_Click(sender, e);
			_new_car = false;

		}

		private void button_find_Click(object sender, EventArgs e)
		{
			try
			{
				this.uspVDRV_DRIVER_LIST_SelectCarTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_car.uspVDRV_DRIVER_LIST_SelectCar, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
				                                                    , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                    , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                    , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
				this.uspVDRV_DRIVER_LIST_SelectFreightTableAdapter.Fill(this.ANGEL_TO_001_Driver_list_freight.uspVDRV_DRIVER_LIST_SelectFreight, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox1.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox1.Text, typeof(System.DateTime)))))
				                                                        , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
			}
			catch (System.Exception ex)
			{
				System.Windows.Forms.MessageBox.Show(ex.Message);
			}
		}

		private void Ok_Toggle(bool v_result)
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

		private void uspVDRV_DRIVER_LIST_SelectCarDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
		{
			try
			{
				throw e.Exception;
			}
			catch (Exception Appe)
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

		private void uspVDRV_DRIVER_LIST_SelectFreightDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
		{
			try
			{
				throw e.Exception;
			}
			catch (Exception Appe)
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

		private void fillToolStripButton3_Click(object sender, EventArgs e)
		{
			try
			{
				this.uspVDRV_DRIVER_PLAN_Select_DriverByIdTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_Select_DriverById, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_date_createdToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_idToolStripTextBox.Text, typeof(decimal))))));
			}
			catch (System.Exception ex)
			{
				System.Windows.Forms.MessageBox.Show(ex.Message);
			}

		}

        private void uspVDRV_DRIVER_LIST_SelectCarDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие закрытых путевых листов и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Columns[e.ColumnIndex].Name == "dataGridViewTextBoxColumn21")
                {

                    if (this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn21.Index].Value.ToString() == "Закрыт")
                    {
                        this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightGreen;
                    }
                    else
                    {

                        this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVDRV_DRIVER_LIST_SelectCarDataGridView.DefaultCellStyle.BackColor;


                    }


                }
            }
            catch (Exception Appe)
            { }
        }

        private void uspVDRV_DRIVER_LIST_SelectFreightDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие закрытых путевых листов и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Columns[e.ColumnIndex].Name == "dataGridViewTextBoxColumn57")
                {

                    if (this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn57.Index].Value.ToString() == "Закрыт")
                    {
                        this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightGreen;
                    }
                    else
                    {

                        this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVDRV_DRIVER_LIST_SelectFreightDataGridView.DefaultCellStyle.BackColor;


                    }


                }
            }
            catch (Exception Appe)
            { }
        }

        private void uspVDRV_DRIVER_PLAN_Select_DriverByIdDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }



        

	}
}
