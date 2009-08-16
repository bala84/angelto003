/*
 * Created by SharpDevelop.
 * User: Администратор
 * Date: 16.02.2008
 * Time: 12:46
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

using System;
using System.Windows.Forms;
using System.Diagnostics;
using System.Threading;

namespace Angel_to_001
{
	/// <summary>
	/// Class with program entry point.
	/// </summary>
	internal sealed class Program
	{
		/// <summary>
		/// Program entry point.
		/// </summary>
		[STAThread]
		private static void Main(string[] args)
		{
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);
			Application.Run(new MainForm());

            // Create the source, if it does not already exist.
            if (!EventLog.SourceExists("Angel_TO"))
            {
                EventLog.CreateEventSource("Angel_TO", "Angel_TO_Log");
            }

            // Create an EventLog instance and assign its source.
            EventLog Angel_TO_Log = new EventLog();
            Angel_TO_Log.Source = "Angel_TO";

            // Write an informational entry to the event log.    
            Angel_TO_Log.WriteEntry("Writing to event log.");

      

		}
		
	}
}
