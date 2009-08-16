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
    public partial class Car_model : Form
    {
        public string _username;

    	private bool _is_valid = true;
        public string Mark_short_name;
        public string Mark_id;
        
        public Car_model()
        {
            InitializeComponent();
            
        }

        //Укажем id для интересующей нас колонки
        public string Model_id
        {
            get 
            {
                try  
                {return this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
                catch
                { return null; }
            }
            // set { Car_mark_id = value; }
        }
        //Укажем название для интересующей нас колонки
        public string Model_short_name
        {
            get 
            {
                try
                {return this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
                catch
                { return null; }
            }
            //set { Car_mark_short_name = value; }
        }


        private void Car_model_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Car_model.utfVCAR_CAR_MODEL' table. You can move, or remove it, as needed.
            try
            {                
                //Присвоим значение 
                this.label2.Text = Mark_short_name;
                this.p_car_mark_idToolStripTextBox.Text = Mark_id;
                this.utfVCAR_CAR_MODELTableAdapter.Fill(this.ANGEL_TO_001_Car_model.utfVCAR_CAR_MODEL, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_mark_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            } 
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
           if (this.utfVCAR_CAR_MODELDataGridView.RowCount == 1)
                {
                    this.utfVCAR_CAR_MODELBindingSource.AddNew();
                    this.utfVCAR_CAR_MODELBindingSource.RemoveCurrent();
                }
                else
                {
                    this.utfVCAR_CAR_MODELBindingSource.AddNew();
                }
                _is_valid &= false;
			    Ok_Toggle(_is_valid);
            
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.utfVCAR_CAR_MODELBindingSource.RemoveCurrent();
            _is_valid &= false;
			Ok_Toggle(_is_valid);
        }

        private void utfVCAR_CAR_MODELDataGridView_CellValidated(object sender, DataGridViewCellEventArgs e)
        {
            if ((this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Index + 1)
                           != this.utfVCAR_CAR_MODELDataGridView.RowCount)
            {
                if (Is_Short_name_Valid())
                {
                    this.Short_name_errorProvider.SetError(this.utfVCAR_CAR_MODELDataGridView, "");
                    this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
                        = Color.White;
                    _is_valid &= true;
                }
                else
                {
                    this.Short_name_errorProvider.SetError(this.utfVCAR_CAR_MODELDataGridView, "Необходимо ввести краткое наименование");
                    this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Style.BackColor
                        = Color.Red;
                    _is_valid &= false;
                }
                if (Is_Full_name_Valid())
                {
                    this.Full_name_errorProvider.SetError(this.utfVCAR_CAR_MODELDataGridView, "");
                    this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Style.BackColor
                        = Color.White;
                    _is_valid &= true;
                }
                else
                {
                    this.Full_name_errorProvider.SetIconPadding(this.utfVCAR_CAR_MODELDataGridView, 15);
                    this.Full_name_errorProvider.SetError(this.utfVCAR_CAR_MODELDataGridView, "Необходимо ввести полное наименование");
                    this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Style.BackColor
                        = Color.Red;
                    _is_valid &= false;
                }
                
			    Ok_Toggle(_is_valid);

            }
        }
        // Functions to verify data.
        private bool Is_Short_name_Valid()
        {
            return (this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString().Length != 0);
        }
        private bool Is_Full_name_Valid()
        {
            return (this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString().Length != 0);
        }

        private void utfVCAR_CAR_MODELDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
        }

        private void utfVCAR_CAR_MODELBindingNavigatorSaveItem_Click_1(object sender, EventArgs e)
        {
           try 
            {
               //Проверим на нулл перед сохранением mark_id

                try
                {
                    this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                       = p_car_mark_idToolStripTextBox.Text;
                }
                catch (NullReferenceException Nex)
                {
                }
                this.Validate();
                this.utfVCAR_CAR_MODELBindingSource.EndEdit();
                this.utfVCAR_CAR_MODELTableAdapter.Update(this.ANGEL_TO_001_Car_model.utfVCAR_CAR_MODEL);
			    Ok_Toggle(true);
			    _is_valid = true;
            }
            catch (SqlException Sqle)
            {   //not null sql exception
					switch (Sqle.Number)
					{
						case 515:
							MessageBox.Show("Необходимо заполнить все обязательные поля!");
							break;

						case 2601:
							MessageBox.Show("Такая 'Модель' уже существует");
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

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.utfVCAR_CAR_MODELBindingNavigatorSaveItem_Click_1(sender, e);
        }

        
        void EditToolStripMenuItemClick(object sender, EventArgs e)
        {
        	try
        	{
				this.utfVCAR_CAR_MODELDataGridView.BeginEdit(false);
				
				if (this.utfVCAR_CAR_MODELDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13")
				{
					using (Route_master Route_masterForm = new Route_master())
					{
						Route_masterForm.ShowDialog(this);
						if (Route_masterForm.DialogResult == DialogResult.OK)
						{
							if (Route_masterForm.Route_master_id != "")
							{
								this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
									= Route_masterForm.Route_master_id;
								this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
									= true;
								_is_valid &= false;
								Ok_Toggle(_is_valid);
							}
						}
					}
				}
			}
			catch (Exception Appe)
			{}
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
        
        void UtfVCAR_CAR_MODELDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void utfVCAR_CAR_MODELDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.utfVCAR_CAR_MODELDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { }
            _is_valid = false;
            Ok_Toggle(_is_valid);
        }
    }
}
