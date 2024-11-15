package com.nomus.m2m.reporttools;

import java.io.File;
import java.sql.Connection;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.Map;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import net.sf.jasperreports.engine.JasperRunManager;

public class GenerateReportFormat {

	public GenerateReportFormat() {
		super();
		// TODO Auto-generated constructor stub

	}

	public static byte[] getReportInBytes(String reportid, Map parameters,Connection con, File reportFile)
	{
		try
		{
			byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameters, con);
			return bytes;
		}
		catch(Exception e)
		{
			e.printStackTrace();             
		}
		return new byte[1];
	}  

	public static XSSFWorkbook getWorkBook(String[] cols,ResultSet rs,String repname,String timeperiod)
	{
		int rowcnt = 1;
		DecimalFormat df = new DecimalFormat("##.##");
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet spreadsheet = workbook.createSheet(repname);
		org.apache.poi.ss.usermodel.Header header = spreadsheet.getHeader();
		for(int i=0;i<26;i++)
			spreadsheet.setColumnWidth(i, 15*256);
		XSSFRow row;
		CellStyle style = workbook.createCellStyle();
		XSSFFont font = (XSSFFont)workbook.createFont();
		font.setBold(true);
		if(repname.equals("DeviceUptime"))
		{
			row = spreadsheet.createRow((short) 0);
			row.createCell(0).setCellValue("Selected Option:   "+timeperiod);
			row = spreadsheet.createRow((short) rowcnt);
			
		}
		else
			 row = spreadsheet.createRow((short) rowcnt);
		
		
		for(int i=0;i<cols.length;i++)
		{
			XSSFRichTextString rtstr = new XSSFRichTextString(cols[i]);
			rtstr.applyFont(font);
			XSSFCell cell = row.createCell(i);
			cell.setCellValue(rtstr);
			cell.setCellStyle(style);
		}
		try
		{
			while (rs.next())
			{
				rowcnt++;
				row = spreadsheet.createRow((short) rowcnt);
				if(repname.equals("InventoryReport"))
				{
					for(int i=0;i<cols.length;i++)
						row.createCell(i).setCellValue(rs.getString(i+1));
				}
				else if(repname.equals("DeviceUptime"))
				{
					 for(int i=0;i<3;i++) { 
						 row.createCell(i).setCellValue(rs.getString(i+1)); 
					}
					double tot_sec = rs.getDouble(4);
					double downsec = rs.getDouble(5);
					double downperdou = tot_sec==0.0 ? 0: (downsec/tot_sec)*100;
					double upperdou  = tot_sec==0.0 ? 0 :((tot_sec-downsec)/tot_sec)*100;
					String down_per = df.format(downperdou);
					String up_per = df.format(upperdou);
					String down_dur = (long) (downsec/(24*3600))+" days "+
							(long)(downsec/3600)%24+" hours "+ 
							(long)(downsec/60)%(60)+" min";
					String up_dur = (long)(tot_sec-downsec) /(24*3600)+" days "+
							((long)(tot_sec-downsec)/3600)%24+" hours "+
							((long)(tot_sec-downsec)/60)%(60)+" min";

					row.createCell(3).setCellValue(down_per);
					row.createCell(4).setCellValue(down_dur);
					row.createCell(5).setCellValue(up_per);
					row.createCell(6).setCellValue(up_dur);
				}
				else if(repname.equals("StateChange"))
				{
					row.createCell(0).setCellValue(rs.getString("slnumber")==null ? "" :rs.getString("slnumber"));
					row.createCell(1).setCellValue(rs.getString("downtime")==null ? "" :rs.getString("downtime"));
					row.createCell(2).setCellValue(rs.getString("uptime")==null ? "" : rs.getString("uptime"));
					row.createCell(3).setCellValue(rs.getString("persisttime")==null ? "" :rs.getString("persisttime"));
				}
				else if(repname.equals("AllDevices"))
				{
					for(int i=0;i<cols.length;i++)
						row.createCell(i).setCellValue(rs.getString(i+1));
				}
			}
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return workbook;
	}
}
