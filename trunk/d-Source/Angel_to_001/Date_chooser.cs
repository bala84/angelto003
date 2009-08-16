using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Angel_to_001
{
	public partial class Date_chooser : Form
	{
		public string _date_chooser_format_type = "Long";
		public string _date_chooser_format = "";
		public Date_chooser()
		{
			InitializeComponent();
		}
		public string Datetime_value
		{
			get { return this.dateTimePicker1.Value.ToString(); }
		}
		public string Short_date_value
		{
			get { return this.dateTimePicker1.Value.ToShortDateString(); }
		}

		public string Short_time_value
		{
			get { return this.dateTimePicker1.Value.ToShortTimeString(); }
		}
		
		public string Month_index
		{
			get { return this.dateTimePicker1.Value.Month.ToString(); }
		}
		
		public string Hour
		{
			get {
				string v_hour;
				
				if (this.dateTimePicker1.Value.Hour < 10)
				{
					v_hour = "0" + this.dateTimePicker1.Value.Hour.ToString();
				}
				else
				{
					v_hour = this.dateTimePicker1.Value.Hour.ToString();
				}
				
				return v_hour + ":00"; }
		}
		
		public string Month_name
		{
			get
			{	Int32 v_month = this.dateTimePicker1.Value.Month;
				string v_month_name;
				
				switch (v_month)
				{
					case 1:
						v_month_name = "Январь";
						break;
					case 2:
						v_month_name = "Февраль";
						break;
					case 3:
						v_month_name = "Март";
						break;
					case 4:
						v_month_name = "Апрель";
						break;
					case 5:
						v_month_name = "Май";
						break;
					case 6:
						v_month_name = "Июнь";
						break;
					case 7:
						v_month_name = "Июль";
						break;
					case 8:
						v_month_name = "Август";
						break;
					case 9:
						v_month_name = "Сентябрь";
						break;
					case 10:
						v_month_name = "Октябрь";
						break;
					case 11:
						v_month_name = "Ноябрь";
						break;
					case 12:
						v_month_name = "Декабрь";
						break;
					default:
						v_month_name = "";
						break;
				}
				
				return v_month_name;
			}
		}
		
		void Date_chooserLoad(object sender, EventArgs e)
		{
			switch (_date_chooser_format_type)
			{
				case "Long":
					this.dateTimePicker1.Format = DateTimePickerFormat.Long;
					break;
				case "Custom":
					this.dateTimePicker1.Format = DateTimePickerFormat.Custom;
					break;
				default:
					this.dateTimePicker1.Format = DateTimePickerFormat.Long;
					break;
			}
			if (_date_chooser_format != "")
			{
				try
				{
					this.dateTimePicker1.CustomFormat = _date_chooser_format;
				}
				catch {}
			}
			
		}
	}
	
}
