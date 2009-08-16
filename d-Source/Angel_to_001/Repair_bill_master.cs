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
    public partial class Repair_bill_master : Form
    {
        public string _username;

        public string Repair_bill_master_id
        {
            get { return this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }


        public Repair_bill_master()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void uspVRPR_REPAIR_BILL_MASTER_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.uspVRPR_REPAIR_BILL_MASTER_SelectAllBindingSource.EndEdit();
            this.uspVRPR_REPAIR_BILL_MASTER_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_MASTER_SelectAll);

        }

        private void fillToolStripButton_Click(object sender, EventArgs e)
        {
            

        }

        private void Repair_bill_master_Load(object sender, EventArgs e)
        {
            this.p_searchtextBox.Text = DBNull.Value.ToString();
            this.p_search_typetextBox.Text = Const.Pt_search.ToString();
            this.p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();

            try
            {
                this.uspVRPR_REPAIR_BILL_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_MASTER_SelectAll, p_searchtextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Repair_bill_detail Repair_bill_detailForm = new Repair_bill_detail())
            {
                Repair_bill_detailForm.Text = "Вставка -";
                Repair_bill_detailForm.ShowDialog(this);
                if (Repair_bill_detailForm.DialogResult == DialogResult.OK)
                {
                    if (this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.RowCount == 1)
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllBindingSource.AddNew();
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllBindingSource.AddNew();
                    }

                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_full_name != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_full_name;
                    }
                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_repair_type_master_id != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_repair_type_master_id;
                    }
                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_short_name != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_short_name;
                    }

                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_id != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_id;
                    }

                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_is_default != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_default.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_is_default;
                    }


                    //_is_valid &= false;
                    //Ok_Toggle(_is_valid);
                }

            }

        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Repair_bill_detail Repair_bill_detailForm = new Repair_bill_detail())
            {
                Repair_bill_detailForm.Text = "Редактирование -";
                Repair_bill_detailForm._repair_bill_detail_form_state = 2;
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_id = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_full_name = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_repair_type_master_id = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_short_name = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_is_default = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_default.Index].Value.ToString();

                Repair_bill_detailForm.ShowDialog(this);
                if (Repair_bill_detailForm.DialogResult == DialogResult.OK)
                {
                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_full_name != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_full_name;
                    }
                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_repair_type_master_id != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_repair_type_master_id;
                    }
                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_short_name != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_short_name;
                    }

                    if (Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_is_default != "")
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_default.Index].Value
                            = Repair_bill_detailForm.Repair_bill_detail_repair_bill_master_is_default;
                    }

                    //_is_valid = false;
                    //Ok_Toggle(false);
                }
            }
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Repair_bill_detail Repair_bill_detailForm = new Repair_bill_detail())
            {
                Repair_bill_detailForm.Text = "Удаление -";
                Repair_bill_detailForm._repair_bill_detail_form_state = 3;
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_id = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_full_name = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_repair_type_master_id = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_short_name = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
                Repair_bill_detailForm._repair_bill_detail_repair_bill_master_is_default = this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Cells[is_default.Index].Value.ToString();

                Repair_bill_detailForm.ShowDialog(this);
                if (Repair_bill_detailForm.DialogResult == DialogResult.OK)
                {
                    this.uspVRPR_REPAIR_BILL_MASTER_SelectAllBindingSource.RemoveCurrent();
                    //_is_valid = false;
                    //Ok_Toggle(false);
                }
            }
        }

        private void uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                    != this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    //this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой
                if (((this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                     == this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.RowCount)
                    && (this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                        == this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.RowCount)
                    {
                        this.DeleteToolStripMenuItem.Enabled = false;
                        this.EditToolStripMenuItem.Enabled = false;


                    }
                    else
                    {
                        this.DeleteToolStripMenuItem.Enabled = true;
                        this.DeleteToolStripMenuItem.Enabled = true;

                    }
                }


            }
            catch (Exception Appe)
            {
            }
        }

        private void uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                throw e.Exception;
            }
            catch (Exception Appe)
            {
                MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
            }
        }

        private void uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.CurrentRow.Index + 1)
                    != this.uspVRPR_REPAIR_BILL_MASTER_SelectAllDataGridView.RowCount)
                {

                    //this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void button_find_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVRPR_REPAIR_BILL_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_MASTER_SelectAll, p_StrToolStripTextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }
    }
}
