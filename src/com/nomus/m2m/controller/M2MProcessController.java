package com.nomus.m2m.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.commons.io.FileUtils;
import org.hibernate.Session;

import com.nomus.m2m.dao.BulkActivityDao;
import com.nomus.m2m.dao.HibernateSession;
import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.pojo.BulkActivity;
import com.nomus.m2m.pojo.BulkActivityDetails;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.ActivityStatus;
import com.nomus.staticmembers.ConfigActions;
import com.nomus.staticmembers.M2MProperties;
import com.nomus.staticmembers.NumberTester;
import com.nomus.staticmembers.Symbols;
import com.nomus.staticmembers.TripleDES;
import com.nomus.staticmembers.UserTempFile;

import net.sf.json.JSONObject;

/**
 * Servlet implementation class M2MProcessController
 */
@WebServlet("/m2m/m2mprocess")
@MultipartConfig(fileSizeThreshold=1024*1024*20,
maxFileSize=1024*1024*100,      	
maxRequestSize=1024*1024*200)
public class M2MProcessController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    final int OS_WINDOWS = 0;
    final int OS_LINUX = 1;
    User user=null;
    Properties props;
    private static String FILE_CORRUPED = "corrupted-100";
       
   
    public M2MProcessController() {
        super();
        // TODO Auto-generated constructor stub
        
    }

 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doPost(request,response);
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
    	HttpSession httpsession = request.getSession();
        user = (User) httpsession.getAttribute("loggedinuser");
        int bulkupdate=0;
        int orgupdate=0;
        boolean is_bulk_edit = false;
        boolean is_bulk_export = false;
        boolean is_bulk_reboot = false;
        boolean is_bulk_upgrade = false;
        String liconfigtype = request.getParameter("configtype");
        String lisubmenu = request.getParameter("lisubmenu");
        String targetfilename = "WiZ_NG.zip";
        String targetversionfile = "version.txt";
        String processed_str="";
        String non_processed_str="";
        //MultipartConfigElement MULTI_PART_CONFIG = new MultipartConfigElement(System.getProperty("java.io.tmpdir"));
        //request.setAttribute(Request.__MULTIPART_CONFIG_ELEMENT, MULTI_PART_CONFIG);
        response.setContentType("text/html;charset=UTF-8");
        Session hibsession = HibernateSession.getDBSession();
        props = M2MProperties.getM2MProperties();	
        
        String tlsconfigspath = props.getProperty("tlsconfigspath");
        targetfilename = props.getProperty("targetfilename")==null ? targetfilename : props.getProperty("targetfilename").trim();
        targetversionfile = props.getProperty("versionfile")==null ? targetversionfile : props.getProperty("versionfile").trim();
        if(tlsconfigspath != null && tlsconfigspath.trim().length() > 0)
        {
            final String upgversion_str =  "upgdvrsn";
            final String filename_str =  "configfile";
            boolean bulk_valid= false;
            boolean valid = false;
            boolean fwmatched = false;
            String bulk_filefwversion = "";
            String filefwversion="";
            String status_str = "";
            String YES_STR ="yes";
            String NO_STR = "no";
            try
            {
                Part bulkfilePart = request.getPart("bulk_configfile");
                String bulkfileName = getFileName(bulkfilePart);
                if(bulkfileName != null && bulkfileName.trim().length() > 0)
                {
                    bulk_valid = getFileValidStatus(bulkfilePart,targetfilename);
                    File targetdir = new File(user.getUsername()+"tmp");
                    bulk_filefwversion = getFirmwareVerionInFile(targetdir);
                    if(!bulk_valid)
                    {
                        status_str = "The selected file for Bulk Export is not valid";
                    }
                }
                else
                    bulk_valid = false;  
                
                String slnumber = "";
                int cversion=0;
                String fwver = "";
                String bluk_configtype = null;
                if(request.getParameter("bulk_upgd") != null)
                {
                    is_bulk_upgrade = true;
                    bluk_configtype = "Upgrade";
                }
                else if(request.getParameter("bulk_config") != null)
                {
                    is_bulk_export = true;
                    bluk_configtype="Export";
                }
                else if(request.getParameter("bulk_edit") != null)
                {
                    is_bulk_edit = true;
                    bluk_configtype="Edit";
                }
                else if(request.getParameter("bulk_reboot") != null)
                {
                    is_bulk_reboot = true;
                    bluk_configtype="Reboot";
                }
                Enumeration<String> paramenm = request.getParameterNames();
                List<Integer> nodeidlist = new ArrayList<Integer>();
                while(paramenm.hasMoreElements())
                {
                	String param = paramenm.nextElement();
                	String nodeidstr = "";
                	if(param.endsWith(ConfigActions.EDIT))
                		nodeidstr = param.replace(ConfigActions.EDIT, "").trim();
                	else if(param.endsWith(ConfigActions.CONFIG))
                		nodeidstr = param.replace(ConfigActions.CONFIG, "").trim();
                	else if(param.endsWith(ConfigActions.UPGRADE))
                		nodeidstr = param.replace(ConfigActions.UPGRADE, "").trim();
                	else if(param.endsWith(ConfigActions.REBOOT))
                		nodeidstr = param.replace(ConfigActions.REBOOT, "").trim();
                	else 
                		continue;
                	
                	if(NumberTester.isInteger(nodeidstr))
                	nodeidlist.add(Integer.parseInt(nodeidstr));
                	
                }
                NodedetailsDao ndao = new NodedetailsDao();
                List<NodeDetails> ndetlist = ndao.getNodeList("id", nodeidlist);
                List<BulkActivityDetails> bulk_act_list = new ArrayList<BulkActivityDetails>();
                Date curtime = Calendar.getInstance().getTime();
                for(NodeDetails node : ndetlist)
                {
                	bulkupdate = 0;
                	orgupdate = 0;
                	slnumber = node.getSlnumber();
                	cversion = node.getCversion();
                	fwver = node.getFwversion();

                	if(request.getParameter(node.getId()+ConfigActions.CONFIG) != null)
                	{
                		Part filePart = request.getPart(slnumber+filename_str);
                		String fileName="";
                		if(bulkfileName.trim().length() > 0 && bulk_valid)
                		{
                			if((fwver.startsWith(Symbols.WiZV2) && !fwver.startsWith(bulk_filefwversion)) 
            						|| (fwver.startsWith(Symbols.WiZV1) && !fwver.startsWith(bulk_filefwversion))
            						|| bulk_filefwversion.equals(FILE_CORRUPED))
            				{
            					non_processed_str +=" , "+slnumber+"- Version not Matched";
            					fwmatched =false;
            				}
                			else
                				fwmatched =true;
                			valid = true;
                			fileName = bulkfileName;
                			filePart = bulkfilePart;
                			bulkupdate=1;
                		}
                		else
                		{

                			fileName= getFileName(filePart);
                			if(fileName == null)
                				valid  =false;
                			else 
                			{
                				valid = getFileValidStatus(filePart,targetfilename);
                				File targetdir = new File(user.getUsername()+"tmp");
                				filefwversion = getFirmwareVerionInFile(targetdir);
                				if(!valid)
                				{
                					non_processed_str +=" , "+slnumber;
                				}
                				//code to do here
                				else if((fwver.startsWith(Symbols.WiZV2) && !fwver.startsWith(filefwversion)) 
                						|| (fwver.startsWith(Symbols.WiZV1) && !fwver.startsWith(filefwversion))
                						|| filefwversion.equals(FILE_CORRUPED))
                				{
                					non_processed_str +=" , "+slnumber+"- Version not Matched";
                					fwmatched =false;
                				}
                				else 
                					fwmatched =true;
                			}
                		}

                		fileName = fileName.substring(fileName.lastIndexOf("\\")+1);

                		if(fileName != null && fileName.length() > 0 && valid && fwmatched)
                		{
                			boolean proceed = LoadConfigFile(tlsconfigspath,slnumber,filePart,targetfilename,cversion+1,targetversionfile);
                			node.setExport(proceed?YES_STR:NO_STR);
                			node.setCversion(proceed?cversion+1:cversion);
                			if(proceed)
                				node.setConfiginittime(curtime);
                			processed_str += " , "+slnumber;
                		}
                	}

                	if( request.getParameter(node.getId()+ConfigActions.REBOOT) != null)
                	{
                		node.setReboot(YES_STR);
                		node.setRebootinittime(curtime);
                	}
                	if(request.getParameter(node.getId()+ConfigActions.UPGRADE) != null)
                	{
                		String version = request.getParameter(slnumber+upgversion_str);
                		node.setUpgrade(YES_STR);
                		node.setUpgradeversion(version.length()>0?version:"");
                		node.setUpgradeinittime(curtime);
                	}

                	node.setBulkupdate(bulkupdate);
                	node.setOrgupdate(orgupdate);

                	if(request.getParameter(node.getId()+ConfigActions.EDIT) != null)
                	{
                		File tmpbulkeditdir = UserTempFile.getUserTempDir(user, "Bulk-Edit");
                		if(!tmpbulkeditdir.exists())
                			tmpbulkeditdir.mkdir();

                		File srcfile = new File(tmpbulkeditdir.getAbsolutePath()+File.separator+targetfilename);
                		File desfile = new File(tlsconfigspath+File.separator+slnumber+File.separator+targetfilename);
                		if(srcfile.exists())
                		{
                			boolean proceed = copyFileAndChangeVersion(slnumber,srcfile.toPath(), desfile.toPath(),tlsconfigspath,cversion+1,targetversionfile);
                			if(proceed)
                			{
                				node.setCversion(node.getCversion()+1);
                				node.setSendconfig(YES_STR);
                				node.setBulkedit(1);
                				node.setConfiginittime(curtime);
                				processed_str += " , "+slnumber;
                			}
                		}
                	}

                	if(bluk_configtype != null)
                	{
                		BulkActivityDetails bact_det = new BulkActivityDetails();
                		bact_det.setConfigtime(curtime);
                		bact_det.setConfigtype(bluk_configtype);
                		bact_det.setSlnumber(slnumber);
                		bact_det.setStatus("InProgress");
                		bulk_act_list.add(bact_det);
                	}
                }
                
                if(ndetlist.size() > 0)
                {
                	ndao.updateNodelist(ndetlist);
                }
                if(bulk_act_list.size() > 0)
                {
                	BulkActivity bulk_act = new BulkActivity();
                	bulk_act.setConfigtime(curtime);
                	bulk_act.setConfigtype(bluk_configtype);
                	bulk_act.setCreatedby(user);
                	bulk_act.setOrganization(user.getOrganization().getName());
                	bulk_act.setSuperior(user.getUnder());
                	bulk_act.setStatus(ActivityStatus.INPROGRESS);
                	bulk_act.setBulkActivityDetList(bulk_act_list);
                	
                	BulkActivityDao bulkactgao = new BulkActivityDao();
                	bulkactgao.addBulkConfig(bulk_act);
                }
            }
            catch (Throwable ex)
            {
                ex.printStackTrace();
            }
            finally
            {
            	try
            	{
            		if(hibsession != null)
            		{
            			hibsession.disconnect();
            			hibsession.close();
            		}
            		
            	}
            	 catch (Exception e) {
                     e.printStackTrace();
                 }
            }
            //RequestDispatcher rd = request.getRequestDispatcher("iport/message.jsp?status=Saved successfully");
            //rd.forward(request, response);
            if(status_str.trim().length() == 0 && non_processed_str.trim().length() == 0)
                status_str = "Saved Successfully.";
            HttpSession session =  request.getSession();
            session.setAttribute("m2mprocessstatus", status_str);
            session.setAttribute("processed", processed_str);
            session.setAttribute("failed", non_processed_str);
            response.sendRedirect("m2m.jsp?configtype="+liconfigtype+"&lisubmenu="+lisubmenu);
            try {
				UserTempFile.createOrRemoveTempBulkEditFiles(user,"false");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
        else
        {
            //RequestDispatcher rd = request.getRequestDispatcher("iport/error.jsp?error=Please Configure m2m.prperties in etc");
            //rd.forward(request, response);
        	try {
				UserTempFile.createOrRemoveTempBulkEditFiles(user,"false");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            response.sendRedirect("iport/error.jsp?error=Please Configure m2m.prperties in etc");
        }

    }

   
    private boolean getFileValidStatus(Part filePart,String targetfilename)
    {
        //String strTmp = System.getProperty("java.io.tmpdir");
        OutputStream out = null;
        InputStream filecontent = null;
        File testfile = null;
        boolean status = false;
        File targetdir = new File(user.getUsername()+"tmp");
        //File targetdir = UserTempFile.getUserTempDir(user, "config");
        
        if(!targetdir.exists())
            targetdir.mkdir();
        testfile = new File(targetdir.getAbsolutePath()+File.separator+targetfilename);
        try {
            out = new FileOutputStream(testfile);
            filecontent = filePart.getInputStream();
            int read = 0;
            final byte[] bytes = new byte[1024];

            while ((read = filecontent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
           
        } catch (IOException fne) {
            fne.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
            if (filecontent != null) {
                try {
                    filecontent.close();
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
        
        if(testfile != null)
        {
             status = isvaildFile(testfile,targetdir);
        }
            return status;   
    }
    
    private boolean isvaildFile(File testfile,File targetdir) {
        // TODO Auto-generated method stub
        boolean valid = false;
        try {
        unzipFile(testfile,targetdir);
       
            File validationfile = new File(targetdir+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations"+File.separator+"M2MValidation.txt");
            //System.out.println("validationfile is : "+validationfile.getAbsolutePath());
            if(validationfile.exists())
            {
                //System.out.println("validationfile is : "+validationfile.getAbsolutePath()+" and is exists.");
                BufferedReader br = null;
                try
                {
                    br = new BufferedReader(new FileReader(validationfile));
                    String str;
                    while((str = br.readLine()) != null)
                    {
                        if(str.toLowerCase().trim().startsWith("valid"))
                            valid = true;
                        break;
                    }
                }
                catch (Exception e) {
                    // TODO: handle exception
                    e.printStackTrace();
                }
                finally {
                    if(br != null)
                    br.close();
                }
                
            }
            //FileUtils.deleteDirectory(targetdir);
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return valid;
       
    }
    private String getFirmwareVerionInFile(File targetdir) {
    	String fwversion = "";
    	StringBuffer sb = new StringBuffer();
    	try {
    		File configfile = new File(targetdir+File.separator+"WiZ_NG"+File.separator+"Startup_Configurations"+File.separator+"Config.json");
    		if(configfile.exists())
    		{
    			BufferedReader br = null;
    			try {
    				br = new BufferedReader(new FileReader(configfile));
    				String line;
    				while((line = br.readLine()) != null)
    				{
    					sb.append(line+"\n");	
    				}
    			}catch (Exception e) {
    				// TODO: handle exception
    				e.printStackTrace();
    			}
    			JSONObject configjson =JSONObject.fromObject(sb.toString());
    			JSONObject m2mobject = configjson.getJSONObject("m2m").getJSONObject("m2m:m2m");
    			String version = m2mobject.containsKey("version")?m2mobject.getString("version").toString():"";
    			String enc = m2mobject.containsKey("enc")?m2mobject.getString("enc").toString():"";
    			version = version.trim();
    			enc = enc.trim();
    			if(version.length() > 0 && enc.length() > 0)
    			{
    				TripleDES tripledes = new TripleDES();
    				String decstr = tripledes.decrypt(enc);
    				if(version.equals(decstr))
    					fwversion = version;
    				else
    					fwversion = FILE_CORRUPED;
    			}
    			else if(configjson.containsKey("NETWORKCONFIG"))
    				fwversion = Symbols.WiZV1;
    			else
    				fwversion = FILE_CORRUPED;
    		}
    		FileUtils.deleteDirectory(targetdir);
    	} catch (Exception e) {
			e.printStackTrace();
		}
		return fwversion;
		
	}


	public void unzipFile(File testfile,File targetdir)
    {
        try {
            // Open the zip file
            ZipFile zipFile = new ZipFile(testfile.getAbsolutePath());
            Enumeration<?> enu = zipFile.entries();
            File desDir = new File(targetdir+File.separator+"WiZ_NG");
            if(!desDir.exists())
                desDir.mkdir();
            while (enu.hasMoreElements()) {
                ZipEntry zipEntry = (ZipEntry) enu.nextElement();
                String name = zipEntry.getName();
                if(!name.contains(desDir.getAbsolutePath()))
                    name = desDir.getAbsolutePath()+File.separator+name;
                // Do we need to create a directory ?
                File file = new File(name);
                
                if (name.endsWith("/")) {
                    file.mkdirs();
                    continue;
                } 
                
                File parent = file.getParentFile();
                if (parent != null) {
                    parent.mkdirs();
                }

                // Extract the file
                InputStream is = zipFile.getInputStream(zipEntry);
                FileOutputStream fos = new FileOutputStream(file);
                byte[] bytes = new byte[1024];
                int length;
                while ((length = is.read(bytes)) >= 0) {
                    fos.write(bytes, 0, length);
                }
                is.close();
                fos.close();

            }
            zipFile.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void printResults(Process process) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line = "";
        try
        {
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            
            reader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
        }
        catch (Exception e) {
            // TODO: handle exception
        }
        finally
        {
            if(reader != null)
                try {
                    reader.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
        }
    }
    private boolean copyFileAndChangeVersion(String slnumber,Path srcpath,Path despath,String tlsconfigspath,int cversion,String targetversionfile)
    {

        OutputStream out = null;
        boolean copied = false;
        try {
            Files.copy(srcpath, despath, StandardCopyOption.REPLACE_EXISTING);
            copied = true;
            out = new FileOutputStream(new File(tlsconfigspath+File.separator+slnumber+File.separator+targetversionfile));
            out.write((cversion+"").getBytes());
            copied =  true;
        } catch (Exception fne) {
        } finally {
            try
            {
            if (out != null)
                out.close();
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
        }
        return copied;
    
    }
    private boolean LoadConfigFile(String path,String slnumber,Part filePart,String targetfilename,int cversion,String targetversionfile) throws IOException
    {
        OutputStream out = null;
        InputStream filecontent = null;
        boolean coppied = false;
        File targetdir = new File(path+File.separator+slnumber);
        if(!targetdir.exists())
            targetdir.mkdir();
        try {
            out = new FileOutputStream(
                     new File(path+File.separator+slnumber+File.separator+targetfilename));
            filecontent = filePart.getInputStream();
            int read = 0;
            final byte[] bytes = new byte[1024];

            while ((read = filecontent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
            out.close();
            out = new FileOutputStream(
                                       new File(path+File.separator+slnumber+File.separator+targetversionfile));
            out.write((cversion+"").getBytes());
            coppied =  true;
        } catch (FileNotFoundException fne) {
        } finally {
            if (out != null) {
                out.close();
            }
            if (filecontent != null) {
                filecontent.close();
            }
        }
        return coppied;
    }
     private String getFileName(final Part part) {
    	    if(part == null)
    	    	return null;
            //final String partHeader = part.getHeader("content-disposition");
            for (String content : part.getHeader("content-disposition").split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(
                            content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
            return null;
        }
}
