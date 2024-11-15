package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.staticmembers.DateTimeUtil;

/**
 * Servlet implementation class DownloadBatch
 */
@WebServlet("/account/DownloadBatch")
public class DownloadBatch extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadBatch() {
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
		doGet(request, response);
		String orgname = request.getParameter("orgName");
		OrganizationDao orgdao = new OrganizationDao();
		Organization selorg = orgdao.getOrganization(orgname);
		List<LoadBatch> batchlist = selorg.getLoadBatchList();
		Date date = DateTimeUtil.getOnlyDate(new Date());
		int rowcnt = 1;
		XSSFWorkbook wkbook = new XSSFWorkbook();
		XSSFSheet spreadsheet = wkbook.createSheet("Batch Details");
		org.apache.poi.ss.usermodel.Header header = spreadsheet.getHeader();
		for(int i=0;i<26;i++)
			spreadsheet.setColumnWidth(i, 15*256);
		XSSFRow row;
		CellStyle style = wkbook.createCellStyle();
		XSSFFont font = (XSSFFont)wkbook.createFont();
		font.setBold(true);
		row = spreadsheet.createRow((short)0);  
		row.createCell(0).setCellValue("Organization Name : " + orgname); 
		row.setRowStyle(style);
		try
		{
			for(LoadBatch batch : batchlist)
			{
				row = spreadsheet.createRow((short) rowcnt);
				List<OrganizationData> orgdatalist = batch.getOrgdatalist();
				int count=0;
				int daysdiff = DateTimeUtil.getDaysDiff(date,batch.getValidUpTo());
				String status = (daysdiff < 0)?"Expired":(daysdiff < 30)?"About to Expire":"Active";
				int nodesct = orgdatalist.size();
				String [] batchhead = {"Batch Name : "+batch.getBatchName(),
						"Valid Up to : "+DateTimeUtil.getDateString(batch.getValidUpTo()),
						"No. of Nodes : "+nodesct,"Status : "+status};
				for(int i=0; i<batchhead.length;i++)
				{
					if(status.equalsIgnoreCase("Expired"))
						font.setColor(IndexedColors.RED.getIndex());
					else if(status.equalsIgnoreCase("Active"))
						font.setColor(IndexedColors.GREEN.getIndex());
					else if(status.equalsIgnoreCase("About to Expire"))
						font.setColor(IndexedColors.ORANGE.getIndex());
					XSSFRichTextString rtstr = new XSSFRichTextString(batchhead[i]);
					rtstr.applyFont(font);
					XSSFCell cell = row.createCell(i);
					cell.setCellValue(batch.getOrganization().getName());
					cell.setCellValue(rtstr);
					cell.setCellStyle(style);
				}

				rowcnt++;
				row = spreadsheet.createRow((short) rowcnt);
				for(OrganizationData orgdata : orgdatalist)
				{
					if(count == 10)
					{
						count = 0;
						rowcnt++;
						row = spreadsheet.createRow((short) rowcnt);
					}
					if(orgdata.getStatus().equalsIgnoreCase("fault") || orgdata.getStatus().equalsIgnoreCase("manual"))
					{
						CellStyle rowstyle = wkbook.createCellStyle();
						XSSFFont rowfont = wkbook.createFont();
						rowfont.setColor(IndexedColors.RED.getIndex());
						rowstyle.setFont(rowfont);
						row.createCell(count).setCellValue(orgdata.getSlnumber()+"("+orgdata.getStatus()+")");
						row.getCell(count).setCellStyle(rowstyle);
					}
					else
						row.createCell(count).setCellValue(orgdata.getSlnumber());
					count++;
				}
				rowcnt++;
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-disposition", "inline; filename=batchlist.xlsx");
		wkbook.write(response.getOutputStream());
		response.getOutputStream().close();
	}

}
