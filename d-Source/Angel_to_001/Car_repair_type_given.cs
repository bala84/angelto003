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
    public partial class Car_repair_type_given : Form
    {
        public string _username;

        public Car_repair_type_given()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void fillToolStripButton_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

        }

        private void Car_repair_type_given_Load(object sender, EventArgs e)
        {
            start_dateTimePicker.Value = DateTime.Now.AddDays(-7.0);

            p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();

            end_dateTimePicker.Value = DateTime.Now;

            p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();

            p_searchtextBox.Text = DBNull.Value.ToString();
            this.p_Srch_TypeToolStripTextBox.Text = Const.Pt_search.ToString();
            this.p_Top_n_by_rankToolStripTextBox.Text = Const.Top_n_by_rank.ToString();
            try
            {
                this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }


        }

        private void start_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            
            try
            {
                p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
                this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
               
            }
        }

        private void end_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            
            try
            {
                p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();

                this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                
            }
        }

        private void button_find_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), this.p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

        }

        private void uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие предстоящего ТО и перепробег и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllDataGridView.Columns[e.ColumnIndex].Name == "dataGridViewTextBoxColumn8")
                {
                    if (
                        (decimal)Convert.ChangeType(this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllDataGridView.Rows[e.RowIndex].Cells[dataGridViewTextBoxColumn7.Index].Value.ToString(), typeof(decimal)) > 0)
                    {
                        this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.Red;
                    }
                    else
                    {
                        if ((bool)Convert.ChangeType(e.Value.ToString(), typeof(bool)))
                        {
                            this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                                = Color.Yellow;

                        }
                        else
                        {
                            this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                                = this.uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAllDataGridView.DefaultCellStyle.BackColor;

                        }
                    }


                }
            }
            catch (Exception Appe)
            { }
        }

        private void open_orderToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Warehouse_order Warehouse_orderForm = new Warehouse_order())
            {
                Warehouse_orderForm._username = _username;
                Warehouse_orderForm.ShowDialog(this);
            };
        }
    }
}
