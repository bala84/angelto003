using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;

namespace Angel_to_001
{
    public partial class Serial_log : Form
    {
        public string _username;

        private readonly int port = 48888;
        private readonly IPAddress ip = IPAddress.Parse(System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Ip_server"]);
        private TcpListener listener;

        [DllImport("winmm.dll", EntryPoint="sndPlaySound")] 
        public static extern long PlaySound(string fileName, long flags);
         
        public Serial_log()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;

            start_dateTimePicker.Value = DateTime.Now.AddDays(-7.0);

            p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();


            end_dateTimePicker.Value = DateTime.Now;

            p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();

        }

        private void fillToolStripButton_Click(object sender, EventArgs e)
        {
            

        }

        private void Serial_log_Load(object sender, EventArgs e)
        {
            string v_Str = "";

            if (this.str_textBox.Text != "")
            {
                this.p_StrToolStripTextBox.Text = this.str_textBox.Text;
            }

            if (this.p_StrToolStripTextBox.Text != "")
            {
                v_Str = this.p_StrToolStripTextBox.Text;
            }

            try
            {
                this.uspVREP_SERIAL_LOG_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVREP_SERIAL_LOG_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), v_Str);
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            this.backgroundWorker1.RunWorkerAsync(); 
        }

        private void reselect_toolStripButton_Click(object sender, EventArgs e)
        {
            string v_Str = "";

            if (this.str_textBox.Text != "")
            {
                this.p_StrToolStripTextBox.Text = this.str_textBox.Text;
            }

            if (this.p_StrToolStripTextBox.Text != "")
            {
                v_Str = this.p_StrToolStripTextBox.Text;
            }



            try
            {
                this.uspVREP_SERIAL_LOG_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVREP_SERIAL_LOG_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), v_Str);
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void button_find_Click(object sender, EventArgs e)
        {
            string v_Str = "";

            if (this.str_textBox.Text != "")
            {
                this.p_StrToolStripTextBox.Text = this.str_textBox.Text;
            }

            if (this.p_StrToolStripTextBox.Text != "")
            {
                v_Str = this.p_StrToolStripTextBox.Text;
            }
            
            try
            {
                this.uspVREP_SERIAL_LOG_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVREP_SERIAL_LOG_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), v_Str);
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void end_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
                string v_Str = "";

                if (this.str_textBox.Text != "")
                {
                    this.p_StrToolStripTextBox.Text = this.str_textBox.Text;
                }

                if (this.p_StrToolStripTextBox.Text != "")
                {
                    v_Str = this.p_StrToolStripTextBox.Text;
                }

               // try
                //{
                    this.uspVREP_SERIAL_LOG_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVREP_SERIAL_LOG_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), v_Str);
                //}
                //catch (System.Exception ex)
                //{
                 //   System.Windows.Forms.MessageBox.Show(ex.Message);
               // }
            }
            catch { }
        }

        private void start_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
                string v_Str = "";

                if (this.str_textBox.Text != "")
                {
                    this.p_StrToolStripTextBox.Text = this.str_textBox.Text;
                }

                if (this.p_StrToolStripTextBox.Text != "")
                {
                    v_Str = this.p_StrToolStripTextBox.Text;
                }
               // try
               // {
                    this.uspVREP_SERIAL_LOG_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVREP_SERIAL_LOG_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), v_Str);
               // }
               // catch (System.Exception ex)
               // {
               //     System.Windows.Forms.MessageBox.Show(ex.Message);
               // }
            }
            catch { }
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            try
            {
                listener = new TcpListener(this.ip, this.port);

                Socket s;
                Byte[] incomingBuffer;
                Byte[] time;
                int bytesRead;
                string v_Str = "";

                this.listener.Start();



                while (true)
                {
                    if (this.str_textBox.Text != "")
                    {
                        this.p_StrToolStripTextBox.Text = this.str_textBox.Text;
                    }

                    if (this.p_StrToolStripTextBox.Text != "")
                    {
                        v_Str = this.p_StrToolStripTextBox.Text;
                    }

                    s = this.listener.AcceptSocket();

                    incomingBuffer = new Byte[100];
                    bytesRead = s.Receive(incomingBuffer);

                    time = Encoding.ASCII.GetBytes(
                       System.DateTime.Now.ToString().ToCharArray());
                    //Ответ
                    s.Send(time);
                     try
                     {
                         this.uspVREP_SERIAL_LOG_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVREP_SERIAL_LOG_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), v_Str);

                     }
                     catch
                     {
                     }
                    this.notifyIcon1.ShowBalloonTip(99999999);
                    if (this.soundcheckBox.Checked == true)
                    {
                        PlaySound("sounds\\sndIncMsg.wav", 1);
                    }
                }
                }
            catch { }
     
        }

        private void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            this.textlabel.Text = "Идет прослушивание...";
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            this.textlabel.Text = "";
        }

        private void uspVREP_SERIAL_LOG_SelectAllBindingNavigator_RefreshItems(object sender, EventArgs e)
        {

        }

    }
}
