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
    public partial class Options : Form
    {

        public string _username;

        private bool _is_valid = true;


        public Options()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel;
        }

        private void uspVSYS_CONST_SelectBySubsystemBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.uspVSYS_CONST_SelectBySubsystemBindingSource.EndEdit();
            this.uspVSYS_CONST_SelectBySubsystemTableAdapter.Update(this.aNGEL_TO_001.uspVSYS_CONST_SelectBySubsystem);

        }

        private void treeView1_DoubleClick(object sender, EventArgs e)
        {
            if (this.treeView1.SelectedNode.Name == "General_options")
            {
                this.p_subsystemToolStripTextBox.Text = "general";
                this.uspVSYS_CONST_SelectBySubsystemTableAdapter.Fill(this.aNGEL_TO_001.uspVSYS_CONST_SelectBySubsystem, p_subsystemToolStripTextBox.Text);
            }
        }

        private void Options_Load(object sender, EventArgs e)
        {
            this.p_subsystemToolStripTextBox.Text = "general";
            this.uspVSYS_CONST_SelectBySubsystemTableAdapter.Fill(this.aNGEL_TO_001.uspVSYS_CONST_SelectBySubsystem, p_subsystemToolStripTextBox.Text);
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

        private void uspVSYS_CONST_SelectBySubsystemDataGridView_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if ((this.uspVSYS_CONST_SelectBySubsystemDataGridView.CurrentRow.Index + 1)
                         != this.uspVSYS_CONST_SelectBySubsystemDataGridView.RowCount)
                {
                    this.Ok_Toggle(_is_valid);
                }
            }
            catch { }
        }

        private void uspVSYS_CONST_SelectBySubsystemDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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

                    default:
                        MessageBox.Show(Appe.Message);
                        break;
                }
            }
        }

        private void uspVSYS_CONST_SelectBySubsystemDataGridView_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                this.uspVSYS_CONST_SelectBySubsystemDataGridView.CurrentRow.Cells[this.sys_user_modified.Index].Value
                = this._username;
            }
            catch { }

            _is_valid &= false;
            Ok_Toggle(_is_valid);
        }

        private void uspVSYS_CONST_SelectBySubsystemDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
            try
            {
                //Если это не последняя строка, то проверим содержимое
                if ((this.uspVSYS_CONST_SelectBySubsystemDataGridView.CurrentRow.Index + 1)
                        != this.uspVSYS_CONST_SelectBySubsystemDataGridView.RowCount)
                {
                    //_is_valid &= this.Check_Items();
                    this.Ok_Toggle(_is_valid);
                }
                


            }
            catch (Exception Appe)
            {
            }
        }

        private void uspVWRH_GOOD_CATEGORY_SelectAllBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {

                this.Validate();
                this.uspVSYS_CONST_SelectBySubsystemBindingSource.EndEdit();
                this.uspVSYS_CONST_SelectBySubsystemTableAdapter.Update(this.aNGEL_TO_001.uspVSYS_CONST_SelectBySubsystem);
                //_is_valid &= this.Check_Items();
                this.Ok_Toggle(true);
                _is_valid = true;
                this.uspVSYS_CONST_SelectBySubsystemDataGridView_CurrentCellChanged(sender, e);

            }
            catch (SqlException Sqle)
            {

                switch (Sqle.Number)
                {
                    case 515:
                        MessageBox.Show("Необходимо заполнить все обязательные поля!");
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
    }
}
