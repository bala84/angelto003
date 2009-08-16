/*
 * Created by SharpDevelop.
 * User: ?????????????
 * Date: 15.04.2008
 * Time: 7:08
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

using System;
using System.Drawing;
using System.Windows.Forms;

namespace Angel_to_001
{
	/// <summary>
	/// Description of Dialog.
	/// </summary>
	public partial class Dialog : Form
	{
		
		public string _dialog_label;
        public byte _dialog_form_state = 1;
		
		public Dialog()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			this.button_ok.DialogResult = DialogResult.OK;
			this.button_cancel.DialogResult = DialogResult.Cancel;
			this.AcceptButton = this.button_ok;
			this.CancelButton = this.button_cancel;
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		
		void DialogLoad(object sender, EventArgs e)
		{
			if (_dialog_label != "")
			{
				this.label1.Text = _dialog_label;
			}
            //Если состояние формы - предупреждение
            //выведем провайдер ошибки
            if (_dialog_form_state == 2)
            {
                this.errorProvider1.SetIconAlignment(this.label1, ErrorIconAlignment.MiddleLeft);
                this.errorProvider1.SetError(this.label1, "Внимание");
                this.BackColor = Color.Yellow;
            }

		}
	}
}
