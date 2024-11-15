package com.nomus.m2m.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import com.nomus.m2m.functions.ReadExcelFile;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.FileCopy;
/**
 * Servlet implementation class OrganizationUpdateFileLoder
 */
@WebServlet("/m2m/OrganizationUpdateFileLoder")
@MultipartConfig(fileSizeThreshold=1024*1024*20,
maxFileSize=1024*1024*100,      	
maxRequestSize=1024*1024*200)
public class OrganizationUpdateFileLoder extends HttpServlet {
	private static final long serialVersionUID = 1L;
    User user = null;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrganizationUpdateFileLoder() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Part bulkfilePart = request.getPart("orgupdatefile");
		String filename=bulkfilePart.getSubmittedFileName();
		HttpSession httpsession = request.getSession();
		user = (User)httpsession.getAttribute("loggedinuser");
		String options[] = request.getParameterValues("options");
		boolean file_copied = false;
		boolean valid_file = false;
		boolean exit = false;
		FileInputStream rec_file=null;
		BufferedReader br = null;
		Vector<Vector<String>> orgupdate_vec = null;
		File tmpdir = new File(user.getUsername()+"tmp");
		try
		{
			if(!tmpdir.exists())
				tmpdir.mkdir();
			if(bulkfilePart != null)
				file_copied = FileCopy.copyFile(bulkfilePart, tmpdir+File.separator+"orgupdate.xls");
			if(file_copied)
			{
				rec_file = new FileInputStream(tmpdir+File.separator+"orgupdate.xls");
				ReadExcelFile readfile=new ReadExcelFile();
				String filepath = tmpdir+File.separator+bulkfilePart.getSubmittedFileName();
				Workbook wb=readfile.getWorkBook(rec_file,filepath);
				Sheet hsheet=wb.getSheetAt(0);
				Iterator<Row> itr = hsheet.iterator(); 
				orgupdate_vec =  new Vector<Vector<String>>();
				Vector<String> orgup_det_vec = new Vector<String>();
				Cell cell=null;
				if(itr.hasNext())
					itr.next();
				while(itr.hasNext())
				{
					Row row = itr.next();
					orgup_det_vec = new Vector<>();
					boolean empty_row = true;
					for(int i=0; i<7;i++)
					{
						cell = row.getCell(i);
						if(cell == null)
						{
							orgup_det_vec.add("");
							continue;
						}
						switch (cell.getCellType()) {
						case Cell.CELL_TYPE_BLANK:
							orgup_det_vec.add("");
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							orgup_det_vec.add(cell.getBooleanCellValue()+"");
							if(orgup_det_vec.get(orgup_det_vec.size() -1).trim().length() > 0)
								empty_row = false;
							break;
						case Cell.CELL_TYPE_ERROR:
							orgup_det_vec.add("");
							break;
						case Cell.CELL_TYPE_FORMULA:
							orgup_det_vec.add("");
							break;
						case Cell.CELL_TYPE_NUMERIC:
							orgup_det_vec.add(cell.getNumericCellValue()+"");
							if(orgup_det_vec.get(orgup_det_vec.size() -1).trim().length() > 0)
								empty_row = false;
							break;
						case Cell.CELL_TYPE_STRING:
							if(cell.getStringCellValue().contains(","))
							{
								String vallen[]=cell.getStringCellValue().split(",");
								int lenth=vallen.length;
								if(lenth>5)
									exit=true;
								else
								{
									 orgup_det_vec.add(cell.getStringCellValue());
									 if(orgup_det_vec.get(orgup_det_vec.size() -1).trim().length() > 0)
											empty_row = false;
								}
							}
							else
							{
								orgup_det_vec.add(cell.getStringCellValue());
								if(orgup_det_vec.get(orgup_det_vec.size() -1).trim().length() > 0)
									empty_row = false;
							}
							break;
						default:
							orgup_det_vec.add("");
							break;
						}
					}
					if(!empty_row&&!exit)
						orgupdate_vec.add(orgup_det_vec);
				}
				if(!exit)
				  valid_file=true;
			}
		}
		catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			valid_file = false;
		}
		finally {
			if(br != null)
				br.close();
		}
		FileUtils.deleteDirectory(tmpdir);
		if(!valid_file||exit)
			httpsession.setAttribute("status", "Invalid File");
		else
		httpsession.setAttribute("orgupdatevec", orgupdate_vec);
		httpsession.setAttribute("options", options);
		httpsession.setAttribute("orgupdatefile",filename);
	    response.sendRedirect("orgupdate.jsp");
	}
		

	
}
