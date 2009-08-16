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
	public partial class Car : Form
	{
		private bool _is_valid = true;

        public string _username;

		public Car()
		{
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
		}


		//Укажем id для интересующей нас колонки
		public string Car_id
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
		}

		//Укажем марку-модель для интересующей нас колонки
		public string Car_mark_model_sname
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString()
					+ " - " + this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
			}
		}
		
		//Укажем номер для интересующей нас колонки
		public string Car_mark
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString(); }
		}
		
		//Укажем номер для интересующей нас колонки
		public string Car_model
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString(); }
		}

		//Укажем номер для интересующей нас колонки
		public string Car_state_number
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
		}

		//Укажем тип топлива для интересующей нас колонки
		public string Car_fuel_type_sname
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString(); }
		}

		//Укажем id типа топлива для интересующей нас колонки
		public string Car_fuel_type_id
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString(); }
		}

		//Укажем нормы топлива для интересующей нас колонки
		public string Car_fuel_norm
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn23.Index].Value.ToString(); }
		}

		//Укажем пробег для интересующей нас колонки
		public string Car_run
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString(); }
		}

		//Укажем остаток топлива для интересующей нас колонки
		public string Car_fuel_end_left
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn31.Index].Value.ToString(); }
		}


        public string Car_organization_id
        {
            get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[this.organization_id.Index].Value.ToString(); }
        }

        //Укажем остаток топлива для интересующей нас колонки
        public string Car_organization_sname
        {
            get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[this.organization_sname.Index].Value.ToString(); }
        }


		//Укажем последнее показание спидометра для интересующей нас колонки
		public string Car_speedometer_end_indctn
		{
			get
			{
				if ((this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString() != null)
				    &&(this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString() != ""))
				{
					return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString(); }
				else {
					return null; }
			}
		}

		//Укажем ид состояния (CONDITION) для интересующей нас колонки
		public string Car_condition_id
		{
			get { return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value.ToString(); }
		}


		//Укажем id механика для интересующей нас колонки
		public string Car_employee_id
		{
			get
			{
				if ((this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString() != null)
				    && (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString() != ""))
				{
					return this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString();
				}
				else
				{
					return null;
				}
			}
		}

		private DataGridViewSelectedRowCollection _selected_rows;

		private bool Check_Items()
		{
			bool v_is_valid = true;
			
			v_is_valid &= Is_Car_Kind_Name_Valid();
			if (Is_Car_Kind_Name_Valid())
			{
				this.Car_kind_sname_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Car_kind_sname_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Вид'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Style.BackColor
					= Color.Red;
			}

			v_is_valid &= Is_Begin_Run_Valid();
			if (Is_Begin_Run_Valid())
			{
				this.Begin_run_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Begin_run_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 15);
				this.Begin_run_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Пробег'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Style.BackColor
					= Color.Red;
			}

			v_is_valid &= Is_State_Number_Valid();
			if (Is_State_Number_Valid())
			{
				this.State_number_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.State_number_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
				this.State_number_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести '№ СТП'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
					= Color.Red;
			}

			v_is_valid &= Is_Begin_Idctn_Valid();
			if (Is_Begin_Idctn_Valid())
			{
				this.Begin_idctn_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Begin_idctn_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Показание'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Style.BackColor
					= Color.Red;
			}

			v_is_valid &= Is_Begin_Mntnc_Date_Valid();
			if (Is_Begin_Mntnc_Date_Valid())
			{
				this.Begin_mntnc_date_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Begin_mntnc_date_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 15);
				this.Begin_mntnc_date_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Дату начала эксплуатации'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Style.BackColor
					= Color.Red;
			}

			v_is_valid &= Is_Car_Type_Valid();
			if (Is_Car_Type_Valid())
			{
				this.Car_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Car_type_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
				this.Car_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Тип'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Style.BackColor
					= Color.Red;
			}

			v_is_valid &= Is_Car_Mark_Valid();
			if (Is_Car_Mark_Valid())
			{
				this.Car_mark_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Car_mark_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Марку'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Style.BackColor
					= Color.Red;
			}


			v_is_valid &= Is_Car_Model_Valid();
			if (Is_Car_Model_Valid())
			{
				this.Car_model_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Car_model_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 15);
				this.Car_model_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Модель'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Style.BackColor
					= Color.Red;
			}


			v_is_valid &= Is_Fuel_Type_Valid();
			if (Is_Fuel_Type_Valid())
			{
				this.Fuel_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Style.BackColor
					= this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
			}
			else
			{
				this.Fuel_type_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
				this.Fuel_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести 'Тип топлива'");
				this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Style.BackColor
					= Color.Red;
			}

			/*v_is_valid &= Is_Last_Ts_Type_Valid();
                if (Is_Last_Ts_Type_Valid())
                {
                    this.Last_ts_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "");
                    this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Style.BackColor
                        = this.utfVCAR_CARDataGridView.DefaultCellStyle.BackColor;
                }
                else
                {
                    //this.Last_ts_type_errorProvider.SetIconPadding(this.utfVCAR_CARDataGridView, 30);
                    this.Last_ts_type_errorProvider.SetError(this.utfVCAR_CARDataGridView, "Необходимо ввести предыдущее ТО");
                    this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Style.BackColor
                        = Color.Red;
                }*/

			

			return v_is_valid;

		}



		private void utfVCAR_CARBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{

			try
			{

				this.Validate();
				this.utfVCAR_CARBindingSource.EndEdit();
				this.utfVCAR_CARTableAdapter.Update(this.ANGEL_TO_001_Car.utfVCAR_CAR);
				//Если это не последняя строка, то проверим содержимое
				//  if ((this.utfVCAR_CARDataGridView.CurrentRow.Index + 1)
				//          != this.utfVCAR_CARDataGridView.RowCount)
				//  {
				//_is_valid &= this.Check_Items();
				this.Ok_Toggle(_is_valid);
				_is_valid = true;
				this.utfVCAR_CARDataGridView_CurrentCellChanged(sender, e);
				//  }
				//     MessageBox.Show("Если у вас есть автомобили, отмеченные желтым цветом, проверьте, что у них указаны все последние ТО");
				//     this.utfVCAR_CARTableAdapter.Fill(this.ANGEL_TO_001_Car.utfVCAR_CAR, ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
				//                                                        , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
				//                                                        , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
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
						                +"Проверьте, что у данного автомобиля нет состояния и путевых листов. ");
						this.utfVCAR_CARTableAdapter.Fill(this.ANGEL_TO_001_Car.utfVCAR_CAR, ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
						                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
						                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                          , DateTime.Now);
						break;

					case 2601:
						MessageBox.Show("Такой '№ СТП' уже существует");
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
			{ }
			
		}

		private void Car_Load(object sender, EventArgs e)
		{
			p_searchtextBox.Text = DBNull.Value.ToString();
			p_search_typetextBox.Text = Const.Pt_search.ToString();
			p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
			// TODO: This line of code loads data into the 'aNGEL_TO_001_Car.utfVCAR_CAR' table. You can move, or remove it, as needed.
			this.utfVCAR_CARTableAdapter.Fill(this.ANGEL_TO_001_Car.utfVCAR_CAR
			                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
			                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
			                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                              , DateTime.Now);
			
		}

		private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
		{

            using (Car_detail Car_detailForm = new Car_detail())
            {
                Car_detailForm.Text = "Вставка ";
                Car_detailForm._form_state = 1;
                Car_detailForm.ShowDialog(this);
                if (Car_detailForm.DialogResult == DialogResult.OK)
                {
                    if (this.utfVCAR_CARDataGridView.RowCount == 1)
                    {
                        this.utfVCAR_CARBindingSource.AddNew();
                        this.utfVCAR_CARBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.utfVCAR_CARBindingSource.AddNew();
                    }

                    if (Car_detailForm.State_number != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                            = Car_detailForm.State_number;
                    }
                    if (Car_detailForm.Car_kind_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
                            = Car_detailForm.Car_kind_id;
                    }
                    if (Car_detailForm.Car_kind_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
                            = Car_detailForm.Car_kind_sname;
                    }
                    if (Car_detailForm.Run != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
                            = Car_detailForm.Run;
                    }
                    if (Car_detailForm.Speedometer_end_indctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value
                            = Car_detailForm.Speedometer_end_indctn;
                    }
                    if (Car_detailForm.Begin_mntnc_date != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                            = Car_detailForm.Begin_mntnc_date;
                    }
                    if (Car_detailForm.Car_type_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                            = Car_detailForm.Car_type_id;
                    }
                    if (Car_detailForm.Car_type_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                            = Car_detailForm.Car_type_sname;
                    }
                    if (Car_detailForm.Car_mark_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                            = Car_detailForm.Car_mark_id;
                    }
                    if (Car_detailForm.Car_mark_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                            = Car_detailForm.Car_mark_sname;
                    }

                    if (Car_detailForm.Car_model_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
                            = Car_detailForm.Car_model_id;
                    }
                    if (Car_detailForm.Car_model_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
                            = Car_detailForm.Car_model_sname;
                    }

                    if (Car_detailForm.Fuel_type_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
                            = Car_detailForm.Fuel_type_id;
                    }
                    if (Car_detailForm.Fuel_type_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
                            = Car_detailForm.Fuel_type_sname;
                    }

                    if (Car_detailForm.Organization_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_id.Index].Value
                            = Car_detailForm.Organization_id;
                    }
                    if (Car_detailForm.Organization_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_sname.Index].Value
                            = Car_detailForm.Organization_sname;
                    }

                    if (Car_detailForm.Last_speedometer_idctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
                            = Car_detailForm.Last_speedometer_idctn;
                    }

                    if (Car_detailForm.Speedometer_idctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                            = Car_detailForm.Speedometer_idctn;
                    }

                    if (Car_detailForm.Last_begin_run != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value
                            = Car_detailForm.Last_begin_run;
                    }

                    if (Car_detailForm.Begin_run != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
                            = Car_detailForm.Begin_run;
                    }

                    if (Car_detailForm.Speedometer_start_indctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value
                            = Car_detailForm.Speedometer_start_indctn;
                    }


                    if (Car_detailForm.Fuel_start_left != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[fuel_start_left.Index].Value
                            = Car_detailForm.Fuel_start_left;
                    }


                    if (Car_detailForm.Condition_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value
                            = Car_detailForm.Condition_id;
                    }

                    if (Car_detailForm.Employee_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value
                            = Car_detailForm.Employee_id;
                    }

                    if (Car_detailForm.Card_number != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[card_number.Index].Value
                            = Car_detailForm.Card_number;
                    }


                    if (Car_detailForm.Driver_list_type_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value
                            = Car_detailForm.Driver_list_type_id;
                    }

                    if (Car_detailForm.Driver_list_type_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_sname.Index].Value
                            = Car_detailForm.Driver_list_type_sname;
                    }

                    if (Car_detailForm.Car_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
                            = Car_detailForm.Car_id;
                    }



                   // _is_valid = false;
                   // Ok_Toggle(_is_valid);

                }
            }
		}

		private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
		{
            using (Car_detail Car_detailForm = new Car_detail())
            {
                Car_detailForm.Text = "Удаление ";
                Car_detailForm._car_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                Car_detailForm._car_kind_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
                Car_detailForm._car_kind_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString();
                Car_detailForm._run = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString();
                Car_detailForm._state_number = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                Car_detailForm._speedometer_end_indctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
                Car_detailForm._begin_mntnc_date = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
                Car_detailForm._car_type_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
                Car_detailForm._car_type_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
                Car_detailForm._car_mark_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
                Car_detailForm._car_mark_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
                Car_detailForm._car_model_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
                Car_detailForm._car_model_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
                Car_detailForm._fuel_type_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
                Car_detailForm._fuel_type_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
                Car_detailForm._organization_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString();
                Car_detailForm._organization_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_sname.Index].Value.ToString();
                Car_detailForm._car_passport = this.utfVCAR_CARDataGridView.CurrentRow.Cells[car_passport.Index].Value.ToString();
                Car_detailForm._card_number = this.utfVCAR_CARDataGridView.CurrentRow.Cells[card_number.Index].Value.ToString();
                Car_detailForm._driver_list_type_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value.ToString();
                Car_detailForm._driver_list_type_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_sname.Index].Value.ToString();
                Car_detailForm._last_speedometer_idctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
                Car_detailForm._speedometer_idctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
                Car_detailForm._last_begin_run = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();
                Car_detailForm._begin_run = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
                Car_detailForm._speedometer_start_indctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
                Car_detailForm._fuel_start_left = this.utfVCAR_CARDataGridView.CurrentRow.Cells[fuel_start_left.Index].Value.ToString();
                Car_detailForm._condition_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value.ToString();
                Car_detailForm._employee_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString();
                
                Car_detailForm._form_state = 3;

                Car_detailForm.ShowDialog(this);


                if (Car_detailForm.DialogResult == DialogResult.OK)
                {
                    this.utfVCAR_CARBindingSource.RemoveCurrent();
                    //_is_valid = false;
                    //Ok_Toggle(false);
                }
            }
		}

		private void EditToolStripMenuItem_Click(object sender, EventArgs e)
		{
            using (Car_detail Car_detailForm = new Car_detail())
            {
                Car_detailForm.Text = "Редактирование ";

                Car_detailForm._car_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                Car_detailForm._state_number = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                Car_detailForm._car_kind_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString();
                Car_detailForm._car_kind_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString();
                Car_detailForm._run = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString();
                Car_detailForm._speedometer_end_indctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString();
                Car_detailForm._begin_mntnc_date = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
                Car_detailForm._car_type_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
                Car_detailForm._car_type_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
                Car_detailForm._car_mark_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
                Car_detailForm._car_mark_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
                Car_detailForm._car_model_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
                Car_detailForm._car_model_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString();
                Car_detailForm._fuel_type_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
                Car_detailForm._fuel_type_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString();
                Car_detailForm._organization_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_id.Index].Value.ToString();
                Car_detailForm._organization_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_sname.Index].Value.ToString();
                Car_detailForm._car_passport = this.utfVCAR_CARDataGridView.CurrentRow.Cells[car_passport.Index].Value.ToString();
                Car_detailForm._card_number = this.utfVCAR_CARDataGridView.CurrentRow.Cells[card_number.Index].Value.ToString();
                Car_detailForm._driver_list_type_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value.ToString();
                Car_detailForm._driver_list_type_sname = this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_sname.Index].Value.ToString();
                Car_detailForm._last_speedometer_idctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value.ToString();
                Car_detailForm._speedometer_idctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
                Car_detailForm._last_begin_run = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value.ToString();
                Car_detailForm._begin_run = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value.ToString();
                Car_detailForm._speedometer_start_indctn = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value.ToString();
                Car_detailForm._fuel_start_left = this.utfVCAR_CARDataGridView.CurrentRow.Cells[fuel_start_left.Index].Value.ToString();
                Car_detailForm._condition_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value.ToString();
                Car_detailForm._employee_id = this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value.ToString();
                
                Car_detailForm._form_state = 2;


                Car_detailForm.ShowDialog(this);

                if (Car_detailForm.DialogResult == DialogResult.OK)
                {

                    if (Car_detailForm.State_number != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                            = Car_detailForm.State_number;
                    }
                    if (Car_detailForm.Car_kind_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value
                            = Car_detailForm.Car_kind_id;
                    }
                    if (Car_detailForm.Car_kind_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value
                            = Car_detailForm.Car_kind_sname;
                    }
                    if (Car_detailForm.Run != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value
                            = Car_detailForm.Run;
                    }
                    if (Car_detailForm.Speedometer_end_indctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value
                            = Car_detailForm.Speedometer_end_indctn;
                    }
                    if (Car_detailForm.Begin_mntnc_date != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                            = Car_detailForm.Begin_mntnc_date;
                    }
                    if (Car_detailForm.Car_type_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                            = Car_detailForm.Car_type_id;
                    }
                    if (Car_detailForm.Car_type_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                            = Car_detailForm.Car_type_sname;
                    }
                    if (Car_detailForm.Car_mark_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                            = Car_detailForm.Car_mark_id;
                    }
                    if (Car_detailForm.Car_mark_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                            = Car_detailForm.Car_mark_sname;
                    }

                    if (Car_detailForm.Car_model_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
                            = Car_detailForm.Car_model_id;
                    }
                    if (Car_detailForm.Car_model_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
                            = Car_detailForm.Car_model_sname;
                    }

                    if (Car_detailForm.Fuel_type_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
                            = Car_detailForm.Fuel_type_id;
                    }
                    if (Car_detailForm.Fuel_type_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
                            = Car_detailForm.Fuel_type_sname;
                    }

                    if (Car_detailForm.Organization_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_id.Index].Value
                            = Car_detailForm.Organization_id;
                    }
                    if (Car_detailForm.Organization_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[organization_sname.Index].Value
                            = Car_detailForm.Organization_sname;
                    }

                    if (Car_detailForm.Last_speedometer_idctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
                            = Car_detailForm.Last_speedometer_idctn;
                    }

                    if (Car_detailForm.Speedometer_idctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                            = Car_detailForm.Speedometer_idctn;
                    }

                    if (Car_detailForm.Last_begin_run != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value
                            = Car_detailForm.Last_begin_run;
                    }

                    if (Car_detailForm.Begin_run != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn24.Index].Value
                            = Car_detailForm.Begin_run;
                    }

                    if (Car_detailForm.Speedometer_start_indctn != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn26.Index].Value
                            = Car_detailForm.Speedometer_start_indctn;
                    }


                    if (Car_detailForm.Fuel_start_left != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[fuel_start_left.Index].Value
                            = Car_detailForm.Fuel_start_left;
                    }


                    if (Car_detailForm.Condition_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn28.Index].Value
                            = Car_detailForm.Condition_id;
                    }

                    if (Car_detailForm.Employee_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn32.Index].Value
                            = Car_detailForm.Employee_id;
                    }

                    if (Car_detailForm.Card_number != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[card_number.Index].Value
                            = Car_detailForm.Card_number;
                    }


                    if (Car_detailForm.Driver_list_type_id != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_id.Index].Value
                            = Car_detailForm.Driver_list_type_id;
                    }

                    if (Car_detailForm.Driver_list_type_sname != "")
                    {
                        this.utfVCAR_CARDataGridView.CurrentRow.Cells[driver_list_type_sname.Index].Value
                            = Car_detailForm.Driver_list_type_sname;
                    }

                    //_is_valid = false;
                    //Ok_Toggle(_is_valid);

                }
            }
					
		}

		private void utfVCAR_CARDataGridView_CurrentCellChanged(object sender, EventArgs e)
		{
			
			
		}

		private void date_choosertoolStripMenuItem_Click(object sender, EventArgs e)
		{
			//using (Dialog DialogForm = new Dialog())
				
			//{
				//DialogForm._dialog_label = "Вы уверены что хотите изменить автомобиль?";
				//DialogForm.BackColor = Color.Yellow;
				//DialogForm.ShowDialog(this);
				//if (DialogForm.DialogResult == DialogResult.OK)
				//{
					using (Date_chooser Date_chooserForm = new Date_chooser())
					{
						Date_chooserForm.ShowDialog(this);
						if (Date_chooserForm.DialogResult == DialogResult.OK)
						{
							this.utfVCAR_CARDataGridView.CurrentCell.Value
								= Date_chooserForm.Short_date_value;
						}
					}
				//}
			//}
		}

		private void utfVCAR_CARDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
		{
			if (this.utfVCAR_CARDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn24")
			{
				this.last_begin_run_temptextBox.Text
					= this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString();
			}

			if (this.utfVCAR_CARDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn9")
			{
				this.last_speedometer_idctn_temptextBox.Text
					= this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString();
			}
			_is_valid &= false;
			Ok_Toggle(_is_valid);
		}

		private void utfVCAR_CARDataGridView_CellEndEdit(object sender, DataGridViewCellEventArgs e)
		{
			if (this.utfVCAR_CARDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn24")
			{
				if (((this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString() != "")
				     &&(this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString() != null))
				    &&(this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString() != this.last_begin_run_temptextBox.Text))
				{
					if ((this.last_begin_run_temptextBox.Text != null)
					    && (this.last_begin_run_temptextBox.Text != ""))
					{
						this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn29.Index].Value
							= this.last_begin_run_temptextBox.Text;
					}
				}
			}

			if (this.utfVCAR_CARDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn9")
			{
				if (((this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString() != "")
				     &&(this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString() != null))
				    &&(this.utfVCAR_CARDataGridView.CurrentCell.Value.ToString() != this.last_speedometer_idctn_temptextBox.Text))
				{
					if ((this.last_speedometer_idctn_temptextBox.Text != null)
					    && (this.last_speedometer_idctn_temptextBox.Text != ""))
					{
						this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn30.Index].Value
							= this.last_speedometer_idctn_temptextBox.Text;
					}
				}
			}
		}

		// Functions to verify data.
		private bool Is_Car_Kind_Name_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn22.Index].Value.ToString().Length != 0);
		}
		private bool Is_Begin_Run_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn25.Index].Value.ToString().Length != 0);
		}
		private bool Is_State_Number_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString().Length != 0);
		}
		private bool Is_Begin_Idctn_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn27.Index].Value.ToString().Length != 0);
		}
		private bool Is_Begin_Mntnc_Date_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString().Length != 0);
		}
		private bool Is_Car_Type_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString().Length != 0);
		}
		private bool Is_Car_Mark_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString().Length != 0);
		}
		private bool Is_Car_Model_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value.ToString().Length != 0);
		}
		private bool Is_Fuel_Type_Valid()
		{
			return (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString().Length != 0);
		}

		private bool Is_Last_Ts_Type_Valid()
		{
			if (this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value.ToString() == "1")
			{
				return true;
			}
			else
			{
				return false;
			}
			
		}

		private void button_ok_Click(object sender, EventArgs e)
		{
            if (_is_valid == false)
            {
                this.utfVCAR_CARBindingNavigatorSaveItem_Click(sender, e);
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

		private void utfVCAR_CARDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
		{
			//Если это не последняя строка, то проверим содержимое
			try
			{
				if ((this.utfVCAR_CARDataGridView.CurrentRow.Index + 1)
				    != this.utfVCAR_CARDataGridView.RowCount)
				{
					//_is_valid &= this.Check_Items();
					this.Ok_Toggle(_is_valid);
				}
			}
			catch { }
		}

		private void button_find_Click(object sender, EventArgs e)
		{
			this.utfVCAR_CARTableAdapter.Fill(this.ANGEL_TO_001_Car.utfVCAR_CAR, ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
			                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
			                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                              , DateTime.Now);
		}

		private void copyToolStripMenuItem_Click(object sender, EventArgs e)
		{
			try
			{
				_selected_rows = this.utfVCAR_CARDataGridView.SelectedRows;
				this.pasteToolStripMenuItem.Enabled = true;
			}
			catch (Exception Appe)
			{ }
		}

		private void pasteToolStripMenuItem_Click(object sender, EventArgs e)
		{
			using (Dialog DialogForm = new Dialog())
				
			{
				DialogForm._dialog_label = "Вы уверены что хотите изменить автомобиль?";
				DialogForm.BackColor = Color.Yellow;
				DialogForm.ShowDialog(this);
				if (DialogForm.DialogResult == DialogResult.OK)
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
								this.InsertToolStripMenuItem_Click(sender, e);
							}
							//for (int j = 0; j <= _selected_rows[i].Cells.Count - 1; i++)
							// {
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn10.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn21.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn21.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn32.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn32.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn29.Index].ColumnIndex].Value
								= DBNull.Value;
							//        = _selected_rows[i].Cells[dataGridViewTextBoxColumn29.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn30.Index].ColumnIndex].Value
								= DBNull.Value;
							//       = _selected_rows[i].Cells[dataGridViewTextBoxColumn30.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn26.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn26.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn28.Index].ColumnIndex].Value
								= DBNull.Value;
							//       = _selected_rows[i].Cells[dataGridViewTextBoxColumn28.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn22.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn22.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn25.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn25.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn23.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn23.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn24.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn24.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn27.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn27.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn31.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn31.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn8.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn9.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn11.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn11.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn12.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn13.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn13.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn14.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn14.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn15.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn15.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn16.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn16.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn17.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn17.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn18.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn18.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn19.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn19.Index].Value;
							this.utfVCAR_CARDataGridView.CurrentRow.Cells[_selected_rows[i].Cells[dataGridViewTextBoxColumn20.Index].ColumnIndex].Value
								= _selected_rows[i].Cells[dataGridViewTextBoxColumn20.Index].Value;

							this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value = DBNull.Value;
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
			}
		}

		private void utfVCAR_CARDataGridView_SelectionChanged(object sender, EventArgs e)
		{
			//MessageBox.Show(this.utfVCAR_CARDataGridView.SelectedRows.Count.ToString());
			if (this.utfVCAR_CARDataGridView.SelectedRows.Count > 0)
			{
				this.copyToolStripMenuItem.Enabled = true;
			}
			else
			{
				this.copyToolStripMenuItem.Enabled = false;
			}
		}

		private void utfVCAR_CARDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

		private void last_ts_verifyToolStripMenuItem_Click(object sender, EventArgs e)
		{
			//using (Dialog DialogForm = new Dialog())
				
			//{
				//DialogForm._dialog_label = "Вы уверены что хотите изменить автомобиль?";
				//DialogForm.BackColor = Color.Yellow;
				//DialogForm.ShowDialog(this);
				//if (DialogForm.DialogResult == DialogResult.OK)
				//{

					using (Last_ts_type Last_ts_typeForm = new Last_ts_type())
					{

						Last_ts_typeForm._last_ts_type_car_id
							= this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
						Last_ts_typeForm.ShowDialog(this);
						if (Last_ts_typeForm.DialogResult == DialogResult.OK)
						{

							this.utfVCAR_CARDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn33.Index].Value
								= "1";

							_is_valid &= false;
							Ok_Toggle(_is_valid);
						}
					}
				//}
			//}
			

			
		}

		private void utfVCAR_CARDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
		{

		}

	}
}
