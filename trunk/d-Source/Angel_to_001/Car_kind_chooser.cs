using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Angel_to_001
{
    public partial class Car_kind_chooser : Form
    {
        public Car_kind_chooser()
        {
            InitializeComponent();
        }

        public string Car_kind_id
        {
            get { return this.utfVCAR_CAR_KINDDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn1.Index].Value.ToString(); }
        }

        public string Car_kind_short_name
        {
            get { return this.utfVCAR_CAR_KINDDataGridView.CurrentRow.Cells[dataGridViewTextBoxColumn8.Index].Value.ToString(); }
        }

        private void Car_kind_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Car_kind.utfVCAR_CAR_KIND' table. You can move, or remove it, as needed.
            this.utfVCAR_CAR_KINDTableAdapter.Fill(this.aNGEL_TO_001_Car_kind.utfVCAR_CAR_KIND);

        }
    }
}
