//import java.awt.Image;
//import java.awt.MediaTracker;
//import java.awt.Panel;
//import java.awt.Toolkit;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.*;
import java.text.*;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperPrintManager;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.export.JExcelApiExporter;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.JRRtfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.export.oasis.JROdtExporter;
import net.sf.jasperreports.engine.util.JRLoader;


/**
 * @author Valery Lavrentiev (lavsurgut@gmail.com)
 */
public class Report_setup
{


	/**
	 *
	 */
	private static final String TASK_FILL = "fill";
	private static final String TASK_PRINT = "print";
	private static final String TASK_PDF = "pdf";
	private static final String TASK_XML = "xml";
	private static final String TASK_XML_EMBED = "xmlEmbed";
	private static final String TASK_HTML = "html";
	private static final String TASK_RTF = "rtf";
	private static final String TASK_XLS = "xls";
	private static final String TASK_JXL = "jxl";
	private static final String TASK_CSV = "csv";
	private static final String TASK_ODT = "odt";
	private static final String TASK_RUN = "run";
	
	private static String _connection_driver = "";
	private static String _connection_string = "";
	
/**
	 *
	 */
	public static void main(String[] args)
	{
		if(args.length < 4)
		{
			usage();
			return;
		}
		
		
		String taskName = args[0];
		String fileName = args[1];

		_connection_string = args[2];
		_connection_driver = args[3];
		
		SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy");

		try
		{
			long start = System.currentTimeMillis();
			
			Map parameters = new HashMap();
			
			/*
			parameters.put("start_date", sdf.parse(startDate));
			parameters.put("end_date", sdf.parse(endDate));
			
			if (car_mark_id.length() > 2)
			{
				parameters.put("car_mark_id", Double.parseDouble(car_mark_id));
				parameters.put("car_mark_sname", car_mark_sname);
			}
			if (car_kind_id.length() > 2)
			{
				parameters.put("car_kind_id", Double.parseDouble(car_kind_id));			
				parameters.put("car_kind_sname", car_kind_sname);
			}
			
			if (car_id.length() > 2)
			{
				parameters.put("car_id", Double.parseDouble(car_id));			
				parameters.put("state_number", state_number);
			}
			
			if (wrh_demand_master_type_id.length() > 2)
			{
				parameters.put("wrh_demand_master_type_id", Double.parseDouble(wrh_demand_master_type_id));			
				parameters.put("wrh_demand_master_type_sname", wrh_demand_master_type_sname);
			}
			
			if (employee_recieve_id.length() > 2)
			{
				parameters.put("employee_recieve_id", Double.parseDouble(employee_recieve_id));			
				parameters.put("employee_recieve_fio", employee_recieve_fio);
			}
			
			if (organization_id.length() > 2)
			{
				parameters.put("organization_id", Double.parseDouble(organization_id));			
				parameters.put("organization_sname", organization_sname);
			}
			
			if (employee_type_id.length() > 2)
			{
				parameters.put("employee_type_id", Double.parseDouble(employee_type_id));			
				parameters.put("employee_type_sname", employee_type_sname);
			}
			
			System.err.println("Parameter start_date : " + startDate);
			System.err.println("Parameter end_date : " + endDate);*/
			if (TASK_FILL.equals(taskName))
			{
				//Preparing parameters
			/*	Image image = 
					Toolkit.getDefaultToolkit().createImage(
						JRLoader.loadBytesFromLocation("dukesign.jpg")
						);
				MediaTracker traker = new MediaTracker(new Panel());
				traker.addImage(image, 0);
				try
				{
					traker.waitForID(0);
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}*/
				

				JasperFillManager.fillReportToFile(fileName, parameters, getConnection());
				System.err.println("Filling time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_PRINT.equals(taskName))
			{
				JasperPrintManager.printReport(fileName, true);
				System.err.println("Printing time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_PDF.equals(taskName))
			{
				JasperExportManager.exportReportToPdfFile(fileName);
				System.err.println("PDF creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_XML.equals(taskName))
			{
				JasperExportManager.exportReportToXmlFile(fileName, false);
				System.err.println("XML creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_XML_EMBED.equals(taskName))
			{
				JasperExportManager.exportReportToXmlFile(fileName, true);
				System.err.println("XML creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_HTML.equals(taskName))
			{
				JasperExportManager.exportReportToHtmlFile(fileName);
				System.err.println("HTML creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_RTF.equals(taskName))
			{
				File sourceFile = new File(fileName);
		
				JasperPrint jasperPrint = (JasperPrint)JRLoader.loadObject(sourceFile);
		
				File destFile = new File(sourceFile.getParent(), jasperPrint.getName() + ".rtf");
				
				JRRtfExporter exporter = new JRRtfExporter();
				
				exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, destFile.toString());
				
				exporter.exportReport();

				System.err.println("RTF creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_XLS.equals(taskName))
			{
				File sourceFile = new File(fileName);
				Map dateFormats = new HashMap();
				dateFormats.put("EEE, MMM d, yyyy", "ddd, mmm d, yyyy");
				JasperPrint jasperPrint = (JasperPrint)JRLoader.loadObject(sourceFile);
				File destFile = new File(sourceFile.getParent(), jasperPrint.getName() + ".xls");
				
				JRXlsExporter exporter = new JRXlsExporter();
				
				exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, destFile.toString());
				exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.TRUE);
				exporter.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
				exporter.setParameter(JRXlsExporterParameter.FORMAT_PATTERNS_MAP, dateFormats);
				
				exporter.exportReport();

				System.err.println("XLS creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_JXL.equals(taskName))
			{
				File sourceFile = new File(fileName);

				JasperPrint jasperPrint = (JasperPrint)JRLoader.loadObject(sourceFile);

				File destFile = new File(sourceFile.getParent(), jasperPrint.getName() + ".jxl.xls");

				JExcelApiExporter exporter = new JExcelApiExporter();

				exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, destFile.toString());
				exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.TRUE);

				exporter.exportReport();

				System.err.println("XLS creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_CSV.equals(taskName))
			{
				File sourceFile = new File(fileName);
		
				JasperPrint jasperPrint = (JasperPrint)JRLoader.loadObject(sourceFile);
		
				File destFile = new File(sourceFile.getParent(), jasperPrint.getName() + ".csv");
				
				JRCsvExporter exporter = new JRCsvExporter();
				
				exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, destFile.toString());
				
				exporter.exportReport();

				System.err.println("CSV creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_ODT.equals(taskName))
			{
				File sourceFile = new File(fileName);

				JasperPrint jasperPrint = (JasperPrint)JRLoader.loadObject(sourceFile);

				File destFile = new File(sourceFile.getParent(), jasperPrint.getName() + ".odt");

				JROdtExporter exporter = new JROdtExporter();

				exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, destFile.toString());

				exporter.exportReport();

				System.err.println("ODT creation time : " + (System.currentTimeMillis() - start));
			}
			else if (TASK_RUN.equals(taskName))
			{
				/*//Preparing parameters
				Image image = Toolkit.getDefaultToolkit().createImage("dukesign.jpg");
				MediaTracker traker = new MediaTracker(new Panel());
				traker.addImage(image, 0);
				try
				{
					traker.waitForID(0);
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}*/
				
		//		Map parameters = new HashMap();
			//	parameters.put("ReportTitle", "The First Jasper Report Ever");
			//	parameters.put("MaxOrderID", new Integer(10500));
			//	parameters.put("SummaryImage", image);
				
				JasperRunManager.runReportToPdfFile(fileName, parameters, getConnection());
				System.err.println("PDF running time : " + (System.currentTimeMillis() - start));
			}
			else
			{
				usage();
			}
		}
		catch (JRException e)
		{
			e.printStackTrace();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	/**
	 *
	 */
	private static void usage()
	{
		System.out.println( "Report_setup usage:" );
		System.out.println( "\tjava Report_setup task file" );
		System.out.println( "\tTasks : fill | print | pdf | xml | xmlEmbed | html | rtf | xls | jxl | csv | odt | run" );
	}


	/**
	 *
	 */
	private static Connection getConnection() throws ClassNotFoundException, SQLException
	{
		//Change these settings according to your local configuration
		String driver = _connection_driver;
		String connectString = _connection_string;


		Class.forName(driver);
		Connection conn = DriverManager. getConnection(connectString);
		return conn;
	}


}
