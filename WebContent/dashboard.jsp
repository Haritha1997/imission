<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="com.nomus.m2m.pojo.Organization"%>
<%@page import="com.nomus.staticmembers.NodeStatus"%>
<%@page import="com.nomus.staticmembers.QueryGenerator"%>
<%@page import="javax.management.Query"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.m2m.pojo.NodeDetails"%>
<%@page import="com.nomus.m2m.dao.M2MNodeOtagesDao"%>
<%@page import="com.nomus.m2m.pojo.M2MNodeOtages"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.nomus.Role"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>
<%@page language="java" contentType="text/html" session="true"%>
<%@page import="java.sql.SQLException" %>

<%@page import="java.util.*" %>
<%@page import="java.lang.*" %>


   <jsp:include page="bootstrap.jsp" flush="false" >
   <jsp:param name="title" value="imission"/>
   <jsp:param name="headTitle" value="imission"/>
   </jsp:include>
   
   <%
     String serialno = request.getParameter("slnumber")==null?"":request.getParameter("slnumber");
     String status="";
	 String htkey="";
	 String fav_slnumber = "";
	 Hashtable<String,Hashtable<String,String>> favourites_ht = new Hashtable<String,Hashtable<String,String>>();
		String sim1weekupvalue="";
		String sim1weekdownvalue="";
		String sim1weekdatevalue="";
		String sim2weekupvalue="";
		String sim2weekdownvalue="";
		String sim2weekdatevalue="";
		String upvalue="";
		String downvalue="";
		String datevalue="";
		int block_size = 25;
		int no_blocks = 11;
		
		
		JSONObject statusobj = null;
		BufferedReader jsonreader = null;
		StringBuffer jsonbuf = new StringBuffer("");
		//Vector<Hashtable<String,String>> heatmap_vec = new Vector<Hashtable<String,String>>();
		ArrayList<String> slnum_list = new ArrayList<String>();
		NodedetailsDao nodedao = new NodedetailsDao();
		session = request.getSession();
		User user = (User)session.getAttribute("loggedinuser");
		Organization selorg =user.getOrganization();
		String refresh = selorg.getRefresh();
		int refreshtime = selorg.getRefreshTime();
		Vector<Hashtable<String,String>> nodeactive_vec = new Vector<Hashtable<String,String>>();
		Vector<Hashtable<String,String>> nodedown_vec = new Vector<Hashtable<String,String>>();
		Vector<Hashtable<String,String>> nodeinactive_vec = new Vector<Hashtable<String,String>>();
%>
<html style="height:100%;">
<head>
		<!--  <script src="js/jquery-1.8.3.min.js"></script> -->
		<script src="js/jquery-1.4.2.min.js"></script>
		<script src="js/prop-types.min.js"></script>
		<script src="js/Chart.min.js"></script>		
		<script src="js/apexcharts"></script>
		<link href="styles.css" rel="stylesheet"/>
		<link rel="stylesheet" href="css/fontawesome.css">
		<link rel="stylesheet" href="css/v4-shims.css">
		
<style type="text/css">
body{
	overflow:hidden;
	height:100%;
}
#heatmaptab
{
	vertical-align: top;
	max-height:250px;
	border:1px solid #ddd;
	border-bottom:0px;
}
#heatmapdiv
{
	height:100%;
	max-height:250px;
	border-bottom:1px solid #ddd;
}
#heatmaptab tr
{
	vertical-align: top;
	max-height:20px;
}
#heatmaptab td
{
	vertical-align: top;
	max-height:20px;
}
#heatmaptab td,#heatmaptab th
{
	padding-left: 10px;
}
input[type=range][orient=vertical]
{
    writing-mode: bt-lr; /* IE */
    -webkit-appearance: slider-vertical; /* WebKit */
    width: 0px;
    height: 150px;
    padding: 0 5px;
}
.nwlbl {
	min-width:70px;
	font-weight: bold;
}
.fa-plus
{
	float:right;
	font-weight:5px;
	padding-top:3px;
	padding-right:5;
	color:#6495ED;
}
.outertable{
  border-collapse: collapse;
  border-spacing: 0;
  width: 100%;
  border: 1px solid #ddd;
}
.outertable td table
{
width:100%;
height : 100%;
}
th
{
  padding : 4px 4px 4px 4px;
  border-radius: 5px;
}
th, td {
  text-align: left;
  padding: 2px;
}

#todaybar,#yesterdaybar
{
	float:left;
	min-height:230px;
	min-width:40%;
	max-width:40%;
	width:40%;
	padding-left:5%;
}

#yestardaybar
{
	padding-left:10%;
}
.circles-div{
text-align:center;
position:absolute;
margin-top:130px;
z-index:99;
}
#circle {
      width: 10px;
      height: 10px;
      background: #87cefa;
      border-radius: 50%;
	  display:inline-block;
	  margin:0 5px;
}
#horizontalbar {
  max-width: 350px;

}
.arrow-up {
color:#89CFF0;
font-size:15px;
}
.arrow-down {
color:#89CFF0;
font-size:15px;
}

.simchart li  {
    display: inline-block;
    width: 12px;
    height: 12px;
    margin-right: 5px;
    border-radius: 25px;
}
.cleared
{
background-color:#7BC342;
}
.down
{
background-color:#fe2712;
}
.warning
{
background-image:linear-gradient(#7BC342,#7BC342,#fe2712,#7BC342,#7BC342);
}
.critical
{
background-color:#fe2712;
}

#star
{
margin:0px;
padding:0;
margin-top:-5px;
vertical-align:top;
height:10px;
width:10px;
}
.leftscroller
{
	 direction: rtl;
	 height:100%;
}
#nodec
{
	text-decoration:none;
	color:black;
}
#sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0px;
  z-index: 1;
}	
.thcolor
{
background-color:white;
min-width:20%;
}
.nodealign{
cursor:pointer;
	text-align: left;
	padding-right: 15%;
}
#active
{
color: #7BC342;
}
#down{
	color: #FF6347;
}
#inactive
{
	color: #C70039;
}

</style>
	<link rel="stylesheet" href="/imission/css/jquery-ui.css">
	<link rel="stylesheet" href="/imission/css/style.css">
	<script src="/imission/js/jquery.js"></script>
	<script src="/imission/js/jquery-ui.js"></script>
<script type="text/javascript">
const simmap = new Map();
const devinfomap = new Map();
var sim1Chart;
var sim2Chart; 
var half_height='250px';

function getFirtHalfHeight()
{
	half_height = document.getElementById("todayact").clientHeight;
}

function fnBlink() {
    $(".warning").fadeOut(500);
    $(".warning").fadeIn(500);
  }
  setInterval(fnBlink, 500);
  function funBlink() {
	    $(".critical").fadeOut(500);
	    $(".critical").fadeIn(500);
	  }
	  setInterval(funBlink, 500);
	  var ctrlKeyDown = false;
	  function disableF5(e) 
	  { 
	  	if ((e.which || e.keyCode) == 116 || ((e.which || e.keyCode) == 82 && ctrlKeyDown)) 
	  		e.preventDefault(); 
	  	else if ((e.which || e.keyCode) == 17) {
	          // Pressing  only Ctrl
	          ctrlKeyDown = true;
	      }
	  };
	  $(document).on("keydown", disableF5);
function setBodyHeight()
{
	var scbody= document.getElementById("dbbody");
	var curheight =(parseInt(window.innerHeight)-90);
	scbody.style.height = curheight;
	scbody.clientHeight = curheight;
}
function setOutertablesHeight()
{
	var scbody= document.getElementById("dbbody");
	var outtables = document.getElementsByClassName("outertable");
	var height = Math.round((scbody.clientHeight-230)/2-1);
	for(var i=0;i<outtables.length;i++)
		outtables[i].style.height =  height+"px";
	document.getElementById("favdiv").style.height = (height-10)+"px";
	document.getElementById("alarmsdiv").style.height = (height-10)+"px";
	var circlediv = document.getElementsByClassName("circles-div");
	for(var i=0;i<circlediv.length;i++)
		circlediv[i].style.marginTop=(height-70)+"px";
}

function setHeatmapHeight()
{
	var act_tab = document.getElementById("todayact");
	half_height = act_tab.clientHeight;
	var heamap_div = document.getElementById("heatmapdiv");
	var heamap_tab = document.getElementById("heatmaptab");
	heamap_div.style.maxHeight =  half_height+"px";
	heamap_div.height =  half_height+"px";
	heamap_div.style.height = half_height+"px";
	
	heamap_tab.style.height = half_height+"px";
	heamap_tab.height = half_height+"px";
	heamap_div.style.minHeight =  half_height+"px";
	heamap_tab.style.minHeight =  half_height+"px";
	
}
function addSimData(slno,sim1data,sim2data)
{
	simmap.set(slno+'sim1',sim1data);
	simmap.set(slno+'sim2',sim2data);
}
function addDevInfo(slno,loopbackip,location,sq,uptime,devstatus,activesim)
{
	var arr = new Array(loopbackip,location,sq,uptime,devstatus,activesim);
	devinfomap.set(slno,arr);
}
function updateFavTab(slno)
{
	var infoarr = devinfomap.get(slno);
	var info="<label style=\"min-width:73px; font-weight:bold;\">S.No</label>: "+slno+"<br>"+
	"<label class=\"nwlbl\">Loopback IP</label>   : "+infoarr[0]+"<br>"+
	"<label class=\"nwlbl\">Location</label>   : "+infoarr[1]+"<br>"+
	"<label class=\"nwlbl\">Signal Strength</label> : "+infoarr[2]+"<br>"+
	"<label class=\"nwlbl\">Uptime</label>   : "+infoarr[3]+"<br>"+
	"<label class=\"nwlbl\">Status</label>   : "+infoarr[4]+"<br>"+
	"<label class=\"nwlbl\">Active SIM</label>   : "+infoarr[5]+"<br>";
	document.getElementById("slider").innerHTML = info;

	if(simmap.has(slno+"sim1"))
	{
		var sim1data = simmap.get(slno+"sim1");
		var sim2data=simmap.get(slno+"sim2");
		barchart(sim1data[0],sim1data[1],sim1data[2],sim1data[3],sim1data[4]);
		barchart(sim2data[0],sim2data[1],sim2data[2],sim2data[3],sim2data[4]);
	}
	else
	{
		barchart("sim1week","-,-,-,-,-,-,-,","0.00,0.00,0.00,0.00,0.00,0.00,0.00","0.00,0.00,0.00,0.00,0.00,0.00,0.00","SIM1 Data Usage Weekly(in MB)");
		barchart("sim2week","-,-,-,-,-,-,-,","0.00,0.00,0.00,0.00,0.00,0.00,0.00","0.00,0.00,0.00,0.00,0.00,0.00,0.00","SIM2 Data Usage Weekly(in MB)");
	}	
}
function goToURL(url)
{
	window.location.href = url;
}
	function makelink(sortby,sorttype,cursortby)
	{
	    var url = "dashboard.jsp?slnumber="+sortby+"&limit=10";
		sortby = cursortby;
		if(sorttype == "asc"){
			sorttype = "desc";
		}
		else{
			sorttype = "asc";
		}
		url += "&sortby="+sortby+"&sorttype="+sorttype;
		window.location = url;
	}

function barchart(chartid,datedata,updata,downdata,charttitle) {
	var ctx = document.getElementById(chartid);
	 while (ctx.lastElementChild) {
		 ctx.removeChild(ctx.lastElementChild);
		  }
	var datedataarr = datedata.split(",");
	var updataarr = updata.split(",");
	var downdataarr = downdata.split(",");
	//data = {type:"bar",data:{labels:[getDateFormat(datedataarr[0]),getDateFormat(datedataarr[1]),getDateFormat(datedataarr[2]),getDateFormat(datedataarr[3]),getDateFormat(datedataarr[4]),getDateFormat(datedataarr[5]),getDateFormat(datedataarr[6])],datasets:[{label:"Upload",barPercentage:1,barThickness:15,maxBarThickness:15,minBarLength:5,backgroundColor:["#AACE77","#AACE77","#AACE77","#AACE77","#AACE77","#AACE77","#AACE77"],fillColor:"brown",strokeColor:"red",data:[updataarr[0],updataarr[1],updataarr[2],updataarr[3],updataarr[4],updataarr[5],updataarr[6]]},{label:"Download",barPercentage:1,barThickness:15,maxBarThickness:15,minBarLength:5,backgroundColor:["#66BFEE","#66BFEE","#66BFEE","#66BFEE","#66BFEE","#66BFEE","#66BFEE"],fillColor:"blue",strokeColor:"green",data:[downdataarr[0],downdataarr[1],downdataarr[2],downdataarr[3],downdataarr[4],downdataarr[5],downdataarr[6]]}]},options:{scales:{yAxes:[{ticks:{beginAtZero:true}}]},title:{display:true,text:charttitle}}};
	data = {
	type: "bar",
	data: {
		labels: [getDateFormat(datedataarr[0]), getDateFormat(datedataarr[1]), getDateFormat(datedataarr[2]), getDateFormat(datedataarr[3]), getDateFormat(datedataarr[4]), getDateFormat(datedataarr[5]), getDateFormat(datedataarr[6])],
		datasets: [{
			label: "Upload",
			barPercentage: 10,
			barThickness: 15,
			maxBarThickness: 15,
			minBarLength: 5,
			backgroundColor: ["#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77"],
			fillColor: "brown",
			strokeColor: "red",
			data: [updataarr[0], updataarr[1], updataarr[2], updataarr[3], updataarr[4], updataarr[5], updataarr[6]]
		}, {
			label: "Download",
			barPercentage: 10,
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
			xAxes: [{
				ticks: {
					beginAtZero: true,
					display: false 
				},
				gridLines: {
					color: "rgba(0, 0, 0, 0)",
				}
				}],
        yAxes: [{
				scaleLabel: {
					display: true,
					},
				ticks: {
						beginAtZero: true,
						display: false 
					},
				gridLines: {
					color: "rgba(0, 0, 0, 0)",
				}   
				}]
			},
		title: {
			display: true,
			text: charttitle
		},
	}
};
	if(chartid == 'sim1week')
	{
		if(sim1Chart == null)
			sim1Chart = new Chart(ctx,data);
		else
		{
			sim1Chart.destroy();
			ctx.style.maxWidth='300px';
			ctx.style.minWidth='300px';
			sim1Chart = new Chart(ctx,data);
		}
	}
	else
	{
		if(sim2Chart == null)
			sim2Chart = new Chart(ctx,data);
		else
		{
			sim2Chart.destroy();
			ctx.style.maxWidth='300px';
			ctx.style.minWidth='300px';
			sim2Chart = new Chart(ctx,data);
		}
	}
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

var tvchartdata = [0,0,0];
var yvchartdata = [0,0,0];

function updateVhartValues(total,up,down,day)
{
	if(day == "today")
	{
		tvchartdata[0] = total;
		tvchartdata[1] = up;
		tvchartdata[2] = down;
	}
	if(day == "yesterday")
	{
		yvchartdata[0] = total;
		yvchartdata[1] = up;
		yvchartdata[2] = down;
	}
}

var cnfhdata = [0,0,0];
var upghdata = [0,0,0];
var rbthdata = [0,0,0];

function updatecnfchartValues(inprogress,success,failed)
{
	cnfhdata[0] = inprogress;
	cnfhdata[1] = success;
	cnfhdata[2] = failed;
}

function updateupgchartValues(inprogress,success,failed)
{
	upghdata[0] = inprogress;
	upghdata[1] = success;
	upghdata[2] = failed;
}

function updaterbtchartValues(inprogress,success,failed)
{
	rbthdata[0] = inprogress;
	rbthdata[1] = success;
	rbthdata[2] = failed;
}

var rbseries = [0,0,0];
function updaterbseriesValues(up,down,total)
{
	rbseries[0] = up;
	//rbseries[1] = inactive;
	rbseries[1] = down;
	//rbseries[3] = diodown;
	rbseries[2] = total;
}

var mytitle="Today";
window.onload = function () {
var options = {
colors : ['#318ce7', '#3CB371','#FF6347'],
  chart: {
    type: 'bar',
	height:200
  },
  grid:{
	show:true,
	xaxis:
	{
		lines:
		{
		show:false
		}
	},
	yaxis:
	{
		lines:
		{
		show:false,
		}
	},
  },
  yaxis:{
  axisTicks: {
    show: false,
	min: 5,
  },
  axisBorder: {
    show: false
  },
  labels: {
    show: false
  },
  },
  series: [{
    name: 'Today',
    data: [tvchartdata[0],tvchartdata[1],tvchartdata[2]]
  }],
   plotOptions: {
          bar: {
            horizontal: false,
			distributed: true,
			barHeight:'30%',
			columnWidth: '90%',
          },
        },
		dataLabels: {
          enabled: true,
		  style: {
                colors: ['#555']
              },			  
        },
		colors: ["#1974d0", "#7BC342", "#fe2712"],
		title: {
                text: mytitle,
				style: 
					{
						fontWeight:  'string'
					},
				align: 'center',
              },
			  legend: {
          show: false
        },
  xaxis: {
	axisTicks: {
    show: false
  },
  axisBorder: {
    show: false
  },
    categories: ['Total','Active','Down']
  }
}

var chart = new ApexCharts(document.querySelector("#todaybar"), options);
chart.render();

var chart1 = new ApexCharts(document.querySelector("#yesterdaybar"), options);
chart1.render();

try{
chart1.updateSeries([{
     name: 'Yesterday',
    data: [yvchartdata[0],yvchartdata[1],yvchartdata[2]]
}])
chart1.updateOptions({
  title: {
    text: 'Yesterday'
  }
})
}
catch(e){
}
//node status vertical bar
var options = {
      chart: {
          type: 'bar',
          height: 200,
          stacked: true,
        },
        grid:{
        	show:false,
          },
          xaxis:{
        	  axisTicks: {
        	    show: false,
        	  },
        	  axisBorder: {
        	    show: false
        	  },
        	  labels: {
        	    show: true,
        	  },
        	  },
          yaxis:{
        	  axisTicks: {
        	    show: false,
        	  },
        	  axisBorder: {
        	    show: false
        	  },
        	  labels: {
        	    show: false
        	  },
        	  },
        	  series: [{
        		  name: 'Up', 
                  data: [rbseries[0]]
                },{
                  name: 'Down',
           	      data: [rbseries[1]]
                }],
        plotOptions: 
		{
        	 bar: {
                 horizontal: false,
     			distributed: false,
     			barHeight:'5%',
     			columnWidth: '35%',
               },
        },
        colors: ["#7BC342","#FF6347"],
		dataLabels: {
			enabled: true,
			  style: {
	                colors: ['#555']
	              },
		},
		fill: {
            opacity: 1,
          }, 
          tooltip: {
              y: {
                formatter: function (val) {
                  return val
                }
              }
            },
      labels: ['Total : '+rbseries[2]],
      };
	  /* var chart = new ApexCharts(document.querySelector("#verticalbar"), options);
      chart.render(); */
      // horizontal bar
      var options = {
              series: [{
              name: 'In-progress',
              data: [cnfhdata[0],upghdata[0],rbthdata[0]]
            }, {
              name: 'Success',
              data: [cnfhdata[1], upghdata[1], rbthdata[1]]
            }, {
              name: 'Fail',
              data: [cnfhdata[2], upghdata[2], rbthdata[2]]
            }],
              chart: {
              type: 'bar',
              height: 200,
              stacked: true,
              stackType: '100%'
              //stackType: '10'
            },
            plotOptions: 
    		{
              bar: {
                horizontal: true,
              },
            },
    		dataLabels:{
              enabled: true,
    		    style: {
                    colors: ['#555']
                  },
            },
    		colors : ['#318ce7', '#7BC342','#FF6347'],
            stroke: {
              width: 1,
              colors: ['#FFF']
            },
    		grid: {
              show: false
            },
            title: {
              text: 'In Progress/Success/Fail',
    		  style: 
    					{
    						fontWeight:  'string'
    					},
    		  align:'center'
            },
            xaxis: {
    		axisBorder: {
    				  show: false,
    				},
    				axisTicks:{
    				  show: false,
    				},
    				labels:{show:false},
              categories: ['Config','Upgrade','Reboot'],
            },
    		yaxis: {
    		axisBorder: {
    				  show: false,
    				},
    				axisTicks:{
    				  show: false,
    				}
            },
            tooltip: {
              y: {
                formatter: function (val) {
                  return val
                }
              }
            },
            fill: {
              opacity: 1,
            }, 
            };

            var chart = new ApexCharts(document.querySelector("#horizontalbar"), options);
            chart.render();
      ///////////////
}

function setFavViewPort()
{
	var dragger = document.getElementById("dragger");
	var favviewarea = document.getElementById("favviewdiv");
	var viewarea = document.getElementById("favviewdivch");
	var areaheight = favviewarea.offsetHeight;
	var viewpoint = 100-dragger.value;
	var top_val = (areaheight*viewpoint)/100;
	favviewarea.scrollTop = parseInt(top_val);
}
</script>
</head> 
<body id="dbbody">
	<% 
//XssRequestWrapper req = new XssRequestWrapper(request);

	
	
 SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM YYYY hh:mm:ss aaa");
 SimpleDateFormat total_time_fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
 String sorttype =  request.getParameter("sorttype")==null? "desc":request.getParameter("sorttype").equals("asc")?"asc":"desc";                                          
 String sortby =  request.getParameter("sortby")==null? "slnumber":request.getParameter("sortby");
 String slnumber = request.getParameter("slnumber") == null?"":request.getParameter("slnumber");
 M2MNodeOtagesDao outagedao = new M2MNodeOtagesDao();
 
 if( user.getRole().equals(Role.ADMIN)||  user.getRole().equals(Role.SUPERADMIN) || !user.getRole().equals(Role.VIEW)) { 
	  
      try
      {
    	  String limitstr = (request.getParameter("limit") == null? "20" : request.getParameter("limit"));
		  List<NodeDetails> nodelist = nodedao.getNodeList(user, NodeStatus.ALL, true);
		  List<NodeDetails> yes_nodelist = nodedao.getYesterdayNodeList(user, NodeStatus.ALL, true);
		  List<M2MNodeOtages> alarmslist = outagedao.getAlarmsList(user);
		  int downtoday = nodedao.getDownCount(user,"today");
		  int downyesterday = nodedao.getDownCount(user,"yesterday");
		  Hashtable <String,Integer> configstatustab = nodedao.getConfigStatusTable(user, "config"); 
		  Hashtable <String,Integer> upgradestatustab = nodedao.getConfigStatusTable(user, "upgrade"); 
		  Hashtable <String,Integer> rebootstatustab = nodedao.getConfigStatusTable(user, "reboot"); 
		  
		  //String configqry ="select slnumber,(select count(id) from nodedetails where (export='yes' or sendconfig='yes') and configinittime > current_date) as inprogress,(select count(id) from nodedetails where export='no' and sendconfig='no' and (exportstatus = 1 or sendconfigstatus = 1) and configinittime > current_date) as success,(select count(id) from nodedetails where export='no' and sendconfig='no' and (exportstatus = 2 or sendconfigstatus = 2) and configinittime> current_date) as failed from nodedetails where configinittime > current_date limit 1";
		  //String upgradeqry ="select (select count(id) from nodedetails where upgrade='yes' and upgradeinittime > current_date) as inprogress,(select count(id) from nodedetails where upgrade='no' and upgradestatus = 1 and upgradeinittime > current_date) as success,(select count(id) from nodedetails where upgrade='no' and upgradestatus = 2 and upgradeinittime > current_date) as failed from nodedetails where upgradeinittime > current_date limit 1";
		  //String rebootqry ="select (select count(id) from nodedetails where reboot='yes' and rebootinittime > current_date) as inprogress,(select count(id) from nodedetails where reboot='no' and rebootstatus = 1 and rebootinittime > current_date) as success,(select count(id) from nodedetails where reboot='no' and rebootstatus = 2 and rebootinittime > current_date) as failed from nodedetails where rebootinittime > current_date limit 1";
		  
		  //String radialqry ="select count(id) as total,(select count(id) from nodedetails where status='down') as major,(select count(id) from nodedetails where status='up') as clear,(select count(id) from nodedetails where status='inactive') as critical from nodedetails where status !='deleted' limit 1";
		  
		  //sql += " order by updatetime desc limit 10";
    	  //rs = st.executeQuery(sql);
    	  Vector<Hashtable<String,String>> res_vec = new Vector<Hashtable<String,String>>();
		  Vector<Integer> todaydata = new Vector<Integer>();
		  Vector<Integer> yesterdaydata = new Vector<Integer>();
		  Vector<Integer> configdata = new Vector<Integer>();
		  Vector<Integer> upgradedata = new Vector<Integer>();
		  Vector<Integer> rebootdata = new Vector<Integer>();
		  Vector<Integer> radialdata = new Vector<Integer>();
    	 for(M2MNodeOtages alarm : alarmslist)
    	  {
    		  Hashtable<String,String> res_sh = new Hashtable<String,String>();
    		  res_sh.put("severity",alarm.getSeverity());
    		  res_sh.put("slnumber",alarm.getSlnumber());
    		  res_sh.put("alarminfo",alarm.getAlarmInfo()==null?"":alarm.getAlarmInfo());
			  res_sh.put("downtime",alarm.getDowntime()==null?(alarm.getUpdateTime()==null?"":total_time_fmt.format(alarm.getUpdateTime())):total_time_fmt.format(alarm.getDowntime()));
			  
    		  res_sh.put("uptime",alarm.getUptime()==null?"":total_time_fmt.format(alarm.getUptime()));
			  res_vec.add(res_sh);
		  }
			
			todaydata.add(nodelist.size());
			todaydata.add(nodelist.size()-downtoday);
			todaydata.add(downtoday);
			if(todaydata.size() == 0)
			{
				todaydata.add(0);
				todaydata.add(0);
				todaydata.add(0);
			}
			%>
			<script type="text/javascript">	
				updateVhartValues(<%=todaydata.get(0)%>,<%=todaydata.get(1)%>,<%=todaydata.get(2)%>,'today');
			</script>
			<% 	
				yesterdaydata.add(yes_nodelist.size());
				yesterdaydata.add(yes_nodelist.size()-downyesterday);
				yesterdaydata.add(downyesterday);
			if(yesterdaydata.size() == 0)
			{
				yesterdaydata.add(0);
				yesterdaydata.add(0);
				yesterdaydata.add(0);
			}
			%>
			<script type="text/javascript">	
				updateVhartValues(<%=yesterdaydata.get(0)%>,<%=yesterdaydata.get(1)%>,<%=yesterdaydata.get(2)%>,'yesterday');
			</script>
			<%
				configdata.add(configstatustab.get("inprogress"));
				configdata.add(configstatustab.get("success"));
				configdata.add(configstatustab.get("failed"));
			%>
			<script type="text/javascript">	
				updatecnfchartValues(<%=configdata.get(0)%>,<%=configdata.get(1)%>,<%=configdata.get(2)%>);
			</script>
			<%
				upgradedata.add(upgradestatustab.get("inprogress"));
				upgradedata.add(upgradestatustab.get("success"));
				upgradedata.add(upgradestatustab.get("failed"));
				
			%>
			<script type="text/javascript">	
				updateupgchartValues(<%=upgradedata.get(0)%>,<%=upgradedata.get(1)%>,<%=upgradedata.get(2)%>);
			</script>
			<%
				rebootdata.add(rebootstatustab.get("inprogress"));
				rebootdata.add(rebootstatustab.get("success"));
				rebootdata.add(rebootstatustab.get("failed"));
			%>
			<script type="text/javascript">	
				updaterbtchartValues(<%=rebootdata.get(0)%>,<%=rebootdata.get(1)%>,<%=rebootdata.get(2)%>);
			</script>
			<%
			//rs = st.executeQuery(radialqry); 
			
			 int up = 0;
			 int down = 0;
			 int inactive = 0;
			 int diodown = 0;
			 int total = nodelist.size();
			 for(NodeDetails node : nodelist)
			 {
				 /* if(node.getStatus().equals(NodeStatus.UP) && (node.getDi1().equals("1") 
						 || node.getDi2().equals("1")  || node.getDi3().equals("1")) && (node.getDi1() != null && node.getDi2() != null && node.getDi3() != null))
					 diodown++; */
				 if(node.getStatus().equals(NodeStatus.UP))
					 up++;
				 else if(node.getStatus().equals(NodeStatus.DOWN))
					 down++;
				 else if(node.getStatus().equals(NodeStatus.INACTIVE))
					 inactive++;
				 
			 }
			 radialdata.add(up);
			 radialdata.add(down);
			 //radialdata.add(diodown);
			 radialdata.add(nodelist.size());
			 radialdata.add(inactive);
			%>
			<script type="text/javascript">	
			updaterbseriesValues(<%=radialdata.get(0)%>,<%=radialdata.get(1)%>,<%=radialdata.get(2)%>);
		</script>
		<%
		  //rs = st.executeQuery("select fa.slnumber as slnumber,nd.location as location,nd.loopbackip as loopbackip,nd.signalstrength as signalstrength,nd.routeruptime as uptime,nd.status as status,nd.activesim as activesim from favourites fa inner join nodedetails nd on nd.slnumber=fa.slnumber");
		  List<String> favsllist = user.getFavouriteList();
		  List<NodeDetails>favnodelist =  nodedao.getNodeList(favsllist);
		  for(NodeDetails favnode : favnodelist)
		  {
			  Hashtable<String,String> fav_row_ht = new Hashtable<String,String>();
			 
			  fav_row_ht.put("slnumber",favnode.getSlnumber());
			  fav_row_ht.put("loopbackip",favnode.getLoopbackip());
			  fav_row_ht.put("location",favnode.getLocation());
			  fav_row_ht.put("signalstrength",favnode.getSignalstrength());
			  String ruptime = favnode.getRouteruptime();
					String ruptime_arr[] = ruptime.split(":");
					try{
						ruptime = Integer.parseInt(ruptime_arr[0])+" days "+
								  Integer.parseInt(ruptime_arr[1])+" hours "+
								  Integer.parseInt(ruptime_arr[2])+" mins "+
								  Integer.parseInt(ruptime_arr[3])+" sec";
					}
					catch( Exception e)
					{
						
					}
			  fav_row_ht.put("uptime",ruptime);
			  fav_row_ht.put("status",favnode.getStatus());
			  fav_row_ht.put("activesim",favnode.getActivesim());
			  if(fav_slnumber.length() == 0)
				  fav_slnumber = fav_row_ht.get("slnumber");
			  
			  favourites_ht.put(fav_row_ht.get("slnumber"),fav_row_ht);
		  }
		  String nodestatus="";
		  for(NodeDetails node : nodelist)
		  {
			  Hashtable<String,String> out_ht = new Hashtable<String,String>();
			  out_ht.put("slnumber",node.getSlnumber());
			  out_ht.put("imeinumber",node.getImeinumber());
			  out_ht.put("nodelabel",node.getNodelabel());
			  out_ht.put("loopbackip",node.getLoopbackip());
			  out_ht.put("location",node.getLocation());
			  out_ht.put("status",NodeStatus.getNodeStatusForTitle(node));
			   nodestatus = node.getStatus().toLowerCase();
			  out_ht.put("severity",(nodestatus.equals(NodeStatus.UP) && (node.getDi1().equals("1") || node.getDi2().equals("1") || node.getDi3().equals("1")))?"warning":nodestatus.equals(NodeStatus.INACTIVE)?"critical":nodestatus.equals(NodeStatus.DOWN)?"down":"cleared");
			  slnum_list.add(out_ht.get("slnumber"));
			 // heatmap_vec.add(out_ht); 
			  if(nodestatus.equals("up"))
				  nodeactive_vec.add(out_ht); 
			  else if(nodestatus.equals("down"))
				  nodedown_vec.add(out_ht);
			  else if(nodestatus.equals("inactive"))
				  nodeinactive_vec.add(out_ht);
		  }
		  if(nodelist.size() > 200)
			  no_blocks = no_blocks*2-10;
		  if(nodelist.size() > 100)
			  no_blocks = no_blocks;  
%>
<div style="height:100%">
<table class="outertable" width="100%">
    	<tr>		
    	<td id="todayact" style="width:32%" height="50%">
			<table id="network" style="border:1px solid #ddd;">
			<tr>
				<th style="background-color:#ddd; color:black; border:1px solid #ddd;">My Network</th>
			</tr>
			<tr>
			<td style="border:1px solid #ddd;">
				<div>
					<div id="todaybar"></div>
					<div id="yesterdaybar"></div>
				</div>
			</td>
			</tr>
			</table>
		</td>
		<td style="width:30%" height="50%">
		<script>
			getFirtHalfHeight();
		</script>
			<table id="activity" style="border:1px solid #ddd;">
			<tr>
				<th style="background-color:#ddd; color:black; border:none;">Today Activity</th>
			</tr>
			<tr>
				<td style="border:none;">
					<div>
						<div id="horizontalbar" style="float:left;height:200px;width:100%;"></div>
					</div>
				</td>
			</tr>
			</table>
		</td>
		
		<td style="width:40%;height:50%;max-height:50%;vertical-align: top;border:">
		<div id="heatmapdiv"  style="overflow-y:scroll;scrollbar-width:thin;scrollbar-height:50px">
		<table id="heatmaptab">
		<thead id="sticky">
		<tr>
			<th colspan="3" style="background-color:#ddd; color:black;height: 4%">Node Status
			</th>
		</tr>
		<tr style="vertical-align: top">
	        <th class="thcolor" >Active  <label style="color:#7BC342"><%=radialdata.get(0)%></label></th>
	        <th class="thcolor" >Down  <label style="color:#FF6347"><%=radialdata.get(1)%></label></th>
	        <th class="thcolor" >InActive  <label style="color:#C70039 "><%=radialdata.get(3)%></label></th>
	    </tr>
	    </thead>
		<tbody>
		<%
			int max_rows = nodeactive_vec.size() >= nodedown_vec.size()?nodeactive_vec.size():nodedown_vec.size();
			max_rows = max_rows >= nodeinactive_vec.size()?max_rows:nodeinactive_vec.size();
			for(int i=0;i<max_rows;i++)
			{
		%>
		 <tr id="rowdata" style="vertical-align: top">
			 <td for="activenodes" style="text-align:center;";>
		    <%
		       if(i < nodeactive_vec.size())
		       {
			    Hashtable<String, String> nodeactive = nodeactive_vec.get(i);
			%>
<div id="activenode" class="nodealign"
title="Serial Number : <%= nodeactive.get("slnumber") %>  
IMEI Number : <%= nodeactive.get("imeinumber") %> 
Host Name : <%= nodeactive.get("nodelabel") %>
Location : <%= nodeactive.get("location") %>
Status : <%= nodeactive.get("status") %>" onclick="goToURL('m2m/node.jsp?slnumber=<%= nodeactive.get("slnumber") %>')">
<a id="active"><%= nodeactive.get("location") %></a>
</div>
			<% 
				} 
			%>
			</td>
			<td for="downnodes" style="text-align:center;">
		    <%
				if(i < nodedown_vec.size()) {
			    Hashtable<String, String> nodedown = nodedown_vec.get(i);
		    %>
				<div  id="downnode" class="nodealign" style="text-align:left" 
title="Serial Number : <%= nodedown.get("slnumber") %>  
IMEI Number : <%= nodedown.get("imeinumber") %> 
Host Name : <%= nodedown.get("nodelabel") %>
Location : <%= nodedown.get("location") %>
Status : <%= nodedown.get("status") %>" 
onclick="goToURL('m2m/node.jsp?slnumber=<%= nodedown.get("slnumber")%>')">
					<a id="down"><%= nodedown.get("location") %></a>
				</div>
							<% 
							} 
							%>
						</td>
						<td for="inactivenodes">
						    <%
						if (i < nodeinactive_vec.size()) {
						    Hashtable<String, String> nodeinactive = nodeinactive_vec.get(i);
						    %>
<div id="inactivenode" class="nodealign"
title="Serial Number : <%= nodeinactive.get("slnumber") %>  
IMEI Number : <%= nodeinactive.get("imeinumber") %> 
Host Name : <%= nodeinactive.get("nodelabel") %>
Location : <%= nodeinactive.get("location") %>
Status : <%= nodeinactive.get("status") %>"  onclick="goToURL('m2m/node.jsp?slnumber=<%= nodeinactive.get("slnumber") %>')">
<a id="inactive"><%= nodeinactive.get("location") %></a>
</div>
						<% 
						} 
						%>
					   </td>
					   </tr>
					   <%
					   
			}
				if(max_rows < 30)
				{
				for(int c=max_rows;c<30;c++)
				{
				%>
					<tr>
					<td>
					</td>
					<td>
					</td>
					<td>
					</td>
					</tr>
			<%}}%>
					 <!--   </div>
					</div> -->
			</tbody>
		</table> 
		</div>
		</td>
		</tr>
</table>
<table  width="100%">
<tr>
<td style="vertical-align:top" width="50%">
<div id="favdiv" class="leftscroller" style="overflow-y:scroll;scrollbar-width:thin;scrollbar-height:30px">
<div style="direction:ltr;height:100%">
<table id = "container" class="table table-condensed severity">
<thead id="sticky">
<tr>
<th width="100%" height='5' colspan="2" style="background-color:#ddd; background:#ddd; color:black; border:1px solid #ddd; vertical-align:middle;">
<img  src ="images/Blue_Star.png" alt="" border=""  width="15" style="padding-bottom:3px;padding-right:0px;">
</img>My Favourites<a href="favourites.jsp"><i class="fa fa-plus" aria-hidden="true"></i></a></th>
</tr>
</thead>
<tr width="100%" id="favviewdiv">
<!-- <div ><input id="dragger" type="range" value="100" min="0"; max="100" style="position:absolute;top:415px;" orient="vertical" oninput="setFavViewPort()"/>

<td id="slider" style="padding-left:2%;font-weight:bold;width:45%;vertical-align:top">
<div id="favviewdivch" style="height:300px;"> -->
<td id="slider" style="padding-left:2%;font-weight:bold;width:45%;vertical-align:top">
 <%
Set<String> fav_key_set = favourites_ht.keySet();
Hashtable<String,String> res_sh = null;
	for(String slno: fav_key_set){
		res_sh  = favourites_ht.get(slno);
			String signalstr = res_sh.get("status").equals("up")?res_sh.get("signalstrength"):"-";
			String uptimestr = res_sh.get("status").equals("up")?res_sh.get("uptime"):"-";
			String devstatus = res_sh.get("status").equals("up")?"Active":res_sh.get("status").equals("down")?"Down":"In Active";
			String activesim = res_sh.get("status").equals("down") || res_sh.get("status").equals("inactive")?"-":res_sh.get("activesim").equals("SIM 1")?"1":"2";
		%>
		<script>
		addDevInfo('<%=res_sh.get("slnumber")%>','<%=res_sh.get("loopbackip")%>','<%=res_sh.get("location")%>','<%=signalstr%>','<%=uptimestr%>','<%=devstatus%>','<%=activesim%>');
		</script>
	  <%
   }%>

</td>
<td style="width:50%">
<div class ="circles-div" style="align:center">
  <%
   for(String slno: fav_key_set)
   {%> 
	  <!-- <a id="circle" href="dashboard.jsp?slnumber=<%=slno%>"> </a> -->
	  <span id="circle" style="cursor:pointer;" title="Serial Number : <%=slno%>" onclick="updateFavTab('<%=slno%>')"> </span> 
  <% } %>
</div>
<canvas id="sim1week" style="max-height:110px;max-width:300px; "></canvas>
<canvas id="sim2week" style="max-height:110px;max-width:300px;margin-top:40px"></canvas>
</td>
<!-- </div>
</div> -->
</tr>
</table>
</div>
</div>
</td>
<td width="50%" style="vertical-align:top">
<div id="alarmsdiv" style="overflow-y:scroll;scrollbar-width:thin;">															
<table id = "container" class="table table-condensed severity" style="height:32px">
	<thead id="sticky">
	<tr>
	<th colspan="4"  height='5' style="background-color:#ddd; background:#ddd;color:black; border:none;"><a id="nodec" href="m2m/alarm/alarms.jsp">Recent Alarms</a></th>
	<!-- <th id="serialnum" width="30%" style="background-color:#ddd;background:#ddd;color:black; border:none; vertical-align:middle;" class="headerSortUpDown">
	<div onclick="makelink('<%=slnumber%>','<%=sorttype%>','<%=sortby%>')">Device S.No&nbsp;
	<div class="fa fa-caret-up arrow <%if(sorttype.equals("asc")){%>hidden<%}%>"></div>
	<div class="fa fa-caret-down arrow <%if(sorttype.equals("desc")){%>hidden<%}%>"></div>
	</div>	
	</th> -->
	</tr>
	</thead>
	<% for(int i=0;i<res_vec.size();i++){
		Hashtable<String,String> res_sh1 = res_vec.get(i);
	%>
         <tr valign="top" class="severity-<%=res_sh1.get("severity")%>">
         	<td style="min-width:20%" class="divider bright">
         	<%=res_sh1.get("slnumber")%>&nbsp;&nbsp;
			</td>
			<td>
			<%=res_sh1.get("alarminfo") %>
			</td>
			<td>
			<%=res_sh1.get("downtime")%>
			</td>
			<td>
			<%=res_sh1.get("uptime")%>
			</td>
         </tr>					
      <%}
	  }
      catch(Exception e)
      {
    	  e.printStackTrace();
      }
      finally
      {
      }
}
      %>

</table>
</div>
</td>
</tr>
</table>
</div>
<%
if(serialno.trim().length() == 0 && fav_slnumber.length()> 0)
{
	serialno = fav_slnumber;
}
for(String slno:favourites_ht.keySet())
{

	   Properties m2mprops = M2MProperties.getM2MProperties();
	   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slno;
	   try
	   {
	   	jsonreader = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Status.json")));
	   }
	   catch(Exception e)
	   {
		   System.out.println("the json file not exists" );
		   //e.printStackTrace();
	   }
	   String jsonString = null;
	   jsonbuf = new StringBuffer("");
	   if(jsonreader != null)
	   {
		   while((jsonString = jsonreader.readLine())!= null)
	   			  jsonbuf.append( jsonString );
	   }
	    sim1weekupvalue = "";
		sim1weekdownvalue ="";
		sim1weekdatevalue="";
		sim2weekupvalue = "";
		sim2weekdownvalue = "";
		sim2weekdatevalue = "";
	if(jsonbuf != null && jsonbuf.toString().length() > 0 && jsonbuf.toString().contains("STATUS"))
	{	
		try{
				//statusobj = JSONObject.fromObject(jsonbuf.toString()).getJSONObject("STATUS").getJSONObject("Status");
				
					statusobj = JSONObject.fromObject(jsonbuf.toString());
					JSONObject datausgobj = statusobj.getJSONObject("STATUS").getJSONObject("DataUsage");
					//JSONObject weekusage = datausgobj.getJSONObject("HEADINGW");
					JSONObject s1weekusage = datausgobj.getJSONObject("TABLEWSIM1");
					JSONObject s2weekusage = datausgobj.getJSONObject("TABLEWSIM2");
					JSONArray s1weekarr = s1weekusage.getJSONArray("arr");
					JSONArray s2weekarr = s2weekusage.getJSONArray("arr");
					
					for (int i = 0; i < s1weekarr.size(); i++) {
						JSONObject weekobj = s1weekarr.getJSONObject(i);
						sim1weekupvalue += weekobj.getString("Upload(MB)") + ",";
						sim1weekdownvalue += weekobj.getString("Download(MB)") + ",";
						sim1weekdatevalue += weekobj.getString("Week") + ",";
					}
					for (int i = 0; i < s2weekarr.size(); i++) {
						JSONObject weekobj = s2weekarr.getJSONObject(i);
						sim2weekupvalue += weekobj.getString("Upload(MB)") + ",";
						sim2weekdownvalue += weekobj.getString("Download(MB)") + ",";
						sim2weekdatevalue += weekobj.getString("Week") + ",";
					}
					for (int i = s1weekarr.size(); i < 7; i++) {
						sim1weekupvalue += "0.00,";
						sim1weekdownvalue += "0.00,";
						sim1weekdatevalue += " ,";
					}
					for (int i = s2weekarr.size(); i < 7; i++) {
						sim2weekupvalue += "0.00,";
						sim2weekdownvalue += "0.00,";
						sim2weekdatevalue += " ,";
					}
					sim1weekupvalue = sim1weekupvalue.substring(0, sim1weekupvalue.length() - 1);
					sim1weekdownvalue = sim1weekdownvalue.substring(0, sim1weekdownvalue.length() - 1);
					sim1weekdatevalue = sim1weekdatevalue.substring(0, sim1weekdatevalue.length() - 1);

					sim2weekupvalue = sim2weekupvalue.substring(0, sim2weekupvalue.length() - 1);
					sim2weekdownvalue = sim2weekdownvalue.substring(0, sim2weekdownvalue.length() - 1);
					sim2weekdatevalue = sim2weekdatevalue.substring(0, sim2weekdatevalue.length() - 1);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else
		{
			for (int i = 0; i < 7; i++) {
				sim1weekupvalue += "0.00,";
				sim1weekdownvalue += "0.00,";
				sim1weekdatevalue += " ,";
			}
			for (int i = 0; i < 7; i++) {
				sim2weekupvalue += "0.00,";
				sim2weekdownvalue += "0.00,";
				sim2weekdatevalue += " ,";
			}
		}
	if(jsonreader != null)
		jsonreader.close();
%>
 <script>
           try
           {
			var sim1detarr = new Array("sim1week","<%=sim1weekdatevalue%>","<%=sim1weekupvalue%>","<%=sim1weekdownvalue%>","SIM1 Data Usage Weekly(in MB)");
			var sim2detarr = new Array("sim2week","<%=sim2weekdatevalue%>","<%=sim2weekupvalue%>","<%=sim2weekdownvalue%>","SIM2 Data Usage Weekly(in MB)");
			addSimData('<%=slno%>',sim1detarr,sim2detarr);
           }
           catch(e)
           {
        	   
           }
</script>
<%}%>
 <script>
 	setBodyHeight();
 	setOutertablesHeight();
 	setHeatmapHeight();
 	updateFavTab('<%=serialno%>');
 </script>
 </body>
</html>
<jsp:include page="bootstrap-footer.jsp" flush="false" />
