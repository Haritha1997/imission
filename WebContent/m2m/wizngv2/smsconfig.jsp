<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
<%
	JSONObject wizjsonnode = null;
	JSONObject smsconfig_obj = null;
	BufferedReader jsonfile = null;  
	
		String slnumber=request.getParameter("slnumber");
	String errorstr = request.getParameter("error");
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
		
		smsconfig_obj =  wizjsonnode.getJSONObject("cellular").getJSONObject("SMS:sms");
		
		
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
<html>
   <head>
		<link rel="stylesheet" href="css/fontawesome.css">
		<link rel="stylesheet" href="css/solid.css">
		<link rel="stylesheet" href="css/v4-shims.css">
		<link rel="stylesheet" type="text/css" href="css/style.css">

<script type = "text/javascript" > 
function IPv4AddressKeyOnly(e) {
    var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
    if ((keyCode == 43 || keyCode == 46 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
        return true;
    }
    return false;
}
function digitWithPlusOnly(e) {
    var keyCode = e.keyCode == 0 ? e.charCode : e.keyCode;
    if ((keyCode == 43 || keyCode == 8 || keyCode == 9 || keyCode == 13) || (keyCode >= 48 && keyCode <= 57)) {
        return true;
    }
    return false;
}
function validateSmsConfig()
{
	var altmsg="";
	var sms_id_arr = ["Srcmn1","Srcmn2","Srcmn3"];
	var sms_msg_id_arr = ["Sim1cmn","Sim2cmn"];
	var sms_name_arr = ["Source Mobile Number 1","Source Mobile Number 2","Source Mobile Number 3"];
	var sms_msg_name_arr = ["SIM1 Message Center Number","SIM2 Message Center Number"];
	var sms1id = document.getElementById("Srcmn1");
	var sms2id = document.getElementById("Srcmn2");
	var sms3id = document.getElementById("Srcmn3");
	for(var i=0;i<sms_id_arr.length;i++)
	{
		var srcobj=document.getElementById(sms_id_arr[i]);
		if(!validateNumber(sms_id_arr[i]))
		{
			altmsg += "invalid "+sms_name_arr[i]+"\n";
			continue;
	    }
		for(var j=0;j<sms_id_arr.length;j++)
		{
			if(i != j)
			if(checkDuplicates(sms_id_arr[i],sms_id_arr[j]))
			{
				srcobj.title = "Duplicate number with "+sms_name_arr[j];
				srcobj.style.outline="thin solid red";				
				if(!altmsg.includes(sms_name_arr[i]+" and "+sms_name_arr[j]+" are duplicate numbers") && 
						   !altmsg.includes(sms_name_arr[j]+" and "+sms_name_arr[i]+" are duplicate numbers"))
						altmsg += sms_name_arr[i]+" and "+sms_name_arr[j]+" are duplicate numbers\n";
			}
		}
	}
	for(var i=0;i<sms_msg_id_arr.length;i++)
	{
		if(!validateNumber(sms_msg_id_arr[i]))
		{
			altmsg += "invalid "+sms_msg_name_arr[i]+"\n";
			continue;
	    }
	}
	
	if (altmsg.trim().length == 0) {
      return true;
   } 
   else {
      alert(altmsg);
      return false;
   }			
} 
function validateNumber(id)
{
	var idobj = document.getElementById(id);
	if(idobj.value.length !=0 && (idobj.value.length<13 || !idobj.value.startsWith("+91") 
		|| idobj.value.split("+").length!=2 || !indianNumber(idobj.value.charAt(3))))
	{
		idobj.title = "Invalid number";
		idobj.style.outline="thin solid red";
		return false
	}		
	else {
		idobj.style.outline = "initial";
        idobj.title = "";
		return true;
	}
}
function indianNumber(val)
{
	if(val == '9' || val == '8' || val == '7' || val == '6')
	{
		return true;
	}
	else
		return false;
}
 function checkDuplicates(id1,id2)
{

	var simobj1=document.getElementById(id1);
	var simobj2=document.getElementById(id2);

	if(simobj1.value==simobj2.value && simobj1.value.trim().length != 0)
		return true;
	else
		return false;
} 
</script>   
</head>
   <body>
   <div align="center">
      <form action="savedetails.jsp?page=smsconfig&slnumber=<%=slnumber%>" method="post" onsubmit="return validateSmsConfig()">
         <p class="style5" align="center">SMS Configuration</p>
		 <br/>
		 <br/>
         <table id="WiZConf" align="center" class="borderlesstab" style="width:500px;margin-bottom:0px;margin-bottom:0px;">
            <tbody>
               <tr>
                  <th width="140px" align="center">Parameters</th>
                  <th width="140px" align="center">Values</th>
               </tr>
               <tr>
                  <td >Source Mobile Number 1</td>
                  <td ><input type="text" class="text" max="12" id="Srcmn1" name="Srcmn1" maxlength="13" value="<%=smsconfig_obj == null?"":smsconfig_obj.get("Srcmn1")==null?"":smsconfig_obj.getString("Srcmn1")%>" onkeypress="return digitWithPlusOnly(event)" onfocusout="validateNumber('Srcmn1')"></td>
               </tr>
               <tr>
                  <td >Source Mobile Number 2</td>
                  <td width="160px"><input type="text" class="text" max="12" id="Srcmn2" name="Srcmn2" maxlength="13" value="<%=smsconfig_obj == null?"":smsconfig_obj.get("Srcmn2")==null?"":smsconfig_obj.getString("Srcmn2")%>" onkeypress="return digitWithPlusOnly(event)" onfocusout="validateNumber('Srcmn2')"></td>
               </tr>
               <tr>
                  <td >Source Mobile Number 3</td>                  
                  <td width="160px"><input type="text" class="text" max="12" id="Srcmn3" name="Srcmn3" maxlength="13" value="<%=smsconfig_obj == null?"":smsconfig_obj.get("Srcmn3")==null?"":smsconfig_obj.getString("Srcmn3")%>" onkeypress="return digitWithPlusOnly(event)" onfocusout="validateNumber('Srcmn3')"></td>
               </tr>
               <tr>
                  <td >SIM1 Message Center Number</td>
                  <td width="160px"><input type="text" class="text" max="12" id="Sim1cmn" name="Sim1cmn" maxlength="13"  value="<%=smsconfig_obj == null?"":smsconfig_obj.get("Sim1cmn")==null?"":smsconfig_obj.getString("Sim1cmn")%>" onkeypress="return digitWithPlusOnly(event)"></td>
               </tr>
               <tr>
                  <td >SIM2 Message Center Number</td>
                  <td width="160px"><input type="text" class="text" max="12" maxlength="13" id="Sim2cmn" name="Sim2cmn" value="<%=smsconfig_obj == null?"":smsconfig_obj.get("Sim2cmn")==null?"":smsconfig_obj.getString("Sim2cmn")%>"  onkeypress="return digitWithPlusOnly(event)"></td>
               </tr>
               <tr>
               		<td>Event Logs</td>
               		<%String coldwarmstart=smsconfig_obj == null?"":smsconfig_obj.get("cold_warmstart")==null?"":smsconfig_obj.getString("cold_warmstart").equals("1")?"checked":"";
               		String linkud=smsconfig_obj == null?"":smsconfig_obj.get("linkud")==null?"":smsconfig_obj.getString("linkud").equals("1")?"checked":"";%>
	               <td>Cold/WarmStart <input type="checkbox" id="cold_warmstart" name="cold_warmstart" <%=coldwarmstart%>>&emsp;Link-Up/Down <input type="checkbox" id="linkud" name="linkud" <%=linkud%>>
	               </td>
               </tr>
            </tbody>
         </table>
		 <br/>
		 
         <div align="center"><input type="submit" name="Apply" value="Apply" class="button"></div>
      </form>
    </div>  
   </body>
   <script src="js/timeout.js" type="text/javascript"></script>
</html>

