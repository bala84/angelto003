/*
 * Created by SharpDevelop.
 * User: Администратор
 * Date: 17.02.2008
 * Time: 15:08
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

using System;
using System.Drawing;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Text;

namespace Angel_to_001
{
	/// <summary>
	/// Description of Employee.
	/// </summary>
	public partial class Employee : Form
	{
        public string _username;
        public string _where_clause = "";
        private bool _is_valid = true;

		public Employee()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();

			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//

		}
		public bool _employee_edited = false;

		//Укажем ФИО для интересующей нас колонки
		public string Employee_fio
		{
			get { string v_fio = "";
                  try
                  {
                      v_fio = this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString(); 
                  }
                   catch {}
                  return v_fio; 
                }
		}

		//Укажем короткое ФИО для интересующей нас колонки
		public string Employee_short_fio
		{
			get { string v_lastname = "";
				string v_name = "";
				string v_surname = "";
				try {
					if (this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString() != "")
					{
						v_lastname = this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value.ToString();
					}
					
					if (this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString() != "")
					{
						v_name = this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value.ToString().Substring(0,1);
					}
					
					if (this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString() != "")
					{
						v_surname = this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn21.Index].Value.ToString().Substring(0,1);
					}
				}
				catch {}
				return v_lastname
					+ " " + v_name
					+ "." + v_surname
					+ "."; }
		}

		//Укажем id  для интересующей нас колонки
		public string Employee_id
		{
            get
            {
                string v_id = "";
                try
                {
                    v_id = this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();  
                }
                catch {}
                return v_id;
            }
		}

		private void utfVPRT_EMPLOYEEBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
            try
            {
                this.Validate();
                this.utfVPRT_EMPLOYEEBindingSource.EndEdit();
                this.utfVPRT_EMPLOYEETableAdapter.Update(this.ANGEL_TO_001_Employee.utfVPRT_EMPLOYEE);
                this.Ok_Toggle(true);
                _is_valid = true;
            }
            catch (SqlException Sqle)
            {   //not null sql exception
                if (Sqle.Number == 515)
                {
                    MessageBox.Show("Необходимо заполнить все обязательные поля!");
                }
                if (Sqle.Number == 547)
                {
                    MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись!");
                    this.utfVPRT_EMPLOYEETableAdapter.Fill(this.ANGEL_TO_001_Employee.utfVPRT_EMPLOYEE
                                                           , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                           , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                           , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                           , DateTime.Now);

                }
                if (Sqle.Number == 2601)
                {
                    MessageBox.Show("Такой 'Сотрудник' уже существует");
                }
                this.Ok_Toggle(false);
                _is_valid = false;
            }
            catch (Exception Appe)
            {
                this.Ok_Toggle(false);
                _is_valid = false;
            }

		}

		private void Employee_Load(object sender, EventArgs e)
		{
			// TODO: This line of code loads data into the 'ANGEL_TO_001_DataSet.utfVPRT_EMPLOYEE' table. You can move, or remove it, as needed.
			p_searchtextBox.Text = DBNull.Value.ToString();
			p_search_typetextBox.Text = Const.Pt_search.ToString();
			p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();

            this.utfVPRT_EMPLOYEEBindingSource.Filter = _where_clause;
			this.utfVPRT_EMPLOYEETableAdapter.Fill(this.ANGEL_TO_001_Employee.utfVPRT_EMPLOYEE, ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
			                                       , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
			                                       , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                   , DateTime.Now);

		}

		private void EditToolStripMenuItem_Click(object sender, EventArgs e)
		{
			this.utfVPRT_EMPLOYEEDataGridView.BeginEdit(false);
			if (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn16")
			{
				
//					using (Dialog DialogForm = new Dialog())
//					{
//						DialogForm._dialog_label = "Вы уверены что хотите изменить организацию?";
//						DialogForm.BackColor = Color.Yellow;
//						DialogForm.ShowDialog(this);
//						if (DialogForm.DialogResult == DialogResult.OK)
//						{
							using (Organization OrganizationForm = new Organization())
							{
								OrganizationForm.ShowDialog(this);
								if (OrganizationForm.DialogResult == DialogResult.OK)
								{

									this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.Value
										= OrganizationForm.Row.Cells[OrganizationForm.Org_name_index].Value;
									this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
										= OrganizationForm.Row.Cells[OrganizationForm.Id_index].Value;
                                    _is_valid = false;
                                    Ok_Toggle(false);
                                }

							}
//						}
//					}
//					_employee_edited = true;
//				}
			}
			if (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn17")
			{
//				using (Dialog DialogForm = new Dialog())
//				{
//					DialogForm._dialog_label = "Вы уверены что хотите изменить должность?";
//					DialogForm.BackColor = Color.Yellow;
//					DialogForm.ShowDialog(this);
//					if (DialogForm.DialogResult == DialogResult.OK)
//					{
						using (Employee_type Employee_typeForm = new Employee_type())
						{
							Employee_typeForm.ShowDialog(this);
							if (Employee_typeForm.DialogResult == DialogResult.OK)
							{

								this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.Value
									= Employee_typeForm.Row.Cells[Employee_typeForm.Job_title_name_index].Value;
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
									= Employee_typeForm.Row.Cells[Employee_typeForm.Id_index].Value;
                                _is_valid = false;
                                Ok_Toggle(false);
							}
						}
//					}
//				}
			}
			if  ( (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11")
			     || (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn18")
			     || (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn12")
			     || (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13")
			     || (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn14")
			     || (this.utfVPRT_EMPLOYEEDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn15"))
				
			{
//				using (Dialog DialogForm = new Dialog())
//				{
//					DialogForm._dialog_label = "Вы уверены что хотите изменить сотрудника?";
//					DialogForm.BackColor = Color.Yellow;
//					DialogForm.ShowDialog(this);
//					if (DialogForm.DialogResult == DialogResult.OK)
//					{
						using (Person PersonForm = new Person())
							
						{
							PersonForm.ShowDialog(this);
							if (PersonForm.DialogResult == DialogResult.OK)
							{
								//Заполним ФИО
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
									=  PersonForm.Person_lastname
									+ " " + PersonForm.Person_name
									+ " " + PersonForm.Person_surname;
								
								//Заполним Id
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
									= PersonForm.Id;
								//Заполним Sex
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
									= PersonForm.Person_sex;
								//Заполним Birthdate
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
									= PersonForm.Person_birthdate;
								//Заполним Mobile Phone
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
									= PersonForm.Person_mobile_phone;
								//Заполним Home Phone
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
									= PersonForm.Person_home_phone;
								//Заполним Work Phone
								this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
									= PersonForm.Person_work_phone;
                                _is_valid = false;
                                Ok_Toggle(false);


							}
						}
					}
//				}
//			}
		}

		private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
		{
            if (this.utfVPRT_EMPLOYEEDataGridView.RowCount == 1)
            {
                this.utfVPRT_EMPLOYEEBindingSource.AddNew();
                this.utfVPRT_EMPLOYEEBindingSource.RemoveCurrent();
            }
            else
            {
                this.utfVPRT_EMPLOYEEBindingSource.AddNew();
            }
            _is_valid = false;
            Ok_Toggle(false);
		}

		private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
		{
			this.utfVPRT_EMPLOYEEBindingSource.RemoveCurrent();
            _is_valid = false;
            Ok_Toggle(false);
		}
		
		private void utfVPRT_EMPLOYEEDataGridView_CurrentCellChanged(object sender, EventArgs e)
		{

		}

		private void printToolStripButton_Click(object sender, EventArgs e)
		{
			// This method will set properties on the PrintDialog object and
			// then display the dialog.
			

			// Set the Document property to the PrintDocument for
			// which the PrintPage Event has been handled. To display the
			// dialog, either this property or the PrinterSettings property
			// must be set
			printDialog1.Document = printDocument1;

			DialogResult result = printDialog1.ShowDialog();

			// If the result is OK then print the document.
			if (result==DialogResult.OK)
			{
				printDocument1.Print();
			}

		}

		// The PrintDialog will print the document
		// by handling the document's PrintPage event.
		private void document_PrintPage(object sender,
		                                System.Drawing.Printing.PrintPageEventArgs e)
		{

			// Insert code to render the page here.
			// This code will be called when the control is drawn.

			// The following code will render a simple
			// message on the printed document.
			string text = "In document_PrintPage method.";
			System.Drawing.Font printFont = new System.Drawing.Font
				("Arial", 35, System.Drawing.FontStyle.Regular);

			// Draw the content.
			e.Graphics.DrawString(text, printFont,
			                      System.Drawing.Brushes.Black, 10, 10);
		}

		private void utfVPRT_EMPLOYEEDataGridView_CellValidated(object sender, DataGridViewCellEventArgs e)
		{

			if ((this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Index + 1)
			    != this.utfVPRT_EMPLOYEEDataGridView.RowCount)
			{
				/*if (Is_FIO_Valid())
				{
					this.FIO_errorProvider.SetError(this.utfVPRT_EMPLOYEEDataGridView, "");
					this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Style.BackColor
						= Color.White;
				}
				else
				{
					this.FIO_errorProvider.SetError(this.utfVPRT_EMPLOYEEDataGridView, "Необходимо ввести ФИО");
					this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Style.BackColor
						= Color.Red;
				}
				if (Is_Org_Name_Valid())
				{
					this.Org_name_errorProvider.SetError(this.utfVPRT_EMPLOYEEDataGridView, "");
					this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Style.BackColor
						= Color.White;
				}
				else
				{
					this.Org_name_errorProvider.SetIconPadding(utfVPRT_EMPLOYEEDataGridView, 15);
					this.Org_name_errorProvider.SetError(this.utfVPRT_EMPLOYEEDataGridView, "Необходимо ввести организацию");
					this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Style.BackColor
						= Color.Red;
				}
				if (Is_Job_Title_Valid())
				{
					this.Job_title_errorProvider.SetError(this.utfVPRT_EMPLOYEEDataGridView, "");
					this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Style.BackColor
						= Color.White;
				}
				else
				{
					this.Job_title_errorProvider.SetIconPadding(utfVPRT_EMPLOYEEDataGridView, 30);
					this.Job_title_errorProvider.SetError(this.utfVPRT_EMPLOYEEDataGridView, "Необходимо ввести должность");
					this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Style.BackColor
						= Color.Red;
				}*/
			}

		}
		// Functions to verify data.
		private bool Is_FIO_Valid()
		{
			return (this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString().Length != 0);
		}

		private bool Is_Org_Name_Valid()
		{
			return (this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString().Length != 0);
		}

		private bool Is_Job_Title_Valid()
		{
			return (this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString().Length != 0);
		}

		private void button_ok_Click(object sender, EventArgs e)
		{
			this.utfVPRT_EMPLOYEEBindingNavigatorSaveItem_Click(sender, e);
		}

		private void button_find_Click(object sender, EventArgs e)
		{

			this.utfVPRT_EMPLOYEETableAdapter.Fill(this.ANGEL_TO_001_Employee.utfVPRT_EMPLOYEE, ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
			                                       , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
			                                       , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                   , DateTime.Now);

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

        private void utfVPRT_EMPLOYEEDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.utfVPRT_EMPLOYEEDataGridView.CurrentRow.Cells[this.dataGridViewTextBoxColumn6.Index].Value
                = this._username;
            }
            catch { }
        }
		


	}
}
