namespace Angel_to_001
{
    partial class Wrh_income_order_detail_rep_viewer
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            Microsoft.Reporting.WinForms.ReportDataSource reportDataSource1 = new Microsoft.Reporting.WinForms.ReportDataSource();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Wrh_income_order_detail_rep_viewer));
            this.reportViewer1 = new Microsoft.Reporting.WinForms.ReportViewer();
            this.ANGEL_TO_001 = new Angel_to_001.ANGEL_TO_001();
            this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter = new Angel_to_001.ANGEL_TO_001TableAdapters.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter();
            ((System.ComponentModel.ISupportInitialize)(this.ANGEL_TO_001)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // reportViewer1
            // 
            this.reportViewer1.Dock = System.Windows.Forms.DockStyle.Fill;
            reportDataSource1.Name = "ANGEL_TO_001_uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id";
            reportDataSource1.Value = this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource;
            this.reportViewer1.LocalReport.DataSources.Add(reportDataSource1);
            this.reportViewer1.LocalReport.ReportEmbeddedResource = "Angel_to_001.Wrh_income_order_detail2.rdlc";
            this.reportViewer1.Location = new System.Drawing.Point(0, 0);
            this.reportViewer1.Name = "reportViewer1";
            this.reportViewer1.ShowBackButton = false;
            this.reportViewer1.ShowDocumentMapButton = false;
            this.reportViewer1.ShowFindControls = false;
            this.reportViewer1.ShowPageNavigationControls = false;
            this.reportViewer1.ShowPromptAreaButton = false;
            this.reportViewer1.ShowStopButton = false;
            this.reportViewer1.Size = new System.Drawing.Size(630, 515);
            this.reportViewer1.TabIndex = 0;
            // 
            // ANGEL_TO_001
            // 
            this.ANGEL_TO_001.DataSetName = "ANGEL_TO_001";
            this.ANGEL_TO_001.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource
            // 
            this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource.DataMember = "uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id";
            this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource.DataSource = this.ANGEL_TO_001;
            // 
            // uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter
            // 
            this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter.ClearBeforeFill = true;
            // 
            // Wrh_income_order_detail_rep_viewer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(630, 515);
            this.Controls.Add(this.reportViewer1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Wrh_income_order_detail_rep_viewer";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Заявка на закупку запчастей";
            this.Load += new System.EventHandler(this.Wrh_income_order_detail_rep_viewer_Load);
            ((System.ComponentModel.ISupportInitialize)(this.ANGEL_TO_001)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Microsoft.Reporting.WinForms.ReportViewer reportViewer1;
        private System.Windows.Forms.BindingSource uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdBindingSource;
        private ANGEL_TO_001 ANGEL_TO_001;
        private Angel_to_001.ANGEL_TO_001TableAdapters.uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_IdTableAdapter;
    }
}