/*
 * Created by SharpDevelop.
 * User: Администратор
 * Date: 18.05.2008
 * Time: 12:56
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

using System;
using System.Drawing;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Data.OleDb;
using System.Data.Common;
using System.IO;
using System.Data.SqlClient;

namespace Angel_to_001
{
	/// <summary>
	/// Description of Load_warehouse_item.
	/// </summary>
	public partial class Load_warehouse_item : Form
	{
        public string _username;

		//Переменные для обработки файла загрузки
		private string Lwi_warehouse_sname = "";
		private string Lwi_good_category_fname = "";
		//Способ загрузки
		private string Lwi_edit_state = "U";
		
		public Load_warehouse_item()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		//Считываем файл с данными по остаткам на складе и отправляем его в бд
		void Button_okClick(object sender, EventArgs e)
		{
			string v_warehouse_sname = "";
			string v_good_category_fname = "";
			string v_amount = "";
			string v_total_sum = "";
			string v_edit_state = Lwi_edit_state;
			if (this.organization_idtextBox.Text != "")
			{
				try
				{
					string connectionString = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=остатки.xls;Extended Properties=""Excel 8.0;HDR=YES;IMEX=1""";

					DbProviderFactory factory =
						DbProviderFactories.GetFactory("System.Data.OleDb");

					using (DbConnection connection = factory.CreateConnection())
					{
						connection.ConnectionString = connectionString;

						using (DbCommand command = connection.CreateCommand())
						{
							
							command.CommandText = "SELECT * FROM [TDSheet$]";

							connection.Open();

							using (DbDataReader dr = command.ExecuteReader())
							{
								while (dr.Read())
								{
									if (dr["Субконто"].ToString().ToUpper().Contains("ИТОГО") == true)
									{
										break;
									}
									
									//MessageBox.Show(dr["Субконто"].ToString());
									if ((dr["Субконто"].ToString().ToUpper().Contains("СКЛАД") == true)
									    &&(dr["Субконто"].ToString()!= ""))
									{
										v_warehouse_sname = uspVWRH_LOAD_WAREHOUSE_ITEM_is_wrh_sname_valid(dr["Субконто"].ToString());
									}
									else
									{
										if (dr["Субконто"].ToString() != "")
										{
											v_good_category_fname = uspVWRH_LOAD_WAREHOUSE_ITEM_is_gc_fname_valid(dr["Субконто"].ToString());
											v_total_sum = dr["Сальдо на начало периода"].ToString().Replace(" ","");
										}
									}
									if ((dr["Субконто"].ToString() == "")&&(v_good_category_fname != ""))
									{
										v_amount = dr["Сальдо на начало периода"].ToString().Replace(" ","");
									}
									if (v_amount.IndexOf(",", 0) > 0)
									{
										v_amount = v_amount.Remove(v_amount.IndexOf(",", 0));
									}
									
									//MessageBox.Show("v_total_sum: "+v_total_sum);
									//MessageBox.Show("v_amount:" +v_amount);
									//MessageBox.Show(dr["Сальдо на начало периода"].ToString());
									
									if ((v_warehouse_sname != "") && (v_good_category_fname != "")
									    &&(v_total_sum != "") && (v_amount != ""))
									{
										this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdBindingSource.AddNew();
										this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
											= v_warehouse_sname;
										this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
											= v_good_category_fname;
										this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
											= v_amount;
										this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn18.Index].Value
											= v_total_sum;
										this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn19.Index].Value
											= v_edit_state;
										this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn20.Index].Value
											= this.organization_idtextBox.Text;
										v_good_category_fname = "";
										v_total_sum = "";
										v_amount = "";
									}
									
								}
								
							}
						}
					}
					//Сохранение в БД
					uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdBindingNavigatorSaveItem_Click(sender, e);
					
					MessageBox.Show("Данные успешно загружены");
				}
				catch (SqlException Sqle)
				{

					switch (Sqle.Number)
					{
						case 515:
							MessageBox.Show("Необходимо заполнить все обязательные поля в шаблоне и проверить, что заведены соответствующие склады и товары в справочниках!");
							break;

						case 2601:
							MessageBox.Show("Такой 'Товар' уже существует");
							break;

						default:
							MessageBox.Show("Ошибка");
							MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
							MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
							MessageBox.Show("Источник: " + Sqle.Source.ToString());
							break;
					}
				}
				catch (Exception ex)
				{
					MessageBox.Show("Невозможно прочитать файл: " + ex.Message);
				}
			}
			else
			{
				MessageBox.Show("Проверьте, что перед загрузкой указана организация, к которой принадлежит склад");
			}

			
		}
		
		
		void Button_file_chooseClick(object sender, EventArgs e)
		{
			OpenFileDialog openFileDialog1 = new OpenFileDialog();

			//openFileDialog1.InitialDirectory = "c:\\" ;
			openFileDialog1.Filter = "xls files (*.xls)|*.xls|All files (*.*)|*.*" ;
			openFileDialog1.FilterIndex = 1 ;
			openFileDialog1.RestoreDirectory = true ;
			if(openFileDialog1.ShowDialog() == DialogResult.OK)
			{
                this.file_nametextBox.Text = this.openFileDialog1.FileName;
			}
		}

		private void uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdBindingNavigatorSaveItem_Click(object sender, EventArgs e)
		{
			this.Validate();
			this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdBindingSource.EndEdit();
			this.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById);

		}
		//Функция для определения названия склада
		private string uspVWRH_LOAD_WAREHOUSE_ITEM_is_wrh_sname_valid(string p_warehouse_sname)
		{
			if(p_warehouse_sname != Lwi_warehouse_sname)
			{
				Lwi_warehouse_sname = p_warehouse_sname;
			}
			return Lwi_warehouse_sname;
		}
		
		//Функция для определения названия товара
		private string uspVWRH_LOAD_WAREHOUSE_ITEM_is_gc_fname_valid(string p_good_category_fname)
		{
			if(p_good_category_fname != Lwi_good_category_fname)
			{
				Lwi_good_category_fname = p_good_category_fname;
			}
			return Lwi_good_category_fname;
		}
		
		
		void CheckBox1CheckedChanged(object sender, EventArgs e)
		{
			if (this.checkBox1.Checked == true)
			{
				Lwi_edit_state = "IU";
			}
			else
			{
				Lwi_edit_state = "U";
			}
		}
		
		void UspVWRH_LOAD_WAREHOUSE_ITEM_SaveByIdDataGridViewDataError(object sender, DataGridViewDataErrorEventArgs e)
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
		
		void Button_orgClick(object sender, EventArgs e)
		{
			using (Organization OrganizationForm = new Organization())
			{
				OrganizationForm.ShowDialog(this);
				if (OrganizationForm.DialogResult == DialogResult.OK)
				{

					this.organization_snametextBox.Text
						= OrganizationForm.Org_sname;
					this.organization_idtextBox.Text
						= OrganizationForm.Org_id;
				}
			}
		}
	}
}