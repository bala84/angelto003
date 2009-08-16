/* 
 * ������:    SerialPort Terminal
 * ��������:  polus-it http://polus-it.ru
 * �����:     Valery Lavrentiev
 * �������:    ��� 2008
 * 
 * ���������:      ���������� ������� ��� ������ � ������������� �������� Proximus TM/W-3. 
 *                 ��� ��� ����������� ������ ���������� Listener ��� ���������� ������.
 * TODO:           ������ � ������� ������������� � ��������� �������� "�� ����"
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

        // ������� ������� ��� ����� � RS-232 ������
        private SerialPort comport = new SerialPort();

        // ������ ����� ��� ���������
        private Color[] LogMsgTypeColor = { Color.Blue, Color.Green, Color.Black, Color.Orange, Color.Red };

        // ��������� ������ ��� �������� �������� ������� �� ������
        private bool KeyHandled = false;

        // �������� ����������
        private string Device_name = Settings.Default.Device_name.ToString();

        // �������������� ��������� ����������
        private string Device_info_msg = Settings.Default.Device_info_msg.ToString();
        // ������ ������� ����� ���� � ����������, ������� ���������� �������� 
        private int Device_length_msg = Settings.Default.Device_length_msg;
        // ������ ������� ������ ���� � ����������, ������� ���������� ��������
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
             

            // ������ �����
            InitializeComponent();

            // ���������� ��������� ������������
            InitializeControlValues();

            // ��������/��������� �������� �� ������ ��������� ����������
            EnableControls();

            // ����� �������� ������ � ����� �������� ��� �������
            comport.DataReceived += new SerialDataReceivedEventHandler(port_DataReceived);


        }
        #endregion

        #region Local Methods

        /// <summary> �������� ��������� ������������. </summary>
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

        /// <summary> �������� �������� � ���������� ����������. </summary>
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
                MessageBox.Show(this, "�� ��������� COM ����.\n���������� COM ���� � �������� ������ ����������.", "��� ������������� COM ������", MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.Close();
            }
        }


        /// <summary> ��������/��������� �������� � ����������� �� ��������� ����������. </summary>
        private void EnableControls()
        {
            // ���� ������ ����
            //gbPortSettings.Enabled = !comport.IsOpen;
            txtSendData.Enabled = btnSend.Enabled = comport.IsOpen;

            if (comport.IsOpen) btnOpenPort.Text = "&�������";
            else btnOpenPort.Text = "&�������";
        }


  
        /// <summary> �������� ������ � ���� ����������. </summary>
        /// <param name="msgtype"> ��� ��������� ��� ������. </param>
        /// <param name="msg"> ���������. </param>
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


        /// <summary> ����������� ������ � DatagridView. </summary>
        /// <param name="msgtype"> ��� ��������� ��� ������. </param>
        /// <param name="device_name"> �������� ����������. </param>
        /// <param name="msg"> ���������. </param>
        private void Log(LogMsgType msgtype, string device_name, string msg)
        {
            this.uspVSYS_SERIAL_LOG_SelectAllBindingSource.AddNew();
            this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                = device_name;
            this.uspVSYS_SERIAL_LOG_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                = msg;

        }


        /// <summary> ����������� hex �������� (ex: E4 CA B2)� ������ byte. </summary>
        /// <param name="s"> ������ � hex ���������� (� ��������� ��� ���). </param>
        /// <returns> ���������� ������ byte. </returns>
        private byte[] HexStringToByteArray(string s)
        {
            s = s.Replace(" ", "");
            byte[] buffer = new byte[s.Length / 2];
            for (int i = 0; i < s.Length; i += 2)
                buffer[i / 2] = (byte)Convert.ToByte(s.Substring(i, 2), 16);
            return buffer;
        }

        /// <summary> ����������� ������ byte � hex ������ (ex: E4 CA B2)</summary>
        /// <param name="data"> ������ byte. </param>
        /// <returns> ���������� ������ ����������������� ������ hex ��������. </returns>
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
            Log(LogMsgType.Normal, String.Format("���������� ������� � {0}\n", DateTime.Now));
        }
        private void frmTerminal_FormClosing(object sender, FormClosingEventArgs e)
        {
            // ��� �������� ��������� ��������� ������������
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
            // ���� ���� ������, ������� ���
            if (comport.IsOpen) comport.Close();
            else
            {
                // ������������� ��������� �����
                comport.BaudRate = int.Parse(cmbBaudRate.Text);
                comport.DataBits = int.Parse(cmbDataBits.Text);
                comport.StopBits = (StopBits)Enum.Parse(typeof(StopBits), cmbStopBits.Text);
                comport.Parity = (Parity)Enum.Parse(typeof(Parity), cmbParity.Text);
                comport.PortName = cmbPortName.Text;

                // ������ ����
                comport.Open();
            }

            // ������� ��������� ���������
            EnableControls();

            // ���� ������ ����, ����������� ������� SendData
            if (comport.IsOpen) txtSendData.Focus();
        }
        /// <summary> ��� �������� ���������� � Listener</summary>
        private void send_Request()
        {
            try
            {
                TcpClient client = new TcpClient(this.ip, this.port);
                byte[] request = Encoding.ASCII.GetBytes("request");
                this.txtSendData.Text = "���������� ������...";
                client.GetStream().Write(request, 0, request.Length);
                byte[] response = new byte[client.ReceiveBufferSize];
                int bytesRead = client.GetStream().Read(response, 0, client.ReceiveBufferSize);
                this.txtSendData.Text = "�������� �����: " + Encoding.ASCII.GetString(response);
                client.Close();
            }
            catch
            {
                MessageBox.Show("�� ������� ��������� ������");
            }
        }



        private void btnSend_Click(object sender, EventArgs e)
        { this.send_Request(); }

        private void port_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            string v_string = "";
            try
            {
                // ���� ���� ����������� ������ � ������, ���������� ���� �����

                // ���������� � ����� ���� �������� ������ ������������
                if (CurrentDataMode == DataMode.Text)
                {
                    // ��������� ��� ������ � ������
                    string data = comport.ReadExisting();

                    // ���������� ������ � ���� ����������
                    Log(LogMsgType.Incoming, data);
                }
                else
                {
                    // ������� ���������� ��������� ����
                    int bytes = comport.BytesToRead;

                    // �������� ������ byte ��� �������� ����������� ������
                    byte[] buffer = new byte[bytes];

                    // ��������� ������ �� ������ � �������� � ������
                    comport.Read(buffer, 0, bytes);

                    // ���������� ������ � ����
                    Log(LogMsgType.Incoming, ByteArrayToHexString(buffer));
                    //������� ��� � DataGridView � ��, ���� ��������� ������������� ����������
                    //� ���������� ��������������
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
                            // ������� ��� � Datagridview
                            Log(LogMsgType.Incoming, Device_name, v_string);
                            this.action_textBox.Text = "� " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString() + " ���� ���������� ��������. ����� ��������: '" + v_string + "'";
                            // ������� ��� � �� ���� � ��� ������ ����������� ���������
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
                        MessageBox.Show("���������� ��������� ��� ������������ ����!");
                        break;

                    default:
                        MessageBox.Show("������");
                        MessageBox.Show("�����: " + Sqle.TargetSite.ToString());
                        MessageBox.Show("���������: " + Sqle.Message.ToString());
                        MessageBox.Show("��������: " + Sqle.Source.ToString());
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
        {  //���� ��� ����� ��������� ��� ����� � ��� ������
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
