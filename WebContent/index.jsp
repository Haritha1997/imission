
<%@page import="java.awt.Toolkit"%>
<%@page import="java.awt.Dimension"%>
<%@page import="com.nomus.staticmembers.FileExtracter"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="org.apache.xmlbeans.impl.common.SystemCache"%>
<%@page import="com.nomus.m2m.pojo.UserColumns"%>
<%@page import="com.nomus.staticmembers.NodeStatus"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="com.nomus.staticmembers.QueryGenerator"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.nomus.m2m.pojo.UserSlnumber"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.*" %>
<%@page import="java.lang.*"%>


   <jsp:include page="bootstrap.jsp" flush="false">
   <jsp:param name="title" value="imission"/>
   <jsp:param name="headTitle" value="imission"/>
   <jsp:param name="limenu" value="Dashboard"/>
   <jsp:param name="lisubmenu" value="<%=request.getParameter(\"lisubmenu\")%>"/>
  </jsp:include>

   <head>
</head> 
<%
	String submenu = request.getParameter("lisubmenu");
  	Vector<String> services_vec = new Vector<String>();
  	String remote = null;
  	String ipaddress = null;
  	String loopbackip =null;
	int up = 0;
	int down = 0;
	int deleted = 0;
  	int nodeid = 0;
	int all = 0;
  	String nodename = null ;
  	 String RED_OVAL = "down";
  	 int WHITE_OVAL = 1;
  	 int GREY_OVAL = 2;
  	 String GREEN_OVAL = "up";
  	 String GRAY_OVAL = "off";
  	 String status = RED_OVAL;
	 final String DOWN_STR="down";
	 final String INACTIVE_STR="inactive";
	 final String NA_STR="NA";
	 final String ACTIVE_STR="active";
	 final String DELETED_STR="deleted";
  	 int row=1;
	 String fetchtype = request.getParameter("type")==null?"active":request.getParameter("type");
	 User user = (User)request.getSession().getAttribute("loggedinuser");
	 NodedetailsDao nddao = new NodedetailsDao();
	 List<UserColumns> ucollist= user.getUserColumnsList();
	 UserColumns viewUserCols = new UserColumns();
	 for(UserColumns uscol : ucollist)
	 {
		if(uscol.getTableName().equals("dashboard"))
		{
 			viewUserCols = uscol;
			break;
		}
	 }
	HashMap<String,Boolean> usercolmap= viewUserCols.getColumsStatus();
	int todcolsize = 1;
	for(boolean val : usercolmap.values())
	{
		if(val)
			todcolsize++;
	}
  %>
<style>
#tab td
{
	padding-left : 5px;
	padding-right : 5px;
	vertical-align:middle;
}
#tab th
{
  max-width:12%;
  margin:0px;
  padding:5px;
}
#tab td input
{
  max-width:80px;
}
input[type="checkbox"]	
{
  margin:0px;
  padding:0px;
  max-width:20px;
  display:inline;
  vertical-align:middle;
}
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
}
.UP
{
 background-color: #AACE77;
}
.MAJOR
{
 background-color: #FFC84F;
}

.DOWN 
{
 background-color: #FF0900;
}
.DISABLED,.NA,.na,.NA
{
background-color: grey;
}
.circle
{
	width:12px;
	height:12px;
 	border-radius: 25px;
}
label{
	margin:0px;
	margin-top:2px;
}
html, body {margin: 1; height: 100%; overflow-y: hidden}

.cls-context-menu-link {
  display: block;
}

.cls-context-menu {
  position: absolute;
  display: none;
  background-color: #eee;
  width:17%; 
  overflow-y:scroll;
  max-height:62vh;
  scrollbar-width:thin; 
  height:60%; 
}
.cls-context-menu {
  border: solid 1px #CCC;
  margin-top:25px;
}
.cls-context-menu li {
  display: block;
  text-decoration: none;
  color: blue;
  padding:4px;
  margin-left:5px;
  margin-right: 5px;
  color:black;

}

</style>
<script type="text/javascript">
function showCheckBox(id,field)
{
	//alert("in the function showCheckBox");
	document.getElementById(id).style.display = "";
}
function hideCheckBox(id)
{
	document.getElementById(id).style.display = "none";
}
function doUselectAction(id)
{
	document.getElementById(id+"id").checked = false;
	saveTheColumns();
}
function saveTheColumns()
{
	form = document.getElementById("m2mform");
	form.action = "userColumnsController?tablename=dashboard&pagename=<%=fetchtype%>";
	var div = document.getElementById("div-context-menu"); 
	form.appendChild(div);
	form.submit();
	
}
function makelink(sortby,sorttype,cursortby)
{
	var link = "index.jsp?sortby="+sortby+"&lisubmenu=Active";
	if(sortby == cursortby)
	{
		if(sorttype == "asc")
			sorttype = "desc";
		else
			sorttype = "asc";
		link += "&sorttype="+sorttype;
	}
	document.location.href = link;
	
}
</script>
<% String sorttype =  request.getParameter("sorttype")==null? "desc":request.getParameter("sorttype").equals("asc")?"asc":"desc";
String sortby =  request.getParameter("sortby")==null? "id":request.getParameter("sortby"); %>
<body>
<form id="m2mform"  class="form-horizontal" method="post" onsubmit="">
<% String labelname_arr[]={"Device Status","Node Label","Connected IP","Loopback IP","Serial Number","Location","FW Version","Model Number","Router Uptime","IMEI No","Active SIM","Network","Signal Strength","P0","P1","P2","P3","WAN"};%>	
<%-- <% String labelname_arr[]={"Device Status","Node Label","Connected IP","Loopback IP","Serial Number","Location","FW Version","Model Number","Router Uptime","IMEI No","Active SIM","Network","Signal Strength","P0","P1","P2","P3","WAN","DI1","DI2","DI3"};%> --%>
 <div style="overflow-y:scroll;max-height:68vh">
	  <table class="table table-bordered" id="tab" style="width:100%;">
      <thead id="sticky">	  
	      <tr>
	      		<% for (String labelname : labelname_arr) { 
	      			if(usercolmap.containsKey(labelname) && usercolmap.get(labelname)==false)
	      				continue;
	      			else if(labelname.equals("P0")||labelname.equals("P1")||labelname.equals("P2")||labelname.equals("P3")){%>
	      			<th style="min-width:40px;">
		      		 <div valign="middle" <%if(!labelname.equals("Device Status")) {%>onmouseover="showCheckBox('<%=labelname%>')" onmouseout="hideCheckBox('<%=labelname%>')" onclick=""<%}%> class="cls-context-menu-link">
					    <%=labelname%><input type="checkbox" checked id="<%=labelname%>" style="display:none" onclick="doUselectAction('<%=labelname%>')"/>
					</div>
		     	</th>
		      <%} else if(labelname.equals("WAN")){%>
		    	  
		    	  <th style="min-width:60px; ">
		      		 <div valign="middle" <%if(!labelname.equals("Device Status")) {%>onmouseover="showCheckBox('<%=labelname%>')" onmouseout="hideCheckBox('<%=labelname%>')" onclick=""<%}%> class="cls-context-menu-link">
					 <%=labelname%><input type="checkbox" checked id="<%=labelname%>" style="display:none" onclick="doUselectAction('<%=labelname%>')"/>
					</div>
		     	</th>
		      <% } else if(labelname.equals("DI1") || labelname.equals("DI2") || labelname.equals("DI3")){%>
	      			<th style="min-width:50px;">
	      			<%if(submenu.equals("Active")) {%>
		      		 <div valign="middle" <%if(!labelname.equals("Device Status")) {%>onmouseover="showCheckBox('<%=labelname%>')" onmouseout="hideCheckBox('<%=labelname%>')" onclick=""<%}%> class="cls-context-menu-link">
		      		 <% if(sortby.equals(labelname)) {%><img <%if(sorttype.equals("asc")){ %>src="images/arrowup.gif"<%}else{%> src="images/arrowdown.gif"<%}%>alt="" vspace="0" hspace="0" border="0"/><%}%>
					 <label class="pointer" onclick="makelink('<%=labelname%>','<%=sorttype%>','<%=sortby%>')"><%=labelname%></label><input type="checkbox" checked id="<%=labelname%>" style="display:none" onclick="doUselectAction('<%=labelname%>')"/>
					</div>
					<%} else { %>
					<div valign="middle" <%if(!labelname.equals("Device Status")) {%>onmouseover="showCheckBox('<%=labelname%>')" onmouseout="hideCheckBox('<%=labelname%>')" onclick=""<%}%> class="cls-context-menu-link">
					 <%=labelname%><input type="checkbox" checked id="<%=labelname%>" style="display:none" onclick="doUselectAction('<%=labelname%>')"/>
					</div>
		     	</th>
		     	
		     	
		      <%}}else if(labelname.equals("Active SIM")||labelname.equals("Network")) {%>
			      	<th style="min-width:90px; ">
		      		 <div valign="middle" <%if(!labelname.equals("Device Status")) {%>onmouseover="showCheckBox('<%=labelname%>')" onmouseout="hideCheckBox('<%=labelname%>')" onclick=""<%}%> class="cls-context-menu-link">
					    <%=labelname%><input type="checkbox" checked id="<%=labelname%>" style="display:none" onclick="doUselectAction('<%=labelname%>')"/>
					</div>
		     	</th>
		      <%} 
	      			else if(!labelname.equals("Active SIM")||!labelname.equals("Network")||!labelname.equals("P0")||!labelname.equals("P1")||!labelname.equals("P3")||!labelname.equals("WAN") || !labelname.equals("DI1") || !labelname.equals("DI2") || !labelname.equals("DI3")) {%>
		      	<th style="min-width:115px; ">
		      		 <div valign="middle" <%if(!labelname.equals("Device Status")) {%>onmouseover="showCheckBox('<%=labelname%>')" onmouseout="hideCheckBox('<%=labelname%>')" onclick=""<%}%> class="cls-context-menu-link">
					    <%=labelname%><input type="checkbox" checked id="<%=labelname%>" style="display:none" onclick="doUselectAction('<%=labelname%>')"/>
					</div>
		     	</th>
		      <%} }%>
		 </tr>
		</thead>
		<div id="div-context-menu" class="cls-context-menu">
				<ul>
						
					<% int count = 0;
						for (String labelname : labelname_arr) {
							if(labelname.equals("Device Status"))
				      			continue;
					%>
							<li><input type="checkbox" id="<%=labelname%>id" name="<%=labelname%>id" value="<%=labelname%>" <%if(usercolmap.get(labelname)){%> checked <%}%>> <label><%=labelname%></label>
										</li>
							<%
								}
							%>
									
				</ul>
					<div class="form-group">
					<div class="btn-group" role="group" style="padding-right: 5px;padding-left:20px">
						<button type="button" class="btn btn-default" onclick="saveTheColumns();">Submit</button>
					</div>
					<div class="btn-group" role="group">
						<button type="button" class="btn btn-default" onclick="hideContextmenu();">Cancel</button>
					</div>
				</div>
			</div>		
<%
		try
		{   
				String nodestatus = NodeStatus.UP;
				if(fetchtype.equals(DOWN_STR))
					nodestatus = NodeStatus.DOWN;
				else if(fetchtype.equals(INACTIVE_STR))
					nodestatus= NodeStatus.INACTIVE;
				else if(fetchtype.equals(DELETED_STR))
					nodestatus = NodeStatus.DELETED;
				List<NodeDetails> nodelist=null;
				if(nodestatus.equals("up") && (sortby.equals("DI1") || sortby.equals("DI2") || sortby.equals("DI3")))
					nodelist=nddao.getNodeList(user,nodestatus,true,sortby,sorttype);
				else
					nodelist = nddao.getNodeList(user,nodestatus,true);
			
            for(NodeDetails node : nodelist)
			{	
%>
<tbody id="rowdata">

<tr>
<!--Status-->
<td>
<%
     status = node.getStatus();
     if(status.equals(INACTIVE_STR))
	{
		%>
		<label class="circle DOWN"></label>
		
	<%}
	else if(status.equals(DOWN_STR)){%>
	<label class="circle DOWN"></label>
	<%}
	else {%>
		<label class="circle UP"></label>
	<%}%>
</td>
<!-- Node Label -->
<%if(usercolmap.get("Node Label")) {%>
  <td>
   <%
		nodename = node.getNodelabel();
		if(nodename == null)
		{
			out.print("NA");
		}
		else{
			out.print(nodename);
		}	
	%>
  </td>
  <%}%>
  <!-- IpAddress -->
  <%if(usercolmap.get("Connected IP")) {%>
  <td>
	<%
	ipaddress = node.getIpaddress();
	if(ipaddress == null)
	{
		out.print("NA");
	}
	else{
		out.print(ipaddress);
	}	
%>
</td>
<%}%>
<!-- Loopback IP -->
<%if(usercolmap.get("Loopback IP")) {%>
<td>
	<%
	loopbackip  = node.getLoopbackip();
	if(loopbackip == null)
	{
		out.print("-");
	}
	else{
		out.print(loopbackip);
	}	
%>
  </td>
  <%}%>
  <!-- Device Serial Number -->
  <%if(usercolmap.get("Serial Number")) {%>
  <td>
   <a href="m2m/node.jsp?slnumber=<%=node.getSlnumber()%>">
    <%
		String deviceserialno = node.getSlnumber();
		if(deviceserialno == null || deviceserialno.equalsIgnoreCase("NA") || deviceserialno.equalsIgnoreCase("noSuchObject"))
		{
			out.print("");
		}
		else{
			out.print(deviceserialno);
		}	
	%>
  </a>
  </td>
  <%}%>
  <!-- Location -->
  <%if(usercolmap.get("Location")) {%>
  <td>
  <%
		String location = node.getLocation();
		if(location!= null)
		{
			out.print(location);
		}
		else
		 out.print("");
   
  %>
</td>
 <%}%>
<!-- Firmware Version -->
<%if(usercolmap.get("FW Version")) {%>
  <td>
  <%
		String fwvsn = node.getFwversion();
		if(fwvsn!= null)
		{
			out.print(fwvsn);
		}
		else
		 out.print("");
   
  %>
</td>
<%}%>
<!-- Model Number -->
<%if(usercolmap.get("Model Number")) {%>
  <td>
  <%
		String mdlnum = node.getModelnumber();
		if(mdlnum!= null)
		{
			out.print(mdlnum);
		}
		else
		 out.print("");
   
  %>
</td>
<%}%>
<!-- Router Uptime -->
<%if(usercolmap.get("Router Uptime")) {%>
  <td>
<%if(status.equalsIgnoreCase("up")) { %>
  <%
		String routeup = node.getRouteruptime();
		if(routeup!= null)
		{
			out.print(routeup);
		}
		else
		 out.print("-");
   
  %>

<%} else {
   out.print("-"); 
  }%>
</td>
<%}%>
<!-- IMEI Number -->
<%if(usercolmap.get("IMEI No")) {%>
  <td>
    <%
		String imeino = node.getImeinumber();
		if(imeino == null)
		{
			out.print("");
		}
		else{
			out.print(imeino);
		}	
	%>
  
  </td>
  <%}%>
  
       <!--   <%//if(status.equalsIgnoreCase("up")) { %> -->
<!-- Active Sim -->
<%if(usercolmap.get("Active SIM")) {%>
  <td>
  <%if(status.equalsIgnoreCase("up")) { %>
  <%
		String actvsim = node.getActivesim();
		if(actvsim!= null)
		{
			out.print(actvsim);
		}
		else
		 out.print("-");
   
  %>
  <%} else {
   out.print("-"); 
  }%>
  
</td>
 <%}%>
<!-- Network -->
<%if(usercolmap.get("Network")) {%>
  <td>
  <%if(status.equalsIgnoreCase("up")) { %>
  <%
		String network =node.getNetwork();
		if(network!= null)
		{
			out.print(network);
		}
		else
		 out.print("-");
   
  %>
   <%} else {
   out.print("-"); 
  }%>
</td>
 <%}%>
<!-- Signal Strength-->
<%if(usercolmap.get("Signal Strength")) {%>
  <td>
  <%if(status.equalsIgnoreCase("up")) { %>
  <%
		String sgnalstnth = node.getSignalstrength();
		if(sgnalstnth!= null)
		{
			out.print(sgnalstnth);
		}
		else
		 out.print("-");
   
  %>
   <%} else {
   out.print("-"); 
  }%>
</td>
 <%}%>
 <%if(usercolmap.get("P0")) {%>
<td>
<% String port1 = node.getSwitch1()==null?"":node.getSwitch1();
 if(status.equalsIgnoreCase("up")) {
	 if(port1.equalsIgnoreCase(NA_STR)){%>
		<label class="circle NA"></label>
	<%}
	 else if(port1.equalsIgnoreCase(RED_OVAL))
	{
	%>
	<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
	<label class="circle DOWN"></label>
	<%} else if(port1.equalsIgnoreCase(GREEN_OVAL)){%>
	<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
	<label class="circle UP"></label>
	<%}%>
<% } else { %>
	<label class="circle DOWN"></label>
<%} %>
</td>
 <%}%>
 
<%if(usercolmap.get("P1")) {%>
<%String port2 = node.getSwitch2()==null?"":node.getSwitch2(); 
if(node.getFwversion().startsWith(Symbols.WiZV2+Symbols.EL)) {
	%>
	<td>
 <%if(status.equalsIgnoreCase("up")) {
 if(port2.equalsIgnoreCase(NA_STR)){%>
	<label class="circle NA"></label>
<%}
 else if(port2.equalsIgnoreCase(RED_OVAL))
	{
	%>
	<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
	<label class="circle DOWN"></label>
	<%} else if(port2.equalsIgnoreCase(GREEN_OVAL)){%>
	<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
	<label class="circle UP"></label>
	<%}%>
<% }else { %>
	<label class="circle DOWN"></label>
<%} %>
</td>
 <%}else if(!node.getFwversion().startsWith(Symbols.WiZV2+Symbols.ES)){%>
 	<td>
		 <%if(status.equalsIgnoreCase("up")) {
		 if(port2.equalsIgnoreCase(NA_STR)){%>
			<label class="circle NA"></label>
		<%}
		 else if(port2.equalsIgnoreCase(RED_OVAL))
			{
			%>
			<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
			<label class="circle DOWN"></label>
			<%} else if(port2.equalsIgnoreCase(GREEN_OVAL)){%>
			<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
			<label class="circle UP"></label>
			<%}%>
		<% }else { %>
			<label class="circle DOWN"></label>
		<%} %>
	  </td>
<%}else {%>
 <td>
 <label class="circle DISABLED"></label>
 </td>
 <%} } %>
 <%if(usercolmap.get("P2")) {%>
 <% String port3 = node.getSwitch3()==null?"":node.getSwitch3();  
 if(node.getFwversion().startsWith(Symbols.WiZV2+Symbols.EL)) {
%>
<td>
<%if(status.equalsIgnoreCase("up")) {
	if(port3.equalsIgnoreCase(NA_STR)){%>
	<label class="circle NA"></label>
<%}
	else if(port3.equalsIgnoreCase(RED_OVAL))
	{
	%>
	<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
	<label class="circle DOWN"></label>
	<%} else if(port3.equalsIgnoreCase(GREEN_OVAL)){%>
	<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
	<label class="circle UP"></label>
	<%}%>
<% } else { %>
	<label class="circle DOWN"></label>
<%} %>
</td>
 <%}else if(!node.getFwversion().startsWith(Symbols.WiZV2+Symbols.ES)){%>
 	<td>
		 <%if(status.equalsIgnoreCase("up")) {
		 if(port3.equalsIgnoreCase(NA_STR)){%>
			<label class="circle NA"></label>
		<%}
		 else if(port3.equalsIgnoreCase(RED_OVAL))
			{
			%>
			<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
			<label class="circle DOWN"></label>
			<%} else if(port3.equalsIgnoreCase(GREEN_OVAL)){%>
			<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
			<label class="circle UP"></label>
			<%}%>
		<% }else { %>
			<label class="circle DOWN"></label>
		<%} %>
	</td>
<%}else {%>
 <td>
 <label class="circle DISABLED"></label>
 </td>
 <%} %>
 <%} String slnumber=node.getSlnumber();
	JSONObject wizjsonnode = null;
	JSONObject producttypeobj = null;
	String producttype="4LAN";
	  File jsonfile=null;
    BufferedReader jsonfilereader = null;  
    boolean enabled = false;
   if(slnumber != null && slnumber.trim().length() > 0 )
   {
	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
	   try{
	   FileExtracter.extractAndCopyConfig(slnumber);
	   jsonfile =new File(slnumpath+File.separator+"Config.json");
	   }catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   if(jsonfile.exists())
	   {
		   jsonfilereader = new BufferedReader(new FileReader(jsonfile));
		   StringBuilder jsonbuf = new StringBuilder("");
		   String jsonString="";
		   try
		   {
				while((jsonString = jsonfilereader.readLine())!= null)
	   			jsonbuf.append( jsonString );
				wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
				producttypeobj=wizjsonnode.containsKey("SYSTEMCONTROL")?wizjsonnode.getJSONObject("SYSTEMCONTROL").containsKey("PRODUCTTYPE")?wizjsonnode.getJSONObject("SYSTEMCONTROL").getJSONObject("PRODUCTTYPE"):new JSONObject():new JSONObject();
				producttype=producttypeobj.containsKey("ProductType")?producttypeobj.getString("ProductType"):producttype;
		   }
		   catch(Exception e)
		   {
			   e.printStackTrace();
		   }
		   finally
		   {
			   if(jsonfilereader != null)
				   jsonfilereader.close();
		   }
	   }
	   }%>
 <%if(usercolmap.get("P3")) {%>
 <% String port4 = node.getSwitch4()==null?"":node.getSwitch4(); 
 if(node.getFwversion().startsWith(Symbols.WiZV2+Symbols.EL)) {
 %>
<td>
<% if(status.equalsIgnoreCase("up")) {
	if(port4.equalsIgnoreCase(NA_STR)){%>
	<label class="circle NA"></label>
<%}
	else if(port4.equalsIgnoreCase(RED_OVAL))
	{
	%>
	<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
	<label class="circle DOWN"></label>
	<%} else if(port4.equalsIgnoreCase(GREEN_OVAL)){%>
	<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
	<label class="circle UP"></label>
	<%}%>
<% } else { %>
	<label class="circle DOWN"></label>
<%} %>
</td>
  <%}else if(!node.getFwversion().startsWith(Symbols.WiZV2+Symbols.ES)&&producttype.equals("4LAN")){%>
	<td>
		 <%if(status.equalsIgnoreCase("up")) {
		 if(port4.equalsIgnoreCase(NA_STR)){%>
			<label class="circle NA"></label>
		<%}
		 else if(port4.equalsIgnoreCase(RED_OVAL))
			{
			%>
			<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
			<label class="circle DOWN"></label>
			<%} else if(port4.equalsIgnoreCase(GREEN_OVAL)){%>
			<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
			<label class="circle UP"></label>
			<%}%>
		<% }else { %>
			<label class="circle DOWN"></label>
		<%} %>
	</td>
<%}
 else {%>
 <td>
 <label class="circle DISABLED"></label>
 </td>
 <%} %>
 <%} %>
  <%if(usercolmap.get("WAN")) {%>
  <% if(node.getFwversion().startsWith(Symbols.WiZV2+Symbols.EL)) {%>
<td>
<%if(status.equalsIgnoreCase("up")) { %>
<% String wansts = node.getWanstatus()==null?"":node.getWanstatus().trim();  
     if(wansts.equalsIgnoreCase(RED_OVAL))
	{
	%>
	<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
	<label class="circle DOWN"></label>
	<%} else if(wansts.equalsIgnoreCase(GREEN_OVAL)){%>
	<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
	<label class="circle UP"></label>
	<%} else if(wansts.equalsIgnoreCase(GRAY_OVAL)) {%>
	<label class="circle DISABLED"></label>
	<%} %>
<% } else { %>
	<label class="circle DOWN"></label>
<%} %>
</td>
  <%}else if(!node.getFwversion().startsWith(Symbols.WiZV2+Symbols.ES)&&producttype.equals("3LAN-1WAN")){%>
	<td>
		 <%
		 String wansts = node.getSwitch4()==null?"":node.getSwitch4();
		 if(status.equalsIgnoreCase("up")) {
		 if(wansts.equalsIgnoreCase(NA_STR)){%>
			<label class="circle NA"></label>
		<%}
		 else if(wansts.equalsIgnoreCase(RED_OVAL))
			{
			%>
			<!--<img src="\imission\images\nodedown.png" alt="" ></img>-->
			<label class="circle DOWN"></label>
			<%} else if(wansts.equalsIgnoreCase(GREEN_OVAL)){%>
			<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
			<label class="circle UP"></label>
			<%}%>
		<% }else { %>
			<label class="circle DOWN"></label>
		<%} %>
	</td>
<%}
  else {%>
  <td>
  <label class="circle DISABLED"></label>
  </td>
  <%} %>
  <%} %>
  <%-- <%if(usercolmap.get("DI1")) {%>
  <% if(node.getFwversion().startsWith(Symbols.WiZV2+Symbols.EL)) {%>
  <td <% if(sortby.equals("DI1")) {%> style="padding-left:20px" <%} %>>
  	<% String dio1sts = node.getDi1()==null?"":node.getDi1();
  		if(dio1sts.equals("0")) {
  	%>
  	<label class="circle UP"></label>
	<%} 
  		else if(dio1sts.equals("1")) {
	%>
	<label class="circle DOWN"></label>
	<%}
  		else if(dio1sts.equals("2")) {
	%>
	<label class="circle DISABLED"></label>
	<%} %>
  </td>
  <%} 
  else {%>
  <td>
  <label class="circle DISABLED"></label>
  </td>
  <%} %>
  <%} %>
  <%if(usercolmap.get("DI2")) {%>
  <% if(node.getFwversion().startsWith(Symbols.WiZV2+Symbols.EL)) {%>
  <td <% if(sortby.equals("DI2")) {%> style="padding-left:20px" <%} %>>
  	<% String dio2sts = node.getDi2()==null?"":node.getDi2();
  		if(dio2sts.equals("0")) {
  	%>
  	<label class="circle UP"></label>
	<%} 
  		else if(dio2sts.equals("1")) {
	%>
	<label class="circle DOWN"></label>
	<%}
  		else if(dio2sts.equals("2")) {
  			%>
  			<label class="circle DISABLED"></label>
  			<%} %>
  </td>
  <%} 
  else {%>
  <td>
  <label class="circle DISABLED"></label>
  </td>
  <%} %>
  <%} %>
  <%if(usercolmap.get("DI3")) {%>
  <% if(node.getFwversion().startsWith(Symbols.WiZV2+Symbols.EL)) {%>
  <td 
  		<%if(sortby.equals("DI3")) {%> style="padding-left:20px" <%} %>>
  	<% String dio3sts = node.getDi3()==null?"":node.getDi3();
  		if(dio3sts.equals("0")) {
  	%>
  	<label class="circle UP"></label>
	<%} 
  		else if(dio3sts.equals("1")) {
	%>
	<label class="circle DOWN"></label>
	<%}
  		else if(dio3sts.equals("2")) {
  			%>
  			<label class="circle DISABLED"></label>
  			<%}%>
  		</td>
  <% } else
  	{%>
  	<td>
  		<label class="circle DISABLED"></label>
  	</td>
  	<%}%>
  <%} %> --%>
  <%-- else {%>
  <td>
  <label class="circle DISABLED"></label>
  <%out.print(""); %>
  </td>
  <%} %> --%>
  </tr>

	 <%  row++; 
	     }
		}
		catch(Exception e)
		{
			e.printStackTrace();	
	
	    }
		finally
		{
		}
     %>
</tbody>
</table>
</div>
<div>
<input hidden id="cnt" name="cnt" value="<%=row%>"/>
</div>
</div>	
</form>
<script>

var rgtClickContextMenu = document.getElementById('div-context-menu');
var secolumnsmap=new Map();
<%
Set<String> colset = usercolmap.keySet();
for(String colname : colset)
{%>
secolumnsmap.set("<%=colname%>",<%=usercolmap.get(colname)%>)
<%}%>
document.onclick = function(e) {
  //rgtClickContextMenu.style.display = 'none';
}
document.oncontextmenu = function(e) {
  var elmnt = e.target
  if(rgtClickContextMenu.style.display == 'block')
  {
	  e.preventDefault();
	  rgtClickContextMenu.style.display = 'none'
	  return;
  }
  if (elmnt.className.startsWith("cls-context-menu")) {
    e.preventDefault();
    var eid = elmnt.id.replace(/link-/, "")
    rgtClickContextMenu.style.left = e.pageX + 'px'
    rgtClickContextMenu.style.top = e.pageY + 'px'
    rgtClickContextMenu.style.display = 'block'
    var toRepl = "to=" + eid.toString()
    rgtClickContextMenu.innerHTML = rgtClickContextMenu.innerHTML.replace(/to=\d+/g, toRepl)
  }
}
function hideContextmenu()
{
	rgtClickContextMenu.style.display = 'none';
}

</script>
</body>
<jsp:include page="bootstrap-footer.jsp" flush="false" />