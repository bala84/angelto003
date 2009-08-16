using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Reflection;

namespace Angel_to_001
{
    class Just
    {
        public static T CreateShallowCopy<T>(T o) 
        { 
          MethodInfo memberwiseClone = o.GetType().GetMethod("MemberwiseClone", BindingFlags.Instance | BindingFlags.NonPublic); 
            
          return (T)memberwiseClone.Invoke(o, null); 
        } 
        public static T CreateDeepCopy<T>(T o) 
        { 
          T copy = CreateShallowCopy(o); 
          foreach (FieldInfo f in typeof(T).GetFields(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public))
            { 
             object original = f.GetValue(o); 
             f.SetValue(copy, CreateDeepCopy(original)); 
            } return copy;
        }
        public static void ShallowCopyObject<T>(T x, T y) 
        {  
          Type tx = x.GetType();  
          Type ty = y.GetType();  
          foreach (FieldInfo f in tx.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))  
            {  
              //Копируем поле экземпляра x 
             object copy = CreateShallowCopy<object>(f.GetValue(x)); 
              //Переносим значение в экземпляр y
             f.SetValue(y, copy);
            } 
        } 
        public static void DeepCopyObject<T>(T x, T y) 
        {  
           Type tx = x.GetType();  Type ty = y.GetType();  
           foreach (FieldInfo f in tx.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
           {  //Копируем поле экземпляра x 
               object copy = CreateDeepCopy<object>(f.GetValue(x));  
              //Переносим значение в экземпляр y
               f.SetValue(y, copy);   
           } 
        }
        //Функция обрабатывает стандартные ошибки
        public static string Error_Message_Translate(string v_input_message)
        {
          string v_output_message;	
          switch (v_input_message)
				{
					case "Input string was not in a correct format.":
						v_output_message = "Неверный формат числа, укажите запятую вместо точки";
						break;

					default:
						v_output_message = v_input_message;
						break;
				}
          return v_output_message;
        }
        //Процедура подготавливает детальную таблицу для записи
        public static void Prepare_Detail (int master_id_index, DataGridViewRowCollection dgvRows, string v_master_id)
		{
			foreach(DataGridViewRow currentRow in dgvRows)
			{
			 try
			 {
				currentRow.Cells[master_id_index].Value = v_master_id;
			 }
			 catch {}
			}
		}
        //Функция получения номера путевого листа
        public static string Get_driver_list_number(decimal p_car_type_id, decimal p_organization_id)
        {
            string v_number = "";
            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("dbo.uspVDRV_DRIVER_LIST_SEQ_Generate",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_car_type_id", SqlDbType.Decimal);
                        parameter.Value = p_car_type_id;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_organization_id", SqlDbType.Decimal);
                        parameter.Value = p_organization_id;

                        parameter = AuthenticationCommand.Parameters.Add(
                          "@p_number", SqlDbType.VarChar, 20);


                        parameter.Direction = ParameterDirection.Output;

                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {

                            v_number = AuthenticationCommand.Parameters["@p_number"].Value.ToString();

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
            return v_number;
        }
        //Функция получения номера заказа - наряда
        public static string Get_order_number(string p_sent_to)
        {
            string v_number = "";
            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("dbo.uspVWRH_WRH_ORDER_SEQ_Generate",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_sent_to", SqlDbType.Char, 1);
                        parameter.Value = p_sent_to;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_number", SqlDbType.VarChar, 20);

                        parameter.Direction = ParameterDirection.Output;

                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {

                            v_number = AuthenticationCommand.Parameters["@p_number"].Value.ToString();

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
            return v_number;
        }


        //Функция проверки правильности заведения ТО
        public static string Сheck_ts(decimal p_id, decimal p_repair_type_master_id, DateTime p_date_created)
        {
            string v_is_correct = "Y";
            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("dbo.uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_Check_correct_ts",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_id", SqlDbType.Decimal);
                        parameter.Value = p_id;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_repair_type_master_id", SqlDbType.Decimal);
                        parameter.Value = p_repair_type_master_id;

                        parameter = AuthenticationCommand.Parameters.Add(
                         "@p_date_created", SqlDbType.DateTime);
                        parameter.Value = p_date_created;

                        parameter = AuthenticationCommand.Parameters.Add(
                         "@p_is_correct", SqlDbType.Char, 1);

                        parameter.Direction = ParameterDirection.Output;

                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {

                            v_is_correct = AuthenticationCommand.Parameters["@p_is_correct"].Value.ToString();

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
            return v_is_correct;
        }

        //Функция создания нового плана на день по предыдущему дню
        public static void Insert_new_driver_plan_detail_by_prev(DateTime p_date, DateTime p_curr_date, decimal p_organization_id, decimal p_car_kind_id)
        {
            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("uspVDRV_DRIVER_PLAN_DETAIL_CreateBy_prevdate",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_date", SqlDbType.DateTime);
                        parameter.Value = p_date;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_curr_date", SqlDbType.DateTime);
                        parameter.Value = p_curr_date;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_organization_id", SqlDbType.Decimal);
                        parameter.Value = p_organization_id;

                        parameter = AuthenticationCommand.Parameters.Add(
                          "@p_car_kind_id", SqlDbType.Decimal);

                        parameter.Value = p_car_kind_id;


                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {

                            //v_number = AuthenticationCommand.Parameters["@p_number"].Value.ToString();

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
           // return v_number;
        }


        //Функция создания нового плана на день по предыдущему месяцу
        public static void Insert_new_driver_plan_by_curr_month()
        {
            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("uspVDRV_DRIVER_PLAN_CreateBy_currmonth",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;




                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {

                            //v_number = AuthenticationCommand.Parameters["@p_number"].Value.ToString();

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
            // return v_number;
        }


        //Функция удаления плана за определенную дату
        public static void Delete_driver_plan_by_date(DateTime p_date, Decimal p_organization_id, Decimal p_car_kind_id)
        {
            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("uspVDRV_DRIVER_PLAN_DETAIL_DeleteAll_ByDate",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_date", SqlDbType.DateTime);
                        parameter.Value = p_date;

                        parameter = AuthenticationCommand.Parameters.Add(
                            "@p_organization_id", SqlDbType.Decimal);
                        parameter.Value = p_organization_id;

                        parameter = AuthenticationCommand.Parameters.Add(
                          "@p_car_kind_id", SqlDbType.Decimal);

                        parameter.Value = p_car_kind_id;


                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {

                            //v_number = AuthenticationCommand.Parameters["@p_number"].Value.ToString();

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
            // return v_number;
        }
        //Функция проверки правильности обработки требований
        public static string Check_correct_demand(Decimal p_wrh_order_master_id)
        {
            string v_is_correct = "Y";

            System.Configuration.ConnectionStringSettings settings;
            settings =
                System.Configuration.ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"];
            if (settings != null)
            {


                // Подключение к БД
                try
                {
                    using (SqlConnection connection = new SqlConnection(settings.ConnectionString))
                    {
                        SqlCommand AuthenticationCommand = new SqlCommand("uspVWRH_DEMAND_DETAIL_check_correctnes",
                                                                          connection);
                        AuthenticationCommand.CommandType = CommandType.StoredProcedure;

                        //Добавление параметров для процедуры
                        SqlParameter parameter = AuthenticationCommand.Parameters.Add(
                            "@p_wrh_order_master_id", SqlDbType.Decimal);
                        parameter.Value = p_wrh_order_master_id;



                        parameter = AuthenticationCommand.Parameters.Add(
                         "@p_is_correct_demanded", SqlDbType.Char, 1);

                        parameter.Direction = ParameterDirection.Output;

                        connection.Open();

                        SqlDataReader reader = AuthenticationCommand.ExecuteReader();


                        try
                        {
                            v_is_correct = AuthenticationCommand.Parameters["@p_is_correct_demanded"].Value.ToString();
                            //v_number = AuthenticationCommand.Parameters["@p_number"].Value.ToString();

                            reader.Close();
                            connection.Close();
                            return v_is_correct;

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
                    return v_is_correct;

                }
            }
            return v_is_correct;
        }

    }
}
