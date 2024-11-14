<%@page import="com.nomus.staticmembers.NodeStatus"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="com.nomus.m2m.dao.FavouritesDao"%>
<%@page import="com.nomus.m2m.pojo.Favourites"%>
<%@page import="java.util.*" %>

   <jsp:include page="bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="imission"/>
   <jsp:param name="headTitle" value="imission"/>
   </jsp:include>
   <head>
   <style>
   
   #sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  z-index: 1;
}
html, body {margin: 1; height: 100%; overflow: hidden}
   
   </style>
   <script>
   function checkMinSel(selobj)
   {
	   if(selobj.checked)
	   {
			var checkboxes = document.querySelectorAll('input[type="checkbox"]:checked');
			if(checkboxes.length > 10)
			{
				alert("Maxinum Number (10) of Favourite Nodes  Exceeded.");
				selobj.checked = false;
			}				
	   }
   }
   </script>
   </head>
   <form method="post" name="form" id="form" action="savefavourites">																																																																																																																																							
   <div style="width:100%;text-align:right;padding-bottom:5px;">
	<input type="submit" id="submit" class="btn btn-default" value="Submit" style="padding-right:2px;"></input>
	</div>
   <div style="overflow-y:scroll; height:62vh;background-color:white;">
   <table class="table table-bordered" id="tab">
    <thead id="sticky">
				
					<th width="10%">Select</th>
					<th width="15%">Node Name</th>
					<th width="15%">Serial No</th>
					<th width="15%">Loopback IP</th>
					<th width="15%">IMEI Number</th>
					<th width="15%">Location</th>
				</thead>
				
  <% 
	int row=0;
  	User user = (User)session.getAttribute("loggedinuser");
	Hashtable<String,String> favouritesmap = new Hashtable<String,String>();
	try
	{
		for(String fav : user.getFavouriteList())
			favouritesmap.put(fav, fav);
		List<NodeDetails> ndetlist = new NodedetailsDao().getNodeList(user, NodeStatus.ALL, true);
		for(NodeDetails ndet : ndetlist)
		{
			String slnumber = ndet.getSlnumber();
			row++;
			%>
		<tbody id="rowdata">
		<tr>
		<td><input onchange="checkMinSel(this)" class="nodecheck" type="checkbox" name="favourites" value="<%=ndet.getSlnumber()%>" <%if(favouritesmap.get(slnumber) != null){%>checked <%}%>></input> <input type="hidden" name="slnumber<%=row%>" value="<%=slnumber%>"></input></td>
		<td><%=ndet.getNodelabel()%></td>
		<td><%=slnumber%></td>
		<td><%=ndet.getLoopbackip()%></td>
		<td><%=ndet.getImeinumber()%></td>
		<td><%=ndet.getLocation()%></td>
		</tr>	
		<%}
		
	}catch(Exception e)
	{
		e.printStackTrace();
	}
  %>
  
   </tbody>
   </table>
   </div>
 </form>
 <script>
 setSearchTableId('tab');
 </script>
<jsp:include page="bootstrap-footer.jsp" flush="false" />