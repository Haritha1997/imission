
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>

<%
	JSONObject statusnnode = null;
	JSONArray ipsecstatusarr = null;
	BufferedReader jsonfile = null;
	String slnumber = request.getParameter("slnumber");
	if (slnumber != null && slnumber.trim().length() > 0) {
		Properties m2mprops = M2MProperties.getM2MProperties();
		String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + slnumber;
		File statusfile = new File(slnumpath + File.separator + "Status.json");
		if (statusfile.exists()) {
			jsonfile = new BufferedReader(new FileReader(statusfile));
			StringBuilder jsonbuf = new StringBuilder("");
			String jsonString = "";
			try {
				while ((jsonString = jsonfile.readLine()) != null)
					jsonbuf.append(jsonString);
				statusnnode = JSONObject.fromObject(jsonbuf.toString());

				ipsecstatusarr = statusnnode.getJSONObject("STATUS").getJSONObject("IPSEC").getJSONObject("IPSEC_SPD_CONFIG")
						.getJSONArray("arr");
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (jsonfile != null)
					jsonfile.close();
			}
		}
	}
%>
<head>
<style type="text/css">
#WiZConf {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 12.5px;
	border-collapse: collapse;
	width: 600px;
}

#WiZConf td, #WiZConf th {
	border: 2px solid #ddd;
	padding: 8px;
	text-align: center;
}

#WiZConf tr:nth-child(even) {
	background-color: #f2f2f2;
}

#WiZConf tr:hover {
	background-color: #d3f2ef;
}

#WiZConf th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: center;
	background-color: #5798B4;
	color: white;
}

.text {
	background: white;
	border: 2px Solid #DDD;
	border-radius: 5px;
	box-shadow: 1 1 5px #DDD inset;
	color: #000;
	height: 17px;
}

.button {
	display: block;
	border-radius: 6px;
	background-color: #6caee0;
	color: #ffffff;
	font-weight: bold;
	box-shadow: 1px 2px 4px 0 rgba(0, 0, 0, 0.08);
	padding: 12px 20px;
	border: 0;
}

.style1 {
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	color: #5798B4;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer
}

td #borderless {
	border: none;
	padding: 0 0 0 0;
}

#noborder {
	border: none;
	align: center
}

a {
	text-decoration: none;
	cursor: pointer
}
</style>
</head>
<body>
	<p class="style1" align="center">IPSEC SPD DETAILS</p>
	<table id="WiZConf" align="center">
		<tbody>
			<tr>
				<th width="150">Instance Name</th>
				<th width="150">Local Network</th>
				<th width="150">Remote Network</th>
				<th width="150">Local Peer</th>
				<th width="150">Remote Peer</th>
				<th width="150">Status</th>
			</tr>
         <%
         if(ipsecstatusarr != null)
         {
        	 for(int i=0;i<ipsecstatusarr.size();i++)
        	 {
        		 JSONObject tunins = ipsecstatusarr.getJSONObject(i);
        		 String insname = tunins.getString("Instance_Name")==null?"":tunins.getString("Instance_Name");
        		 String local_nw = tunins.getString("Local_Network")==null?"":tunins.getString("Local_Network");
        		 String remote_nw = tunins.getString("Remote_Network")==null?"":tunins.getString("Remote_Network");
        		 String local_peer = tunins.getString("Local_peer")==null?"":tunins.getString("Local_peer");
        		 String remote_peer = tunins.getString("Remote_Peer")==null?"":tunins.getString("Remote_Peer");
        		 String status = tunins.getString("Status")==null?"":tunins.getString("Status");
        		 %>
        		 <tr>
        		 <td><%=insname%></td>
        		 <td><%=local_nw%></td>
        		 <td><%=remote_nw%></td>
        		 <td><%=local_peer%></td>
        		 <td><%=remote_peer%></td>
        		 <td><%=status%></td>
        		 </tr>
        	 <%}
         }
         %>
		</tbody>
	</table>
</body>

