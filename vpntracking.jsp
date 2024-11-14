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
 		String version=request.getParameter("version");
		String errorstr = request.getParameter("error");
%>
<html>
<head>
    <link rel="stylesheet" href="css/fontawesome.css">
      <link rel="stylesheet" href="css/fontawesome.css">
      <link rel="stylesheet" href="css/solid.css">
      <link rel="stylesheet" href="css/v4-shims.css">
      <link rel="stylesheet" type="text/css" href="css/style.css">
	  <link rel="stylesheet" href="css/openvpn.css">
	  <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
	  <script type="text/javascript" src="js/common.js"></script>
</head>
<style type="text/css">
		.container{
		height:430px; 
		width: 850px;
		overflow: scroll;
		border-radius: 5px;
		margin: 0 auto;
		border-bottom-style: solid;
		border-right-style: solid;
		border-top-style: solid;
		border-left-style: solid;
		padding: 5px;
		}
		.content{
		padding:10 10 10 10;
		}

        #icon{
            margin-top: 150px;
        }
#loading {
	display: none;
	top: 0;
	left: 0;
	z-index: 100;
	width: 60vw;
	height: 60vh;
	background-image: url("icons/loading.gif ");
	background-repeat: no-repeat;
	background-position: center;
	transition-duration: 10s;
}

</style>
<body>
    <p class="style1" id="title" align="center">Tracking</p>
    <br>
    <div align="center">
        <table class="borderlesstab nobackground" style="width:660px;margin-bottom:0px;margin-bottom:0px;">
            <tbody>
                <tr style="padding:0px;margin:0px;">
                    <td style="padding:0px;margin:0px;">
                        <ul id="dtrackdiv">
							<li><a class="casesense dtracklist" style="cursor:pointer" id="hilightthis" onclick="showPDivision('logsdiv');">Logs</a></li>
                            <li><a class="casesense dtracklist" style="cursor:pointer" id="" onclick="showPDivision('statsdiv');">Stats</a></li>   
							<li><a class="casesense dtracklist" style="cursor:pointer" id="" onclick="showPDivision('resetdiv',true);" >Reset</a></li>
                        </ul>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Logs -->
    <div id="logsdiv" style="" align="center" >
		<form action="savedetails.jsp?page=vpntrackinglogs&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="">
				<p class="style5" align="center">Logs</p><br/>					
				<textarea id="text" name="text" align="center" cols="100" rows="25" style="font-size:12px; overflow:scroll;" readonly="readonly" wrap="off">
				</textarea>
				<div align="center">
				<input type="submit" name="refresh" value="Refresh" class="button">
				</div>
		</form>
	</div>

    <!-- Stats -->
    <div id="statsdiv" style="" align="center">
		<form action="savedetails.jsp?page=vpntrackingstats&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="">
				<p class="style5" align="center">Stats</p><br/>					
				<textarea id="text" name="text" align="center" cols="100" rows="25" style="font-size:12px; overflow:scroll;" readonly="readonly" wrap="off">
				
				</textarea>
				<div align="center">
				<input type="submit" name="refresh" value="Refresh" class="button">
				</div>
		</form>
	</div>

    <!-- Reset -->
     <div id="resetdiv" style="" align="center">
        <div class="loading" id="loading" style="text-align:center"></div>
    </div>
    
</body>
<script>
	
//Function - Show division for Stats, Logs and Reset
function showPDivision(divname,wait)
{
    var divname_arr = ["logsdiv","statsdiv","resetdiv"];
	var dtracklist = document.getElementsByClassName("dtracklist");
    for(var i=0;i<divname_arr.length;i++)
	{		
		if(divname == divname_arr[i])
		{
			dtracklist[i].id="hilightthis";
			document.getElementById(divname_arr[i]).style.display = "";
			if(divname == 'resetdiv')
			{
				if(wait)
				{
					showSpinner();
				}
			}
			
		}
		else
		{
			dtracklist[i].id="";
			document.getElementById(divname_arr[i]).style.display = "none";			
		}
	}
}
function showSpinner() {
	setVisible('#loading', true);	
}

function setVisible(selector, visible) {
	document.querySelector(selector).style.display = visible ? 'block' : 'none';
	var spinner = document.getElementById("resetdiv");
	setTimeout(function() {
		spinner.style.display = "none"; 
		}, 3000);
}
</script>
<script>
    showPDivision("logsdiv"); 	
</script>
</html></html>