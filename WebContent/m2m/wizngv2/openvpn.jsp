<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
 <%
   		String slnumber=request.getParameter("slnumber");
 		String version=request.getParameter("version");
		String errorstr = request.getParameter("error");
		 JSONObject wizjsonnode = null;
		 JSONObject openvpnobj = null;
		 String name=null;
		 BufferedReader jsonfile = null;  
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
					openvpnobj=wizjsonnode.containsKey("openvpn")?wizjsonnode.getJSONObject("openvpn"):new JSONObject();
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
 	<link rel="stylesheet" href="css/fontawesomev6.4all.css">
 	<link rel="stylesheet" href="css/solid.css">
    <link rel="stylesheet" href="css/v4-shims.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/openvpn.css">
    <script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
    <script src="js/common.js"></script>
	<script src="js/openvpn.js"></script>

</head>
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
/*  a {
padding-top: 40px;

}  */ 
#openvpnid
{
width:550px;
}
</style>
<script type="text/javascript">

    function checkAlphaNUmeric(id)
     {
        var name = document.getElementById("nwinstance").value;
       // localStorage.setItem("name", name);

        var val = document.getElementById(id).value.trim();
        if(!isValidAlphaNumberic(id) && val.length != 0)
        {
            alert("Please Use Only AlphaNumeric");
            return;
        }
        addopenvpnpage(id,true,'<%=slnumber%>','<%=version%>');
    }
    function toggleButtons(iconid,id,actid,icontxtid) 
     {
        var actvobj = document.getElementById(actid);
        var instance=document.getElementById(id).value;
        var iconobj = document.getElementById(iconid);
        var icontextobj = document.getElementById(icontxtid);
        var oldcolor = iconobj.style.color
        if(actvobj.checked == false)
        {
             alert("Activation must be enabled");
             return;
        }
        if(iconobj.className.includes("fa-solid fas fa-lock fa-xl")){
                iconobj.className = "fa-solid fas fa-lock-open fa-xl";
                iconobj.style.color = "black";
                icontextobj.value="0";
        }else if(iconobj.className.includes("fa-solid fas fa-lock-open fa-xl")){
            iconobj.className = "fa-solid fas fa-lock fa-xl";
            iconobj.style.color = "red";
            icontextobj.value="-1";
        }
       // window.location.href = "Nomus.cgi?OpenVPNLockInstance="+instance+".cgi";
    }
</script>
<body>
    <div>
        <table>
            <tr>
                <ul>
                    <li>
                       <!--  <a class="hilightthis" id="openvpn" hidden name="openvpn">OpenVPN</a><br><br> -->
                        <a id="client" name="client" class="hilightthis">Client</a>
                        <!-- <a class="hilightthis" id="server" name="server" style="display: none;">Server</a> -->
                    </li>
                </ul>
            </tr>
        </table>
    </div>

    <br><br><br><br>
    <div align="center" id="clientpage" >
        <p class="style5" align="center">Client Configuration</p><br>
        <form method="post" action="savedetails.jsp?page=openvpn&slnumber=<%=slnumber%>&version=<%=version%>" onsubmit="return validateClient()"> 
             <input type="text" id="slno" value="<%=slnumber%>" hidden />
            <table class="borderlesstab" style="width:1050px; height: 30px; margin-bottom:0px;margin-bottom:0px;" id="clientconfig" align="center">
                <input type="text" id="opvpconf" name="opvpconf" value="1" hidden="">
                <tbody>
                    <tr>
                        <th style="text-align:center;" width="30px" align="center">S.No</th>
                        <th style="text-align:center;" width="120px" align="center">Instance</th>
                        <th style="text-align:center;" width="120px" align="center">Mode</th>
                        <th style="text-align:center;" width="80px" align="center">Protocal</th>
                        <th style="text-align:center;" width="120px" align="center">Remote Address</th>
                        <th style="text-align:center;" width="80px" align="center">Remote Port</th>
                        <th style="text-align:center;" width="30px" align="center">Activation</th>
                         <th style="text-align:center;" width="70px" align="center">Action</th>
                        <!-- <th style="text-align:center;" width="30px" align="center">Open/Close</th>
                        <th style="text-align:center;" width="70px" align="center">Status</th>
                        <th style="text-align:center;" width="30px" align="center">Tracking</th> -->
                       
                    </tr>
                </tbody>
            </table>
           <!--  <table id="tabnote" name="tabnote" align="center">
                <tbody>
                    <tr style="background-color: white;">
                        <td colspan="4">
                            <p style="font-size:11px;font-family: verdana;margin-left:80px;">
                                <span style="color:red;text-align:left;">
                                    <b>Note:</b>
                                </span>
                                    New instance name don't change 
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table> -->
                    <br>
                    <br>
            <table class="borderlesstab" id="openvpnid" name="openvpnid" align="center">
                <tbody>
                    <tr align="center">
                       <td>New Instance Name</td>
                       <td ><input type="text" class="text" id="nwinstance" name="nwinstance" style="margin-left:10px;" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('nwinstance','New Instance Name')"></td>
                       <td>
                        <select name="clientserver" id="clientserver" class="text" style="margin-left:10px;min-width: 120px;max-width: 30px;">
                            <option value="1">Client To Server Configuration</option>
                            <option value="2">Point To Point Configuration</option>
                        </select>
                        </td>
                       <td><input type="button" class="button1" id="add" value="Add" style="margin-left:10px;" onclick="checkAlphaNUmeric('nwinstance')"></td>
                    </tr>
                    <tr style="background-color: white;">
                        <td colspan="4">
                            <p style="font-size:11px;font-family: verdana;margin-left:80px;">
                                <span style="color:red;text-align:left;">
                                    <b>Note:</b>
                                </span>
                                    Special Characters are not allowed 
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div align="center">
                <input type="submit" value="Apply" name="Apply" style="display:inline block" class="button">
            </div>	
    </form> 
</div> 
<% 
					int i = 0;
					String remaddr="";
					Iterator<String> keys = openvpnobj.keys();
					while (keys.hasNext()) {
						String ckey = keys.next();
						if (ckey.contains("openvpn:")) {
							JSONObject openvpn_obj = openvpnobj.getJSONObject(ckey);
							String instname = ckey.replace("openvpn:", "");
							String configuration =openvpn_obj.containsKey("configuration")?openvpn_obj.getString("configuration"):"";
							String protocal=openvpn_obj.containsKey("proto")?openvpn_obj.getString("proto"):"";
							String config_mode=openvpn_obj.containsKey("configmode")?openvpn_obj.getString("configmode"):"";
							//if(configuration.equals("Client To Server") || config_mode.equals("remote")) {
								remaddr = openvpn_obj.containsKey("remote")?openvpn_obj.getString("remote").split(" ")[0]:"";
								if(remaddr.equals("@"))
									remaddr="";
							/* }
							else
								remaddr="Local"; */
							String remport = openvpn_obj.containsKey("remote")?openvpn_obj.getString("remote").split(" ")[1]:"1194";
							//String localport = openvpn_obj.containsKey("port")?openvpn_obj.getString("port"):"";
							String act=openvpn_obj.containsKey("enabled")?openvpn_obj.getString("enabled").equals("1")?"checked":"":"";
							//String iconcol=openvpn_obj.containsKey("connect")?openvpn_obj.getString("connect").equals("1")?"green":openvpn_obj.getString("connect").equals("-1")?"red":"black":"black";
					%>
					<script>
					addRow('clientconfig',false,"<%=slnumber%>","<%=version%>");
					<%if(configuration.equals("Client To Server") || config_mode.equals("remote")){ %>
						fillrow('<%=i + 1%>','<%=instname%>','<%=configuration%>','<%=protocal%>','<%=remaddr%>','<%=remport%>','<%=act%>');
				<%} else {%>
				fillrowlocal('<%=i + 1%>','<%=instname%>','<%=configuration%>','<%=protocal%>','<%=remaddr%>','<%=remport%>','<%=act%>');
				<%}%>
				</script>
					<%
					i++;
						}
					}
					%>
</body>
<script>
    //checknote();
    protocolhide();
</script>
</html>