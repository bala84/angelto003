namespace Angel_to_001
{
    partial class Driver_plan_detail_rep_viewer
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Driver_plan_detail_rep_viewer));
            this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.ANGEL_TO_001 = new Angel_to_001.ANGEL_TO_001();
            this.reportViewer1 = new Microsoft.Reporting.WinForms.ReportViewer();
            this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter = new Angel_to_001.ANGEL_TO_001TableAdapters.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter();
            ((System.ComponentModel.ISupportInitialize)(this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.ANGEL_TO_001)).BeginInit();
            this.SuspendLayout();
            // 
            // uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource
            // 
            this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.DataMember = "uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate";
            this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource.DataSource = this.ANGEL_TO_001;
            // 
            // ANGEL_TO_001
            // 
            this.ANGEL_TO_001.DataSetName = "ANGEL_TO_001";
            this.ANGEL_TO_001.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // reportViewer1
            // 
            reportDataSource1.Name = "ANGEL_TO_001_uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate";
            reportDataSource1.Value = this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource;
            this.reportViewer1.LocalReport.DataSources.Add(reportDataSource1);
            this.reportViewer1.LocalReport.ReportEmbeddedResource = "Angel_to_001.Driver_plan_detail_report.rdlc";
            this.reportViewer1.Location = new System.Drawing.Point(0, 0);
            this.reportViewer1.Name = "reportViewer1";
            this.reportViewer1.ShowBackButton = false;
            this.reportViewer1.ShowDocumentMapButton = false;
            this.reportViewer1.ShowFindControls = false;
            this.reportViewer1.ShowPageNavigationControls = false;
            this.reportViewer1.ShowStopButton = false;
            this.reportViewer1.Size = new System.Drawing.Size(720, 468);
            this.reportViewer1.TabIndex = 0;
            // 
            // uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter
            // 
            this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter.ClearBeforeFill = true;
            // 
            // Driver_plan_detail_rep_viewer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(720, 511);
            this.Controls.Add(this.reportViewer1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Driver_plan_detail_rep_viewer";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "План выхода на линию";
            this.Load += new System.EventHandler(this.Driver_plan_detail_rep_viewer_Load);
            ((System.ComponentModel.ISupportInitialize)(this.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.ANGEL_TO_001)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Microsoft.Reporting.WinForms.ReportViewer reportViewer1;
        private System.Windows.Forms.BindingSource uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateBindingSource;
        private ANGEL_TO_001 ANGEL_TO_001;
        private Angel_to_001.ANGEL_TO_001TableAdapters.uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter uspVDRV_DRIVER_PLAN_DETAIL_SelectByDateTableAdapter;
    }
}