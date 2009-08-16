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
    public partial class Driver_plan_detail_rep_viewer : Form
    {

        public string _driver_plan_detail_date;
        public string _driver_plan_car_kind_id;
        public string _driver_plan_organization_id;
        public Driver_plan_detail_rep_viewer()
        {
            InitializeComponent();
        }

        private void Driver_plan_detail_rep_viewer_Load(object sender, EventArgs e)
        {

            this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.Fill(this.ANGEL_TO_001.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate, new System.Nullable<System.DateTime>(((System.DateTime)(System.Convert.ChangeType(_driver_plan_detail_date, typeof(System.DateTime))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(_driver_plan_car_kind_id, typeof(decimal))))), new System.Nullable<decimal>(((decimal)(System.Convert.ChangeType(_driver_plan_organization_id, typeof(decimal))))));

            this.reportViewer1.RefreshReport();
        }
    }
}
