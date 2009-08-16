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
    public partial class Warehouse_income_list : Form
    {
        public string _username;

        public string _warehouse_income_good_category_id;
        public string _warehouse_income_organization_id;
        public string _warehouse_income_warehouse_type_id;
        public string _warehouse_income_amount_to_give;
        public string _warehouse_income_end_date;

        public string _warehouse_income_mode;

        public string _warehouse_income_detail_id;

        //Укажем id для интересующей нас колонки
        public string Warehouse_type_id
        {
            get { return this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.CurrentRow.Cells[this.warehouse_type_id.Index].Value.ToString(); }
        }
        //Укажем название для интересующей нас колонки
        public string Warehouse_type_short_name
        {
            get { return this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.CurrentRow.Cells[this.warehouse_type_sname.Index].Value.ToString(); }
        }


        //Укажем id для интересующей нас колонки
        public string Good_category_price
        {
            get { return this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.CurrentRow.Cells[this.price.Index].Value.ToString(); }
        }

        //Укажем id для интересующей нас колонки
        public string Wrh_income_detail_id
        {
            get { return this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.CurrentRow.Cells[this.id.Index].Value.ToString(); }
        }

        //Укажем id для интересующей нас колонки
        public string Wrh_income_number
        {
            get { return this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.CurrentRow.Cells[this.number.Index].Value.ToString(); }
        }



        public Warehouse_income_list()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;

            start_dateTimePicker.Value = DateTime.Now.AddDays(-7.0);

            end_dateTimePicker.Value = DateTime.Now;

        }

        private void Warehouse_income_list_Load(object sender, EventArgs e)
        {
            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
            
            p_good_category_idToolStripTextBox.Text = _warehouse_income_good_category_id;
            p_organization_idToolStripTextBox.Text = _warehouse_income_organization_id;
            this.p_warehouse_type_idtextBox.Text = _warehouse_income_warehouse_type_id;
            this.p_amount_to_givetextBox.Text = _warehouse_income_amount_to_give;

            p_wrh_income_detail_idToolStripTextBox.Text = _warehouse_income_detail_id;

            Nullable<decimal> v_wrh_income_detail_id = new Nullable<decimal>();

            if (p_wrh_income_detail_idToolStripTextBox.Text != "")
            {
                v_wrh_income_detail_id = (decimal)(System.Convert.ChangeType(this.p_wrh_income_detail_idToolStripTextBox.Text, typeof(decimal)));
            }
            try
            {
                if (v_wrh_income_detail_id.ToString() == "")
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value,(DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , (short)(System.Convert.ChangeType(_warehouse_income_mode, typeof(short)))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));

                }
                else
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value,(DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , 2
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));
                }
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void button_find_Click(object sender, EventArgs e)
        {

            Nullable<decimal> v_wrh_income_detail_id = new Nullable<decimal>();

            if (p_wrh_income_detail_idToolStripTextBox.Text != "")
            {
                v_wrh_income_detail_id = (decimal)(System.Convert.ChangeType(this.p_wrh_income_detail_idToolStripTextBox.Text, typeof(decimal)));
            }
            try
            {
                if (v_wrh_income_detail_id.ToString() == "")
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value, (DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , (short)(System.Convert.ChangeType(_warehouse_income_mode, typeof(short)))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));

                }
                else
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value, (DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , 2
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));
                }
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void start_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            Nullable<decimal> v_wrh_income_detail_id = new Nullable<decimal>();

            if (p_wrh_income_detail_idToolStripTextBox.Text != "")
            {
                v_wrh_income_detail_id = (decimal)(System.Convert.ChangeType(this.p_wrh_income_detail_idToolStripTextBox.Text, typeof(decimal)));
            }
            try
            {
                if (v_wrh_income_detail_id.ToString() == "")
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value, (DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , (short)(System.Convert.ChangeType(_warehouse_income_mode, typeof(short)))
                                                                                                                                                , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));

                }
                else
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value, (DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , 2
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));
                }
            }
            catch (System.Exception ex)
            {
              //  System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void end_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            Nullable<decimal> v_wrh_income_detail_id = new Nullable<decimal>();

            if (p_wrh_income_detail_idToolStripTextBox.Text != "")
            {
                v_wrh_income_detail_id = (decimal)(System.Convert.ChangeType(this.p_wrh_income_detail_idToolStripTextBox.Text, typeof(decimal)));
            }
            try
            {
                if (v_wrh_income_detail_id.ToString() == "")
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value
                                                                                                                                               , (DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , (short)(System.Convert.ChangeType(_warehouse_income_mode, typeof(short)))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));

                }
                else
                {
                    this.uspVWRH_WRH_INCOME_SelectByGood_category_idTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_SelectByGood_category_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_good_category_idToolStripTextBox.Text, typeof(decimal)))))

                                                                                                                           , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_organization_idToolStripTextBox.Text, typeof(decimal)))))
                                                                                                                                               , start_dateTimePicker.Value, (DateTime)(System.Convert.ChangeType(_warehouse_income_end_date, typeof(DateTime))), v_wrh_income_detail_id, p_searchtextBox.Text
                                                                                                                                               , new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_search_typetextBox.Text, typeof(byte)))))
                                                                                                                                               , new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                                                                                                               , 2
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_amount_to_givetextBox.Text, typeof(decimal)))))
                                                                                                                                               , new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_warehouse_type_idtextBox.Text, typeof(decimal))))));
                }
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void open_incomeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Warehouse_income_master Warehouse_income_masterForm = new Warehouse_income_master())
            {
                Warehouse_income_masterForm._username = _username;
                Warehouse_income_masterForm.ShowDialog(this);
            };
        }

        private void uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие закрытых приходных документов и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.Columns[e.ColumnIndex].Name == "is_verified")
                {

                    if (this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.Rows[e.RowIndex].Cells[this.is_verified.Index].Value.ToString() == "Проверен")
                    {
                        this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightGreen;
                    }
                    else
                    {

                        this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVWRH_WRH_INCOME_SelectByGood_category_idDataGridView.DefaultCellStyle.BackColor;


                    }


                }
            }
            catch (Exception Appe)
            { }
        }
    }
}
