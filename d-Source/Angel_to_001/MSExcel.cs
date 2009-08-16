using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;

namespace Angel_to_001
{
    public class MSExcel
    {
        Type ExcelType;
        object ExcelApplication;
        public object oBook;

        public MSExcel()
        {
            //Gets the type of the Excel application using prorame id
            ExcelType = Type.GetTypeFromProgID("Excel.Application");

            //Creating Excel application instance from the type
            //Check the running processes using alt+ctrl+del
            ExcelApplication = Activator.CreateInstance(ExcelType);
        }
        public void Open(string strFileName)
        {
            object fileName = strFileName;
            object readOnly = true;
            object missing = System.Reflection.Missing.Value;
            object[] oParams = new object[1];

            //Getting the WoorkBook collection [work Sheet collection]
            object oDocs = ExcelApplication.GetType().InvokeMember("Workbooks",
            System.Reflection.BindingFlags.GetProperty,
            null,
            ExcelApplication,
            null, CultureInfo.InvariantCulture);
            oParams = new object[3];
            oParams[0] = fileName;
            oParams[1] = missing;
            oParams[2] = readOnly;

            //Open the first work sheet
            oBook = oDocs.GetType().InvokeMember("Open", System.Reflection.BindingFlags.InvokeMethod,
            null,
            oDocs,
            oParams, CultureInfo.InvariantCulture);

        }
        public void Close()
        {
            //Closing the work sheet
            oBook.GetType().InvokeMember("Close", System.Reflection.BindingFlags.InvokeMethod,
            null,
            oBook,
            null, CultureInfo.InvariantCulture);
        }
        public void Print()
        {
            //Printing the sheet
            oBook.GetType().InvokeMember("PrintOut", System.Reflection.BindingFlags.InvokeMethod,
            null,
            oBook,
            null, CultureInfo.InvariantCulture);
        }
        public void Quit()
        {
            //Close the Excel application block
            //Check the running processes using alt+ctrl+del
            ExcelApplication.GetType().InvokeMember("Quit", System.Reflection.BindingFlags.InvokeMethod,
            null,
            ExcelApplication,
            null, CultureInfo.InvariantCulture);
        }
    }
}
