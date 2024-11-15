package com.nomus.m2m.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.nomus.m2m.dao.LoadBatchDao;
import com.nomus.m2m.dao.OrganizationDao;
import com.nomus.m2m.dao.OrganizationDataDao;
import com.nomus.m2m.functions.ReadExcelFile;
import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.FileCopy;
import com.nomus.staticmembers.SerialnumberValidator;
import com.nomus.staticmembers.Symbols;
import com.nomus.staticmembers.UserTempFile;
@WebServlet("/account/loadOrganizationData")
@MultipartConfig(fileSizeThreshold=1024*1024*40,
maxFileSize=1024*1024*200,      	
maxRequestSize=1024*1024*400)
public class LoadOrganizationDataController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String status="";
		List<String> invalidsl=new ArrayList<String>();
		String  savedsl="";
		String  duplicatesl="";
		int invalidcnt=0;
		int savedcnt=0;
		Part bulkfilePart = request.getPart("selfile");
		//System.out.println(bulkfilePart.getSubmittedFileName());
		//String excelpath=request.getParameter("selfile");
		HttpSession httpsession = request.getSession();
		User user = (User)httpsession.getAttribute("loggedinuser");
		String organization = request.getParameter("organization");
		String batchname = request.getParameter("batname");
		int batchid = Integer.parseInt(request.getParameter("batchid").trim());
		String validupto = request.getParameter("validupto");
		Date validuptodate = DateTimeUtil.getDate(validupto);
		File tmpdir = UserTempFile.getUserTempDir(user, "orgdata");
		LoadBatchDao batchdao = new LoadBatchDao();
		OrganizationDao orgdao = new OrganizationDao();
		Organization org = orgdao.getOrganization(organization);
		if(!batchdao.isBatchExists(batchname, org))
		{
			boolean file_copied = false;
			String filepath = tmpdir+File.separator+bulkfilePart.getSubmittedFileName();
			try
			{
				if(!tmpdir.exists())
					tmpdir.mkdir();
				if(bulkfilePart != null)
					file_copied = FileCopy.copyFile(bulkfilePart, filepath);
				if(file_copied)
				{
					LoadBatch batchtosave = new  LoadBatch();
					batchtosave.setBatchName(batchname);
					batchtosave.setOrganization(org);
					batchtosave.setBatchId(batchid);
					batchtosave.setValidUpTo(DateTimeUtil.getDate(validupto));
					ReadExcelFile rd=new ReadExcelFile();
					List<OrganizationData> orgdatalist=rd.getSlnumlistFromExcel(filepath,organization,batchtosave,validuptodate);
					List<OrganizationData> orgdatalisttosave = new ArrayList<OrganizationData>();
					List<Organization>savedorglist = orgdao.getOrganizationList();
					HashMap<String,String> savedorgdatamap= extractSavedOrgDataToMap(savedorglist);
					String dupinfo;
					//int total_node_cnt = savedorglist
					for(OrganizationData orgdata : orgdatalist)
					{
						if(!SerialnumberValidator.isInvalidSerialnumber(orgdata.getSlnumber()))
						{
							invalidsl.add(orgdata.getSlnumber());
							invalidcnt++;
							
							
						}
					
						else if((dupinfo = getDuplicateSlNumberInfo(orgdata.getSlnumber(),savedorgdatamap)) != null)
							duplicatesl += orgdata.getSlnumber() +" "+dupinfo+Symbols.NEWLINE;
						else
						{
							orgdatalisttosave.add(orgdata);
							savedsl+=orgdata.getSlnumber();
							savedcnt++;
							if(savedcnt==3)
							{
								savedsl+=Symbols.NEWLINE+" ";
								savedcnt=0;
							}
							
							 else 
								 savedsl+=",";
							
						}
					}
					boolean ret = true;
					batchtosave.setOrgdatalist(orgdatalisttosave);
					int nodesct = orgdatalisttosave.size();
					OrganizationDataDao orgdatadao = new OrganizationDataDao();	
					int savedsize = orgdatadao.getCurrentOrgDataSize(org.getName());
				    int remain = org.getNodesLimit() - savedsize;
				    if(nodesct > remain)
				    {
				    	status +="Nodes Limit Reached."+Symbols.NEWLINE;
				    }
				    else if(savedsl.trim().length() > 0 )
						ret = batchdao.addLoadBatch(batchtosave);
					
				    if(ret == true)
					{
				    	if(status == "")
				    	{
							if(savedsl.trim().length() > 0)
								status += "The Following serial Number"+(savedsl.contains(",")?"s are ":" is ")+" Saved Succesfully."+Symbols.NEWLINE+savedsl.substring(0,savedsl.length()-1)+Symbols.NEWLINE;
							if(invalidsl.size() > 0)
								status += Symbols.NEWLINE+"The Following serial Number"+(invalidsl.contains(",")?"s are ":" is ")+" Invalid."+Symbols.NEWLINE+invalidsl+Symbols.NEWLINE;
							if(duplicatesl.trim().length() > 0)
								status += Symbols.NEWLINE+"The Following serial Number"+(duplicatesl.contains(",")?"s are ":" is ")+" Already Exists."+Symbols.NEWLINE+duplicatesl+Symbols.NEWLINE;
				    	}
					}
					else if(!status.equals("Nodes Limit Reached."))
						status = "Save failed. Please Try Again";
				}
				else if(!status.equals("Nodes Limit Reached."))
					status = "Save failed. Please Try Again";
			}
			catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
				status = "Save failed. Please Try Again";
			}
		}
		else
			status = "Batch Name "+batchname+" is Already Exists.";
		request.getSession().setAttribute("status", status);
		response.sendRedirect("index.jsp");
	}

	private HashMap<String,String> extractSavedOrgDataToMap(List<Organization> savedorglist) {
		// TODO Auto-generated method stub
		HashMap<String,String> savedOrgDataMap = new HashMap<String,String>();
		for(Organization sorg : savedorglist)
		{
			List<LoadBatch> batchlist = sorg.getLoadBatchList();
			for(LoadBatch batch : batchlist)
			{
				for(OrganizationData orgdata :batch.getOrgdatalist())
				{
					savedOrgDataMap.put(orgdata.getSlnumber(),"[batch : "+batch.getBatchName()+" , Organization : "+sorg.getName()+"]");
				}
			}
		}
		return savedOrgDataMap;
	}

	private String getDuplicateSlNumberInfo(String slnumber, HashMap<String,String> savedOrgDataMap) {
		// TODO Auto-generated method stub
		return savedOrgDataMap.get(slnumber);
	}
}
