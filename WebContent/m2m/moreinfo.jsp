<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Properties"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.nomus.staticmembers.Symbols"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <jsp:include page="/bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="M2M" />
   <jsp:param name="headTitle" value="M2M" />
  </jsp:include>
  <%
  Vector<Hashtable<String,String>> ipsec_vec = new Vector<Hashtable<String,String>>();
  Vector<Hashtable<String,String>> openvpn_vec = new Vector<Hashtable<String,String>>();
  Hashtable<String,String> device_info_ht = new Hashtable<String,String>();
  Hashtable<String,String> cellular_info_ht = new Hashtable<String,String>();
  Hashtable<String,String> config_info_ht = new Hashtable<String,String>();
  Hashtable<String,String> activity_ht = new Hashtable<String,String>();
  Hashtable<String,String> outage_ht = new Hashtable<String,String>();
  Vector<Hashtable<String,String>> alarms_vec = new Vector<Hashtable<String,String>>();
  Hashtable<String,String> lan_vec = new Hashtable<String,String>();
  NodeDetails nd = null;
  String err_url = "";
  String err_param="";
  String err_msg="";
  String serialno = request.getParameter("slnumber") == null ? "active" : request.getParameter("slnumber");
  boolean node_exists = false;
  ArrayList<String> ipsec_headlist = new ArrayList<String>();
  ArrayList<String> openvpn_headlist = new ArrayList<String>();
  ArrayList<String> ethport_list = new ArrayList<String>();
  Vector<String> wanip_vec = new Vector<String>();
  String version = "";
  String devinfo_arr[] = { "Discovered On", "Serial Number", "Model Number", "Node Label", "Location",
			"Hardware Version", "Software Version", "Software Date", "Status", "Uptime",
			"Loopback IP Address" };
	ArrayList<String> devinfo_key_list = new ArrayList<String>();
	for (String key : devinfo_arr)
		devinfo_key_list.add(key);
	String cellular_arr[] = { "Module Name", "Module Revision", "Hardware Version", "Active SIM",
  			"Cellular IP Address", "IMEI", "Network", "Network Band", "Signal Strength", "Cell ID", "ICC ID" };
  	ArrayList<String> cellular_key_list = new ArrayList<String>();
  	for (String key : cellular_arr)
  		cellular_key_list.add(key);
  	String config_arr[] = {"Edit","Export","FW Upgrade","Reboot"};
  	ArrayList<String> config_key_list = new ArrayList<String>();
  	for (String key : config_arr)
  		config_key_list.add(key);
  	String activity_arr[] = { "Configuration", "Firmware Upgrade", "Reboot", "Down At", "Down Duration" };
  	String status = "";
  	SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM YYYY hh:mm:ss aaa");
  	SimpleDateFormat dfmt = new SimpleDateFormat("dd-MM-yyyy");
  	SimpleDateFormat total_time_fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  	String htkey = "";
  	String sim1dayupvalue = "";
  	String sim1daydownvalue = "";
  	String sim1daydatevalue = "";
  	String sim1weekupvalue = "";
  	String sim1weekdownvalue = "";
  	String sim1weekdatevalue = "";
  	String sim1monthupvalue = "";
  	String sim1monthdownvalue = "";
  	String sim1monthdatevalue = "";
  	String sim2dayupvalue = "";
  	String sim2daydownvalue = "";
  	String sim2daydatevalue = "";
  	String sim2weekupvalue = "";
  	String sim2weekdownvalue = "";
  	String sim2weekdatevalue = "";
  	String sim2monthupvalue = "";
  	String sim2monthdownvalue = "";
  	String sim2monthdatevalue = "";

  	String upvalue = "";
  	String downvalue = "";
  	String datevalue = "";
  	outage_ht.put("tup", "100");
  	outage_ht.put("tdown", "0");
  	outage_ht.put("yup", "100");
  	outage_ht.put("ydown", "0");
  	outage_ht.put("wup", "100");
  	outage_ht.put("wdown", "0");
  	JSONObject statusobj = null;
  	BufferedReader jsonfile = null;
  	StringBuffer jsonbuf = new StringBuffer("");
  	if (serialno != null && serialno.trim().length() > 0) {
  		Properties m2mprops = M2MProperties.getM2MProperties();
  		String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + serialno;
  		try {
  			jsonfile = new BufferedReader(new FileReader(new File(slnumpath + File.separator + "Status.json")));
  		} catch (Exception e) {
  			e.printStackTrace();
  		}
  		String jsonString = null;
  		if (jsonfile != null) {
  			while ((jsonString = jsonfile.readLine()) != null)
  				jsonbuf.append(jsonString);
  		}
  	}
  %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
canvas
{
	min-height:60%;
	max-height:60%;
	min-width:60%;
	max-width:100%;
}
table div
{
padding-bottom: 10px;
}
.titleheader
{
font-size: 20px;
}
.borderlesstab
{
width:98%;
}
.borderlesstab td
{
 vertical-align: top;
 min-width:25%;
 width:25%;
 max-width:25%;
 padding-right:50px;
 padding-bottom:30px;
}
.innertab
{
 width:100%;
 padding-bottom:30px;
}
.innertab td
{
padding:0px;
}
#devinfotab td,#configtab td, #ethporttab td, #celllartab td, #activitytab td, #wantab td, #diotab td,#zerotiretab td, #openvpntab td,#ipsectab td
{
border: 1px solid white;
padding-left:5px;
height:22px;
font-weight: bold;
vertical-align: middle;
}
#devinfotab td:nth-child(odd),#celllartab td:nth-child(odd),#activitytab td:nth-child(odd),#configtab td:nth-child(odd)
{
	min-width:40%;
	max-width:48%;
	width:40%;
	background-color:#696969;
	color:white;
}
#devinfotab td:nth-child(even),#celllartab td:nth-child(even),#activitytab td:nth-child(even),#configtab td:nth-child(even)
{
	min-width:52%;
	max-width:52%;
	width:52%;
	background-color:#EEE;
	padding-top:5px;
}
#ethporttab td, #diotab td
{
 text-align:center;
 font-size: 12px;
 width:80px;
 min-width: 60px;
 color:#FFD;
}
#ipsectab th,#ipsectab td,#wantab th,#wantab td ,#zerotiretab td,#openvpntab td,#openvpntab th,#zerotiretab th
{
/* max-width:100px; */
height:26px;
 border: 1px solid #D3D3D3;
 text-align: center;
 vertical-align: middle;
}
#ipsectab th,#wantab th,#zerotiretab th,#openvpntab th
{
background-color: #696969;
color:white;
text-align: center;
}
#ipsectab td,#wantab td ,#zerotiretab td,#openvpntab td
{
 padding-left: 5px;
}
.UP
{
 background-color: rgb(0, 150, 0);
}
.Active
{
 background-color: rgb(0, 150, 0);
}
.disabled,.Disabled,.DISABLED,.NA,.na,.Na,.LANNA,.LANna,.LANNa
{
background-color: grey;
}
.DOWN,.LANDOWN,.DI1
{
 background-color: #FF0900;
}
.LANUP,.DI0
{
  background-color: #AACE77;	
}
.Progress
{
	background-color:#1974d0;
}
.warning
{
background-color:#FFA500;
}
.circle
{
	width:12px;
	height:12px;
	margin-left:45%;
 	border-radius: 25px;
}
label{
	margin:0px;
	margin-top:2px;
}
.toppaddiv
{
padding-top: 30px;
}
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
}
.DI2
{
background-color: #B2BEB5;
}
.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
}
/* #topnavdivision 
{
	background-color: #7BC342;
} */
#topnavdivision a 
{
	float: left;
	display: block;
	padding: 2px 5px;
	text-decoration: none;
	font-size: 12px;
	color:black;
	min-width:120px;
	max-width:180px;
	background-color: #ddd;
	cursor: pointer;
	/* border-radius:5px;
	border: 1px solid green; */	
}
/* #topnavdivision a:hover 
{
	background-color: #ddd;
	border-radius:5px;
	border: 1px solid green;
	color: black;
} */
</style>
<script src="/imission/js/Chart.min.js"></script>
<script type="text/javascript">
/* function gotoUrl(slno,version,cmpstr,status) {
	var url = "";
	if(status == "up")
	{
		url = "wizng/mainpage.jsp?slnumber="+slno+"&version="+version;
		if(version.startsWith(cmpstr))
		{  
			url = "wizngv2_with_new_pages/window.jsp?slnumber="+slno+"&version="+version;
		}
		alert("url is : "+url);
		 window.open(url);
	}
		
} */
var outagechart;
//pierchart start
function createOtageChart(uppercent,downpercent)
{
outagechart = new Chart(document.getElementById("outagechart"), {
    type: 'pie',
	startAngle: 180,
    data: {
      labels: ["Up", "Down"],
      datasets: [{
        label: "Node Outage in %",
        backgroundColor: ["#AACE77", "#FF0900"],
        data: [uppercent,downpercent]
      }]
    },
    options: {
      title: {
        display: true,
        text: 'Node Outage in %'
      }
    }
});
}
function changeOutageChartData()
{
	var option = document.getElementById("outageopt").value;
	if(option == "Today")
		outagechart.data.datasets[0].data=[tup,tdown];
	else if(option == "Yesterday")
		outagechart.data.datasets[0].data=[yup,ydown];	
	else if(option == "Lastweek")
		outagechart.data.datasets[0].data=[wup,wdown];
		
	outagechart.update();
}
function setOutageData(toup,todown,yeup,yedown,weup,wedown)
{
tup = toup;
tdown=todown;
yup=yeup;
ydown=yedown;
wup=weup;
wdown=wedown;
}
//   piechart end
function setPosition(id)
{
	divele = document.getElementById(id);
	pos = divele.offsetTop-150
	window.scrollTo(0,pos);
}
function barchart(chartid,datedata,updata,downdata,charttitle) {
	var ctx = document.getElementById(chartid);
	var datedataarr = datedata.split(",");
	var updataarr = updata.split(",");
	var downdataarr = downdata.split(",");
	var tup = '100';
	var tdown = '0';
	var yup = '100';
	var ydown ='0';
	var wup = '100';
	var wdown = '0';
	//alert("datedataarr : "+datedataarr+" updataarr : "+updataarr+" downdataarr : "+downdataarr);
	data = {
	    type: "bar",
	    data: {
	        labels: [getDateFormat(datedataarr[0]), getDateFormat(datedataarr[1]), getDateFormat(datedataarr[2]), getDateFormat(datedataarr[3]), getDateFormat(datedataarr[4]), getDateFormat(datedataarr[5]), getDateFormat(datedataarr[6])],
	        datasets: [{
	            label: "Upload",
	            barPercentage: 1,
	            barThickness: 15,
	            maxBarThickness: 15,
	            minBarLength: 5,
	            backgroundColor: ["#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77"],
	            fillColor: "brown",
	            strokeColor: "red",
	            data: [updataarr[0], updataarr[1], updataarr[2], updataarr[3], updataarr[4], updataarr[5], updataarr[6]]
	        }, {
	            label: "Download",
	            barPercentage: 1,
	            barThickness: 15,
	            maxBarThickness: 15,
	            minBarLength: 5,
	            backgroundColor: ["#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE"],
	            fillColor: "blue",
	            strokeColor: "green",
	            data: [downdataarr[0], downdataarr[1], downdataarr[2], downdataarr[3], downdataarr[4], downdataarr[5], downdataarr[6]]
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
						maxTicksLimit: 8,
						
	                }
	            }],
				xAxes: [{
	                display: false
	            }]
	        },  
	        title: {
	            display: true,
	            text: charttitle
	        }
	    }
	};
	var myfirstChart = new Chart(ctx, data);
}
function getDateFormat(date)
{
	var datearr=date.split("-");
	if(datearr.length == 1)
		return date;
	if(datearr.length == 2)
	{
		if(datearr[0].split("/").length != 3)
			return date;
		var day1arr = datearr[0].split("/");
		date = day1arr[0]+"/"+getMonthName(day1arr[1]);
		var day1arr = datearr[1].split("/");
		date += "-"+day1arr[0]+"/"+getMonthName(day1arr[1]);
	}
	return date;
}
function getMonthName(month)
{
	var mthname="";
	switch(month)
	{
		case "01":
		mthname = "Jan";
		break;
		case "02":
		mthname = "Feb";
		break;
		case "03":
		mthname = "Mar";
		break;
		case "04":
		mthname = "Apr";
		break;
		case "05":
		mthname = "May";
		break;
		case "06":
		mthname = "Jun";
		break;
		case "07":
		mthname = "Jul";
		break;
		case "08":
		mthname = "Aug";
		break;
		case "09":
		mthname = "Sep";
		break;
		case "10":
		mthname = "Oct";
		break;
		case "11":
		mthname = "Nov";
		break;
		case "12":
		mthname = "Dec";
		break;
		default:
		mthname = "";
	}
	return mthname;
}
function goToErrorPage(url,param,msg)
{
	const form = document.createElement('form');
	form.method = 'post';
	form.action = url;
	input = document.createElement("input");
    input.type = "hidden";
    input.name = param;
    input.value = msg;
    form.appendChild(input);
	document.body.appendChild(form);
 	form.submit(); 
}
/* function hideorshow(divname,version)
{
	try{
	var deviceobj = document.getElementById("devicediv");
	var lanobj = document.getElementById("landiv");
	if(version.includes("EL"))
		var wanobj = document.getElementById("wandiv");
	var cellobj = document.getElementById("celldiv");
	var vpnobj = document.getElementById("ipsecdiv");
	var dataobj = document.getElementById("datadiv");
	var alarmobj = document.getElementById("alarmsdiv");
	if(divname == "ipsecdiv")
	{
		vpnobj.style.display = "";
		//deviceobj.style.display = "none";
		lanobj.style.display = "none";
		if(version.includes("EL"))
			wanobj.style.display = "none";
		cellobj.style.display = "none";
		dataobj.style.display = "none";
		alarmobj.style.display = "none";
	}
	else if(divname == "landiv")
	{
		lanobj.style.display = "";
		vpnobj.style.display = "none";
		//deviceobj.style.display = "none";
		if(version.includes("EL"))
			wanobj.style.display = "none";
		cellobj.style.display = "none";
		dataobj.style.display = "none";
		alarmobj.style.display = "none";
	}
	else if(divname == "celldiv")
	{
		vpnobj.style.display = "none";
		//deviceobj.style.display = "none";
		lanobj.style.display = "none";
		if(version.includes("EL"))
			wanobj.style.display = "none";
		cellobj.style.display = "";
		dataobj.style.display = "none";
		alarmobj.style.display = "none";
	}
	else if(divname == "datadiv")
	{
		vpnobj.style.display = "none";
		//deviceobj.style.display = "none";
		lanobj.style.display = "none";
		if(version.includes("EL"))
			wanobj.style.display = "none";
		cellobj.style.display = "none";
		dataobj.style.display = "";
		alarmobj.style.display = "none";
	}
	else if(divname=="alarmsdiv")
	{
		vpnobj.style.display = "none";
		//deviceobj.style.display = "none";
		lanobj.style.display = "none";
		if(version.includes("EL"))
			wanobj.style.display = "none";
		cellobj.style.display = "none";
		dataobj.style.display = "none";
		alarmobj.style.display = "";
	}
	else
	{
		wanobj.style.display = "";
		vpnobj.style.display = "none";
		//deviceobj.style.display = "none";
		lanobj.style.display = "none";
		cellobj.style.display = "none";
		dataobj.style.display = "none";
		alarmobj.style.display = "none";
	}
	}catch(e)
	{
		alert(e);
	}
} */
</script>
</head>
<body>
<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
Session hibsession = null;
try {
	hibsession = HibernateSession.getDBSession();
	NodedetailsDao ndao = new NodedetailsDao();
	nd = ndao.getNodeDetails("slnumber", serialno);
	conn = ((SessionImpl)hibsession).connection();
	stmt = conn.createStatement();
	String qry = "";
	if (nd != null) {
		node_exists = true;
		String ipsec_sarr[] = nd.getIpsecstats() != null? nd.getIpsecstats().split(" "):new String[0];
		String openvpn_sarr[] = nd.getOpenvpnstatus() != null? nd.getOpenvpnstatus().split(" "):new String[0];
		int tunnels = 0;
		int index = 1;
		try
		{
			if(ipsec_sarr.length > 1)
				index = 1;
			else if (ipsec_sarr[0].equals("TUNNELS"))
				index = 2;
			ipsec_headlist.add("Instance Name");
			ipsec_headlist.add("Status");
			version = nd.getFwversion();
			if (version.trim().startsWith(Symbols.WiZV2) || version.trim().endsWith(Symbols.WiZV2)) {
				ipsec_headlist.add(1,"Interface");
				ipsec_headlist.add(2,"Total Uptime");
				ipsec_headlist.add(3,"Current Uptime");
				for (int i = index; i < ipsec_sarr.length; i += 5) {
					Hashtable<String, String> ipsec_ht = new Hashtable<String, String>();
					ipsec_ht.put("Instance Name", ipsec_sarr[i]);
					ipsec_ht.put("Interface", ipsec_sarr[i + 1]);
					
					
					if ((i + 1) < ipsec_sarr.length)
					{
						ipsec_ht.put("Status", ipsec_sarr[i + 2].equals("1") ? "UP" : ipsec_sarr[i + 2].equals("2")?"DISABLED":"DOWN");
					}
					else
						ipsec_ht.put("Status", "");
					
					ipsec_ht.put("Current Uptime", ipsec_sarr[i + 3]);
					ipsec_ht.put("Total Uptime", ipsec_sarr[i + 4]);
					ipsec_vec.add(ipsec_ht);
				}
			}
			else {
				for (int i = index; i < ipsec_sarr.length; i += 2) {
					Hashtable<String, String> ipsec_ht = new Hashtable<String, String>();
					ipsec_ht.put("Instance Name", ipsec_sarr[i]);
					if ((i + 1) < ipsec_sarr.length)
					{
						ipsec_ht.put("Status", ipsec_sarr[i + 1].equals("1") ? "UP" :ipsec_sarr[i + 1].equals("2")?"DISABLED": "DOWN");
					}
					else
						ipsec_ht.put("Status", "");
					ipsec_vec.add(ipsec_ht);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		try
		{
			if(openvpn_sarr.length > 1)
				index = 1;
			else if (openvpn_sarr.length > 0 && openvpn_sarr[0].equals("TUNNELS"))
				index = 2;
			openvpn_headlist.add("Instance Name");
			openvpn_headlist.add("Mode");
			openvpn_headlist.add("Status");
				for (int i = index; i < openvpn_sarr.length; i += 3) {
					Hashtable<String, String> openvpn_ht = new Hashtable<String, String>();
					openvpn_ht.put("Instance Name", openvpn_sarr[i]);
					openvpn_ht.put("Mode", openvpn_sarr[i + 1].equals("1")?"Client To Server":"Point To Point");
					if ((i + 1) < openvpn_sarr.length)
					{
						openvpn_ht.put("Status", openvpn_sarr[i + 2].equals("1") ? "UP" : openvpn_sarr[i + 2].equals("2")?"DISABLED":"DOWN");
					}
					else
						openvpn_ht.put("Status", "");
					openvpn_vec.add(openvpn_ht);
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		device_info_ht.put("Discovered On", sdf.format(nd.getCreatedtime()));
		device_info_ht.put("Serial Number", nd.getSlnumber());
		device_info_ht.put("Model Number", nd.getModelnumber());
		device_info_ht.put("Node Label", nd.getNodelabel());
		device_info_ht.put("Location", nd.getLocation());
		device_info_ht.put("Hardware Version", nd.getMhversion());
		device_info_ht.put("Software Version", nd.getFwversion());
		device_info_ht.put("Software Date", nd.getSwdate());
		device_info_ht.put("DI 1", nd.getDi1());
		device_info_ht.put("DI 2", nd.getDi2());
		device_info_ht.put("DI 3", nd.getDi3());
		String device_status = nd.getStatus();
		String ruptime = nd.getRouteruptime();
		String ruptime_arr[] = ruptime.split(":");
		try {
			ruptime = Integer.parseInt(ruptime_arr[0]) + " days " + Integer.parseInt(ruptime_arr[1])
					+ " hours " + Integer.parseInt(ruptime_arr[2]) + " mins "
					+ Integer.parseInt(ruptime_arr[3]) + " sec";
		} catch (Exception e) {

		}
		device_info_ht.put("Status", device_status.equals("up") ? "Active"
				: device_status.equals("down") ? "Down" : "In Active");
		device_info_ht.put("Uptime", ruptime);
		device_info_ht.put("Loopback IP Address", nd.getLoopbackip());

		device_info_ht.put("P0", nd.getSwitch1());
		device_info_ht.put("P1", nd.getSwitch2());
		device_info_ht.put("P2", nd.getSwitch3());
		if(version.contains(Symbols.WiZV2))
			device_info_ht.put("P3", nd.getSwitch4());
		else
			device_info_ht.put("P3/WAN", nd.getSwitch4());
		int edit = nd.getSendconfigstatus();
		int exp = nd.getExportstatus();
		int fw = nd.getUpgradestatus();
		int reb = nd.getRebootstatus();
		String edit_pro = nd.getSendconfig();
		String exp_pro = nd.getExport();
		String fw_pro = nd.getUpgrade();
		String reb_pro = nd.getReboot();
		String edit_status = "";
		String exp_status = "";
		String fw_status = "";
		String reb_status = "";
		if(edit_pro.equals("no"))
		{
			if(edit == 1)
				edit_status = "Success";
			else if(edit == 2)
				edit_status = "Fail";
		}
		else if(edit_pro.equals("yes"))
			edit_status = "In Progress";
		if(exp_pro.equals("no"))
		{
			if(exp == 1)
				exp_status = "Success";
			else if(exp == 2)
				exp_status = "Fail";
		}
		else if(exp_pro.equals("yes"))
			exp_status = "In Progress";
		if(reb_pro.equals("no"))
		{
			if(reb == 1)
				reb_status = "Success";
			else if(reb == 2)
				reb_status = "Fail";
		}
		else if(reb_pro.equals("yes"))
			reb_status = "In Progress";
		if(fw_pro.equals("no"))
		{
			if(fw == 1)
				fw_status = "Success";
			else if(fw == 2)
				fw_status = "Fail";
		}
		else if(fw_pro.equals("yes"))
		{
			fw_status = " FW in Queue";
			if(nd.getUpgradestarttime() != null && fw != 3)
				fw_status = "In Progress";
			else if(fw == 3)
				fw_status = "Updating";
			
		}
		config_info_ht.put("Edit", edit_status);
		config_info_ht.put("Export", exp_status);
		config_info_ht.put("FW Upgrade", fw_status);
		config_info_ht.put("Reboot", reb_status);
		cellular_info_ht.put("Module Name", nd.getModulename());
		cellular_info_ht.put("Module Revision", nd.getRevision());
		cellular_info_ht.put("Hardware Version",nd.getDhversion());
		
		//cellular_info_ht.put("PPP Status",rs.getString(""));
		//cellular_info_ht.put("PPP Uptime",rs.getString(""));
		cellular_info_ht.put("Cellular IP Address", nd.getIpaddress());
		cellular_info_ht.put("Active SIM", nd.getActivesim());
		cellular_info_ht.put("IMEI", nd.getImeinumber());
		cellular_info_ht.put("Network", nd.getNetwork());
		cellular_info_ht.put("Network Band", nd.getNwband());
		cellular_info_ht.put("Signal Strength", nd.getSignalstrength());
		//cellular_info_ht.put("Service Provider",rs.getString(""));
		cellular_info_ht.put("Cell ID", nd.getCellid());
		cellular_info_ht.put("ICC ID", nd.getIccid());
		//cellular_info_ht.put("IMSI",rs.getString(""));
		//cellular_info_ht.put("SINR",rs.getString(""));
		if (version.startsWith(Symbols.WiZV2) || version.endsWith(Symbols.WiZV2)) {
			device_info_ht.put("Connected Interface",nd.getConintf()==null?"":nd.getConintf());
			devinfo_key_list.add("Connected Interface");
			device_info_ht.put("Fallback Status",nd.getFallbacksts()==null?"-":nd.getFallbacksts().equals("cellular")?"Cellular":nd.getFallbacksts());
			devinfo_key_list.add("Fallback Status");
			if(device_info_ht.get("Status").equals("Active"))
			{
				cellular_info_ht.put("Cellular IP Address", nd.getCelip()==null?"":nd.getCelip());
				cellular_info_ht.put("Status",  nd.getCelstatus().equalsIgnoreCase("up") ? "Active"
						: nd.getCelip().equalsIgnoreCase("down") ? "Down" : "Down");
				//cellular_info_ht.put("Status",nd.getCelstatus());
				cellular_info_ht.put("UpTime",nd.getCeluptime());
			}
			else
			{
				cellular_info_ht.put("Cellular IP Address", "-");
				cellular_info_ht.put("Status","Down");
				cellular_info_ht.put("UpTime","-");
			}
			cellular_key_list.add("Status");
		 	cellular_key_list.add("UpTime");  // add this key to cellular_key_list if the version is wizngv2
		 	
		}
	}
		if(node_exists)
		{
			qry = "select updatetime as configtime from m2mlogs where (loginfo like 'Configuration%' or loginfo like 'Export-Config%' or loginfo like 'Bulk-%' ) and (loginfo like '%Success') and slnumber='"
					+ serialno + "' order by id desc limit 1";
			rs = stmt.executeQuery(qry);
			if (rs.next())
				activity_ht.put("Configuration", sdf.format(rs.getTimestamp(1)));

			qry = "select updatetime as reboottime from m2mlogs where loginfo ='Reboot-Accepted' and slnumber='"
					+ serialno + "' order by id desc limit 1";
			rs = stmt.executeQuery(qry);
			if (rs.next())
				activity_ht.put("Reboot", sdf.format(rs.getTimestamp(1)));

			qry = "select updatetime as configtime from m2mlogs where loginfo ='Firmware-Upgrade:Success' and slnumber='"
					+ serialno + "'  order by id desc limit 1";
			rs = stmt.executeQuery(qry);
			if (rs.next())
				activity_ht.put("Firmware Upgrade", sdf.format(rs.getTimestamp(1)));

			qry = "select downtime,EXTRACT(EPOCH FROM (case when uptime is null then to_timestamp('"
					+ total_time_fmt.format(Calendar.getInstance().getTime())
					+ "','YYYY-MM-DD HH24:MI:SS') else uptime end - downtime)) from m2mnodeoutages where slnumber='"
					+ serialno + "' and alarminfo ='Node is Down' order by id desc limit 1";
			rs = stmt.executeQuery(qry);
			if (rs.next()) {
				if(rs.getTimestamp(1) == null)
				{
					activity_ht.put("Down Duration", "0 days 0 hours 0 min");
				}
				else
				{
					activity_ht.put("Down At", sdf.format(rs.getTimestamp(1)));
					double diffinsec = rs.getDouble(2);
					String down_dur = (long) (diffinsec / (24 * 3600)) + " days " + (long) (diffinsec / 3600) % 24
							+ " hours " + (long) (diffinsec / 60) % (60) + " min";
					activity_ht.put("Down Duration", down_dur);
				}
			}
			Calendar cal = Calendar.getInstance();
			Date curdate = new Date();
			cal.setTime(DateTimeUtil.getOnlyDate(curdate));
			Date today = cal.getTime();
			cal.add(Calendar.DATE, -1);
			Date yesterday = cal.getTime();
			cal.add(Calendar.DATE, -1);
			Date dbyday = cal.getTime();
			cal.add(Calendar.DATE, -5);
			Date lastweek = cal.getTime();
			Date created_on = nd.getCreatedtime();
			
			Date from_day = today.compareTo(created_on) < 0 ? created_on : today;
			Date to_day = curdate;
			DecimalFormat df = new DecimalFormat("##.##");
			// query for outage on today 
			String todayqry = "select nd.nodelabel,nd.loopbackip,nout.slnumber,EXTRACT(EPOCH FROM (to_timestamp('"
					+ total_time_fmt.format(Calendar.getInstance().getTime())
					+ "','YYYY-MM-DD HH24:MI:SS')-to_timestamp('" + dfmt.format(from_day)
					+ "','DD-MM-YYYY'))) as total_time_sec,"
					+ " sum(EXTRACT(EPOCH FROM (COALESCE(nout.uptime,to_timestamp('"
					+ total_time_fmt.format(Calendar.getInstance().getTime())
					+ "','YYYY-MM-DD HH24:MI:SS'),nout.uptime)-(case when nout.downtime < to_timestamp('"
					+ dfmt.format(from_day) + "','DD-MM-YYYY') then to_timestamp('" + dfmt.format(from_day)
					+ "','DD-MM-YYYY') else nout.downtime end)))) as tot_down_time_sec "
					+ " from m2mnodeoutages  nout inner join nodedetails nd on nd.slnumber = nout.slnumber where  nd.slnumber =  '"
					+ serialno + "' and nout.downtime <= '"+to_day+"' and (nout.uptime >= to_date('" + dfmt.format(from_day)
					+ "','DD-MM-YYYY') or nout.uptime is null)  group by nout.slnumber,nd.nodelabel,nd.loopbackip order by slnumber";

			/*String todayqry  = "select nd.nodelabel,nd.loopbackip,nout.slnumber,EXTRACT(EPOCH FROM (to_timestamp('"+dfmt.format(to_day)+"','DD-MM-YYYY')-to_timestamp('"+dfmt.format(from_day)+"','DD-MM-YYYY'))) as total_time_sec," + 
			           " sum(EXTRACT(EPOCH FROM (COALESCE(nout.uptime,to_timestamp('"+total_time_fmt.format(Calendar.getInstance().getTime())+"','DD-MM-YYYY HH24:MI:SS'),nout.uptime)-(case when nout.downtime < to_timestamp('"+dfmt.format(from_day)+"','DD-MM-YYYY') then to_timestamp('"+dfmt.format(from_day)+"','DD-MM-YYYY') else nout.downtime end)))) as tot_down_time_sec " + 
			           " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where  nd.slnumber =  '"+serialno+ 
			           "' and nout.downtime <= to_date('"+dfmt.format(to_day)+"' ,'DD-MM-YYYY') and (nout.uptime >= to_date('"+dfmt.format(from_day)+"','DD-MM-YYYY') or nout.uptime is null)  group by nout.slnumber,nd.nodelabel,nd.loopbackip order by slnumber";*/
			//System.out.println("today query is : "+todayqry);
			rs = stmt.executeQuery(todayqry);
			if (rs.next()) {
				double totaldowntime = rs.getDouble("tot_down_time_sec");
				double tottime  = rs.getDouble("total_time_sec");
				//System.out.println(totaldowntime / tottime);
				double down_per = (totaldowntime / tottime)* 100;
				outage_ht.put("tup", df.format(100 - down_per));
				outage_ht.put("tdown", df.format(down_per));
			}
			from_day =  yesterday.compareTo(created_on) < 0 ? created_on : yesterday;
			to_day = today;
			// query for outage on yesterday 
			if(created_on.compareTo(today) < 0)
			{ 
					
				String yes_qry = "select nd.nodelabel,nd.loopbackip,nout.slnumber,EXTRACT(EPOCH FROM (to_timestamp('"
						+ dfmt.format(to_day) + "','DD-MM-YYYY')-to_timestamp('" + dfmt.format(from_day)
						+ "','DD-MM-YYYY'))) as total_time_sec,"
						+ " sum(EXTRACT(EPOCH FROM (COALESCE(case when nout.uptime is null or nout.uptime > to_timestamp('"
						+ dfmt.format(to_day) + "','DD-MM-YYYY') then to_timestamp('" + dfmt.format(to_day)
						+ "','DD-MM-YYYY') else nout.uptime end)-(case when nout.downtime < to_timestamp('"
						+ dfmt.format(from_day) + "','DD-MM-YYYY') then to_timestamp('" + dfmt.format(from_day)
						+ "','DD-MM-YYYY') else nout.downtime end)))) as tot_down_time_sec "
						+ " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where  nd.slnumber =  '"
						+ serialno + "' and (nout.downtime < to_date('" + dfmt.format(to_day)
						+ "','DD-MM-YYYY')) and (nout.uptime >= to_date('" + dfmt.format(from_day)
						+ "','DD-MM-YYYY') or nout.uptime is null)  group by nout.slnumber,nd.nodelabel,nd.loopbackip order by slnumber";
				//System.out.println(yes_qry);
				rs = stmt.executeQuery(yes_qry);
				if (rs.next()) {
	
					double down_per = (rs.getLong("tot_down_time_sec") * 100) / rs.getLong("total_time_sec");
					outage_ht.put("yup", df.format(100 - down_per));
					outage_ht.put("ydown", df.format(down_per));
				}
			 }
			else
			{
				outage_ht.put("yup", "0.00");
				outage_ht.put("ydown","0.00");
			} 
				
			from_day =  lastweek.compareTo(created_on) < 0 ? created_on : lastweek;
			to_day = today;
			// query for outage last one week 
			if(created_on.compareTo(today) < 0)
			{
				String lastweek_qry = "select nd.nodelabel,nd.loopbackip,nout.slnumber,EXTRACT(EPOCH FROM (to_timestamp('"
						+ dfmt.format(to_day) + "','DD-MM-YYYY')-to_timestamp('" + dfmt.format(from_day)
						+ "','DD-MM-YYYY'))) as total_time_sec,"
						+ " sum(EXTRACT(EPOCH FROM (COALESCE(case when nout.uptime is null or nout.uptime > to_timestamp('"
						+ dfmt.format(to_day) + "','DD-MM-YYYY') then to_timestamp('" + dfmt.format(to_day)
						+ "','DD-MM-YYYY') else nout.uptime end)-(case when nout.downtime < to_timestamp('"
						+ dfmt.format(from_day) + "','DD-MM-YYYY') then to_timestamp('" + dfmt.format(from_day)
						+ "','DD-MM-YYYY') else nout.downtime end)))) as tot_down_time_sec "
						+ " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where  nd.slnumber =  '"
						+ serialno + "' and (nout.downtime <= to_date('" + dfmt.format(to_day)
						+ "','DD-MM-YYYY')) and (nout.uptime >= to_date('" + dfmt.format(from_day)
						+ "','DD-MM-YYYY') or nout.uptime is null)  group by nout.slnumber,nd.nodelabel,nd.loopbackip order by slnumber";

				rs = stmt.executeQuery(lastweek_qry);
				if (rs.next()) {
					double down_per = (rs.getLong("tot_down_time_sec") * 100) / rs.getLong("total_time_sec");
					outage_ht.put("wup", df.format(100 - down_per));
					outage_ht.put("wdown", df.format(down_per));
				}
			}
			else
			{
				outage_ht.put("wup", "0.00");
				outage_ht.put("wdown","0.00");
			}
			qry = "select severity, slnumber, alarminfo, downtime, updatetime, uptime,date_trunc('second',age(uptime,downtime)) as persisttime from m2mnodeoutages where slnumber = '"
					+ serialno + "' order by updatetime desc,id desc limit 50";
			rs = stmt.executeQuery(qry);
			while (rs.next()) {
				Hashtable<String, String> alarm_ht = new Hashtable<String, String>();
				alarm_ht.put("severity", rs.getString("severity"));
				alarm_ht.put("slnumber", rs.getString("slnumber"));
				alarm_ht.put("alarminfo", rs.getString("alarminfo") == null ? "" : rs.getString("alarminfo"));
				alarm_ht.put("downtime",
						rs.getTimestamp("downtime") == null
								? (rs.getTimestamp("updatetime") == null ? ""
										: total_time_fmt.format(rs.getTimestamp("updatetime")))
								: total_time_fmt.format(rs.getTimestamp("downtime")));
				alarm_ht.put("uptime",
						rs.getTimestamp("uptime") == null ? "" : total_time_fmt.format(rs.getTimestamp("uptime")));
				alarm_ht.put("persisttime",
						rs.getString("persisttime") == null ? "" : rs.getString("persisttime"));
				alarms_vec.add(alarm_ht);
			}
		}
		else
		{
			err_url="/imission/message.jsp";
			err_param="status";
			err_msg="The Node with Serial Number " + serialno+ " does not exists.";
		}
}catch(Exception e)
{
	e.printStackTrace();
}
finally {
	if (hibsession != null)
		hibsession.close();
	try {

	} catch (Exception e) {
	}
	try {
		if (stmt != null)
			stmt.close();
	} catch (Exception e) {
	}
	try {
		if (rs != null)
			rs.close();
	} catch (Exception e) {
	}
}
if(err_url.length() > 0){
%>
<script type="text/javascript">
goToErrorPage('<%=err_url%>','<%=err_param%>','<%=err_msg%>');
</script>
<%}%>
<div style="position: fixed;" id="topnavdivision">
<ul style="height:30px;background-color:#ddd">
<%-- <li style="margin-right : 5px;" onclick="setPosition('landiv')"><a ><img id="lanid " title="LAN" src="/imission/images/lan.png" style="width:20%;height:80%;"></img>
LAN</a></li>
<%if(version.startsWith(Symbols.WiZV2+Symbols.EL)) {%>
<li onclick="setPosition('wandiv')">
<a><img id="wanid" title="WAN" src="/imission/images/wan.jpg" style="width: 20%;height:90%"></img>
WAN</a>
</li>
<%} %>
<li onclick="setPosition('celldiv')">
<a><img id="cellid" title="Cellular" src="/imission/images/cellular.png" style="width: 20%;height:80%"></img>
Cellular</a>
</li> --%>
<li onclick="setPosition('systemdiv')">
<a><img id="systemid" title="VPN" src="/imission/images/device-info.png" style="width: 20%;height:80%"></img>
System</a>
</li>
<li onclick="setPosition('ntwkdiv')">
<a><img id="ntwkid" title="VPN" src="/imission/images/interface.png" style="width: 20%;height:80%"></img>
Network</a>
</li>
<li onclick="setPosition('ipsecdiv')">
<a><img id="vpnid" title="VPN" src="/imission/images/vpn.jpg" style="width: 20%;height:80%"></img>
VPN</a>
</li>
<li onclick="setPosition('configdiv')">
<a><img id="configid" title="Recent Alarms" src="/imission/images/config.png" style="width: 20%;height:80%"></img>
Configuration</a>
</li>
<li onclick="setPosition('activitydiv')">
<a><img id="actid" title="Recent Activity" src="/imission/images/activity.jpg" style="width: 20%;height:80%"></img>
Recent Activity</a>
</li>
<li onclick="setPosition('datadiv')">
<a><img id="dataid" title="Data Usage" src="/imission/images/data-usage.png" style="width: 20%;height:80%"></img>
Data Usage</a>
</li>
<li onclick="setPosition('alarmsdiv')">
<a><img id="alarmsid" title="Recent Alarms" src="/imission/images/alarm.jpg" style="width: 20%;height:80%"></img>
Recent Alarms</a>
</li>
</ul>
</div>
<br>
<br>
<div id="systemdiv">
<table class="borderlesstab">
<tr>
<td>
<div class="titleheader toppaddiv">Device Information</div>
<br>
<table class="innertab" id="devinfotab">
<%for(int i=0;i<devinfo_key_list.size();i++) {%>
<tr>
<td><%=devinfo_key_list.get(i)%></td>
<td>
<%if(i == 10) {%>
<%=device_info_ht.get(devinfo_key_list.get(i))==null?"-":device_info_ht.get(devinfo_key_list.get(i)).replace(" ","  ")%> 
<%}else if(i <=8 || i > 9) {%>
<%=device_info_ht.get(devinfo_key_list.get(i))==null?"-":device_info_ht.get(devinfo_key_list.get(i))%> 
<label style="padding-left:20px;">
<%}if(i==8){
	if(device_info_ht.size()>0&&device_info_ht.get("Status").equals("Active"))
	{%>
		<!--<img src="/imission/images/nodeup.png"></img>-->
		<label class="circle <%=device_info_ht.get(devinfo_arr[i])%>"></label>
	<%}
	else
	{%>
		<!--<img src="/imission/images/nodedown.png"></img>-->
		<label class="circle DOWN"></label>
	<%}
      
}%></label>
<%if(i==9){
	if(device_info_ht.size()>0&&device_info_ht.get("Status").equals("Active"))
	{
		 String router_uptime=device_info_ht.get("Uptime");%>
		 <%=router_uptime%>
	<%}
	else{%>
		-
	<%}
}%>
</td>
</tr>
<%}%>
<tr>
</tr>
</table>
</td>
<td colspan="2" width="66%" style="max-width: 66%">
</td>
<td width="30%">
<div class="titleheader" align="center" style="font-size: 14px;padding-left:20%;margin-top: 10%"><select id="outageopt" onchange="changeOutageChartData()"><option value="Today">Today</option><option value="Yesterday">Yesterday</option><option value="Lastweek">Last Week</option></select></div>
	<canvas align="center" id="outagechart" style="height:260px; width:100%; float:center;margin-left:20%">
	</canvas>
</td>
</tr>
</table>
</div>
<div id="ntwkdiv">
	<%if(version.contains(Symbols.WiZV2)){%>
	<div class="titleheader toppaddiv">LAN</div> 
	<%}else {%>
		<div class="titleheader toppaddiv">Ethernet</div>
	<%} %>
	<br>
	<table class="innertab" id="ethporttab" style="width:<%if(version.startsWith(Symbols.WiZV2+Symbols.ES)){%>60px<%}else {%>30%<%}%>">
	<tr>
	<%
	ethport_list.add("P0");
	ethport_list.add("P1");
	ethport_list.add("P2");
	if(version.contains(Symbols.WiZV2))
		ethport_list.add("P3");
	else
		ethport_list.add("P3/WAN");
	lan_vec.put("P0", nd.getSwitch1());	
	lan_vec.put("P1", nd.getSwitch2());	
	lan_vec.put("P2", nd.getSwitch3());	
	if(version.contains(Symbols.WiZV2))
		lan_vec.put("P3", nd.getSwitch4());
	else
		lan_vec.put("P3/WAN", nd.getSwitch4());
	for(int i=0;i<(version.startsWith(Symbols.WiZV2+Symbols.ES)?1:ethport_list.size());i++) {
		//System.out.println(device_info_ht.get(ethport_arr[i]));
		if(nd.getStatus().equals("up")){%>
	<td style ="max-width:60px" class="LAN<%=lan_vec.get(ethport_list.get(i))==null?"DOWN":lan_vec.get(ethport_list.get(i))%>"><%=ethport_list.get(i)%></td>
	<%}else{%>
	<td style ="max-width:60px" class="LANDOWN"><%=ethport_list.get(i)%></td>
	<%}
	}%>
	</tr>
	</table>
<%if(version.contains(Symbols.WiZV2+Symbols.EL)) {
	String wanip="";
	String wanuptime="";
	String wanstatus="";
	if(nd != null)
	{
		wanip=nd.getWanip()==null?"-":nd.getWanip();
		wanuptime=nd.getWanuptime()==null?"-":(nd.getStatus().equalsIgnoreCase("up")?nd.getWanuptime():"-");
		wanstatus=nd.getWanstatus()==null?"DOWN":(nd.getStatus().equalsIgnoreCase("up")?(nd.getWanstatus().equalsIgnoreCase("up")?"Active":(nd.getWanstatus().equalsIgnoreCase("off")?"Disabled":"DOWN")):"DOWN");
		
	}
%>
<div class="titleheader toppaddiv" >WAN</div>
<br>
<table class="innertab" id="wantab" style="width:30%">
<thead>
<tr>
<th width="75px">IP Address</th>
<th width="75px">Uptime</th>
<th width="75px">Status</th>
</tr>
</thead>
<%String wanip_arr[]=wanip.split(" ");
for(String ip : wanip_arr)
wanip_vec.add(ip);
for(int i=0;i<wanip_vec.size();i++)
{
%>
<tr>
	<td width="75px" style="text-align:left;padding-left:5px;"><%=wanip_vec.get(i)%></td>
	<%if(i==0){%>
		<td width="75px" rowspan="<%=wanip_vec.size()%>" style="text-align:left;padding-left:5px;"><%=wanuptime%></td>
		<td width="75px" rowspan="<%=wanip_vec.size()%>" style="text-align:left;padding-left:5px;"><div class="circle <%=wanstatus%>"></div></td>
	<%} %>
</tr>
<%}%>
</table>
<%}%>
<div class="titleheader toppaddiv">Cellular</div>
<br>
<table class="innertab" id="celllartab" style="width:30%;">
<%for(int i=0;i<cellular_key_list.size();i++) {%>
<tr>
<td ><%=cellular_key_list.get(i)%></td>
<%-- <%System.out.println("cellualr key list :"+cellular_key_list.get(i) +"i val :"+i); %> --%> 
<td>
<%if(i <=2 || i==5) {%>
<%=cellular_info_ht.get(cellular_key_list.get(i))== null?"-":cellular_info_ht.get(cellular_key_list.get(i))%>
<%}
//System.out.println("cellular_info_ht :"+cellular_info_ht.get(cellular_key_list.get(i)));
else if(i>2){
	
	if(device_info_ht.size()>0 && device_info_ht.get("Status").equals("Active"))
	{
		
		if(cellular_key_list.get(i).equals("Status"))
		{%>
			<!-- out.print(cellular_info_ht.get(cellular_key_list.get(i))+"<label style=\"padding-left:20px;\">"); -->
			<%=cellular_info_ht.get(cellular_key_list.get(i)) %><label style="padding-left:20px;">

		<%if(cellular_info_ht.get(cellular_key_list.get(i)) != null && cellular_info_ht.get(cellular_key_list.get(i)).equals("Active") )
		{
		%>
			<label class="circle <%=cellular_info_ht.get(cellular_key_list.get(i))%>"></label>
		<%}
		else
		{%>
			<label class="circle DOWN"></label>
		<%}%>
			</label>
		<%}
		/* else
			out.print(cellular_info_ht.get(cellular_key_list.get(i)) == null?"-":cellular_info_ht.get(cellular_key_list.get(i))); */
		else
		{%>
			<%=cellular_info_ht.get(cellular_key_list.get(i)) == null ? "-" : cellular_info_ht.get(cellular_key_list.get(i))%>
	<% }}
	else
	{
		if(cellular_key_list.get(i).equals("Status"))
		{%>
			Down <label style="padding-left:20px;">
			<label class="circle DOWN"></label>
			</label>
		<%}
		else
		{%>
			-
		<%}
	}
}%>
</td>
</tr>
<%}%>
</table>
</div>
<div id="ipsecdiv">
<%if(version.contains(Symbols.WiZV2)){%>
<div class="titleheader toppaddiv">ZeroTier</div>
<br>
<table class="innertab" id="zerotiretab" style="width:30%;">
<thead>
<tr>
<th width="150px">Network ID</th>
<th width="75px">IP Address</th>
</tr>
</thead>
 <tr>
		<td width="150px" style="text-align:left;padding-left:5px;"><%=nd.getZtnwid()!=null?nd.getZtnwid():"-"%></td>
		<td width="75px" style="text-align:left;padding-left:5px;"><%=nd.getZerotierip()!=null?nd.getZerotierip():"-"%></td>
</tr>
</table>
<%} %>
<%if(version.contains(Symbols.WiZV2)){%>
<div class="titleheader toppaddiv">OpenVpn</div>
<br>
<table class="innertab" id="openvpntab" style="width:40%;">
<thead>
<tr>
<th style="min-width:20%">Instance Name</th>
<th width="12%">Mode</th>
<th width="8%">Status</th>
</tr>
</thead>
<%for(int k=0;k<openvpn_vec.size();k++) {
Hashtable<String,String> open_ht = openvpn_vec.get(k);
%>
<tr>
<td  style="text-align:left;padding-left:5px;min-width:20%"><%=open_ht.get(openvpn_headlist.get(0))%></td>
<td width="12%" style="text-align:left;padding-left:5px;"><%=open_ht.get(openvpn_headlist.get(1))%></td>
<td width="8%"><div class="circle <%=nd.getStatus().equals("up")?open_ht.get(openvpn_headlist.get(openvpn_headlist.size()-1)):"DOWN"%>"></div></td>
<%} %>
</tr>
<tr>
<td style="text-align:left;padding-left:5px;min-width:20%">haritha</td>
<td width="12%" style="text-align:left;padding-left:5px;">Client To Server</td>
<td width="8%"><div class="circle DOWN"></div></td>
</tr>
<tr>
<td style="text-align:left;padding-left:5px;min-width:20%">Tharun</td>
<td width="12%" style="text-align:left;padding-left:5px;">Client To Server</td>
<td width="8%"><div class="circle UP"></div></td>
</tr>
<tr>
<td style="text-align:left;padding-left:5px;min-width:20%">haritha2</td>
<td width="12%" style="text-align:left;padding-left:5px;">Point To Point</td>
<td width="8%"><div class="circle DISABLED"></div></td>
</tr>
<tr>
<td style="text-align:left;padding-left:5px;min-width:20%">haritha3</td>
<td width="12%" style="text-align:left;padding-left:5px;">Client To Server</td>
<td width="8%"><div class="circle DOWN"></div></td>
</tr>
<tr>
<td style="text-align:left;padding-left:5px;min-width:20%">haritha4</td>
<td width="12%" style="text-align:left;padding-left:5px;">Point To Point</td>
<td width="8%"><div class="circle UP"></div></td>
</tr>
<tr>
<td style="text-align:left;padding-left:5px;min-width:20%">haritha5</td>
<td width="12%" style="text-align:left;padding-left:5px;">Client To Server</td>
<td width="8%"><div class="circle DOWN"></div></td>

</tr>
</table>
<%} %>
<div class="titleheader toppaddiv">IPSec</div>
<br>
<table class="innertab" id="ipsectab" <%if(version.contains(Symbols.WiZV2)) {%> style="width:50%" <%} else { %> style="width:30%" <%} %>>
<%for(int i=0;i<ipsec_headlist.size();i++) { %>
<th style="max-width:10%"><%=ipsec_headlist.get(i)%></th>
<%} %>
</tr>
</thead>
<%
for(int k=0; k<ipsec_vec.size();k++)
{
 	Hashtable<String,String> ipsec_ht = ipsec_vec.get(k);
 	%>
 	<tr>
 		<td style="text-align:left;padding-left:5px;max-width:10%"><%=ipsec_ht.get(ipsec_headlist.get(0))%></td>
 		<% if(ipsec_headlist.size() > 2){%>
 		<td style="text-align:left;padding-left:5px;max-width:10%"><%=ipsec_ht.get(ipsec_headlist.get(1))%></td>
 		<td style="text-align:left;padding-left:5px;max-width:10%"><%=ipsec_ht.get(ipsec_headlist.get(2)) %></td>
 		<td style="text-align:left;padding-left:5px;max-width:10%"><%=ipsec_ht.get(ipsec_headlist.get(3)) %></td>
 		<%} %>
		<td style="max-width:10%"><div class="circle <%=nd.getStatus().equals("up")?ipsec_ht.get(ipsec_headlist.get(ipsec_headlist.size()-1)):"DOWN"%>"></div></td>
 	</tr>
<%}
%>
</table>
</div>
<div id="configdiv">
<div class="titleheader toppaddiv">Configuration</div>
<br>
<table class="innertab" id="configtab" style="width:30%;">
<%for(int i=0;i<config_key_list.size();i++) {
String config_status = config_info_ht.get(config_key_list.get(i));
String confsta = config_status.equals("Success")?"UP":config_status.equals("Fail")?"DOWN":config_status.equals("In Progress")?
		"Progress":config_status.equals("Updating")?"warning":"DISABLED";
%>
<tr>
<td><%=config_key_list.get(i)%></td>
<td>
<%=config_info_ht.get(config_key_list.get(i))==null?"-":config_info_ht.get(config_key_list.get(i))%>
<label style="padding-left:20px;">
<label class="circle <%=confsta%>"></label>
</label>
</td>
<%} %>
</table>
</div>
<div id="activitydiv">
<div class="titleheader toppaddiv">Recent Activity</div>
<table class="innertab" id="activitytab" style="width:30%;">
<%for(int i=0;i<activity_arr.length;i++) {%>
<tr>
<td ><%=activity_arr[i]%></td>
<td><%=activity_ht.get(activity_arr[i]) == null?"-":activity_ht.get(activity_arr[i])%></td>
</tr>
<%}%>
</table>
</div>
<div id="datadiv">
<div class="titleheader toppaddiv">Data Usage</div>
<br>
<div class="titleheader" align="center">SIM1</div>
<table class="innertab" id="sim1charttable" style="width:65%;">
<tr>
<td width="33%" style="max-width:33%;">
<canvas id="sim1day" width="100%" height="60%"></canvas>
</td >
<td width="33%" style="max-width:33%">
<canvas id="sim1week" width="100%" height="60%"></canvas>
</td>
<td width="34%" style="max-width:34%">
<canvas id="sim1month" width="100%" height="60%"></canvas>
</td>
</tr>
</table>
<div class="titleheader toppaddiv" align="center" id="sim2charttable">SIM2</div>
<table class="innertab" id="sim2Charttable" style="width:65%;">
<tr>
<td width="33%" style="max-width:33%">
<canvas id="sim2day" width="100%" height="60%"></canvas>
</td>
<td width="33%" style="max-width:33%">
<canvas id="sim2week" width="100%" height="60%"></canvas>
</td>
<td width="34%" style="max-width:34%">
<canvas id="sim2month" width="100%" height="60%"></canvas>
</td>
</tr>
</table>
</div>
<div id="alarmsdiv">
<div class="titleheader toppaddiv">Recent Alarms</div>
<br>
<div style="overflow-y:scroll;max-height:62vh">
<table class="table table-condensed severity">
	<thead id="sticky">
		<tr>
			<th width="8%">Severity</th>
			<th width="12%">Serial No</th>
			<th width="20">Alarms Info</th>
			<th width="15%">Alarm Time</th>
			<th width="15%">Recover Time</th>
			<th width="20%">Persistent Time</th>
			<!-- <th width="15%"><label onclick="goToUrl('Time')">service</label>></th> -->
		</tr>
	</thead>
	<% for(int i=0;i<alarms_vec.size();i++){
		Hashtable<String,String> alarm_ht = alarms_vec.get(i);
	%>
         <tr valign="top" class="severity-<%=alarm_ht.get("severity")%>">
         	<td class="divider bright">
			<%=alarm_ht.get("severity")%>
         	</td>
         	<td >
         	<%=alarm_ht.get("slnumber")%>
         	</td>
         	<td>
         	<%=alarm_ht.get("alarminfo") %>
         	</td>
         	<td >
         	<%=alarm_ht.get("downtime")%>
         	</td>
        	 <td >
        	 <%=alarm_ht.get("uptime")%>
         	</td>
			 <td >
			 <%=(alarm_ht.get("persisttime").trim().length() > 0)?
        	 DateTimeUtil.getPersistentDTime(DateTimeUtil.ConvertToFullDate(alarm_ht.get("downtime"),"yyyy-MM-dd HH:mm:ss.SSS"),DateTimeUtil.ConvertToFullDate(alarm_ht.get("uptime"),"yyyy-MM-dd HH:mm:ss.SSS")):""%>
         	</td>
         </tr>					
      <%}
      %>
 </table>
</div>
</div>
<%
if(jsonbuf != null && jsonbuf.length() > 0)
{
	statusobj= JSONObject.fromObject(jsonbuf.toString());
	JSONObject datausgobj= statusobj.getJSONObject("STATUS").getJSONObject("DataUsage");
	//JSONObject dayusage = statusobj.getJSONObject("HEADINGDSIM1");
	JSONObject s1dayusage = datausgobj.getJSONObject("TABLEDSIM1");
	JSONObject s2dayusage = datausgobj.getJSONObject("TABLEDSIM2");
	JSONArray s1dayarr  = s1dayusage.getJSONArray("arr");
	JSONArray s2dayarr  = s2dayusage.getJSONArray("arr");
	for(int i=0;i<s1dayarr.size();i++)
	{
		JSONObject dayobj = s1dayarr.getJSONObject(i);
		sim1dayupvalue += dayobj.getString("Upload(KB)")+",";
		sim1daydownvalue += dayobj.getString("Download(KB)")+",";
		sim1daydatevalue +=dayobj.getString("Date")+",";
	}
	for(int i=0;i<s2dayarr.size();i++)
	{
		JSONObject dayobj = s2dayarr.getJSONObject(i);
		sim2dayupvalue += dayobj.getString("Upload(KB)")+",";
		sim2daydownvalue += dayobj.getString("Download(KB)")+",";
		sim2daydatevalue +=dayobj.getString("Date")+",";
	}

	for(int i=s1dayarr.size();i<7;i++)
	{
		sim1dayupvalue +="0.00,";
		sim1daydownvalue += "0.00,";
		sim1daydatevalue +=" ,";
	}
	for(int i=s2dayarr.size();i<7;i++)
	{
		sim2dayupvalue +="0.00,";
		sim2daydownvalue += "0.00,";
		sim2daydatevalue +=" ,";
	}
	//JSONObject weekusage = datausgobj.getJSONObject("HEADINGW");
	JSONObject s1weekusage = datausgobj.getJSONObject("TABLEWSIM1");
	JSONObject s2weekusage = datausgobj.getJSONObject("TABLEWSIM2");
	JSONArray s1weekarr  = s1weekusage.getJSONArray("arr");
	JSONArray s2weekarr  = s2weekusage.getJSONArray("arr");
	for(int i=0;i<s1weekarr.size();i++)
	{
		JSONObject weekobj = s1weekarr.getJSONObject(i);
		sim1weekupvalue += weekobj.getString("Upload(MB)")+",";
		sim1weekdownvalue += weekobj.getString("Download(MB)")+",";
		sim1weekdatevalue +=weekobj.getString("Week")+",";
	}
	for(int i=0;i<s2weekarr.size();i++)
	{
		JSONObject weekobj = s2weekarr.getJSONObject(i);
		sim2weekupvalue += weekobj.getString("Upload(MB)")+",";
		sim2weekdownvalue += weekobj.getString("Download(MB)")+",";
		sim2weekdatevalue +=weekobj.getString("Week")+",";	
	}
	for(int i=s1weekarr.size();i<7;i++)
	{
		sim1weekupvalue +="0.00,";
		sim1weekdownvalue += "0.00,";
		sim1weekdatevalue +=" ,";
	}
	for(int i=s2weekarr.size();i<7;i++)
	{
		sim2weekupvalue +="0.00,";
		sim2weekdownvalue += "0.00,";
		sim2weekdatevalue +=" ,";
	}
	//JSONObject mthusage = datausgobj.getJSONObject("HEADINGM");
	JSONObject s1mthusage = datausgobj.getJSONObject("TABLEMSIM1");
	JSONObject s2mthusage = datausgobj.getJSONObject("TABLEMSIM2");
	JSONArray s1mtharr  = s1mthusage.getJSONArray("arr");
	JSONArray s2mtharr  = s2mthusage.getJSONArray("arr");
	for(int i=0;i<s1mtharr.size();i++)
	{
		JSONObject mthobj = s1mtharr.getJSONObject(i);
		sim1monthupvalue += mthobj.getString("Upload(MB)")+",";
		sim1monthdownvalue += mthobj.getString("Download(MB)")+",";
		sim1monthdatevalue +=mthobj.getString("Month")+",";
	}
	for(int i=0;i<s2mtharr.size();i++)
	{
		JSONObject mthobj = s2mtharr.getJSONObject(i);
		sim2monthupvalue += mthobj.getString("Upload(MB)")+",";
		sim2monthdownvalue += mthobj.getString("Download(MB)")+",";
		sim2monthdatevalue +=mthobj.getString("Month")+",";
	}
	for(int i=s1mtharr.size();i<7;i++)
	{
		sim1monthupvalue +="0.00,";
		sim1monthdownvalue += "0.00,";
		sim1monthdatevalue +=" ,";
	}
	for(int i=s2mtharr.size();i<7;i++)
	{
		sim2monthupvalue +="0.00,";
		sim2monthdownvalue += "0.00,";
		sim2monthdatevalue +=" ,";
	}
	sim1dayupvalue=sim1dayupvalue.length()>0?sim1dayupvalue.substring(0,sim1dayupvalue.length()-1):sim1dayupvalue;
	sim1daydownvalue=sim1daydownvalue.substring(0,sim1daydownvalue.length()-1);
	sim1daydatevalue=sim1daydatevalue.substring(0,sim1daydatevalue.length()-1);
	sim1weekupvalue=sim1weekupvalue.substring(0,sim1weekupvalue.length()-1);
	sim1weekdownvalue=sim1weekdownvalue.substring(0,sim1weekdownvalue.length()-1);
	sim1weekdatevalue=sim1weekdatevalue.substring(0,sim1weekdatevalue.length()-1);
	sim1monthupvalue=sim1monthupvalue.substring(0,sim1monthupvalue.length()-1);
	sim1monthdownvalue=sim1monthdownvalue.substring(0,sim1monthdownvalue.length()-1);
	sim1monthdatevalue=sim1monthdatevalue.substring(0,sim1monthdatevalue.length()-1);
	
	sim2dayupvalue=sim2dayupvalue.substring(0,sim2dayupvalue.length()-1);
	sim2daydownvalue=sim2daydownvalue.substring(0,sim2daydownvalue.length()-1);
	sim2daydatevalue=sim2daydatevalue.substring(0,sim2daydatevalue.length()-1);
	sim2weekupvalue=sim2weekupvalue.substring(0,sim2weekupvalue.length()-1);
	sim2weekdownvalue=sim2weekdownvalue.substring(0,sim2weekdownvalue.length()-1);
	sim2weekdatevalue=sim2weekdatevalue.substring(0,sim2weekdatevalue.length()-1);
	sim2monthupvalue=sim2monthupvalue.substring(0,sim2monthupvalue.length()-1);
	sim2monthdownvalue=sim2monthdownvalue.substring(0,sim2monthdownvalue.length()-1);
	sim2monthdatevalue=sim2monthdatevalue.substring(0,sim2monthdatevalue.length()-1);
}
if(jsonfile != null)
	jsonfile.close();
     %>
</body>
<script>
createOtageChart('<%=outage_ht.get("tup")%>','<%=outage_ht.get("tdown")%>');
setOutageData('<%=outage_ht.get("tup")%>','<%=outage_ht.get("tdown")%>','<%=outage_ht.get("yup")%>','<%=outage_ht.get("ydown")%>','<%=outage_ht.get("wup")%>','<%=outage_ht.get("wdown")%>');
changeOutageChartData();
barchart("sim1day","<%=sim1daydatevalue%>","<%=sim1dayupvalue%>","<%=sim1daydownvalue%>","Data Usage Daily(in KB)");
barchart("sim1week","<%=sim1weekdatevalue%>","<%=sim1weekupvalue%>","<%=sim1weekdownvalue%>","Data Usage Weekly(in MB)");
barchart("sim1month","<%=sim1monthdatevalue%>","<%=sim1monthupvalue%>","<%=sim1monthdownvalue%>","Data Usage Monthly(in MB)");
barchart("sim2day","<%=sim2daydatevalue%>","<%=sim2dayupvalue%>","<%=sim2daydownvalue%>","Data Usage Daily(in KB)");
barchart("sim2week","<%=sim2weekdatevalue%>","<%=sim2weekupvalue%>","<%=sim2weekdownvalue%>","Data Usage Weekly(in MB)");
barchart("sim2month","<%=sim2monthdatevalue%>","<%=sim2monthupvalue%>","<%=sim2monthdownvalue%>","Data Usage Monthly(in MB)");
</script>
</html>
<jsp:include page="/bootstrap-footer.jsp" flush="false"/>