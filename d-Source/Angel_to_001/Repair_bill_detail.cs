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
    

    public partial class Repair_bill_detail : Form
    {
        public string _username;
        private bool _is_valid = true;
        public string _repair_bill_detail_repair_bill_master_id;
        public string _repair_bill_detail_repair_bill_master_full_name;
        public string _repair_bill_detail_repair_bill_master_short_name;
        public string _repair_bill_detail_repair_bill_master_repair_type_master_id;
        public string _repair_bill_detail_repair_bill_master_is_default;

        //Состояние формы: 1 - Вставка 2 - Редактирование 3 - Удаление
        public byte _repair_bill_detail_form_state;

        public string Repair_bill_detail_repair_bill_master_id
        {
            get { return this.idTextBox.Text; }
        }

        public string Repair_bill_detail_repair_bill_master_full_name
        {
            get { return this.full_nameTextBox.Text; }
        }

        public string Repair_bill_detail_repair_bill_master_short_name
        {
            get { return this.short_nameTextBox.Text; }
        }

        public string Repair_bill_detail_repair_bill_master_repair_type_master_id
        {
            get { return this.repair_type_master_idTextBox.Text; }
        }

        public string Repair_bill_detail_repair_bill_master_is_default
        {
            get  {
                if (this.is_defaultcheckBox.Checked == true)
                {
                    return "Да";
                }
                else
                {
                    return "Нет";
                }
            }
        }

        public Repair_bill_detail()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.EndEdit();
            this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idTableAdapter.Update(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id);

        }




        private void button_repair_type_master_Click(object sender, EventArgs e)
        {
            using (Repair_type_master Repair_type_masterForm = new Repair_type_master())
            {
                Repair_type_masterForm.ShowDialog(this);
                if (Repair_type_masterForm.DialogResult == DialogResult.OK)
                {

                    this.repair_type_master_idTextBox.Text
                        = Repair_type_masterForm.Repair_type_master_id;
                    this.short_nameTextBox.Text
                        = Repair_type_masterForm.Repair_type_master_sname;
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
                }
            }
        }

        void Ok_Toggle(bool v_result)
        {
            if (v_result)
            {
                this.button_ok.Enabled = true;
            }
            else
            {
                this.button_ok.Enabled = false;
            }
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {

            if (this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.RowCount == 1)
            {
                this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.AddNew();
                this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.RemoveCurrent();
            }
            else
            {
                this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.AddNew();
            }

			_is_valid &= false;
			Ok_Toggle(_is_valid);
        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
			{
				this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.BeginEdit(false);
                if ((this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn11")
                    || (this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn12")
                    || (this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentCell.OwningColumn.Name == "dataGridViewTextBoxColumn13"))
				{
					using (Good_category Good_categoryForm = new Good_category())
					{
						Good_categoryForm.ShowDialog(this);
						if (Good_categoryForm.DialogResult == DialogResult.OK)
						{

                            this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
								= Good_categoryForm.Good_category_good_mark;
                            this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
								= Good_categoryForm.Good_category_sname;
                            this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
								= Good_categoryForm.Good_category_unit;
                            this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
								= Good_categoryForm.Good_category_id;
							_is_valid &= false;
							Ok_Toggle(_is_valid);
						}
					}
				}

				
			}
			catch (Exception Appe)
			{}
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.RemoveCurrent();
			_is_valid &= false;
			Ok_Toggle(_is_valid);
        }

        private void pasteToolStripMenuItem_Click(object sender, EventArgs e)
        {
        
        }

        private void copyToolStripMenuItem_Click(object sender, EventArgs e)
        {
        
        }

        private void full_nameTextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void short_nameTextBox_TextChanged(object sender, EventArgs e)
        {
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_IdBindingNavigatorSaveItem_Click_1(object sender, EventArgs e)
        {
            Nullable<decimal> v_id = new Nullable<decimal>();
            string v_is_default = "";
            if ((this.full_nameTextBox.Text != "")
                && (this.short_nameTextBox.Text != "")
                 )
            {
                try
                {
                  //  MessageBox.Show(this.is_defaultcheckBox.Checked.ToString());

                    if (this.idTextBox.Text != "")
                    {
                        v_id = (decimal)Convert.ChangeType(this.idTextBox.Text, typeof(decimal));
                    }

                    this.Validate();
                    this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idBindingSource.EndEdit();
                    this.uspVRPR_REPAIR_BILL_MASTER_SelectAllBindingSource.EndEdit();
                    if (this._repair_bill_detail_form_state == 3)
                    {
                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllTableAdapter.Delete(new System.Nullable<decimal>((decimal)Convert.ChangeType(v_id, typeof(decimal))), "-", _username);
                    }
                    else
                    {
                        if (this.is_defaultcheckBox.Checked == true)
                        {
                            v_is_default = "Да";
                        }
                        else
                        {
                            v_is_default = "Нет";
                        }




                        this.uspVRPR_REPAIR_BILL_MASTER_SelectAllTableAdapter.Update(ref v_id
                                                                                    , this.full_nameTextBox.Text
                                                                                    , new System.Nullable<decimal>((decimal)Convert.ChangeType(this.repair_type_master_idTextBox.Text, typeof(decimal)))
                                                                                    , v_is_default
                                                                                    , this.sys_commentTextBox.Text
                                                                                    , this.sys_user_modifiedTextBox.Text);
                    }
                    if (this._repair_bill_detail_form_state != 3)
                    {
                        this.idTextBox.Text = v_id.ToString();
                        this.p_repair_bill_master_idToolStripTextBox.Text = v_id.ToString();
                        Just.Prepare_Detail(dataGridViewTextBoxColumn9.Index, this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.Rows, this.p_repair_bill_master_idToolStripTextBox.Text);
                        this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idTableAdapter.Update(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id);
                    }
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(true);
                    _is_valid = true;
                }
                catch (SqlException Sqle)
                {

                    switch (Sqle.Number)
                    {
                        case 515:
                            MessageBox.Show("Необходимо заполнить все обязательные поля!");
                            break;

                        case 547:
                            MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись!");
                            break;

                        case 2601:
                            MessageBox.Show("Такой 'Список' или 'Товар', указанный в этом требовании, уже существуют");
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
                MessageBox.Show("Проверьте, что Вы заполнили поля: 'Название', 'Вид ремонта'");
            }
        }

        private void Repair_bill_detail_Load(object sender, EventArgs e)
        {
            this.Text = this.Text + " список используемых товаров";
            if (_repair_bill_detail_repair_bill_master_id != "")
            {
                this.idTextBox.Text = _repair_bill_detail_repair_bill_master_id;
                this.p_repair_bill_master_idToolStripTextBox.Text = _repair_bill_detail_repair_bill_master_id;
            }

            if (_repair_bill_detail_repair_bill_master_full_name != "")
            {
                this.full_nameTextBox.Text = _repair_bill_detail_repair_bill_master_full_name;
            }

            if (_repair_bill_detail_repair_bill_master_short_name != "")
            {
                this.short_nameTextBox.Text = _repair_bill_detail_repair_bill_master_short_name;
            }
            if (_repair_bill_detail_repair_bill_master_repair_type_master_id != "")
            {
                this.repair_type_master_idTextBox.Text = _repair_bill_detail_repair_bill_master_repair_type_master_id;
            }

            if (_repair_bill_detail_repair_bill_master_is_default != "")
            {
                if (this._repair_bill_detail_repair_bill_master_is_default == "Да")
                {
                    this.is_defaultcheckBox.Checked = true;
                }
                else
                {
                    this.is_defaultcheckBox.Checked = false;
                }
             }

            if (this._repair_bill_detail_form_state == 3)
            {
                this.button_repair_type_master.Enabled = false;
                this.full_nameTextBox.Enabled = false;
                this.BackColor = Color.Red;
                this.Ok_Toggle(true);
            }
            if (this.p_repair_bill_master_idToolStripTextBox.Text != "")
            {
                try
                {
                    this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_repair_bill_master_idToolStripTextBox.Text, typeof(decimal))))));
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }
            }
        }

        private void uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Index + 1)
                    != this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    //this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой
                if (((this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Index + 1)
                     == this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.RowCount)
                    && (this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    //Все же выключим лишние пункты меню при работе с пустой строкой
                    if ((this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Index + 1)
                        == this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.RowCount)
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

        private void uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

        private void uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.CurrentRow.Index + 1)
                    != this.uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_idDataGridView.RowCount)
                {

                    //this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }


    }
}
