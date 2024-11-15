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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Enumeration;
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
import org.hibernate.exception.JDBCConnectionException;
import org.hibernate.internal.SessionImpl;

import com.nomus.m2m.dao.HibernateSession;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.M2MProperties;
import com.nomus.staticmembers.UserTempFile;

/**
 * Servlet implementation class M2MProcessController
 */
@WebServlet("/m2m/m2mprocessoldjdbc")
@MultipartConfig(fileSizeThreshold=1024*1024*20,
maxFileSize=1024*1024*100,      	
maxRequestSize=1024*1024*200)
public class M2MProcessControllerOldJDBC extends HttpServlet {
    private static final long serialVersionUID = 1L;
    final int OS_WINDOWS = 0;
    final int OS_LINUX = 1;
    User user=null;
    Properties props;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public M2MProcessControllerOldJDBC() {
        super();
        // TODO Auto-generated constructor stub
        
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
    	HttpSession httpsession = request.getSession();
        user = (User) httpsession.getAttribute("loggedinuser");
        int bulkupdate=0;
        int orgupdate=0;
        int bulkfile_valid;
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
        Connection con=null;
        Statement st=null;
        ResultSet rs=null;
        PreparedStatement ps=null;
        PreparedStatement bulk_det_ps = null;
        Session hibsession = HibernateSession.getDBSession();
        con = ((SessionImpl)hibsession).connection();
        try
        {
        if(con != null)
        con.setAutoCommit(false);
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        
        props = M2MProperties.getM2MProperties();
        
        String bulk_qry = "";
        String bulk_det_qry = "";
        
        String tlsconfigspath = props.getProperty("tlsconfigspath");
        targetfilename = props.getProperty("targetfilename")==null ? targetfilename : props.getProperty("targetfilename").trim();
        targetversionfile = props.getProperty("versionfile")==null ? targetversionfile : props.getProperty("versionfile").trim();
        if(tlsconfigspath != null && tlsconfigspath.trim().length() > 0)
        {
            final String load_str =  "config";
            final String edit_str =  "edit";
            final String reboot_str =  "reboot";
            final String upgrade_str =  "fwupgd";
            final String upgversion_str =  "upgdvrsn";
            final String bulk_load_str =  "bulk_config";
            final String filename_str =  "configfile";
            boolean bulk_valid= false;
            boolean valid = false;
            int bulkconfigid = 0;
            String status_str = "";
            String YES_STR ="yes";
            String NO_STR = "no";
            try
            {
                st = con.createStatement();
                Part bulkfilePart = request.getPart("bulk_configfile");
                String bulkfileName = getFileName(bulkfilePart);
                if(bulkfileName != null && bulkfileName.trim().length() > 0)
                {
                    bulk_valid = getFileValidStatus(bulkfilePart,targetfilename);
                    if(!bulk_valid)
                    {
                        status_str = "The selected file for Bulk Export is not valid";
                    }
                }
                else
                    bulk_valid = false;
                    
                
                String slnumber = "";
                int cversion=0;
                Timestamp conf_init_time;
                Timestamp upg_init_time;
                Timestamp reb_init_time;
                String bulkexportcheck="";
                String nodeid;
                String update_qry = "update Nodedetails set export=?,cversion=?,reboot=?,upgrade=?,upgradeversion=?,"
                        + "bulkupdate=?,orgupdate=?,sendconfig=?,bulkedit=?,configinittime=?,upgradeinittime=?,rebootinittime=? where slnumber=?";
                ps = con.prepareStatement(update_qry);
                String bluk_configtype = null;
                boolean batch_added = false;
                boolean bulk_bactch_added = false;
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
                Calendar  cal = Calendar.getInstance();
                String bulk_act_qry = "";
                if(bluk_configtype != null)
                {
                bulk_act_qry = "insert into bulkactivity (configtype,configtime,createdby,status) values ('"+bluk_configtype+"','"+cal.getTime()+"','"+user.getId()+"','InProgress')";
                
                int rows = st.executeUpdate(bulk_act_qry,Statement.RETURN_GENERATED_KEYS);
                if(rows > 0)
                    rs = st.getGeneratedKeys();
                if(rs.next())
                    bulkconfigid = rs.getInt(1);
                
                
                bulk_det_qry = "insert into bulkactivitydetails(configid,configtime,configtype,slnumber,status) values (?,?,?,?,?)";
                
                bulk_det_ps = con.prepareStatement(bulk_det_qry);
                }
                String sql = "select slnumber,cversion,configinittime,upgradeinittime,rebootinittime,id from Nodedetails order by slnumber";
                
                rs = st.executeQuery(sql);
                while(rs.next())
                {
                    bulkupdate = 0;
                    orgupdate = 0;
                    slnumber = rs.getString(1);
                    cversion = rs.getInt(2);
                    conf_init_time = rs.getTimestamp(3);
                    upg_init_time = rs.getTimestamp(4);
                    reb_init_time = rs.getTimestamp(5);
                    nodeid = rs.getString(6);
                    //System.out.println("request.getParameter("+slnumber+""+load_str+") is :" + request.getParameter(nodeid+load_str));
                    //System.out.println("request.getParameter("+slnumber+""+reboot_str+") is :" + request.getParameter(nodeid+reboot_str));
                    //System.out.println("request.getParameter("+slnumber+""+upgrade_str+") is :" + request.getParameter(nodeid+upgrade_str));
                    //System.out.println("request.getParameter("+slnumber+""+edit_str+") is :" +request.getParameter(nodeid+edit_str));
                    if(request.getParameter(nodeid+load_str) != null ||  request.getParameter(nodeid+reboot_str) != null
                            || request.getParameter(nodeid+upgrade_str) != null || request.getParameter(nodeid+edit_str) != null)
                    {
                        if(request.getParameter(nodeid+load_str) != null)
                        {
                            Part filePart = request.getPart(slnumber+filename_str);
                            String fileName="";
                            if(bulkfileName.trim().length() > 0 && bulk_valid)
                            {
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
                                    if(!valid)
                                    {
                                        non_processed_str +=" , "+slnumber;
                                    }
                                }
                            }
                            
                            fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
                            
                            if(fileName != null && fileName.length() > 0 && valid)
                            {
                                boolean proceed = LoadConfigFile(tlsconfigspath,slnumber,filePart,targetfilename,cversion+1,targetversionfile);
                                ps.setString(1, proceed?YES_STR:NO_STR);
                                ps.setInt(2, proceed?cversion+1:cversion);
                                if(proceed)
                                    ps.setTimestamp(10,new Timestamp(cal.getTimeInMillis()));
                                else
                                    ps.setTimestamp(10,conf_init_time);
                                processed_str += " , "+slnumber;
                            }
                            else
                            {
                                ps.setString(1, NO_STR);
                                ps.setInt(2, cversion);
                                ps.setTimestamp(10,conf_init_time);
                            }
                           
                        }
                        else
                        {
                            ps.setString(1, NO_STR);
                            ps.setInt(2, cversion);
                            ps.setTimestamp(10,conf_init_time);
                        }

                        ps.setString(3, request.getParameter(nodeid+reboot_str) != null?YES_STR:NO_STR);
                        if(request.getParameter(nodeid+reboot_str) != null)
                        	ps.setTimestamp(12,new Timestamp(cal.getTimeInMillis()));
                        else
                            ps.setTimestamp(12,reb_init_time);
                        	

                        if(request.getParameter(nodeid+upgrade_str) != null)
                        {
                            String version = request.getParameter(nodeid+upgversion_str);
                            ps.setString(4, version.length()>0?YES_STR:NO_STR);
                            ps.setString(5, version.length()>0?version:"");
                            ps.setTimestamp(11,new Timestamp(cal.getTimeInMillis()));
                        }
                        else
                        {
                            ps.setString(4, NO_STR);
                            ps.setString(5, "");
                            ps.setTimestamp(11,upg_init_time);
                        }
                        ps.setInt(6, bulkupdate);
                        ps.setInt(7, orgupdate);
                        
                        if(request.getParameter(nodeid+edit_str) != null)
                        {
                            //File bulkeditdir = new File(tlsconfigspath+File.separator+"Bulk-Edit");
                        	File bulkeditdir = UserTempFile.getUserTempDir(user, "Bulk-Edit");
                            if(!bulkeditdir.exists())
                                bulkeditdir.mkdir();
                            
                            File srcfile = new File(bulkeditdir.getAbsolutePath()+File.separator+targetfilename);
                            File desfile = new File(tlsconfigspath+File.separator+slnumber+File.separator+targetfilename);
                            if(srcfile.exists())
                            {
                                boolean proceed = copyFileAndChangeVersion(slnumber,srcfile.toPath(), desfile.toPath(),tlsconfigspath,cversion+1,targetversionfile);
                                if(proceed)
                                {
                                    ps.setInt(2, proceed?cversion+1:cversion);
                                    ps.setString(8,YES_STR);
                                    ps.setInt(9,1);
                                    ps.setTimestamp(10,new Timestamp(cal.getTimeInMillis()));
                                    processed_str += " , "+slnumber;
                                }
                            }
                            else
                            {
                                ps.setString(8,NO_STR);
                                ps.setInt(9,0);
                            }
                                
                        }
                        else
                        {
                            ps.setString(8,NO_STR);
                            ps.setInt(9,0);
                        }
                        ps.setString(13, slnumber);
                        ps.addBatch();
                        batch_added = true;
                        
                        if(bluk_configtype != null)
                        {
                            //configid,configtime,configtype,slnunmber,status
                            if(bulkconfigid != 0)
                            {
                                bulk_det_ps.setInt(1, bulkconfigid);
                                bulk_det_ps.setTimestamp(2, new Timestamp(cal.getTimeInMillis()));
                                bulk_det_ps.setString(3, bluk_configtype);
                                bulk_det_ps.setString(4, slnumber);
                                bulk_det_ps.setString(5, "InProgress");
                                bulk_det_ps.addBatch();
                                bulk_bactch_added = true;
                            }
                        }
                    }
                }
                if(batch_added)
                    ps.executeBatch();
                if(bulk_bactch_added)
                    bulk_det_ps.executeBatch();
                
                con.commit();
                System.out.println("batch executed....");
            }
            catch(JDBCConnectionException  e) {
                try {
                    con.rollback();
                    }
                    catch (SQLException se) {
                        // TODO: handle exception
                        se.printStackTrace();
                    }
                System.out.println("================ {{{");
                SQLException current = e.getSQLException();
                do {
                   current.printStackTrace();
                } while ((current = current.getNextException()) != null);
                System.out.println("================ }}}");
                throw e;
               
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
                     // TODO: handle exception
                     e.printStackTrace();
                 }
                try {
                    if(rs != null)
                        rs.close();
                    if(st != null)
                        st.close();
                    if(ps != null)
                        ps.close();
                    if(bulk_det_ps != null)
                        bulk_det_ps.close();
                    //if(con !=null)                     //dont use con.close as session is closed at line 388 
                       // con.close();  // if connection is gettting from session the close the session instead of connction.
                }
                catch (Exception e) {
                    // TODO: handle exception
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
        }
        else
        {
            //RequestDispatcher rd = request.getRequestDispatcher("iport/error.jsp?error=Please Configure m2m.prperties in etc");
            //rd.forward(request, response);
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
        /*Runtime rt  = Runtime.getRuntime();
        Process pr = null;
        String os = System.getProperty("os.name");

        try {
            if(os.toLowerCase().startsWith("windows"))
            {
                pr = rt.exec("cmd /c openssl enc -aes-128-cbc -d -in WiZ_NG.dat -out Startup_Configurations.tar.gz -k nomuscomm",null, targetdir);
                printResults(pr);
                pr = null;
                pr = rt.exec("cmd /c tar -xf Startup_Configurations.tar.gz -C ./ ",null, targetdir);
                printResults(pr);
                pr = null;
            }
            else
            {
                pr = rt.exec("openssl enc -aes-128-cbc -d -in WiZ_NG.dat -out Startup_Configurations.tar.gz -k nomuscomm",null, targetdir);
                printResults(pr);
                pr = null;
                pr = rt.exec("tar -xf Startup_Configurations.tar.gz -C ./ ",null, targetdir);
                printResults(pr);
                pr = null;
            }
            */
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
            FileUtils.deleteDirectory(targetdir);
            
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return valid;
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
                long size = zipEntry.getSize();
                long compressedSize = zipEntry.getCompressedSize();

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
            out = new FileOutputStream(
                                       new File(tlsconfigspath+File.separator+slnumber+File.separator+targetversionfile));
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
            for (String content : part.getHeader("content-disposition").split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(
                            content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
            return null;
        }
}
