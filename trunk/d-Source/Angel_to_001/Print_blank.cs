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
    public partial class Print_blank : Form
    {
        public string _print_blank_driver_list_type_id;
        public string _print_blank_number;

        public string Print_blank_driver_list_type_id
        {
            get { return this.driver_list_type_idtextBox.Text; }
        }
        public string Print_blank_number
        {
            get { return this.numbertextBox.Text; }
        }

        public Print_blank()
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

        private void form3_radioButton_CheckedChanged(object sender, EventArgs e)
        {
            if (this.form3_radioButton.Checked == true)
            {
                this.form4p_radioButton.Checked = false;
                this.driver_list_type_idtextBox.Text = Const.Car_driver_list_type_id.ToString();
                this.button_ok.Enabled = true;
            }
            else
            {
                if (this.form4p_radioButton.Checked == false)
                {
                    this.button_ok.Enabled = false;
                }
            }
        }

        private void form4p_radioButton_CheckedChanged(object sender, EventArgs e)
        {
            if (this.form4p_radioButton.Checked == true)
            {
                this.form3_radioButton.Checked = false;
                this.driver_list_type_idtextBox.Text = Const.Freight_driver_list_type_id.ToString();
                this.button_ok.Enabled = true;
            }
            else
            {
                if (this.form3_radioButton.Checked == false)
                {
                    this.button_ok.Enabled = false;
                }
            }
        }

        private void numbertextBox_TextChanged(object sender, EventArgs e)
        {
            int v_number; 
            if (this.numbertextBox.Text == "")
            {
                this.button_ok.Enabled = false;
            }
            else
            {
                if ((this.form3_radioButton.Checked == true) || (this.form4p_radioButton.Checked == true))
                {
                    try
                    {
                        v_number = (int)Convert.ChangeType(this.numbertextBox.Text, typeof(int));
                        this.button_ok.Enabled = true;
                    }
                    catch
                    { this.button_ok.Enabled = false; }
                }
            }
        }

        private void Print_blank_Load(object sender, EventArgs e)
        {
            this.driver_list_type_idtextBox.Text = Const.Freight_driver_list_type_id.ToString();
        }
    }
}
