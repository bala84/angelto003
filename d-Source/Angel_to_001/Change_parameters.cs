using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Configuration;

namespace Angel_to_001
{
    public partial class Change_parameters : Form
    {

        private string v_new_conn_string = "";
        private string v_new_printer = "";
        private string v_new_rep_conn_string = "";
        private string v_ar_path = "";

        public Change_parameters()
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

        private void maskedTextBox1_MaskInputRejected(object sender, MaskInputRejectedEventArgs e)
        {

        }

        private void button_save_Click(object sender, EventArgs e)
        {
            //MessageBox.Show(ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"].ToString().Substring(ConfigurationManager.ConnectionStrings["Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString"].ToString().IndexOf("Datasource=")));
            //MessageBox.Show(ConfigurationManager.AppSettings["Angel_to_001.Properties.Settings.Ar_path"].ToString());
            v_new_conn_string = "Data Source=" + this.server_nametextBox.Text + ";Initial Catalog=" + this.db_nametextBox.Text + ";Persist Security Info=True;User ID=" + this.usernametextBox.Text + ";Password=" + this.username_pwdmaskedTextBox.Text;
            v_new_printer = this.printer_nametextBox.Text;
           
            v_new_rep_conn_string = "jdbc:jtds:sqlserver://" + this.server_nametextBox.Text + ":1433/" + this.db_nametextBox.Text + ";USER=" + this.usernametextBox.Text + ";PASSWORD=" + this.username_pwdmaskedTextBox.Text;
            v_ar_path = this.ar_nametextBox.Text;
            ConfigSettings.WriteSetting("connectionStrings", "Angel_to_001.Properties.Settings.ANGEL_TO_001_ConnectionString", v_new_conn_string, "System.Data.SqlClient");
            ConfigSettings.WriteSetting("connectionStrings", "Angel_to_001.Properties.Settings.ANGEL_TO_001_REPORTS_ConnectionString", v_new_rep_conn_string, "net.sourceforge.jtds.jdbc.Driver");
            ConfigSettings.WriteSetting("appSettings", "Angel_to_001.Properties.Settings.Printer_name", v_new_printer, "");
            ConfigSettings.WriteSetting("appSettings", "Angel_to_001.Properties.Settings.Spool_path", "\\\\spool\\" + v_new_printer, "");
            ConfigSettings.WriteSetting("appSettings", "Angel_to_001.Properties.Settings.Ar_path", v_ar_path, "");
            if ((this.server_nametextBox.Text != "")
                    && (this.db_nametextBox.Text != "")
                    && (this.usernametextBox.Text != "")
                    && (this.username_pwdmaskedTextBox.Text != "")
                    && (this.printer_nametextBox.Text != "")
                    && (this.ar_nametextBox.Text != ""))
            {
                this.button_ok.Enabled = true;
            }
            else
            {
                this.button_ok.Enabled = false;
            }
        }
    }
}
