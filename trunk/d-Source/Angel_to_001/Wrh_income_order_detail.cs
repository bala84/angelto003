using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Angel_to_001
{
    public partial class Wrh_income_order_detail : Form
    {
        public string _username;

        private bool _is_valid = true;

        public string _warehouse_income_order_master_id;
        public string _warehouse_income_order_master_number;
        public string _warehouse_income_order_master_date_created;
        public string _warehouse_income_order_master_total;
        public string _warehouse_income_order_master_is_verified;

        //Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
        public byte _warehouse_income_order_detail_form_state;



        public string Warehouse_income_order_master_id
        {
            get { return this.idTextBox.Text; }
        }

        public string Warehouse_income_order_master_number
        {
            get { return this.numberTextBox.Text; }
        }


        public string Warehouse_income_order_master_date_created
        {
            get { return this.date_createdDateTimePicker.Text; }
        }


        public string Warehouse_income_order_master_is_verified
        {
            get { return this.is_verifiedcomboBox.Text; }
        }




        public string Warehouse_order_income_master_total
        {
            get { return this.totalTextBox.Text; }
        }
		

        public Wrh_income_order_detail()
        {
            InitializeComponent();

            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;

        }

        private void uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.EndEdit();
            this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll);

        }

        private void fillToolStripButton_Click(object sender, EventArgs e)
        {
            try
            {
                this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_start_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_end_dateToolStripTextBox.Text, typeof(System.DateTime))))), p_StrToolStripTextBox.Text, new System.Nullable<byte>(((byte)(System.Convert.ChangeType(p_Srch_TypeToolStripTextBox.Text, typeof(byte))))), new System.Nullable<short>(((short)(System.Convert.ChangeType(p_Top_n_by_rankToolStripTextBox.Text, typeof(short))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

        }

        private void uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingNavigatorSaveItem_Click_1(object sender, EventArgs e)
        {
            this.Validate();
            this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.EndEdit();
            this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll);

        }

        private void Wrh_income_order_detail_Load(object sender, EventArgs e)
        {
            this.Text = this.Text + " заявка на закупку";

            this.is_verifiedcomboBox.Text = "Не проверен";


            if ((_warehouse_income_order_master_id != "")
               && (_warehouse_income_order_master_id != null))
            {
                this.idTextBox.Text = _warehouse_income_order_master_id;
                this.p_wrh_income_order_master_idToolStripTextBox.Text = _warehouse_income_order_master_id;
            }

            if ((_warehouse_income_order_master_number != "")
               && (_warehouse_income_order_master_number != null))
            {
                this.numberTextBox.Text = _warehouse_income_order_master_number;
            }

            if ((_warehouse_income_order_master_date_created != "")
                && (_warehouse_income_order_master_date_created != null))
            {
                this.date_createdDateTimePicker.Text = _warehouse_income_order_master_date_created;
            }
            if ((_warehouse_income_order_master_total != "")
                && (_warehouse_income_order_master_total != null))
            {
                this.totalTextBox.Text = _warehouse_income_order_master_total;
            }

            if ((_warehouse_income_order_master_is_verified != "")
                && (_warehouse_income_order_master_is_verified != null))
            {
                this.is_verifiedcomboBox.Text = _warehouse_income_order_master_is_verified;
            }



            if (this.p_wrh_income_order_master_idToolStripTextBox.Text != "")
            {
                try
                {
                    this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Fill(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_wrh_income_order_master_idToolStripTextBox.Text, typeof(decimal))))));
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }
            }

            if (_warehouse_income_order_detail_form_state == 3)
            {
                this.BackColor = Color.Red;
                this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = false;
                this.numberTextBox.Enabled = false;
                this.date_createdDateTimePicker.Enabled = false;
                this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.Enabled = false;
                this.totalTextBox.Enabled = false;
                this.contextMenuStrip1.Enabled = false;
                this.is_verifiedcomboBox.Enabled = false;
                Ok_Toggle(true);
            }
            else
            {
                this.BackColor = System.Drawing.SystemColors.Control;
                this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem.Enabled = true;
                Ok_Toggle(_is_valid);
            }
        }
        void Ok_Toggle(bool v_result)
        {
            if (v_result)
            {
                this.button_ok.Enabled = true;
                this.printToolStripButton.Enabled = true;
            }
            else
            {
                this.button_ok.Enabled = false;
                this.printToolStripButton.Enabled = false;
            }
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount == 1)
            {
                this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource.AddNew();
                this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource.AddNew();
            }

            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.BeginEdit(false);
            if ((this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "good_mark")
                || (this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "good_category_sname")
                || (this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "unit"))
            {
                using (Good_category Good_categoryForm = new Good_category())
                {
                    Good_categoryForm.ShowDialog(this);
                    if (Good_categoryForm.DialogResult == DialogResult.OK)
                    {

                        this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.good_mark.Index].Value
                            = Good_categoryForm.Good_category_good_mark;
                        this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.good_category_sname.Index].Value
                            = Good_categoryForm.Good_category_sname;
                        this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.unit.Index].Value
                            = Good_categoryForm.Good_category_unit;
                        this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.good_category_id.Index].Value
                            = Good_categoryForm.Good_category_id;
                        _is_valid &= false;
                        Ok_Toggle(_is_valid);
                    }
                }
            }

            if (this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentCell.OwningColumn.Name == "state_number")
            {
                using (Car CarForm = new Car())
                {
                    CarForm.ShowDialog(this);
                    if (CarForm.DialogResult == DialogResult.OK)
                    {

                        this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.car_id.Index].Value
                            = CarForm.Car_id;
                        this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Cells[this.state_number.Index].Value
                            = CarForm.Car_state_number;

                        _is_valid &= false;
                        Ok_Toggle(_is_valid);
                    }
                }
            }
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource.RemoveCurrent();
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
                    != this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой
                if (((this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
                     == this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount)
                    && (this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
                        == this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount)
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

        private void uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.CurrentRow.Index + 1)
                    != this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.RowCount)
                {

                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

        //Процедура подготовки детальной таблицы для записи 
        void Prepare_Detail()
        {
            foreach (DataGridViewRow currentRow in this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView.Rows)
            {
               currentRow.Cells[this.wrh_income_order_master_id.Index].Value = this.idTextBox.Text;

            }
        }

        private void uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            Nullable<decimal> v_id = new Nullable<decimal>();

            if ( (this.date_createdDateTimePicker.Text != "")
                && (this.totalTextBox.Text != ""))
            {
                try
                {
                    if (this.idTextBox.Text != "")
                    {
                        v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
                    }

                    this.Validate();
                    this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllBindingSource.EndEdit();
                    this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource.EndEdit();
                    if (this._warehouse_income_order_detail_form_state == 3)
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))), "-", _username);
                    }
                    else
                    {
                        this.uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAllTableAdapter.Update(ref v_id
                                                                                    , this.numberTextBox.Text
                                                                                    , (DateTime)Convert.ChangeType(this.date_createdDateTimePicker.Text, typeof(DateTime))
                                                                                    , (decimal)Convert.ChangeType(this.totalTextBox.Text, typeof(decimal))
                                                                                    , this.is_verifiedcomboBox.Text
                                                                                    , this.sys_commentTextBox.Text
                                                                                    , this.sys_user_modifiedTextBox.Text);
                        this.idTextBox.Text = v_id.ToString();
                        this.Prepare_Detail();
                        this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Update(this.aNGEL_TO_001.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id);
                    }
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                    _is_valid = true;
                    this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdDataGridView_CurrentCellChanged(sender, e);
                }
                catch (SqlException Sqle)
                {

                    switch (Sqle.Number)
                    {
                        case 515:
                            MessageBox.Show("Необходимо заполнить все обязательные поля!");
                            break;

                        case 2601:
                            MessageBox.Show("Такой товар или машина уже указаны в списке");
                            break;

                        default:
                            MessageBox.Show("Ошибка");
                            MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                            MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                            MessageBox.Show("Источник: " + Sqle.Source.ToString());
                            break;
                    }

                    this.Ok_Toggle(false);
                    _is_valid = false;

                }

                catch (Exception Appe)
                {
                    MessageBox.Show(Just.Error_Message_Translate(Appe.Message));
                    this.Ok_Toggle(false);
                    _is_valid = false;
                }
            }
            else
            {
                MessageBox.Show("Проверьте, что вы заполнили поля:  'Дата создания', 'Итог' ");
            }
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            if (_is_valid == false)
            {
                this.uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click(sender, e);
            }
        }

        private void numberTextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void date_createdDateTimePicker_ValueChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void is_verifiedcomboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void totalTextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void printToolStripButton_Click(object sender, EventArgs e)
        {
            using (Wrh_income_order_detail_rep_viewer Wrh_income_order_detail_rep_viewerForm = new Wrh_income_order_detail_rep_viewer())
            {
                
                Wrh_income_order_detail_rep_viewerForm._wrh_income_order_master_id = this.idTextBox.Text;
                Wrh_income_order_detail_rep_viewerForm.ShowDialog(this);
            }
        }


    }
}
