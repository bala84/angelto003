/*
 * Created by SharpDevelop.
 * User: Администратор
 * Date: 16.02.2008
 * Time: 12:46
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

using System;
using System.Configuration;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Data;

namespace Angel_to_001
{
	/// <summary>
	/// Description of MainForm.
	/// </summary>
    /// 

	public partial class MainForm : Form
	{
        //Переменная для хранения имени пользователя 
        public string _username;

        public string Save_name_psw = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Save_name_psw"];
        public string Username = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Username"];
        public string Password = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Password"];
		public MainForm()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		
		void MainFormLoad(object sender, EventArgs e)
		{
            if (this.Save_name_psw == "true")
            {
                this.save_name_pswcheckBox.Checked = true;
            }
            else
            {
                this.save_name_pswcheckBox.Checked = false;
            }
            this.textBox1.Text = this.Username;
            this.maskedTextBox1.Text = this.Password;
		}
		
		void Button1Click(object sender, EventArgs e)
		{ //Получение данных о строке соединения из app.config

            if (this.chg_def_paramscheckBox.Checked == true)
            {
                this.Visible = false;

                using (UI_Defender UI_DefenderForm = new UI_Defender())
                {
                    UI_DefenderForm.ShowDialog(this);
                    if (UI_DefenderForm.DialogResult == DialogResult.OK)
                    {
                        UI_DefenderForm.Visible = false;
                        using (Change_parameters Change_parametersForm = new Change_parameters())
                        {
                            Change_parametersForm.ShowDialog(this);
                            if (Change_parametersForm.DialogResult == DialogResult.OK)
                            {
                               // connect();
                                MessageBox.Show("Запустите программу заново, чтобы настройки вступили в силу");
                                this.Close();
                            }
                        }
                    }
                    else
                    {
                        this.Visible = true;
                    }
                }
            }
            else
            {
                connect();
            }

		}

        private void connect()
        {
            ConnectionStringSettings settings;
            settings =
                ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {//Процедура проверки пользователя
                        SqlCommand AuthenticationCommand = new SqlCommand("dbo.uspVPRT_USER_Authentication",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_username", SqlDbType.VarChar, 60);
                        parameter.Value = this.textBox1.Text;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_password", SqlDbType.VarChar, 60);
                        parameter.Value = this.maskedTextBox1.Text;

                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();

                        try
                        {

                            if (reader.Read())
                            {
                                // Always call Close when done reading.
                                //TODO: need to close here or not?
                                reader.Close();
                                connection.Close();

                                // System.Configuration.ConfigurationManager.AppSettings.Set("Angel_to_001.Properties.Settings.Save_name_psw", "false");
                                // System.Configuration.ConfigurationManager.AppSettings.Set("Angel_to_001.Properties.Settings.Username", this.textBox1.Text);
                                // System.Configuration.ConfigurationManager.AppSettings.Set("Angel_to_001.Properties.Settings.Password", this.maskedTextBox1.Text);

                                using (MainMenu MainMenuForm = new MainMenu())
                                {
                                    this.Visible = false;
                                    MainMenuForm._username = this.textBox1.Text;

                                    MainMenuForm.ShowDialog(this);
                                    this.Close();

                                };
                            }
                            else
                            {
                                MessageBox.Show("Вы не авторизованы");
                            }
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

        private void button2_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            this.verify();
        }

        private void maskedTextBox1_TextChanged(object sender, EventArgs e)
        {
            this.verify();
        }
        //Процедура сравнивает пароли
        private void verify()
        {
            if (this.textBox1.Text == "")
            {
                this.button1.Enabled = false;
            }
            else
            {
                if (this.maskedTextBox1.Text == "")
                {
                    this.button1.Enabled = false;
                }
                else
                {
                    this.button1.Enabled = true;
                }
            }
        }
	}
}
