using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Angel_to_001
{
    public partial class UI_Defender : Form
    {

        public string System_name_psw = System.Configuration.ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Defender_psw"];

        public UI_Defender()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void button_ok_Click(object sender, EventArgs e)
        {

        }

        private void first_input_passw_TextChanged(object sender, EventArgs e)
        {
            this.compare();
        }

        private void second_input_passw_TextChanged(object sender, EventArgs e)
        {
            this.compare();
        }
        //Процедура сравнивает пароли
        private void compare()
        {
            if (this.first_input_passw.Text != this.second_input_passw.Text)
            {
                this.button_ok.Enabled = false;
            }
            else
            {
                if (this.first_input_passw.Text != this.System_name_psw)
                {
                    this.button_ok.Enabled = false;
                }
                else
                {
                    this.button_ok.Enabled = true;
                }
            }
        }
    }
}
