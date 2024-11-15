package com.nomus.m2m.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Properties;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.staticmembers.M2MProperties;

import net.sf.json.JSONObject;

/**
 * Servlet implementation class FileDeleteController
 */
@WebServlet("/FileDeleteController")
public class FileDeleteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FileDeleteController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		 String delpath = request.getParameter("delpath");
		 String page = request.getParameter("page");
		 String slnumber = request.getParameter("slnumber");
		 String version = request.getParameter("version");
		 String instname = request.getParameter("name");
		 String filetype = request.getParameter("filetype");
		 String status = "failed";
		 String msg = "";
		 msg = delselectFile(instname,page,slnumber,version,delpath,filetype);
		 if(msg.equals("success"))
		 {
			 File testfile  = new File(delpath);
			 boolean deleted = false;
			 try
			 {
				 deleted = testfile.delete();
			 }
			 catch (Exception e) {
				// TODO: handle exception
			}
			 status = deleted ? "success":"failed";
		 }
		 else if(msg.length() > 0 && !msg.equals("failed"))
		 {
			 status = msg;
		 }
			
		response.sendRedirect("/imission/m2m/"+page+"?slnumber="+slnumber+"&version="+version+"&status="+status+"&name="+instname);
	}

	private String delselectFile(String instname, String page, String slnumber, String version ,String delpath,String jsonkey) {
		// TODO Auto-generated method stub
		  JSONObject wizjsonnode = null;
		String certificatedir=null;
		   FileReader propsfr = null;
		   JSONObject openvpnobj = null;
		   JSONObject vpnobj = null;
		   BufferedReader jsonreader = null; 
		   String delfilename="";
		   String msg = "";
		   boolean removed = false;
		   if(slnumber != null && slnumber.trim().length() > 0)
		   {
			   Properties m2mprops = M2MProperties.getM2MProperties();
			   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
			   certificatedir = m2mprops.getProperty("tlsconfigspath")+"/"+slnumber+"/WiZ_NG/Startup_Configurations/certificates";
			   try {
				   jsonreader=new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
			} catch (FileNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			   StringBuilder jsonbuf = new StringBuilder("");
			   String jsonString="";
			   try
			   {
					while((jsonString = jsonreader.readLine())!= null)
		   			jsonbuf.append( jsonString );
					wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
					openvpnobj = wizjsonnode.containsKey("openvpn")?wizjsonnode.getJSONObject("openvpn"):new JSONObject();
					vpnobj = openvpnobj.containsKey("openvpn:"+instname)?openvpnobj.getJSONObject("openvpn:"+instname):new JSONObject();
					
					/*if(delpath_lower.contains("/client"))
					{
						if(delpath_lower.endsWith(".crt"))
						{
							delfilename=delpath.substring(delpath.replace("\\", "/").lastIndexOf("/")+1);
							selfilename=vpnobj.containsKey("cert")?vpnobj.getString("cert"):"";
							if(selfilename.endsWith(delfilename))
								jsonkey = "cert";
						}
						else if(delpath_lower.endsWith(".key"))
						{
							delfilename=delpath.substring(delpath.replace("\\", "/").lastIndexOf("/")+1);
							selfilename=vpnobj.containsKey("key")?vpnobj.getString("key"):"";
							if(selfilename.endsWith(delfilename))
								jsonkey = "key";
						}
					}
					else if(delpath_lower.contains("/hmac"))
					{
						delfilename=delpath.substring(delpath.replace("\\", "/").lastIndexOf("/")+1);
						selfilename=vpnobj.containsKey("tls_auth")?vpnobj.getString("tls_auth"):"";
						if(selfilename.endsWith(delfilename))
							jsonkey = "tls_auth";
					}
					else if(delpath_lower.contains("/user"))
					{
						delfilename=delpath.substring(delpath.replace("\\", "/").lastIndexOf("/")+1);
						selfilename=vpnobj.containsKey("auth_user_pass")?vpnobj.getString("auth_user_pass"):"";
						if(selfilename.endsWith(delfilename))
							jsonkey = "auth_user_pass";
					}
					else if(delpath_lower.contains("/psk"))
					{
						delfilename=delpath.substring(delpath.replace("\\", "/").lastIndexOf("/")+1);
						selfilename=vpnobj.containsKey("secret")?vpnobj.getString("secret"):"";
						if(selfilename.endsWith(delfilename))
							jsonkey = "secret";
					}
					else
					{
						delfilename=delpath.substring(delpath.replace("\\", "/").lastIndexOf("/")+1);
						selfilename=vpnobj.containsKey("ca")?vpnobj.getString("ca"):"";
						if(selfilename.endsWith(delfilename))
							jsonkey = "ca";
					}*/
					delfilename=delpath.substring(delpath.replace("\\", "/").lastIndexOf("/")+1);
					if(jsonkey.length() > 0)
					{
						Set<String> keyset = openvpnobj.keySet();
						for(String key : keyset)
						{
							if(!key.equals("openvpn:"+instname))
							{
								JSONObject tunobj = openvpnobj.getJSONObject(key);
								if(tunobj.containsKey(jsonkey) && tunobj.getString(jsonkey).endsWith(delfilename))
								{
									msg = "Cannot delete the file "+delfilename+ " as it is used in another Instance "+key.replace("openvpn:", "");
									
									break;
								}
							}
							
						}
						String selfilename = vpnobj.containsKey(jsonkey)?vpnobj.getString(jsonkey):"";
						if(!selfilename.endsWith(delfilename))
						{
							jsonkey = "";
						}
						if(msg.length() == 0 && jsonkey.length() > 0)
						{
							vpnobj.remove(jsonkey);
							openvpnobj.put("openvpn:"+instname, vpnobj);
							wizjsonnode.put("openvpn", openvpnobj);
							BufferedWriter jsonWriter = null;
							try
							{
								jsonWriter = new BufferedWriter(new FileWriter(slnumpath+File.separator+"Config.json"));
								jsonWriter.write(wizjsonnode.toString(2));
								removed = true;
							}
							catch(Exception e)
							{
								e.printStackTrace();
							}
							finally
							{
								if(jsonWriter != null)
									jsonWriter.close();
							}
						}
						else if(msg.length() == 0)
						{
							removed = true;
						}
					}
					
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
			   }
			   finally
			   {
				   if(propsfr != null)
					try {
						propsfr.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				   if(jsonreader != null)
					try {
						jsonreader.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			   }
		   }
		    if(removed)
		    	msg = "success";
		    else if(msg.length() == 0)
		    	msg = "failed";
		    
		    return msg;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

}
