
<%@page import="com.nomus.staticmembers.M2MProperties"%>
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


   <jsp:include page="/bootstrap.jsp" flush="false">
   <jsp:param name="title" value="Download Configuration"/>
   <jsp:param name="headTitle" value="Download Config" />
  </jsp:include>

   <head>
   <link rel="stylesheet" href="/imission/css/fontawesome.css">
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
	 final String ACTIVE_STR="active";
	 final String DELETED_STR="deleted";
  	 int row=1;
	 String fetchtype = request.getParameter("type")==null?"active":request.getParameter("type");
	 User user = (User)request.getSession().getAttribute("loggedinuser");
	 NodedetailsDao nddao = new NodedetailsDao();
	/* List<UserColumns> ucollist= user.getUserColumnsList();
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
	} */
	
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
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
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
function downloadConfig(slnum)
{
	const form = document.createElement('form');
	form.method = 'post';
	form.action = "DownloadConfigFile?slnumber="+slnum;
	document.body.appendChild(form);
 	form.submit(); 
}
</script>
<% String sorttype =  request.getParameter("sorttype")==null? "desc":request.getParameter("sorttype").equals("asc")?"asc":"desc";
String sortby =  request.getParameter("sortby")==null? "id":request.getParameter("sortby"); %>
<body>
<form id="configform"  class="form-horizontal" method="post" onsubmit="">
<% String labelname_arr[]={"Node Label","Connected IP","Serial Number","Location","FW Version","Download"};%>	

 <div style="overflow-y:scroll;max-height:68vh">
	  <table class="table table-bordered" id="tab" style="width:100%;">
      <thead id="sticky">	  
	      <tr>
	      		<% for (String labelname : labelname_arr) { 
			      	if(labelname.equals("Download")){%>
			    	  
			    	  <th style="min-width:60px; ">
			      		 <div valign="middle"><%=labelname%>
						</div>
			     	</th>
			      <%}else{%>
				      	<th style="min-width:90px; ">
			      		 <div valign="middle"><%=labelname%>
						</div>
			     	</th>
			      <%}
		      }%>
		 </tr>
		</thead>
		<div id="div-context-menu" class="cls-context-menu">
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
					nodelist = nddao.getNodeList(user,NodeStatus.ALL,true);
				Properties props = M2MProperties.getM2MProperties();
				String targetfilename = props.getProperty("targetfilename")==null?"":props.getProperty("targetfilename");
				String tlsconfigspath = props.getProperty("tlsconfigspath")==null?"":props.getProperty("tlsconfigspath");
				File srcfile = null;
				
            for(NodeDetails node : nodelist)
			{
            	File tlsdir = new File(tlsconfigspath+File.separator+node.getSlnumber());
            	if(tlsdir.exists())
    			{
    				srcfile =  new File(tlsdir+File.separator+targetfilename);
    			}
%>
<tbody id="rowdata">
<% if(srcfile.exists())
{%>
<tr>
<!-- Node Label -->
<%if(labelname_arr[0].equals("Node Label")) {%>
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
  <%if(labelname_arr[1].equals("Connected IP")) {%>
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
  <!-- Device Serial Number -->
  <%if(labelname_arr[2].equals("Serial Number")) {%>
  <td>
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
  <%}%>
  <!-- Location -->
  <%if(labelname_arr[3].equals("Location")) {%>
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
<%if(labelname_arr[4].equals("FW Version")) {%>
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
<%if(labelname_arr[5].equals("Download")) {%>
  <td>
  <i class="fa fa-download" style="cursor:pointer" onclick="downloadConfig('<%=node.getSlnumber()%>')"></i>
</td>
<%}%>
  </tr>
	 <%}
	 }
		}
		catch(Exception e)
		{
			e.printStackTrace();	
	    }
     %>
</tbody>
</table>
</div>
<div>
</div>
</div>	
</form>
<script>


</script>
</body>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />