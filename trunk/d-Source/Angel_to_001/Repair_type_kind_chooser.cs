using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Angel_to_001
{
    public partial class Repair_type_kind_chooser : Form
    {

        public string _username;

        public string _where_clause;

        public Repair_type_kind_chooser()
        {
            InitializeComponent();
        }
        public string Repair_type_kind_id
        {
          get { return this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.CurrentRow.Cells[id.Index].Value.ToString(); }
        }

        public string Repair_type_kind_short_name
        {
            get { return this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllDataGridView.CurrentRow.Cells[short_name.Index].Value.ToString(); }
        }

        private void Repair_type_kind_chooser_Load(object sender, EventArgs e)
        {
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllBindingSource.Filter = this._where_clause;
            // TODO: This line of code loads data into the 'aNGEL_TO_001_Car_type.utfVCAR_CAR_TYPE' table. You can move, or remove it, as needed.
            this.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAllTableAdapter.Fill(this.aNGEL_TO_001.uspVRPR_REPAIR_TYPE_MASTER_KIND_SelectAll);

        }


    }
}
