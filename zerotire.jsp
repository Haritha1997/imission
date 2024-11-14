<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
<% 
	String slnumber=request.getParameter("slnumber");
	/* out.println("slnumber: "+slnumber);  */
 	String version=request.getParameter("version");
	String errorstr = request.getParameter("error");
	JSONObject wizjsonnode = null;
	JSONObject ztjsonobj = null;
	JSONObject my_zt_net = null;
	/* JSONObject v1 = null; */
	   JSONArray edit_natrules_arr = null;
	   JSONObject zerotirepage = null;
	   BufferedReader jsonfile = null;  
	   boolean enabled = false;
	   if(slnumber != null && slnumber.trim().length() > 0)
	   {
		   Properties m2mprops = M2MProperties.getM2MProperties();
		   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
		   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
		   StringBuilder jsonbuf = new StringBuilder("");
		   String jsonString="";
		   try
		   {
				while((jsonString = jsonfile.readLine())!= null)
	   			jsonbuf.append( jsonString );
				wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
				ztjsonobj = wizjsonnode.containsKey("zerotier")?wizjsonnode.getJSONObject("zerotier"):new JSONObject();
		   }
		   catch(Exception e)
		   {
			   e.printStackTrace();
		   }
		   finally
		   {
			   if(jsonfile != null)
				   jsonfile.close();
		   }
	   }
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/site-assets.css">
    <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
    <script src="js/ZeroTier.js"></script>
    <script type="text/javascript" src="js/common.js"></script>
  <!--   
    <style>
        p{
        padding: 10px;
        }
        select
        {
            min-width:80px;
            width:80px;
            max-width:80px;
        }
        input[type=number]
        {
            width:100px;
            max-width: 100px;
            min-width: 100px;
        }
        .borderlesstab td
        {
            padding:3px;
        }
    </style> -->
    <script>
    function showErrorMsg(errormsg)
    {
    	alert(errormsg);
    }
        function validatezerotier(){
            var alertmsg = "";
            var zerotiertable = document.getElementById("zerotiertb");
            var zerotierrows = zerotiertable.rows;
            try {
                for(var i=1; i<zerotierrows.length; i++){
                    var cols = zerotierrows[i].cells;
                    var nameobj = cols[1].childNodes[0];
                    var networkidobj = cols[2].childNodes[0];
					/* var actobj=cols[3].childNodes[0].childNodes[0];
                    // if(!checkAlphaNUmeric(nameobj.id))
		            //     return false;
					if(actobj!=null&&!actobj.checked)
					{
						 alertmsg += "First check the firewall(portforward) and if any entry configured with zerotire then delete that entity while deactivating the activation.\n";
						 actobj.checked=true;
					} */
					if(nameobj.value.trim() == ""){
                        alertmsg += "Name " + i + " Should not be empty\n";
                        nameobj.style.outline = "thin solid red";
                        nameobj.title = "Name " + i + " Should not be empty";
                    }
                    else if(!isValidAlphaNumberic(nameobj.id)){
                        alertmsg += "Please Use Only AlphaNumeric for Name in the row " + i + "\n";
                      
                    }
                    else{
                        nameobj.style.outline = "initial";
                        nameobj.title = "";
                    }
                    
                    if(networkidobj.value.trim() == ""){
                        alertmsg += "Network ID " + i + " Should not be empty\n";
                        networkidobj.style.outline = "thin solid red";
                        networkidobj.title = "Networke ID" + i + " Should not be empty";
                    }
                    else if(!isValidAlphaNumberic(networkidobj.id)){
                        alertmsg += "Please Use Only AlphaNumeric for Network ID in the row " + i + "\n";
                     
                    }
                    
                    else if(networkidobj.value.length<16){
                        alertmsg += "Network ID " + i +" Should be 16 AlphaNumeric Characters\n";
                        networkidobj.style.outline = "thin solid red";
                    }
                    else{
                        networkidobj.style.outline = "initial";
                        networkidobj.title = "";
                    }

                    var i_name_val = nameobj.value;
                    var i_networkid_val = networkidobj.value;
                    var firstdone = false;
                    var secondone = false;
                    for(var j=1; j<zerotierrows.length; j++){
                        cols = zerotierrows[j].cells;
                        var j_nameobj = cols[1].childNodes[0];
                        var j_networkidobj = cols[2].childNodes[0];

                        var j_name_val = j_nameobj.value;
                        var j_networkid_val = j_networkidobj.value;

                        if((i_name_val == j_name_val) && (i != j) && i_name_val != ""){
                            if(!alertmsg.includes(i_name_val + " already exists"))
                                alertmsg += i_name_val + " already exists\n";
                            nameobj.style.outline = "thin solid red";
         					nameobj.title = i_name_val + " already exists";
                            j_nameobj.style.outline = "thin solid red";
         					j_nameobj.title = i_name_val + " already exists";
         					firstdone = true;
                            if(secondone)
                                break;
                        }


                        if((i_networkid_val == j_networkid_val) && (i != j) && i_networkid_val != ""){
                            if(!alertmsg.includes(i_networkid_val + " already exists"))
                                alertmsg += i_networkid_val + " already exists\n";
                            networkidobj.style.outline = "thin solid red";
                            networkidobj.title = i_networkid_val + " already exists";
                            j_networkidobj.style.outline = "thin solid red";
                            j_networkidobj.title = i_networkid_val + " already exists";
                            secondone = true;
                            if(firstdone)
                                break;
                        }
                    }

                }

                
                if (alertmsg.trim().length == 0) {
         			return true;
         		} else {
         			alert(alertmsg);
         			return false;
         		}
            }
            catch(e)
         	{
         		alert(e);
         	}
        }
    </script>
</head>
<body>
<form action="savedetails.jsp?page=ZeroTier&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return validatezerotier()">
        <div align="center" id="zerotierpage"><br><br>
            <p class="style5" align="center">ZeroTier</p><br>
            <table class="borderlesstab" style="width:800px; height: 30px; margin-bottom:0px;margin-bottom:0px;" id="zerotiertb" align="center">
                <input type="text" id="zerotierconf" name="zerotierconf" value="1" hidden="">
                <tbody>
                    <tr>
                        <th style="text-align:center;" width="30px" align="center">S.No</th>
                        <th style="text-align:center;" width="120px" align="center">Name</th>
                        <th style="text-align:center;" width="120px" align="center">Network ID</th>
                        <th style="text-align:center;" width="70px" align="center">Activation</th>
                        <th style="text-align:center;" width="80px" align="center">Auto NAT Clients</th>
                        <!-- <th style="text-align:center;" width="80px" align="center">IP Address</th> -->
                        <th style="text-align:center;" width="70px" align="center">Action</th>
                    </tr>
                </tbody>
            </table>
            <br><br>
           <!--  <div style="width:500px">
             <p style="font-size:11px;font-family: verdana;"><span style="color:red;"><b> Note:</b></span>Please refer Firewall(portforward),if any entry configured with Zerotire delete that entry while deactivating the activation or deleting the Zerotire.</p>
            </div><br> -->
            <div align="center"><input class="button" type="button" id="add" value="Add" style="display:inline block" onclick="addRow('zerotiertb','<%=slnumber%>','<%=version%>')"><input type="submit" value="Apply" name="Apply" style="display:inline block" class="button"></div>
        </div>
    </form>
    <%
   	if(errorstr != null && errorstr.trim().length() > 0)
			{%>
		     <script>
			 showErrorMsg('<%=errorstr%>');
			 </script>
			<%}
    	int i = 0;
    	Iterator<String> ztnames = ztjsonobj.keys();
    	String strztkeynames;
    	String name;
    	JSONObject ztobj = null;
    	String networkid = "";
    	String act = "";
    	String natclient = "";
    	String ipaddr = "";
    	while(ztnames.hasNext())
    	{
    		strztkeynames = ztnames.next();
    		if(strztkeynames.toLowerCase().startsWith("zerotier: "));
    			name = strztkeynames.replace("zerotier:", "");
    			ztobj = ztjsonobj.getJSONObject("zerotier:"+name);
    			if(ztobj.containsKey("networkid")){
        				networkid = ztobj.containsKey("networkid")?ztobj.getString("networkid"):"";
        				act = ztobj.containsKey("activation")?ztobj.getString("activation").equals("1")?"checked":"":"";
    					natclient = ztobj.containsKey("natclient")?ztobj.getString("natclient").equals("1")?"checked":"":"";
    					ipaddr = ztobj.containsKey("ipaddr")?ztobj.getString("ipaddr"):"";
    				 %>
				 	<script>
				 	 	addRow('zerotiertb','<%=slnumber%>','<%=version%>');
						fillrow('<%=i+1%>','<%=name%>','<%=networkid%>','<%=act%>','<%=natclient%>','<%=ipaddr%>');
					</script>
					<% 
					i++;
    			}
			
    	}
    %>
    
</body>
</html>