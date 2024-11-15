package com.nomus.m2m.functions;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Pattern;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.OrganizationData;

public class  ReadExcelFile {
	private static final Pattern nonASCII = Pattern.compile("[^\\x00-\\x7f]");
	public List<OrganizationData> getSlnumlistFromExcel(String filepath,String organization,LoadBatch batch,Date validupto)
	{		
		List<OrganizationData> orgdatalist = new ArrayList<OrganizationData>();
		FileInputStream fis = null;
		Workbook wb = null;
		try {
			fis = new FileInputStream(new File(filepath));
			wb = getWorkBook(fis,filepath);
			Sheet hsheet=wb.getSheetAt(0);
			String slnumber;
			HashMap<String,String> slnumbers_hm = new HashMap<String,String>();
			FormulaEvaluator formulaEvaluator=wb.getCreationHelper().createFormulaEvaluator();
			for(Row row: hsheet)       
			{  
				for(Cell cell: row)      
				{  
					switch(formulaEvaluator.evaluateInCell(cell).getCellType())  
					{  
						case Cell.CELL_TYPE_STRING:   
							slnumber = cell.getStringCellValue().toString();
							slnumber = nonASCII.matcher(slnumber).replaceAll("");
							slnumber = slnumber.trim();
							if(slnumber.length() > 0 && slnumbers_hm.get(slnumber) == null)
							{	
								OrganizationData orgdata = new OrganizationData();
								orgdata.setSlnumber(slnumber);
								orgdata.setOrganization(organization);
								orgdata.setBatch(batch);
								orgdata.setValidUpto(validupto);
								orgdatalist.add(orgdata);
								slnumbers_hm.put(slnumber,slnumber);
							}
							break;  
					}  
				}  
			}
		}
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		finally
		{
			if(wb != null)
				wb = null;
			if(fis != null)
				try {
					fis.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
			return orgdatalist;
	}
	
	public Workbook getWorkBook(FileInputStream fis, String srcpath) {
		Workbook wb = null;
		try {
			if(srcpath.endsWith(".xls"))
				wb = new HSSFWorkbook(fis);
			else if(srcpath.endsWith(".xlsx"))
				wb = new XSSFWorkbook(fis);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return wb;
	}

}
