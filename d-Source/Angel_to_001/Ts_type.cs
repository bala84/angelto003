using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;using System.Windows.Forms;
using System.Data.SqlClient;

namespace Angel_to_001
{
    public partial class Ts_type : Form
    {
        public string _username;

        public Ts_type()
        {
            InitializeComponent();
            this.button_ok.DialogResult = DialogResult.OK;
            this.button_cancel.DialogResult = DialogResult.Cancel;
            this.AcceptButton = this.button_ok;
            this.CancelButton = this.button_cancel; 
        }

        public string _where_clause;

        public DataGridViewRow Ts_type_row
        {
            get { return this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow; }
        }

        //Укажем id для интересующей нас колонки
        public string Ts_type_id
        {
            get { return this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }

        //Укажем название для интересующей нас колонки
        public string Ts_type_sname
        {
            get { return this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }

        //Укажем периодичность
        public string Ts_type_periodicity
        {
            get { return this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString(); }
        }

        //Укажем car_mark_id
        public string Ts_type_car_mark_id
        {
            get { return this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString(); }
        }

        //Укажем car_model_id
        public string Ts_type_car_model_id
        {
            get { return this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString(); }
        }

        //Укажем tolerance
        public string Ts_type_car_tolerance
        {
            get { return this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString(); }
        }

        private void utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            try
            {
                this.Validate();
             //   this.utfVCAR_TS_TYPE_MASTERBindingSource.EndEdit();
             //   this.utfVCAR_TS_TYPE_MASTERTableAdapter.Update(this.ANGEL_TO_001_Ts_type_master.utfVCAR_TS_TYPE_MASTER);
                Ok_Toggle(true);
            }
            catch (SqlException Sqle)
            {   //not null sql exception
                switch (Sqle.Number)
                {
                    case 515:
                        MessageBox.Show("Необходимо заполнить все обязательные поля!");
                        break;

                    case 547:
                        MessageBox.Show("Необходимо удалить все данные, которые ссылаются на данную запись! "
                                        + "Проверьте, что у данного автомобиля нет состояния и путевых листов. ");
                        this.utfVCAR_TS_TYPE_MASTERTableAdapter.Fill(this.ANGEL_TO_001_Ts_type_master.utfVCAR_TS_TYPE_MASTER);

                        break;

                    case 2601:
                        MessageBox.Show("Такой 'Вид ТО' уже существует");
                        break;

                    default:
                        MessageBox.Show("Ошибка");
                        MessageBox.Show("Метод: " + Sqle.TargetSite.ToString());
                        MessageBox.Show("Сообщение: " + Sqle.Message.ToString());
                        MessageBox.Show("Источник: " + Sqle.Source.ToString());
                        break;
                }
                Ok_Toggle(false);
            }
            catch (Exception Appe)
            { }
        }

        private void Ts_type_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Ts_type_master.utfVCAR_TS_TYPE_MASTER' table. You can move, or remove it, as needed.
            this.utfVCAR_TS_TYPE_MASTERBindingSource.Filter = this._where_clause;
            
            this.utfVCAR_TS_TYPE_MASTERTableAdapter.Fill(this.ANGEL_TO_001_Ts_type_master.utfVCAR_TS_TYPE_MASTER);

        }

        private void EditToolStripMenuItem_Click(object sender, EventArgs e)
        {

            using (Ts_type_detail Ts_type_detailForm = new Ts_type_detail())
            {
                Ts_type_detailForm.Text = "Редактирование -";
               // MessageBox.Show(Ts_type_detailForm._ts_type_master_child_ts_type_array);
                
                Ts_type_detailForm._ts_type_master_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_short_name = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_periodicity = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_mark_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_mark_model_name = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_model_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_tolerance = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_mark_sname = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_model_sname = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_repair_type_master_kind_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_repair_type_master_kind_sname = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value.ToString();
                //Ts_type_detailForm._ts_type_master_child_ts_type_array = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
                Ts_type_detailForm.ShowDialog(this);
                if (Ts_type_detailForm.DialogResult == DialogResult.OK)
                {
                    if (Ts_type_detailForm.Ts_type_master_short_name != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                        = Ts_type_detailForm.Ts_type_master_short_name;
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                        = Ts_type_detailForm.Ts_type_master_short_name;
                    }

                    if (Ts_type_detailForm.Ts_type_master_periodicity != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                        = Ts_type_detailForm.Ts_type_master_periodicity;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_mark_id != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_mark_id;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_mark_model_name != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_mark_model_name;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_model_id != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_model_id;
                    }

                    if (Ts_type_detailForm.Ts_type_master_tolerance != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                        = Ts_type_detailForm.Ts_type_master_tolerance;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_mark_sname != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_mark_sname;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_model_sname != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_model_sname;
                    }

                    if (Ts_type_detailForm.Ts_type_master_repair_type_master_kind_id != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value
                        = Ts_type_detailForm.Ts_type_master_repair_type_master_kind_id;
                    }

                    if (Ts_type_detailForm.Ts_type_master_repair_type_master_kind_sname != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value
                        = Ts_type_detailForm.Ts_type_master_repair_type_master_kind_sname;
                    }

                    //MessageBox.Show(Ts_type_detailForm.Ts_type_master_child_ts_type_array);
                   // this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
                   //     = Ts_type_detailForm.Ts_type_master_child_ts_type_array;
                    this.utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem_Click(sender, e);
                    this.utfVCAR_TS_TYPE_MASTERTableAdapter.Fill(this.ANGEL_TO_001_Ts_type_master.utfVCAR_TS_TYPE_MASTER);
                }
            }
            
        }

        private void InsertToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Ts_type_detail Ts_type_detailForm = new Ts_type_detail())
            {
                Ts_type_detailForm.Text = "Вставка -";
                //Ts_type_detailForm._ts_type_master_child_ts_type_array = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
                Ts_type_detailForm.ShowDialog(this);
                if (Ts_type_detailForm.DialogResult == DialogResult.OK)
                {
                    if (this.utfVCAR_TS_TYPE_MASTERDataGridView.RowCount == 1)
                    {
                        this.utfVCAR_TS_TYPE_MASTERBindingSource.AddNew();
                        this.utfVCAR_TS_TYPE_MASTERBindingSource.RemoveCurrent();
                    }
                    else
                    {
                        this.utfVCAR_TS_TYPE_MASTERBindingSource.AddNew();
                    }

                    if (Ts_type_detailForm.Ts_type_master_short_name != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value
                        = Ts_type_detailForm.Ts_type_master_short_name;
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn9.Index].Value
                        = Ts_type_detailForm.Ts_type_master_short_name;
                    }

                    if (Ts_type_detailForm.Ts_type_master_periodicity != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value
                        = Ts_type_detailForm.Ts_type_master_periodicity;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_mark_id != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_mark_id;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_mark_model_name != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_mark_model_name;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_model_id != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_model_id;
                    }

                    if (Ts_type_detailForm.Ts_type_master_tolerance != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value
                        = Ts_type_detailForm.Ts_type_master_tolerance;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_mark_sname != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_mark_sname;
                    }

                    if (Ts_type_detailForm.Ts_type_master_car_model_sname!= "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value
                        = Ts_type_detailForm.Ts_type_master_car_model_sname;
                    }

                    if (Ts_type_detailForm.Ts_type_master_repair_type_master_kind_id != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value
                        = Ts_type_detailForm.Ts_type_master_repair_type_master_kind_id;
                    }

                    if (Ts_type_detailForm.Ts_type_master_repair_type_master_kind_sname != "")
                    {
                        this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value
                        = Ts_type_detailForm.Ts_type_master_repair_type_master_kind_sname;
                    }

                    //this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value
                    //    = Ts_type_detailForm.Ts_type_master_child_ts_type_array;
                    
                

                    this.utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem_Click(sender, e);
                    this.utfVCAR_TS_TYPE_MASTERTableAdapter.Fill(this.ANGEL_TO_001_Ts_type_master.utfVCAR_TS_TYPE_MASTER);
                }

            }
        }

        private void DeleteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (Ts_type_detail Ts_type_detailForm = new Ts_type_detail())
            {
                Ts_type_detailForm.Text = "Удаление -";
                Ts_type_detailForm._ts_type_master_form_state = 3;
                Ts_type_detailForm._ts_type_master_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_short_name = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_periodicity = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn10.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_mark_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn11.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_mark_model_name = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn12.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_model_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn13.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_tolerance = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn14.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_mark_sname = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn15.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_car_model_sname = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn16.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_repair_type_master_kind_id = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_id.Index].Value.ToString();
                Ts_type_detailForm._ts_type_master_repair_type_master_kind_sname = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[this.repair_type_master_kind_sname.Index].Value.ToString();
                //Ts_type_detailForm._ts_type_master_child_ts_type_array = this.utfVCAR_TS_TYPE_MASTERDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn17.Index].Value.ToString();
                Ts_type_detailForm.ShowDialog(this);
                if (Ts_type_detailForm.DialogResult == DialogResult.OK)
                {
                    this.utfVCAR_TS_TYPE_MASTERBindingSource.RemoveCurrent();
                    this.utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem_Click(sender, e);
                    this.utfVCAR_TS_TYPE_MASTERTableAdapter.Fill(this.ANGEL_TO_001_Ts_type_master.utfVCAR_TS_TYPE_MASTER);
                }
            }
        }

        private void utfVCAR_TS_TYPE_MASTERDataGridView_CurrentCellChanged(object sender, EventArgs e)
        {
        }

        private void button_ok_Click(object sender, EventArgs e)
        {
            this.utfVCAR_TS_TYPE_MASTERBindingNavigatorSaveItem_Click(sender, e);
        }

        private void utfVCAR_TS_TYPE_MASTERDataGridView_DataError(object sender, DataGridViewDataErrorEventArgs e)
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


        private void Ok_Toggle(bool v_result)
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
    }
}
