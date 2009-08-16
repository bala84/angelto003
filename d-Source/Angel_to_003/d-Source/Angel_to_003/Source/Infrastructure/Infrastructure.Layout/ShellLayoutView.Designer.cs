namespace Angel_to_003.Infrastructure.Layout
{
    partial class ShellLayoutView
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
            if (disposing)
            {
                if (_presenter != null)
                    _presenter.Dispose();

                if (components != null)
                    components.Dispose();
            }

            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ShellLayoutView));
            this._mainMenuStrip = new System.Windows.Forms.MenuStrip();
            this._fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this._exitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this._statusLabel = new System.Windows.Forms.ToolStripStatusLabel();
            this._mainStatusStrip = new System.Windows.Forms.StatusStrip();
            this._mainToolStrip = new System.Windows.Forms.ToolStrip();
            this.OkToolStripButton = new System.Windows.Forms.ToolStripButton();
            this.CancelToolStripButton = new System.Windows.Forms.ToolStripButton();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this._leftWorkspace = new Microsoft.Practices.CompositeUI.WPF.DeckWorkspace();
            this._rightWorkspace = new Microsoft.Practices.CompositeUI.WPF.TabWorkspace();
            this._mainMenuStrip.SuspendLayout();
            this._mainStatusStrip.SuspendLayout();
            this._mainToolStrip.SuspendLayout();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.SuspendLayout();
            // 
            // _mainMenuStrip
            // 
            this._mainMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this._fileToolStripMenuItem});
            this._mainMenuStrip.Location = new System.Drawing.Point(0, 0);
            this._mainMenuStrip.Name = "_mainMenuStrip";
            this._mainMenuStrip.Size = new System.Drawing.Size(613, 24);
            this._mainMenuStrip.TabIndex = 4;
            this._mainMenuStrip.Text = "_mainMenuStrip";
            // 
            // _fileToolStripMenuItem
            // 
            this._fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this._exitToolStripMenuItem});
            this._fileToolStripMenuItem.Name = "_fileToolStripMenuItem";
            this._fileToolStripMenuItem.Size = new System.Drawing.Size(45, 20);
            this._fileToolStripMenuItem.Text = "&Файл";
            // 
            // _exitToolStripMenuItem
            // 
            this._exitToolStripMenuItem.Name = "_exitToolStripMenuItem";
            this._exitToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Alt | System.Windows.Forms.Keys.F4)));
            this._exitToolStripMenuItem.Size = new System.Drawing.Size(158, 22);
            this._exitToolStripMenuItem.Text = "В&ыход";
            this._exitToolStripMenuItem.Click += new System.EventHandler(this.OnFileExit);
            // 
            // _statusLabel
            // 
            this._statusLabel.Name = "_statusLabel";
            this._statusLabel.Size = new System.Drawing.Size(38, 17);
            this._statusLabel.Text = "Ready";
            // 
            // _mainStatusStrip
            // 
            this._mainStatusStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this._statusLabel});
            this._mainStatusStrip.Location = new System.Drawing.Point(0, 477);
            this._mainStatusStrip.Name = "_mainStatusStrip";
            this._mainStatusStrip.Size = new System.Drawing.Size(613, 22);
            this._mainStatusStrip.TabIndex = 6;
            this._mainStatusStrip.Text = "_mainStatusStrip";
            // 
            // _mainToolStrip
            // 
            this._mainToolStrip.AllowDrop = true;
            this._mainToolStrip.BackColor = System.Drawing.SystemColors.Control;
            this._mainToolStrip.Dock = System.Windows.Forms.DockStyle.Bottom;
            this._mainToolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.OkToolStripButton,
            this.CancelToolStripButton});
            this._mainToolStrip.LayoutStyle = System.Windows.Forms.ToolStripLayoutStyle.HorizontalStackWithOverflow;
            this._mainToolStrip.Location = new System.Drawing.Point(0, 452);
            this._mainToolStrip.Name = "_mainToolStrip";
            this._mainToolStrip.RenderMode = System.Windows.Forms.ToolStripRenderMode.Professional;
            this._mainToolStrip.Size = new System.Drawing.Size(613, 25);
            this._mainToolStrip.TabIndex = 5;
            this._mainToolStrip.Text = "_mainToolStrip";
            // 
            // OkToolStripButton
            // 
            this.OkToolStripButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.OkToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.OkToolStripButton.Image = ((System.Drawing.Image)(resources.GetObject("OkToolStripButton.Image")));
            this.OkToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.OkToolStripButton.Name = "OkToolStripButton";
            this.OkToolStripButton.Size = new System.Drawing.Size(25, 22);
            this.OkToolStripButton.Text = "Ок";
            this.OkToolStripButton.Click += new System.EventHandler(this.OkToolStripButton_Click);
            // 
            // CancelToolStripButton
            // 
            this.CancelToolStripButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.CancelToolStripButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.CancelToolStripButton.Image = ((System.Drawing.Image)(resources.GetObject("CancelToolStripButton.Image")));
            this.CancelToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.CancelToolStripButton.Name = "CancelToolStripButton";
            this.CancelToolStripButton.Size = new System.Drawing.Size(49, 22);
            this.CancelToolStripButton.Text = "Отмена";
            this.CancelToolStripButton.ToolTipText = "Отмена";
            this.CancelToolStripButton.Click += new System.EventHandler(this.CancelToolStripButton_Click);
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 24);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this._leftWorkspace);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this._rightWorkspace);
            this.splitContainer1.Size = new System.Drawing.Size(613, 428);
            this.splitContainer1.SplitterDistance = 100;
            this.splitContainer1.TabIndex = 7;
            // 
            // _leftWorkspace
            // 
            this._leftWorkspace.Dock = System.Windows.Forms.DockStyle.Fill;
            this._leftWorkspace.Location = new System.Drawing.Point(0, 0);
            this._leftWorkspace.Name = "_leftWorkspace";
            this._leftWorkspace.Size = new System.Drawing.Size(100, 428);
            this._leftWorkspace.TabIndex = 1;
            this._leftWorkspace.Text = "_leftWorkspace";
            // 
            // _rightWorkspace
            // 
            this._rightWorkspace.Appearance = System.Windows.Forms.TabAppearance.FlatButtons;
            this._rightWorkspace.Dock = System.Windows.Forms.DockStyle.Fill;
            this._rightWorkspace.Location = new System.Drawing.Point(0, 0);
            this._rightWorkspace.Multiline = true;
            this._rightWorkspace.Name = "_rightWorkspace";
            this._rightWorkspace.SelectedIndex = 0;
            this._rightWorkspace.Size = new System.Drawing.Size(509, 428);
            this._rightWorkspace.TabIndex = 1;
            this._rightWorkspace.Text = "_rightWorkspace";
            // 
            // ShellLayoutView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this._mainToolStrip);
            this.Controls.Add(this._mainStatusStrip);
            this.Controls.Add(this._mainMenuStrip);
            this.Name = "ShellLayoutView";
            this.Size = new System.Drawing.Size(613, 499);
            this._mainMenuStrip.ResumeLayout(false);
            this._mainMenuStrip.PerformLayout();
            this._mainStatusStrip.ResumeLayout(false);
            this._mainStatusStrip.PerformLayout();
            this._mainToolStrip.ResumeLayout(false);
            this._mainToolStrip.PerformLayout();
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip _mainMenuStrip;
        private System.Windows.Forms.ToolStripMenuItem _fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem _exitToolStripMenuItem;
        private System.Windows.Forms.ToolStripStatusLabel _statusLabel;
        private System.Windows.Forms.StatusStrip _mainStatusStrip;
        private System.Windows.Forms.ToolStrip _mainToolStrip;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private Microsoft.Practices.CompositeUI.WPF.DeckWorkspace _leftWorkspace;
        private Microsoft.Practices.CompositeUI.WPF.TabWorkspace _rightWorkspace;
        private System.Windows.Forms.ToolStripButton OkToolStripButton;
        private System.Windows.Forms.ToolStripButton CancelToolStripButton;
    }
}

