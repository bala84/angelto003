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
    public partial class Driver_plan_detail : Form
    {

        private bool _is_valid = true;
        public string _username;


        public Driver_plan_detail()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }



        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                p_dateToolStripTextBox.Text = this.dateTimePicker1.Value.ToShortDateString();

                try
                {
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal))))));
                }
                catch { }
            }
            catch { }

            if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount != 1)
            {
                this.fill_prevtoolStripButton.Enabled = false;
            }
            else
            {
                this.fill_prevtoolStripButton.Enabled = true;
            }

        }

        private void button_car_kind_Click(object sender, EventArgs e)
        {
            using (Car_kind_chooser Car_kind_chooserForm = new Car_kind_chooser())
            {
                Car_kind_chooserForm.ShowDialog(this);
                if (Car_kind_chooserForm.DialogResult == DialogResult.OK)
                {
                    this.car_kindtextBox.Text = Car_kind_chooserForm.Car_kind_short_name;
                    this.car_kind_idtextBox.Text = Car_kind_chooserForm.Car_kind_id;
                    this.utfVCAR_CARBindingSource.Filter = "car_kind_id=" + this.car_kind_idtextBox.Text
                                                                 + " and organization_id=" + this.organization_idtextBox.Text;
                    p_car_kind_idToolStripTextBox.Text = this.car_kind_idtextBox.Text;

                    p_dateToolStripTextBox.Text = this.dateTimePicker1.Value.ToShortDateString();

                    this.utfVCAR_CARTableAdapter.Fill(this.ANGEL_TO_001_Car.utfVCAR_CAR
                      , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                      , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                      , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                      , new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))));


                    try
                    {
                        this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal))))));
                    }
                    catch { }

                    if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount != 1)
                    {
                        this.fill_prevtoolStripButton.Enabled = false;
                    }
                    else
                    {
                        this.fill_prevtoolStripButton.Enabled = true;
                    }

                }
            }
        }

        private void Driver_plan_detail_Load(object sender, EventArgs e)
        {
            this.car_kindtextBox.Text = Const.Evacuator_sname;
            this.car_kind_idtextBox.Text = Const.Evacuator.ToString();
            this.organizationtextBox.Text = Const.Organization_l1_name;
            this.organization_idtextBox.Text = Const.Organization_l1_id.ToString();
            p_car_kind_idToolStripTextBox.Text = this.car_kind_idtextBox.Text;
            p_dateToolStripTextBox.Text = this.dateTimePicker1.Value.ToShortDateString();
            p_organization_idToolStripTextBox.Text = this.organization_idtextBox.Text;

            p_searchtextBox.Text = DBNull.Value.ToString();
            p_search_typetextBox.Text = Const.Pt_search.ToString();
            p_Top_n_by_RanktextBox.Text = Const.Top_n_by_rank.ToString();

            this.utfVPRT_EMPLOYEEBindingSource1.Filter = "employee_type_id=" + Const.Emp_type_mech_id.ToString()
                                            + " or employee_type_id=" + Const.Emp_type_mech_manager_id.ToString();

            this.utfVCAR_CARBindingSource.Filter = "car_kind_id=" + Const.Evacuator.ToString()
                                                  + " and organization_id=" + Const.Organization_l1_id.ToString();



            this.utfVPRT_EMPLOYEETableAdapter.Fill(this.aNGEL_TO_001_Employee.utfVPRT_EMPLOYEE, ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                                   , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                                   , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                                    , new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))));

            this.utfVCAR_CARTableAdapter.Fill(this.ANGEL_TO_001_Car.utfVCAR_CAR
                                  , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                                  , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                                  , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                                    , new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))));

            
            try
            {
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal))))));
            }
            catch { }


            if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount != 1)
            {
                this.fill_prevtoolStripButton.Enabled = false;
            }
            else
            {
                this.fill_prevtoolStripButton.Enabled = true;
            }
			

        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            ComboBox c = e.Control as ComboBox;
            if (c != null)
            {
                c.DropDownStyle = ComboBoxStyle.DropDown;
                c.AutoCompleteMode = AutoCompleteMode.Suggest;
                c.AutoCompleteSource = AutoCompleteSource.ListItems;
            }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            /*if (e.ColumnIndex == this.time.Index)
            {
                object eFV = e.FormattedValue;
                if (!this.time.Items.Contains(eFV))
                {
                    this.time.Items.Add(eFV);
                }
            }*/
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
           // MessageBox.Show(this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount.ToString());
            //if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount != 1)
           // {
                //Если только одна строка - то почему то вставляет две
                if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount == 1)
                {
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.AddNew();
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.RemoveCurrent();
                }
                else
                {
                    
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.AddNew();
                    
                }

                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.date.Index].Value
                    = this.dateTimePicker1.Value.ToShortDateString();
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.rownum.Index].Value
                    = this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount - 1;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.organization_id.Index].Value
                    = this.organization_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.organization_sname.Index].Value
                    = this.organizationtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.car_kind_id.Index].Value
                    = this.car_kind_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.car_kind_sname.Index].Value
                    = this.car_kindtextBox.Text;

         //   }
        
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Dialog DialogForm = new Dialog())
            {
                DialogForm._dialog_form_state = 2;
                DialogForm._dialog_label = "Вы уверены, что хотите удалить запись?";
                DialogForm.ShowDialog(this);
                if (DialogForm.DialogResult == DialogResult.OK)
                {
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.RemoveCurrent();
                    Check_nums();
                   // this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingNavigatorSaveItem_Click_1(sender, e);
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
                this.printToolStripButton.Enabled = true;
            }
            else
            {
                this.button_ok.Enabled = false;
                this.printToolStripButton.Enabled = false;
            }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1)
                         != this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount)
                {
                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
            try
            {
                throw e.Exception;
            }
            catch (Exception Appe)
            {
                switch (Appe.Message)
                {
                    case "Input string was not in a correct format.":
                        MessageBox.Show("Неверный формат числа, укажите запятую вместо точки");
                        break;

                    case "DataGridViewComboBoxCell value is not valid.":
                       // MessageBox.Show("Нельзя указывать несуществующего в списках водителя, автомобиль или время");
                        break;

                    default:
                        MessageBox.Show(Appe.Message);
                        break;
                }
            }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.sys_user_modified.Index].Value
                = this._username;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.date.Index].Value
                = this.dateTimePicker1.Value.ToShortDateString();
                if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount == 1)
                {
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.rownum.Index].Value
                    = this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount;
                }
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.organization_id.Index].Value
                    = this.organization_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.organization_sname.Index].Value
                    = this.organizationtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.car_kind_id.Index].Value
                    = this.car_kind_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Cells[this.car_kind_sname.Index].Value
                    = this.car_kindtextBox.Text;
            }
            catch { }

            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1)
                        != this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                //Уберем лишние пункты контекстного меню при работе с "пустой" строкой 
                if (((this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1)
                    == this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount)
                    && (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount != 1))
                {
                    this.contextMenuStrip1.Enabled = false;
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.ReadOnly = true;
                }
                else
                {
                    this.contextMenuStrip1.Enabled = true;
                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.ReadOnly = false;
                    if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.SelectedCells.Count > 0)
                    {
                        this.insertat_aboveToolStripMenuItem.Enabled = true;
                        this.clear_cellToolStripMenuItem.Enabled = true;
                        this.clear_rowToolStripMenuItem.Enabled = true;
                    }
                    else
                    {
                        this.insertat_aboveToolStripMenuItem.Enabled = false;
                        this.clear_cellToolStripMenuItem.Enabled = false;
                        this.clear_rowToolStripMenuItem.Enabled = false;
                    }
                }

                if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount != 1)
                {
                    this.fill_prevtoolStripButton.Enabled = false;
                }
                else
                {
                    this.fill_prevtoolStripButton.Enabled = true;
                }


            }
            catch (Exception Appe)
            {
            }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingNavigatorSaveItem_Click_1(object sender, EventArgs e)
        {

            try
            {

                this.Validate();
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.EndEdit();
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Update(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate);
                //_is_valid &= this.Check_Items();
                this.Ok_Toggle(true);
                _is_valid = true;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_CurrentCellChanged(sender, e);

            }
            catch (SqlException Sqle)
            {

                switch (Sqle.Number)
                {
                    case 515:
                        MessageBox.Show("Необходимо заполнить все обязательные поля!");
                        break;


                    case 2601:
                        MessageBox.Show("Указано более одной и той же машины с тем же временем выхода");
                        break;



                    case 241:
                        MessageBox.Show("Нельзя указывать несуществующего в списках водителя, автомобиль или время");
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
                this.Ok_Toggle(false);
                _is_valid = false;
            }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_RowLeave(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void printToolStripButton_Click(object sender, EventArgs e)
        {
            using (Driver_plan_detail_rep_viewer Driver_plan_detail_rep_viewerForm = new Driver_plan_detail_rep_viewer())
            {
                Driver_plan_detail_rep_viewerForm._driver_plan_detail_date = this.dateTimePicker1.Value.ToShortDateString();
                Driver_plan_detail_rep_viewerForm._driver_plan_car_kind_id = this.car_kind_idtextBox.Text;
                Driver_plan_detail_rep_viewerForm._driver_plan_organization_id = this.organization_idtextBox.Text;
                Driver_plan_detail_rep_viewerForm.ShowDialog(this);
            }

        }

        private void organization_button_Click(object sender, EventArgs e)
        {
            using (Organization OrganizationForm = new Organization())
            {
                OrganizationForm.ShowDialog(this);
                if (OrganizationForm.DialogResult == DialogResult.OK)
                {
                    this.organizationtextBox.Text = OrganizationForm.Org_sname;
                    this.organization_idtextBox.Text = OrganizationForm.Org_id;
                    this.utfVCAR_CARBindingSource.Filter = "car_kind_id=" + this.car_kind_idtextBox.Text
                                                            + " and organization_id=" + this.organization_idtextBox.Text;
                    this.p_organization_idToolStripTextBox.Text = this.organization_idtextBox.Text;


                    this.utfVCAR_CARTableAdapter.Fill(this.ANGEL_TO_001_Car.utfVCAR_CAR
                      , ((String)(System.Convert.ChangeType(this.p_searchtextBox.Text, typeof(String))))
                      , new Nullable<Byte>(((Byte)(System.Convert.ChangeType(this.p_search_typetextBox.Text, typeof(Byte)))))
                      , new Nullable<short>(((short)(System.Convert.ChangeType(this.p_Top_n_by_RanktextBox.Text, typeof(short)))))
                      , new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))));


                    try
                    {
                        this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal))))));
                    }
                    catch { }

                    if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount != 1)
                    {
                        this.fill_prevtoolStripButton.Enabled = false;
                    }
                    else
                    {
                        this.fill_prevtoolStripButton.Enabled = true;
                    }

                }
            }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if ((this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1)
                 != this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount)
            {
                if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentCell.OwningColumn.Name == "del_button")
                {

                        this.DeleteToolStripMenuItem_Click(sender, e);
                }
            }
        }

        //Проверим, что у нас порядок записей соблюден - и обязатальные поля введены
        void Check_nums()
        {

            foreach (DataGridViewRow currentRow in this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows)
            {
                try
                {
                    if ((currentRow.Index + 1) != this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.RowCount)
                    {
                        currentRow.Cells[this.rownum.Index].Value
                             = currentRow.Index + 1;
                        if (currentRow.Cells[this.date.Index].Value.ToString() == "")
                        {
                            currentRow.Cells[this.date.Index].Value
                                = this.dateTimePicker1.Value.ToShortDateString();
                        }
                        if (currentRow.Cells[this.organization_id.Index].Value.ToString() == "")
                        {
                            currentRow.Cells[this.organization_id.Index].Value
                                = this.organization_idtextBox.Text;
                        }
                        if (currentRow.Cells[this.organization_sname.Index].Value.ToString() == "")
                        {
                            currentRow.Cells[this.organization_sname.Index].Value
                                = this.organizationtextBox.Text;
                        }

                        if (currentRow.Cells[this.car_kind_id.Index].Value.ToString() == "")
                        {
                            currentRow.Cells[this.car_kind_id.Index].Value
                                = this.car_kind_idtextBox.Text;
                        }

                        if (currentRow.Cells[this.car_kind_sname.Index].Value.ToString() == "")
                        {
                            currentRow.Cells[this.car_kind_sname.Index].Value
                                = this.car_kindtextBox.Text;
                        }
                    }
                        

                }
                catch { }
            }
        }

        private void fill_prevtoolStripButton_Click(object sender, EventArgs e)
        {
            using (Date_chooser Date_chooserForm = new Date_chooser())
            {
                Date_chooserForm._date_chooser_format_type = "Custom";
                Date_chooserForm._date_chooser_format = "dd.MM.yyyy";
                Date_chooserForm.ShowDialog(this);
                if (Date_chooserForm.DialogResult == DialogResult.OK)
                {
                 Just.Insert_new_driver_plan_detail_by_prev( (System.DateTime)(System.Convert.ChangeType(Date_chooserForm.Short_date_value, typeof(System.DateTime)))
                                                           , (System.DateTime)(System.Convert.ChangeType(this.p_dateToolStripTextBox.Text, typeof(System.DateTime)))
                                                           ,(decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal)))
                                                           ,(decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))));

                 this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal))))));
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
                }
            }
        }

        private void delete_allToolStripButton_Click(object sender, EventArgs e)
        {
            
                using (Dialog DialogForm = new Dialog())
                {
                    DialogForm._dialog_form_state = 2;
                    DialogForm._dialog_label = "Вы уверены, что хотите удалить все данные по этому плану?";
                    DialogForm.ShowDialog(this);

                    if (DialogForm.DialogResult == DialogResult.OK)
                    {
                       Just.Delete_driver_plan_by_date((System.DateTime)(System.Convert.ChangeType(this.p_dateToolStripTextBox.Text, typeof(System.DateTime)))
                                                           ,(decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal)))
                                                           ,(decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))));

                       this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Fill(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(p_dateToolStripTextBox.Text, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(p_car_kind_idToolStripTextBox.Text, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(this.p_organization_idToolStripTextBox.Text, typeof(decimal))))));

                    }
                }


            
        }

        private void insertat_aboveToolStripMenuItem_Click(object sender, EventArgs e)
        {
           // if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.SelectedCells.Count > 0)
         //   {
                this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate.Rows.InsertAt(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate.NewRow(), this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index);
                Check_nums();
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index - 1].Cells[this.sys_user_modified.Index].Value
                    = this._username;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index - 1].Cells[this.date.Index].Value
                    = this.dateTimePicker1.Value.ToShortDateString();
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index - 1].Cells[this.organization_id.Index].Value
                    = this.organization_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index - 1].Cells[this.organization_sname.Index].Value
                    = this.organizationtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index - 1].Cells[this.car_kind_id.Index].Value
                    = this.car_kind_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index - 1].Cells[this.car_kind_sname.Index].Value
                    = this.car_kindtextBox.Text;
                _is_valid &= false;
                Ok_Toggle(_is_valid);
           // }
        }

        private void clear_cellToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentCell.Value = DBNull.Value;
            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void clear_rowToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Dialog DialogForm = new Dialog())
            {
                DialogForm._dialog_form_state = 2;
                DialogForm._dialog_label = "Вы уверены, что хотите очистить запись?";
                DialogForm.ShowDialog(this);
                if (DialogForm.DialogResult == DialogResult.OK)
                {

                    this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.RemoveCurrent();
                    this.insert_belowToolStripMenuItem_Click(sender, e);
                    _is_valid &= false;
                    Ok_Toggle(_is_valid);
                }
            }
        }

        private void insert_belowToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.SelectedCells.Count > 0)
            {
                this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate.Rows.InsertAt(this.aNGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate.NewRow(), this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1);
                Check_nums();
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1].Cells[this.sys_user_modified.Index].Value
                    = this._username;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1].Cells[this.date.Index].Value
                    = this.dateTimePicker1.Value.ToShortDateString();
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1].Cells[this.organization_id.Index].Value
                    = this.organization_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1].Cells[this.organization_sname.Index].Value
                    = this.organizationtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1].Cells[this.car_kind_id.Index].Value
                    = this.car_kind_idtextBox.Text;
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.Rows[this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.CurrentRow.Index + 1].Cells[this.car_kind_sname.Index].Value
                    = this.car_kindtextBox.Text;
                _is_valid &= false;
                Ok_Toggle(_is_valid);
            }
        }

        private void uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView_CellLeave(object sender, DataGridViewCellEventArgs e)
        {
            if (this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.EditingControl is DataGridViewComboBoxEditingControl)
            {
                this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateDataGridView.EditingPanel.Select();
            }
        }

    }
}
