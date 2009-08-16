using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Angel_to_001
{
    public partial class Car_type_chooser : Form
    {
        public Car_type_chooser()
        {
            InitializeComponent();
        }
        public string Car_type_id
        {
          get { return this.utfVCAR_CAR_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }

        public string Car_type_short_name
        {
            get { return this.utfVCAR_CAR_TYPEDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }

        private void utfVCAR_CAR_TYPEBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.utfVCAR_CAR_TYPEBindingSource.EndEdit();
            this.utfVCAR_CAR_TYPETableAdapter.Update(this.aNGEL_TO_001_Car_type.utfVCAR_CAR_TYPE);

        }

        private void Car_type_chooser_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Car_type.utfVCAR_CAR_TYPE' table. You can move, or remove it, as needed.
            this.utfVCAR_CAR_TYPETableAdapter.Fill(this.aNGEL_TO_001_Car_type.utfVCAR_CAR_TYPE);

        }
    }
}
