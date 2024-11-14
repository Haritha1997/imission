
<%@page import="com.nomus.staticmembers.NodeStatus"%>
<%@page import="com.nomus.staticmembers.QueryGenerator"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.*" %>
<%@page import="java.lang.*" %>
   
   <jsp:include page="/bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="M2M" />
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
function doFilter()
{  
         var $rows = $('#tab #rowdata');
         var val = $.trim($('#search').val()).replace(/ +/g, ' ').toLowerCase();
         $rows.show().filter(function() {
             var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
             return !~text.indexOf(val);
         }).hide();	
}

function validateDeleteNodes()
{
	var table = document.getElementById("tab");
	var rows = table.rows;
	 for (var j = 1; j < rows.length; j++)
	{
		var cboxobj = document.getElementById("check" + j);
		if(cboxobj.checked)
		{
			/* var commentval = prompt("Please enter comment:", "");
			if(commentval != null)
			{
				document.getElementById("comm").innerHTML = commentval; 
			} */
			return true;
		}
			
	}
 	alert("Please select atleast one option");
	return false;	
}
function submitForm()
{
	var form = document.getElementById("m2mform");
	if(validateDeleteNodes())
		form.submit();	
}
</script>
	</head> 
  <%
  	Vector<String> services_vec = new Vector<String>();
  	String remote = null;
  	String ipaddress = null ;
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
	 String YELLO_OVAL = "inactive";
  	 String status = RED_OVAL;
	 final String DOWN_STR="down";
	 final String ACTIVE_STR="active";
	 final String DELETED_STR="deleted";
  	 int row=1;
  	 User curuser = (User)session.getAttribute("loggedinuser");
  %>

<body>
<div align="left" style="display:inline;">
<button class="btn btn-default" onClick="checkAll()" value="Select All">Select All</button>
<button class="btn btn-default" onClick="uncheckAll()" value="Unselect All">Unselect All</button></div>
<div style="float:right;"><input  type="submit" class="btn btn-default" value="Delete" onclick="submitForm()"></div>

<form id="m2mform" class="form-horizontal" method="post" action="m2mdeletenodes">
      <div style="overflow-y:scroll;max-height:68vh;background-color:white;">
	  <table class="table table-bordered" id="tab" style="width:100%;">
      <thead id="sticky">	  
				      <tr>
					  <th style="min-width:10px;"><div valign="middle" class="cls-context-menu-link">
					   Select
					  </div></th>
					  <th style="min-width:10px;"><div valign="middle" class="cls-context-menu-link">
					   Status
					  </div></th>
					<th style="min-width:110px;"><div valign="middle" class="cls-context-menu-link">Node Label
					</div></th>
					<th style="min-width:150px;"><div valign="middle" class="cls-context-menu-link">
					    Cellular IP Address
					</div></th>
					<th style="min-width:150px;"><div valign="middle" class="cls-context-menu-link">
					    Loopback IP Address
					</div></th>
					<th style="min-width:110px;"><div valign="middle" class="cls-context-menu-link">
					    Serial Number
					</div></th>
					<th style="min-width:60px;"><div valign="middle" class="cls-context-menu-link">
					     Location
					</div></th>
					<th style="min-width:60px;"><div valign="middle" class="cls-context-menu-link">
					     FW Version
					</div></th>
					<th style="min-width:110px;"><div valign="middle" class="cls-context-menu-link">
					     Model Number
					</div></th>
					<th style="min-width:110px;"><div valign="middle" class="cls-context-menu-link">
					     Router Uptime
					</div></th>
					<th style="min-width:90px;"><div valign="middle" class="cls-context-menu-link">
					     IMEI NO
					</div></th>
					<th style="min-width:90px;"><div valign="middle" class="cls-context-menu-link">
					     Active Sim
					</div></th>
					<th style="min-width:90px;"><div valign="middle" class="cls-context-menu-link">
					    Network
					</div></th>
					<th style="min-width:110px;"><div valign="middle" class="cls-context-menu-link">
					     Signal Strength
					</div></th>
					<th style="min-width:90px;"><div valign="middle" class="cls-context-menu-link">
					     Comment
					</div></th>
					<th style="min-width:160px;"><div valign="middle" class="cls-context-menu-link">
					     Replaced Serial Numbers
					</div></th>
				    </tr>
		</thead>			
<%
		Session hibsession = null;
		try
		{    
			NodedetailsDao ndao = new NodedetailsDao();
			List<NodeDetails> nodelist = ndao.getNodeList(curuser, NodeStatus.ALL, true);
            for(NodeDetails node : nodelist)
			{	
%>
<tbody id="rowdata">
<tr>
<td align="center">
<input type="checkbox" id="check<%=row%>" name="<%=node.getId()%>" value="<%=node.getId()%>"></input>
</td>
<!--Status-->
<td align="center">
<%
     status = node.getStatus();
     if(status.equals(RED_OVAL) || status.equals(YELLO_OVAL))
	{
		%>
		<!--<img src="\imission\images\nodedown1.png" alt="" ></img>-->
		<label class="circle DOWN"></label>
		
	<%}
	 else {%>
		<!--<img src="\imission\images\nodeup.png" alt="" ></img>-->
		<label class="circle UP"></label>
	<%}%>
</td>
<!-- Node Label -->
  <td align="center">
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
  <td align="center">
	<%
	ipaddress =node.getIpaddress();
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
<td align="center">
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
  <!-- Device Serial Number -->
  <td align="center">
  <a href="node.jsp?slnumber=<%=node.getSlnumber()%>">
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
  <!-- Location -->
  <td align="center">
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
  <td align="center">
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
  <td align="center">
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
<!-- Router Uptime -->
  <td align="center">
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
<!-- IMEI Number -->
  <td align="center">
    <%
		String imeino =node.getImeinumber();
		if(imeino == null)
		{
			out.print("");
		}
		else{
			out.print(imeino);
		}	
	%>
  
  </td>
<!-- Active Sim -->
  <td align="center">
  <%if(status.equalsIgnoreCase("up")) { %>
  <%
		String actvsim =node.getActivesim();
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
<!-- Network -->
  <td align="center">
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
<!-- Signal Strength-->
  <td align="center">
  <%if(status.equalsIgnoreCase("up")) { %>
  <%
		String sgnalstnth =node.getSignalstrength();
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
<td>
<input type="text" id="comment<%=node.getId()%>" name="comment<%=node.getId()%>" min="5" value="" placeholder="manual/fault">
</td>
<td>
<input type="text" id="repslnum<%=node.getId()%>" name="repslnum<%=node.getId()%>" value="">
</td>
  </tr>
	 <%
	 	row++; }
	 		
	 		}
	 		catch(Exception e)
	 		{
	 			e.printStackTrace();	
	 	
	 	    }
	 		finally
	 		{
		 		if (hibsession != null)
		 			hibsession.close();
	 		}
	 %>
	 
</tbody>
</table>
<div>
</div>
</div>
</form>
</body>

<jsp:include page="/bootstrap-footer.jsp" flush="false" />