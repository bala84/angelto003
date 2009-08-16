/* 
 * Проект:    SerialPort Terminal
 * Компания:  polus-it http://polus-it.ru
 * Автор:     Valery Lavrentiev
 * Создано:    Май 2008
 * 
 * Замечания:      Приложение создано для работы с считывателями компании Proximus TM/W-3. 
 *                 Для его полноценной работы необходимо Listener для обновления данных.
 * TODO:           Работа с разными считывателями и изменение настроек "на лету"
 */

#region Namespace Inclusions
using System;
using System.Data;
using System.Text;
using System.Drawing;
using System.IO.Ports;
using System.Windows.Forms;
using System.ComponentModel;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Xml;
using System.Net.Sockets;

using SerialPortTerminal.Properties;
#endregion

namespace SerialPortTerminal
{
    #region Public Enumerations
    public enum DataMode { Text, Hex }
    public enum LogMsgType { Incoming, Outgoing, Normal, Warning, Error };
    #endregion

    public partial class frmTerminal : Form
    {
        #region Local Variables

        // Главный контрол для связи с RS-232 портом
        private SerialPort comport = new SerialPort();

        // Разные цвета для сообщений
        private Color[] LogMsgTypeColor = { Color.Blue, Color.Green, Color.Black, Color.Orange, Color.Red };

        // Временный флажок для хранения свойства нажатия на кнопку
        private bool KeyHandled = false;

        // Название устройства
        private string Device_name = Settings.Default.Device_name.ToString();

        // Информационное сообщение устройства
        private string Device_info_msg = Settings.Default.Device_info_msg.ToString();
        // Индекс символа конца кода в устройстве, которое необходимо записать 
        private int Device_length_msg = Settings.Default.Device_length_msg;
        // Индекс символа начала кода в устройстве, которое необходимо записать
        private int Device_offset_msg = Settings.Default.Device_offset_msg;

        private int port;
        private string ip;
        private string Terminal_color = Settings.Default.Terminal_color;

        #endregion

        #region Constructor
        public frmTerminal()
        {

            this.components = null;
            this.comport = new SerialPort();
            this.LogMsgTypeColor = new Color[] { Color.Blue, Color.Green, Color.Black, Color.Orange, Color.Red };
            this.KeyHandled = false;
            this.Device_name = Settings.Default.Device_name.ToString();
            this.Device_info_msg = Settings.Default.Device_info_msg.ToString();
            this.Device_length_msg = Settings.Default.Device_length_msg;
            this.Device_offset_msg = Settings.Default.Device_offset_msg;
            this.port = 0xbef8;
            this.ip = Settings.Default.Ip_server;
             

            // Строим форму
            InitializeComponent();

            // Вспоминаем настройки пользователя
            InitializeControlValues();

            // Включаем/выключаем контролы на основе состояния приложения
            EnableControls();

            // Когда получили данные с порта вызываем это событие
            comport.DataReceived += new SerialDataReceivedEventHandler(port_DataReceived);


        }
        #endregion

        #region Local Methods

        /// <summary> Сохраним настройки пользователя. </summary>
        private void SaveSettings()
        {
            Settings.Default.BaudRate = int.Parse(cmbBaudRate.Text);
            Settings.Default.DataBits = int.Parse(cmbDataBits.Text);
            Settings.Default.DataMode = CurrentDataMode;
            Settings.Default.Parity = (Parity)Enum.Parse(typeof(Parity), cmbParity.Text);
            Settings.Default.StopBits = (StopBits)Enum.Parse(typeof(StopBits), cmbStopBits.Text);
            Settings.Default.PortName = cmbPortName.Text;

            Settings.Default.Save();
        }

        /// <summary> Настроим контролы с дефолтными значениями. </summary>
        private void InitializeControlValues()
        {
            cmbParity.Items.Clear(); cmbParity.Items.AddRange(Enum.GetNames(typeof(Parity)));
            cmbStopBits.Items.Clear(); cmbStopBits.Items.AddRange(Enum.GetNames(typeof(StopBits)));

            cmbParity.Text = Settings.Default.Parity.ToString();
            cmbStopBits.Text = Settings.Default.StopBits.ToString();
            cmbDataBits.Text = Settings.Default.DataBits.ToString();
            cmbParity.Text = Settings.Default.Parity.ToString();
            cmbBaudRate.Text = Settings.Default.BaudRate.ToString();
            CurrentDataMode = Settings.Default.DataMode;

            cmbPortName.Items.Clear();
            foreach (string s in SerialPort.GetPortNames())
                cmbPortName.Items.Add(s);

            if (cmbPortName.Items.Contains(Settings.Default.PortName)) cmbPortName.Text = Settings.Default.PortName;
            else if (cmbPortName.Items.Count > 0) cmbPortName.SelectedIndex = 0;
            else
            {
                MessageBox.Show(this, "Не обнаружен COM порт.\nУстановите COM порт и откройте заново приложение.", "Нет установленных COM портов", MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.Close();
            }
        }


        /// <summary> Включаем/выключаем контролы в зависимости от состояния приложения. </summary>
        private void EnableControls()
        {
            // Если открыт порт
            //gbPortSettings.Enabled = !comport.IsOpen;
            txtSendData.Enabled = btnSend.Enabled = comport.IsOpen;

            if (comport.IsOpen) btnOpenPort.Text = "&Закрыть";
            else btnOpenPort.Text = "&Открыть";
        }


  
        /// <summary> Логируем данные в окно приложения. </summary>
        /// <param name="msgtype"> Тип сообщения для записи. </param>
        /// <param name="msg"> Сообщение. </param>
        private void Log(LogMsgType msgtype, string msg)
        {
            rtfTerminal.Invoke(new EventHandler(delegate
            {
                rtfTerminal.SelectedText = string.Empty;
                rtfTerminal.SelectionFont = new Font(rtfTerminal.SelectionFont, FontStyle.Bold);
                rtfTerminal.SelectionColor = LogMsgTypeColor[(int)msgtype];
                rtfTerminal.AppendText(msg);
                rtfTerminal.ScrollToCaret();
            }));
        }


        /// <summary> Логирование данных в DatagridView. </summary>
        /// <param name="msgtype"> Тип сообщения для записи. </param>
        /// <param name="device_name"> Название устройства. </param>
        /// <param name="msg"> Сообщение. </param>
        private void Log(LogMsgType msgtype, string device_name, string msg)
        {
            this.uspVSYS_SERIAL_LOG_SelectAllBindingSource.AddNew();
            this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                = device_name;
            this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                = msg;

        }


        /// <summary> Преобразуем hex значения (ex: E4 CA B2)в массив byte. </summary>
        /// <param name="s"> Строка с hex значениями (с пробелами или без). </param>
        /// <returns> Возвращает массив byte. </returns>
        private byte[] HexStringToByteArray(string s)
        {
            s = s.Replace(" ", "");
            byte[] buffer = new byte[s.Length / 2];
            for (int i = 0; i < s.Length; i += 2)
                buffer[i / 2] = (byte)Convert.ToByte(s.Substring(i, 2), 16);
            return buffer;
        }

        /// <summary> Преобразуем массив byte в hex строку (ex: E4 CA B2)</summary>
        /// <param name="data"> Массив byte. </param>
        /// <returns> Возвращает хорошо отформатированную строку hex значений. </returns>
        private string ByteArrayToHexString(byte[] data)
        {
            StringBuilder sb = new StringBuilder(data.Length * 3);
            foreach (byte b in data)
                sb.Append(Convert.ToString(b, 16).PadLeft(2, '0').PadRight(3, ' '));
            return sb.ToString().ToUpper();
        }


        #endregion

        #region Local Properties
        private DataMode CurrentDataMode
        {
            get
            {
                if (rbHex.Checked) return DataMode.Hex;
                else return DataMode.Text;
            }
            set
            {
                if (value == DataMode.Text) rbText.Checked = true;
                else rbHex.Checked = true;
            }
        }
        #endregion

        #region Event Handlers


        private void frmTerminal_Shown(object sender, EventArgs e)
        {
            Log(LogMsgType.Normal, String.Format("Приложение открыто в {0}\n", DateTime.Now));
        }
        private void frmTerminal_FormClosing(object sender, FormClosingEventArgs e)
        {
            // При закрытии сохраняем настройки пользователя
            SaveSettings();
        }

        private void rbText_CheckedChanged(object sender, EventArgs e)
        { if (rbText.Checked) CurrentDataMode = DataMode.Text; }
        private void rbHex_CheckedChanged(object sender, EventArgs e)
        { if (rbHex.Checked) CurrentDataMode = DataMode.Hex; }

        private void cmbBaudRate_Validating(object sender, CancelEventArgs e)
        { int x; e.Cancel = !int.TryParse(cmbBaudRate.Text, out x); }
        private void cmbDataBits_Validating(object sender, CancelEventArgs e)
        { int x; e.Cancel = !int.TryParse(cmbDataBits.Text, out x); }


        private void btnOpenPort_Click(object sender, EventArgs e)
        {
            // Если порт открыт, закроем его
            if (comport.IsOpen) comport.Close();
            else
            {
                // Устанавливаем настройки порта
                comport.BaudRate = int.Parse(cmbBaudRate.Text);
                comport.DataBits = int.Parse(cmbDataBits.Text);
                comport.StopBits = (StopBits)Enum.Parse(typeof(StopBits), cmbStopBits.Text);
                comport.Parity = (Parity)Enum.Parse(typeof(Parity), cmbParity.Text);
                comport.PortName = cmbPortName.Text;

                // Открыт порт
                comport.Open();
            }

            // Изменим настройки контролов
            EnableControls();

            // Если открыт порт, сфокусируем контрол SendData
            if (comport.IsOpen) txtSendData.Focus();
        }
        /// <summary> Для проверки соединения с Listener</summary>
        private void send_Request()
        {
            try
            {
                TcpClient client = new TcpClient(this.ip, this.port);
                byte[] request = Encoding.ASCII.GetBytes("request");
                this.txtSendData.Text = "Отправляем запрос...";
                client.GetStream().Write(request, 0, request.Length);
                byte[] response = new byte[client.ReceiveBufferSize];
                int bytesRead = client.GetStream().Read(response, 0, client.ReceiveBufferSize);
                this.txtSendData.Text = "Получаем ответ: " + Encoding.ASCII.GetString(response);
                client.Close();
            }
            catch
            {
                MessageBox.Show("Не удалось отправить запрос");
            }
        }



        private void btnSend_Click(object sender, EventArgs e)
        { this.send_Request(); }

        private void port_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            string v_string = "";
            try
            {
                // Если есть необходимые данные в буфере, используем этот метод

                // Определяем в каком виде выводить данные пользователю
                if (CurrentDataMode == DataMode.Text)
                {
                    // Считываем все данные в буфере
                    string data = comport.ReadExisting();

                    // Отображаем данные в окне приложения
                    Log(LogMsgType.Incoming, data);
                }
                else
                {
                    // Получим количество ожидающих байт
                    int bytes = comport.BytesToRead;

                    // Создадим массив byte для хранения поступивших данных
                    byte[] buffer = new byte[bytes];

                    // Считываем данные из буфера и помещаем в массив
                    comport.Read(buffer, 0, bytes);

                    // Показываем данные в окне
                    Log(LogMsgType.Incoming, ByteArrayToHexString(buffer));
                    //Запигем лог в DataGridView и БД, если сообщение удовлетворяет настройкам
                    //и неявляется информационным
                    if ((ByteArrayToHexString(buffer).Length >= (Device_length_msg - Device_offset_msg)) 
                        && (ByteArrayToHexString(buffer) != Device_info_msg))
                    {
                        
                        if (ByteArrayToHexString(buffer).Length == (Device_length_msg - Device_offset_msg) + 1)
                        {
                            try
                            {
                                v_string = ByteArrayToHexString(buffer).Substring(0, (Device_length_msg - Device_offset_msg));
                            }
                            catch
                            { }
                        }
                        if (v_string != "")
                        {
                            // Запишем лог в Datagridview
                            Log(LogMsgType.Incoming, Device_name, v_string);
                            this.action_textBox.Text = "В " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString() + " была прислонена карточка. Номер карточки: '" + v_string + "'";
                            // Запишем лог в БД если у нас пришло нестатусное сообщение
                            this.Validate();
                            this.uspVSYS_SERIAL_LOG_SelectAllBindingSource.EndEdit();
                            this.tableAdapterManager.UpdateAll(this.angel_to_serialDataSet);
                            this.rtfTerminal.Text = "";
                            try
                            {
                                this.send_Request();
                            }
                            catch
                            {
                            }
                        }
                    }

                }
            }
            catch (SqlException Sqle)
            {

                switch (Sqle.Number)
                {
                    case 515:
                        MessageBox.Show("Необходимо заполнить все обязательные поля!");
                        break;

                    default:
                        MessageBox.Show("Ошибка");
                        MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                        MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                        MessageBox.Show("Источник: " + Sqle.Source.ToString());
                        break;
                }
            }

            catch (Exception Appe)
            {
                MessageBox.Show(Appe.Message);
            }
        }





        #endregion

        private void frmTerminal_Load(object sender, EventArgs e)
        {  //Есть два цвета терминала для входа и для выхода
            this.btnOpenPort_Click(sender, e);
            try
            {
                if (this.Terminal_color == "Yellow")
                {
                    this.BackColor = Color.Yellow;
                }
                if (this.Terminal_color == "YellowGreen")
                {
                    this.BackColor = Color.YellowGreen;
                }
            }
            catch
            {
            }

        }

    }
}
