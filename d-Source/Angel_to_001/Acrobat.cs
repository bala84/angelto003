using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Data;
using System.Windows.Forms;
using iTextSharp.text.pdf;
using iTextSharp.text;
using PdfSharp.Pdf.Printing;
using System.Configuration;
using System.Diagnostics;

namespace Angel_to_001
{
    public class Acrobat
    {//Процедура должна заполнять форму №3(легковой автомобиль)
     //в формате .pdf и имеющую поля формы
     //и возвращать имя заполненного файла
        public string Auto3_form_fill(
                                    string p_number
                                  , string p_datetime
                                  , string p_org_wo_address
                                  , string p_car_mark_model
                                  , string p_state_number
                                  , string p_driver_fio
                                  , string p_driver_passport
                                  , string p_driver_passport_class
                                  , string p_speedometer_start_indctn
                                  , string p_speedometer_end_indctn
                                  , string p_dependent_on
                                  , string p_usage_area_1
                                  , string p_usage_area_2
                                  , string p_fuel_start_left
                                  , string p_fuel_end_left
                                  , string p_fuel_norm
                                  , string p_fuel_exp
                                  , string p_fact_start_duty_time
                                  , string p_fact_end_duty_time
                                  , string p_fuel_gived
                                  , string p_fuel_type_sname
                                  , string p_fuel_type_number
                                  , string p_mech_manager_fio
                                  , string p_mech_fio
                                  , string p_adtnl_driver_fio
                                            )
        {
            string v_all_drivers_fio = "";
            string filled_file = "forms\\avto_3_fill.pdf";
            // add content to existing PDF document with PdfStamper
            PdfStamper so = null;
            try
            {
                FontFactory.Register("fonts\\LiberationSans-Regular.ttf");
                BaseFont baseFont = BaseFont.CreateFont("fonts\\LiberationSans-Regular.ttf",
                                System.Text.Encoding.GetEncoding(1251).BodyName, true);
                // read existing PDF document
                PdfReader reader = new PdfReader("forms\\avto_3.pdf");
                so = new PdfStamper(reader, new System.IO.FileStream(filled_file, System.IO.FileMode.Create));
                AcroFields form = so.AcroFields;

                form.AddSubstitutionFont(baseFont);

                if (p_adtnl_driver_fio != "")
                {
                    v_all_drivers_fio = p_driver_fio + ", " + p_adtnl_driver_fio;
                }
                else
                {
                    v_all_drivers_fio = p_driver_fio;
                }

                form.SetField("fill_2", p_number);
                form.SetField("fill_43", p_datetime);
                form.SetField("fill_3", p_org_wo_address);
                form.SetField("fill_4", p_car_mark_model);
                form.SetField("fill_5", p_state_number);
                form.SetField("fill_6", v_all_drivers_fio);
                form.SetField("fill_7", p_driver_passport);
                form.SetField("fill_8", p_driver_passport_class);
                form.SetField("fill_41", p_speedometer_start_indctn);
                form.SetField("fill_12", p_dependent_on);
                form.SetField("fill_15", p_usage_area_1);
                form.SetField("fill_18", p_usage_area_2);
                form.SetField("fill_44", p_fact_start_duty_time);
                form.SetField("fill_45", p_fact_end_duty_time);
                form.SetField("fill_32", p_fuel_gived);
                form.SetField("fill_33", p_fuel_start_left);
                form.SetField("fill_34", p_fuel_end_left);
                form.SetField("fill_35", p_fuel_norm);
                form.SetField("fill_36", p_fuel_exp);
                form.SetField("fill_42", p_speedometer_end_indctn);
                form.SetField("fill_17", p_driver_fio);
                form.SetField("fill_14", p_mech_fio);
                form.SetField("fill_23", p_mech_manager_fio);
                form.SetField("fill_29", p_driver_fio);
                form.SetField("fill_200", p_fuel_type_sname);

                // make resultant PDF read-only for end-user
                so.FormFlattening = true;
                // forget to close() PdfStamper, you end up with
                // a corrupted file
                so.Close();
                return filled_file;
            }
            catch(ApplicationException Appe)
            {
                MessageBox.Show(Appe.Message);
                return filled_file; 
            }
            catch
            { return filled_file; }
            finally 
            { 
                if (so != null) so.Close(); 
            }
        }
        //Процедура должна заполнять форму №4П(грузовой автомобиль)
        //в формате .pdf и имеющую поля формы
        //и возвращать имя заполненного файла
        public string Auto4p_form_fill(
                                    string p_number
                                  , string p_date
                                  , string p_monthyear
                                  , string p_org_wo_address
                                  , string p_car_mark_model
                                  , string p_state_number
                                  , string p_driver_fio
                                  , string p_driver_passport
                                  , string p_driver_passport_class
                                  , string p_speedometer_start_indctn
                                  , string p_speedometer_end_indctn
                                  , string p_dependent_on
                                  , string p_usage_area_1
                                  , string p_usage_area_2
                                  , string p_fuel_start_left
                                  , string p_fuel_end_left
                                  , string p_fuel_norm
                                  , string p_fuel_exp
                                  , string p_fact_start_duty_time
                                  , string p_fact_end_duty_time
                                  , string p_fuel_gived
                                  , string p_plan_day
                                  , string p_plan_month
                                  , string p_plan_hour
                                  , string p_plan_min
                                  , string p_fuel_type_sname
                                  , string p_fuel_type_number
                                  , string p_mech_manager_fio
                                  , string p_mech_fio 
                                  , string p_adtnl_driver_fio
                                            )
        {
            string v_all_drivers_fio = "";
            string v_plan_month = "";
            string filled_file = "forms\\avto_4p_fill.pdf";
            // add content to existing PDF document with PdfStamper
            PdfStamper so = null;
            try
            {
                FontFactory.Register("fonts\\LiberationSans-Regular.ttf");
                BaseFont baseFont = BaseFont.CreateFont("fonts\\LiberationSans-Regular.ttf",
                                System.Text.Encoding.GetEncoding(1251).BodyName, true);
                // read existing PDF document
                PdfReader reader = new PdfReader("forms\\avto_4p.pdf");
                so = new PdfStamper(reader, new System.IO.FileStream(filled_file, System.IO.FileMode.Create));
                AcroFields form = so.AcroFields;

                form.AddSubstitutionFont(baseFont);

                if (p_adtnl_driver_fio != "")
                {
                    v_all_drivers_fio = p_driver_fio + ", " + p_adtnl_driver_fio;
                }
                else
                {
                    v_all_drivers_fio = p_driver_fio;
                }
                try
                {
                    if (p_plan_month != "")
                    {
                        if ((int)Convert.ChangeType(p_plan_month, typeof(int)) < 10)
                        {
                            v_plan_month = "0" + p_plan_month;
                        }
                        else
                        {
                            v_plan_month = p_plan_month;
                        }
                    }
                }
                catch { }

                form.SetField("fill_2", p_number);
                form.SetField("fill_100", p_date);
                form.SetField("fill_101", p_monthyear);
                form.SetField("fill_4", p_org_wo_address);
                form.SetField("fill_5", p_car_mark_model);
                form.SetField("fill_6", p_state_number);
                form.SetField("fill_7", v_all_drivers_fio);
                form.SetField("fill_8", p_driver_passport);
                form.SetField("fill_9", p_driver_passport_class);
                form.SetField("fill_105", p_speedometer_start_indctn);
                form.SetField("fill_119", p_dependent_on);
                form.SetField("fill_127", p_usage_area_1 + ", " + p_usage_area_2);
                form.SetField("fill_128", p_plan_day);
                form.SetField("fill_113", p_plan_month);
                form.SetField("fill_102", p_plan_hour);
                form.SetField("fill_103", p_plan_min);
                form.SetField("fill_106", p_date + "." + v_plan_month + " " + p_fact_start_duty_time);
                form.SetField("fill_112", p_fact_end_duty_time);
                form.SetField("fill_115", p_fuel_gived);
                form.SetField("fill_116", p_fuel_start_left);
                form.SetField("fill_117", p_fuel_end_left);
                form.SetField("fill_83", p_fuel_norm);
                form.SetField("fill_130", p_fuel_exp);
                form.SetField("fill_111", p_speedometer_end_indctn);
                form.SetField("fill_300", p_fuel_type_sname);
                form.SetField("fill_21", p_mech_fio);
                form.SetField("fill_25", p_driver_fio);
                form.SetField("fill_33", p_driver_fio);
                form.SetField("fill_30", p_mech_manager_fio);
                form.SetField("fill_27", p_fuel_gived);

                // make resultant PDF read-only for end-user
                so.FormFlattening = true;
                // forget to close() PdfStamper, you end up with
                // a corrupted file
                so.Close();
                return filled_file;
            }
            catch (ApplicationException Appe)
            {
                MessageBox.Show(Appe.Message);
                return filled_file;
            }
            catch
            { return filled_file; }
            finally
            {
                if (so != null) so.Close();
            }
        }
        //Процедура должна заполнять заявку на ремонт
        //в формате .pdf и имеющую поля формы
        //и возвращать имя заполненного файла
        public string Order_form_fill(
                                         string p_number
                                        ,string p_date
                                        ,string p_time
                                        ,string p_car_mark_model
                                        ,string p_state_number
                                        ,string p_driver_fio
                                        ,string p_mech_fio
                                        ,string p_run
                                        ,string p_fuel_end_left
                                        ,string p_malfunc_desc
                                        ,string p_speedometer_end_indctn
                                            )
        {
            string filled_file = "forms\\order_fill.pdf";
            // add content to existing PDF document with PdfStamper
            PdfStamper so = null;
            try
            {
                FontFactory.Register("fonts\\LiberationSans-Regular.ttf");
                BaseFont baseFont = BaseFont.CreateFont("fonts\\LiberationSans-Regular.ttf",
                                System.Text.Encoding.GetEncoding(1251).BodyName, true);
                // read existing PDF document
                PdfReader reader = new PdfReader("forms\\order.pdf");
                so = new PdfStamper(reader, new System.IO.FileStream(filled_file, System.IO.FileMode.Create));
                AcroFields form = so.AcroFields;

                form.AddSubstitutionFont(baseFont);

                form.SetField("fill_23", p_number);
                form.SetField("fill_1", p_date);
                form.SetField("fill_2", p_time);
                form.SetField("fill_21", p_car_mark_model);
                form.SetField("fill_3", p_mech_fio);
                form.SetField("fill_4", p_state_number);
                form.SetField("fill_22", p_run);
                form.SetField("fill_5", p_driver_fio);
                form.SetField("fill_6", p_fuel_end_left);
                form.SetField("fill_20", p_malfunc_desc);
                form.SetField("fill_24", p_speedometer_end_indctn);

                // make resultant PDF read-only for end-user
                so.FormFlattening = true;
                // forget to close() PdfStamper, you end up with
                // a corrupted file
                so.Close();
                return filled_file;
            }
            catch (ApplicationException Appe)
            {
                MessageBox.Show(Appe.Message);
                return filled_file;
            }
            catch
            { return filled_file; }
            finally
            {
                if (so != null) so.Close();
            }
        }
        //Процедура должна напечатать форму на принтере
        public void Form_print(string p_ar_path, string p_filename, string p_printername)
        {

            PdfFilePrinter.AdobeReaderPath = p_ar_path;

            PdfFilePrinter printer = new PdfFilePrinter(p_filename, p_printername);

            try
            {
                printer.Print();
                
            }
            catch (Exception ex)
            {
                Console.WriteLine("Ошибка: " + ex.Message);
            }
        }
        //Процедура должна напечатать бланк заготовки формы на принтере
        public void Form_blank_print(string p_ar_path, string p_filename, string p_printername, int p_doc_count)
        {

            PdfFilePrinter.AdobeReaderPath = p_ar_path;

            PdfFilePrinter printer = new PdfFilePrinter(p_filename, p_printername);

            try
            {
                for (int i = 1; i <= p_doc_count; i++)
                {
                    printer.Print();
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine("Ошибка: " + ex.Message);
            }
        }
        //Печать документов с помощью ghostscript
        public void Form_gs_print(string p_filename_with_path, string p_printerspool, string p_device)
        {
            //MessageBox.Show("gswin32c" + " -q -dNOPAUSE -sDEVICE=" + p_device + " " + p_filename_with_path + " -sOutputFile=" + @"""" + p_printerspool + @"""" + " -c quit");
            Process Proc = new Process();
            Proc = Process.Start("gswin32c", "-q -dNOPAUSE -sDEVICE=" + p_device + " " + p_filename_with_path + " -sOutputFile=" + @"""" +  p_printerspool + @"""" + " -c quit");
            Proc.WaitForExit();
        }
        //Печать определенных страниц документов и их кол-во с помощью ghostscript
        public void Form_gs_print_pages_count(string p_filename_with_path, string p_printerspool, string p_device, string p_start_page, string p_end_page, int p_doc_count)
        {
            Process Proc = new Process();
            //MessageBox.Show("gswin32c" + " -q -dNOPAUSE -dFirstPage=" + p_start_page + " -dLastPage=" + p_end_page + " -sDEVICE=" + p_device + " " + p_filename_with_path + " -sOutputFile=" + p_printerspool + " -c quit");
            for (int i = 1; i <= p_doc_count; i++)
            {
                Proc = Process.Start("gswin32c", "-q -dNOPAUSE -dFirstPage=" + p_start_page + " -dLastPage=" + p_end_page + " -sDEVICE=" + p_device + " " + p_filename_with_path + " -sOutputFile=" + @"""" + p_printerspool + @"""" + " -c quit");
            }
             Proc.WaitForExit();
        }
    }
}
