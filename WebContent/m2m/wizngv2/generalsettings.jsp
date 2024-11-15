<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
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
   JSONObject generalsetobj = null;
   JSONArray generalsetarr = null;
   JSONObject generalsetpage = null;
   JSONArray interfacesetarr = null;
   JSONObject interfacesetlanobj = null;
   JSONObject interfacesetwanobj = null;
   JSONObject interfacesetcellularobj = null;
   JSONObject interfacesetzerotierobj = null;
   JSONObject zerotierobj=null;
   JSONObject ztsample_configobj=null;
   String fldrate = "";
   String fldburst = "";
   String input = "";
   String output = "";
   String forward = "";
   String laninput = "";
   String lanoutput = "";
   String lanforward = "";
   String waninput = "";
   String wanoutput = "";
   String wanforward = "";
   String cellularinput = "";
   String cellularoutput = "";
   String cellularforward = "";
   String zerotierinput = "";
   String zerotieroutput = "";
   String zerotierforward = ""; 
   String enable="";
   BufferedReader jsonfile = null;   
   
   		String slnumber=request.getParameter("slnumber");
   		String version=request.getParameter("version");
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
   		
			generalsetobj = wizjsonnode.getJSONObject("firewall");
			generalsetarr = generalsetobj.getJSONArray("defaults")==null ? new JSONArray(): generalsetobj.getJSONArray("defaults");
			generalsetpage = generalsetarr.get(0)==null ? new JSONObject(): (JSONObject)generalsetarr.get(0);
			zerotierobj=wizjsonnode.containsKey("zerotier")?wizjsonnode.getJSONObject("zerotier"):new JSONObject();
			ztsample_configobj=zerotierobj.containsKey("zerotier:sample_config")?zerotierobj.getJSONObject("zerotier:sample_config"):new JSONObject();
			enable=ztsample_configobj.containsKey("enabled")?ztsample_configobj.getString("enabled"):"";
			
			interfacesetarr = generalsetobj.getJSONArray("zone")==null ? new JSONArray(): generalsetobj.getJSONArray("zone");
			interfacesetlanobj = interfacesetarr.get(0)==null ? new JSONObject(): (JSONObject)interfacesetarr.get(0);	
			interfacesetwanobj = interfacesetarr.get(0)==null ? new JSONObject(): (JSONObject)interfacesetarr.get(1);	
			interfacesetcellularobj = interfacesetarr.get(0)==null ? new JSONObject(): version.startsWith(Symbols.WiZV2+Symbols.EL)?(JSONObject)interfacesetarr.get(2):(JSONObject)interfacesetarr.get(1);	
			if(enable.equals("1"))
			{
				interfacesetzerotierobj=interfacesetarr.get(0)==null?new JSONObject():version.startsWith(Symbols.WiZV2+Symbols.EL)&&(interfacesetarr.size()>3&&interfacesetarr.get(3)!=null)?(JSONObject)interfacesetarr.get(3):(JSONObject)interfacesetarr.get(2);	
				zerotierinput = interfacesetzerotierobj.getString("input")==null? "":interfacesetzerotierobj.getString("input");
				zerotieroutput = interfacesetzerotierobj.getString("output")==null? "":interfacesetzerotierobj.getString("output");
				zerotierforward = interfacesetzerotierobj.getString("forward")==null? "":interfacesetzerotierobj.getString("forward");
				if(interfacesetzerotierobj.containsKey("input"))
					zerotierinput = interfacesetzerotierobj.getString("input");
				
				if(interfacesetzerotierobj.containsKey("output"))
					zerotieroutput = interfacesetzerotierobj.getString("output");
				
				if(interfacesetzerotierobj.containsKey("forward"))
					zerotierforward = interfacesetzerotierobj.getString("forward");
			}
				
			fldrate = generalsetpage.getString("synflood_rate")==null? "":generalsetpage.getString("synflood_rate");
			fldburst = generalsetpage.getString("synflood_burst")==null? "":generalsetpage.getString("synflood_burst");
			input = generalsetpage.getString("input")==null? "":generalsetpage.getString("input");
			output = generalsetpage.getString("output")==null? "":generalsetpage.getString("output");
			forward = generalsetpage.getString("forward")==null? "":generalsetpage.getString("forward");
			
			laninput = interfacesetlanobj.getString("input")==null? "":interfacesetlanobj.getString("input");
			lanoutput = interfacesetlanobj.getString("output")==null? "":interfacesetlanobj.getString("output");
			lanforward = interfacesetlanobj.getString("forward")==null? "":interfacesetlanobj.getString("forward");
			
			waninput = interfacesetwanobj.getString("input")==null? "":interfacesetwanobj.getString("input");
			wanoutput = interfacesetwanobj.getString("output")==null? "":interfacesetwanobj.getString("output");
			wanforward = interfacesetwanobj.getString("forward")==null? "":interfacesetwanobj.getString("forward");
			
			cellularinput = interfacesetcellularobj.getString("input")==null? "":interfacesetcellularobj.getString("input");
			cellularoutput = interfacesetcellularobj.getString("output")==null? "":interfacesetcellularobj.getString("output");
			cellularforward = interfacesetcellularobj.getString("forward")==null? "":interfacesetcellularobj.getString("forward");
			
			if(generalsetpage.containsKey("synflood_rate"))
			fldrate = generalsetpage.getString("synflood_rate");
		
			if(generalsetpage.containsKey("synflood_burst"))
			fldburst = generalsetpage.getString("synflood_burst");
		
			if(generalsetpage.containsKey("input"))
			input = generalsetpage.getString("input");
		
			if(generalsetpage.containsKey("output"))
			output = generalsetpage.getString("output");
		
			if(generalsetpage.containsKey("forward"))
			forward = generalsetpage.getString("forward");
		
			if(interfacesetlanobj.containsKey("input"))
			laninput = interfacesetlanobj.getString("input");
		
			if(interfacesetlanobj.containsKey("output"))
			lanoutput = interfacesetlanobj.getString("output");
		
			if(interfacesetlanobj.containsKey("forward"))
			lanforward = interfacesetlanobj.getString("forward");
		
			if(interfacesetwanobj.containsKey("input"))
			waninput = interfacesetwanobj.getString("input");
		
			if(interfacesetwanobj.containsKey("output"))
			wanoutput = interfacesetwanobj.getString("output");
		
			if(interfacesetwanobj.containsKey("forward"))
			wanforward = interfacesetwanobj.getString("forward");
		
			if(interfacesetcellularobj.containsKey("input"))
			cellularinput = interfacesetcellularobj.getString("input");
		
			if(interfacesetcellularobj.containsKey("output"))
			cellularoutput = interfacesetcellularobj.getString("output");
		
			if(interfacesetcellularobj.containsKey("forward"))
			cellularforward = interfacesetcellularobj.getString("forward");
			
			
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
   <meta http-equiv="pragma" content="no-cache" />
      <link rel="stylesheet" type="text/css" href="css/style.css">
     <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
     <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript">
	  function addRow(tablename, suffix) {
	var table = document.getElementById(tablename);
	var iprows = table.rows.length;
	if (tablename == "WiZConf1") {
		if (iprows == 6) {
			alert("Maximum 5 Entries are allowed");
			return false;
		}
		if (iprows == 1) document.getElementById("intrwcnt").value = iprows;
		iprows = document.getElementById("intrwcnt").value;
		document.getElementById("intrwcnt").value = Number(iprows) + 1;
		var row = "<tr align=\"center\" id=\"intrwcnt" + iprows + "\">" + "<td style=\"text-align: center; vertical-align: middle;\">" + iprows + "</td>" + "<td align=\"center\" class=\"text1\" id=\"instancename" + iprows + "\" name=\"instancename" + suffix + "\" readonly></td>" + "<td><select name=\"input" + suffix + "\" id=\"input" + iprows + "\"><option value=\"1\">accept</option><option value=\"2\">reject</option><option value=\"3\">drop</option></select></td>" + "<td><select name=\"output" + suffix + "\" id=\"output" + iprows + "\"><option value=\"1\">accept</option><option value=\"2\">reject</option><option value=\"3\">drop</option></select></td>" + "<td><select name=\"forward" + suffix + "\" id=\"forward" + iprows + "\"><option value=\"1\">accept</option><option value=\"2\">reject</option><option value=\"3\">drop</option></select></td>" + "<td><label class=\"switch\"><input type=\"checkbox\" id=\"masq" + iprows + "\" name=\"masq" + suffix + "\" checked><span class=\"slider round\"></span></input></label></td>" + "<td hidden>0</td>" + "<td hidden>" + iprows + "</td>" + "</tr>";
		$('#WiZConf1').append(row);
	} else {
		alert("No Row added");
	}
	var height = table.rows[1].cells[0].offsetHeight;
	window.scrollBy(0, height);
}

function fillrow(rowid, instancename, input, output, forward, masq) {
	document.getElementById('instancename' + rowid).innerHTML = instancename;
	document.getElementById('input' + rowid).value = input;
	document.getElementById('output' + rowid).value = output;
	document.getElementById('forward' + rowid).value = forward;
	document.getElementById('masq' + rowid).checked = masq;
}
	  </script>
   </head>
   <body>
      <form action="savedetails.jsp?page=generalsettings&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="">
         <br>
         <p class="style5" align="center">General Settings</p>
         <br>
         <table class="borderlesstab" id="WiZConf" style="width:800px;" align="center">
            <tbody>
               <tr>
                  <th width="400px">Parameters</th>
                  <th width="400px">Configuration</th>
               </tr>
               <tr>
                  <td>Enable SYN-flood protection</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="firewallprot" id="firewallprot" style="vertical-align:middle" <%if(generalsetpage.containsKey("syn_flood") && generalsetpage.getString("syn_flood").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>SYN-flood rate (packets/second)</td>
                  <td><input name="synflood_rate" type="number" class="text" value="<%=generalsetpage == null?"":generalsetpage.get("synflood_rate")==null?"":generalsetpage.getString("synflood_rate")%>" id="synflood_rate" min="5" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validateRange('synflood_rate','SYN-flood Rate')"></td>
               </tr>
               <tr>
                  <td>SYN-flood burst (packets/second)</td>
                  <td><input name="synflood_burst" type="number" class="text" value="<%=generalsetpage == null?"":generalsetpage.get("synflood_burst")==null?"":generalsetpage.getString("synflood_burst")%>" id="synflood_burst" min="5" max="65535" onkeypress="return avoidSpace(event)" onfocusout="validateRange('synflood_burst','SYN-flood Burst')"></td>
               </tr>
               <tr>
                  <td>Drop invalid packets</td>
                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="invalidpack" id="invalidpack" style="vertical-align:middle"  <%if(generalsetpage.containsKey("drop_invalid") && generalsetpage.getString("drop_invalid").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
               </tr>
               <tr>
                  <td>
                     <div>Input</div>
                  </td>
                  <td>
                     <select name="input" id="input" class="text">
                        <option value="ACCEPT" <%if(input.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(input.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(input.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>
                     <div>Output</div>
                  </td>
                  <td>
                     <select name="output" id="output" class="text">
                        <option value="ACCEPT" <%if(output.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(output.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(output.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td>
                     <div>Forward</div>
                  </td>
                  <td>
                     <select name="forward" id="forward" class="text">
                        <option value="ACCEPT" <%if(forward.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(forward.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(forward.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
               </tr>
            </tbody>
         </table>
         <br><br>
         <p class="style5" align="center">Interface Settings</p>
         <br><input type="text" id="intrwcnt" name="intrwcnt" value="1" hidden="">
         <table class="borderlesstab" id="WiZConf1" style="width:800px;" align="center">
            <tbody>
               <tr>
                  <th style="text-align:center;" width="30px" align="center">S.No</th>
                  <th style="text-align:center;" width="90px" align="center">Interface</th>
                  <th style="text-align:center;" width="60px" align="center">Input</th>
                  <th style="text-align:center;" width="60px" align="center">Output</th>
                  <th style="text-align:center;" width="60px" align="center">Forward</th>
                  <th style="text-align:center;" width="30px" align="center">Masquerading</th>
               </tr>
               <tr id="intrwcnt1" align="center">
                  <td style="text-align: center; vertical-align: middle;">1</td>
                  <td class="text1" id="instancename1" name="instancenameLAN" readonly="" align="center">LAN</td>
                  <td>
                     <select name="inputLAN" id="input1">
                        <option value="ACCEPT" <%if(laninput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(laninput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(laninput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td>
                     <select name="outputLAN" id="output1">
                        <option value="ACCEPT" <%if(lanoutput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(lanoutput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(lanoutput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td>
                     <select name="forwardLAN" id="forward1">
                        <option value="ACCEPT" <%if(lanforward.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(lanforward.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(lanforward.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td><label class="switch"><input type="checkbox" id="masq1" name="masqLAN" <%if(interfacesetlanobj.containsKey("masq") && interfacesetlanobj.getString("masq").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
                  <td hidden="">0</td>
                  <td hidden="">1</td>
               </tr>
               <%if(version.trim().startsWith(Symbols.WiZV2+Symbols.EL))
      			{%>
               <tr id="intrwcnt2" align="center">
                  <td style="text-align: center; vertical-align: middle;">2</td>
                  <td class="text1" id="instancename2" name="instancenameWAN" readonly="" align="center">WAN</td>
                  <td>
                     <select name="inputWAN" id="input2">
                        <option value="ACCEPT" <%if(waninput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(waninput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(waninput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                 
                  <td>
                     <select name="outputWAN" id="output2">
                         <option value="ACCEPT" <%if(wanoutput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(wanoutput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(wanoutput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
             
                  <td>
                     <select name="forwardWAN" id="forward2">
                       <option value="ACCEPT" <%if(wanforward.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(wanforward.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(wanforward.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td><label class="switch"><input type="checkbox" id="masq2" name="masqWAN" <%if(interfacesetwanobj.containsKey("masq") && interfacesetwanobj.getString("masq").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
                  <td hidden="">0</td>
                  <td hidden="">2</td>
               </tr>
               <%}%>
               <tr id="intrwcnt3" align="center">
                  <td style="text-align: center; vertical-align: middle;"><%if(version.startsWith(Symbols.WiZV2+Symbols.EL)) {%>3 <%} else { %>2<%} %></td>
                  <td class="text1" id="instancename3" name="instancenameCellular" readonly="" align="center">Cellular</td>
                  <td>
                     <select name="inputCellular" id="input3">
                        <option value="ACCEPT" <%if(cellularinput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(cellularinput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(cellularinput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td>
                     <select name="outputCellular" id="output3">
                        <option value="ACCEPT" <%if(cellularoutput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(cellularoutput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(cellularoutput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td>
                     <select name="forwardCellular" id="forward3">
                        <option value="ACCEPT" <%if(cellularforward.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(cellularforward.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(cellularforward.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td><label class="switch"><input type="checkbox" id="masq3" name="masqCellular" <%if(interfacesetcellularobj.containsKey("masq") && interfacesetcellularobj.getString("masq").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
                  <td hidden="">0</td>
                  <td hidden="">3</td>
               </tr>
               <%if(enable.equals("1")){ %>
               <tr id="intrwcnt4" align="center">
                  <td style="text-align: center; vertical-align: middle;">4</td>
                  <td class="text1" id="instancename4" name="instancenameZeroTier" readonly="" align="center">ZeroTier</td>
                  <td>
                     <select name="inputZeroTier" id="input4">
                        <option value="ACCEPT" <%if(zerotierinput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(zerotierinput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(zerotierinput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td>
                     <select name="outputZeroTier" id="output4">
                        <option value="ACCEPT" <%if(zerotieroutput.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(zerotieroutput.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(zerotieroutput.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td>
                     <select name="forwardZeroTier" id="forward4">
                        <option value="ACCEPT" <%if(zerotierforward.equals("ACCEPT")){%>selected<%}%>>accept</option>
                        <option value="REJECT" <%if(zerotierforward.equals("REJECT")){%>selected<%}%>>reject</option>
                        <option value="DROP" <%if(zerotierforward.equals("DROP")){%>selected<%}%>>drop</option>
                     </select>
                  </td>
                  <td><label class="switch"><input type="checkbox" id="masq4" name="masqZeroTier" <%if(interfacesetzerotierobj.containsKey("masq") && interfacesetzerotierobj.getString("masq").equals("1")) {%> checked <%}%>><span class="slider round"></span></label></td>
                  <td hidden="">0</td>
                  <td hidden="">4</td>
               </tr>
               <%} %>
            </tbody>
         </table>
         <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
      </form>

   </body>
</html>