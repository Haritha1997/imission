
<%@page import="java.util.Vector"%>
<%@page import="java.util.List"%>
<%@page import="com.nomus.staticmembers.NodeStatus"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
   
   <jsp:include page="/bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="M2M" />
   <jsp:param name="limenu" value="Dashboard" />
   <jsp:param name="lisubmenu" value="Deleted" />
   <jsp:param name="headTitle" value="M2M" />
  </jsp:include>

   <head>
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
thead{
	background-color:#ddd;
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
   function checkAll()
  {
	  var tab = document.getElementById("tab");
	  var len = tab.rows.length;
      for (var c = 1; c <len; c++)
      {  
          var checkobj = document.getElementById("check"+c);
		  if(checkobj != null)
			  checkobj.checked = true;
      }
  }
  
  function uncheckAll()
  {
      var tab = document.getElementById("tab");
	  var len = tab.rows.length;
      for (var c = 1; c <len; c++)
      {  
          var checkobj = document.getElementById("check"+c);
		  if(checkobj != null)
			  checkobj.checked = false;
      }
  }
function validateRecoverNodes()
{
	var altmsg = "";
	var atleastsel = false;
  	var table = document.getElementById("tab");
  	var rows = table.rows;
  	 for (var j = 1; j < rows.length; j++)
  	 {
  		var cboxobj = document.getElementById("check" + j);
  		if(cboxobj.checked)
  		{
  			atleastsel = true;
  			if(document.getElementById("comment"+j).value.trim() != "" || document.getElementById("repslnum"+j).value.trim() != "")
  				altmsg += "Please remove comment and replaced serial number fields to recover node\n ";
  		}
  	 }
  	 if(!atleastsel)
  	 {
  		alert("Please select atleast one option");
  	  	return false; 
  	 }
  	 else if(altmsg != "")
  	 {
  		 alert(altmsg);
  		 return false;
  	 }
  	 return true;
  	
  } 
function submitForm()
{
	var form = document.getElementById("m2mform");
	if(validateRecoverNodes())
		form.submit();
}
</script>
	</head>
  <%
  	Vector<String> services_vec = new Vector<String>();
  	String remote = null;
  	String ipaddress = null ;
  	String loopbackip =null;
  	String nodename = null ;
  	 String RED_OVAL = "down";
  	 String GREEN_OVAL = "up";
	 String YELLO_OVAL = "inactive";
  	 String status = RED_OVAL;
	 final String DOWN_STR="down";
	 final String ACTIVE_STR="active";
	 final String DELETED_STR="deleted";
  	 int row=1;
  	 User loggedinuser = (User)session.getAttribute("loggedinuser");
  	  String statusmsg = "";
     if(session.getAttribute("recoverMsg") != null)
     {
    	 statusmsg = session.getAttribute("recoverMsg").toString();
    	 session.removeAttribute("recoverMsg");
     } 
  %>
  

<body>
<%if(!loggedinuser.getRole().equals(UserRole.MONITOR)){%>
	<div align="left" style="display:inline;">
	<button class="btn btn-default" onClick="checkAll()">Select All</button>
	<button class="btn btn-default" onClick="uncheckAll()">Unselect All</button></div>
	<div style="float:right;"><input  type="submit" class="btn btn-default" value="Recover" onclick="submitForm()">
	</div>
<%}%>
<form id="m2mform" class="form-horizontal" method="post" action="m2mrecovernodes">

  <div style="overflow-y:scroll;height:68vh;background-color:white;">
	  <table class="table table-bordered" id="tab" style="width:100%;">
      <thead id="sticky">	  
				      <tr>
					  <th style="min-width:100px;"><div valign="middle" class="cls-context-menu-link">
					   Select
					  </div></th>
					<th style="min-width:120px;"><div valign="middle" class="cls-context-menu-link">
					    Node Label
					</div></th>
					<th style="min-width:120px;"><div valign="middle" class="cls-context-menu-link">
					    Connected IP
					</div></th>
					<th style="min-width:120px;"><div valign="middle" class="cls-context-menu-link">
					    Loopback IP
					</div></th>
					<th style="min-width:120px;"><div valign="middle" class="cls-context-menu-link">
					    Serial Number
					</div></th>
					<th style="min-width:120px;"><div valign="middle" class="cls-context-menu-link">
					     Location
					</div></th>
					<th style="min-width:120px;"><div valign="middle" class="cls-context-menu-link">
					     FW Version
					</div></th>
					<th style="min-width:120px;"><div valign="middle" class="cls-context-menu-link">
					     Model Number
					</div></th>
					<!--  <th width="8%"><div valign="middle">
					     Router Uptime
					</div></th> -->
					<th style="min-width:100px;"><div valign="middle" class="cls-context-menu-link">
					     IMEI NO
					</div></th>
					<th style="min-width:100px;"><div valign="middle" class="cls-context-menu-link">
					     Comment
					</div></th> 
					<th style="min-width:160px;"><div valign="middle" class="cls-context-menu-link">
					    Replaced Serial Numbers
					</div></th>
					<!-- <th width="8%"><div valign="middle">
					     Signal Strength
					</div></th> -->
					
				    </tr>
		</thead>			
<%
		Session hibsession = null;
		try
		{    
			NodedetailsDao ndao = new NodedetailsDao();
			List<NodeDetails> nodelist = ndao.getNodeList(loggedinuser, NodeStatus.DELETED, true);
            for(NodeDetails node : nodelist)
			{
%>
<tbody id="rowdata">
<tr>
<td>
<input type="checkbox" id="check<%=row%>" name="<%=node.getId()%>" value="<%=node.getSlnumber()%>"></input>
</td>
<!-- Node Label -->
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
  <!-- IpAddress -->
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
<!-- Loopback IP -->
<td>
	<%
	loopbackip  = node.getLoopbackip();
	if(loopbackip == null)
	{
		out.print("-");
	}
	else{
		out.print(loopbackip.replace(" ", "<br/>"));
	}	
%>
  </td>
  <!-- Device Serial Number -->
  <td>
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
  
  </td>
  <!-- Location -->
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
<!-- Firmware Version -->
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

<!-- Model Number -->
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
<!-- IMEI Number -->
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
   <td>
       <input type="text" id="comment<%=row%>" name="comment<%=node.getId()%>" min="5" value="<%=node.getComment()%>">
     </td>
     <td>
     <input type="text" id="repslnum<%=row%>" name="repslnum<%=node.getId()%>" value="<%=node.getRepslnummber()%>">
     
     </td>
  </tr>
	 <%  row++; }
		
		}
		catch(Exception e)
		{
			e.printStackTrace();		
	    }
		finally
		{
			if(hibsession != null)
				hibsession.close();
		}
     %>
    
	 
</tbody>
</table>
</div>	
</form>
</body>
 <%if(statusmsg.trim().length() > 0)
{%>
<script>
alert('<%=statusmsg%>');
</script>
<%}%> 
<jsp:include page="/bootstrap-footer.jsp" flush="false" />