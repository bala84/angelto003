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
    public partial class Wrh_income_order_detail_rep_viewer : Form
    {
        public string _wrh_income_order_master_id;

        public Wrh_income_order_detail_rep_viewer()
        {
            InitializeComponent();
        }

        private void Wrh_income_order_detail_rep_viewer_Load(object sender, EventArgs e)
        {
            this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter.Fill(ANGEL_TO_001.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id, new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(_wrh_income_order_master_id, typeof(decimal))))));
            this.reportViewer1.RefreshReport();
        }
    }
}
