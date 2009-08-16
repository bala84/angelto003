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
    public partial class Wrh_income_order_master : Form
    {

        public string _username;

        public Wrh_income_order_master()
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

        private void uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.EndEdit();
            this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll);

        }

        private void Wrh_income_order_master_Load(object sender, EventArgs e)
        {
            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();
            try
            {
                this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Wrh_income_order_detail Warehouse_income_order_detailForm = new Wrh_income_order_detail())
            {
                Warehouse_income_order_detailForm.Text = "Вставка -";
                Warehouse_income_order_detailForm._username = _username;
                Warehouse_income_order_detailForm._warehouse_income_order_detail_form_state = 1;
                Warehouse_income_order_detailForm.ShowDialog(this);
                if (Warehouse_income_order_detailForm.DialogResult == DialogResult.OK)
                {
                    if (this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.RowCount == 1)
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.AddNew();
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.AddNew();
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_id != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[id.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_id;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_date_created != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[date_created.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_date_created ;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_number != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[number.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_number;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_order_income_master_total != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[total.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_order_income_master_total;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_is_verified != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_is_verified;
                    }


                }
            }
        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Wrh_income_order_detail Warehouse_income_order_detailForm = new Wrh_income_order_detail())
            {
                Warehouse_income_order_detailForm.Text = "Редактирование -";
                Warehouse_income_order_detailForm._username = _username;

                Warehouse_income_order_detailForm._warehouse_income_order_master_id = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[id.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_date_created = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[date_created.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_number = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[number.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_total = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[total.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_is_verified = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_detail_form_state = 2;

                Warehouse_income_order_detailForm.ShowDialog(this);
                if (Warehouse_income_order_detailForm.DialogResult == DialogResult.OK)
                {

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_id != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[id.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_id;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_date_created != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[date_created.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_date_created ;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_number != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[number.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_number;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_order_income_master_total != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[total.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_order_income_master_total;
                    }

                    if (Warehouse_income_order_detailForm.Warehouse_income_order_master_is_verified != "")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value
                            = Warehouse_income_order_detailForm.Warehouse_income_order_master_is_verified;
                    }
                }
            }
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Wrh_income_order_detail Warehouse_income_order_detailForm = new Wrh_income_order_detail())
            {
                Warehouse_income_order_detailForm.Text = "Удаление -";
                Warehouse_income_order_detailForm._username = _username;


                Warehouse_income_order_detailForm._warehouse_income_order_master_id = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[id.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_date_created = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[date_created.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_number = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[number.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_total = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[total.Index].Value.ToString();
                Warehouse_income_order_detailForm._warehouse_income_order_master_is_verified = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Cells[this.is_verified.Index].Value.ToString();

                Warehouse_income_order_detailForm._warehouse_income_order_detail_form_state = 3;

                Warehouse_income_order_detailForm.ShowDialog(this);
                if (Warehouse_income_order_detailForm.DialogResult == DialogResult.OK)
                {
                    this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.RemoveCurrent();
                    //_is_valid = false;
                    //Ok_Toggle(false);
                }
            }
        }

        private void uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                    != this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    //this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой
                if (((this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                     == this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.RowCount)
                    && (this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                        == this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.RowCount)
                    {
                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;


                    }
                    else
                    {
                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.EditToolStripMenuItem.Enabled = true;

                    }
                }


            }
            catch (Exception Appe)
            {
            }
        }

        private void end_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                p_end_dateToolStripTextBox.Text = end_dateTimePicker.Value.ToShortDateString();
                this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void start_dateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                p_start_dateToolStripTextBox.Text = start_dateTimePicker.Value.ToShortDateString();
                this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void button_find_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime)))))
                                                                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                //System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            //Проверим наличие закрытых приходных документов и раскрасим в соответствующий цвет строку
            try
            {
                if (this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.Columns[e.ColumnIndex].Name == "is_verified")
                {

                    if (this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].Cells[this.is_verified.Index].Value.ToString() == "Проверен")
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = Color.LightGreen;
                    }
                    else
                    {

                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.Rows[e.RowIndex].DefaultCellStyle.BackColor
                            = this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllDataGridView.DefaultCellStyle.BackColor;


                    }


                }
            }
            catch (Exception Appe)
            { }
        }

    }
}
