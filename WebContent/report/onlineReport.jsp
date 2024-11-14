<%@page import="com.nomus.staticmembers.UserRole"%>
<%@page import="com.nomus.staticmembers.DateTimeUtil"%>
<%@page import="org.apache.poi.ss.usermodel.DateUtil"%>
<%@page import="com.nomus.m2m.pojo.DataUsage"%>
<%@page import="com.nomus.m2m.dao.DataUsageDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.List"%>
<%@page import="com.nomus.m2m.dao.NodedetailsDao"%>
<%@page import="com.nomus.staticmembers.QueryGenerator"%>
<%@page import="com.nomus.m2m.pojo.User"%>
<%@page import="org.hibernate.internal.SessionImpl"%>
<%@page import="com.nomus.m2m.dao.HibernateSession"%>
<%@page import="org.hibernate.Session"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<% 
   Calendar cal = Calendar.getInstance();
   SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
   Date fromday = cal.getTime();
   cal.add(Calendar.DAY_OF_MONTH, 1);
   Date today = cal.getTime();
   String reportId = request.getParameter("reportId");
   String format = request.getParameter("format")==null?"PDF":request.getParameter("format").trim();
   String choose = request.getParameter("choose")==null?"slnumber":request.getParameter("choose").trim();
   String chooseinput = request.getParameter("chooseinput")==null?"":request.getParameter("chooseinput").trim();
   String nodesel = request.getParameter("nodesel")==null?"all":request.getParameter("nodesel").trim();
   String timeperiod = request.getParameter("timeperiod")==null?"today":request.getParameter("timeperiod").trim();
   String fromdate = request.getParameter("fromdate")==null?sdf.format(fromday):request.getParameter("fromdate").trim();
   String todate = request.getParameter("todate")==null?sdf.format(today):request.getParameter("todate").trim();
   String todate1 = todate;
   String orderby = request.getParameter("orderby")==null?"slnumber":request.getParameter("orderby").trim();
   String ordertype = request.getParameter("ordertype")==null?"asc":request.getParameter("ordertype").trim();
   String type = request.getParameter("type")==null?"single":request.getParameter("type").trim();
   boolean nodata = true;
   if(!timeperiod.equals("custom"))
   {
   Vector<String> dates_vec = getdates(timeperiod);
   fromdate = dates_vec.get(0);
   todate = dates_vec.get(1);
   }
   String statustype = (nodesel.equals("all") || nodesel.equals("single"))?"'up','down','inactive'": nodesel.equals("down")?"'down','inactive'":"'up'";
   User loguser = (User)session.getAttribute("loggedinuser");
  
	NodedetailsDao ndao = new NodedetailsDao();
	String serialnum = request.getParameter("slnumber");
	String startrange = request.getParameter("startrange")==null?"":request.getParameter("startrange");
	String endrange = request.getParameter("endrange")==null?"":request.getParameter("endrange");
	Properties m2mprops = M2MProperties.getM2MProperties();
	List<String> slnumlist = ndao.getSlnumberList(loguser, false);
	List<String> slnumranlist = new ArrayList<String>();
	for(String slnums : slnumlist)
	{
		if(slnums.compareTo(startrange)>=0 && slnums.compareTo(endrange)<=0)
			slnumranlist.add(slnums);
	}
	%>
<jsp:include page="/bootstrap.jsp" flush="false">
	<jsp:param name="title" value="Reports" />
	<jsp:param name="headTitle" value="Reports List" />
	<jsp:param name="limenu" value="Reports" />
	<jsp:param name="breadcrumb"
		value="<a href='reportlist.jsp'>List Reports</a>" />
	<jsp:param name="breadcrumb" value="run" />
</jsp:include>

<html id="reportdiv">
<head>
<link rel="stylesheet" href="/imission/css/jquery-ui.css">
<script src="/imission/js/jquery.js"></script>
<script src="/imission/js/jquery-ui.js"></script>
<script src="/imission/js/jquery-1.4.2.min.js"></script>
<script src="/imission/js/Chart.min.js"></script>
<script type="text/javascript" src="/imission/js/chartjs-plugin-datalabels.js"></script>
<script type="text/javascript" src="/imission/js/chartjs-plugin-datalabels.min.js"></script>
<script src="/imission/js/html2pdf.bundle.min.js"></script>
<script type="text/javascript" src="/imission/m2m/wizngv2/js/common.js"></script>
<style type="text/css">
th {
	background-color: #7BC342;
}

.select {
	min-width: 105px;
	max-width: 105px;
}

th div {
	cursor: pointer;
}

#lightgreydiv {
	position: relative;
	height: 16px;
	background-color: #D9D9D9;
	text-align: center;
	font-weight: bold;
	overflow: hidden;
}

#greendiv {
	height: 16px;
	background-color: #aed581;
	overflow: hidden;
}

#reddiv {
	height: 16px;
	background-color: #FF6666;
	overflow: hidden;
}

.borderlesstab {
	width: 100%;
}

.borderlesstab td {
	vertical-align: top;
}

.innerbtab {
	width: 98%;
	height: 50%
}

.innerbtab td, label {
	padding: 3px;
}

.innertab td img, .innertab td div img {
	width: 20px;
	height: 20px;
}

#sticky {
	position: -webkit-sticky;
	position: sticky;
	top: 0px;
	z-index: 1;
}

thead {
	background-color: #ddd;
}

html, body {
	margin: 1;
	height: 100%;
	overflow-y: hidden
}

.dropdown {
	position: relative;
	display: inline-block;
	float: right;
	top: 1px;
	right: 20px
}

.dropdown-content {
	display: none;
	position: absolute;
	background-color: #f1f1f1;
	z-index: 2;
}

.dropdown-content a {
	color: green;
	text-decoration: none;
	display: block;
}

.dropdown-content a:hover {
	background-color: #ddd;
}

.dropdown:hover .dropdown-content {
	display: block;
}

.content {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 500px;
	height: 300px;
	background-color: #e8eae6;
	box-sizing: border-box;
	z-index: 100;
	display: none;
	/*to hide popup initially*/
}

.toppaddiv
{
padding-top: 30px;
}
.titleheader
{
font-size: 20px;
}
.innertab
{
 width:96%;
 margin-left:2%;
 padding-bottom:30px;
}.innertab td
{
padding:0px;
}
.slnumclass
{
width:100%;
background-color: #006884;
color:white;
font-family:verdana;
font-size: 16px;
display:inline-block;
text-align: center;
}
.duinfo
{
margin-left:1%;
border:1px solid #006884;
width:96%;
margin-bottom: 4px;
}
</style>
<script type="text/javascript">
function barchart(chartid,datedata,updata,downdata,charttitle) {
	try{
		var ctx = document.getElementById(chartid);
		var datedataarr = datedata.split(",");
		var updataarr = updata.split(",");
		var downdataarr = downdata.split(",");
		//alert(datedataarr[0]+" "+datedataarr[6]);
		if(datedataarr == "" && updataarr == "" && downdataarr == "")
		{
			var elements = document.getElementsByClassName("nodata");
			for (var i = 0; i < elements.length; i++) {
				  elements[i].innerHTML = "No Data Found";
				}
			
		}
		else
		{
		data = {
		    type: "bar",
		    data: {
		        labels: [getDateFormat(datedataarr[0]), getDateFormat(datedataarr[1]), getDateFormat(datedataarr[2]), getDateFormat(datedataarr[3]), getDateFormat(datedataarr[4]), getDateFormat(datedataarr[5]), getDateFormat(datedataarr[6])],
		        datasets: [{
		            label: "Upload",
		            barPercentage: 1,
		            barThickness: 25,
		            maxBarThickness: 25,
		            minBarLength: 5,
		            backgroundColor: ["#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77", "#AACE77"],
		            fillColor: "brown",
		            strokeColor: "red",
		            data: [parseFloat(updataarr[0]).toFixed(2), parseFloat(updataarr[1]).toFixed(2), parseFloat(updataarr[2]).toFixed(2), parseFloat(updataarr[3]).toFixed(2), parseFloat(updataarr[4]).toFixed(2), parseFloat(updataarr[5]).toFixed(2), parseFloat(updataarr[6]).toFixed(2)]
		        }, {
		            label: "Download",
		            barPercentage: 1,
		            barThickness: 25,
		            maxBarThickness: 25,
		            minBarLength: 5,
		            backgroundColor: ["#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE", "#66BFEE"],
		            fillColor: "blue",
		            strokeColor: "green",
		            data: [parseFloat(downdataarr[0]).toFixed(2), parseFloat(downdataarr[1]).toFixed(2), parseFloat(downdataarr[2]).toFixed(2), parseFloat(downdataarr[3]).toFixed(2), parseFloat(downdataarr[4]).toFixed(2), parseFloat(downdataarr[5]).toFixed(2), parseFloat(downdataarr[6]).toFixed(2)]
		        }]
		    },
		    options: {
		        scales: {
		            yAxes: [{
		                ticks: {
		                    beginAtZero: true,
							maxTicksLimit: 8,
							
							
		                },
		            }],
					xAxes: [{
		                display: true
		            }]
		        },  
		        title: {
		            display: true,
		            text: charttitle
		        },
		        
		        animation: {
		            duration: 0,
		            onComplete: function () {
		                // render the value of the chart above the bar
		                var ctx = this.chart.ctx;
		                ctx.font = Chart.helpers.fontString(9, 'normal', Chart.defaults.global.defaultFontFamily);
		                ctx.fillStyle = this.chart.config.options.defaultFontColor;
		                ctx.textAlign = 'center';
		                ctx.textBaseline = 'bottom';
		                this.data.datasets.forEach(function (dataset) {
		                    for (var i = 0; i < dataset.data.length; i++) {
		                        var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
		                        ctx.fillText(dataset.data[i], model.x, model.y - 5);
		                    }
		                });
		            }
		        }
		    }
		};
		var myfirstChart = new Chart(ctx, data);
		myfirstChart.render();
		}
	}catch(e)
	{
		alert(e);
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
		//date = day1arr[0]+"/"+getMonthName(day1arr[1]);
		date = day1arr[0]+"/"+day1arr[1];
		var day1arr = datearr[1].split("/");
		//date += "-"+day1arr[0]+"/"+getMonthName(day1arr[1]);
		date += "-"+day1arr[0]+"/"+day1arr[1];
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
$.noConflict();
 function togglePopup(type) {
	 if(type != "cancel")
	 
	    document.getElementById("param_format").value=type;
	    var reportid = document.getElementById("reportId").value; 
        var format=document.getElementById("param_format").value;
		if(reportid=="local_Device-Uptime")
		{
		  var nodesel=document.getElementById("nodesel").value;
		  var timeperiod=document.getElementById("timeperiod").value;
		  if(nodesel != 'single')
		   document.getElementById("param_nodesel").value=nodesel;
		  else
		   document.getElementById("param_nodesel").value="all";
		  if(timeperiod != 'custom')
		  document.getElementById("param_timeperiod").value=timeperiod;
		  else
		  document.getElementById("param_timeperiod").value="custom";
        }
		if(reportid=="local_State-Change")
		{
			var timeperiod=document.getElementById("timeperiod").value;
		    var select=document.getElementById("choose").value;
		    var input=document.getElementById("chooseinput").value;
			
			 document.getElementById("param_nodesel").value=select;
			 document.getElementById("param_input").value=input;
			if(timeperiod != 'custom')
		     document.getElementById("param_timeperiod").value=timeperiod;
		    else
		     document.getElementById("param_timeperiod").value="custom";
		}
	 
    $(".content").toggle();
    
 }
var display = false;
$(function() {
        $( "#fromdate" ).datepicker({
            changeMonth: true,
            changeYear: true,
            maxDate: 0,
			dateFormat: 'dd-mm-yy'
        });
		$( "#todate" ).datepicker({
            changeMonth: true,
            changeYear: true,
            maxDate: 0,
			dateFormat: 'dd-mm-yy'
        });
    });
    function setorderby(orderby,prevorderby,prevordertype)
    {
    	var ordertype = "asc";
    	if(orderby == prevorderby)
    	{
    		if(prevordertype == "asc")
    			ordertype = "desc";
    	}
			var form = document.getElementById("reportform");
    		var input = document.createElement('input');
    	    input.setAttribute('name', 'orderby');
    	    input.setAttribute('value',orderby);
    	    input.setAttribute('type','hidden');
    	    form.appendChild(input);
			
    	    var type = document.createElement('input');
    	    type.setAttribute('name', 'ordertype');
    	    type.setAttribute('value',ordertype);
    	    type.setAttribute('type', 'hidden');
    	    form.appendChild(type);
    	    form.submit();
    }
	function submitForm()
	{
		var form = document.getElementById("reportform");
		var timeperiodobj = document.getElementById("timeperiod");
		var timeperiod = timeperiodobj==null ? "": timeperiodobj.value;
		if(timeperiod == "custom")
		{
			var fromdate=document.getElementById("fromdate").value;
			var todate=document.getElementById("todate").value;
			if(!isValidDateFormat(fromdate)||!isValidDateFormat(todate))
			{
		    	alert("Invalid Date Range!");
				return;
			}
			else if(checkdate(fromdate,todate))
			{
				alert("Date Range Should not be greater than current date!");
				return;
			}
			else if(checkTolessthanFrom(fromdate,todate))
			{
				alert("To Date should not be less than From Date!");
				return;
			}
		}
		form.submit();
	}
	function isEmpty(id,name)
	{
		var ele=document.getElementById(id);
		var val=ele.value;
		if(val == "")
		{
			ele.style.outline= "thin solid red";
			ele.title=name+" should not be empty";
			return false;
		}
		else
		{
			ele.style.outline="initial";
			ele.title="";
			return true;
		}
	}
	function ScheduleReport()
	{ 
		var alertmsg = "";
		var reportid = document.getElementById("reportId").value;
		var format=document.getElementById("param_format").value;
		var email=document.getElementById("param_email");
		var Param_Input=document.getElementById("param_input");
		var valid=ValidateEmail("param_email",true,"Email Address");
		if(!valid) 
        { 
	       if(email.value.trim()=="") 
	       {
  
		     alertmsg += "Email Address should not be empty\n"; 
	       } 
	      else 
	      { 
		    alertmsg += "Email Address is not valid\n"; 
	      } 
        }
		if(reportid=="local_State-Change")
	    {
		 var isempty=isEmpty("param_input","Parameter");
		 if(!isempty) 
	     {
           alertmsg += "Parameter should not be empty\n"; 
	     } 
		}
	    if (alertmsg.trim().length == 0) 
	    {
		   $(".content").toggle();
		   scheduleForm(format);
		}
 	    else 
		{
 		   alert(alertmsg);
           return false;	 	   
 	    } 
		 
	}
	function scheduleForm(format)
	{
		var reportid = document.getElementById("reportId").value;
		var form = document.getElementById("reportform");
		//form.action = "saveschedulereport?reportid="+reportid+"&param_nodesel="+param_nodesel+"&param_timeperiod="+param_timeperiod+"&format="+format+"&email="+email;
		form.action = "saveschedulereport?reportid="+reportid+"&format="+format;
		form.submit();
		//gurukaditam@gmail.com
	}
	function checkdate(date2,date3)
	{
		const date = new Date();
		const yyyy = date.getFullYear();
		let mm = date.getMonth() + 1; // Months start at 0!
		let dd = date.getDate();

		if (dd < 10) dd = '0' + dd;
		if (mm < 10) mm = '0' + mm;

		const date1 = dd + '-' + mm + '-' + yyyy;
		var parts1 = date1.split("-");
		var parts2 = date2.split("-");
		var parts3 = date3.split("-");
		var latest = false;
		if((parseInt(parts1[2]) < parseInt(parts2[2])) || (parseInt(parts1[2]) < parseInt(parts3[2])))
			latest = true;
		else if ((parseInt(parts1[2]) == parseInt(parts2[2])) || (parseInt(parts1[2]) == parseInt(parts3[2]))) {
    	    if ((parseInt(parts1[1]) < parseInt(parts2[1])) || (parseInt(parts1[1]) < parseInt(parts3[1]))) {
    	        latest = true;
    	    } else if ((parseInt(parts1[1]) == parseInt(parts2[1])) || (parseInt(parts1[1]) == parseInt(parts3[1]))) {
    	        if ((parseInt(parts1[0]) < parseInt(parts2[0])) || (parseInt(parts1[0]) < parseInt(parts3[0]))) {
    	            latest = true;
    	        } 
    	    }
    	}
		return latest;
	}
	function checkTolessthanFrom(date2,date3)
	{
		var parts1 = date2.split("-");
		var parts2 = date3.split("-");
		var latest = false;
		if((parseInt(parts1[2]) > parseInt(parts2[2])))
			latest = true;
		else if ((parseInt(parts1[2]) == parseInt(parts2[2]))) {
    	    if ((parseInt(parts1[1]) > parseInt(parts2[1]))) {
    	        latest = true;
    	    } else if ((parseInt(parts1[1]) == parseInt(parts2[1]))) {
    	        if ((parseInt(parts1[0]) > parseInt(parts2[0]))) {
    	            latest = true;
    	        } 
    	    }
    	}
		return latest;
	}
function exportReport(format)
{
	var reportid = document.getElementById("reportId").value;
	var form = document.getElementById("reportform");
	var div_data = document.getElementById("reportdiv").innerHTML;
	var defaction = form.action;
	var timeperiodobj = document.getElementById("timeperiod");
	var timeperiod = timeperiodobj==null ? "": timeperiodobj.value;
	var submit = true;
	  if(reportid != "Data-Usage-Report")
	  {
		  if(timeperiod == "custom")
			{
				var fromdate=document.getElementById("fromdate").value;
				var todate=document.getElementById("todate").value;
				if((!isValidDateFormat(fromdate)||!isValidDateFormat(todate)) || checkdate(fromdate,todate) || checkTolessthanFrom(fromdate,todate)) 
					submit = false;		    	
			}
		  if(submit)
		{
		  form.action = "runreport?reportid="+reportid+"&format="+format;
		  form.submit();
		  form.action = defaction;
	  }
	  }
	  else
	  {
			//const doc = new jsPDF();
			/* var element = document.querySelector("#reportdiv");
			html2pdf().from(element).save("DataUsageReport.pdf"); */
			var type = document.getElementById("type").value;
			if(type == "single")
			{
				var element = document.querySelector("#singlediv");
				var opt = {
					margin: 10,
					html2canvas: {scale: 1, scrollY: 0, logging: true, dpi: 192, letterRendering: true},
					jsPDF: {unit: 'mm', format: 'a2', orientation: 'portrait'}
				};
				html2pdf().set(opt).from(element).save("DataUsageReport.pdf");
			}
			else if(type == "range")
			{
				element = document.querySelector(".duinfo1");
				if(element != null)
				{
					var opt = {
							margin: 10,
							html2canvas: {scale: 2, scrollY: 0, logging: true, dpi: 192, letterRendering: true},
							jsPDF: {unit: 'mm', format: 'a2', orientation: 'portrait'}
						};
					let doc = html2pdf().set(opt).from(element).toPdf();
					<%for(int i=2;i<=slnumranlist.size();i++) {%>
					 element<%=i%> = document.querySelector(".duinfo<%=i%>");
					 doc = doc.get('pdf').then(function (pdf) {
					          pdf.addPage() }
					        ).from(element<%=i%>).toContainer().toCanvas().toPdf();
					<%}%>
					doc.save("DataUsageReport.pdf");
					<%-- <%for(int i=1;i<=slnumlist.size();i++) {%>
						element<%=i%> = document.querySelector(".duinfo<%=i%>");
						alert(element<%=i%>);
						html2pdf().from(element<%=i%>).save("DataUsageReport.pdf");
					<%}%> --%>
				}
			}
			else
			{
				var element=null;
				try
				{
					element = document.querySelector(".duinfo1");
				}
				catch(e){}
				if(element != null)
				{
					var opt = {
							margin: 10,
							html2canvas: {scale: 2, scrollY: 0, logging: true, dpi: 192, letterRendering: true},
							jsPDF: {unit: 'mm', format: 'a2', orientation: 'portrait'}
						};
					let doc = html2pdf().set(opt).from(element).toPdf();
					<%for(int i=2;i<=slnumlist.size();i++) {%>
					 element<%=i%> = document.querySelector(".duinfo<%=i%>");
					 doc = doc.get('pdf').then(function (pdf) {
					          pdf.addPage() }
					        ).from(element<%=i%>).toContainer().toCanvas().toPdf();
					<%}%>
					doc.save("DataUsageReport.pdf");
					<%-- <%for(int i=1;i<=slnumlist.size();i++) {%>
						element<%=i%> = document.querySelector(".duinfo<%=i%>");
						alert(element<%=i%>);
						html2pdf().from(element<%=i%>).save("DataUsageReport.pdf");
					<%}%> --%>
				}
			}
	  }
}
function showOrHideInput(id,submitfrom)
{
	try
	{
		var option = document.getElementById(id).value;
		if(id == "nodesel")
		{
			if(option == "single")
			{
				document.getElementById("choose").style.display = "";
				document.getElementById("chooseinput").style.display = "";
				document.getElementById("singleok").style.display = "";
			}
			else
			{
				document.getElementById("choose").style.display = "none";
				document.getElementById("chooseinput").style.display = "none";
				document.getElementById("choose").selectedIndex ="0";
				document.getElementById("chooseinput").value="";
			}
		}
		else if(id == "timeperiod")
		{
			if(option == "custom")
			{
				document.getElementById("datelbl").style.display = "";
				document.getElementById("fromdate").style.display = "";
				document.getElementById("todate").style.display = "";
				document.getElementById("ok").style.display = "";
				document.getElementById("fromdate").value = "";
				document.getElementById("todate").value = "";
				//document.getElementById("colonlbl").style.display = "";	
			}
			else
			{
				document.getElementById("datelbl").style.display = "none";
				document.getElementById("fromdate").style.display = "none";
				document.getElementById("todate").style.display = "none";
				document.getElementById("fromdate").value = "";
				document.getElementById("todate").value = "";
				//document.getElementById("colonlbl").style.display = "none";						
			}
		}
		else if(id == "type")
		{
			if(option == "single")
			{
				document.getElementById("colon").style.display = "";
				document.getElementById("slnum").style.display = "";
				document.getElementById("slnumber").style.display = "";
				document.getElementById("slnumget").style.display = "";
				document.getElementById("startrange").style.display = "none";
				document.getElementById("endrange").style.display = "none";
			}
			else if(option == "range")
			{
				document.getElementById("colon").style.display = "none";
				document.getElementById("slnum").style.display = "none";
				document.getElementById("slnumber").style.display = "none";
				document.getElementById("slnumget").style.display = "";
				document.getElementById("startrange").style.display = "";
				document.getElementById("endrange").style.display = "";
			}
			else
			{
				document.getElementById("colon").style.display = "none";
				document.getElementById("slnum").style.display = "none";
				document.getElementById("slnumber").style.display = "none";
				document.getElementById("slnumget").style.display = "none";
				document.getElementById("startrange").style.display = "none";
				document.getElementById("endrange").style.display = "none";
			}
		}
		if(submitfrom && option != "custom" && option != "single")
		submitForm();
	}
	catch(e)
	{
		
	}
}
function displayFormats()
{
	if(display)
	{
		display = false;
		document.getElementById("pdficonid").style.display = "none";
		document.getElementById("exceliconid").style.display = "none";
		
	}
	else{
		display = true;
		document.getElementById("pdficonid").style.display = "";
		document.getElementById("exceliconid").style.display = "";
	}
}
function updateChooseInput(input,inputtype)
{
	document.getElementById("chooseinput").value = input;
	document.getElementById("choose").value=inputtype;
}
function showNoDataPopUp()
{
	alert("No data Found");
}
function setDates(fromdate,todate)
{
	document.getElementById("fromdate").value = fromdate;
	document.getElementById("todate").value=todate;
}
function ValidateEmail(id,checkempty,name)
{
 var emailobj=document.getElementById(id);
 var email=emailobj.value;
 var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
  if(email=="")
  {
    if (checkempty) 
		{ 
			emailobj.style.outline = "thin solid red"; 
			emailobj.title = name + " should not be empty"; 
			return false; 
		} 
		else 
		{ 
			emailobj.style.outline = "initial"; 
			emailobj.title = ""; return true; 
		} 	  
  }
  else if(email.match(mailformat))
  {
    emailobj.style.outline = "initial";
	emailobj.title = "";
	return true;
  }
  else
  {
    emailobj.style.outline =  "thin solid red";
	emailobj.title=name+" is not valid";
	return false
  }
}

</script>
</head>

<form method="post" id="reportform"
	action="onlineReport.jsp?reportId=<%=reportId%>">
	<input hidden id="reportId" name="reportId" value="<%=reportId%>" />
	<div  id="reportdiv" class="reportdiv"">
		<div style="padding-bottom: 5px;">
			<div>
				<div class="panel-heading">
					<h3 class="panel-title"><%=reportId.replace("local_","")%></h3>
				</div>
				 
				<!--<div class="panel-body">
                        <div class="form-group">
                            <div class="col-md-1">
							<label> Format : </label>                    
                            </div>
							<div class="col-md-1">
							<select name="format" class="select">
								<option value="PDF" >PDF</option>
								<option value="EXCEL" <%if(format.equals("EXCEL")){%>selected <%}%>>EXCEL</option>
							</select>
							</div>
                        </div>	
			</div> -->
			
				<table class="borderlesstab">
					<tr>
						<td width="90%">
							<table class="borderlesstab innerbtab" style="width: 100%">

								<%
								if (reportId.equals("local_Device-Uptime") || reportId.equals("local_State-Change") || reportId.equals("Data-Usage-Report")) {
								%>
								<tr>
									<%
									if (reportId.equals("local_Device-Uptime")) {
									%>

									<td style="min-width: 50%; max-width: 50%"><label>
											Select </label> <label>:</label><select id="nodesel" name="nodesel"
										class="select" onchange="showOrHideInput('nodesel',true)">
											<option value="all">All</option>
											<option value="up" <%if (nodesel.equals("up")) {%> selected
												<%}%>>Monitored</option>
											<option value="down" <%if (nodesel.equals("down")) {%> selected
												<%}%>>Down</option>
											<option value="single" <%if (nodesel.equals("single")) {%>
												selected <%}%>>Single</option>
									</select> <select id="choose" name="choose" class="select"
										style="display: none; margin-right: 1%; min-width: 110px">
											<option value="slnumber">Serial Number</option>
											<option value="ipaddress"
												<%if (choose.equals("ipaddress")) {%> selected <%}%>>Connected
												IP</option>
									</select> <input type="text" id="chooseinput" name="chooseinput"
										value="<%=chooseinput%>" style="display: none"></input> <input
										id="singleok"
										style="display: none; padding: 1px; max-height: 20px; max-width: 35px;"
										class="btn btn-default" type="button" value="Get"
										onclick="submitForm()"></input></td>

									<%
									} else if (reportId.equals("local_State-Change")) {
									%>
									<td><label> Select </label> <label>:</label><select
										id="choose" name="choose" class="select">
											<option value="slnumber">Serial Number</option>
											<option value="ipaddress"
												<%if (choose.equals("ipaddress")) {%> selected <%}%>>Connected IP</option>
											<option value="nodelabel" <%if (choose.equals("nodelabel")) {%>
												selected <%}%>>Node Name</option>
											<input type="text" id="chooseinput" name="chooseinput"
											style="width: 100px" value="<%=chooseinput%>"></input>
											<input id="get"
											style="padding: 1px; max-height: 20px; max-width: 35px;"
											class="btn btn-default" type="button" value="Get"
											onclick="submitForm()"></input></td>

									<%
									} else if(reportId.equals("Data-Usage-Report"))
									{%>
										<td><label> Type </label> <label>:</label>
										<select id="type" name="type" class="select" onchange="showOrHideInput('type',true)">
										<option value="single">Single</option>
										<option value="range" <%if(type.equals("range")) {%> selected <%} %>>Range</option>
										<option value="all" <%if(type.equals("all")) {%> selected <%} %>>All</option>
										</select>
										<input type="text" id="startrange" name="startrange"
											style="width: 100px" value="<%=startrange%>"></input>
										<input type="text" id="endrange" name="endrange"
											style="width: 100px" value="<%=endrange%>"></input>
										<label id="slnum" name="slnum"> Serial Number </label> <label id="colon" name="colon">:</label>
										<select id="slnumber" name="slnumber" class="select">
										<option></option>
										<%for(String str:slnumlist) {%>
											<option value="<%=str%>" <%if(serialnum !=null && serialnum.equals(str)) {%> selected="selected" <%} %>><%=str%></option>
										<%}%>
										</select>
										<input id="slnumget"
											style="padding: 1px; max-height: 20px; max-width: 35px;"
											class="btn btn-default" type="button" value="Get"
											onclick="submitForm()"></input></td>
									<% }
									if(!reportId.equals("Data-Usage-Report")) {
									%>
									<td><label> Time Period </label> <label>:</label><select
										id="timeperiod" name="timeperiod" class="select"
										onchange="showOrHideInput('timeperiod',true)">
											<option value="today">Today</option>
											<option value="yesterday"
												<%if (timeperiod.equals("yesterday")) {%> selected <%}%>>Yesterday</option>
											<option value="lastweek"
												<%if (timeperiod.equals("lastweek")) {%> selected <%}%>>Last
												Week</option>
											<option value="lastmonth"
												<%if (timeperiod.equals("lastmonth")) {%> selected <%}%>>Last
												Month</option>
											<option value="lastquarter"
												<%if (timeperiod.equals("lastquarter")) {%> selected <%}%>>Last
												Quarter</option>
											<option value="custom" <%if (timeperiod.equals("custom")) {%>
												selected <%}%>>Custom</option>
									</select> <label id="datelbl"> Date Range : </label> </label> <input
										id="fromdate" style="display: none; width: 100px;" type="text"
										value="<%=fromdate%>" class="datepicker" placeholder="dd-mm-yyyy" id="fromdate"
										name="fromdate" class="select" style="margin-right:4%;"></input>
										<input id="todate" style="display: none; width: 100px;"
										type="text" value="<%=todate1%>" class="datepicker" placeholder="dd-mm-yyyy" id="todate"
										name="todate"></input> <input id="ok"
										style="display: none; padding: 1px; max-height: 20px; max-width: 35px;"
										class="btn btn-default" type="button" value="Get"
										onclick="submitForm()"></input></td>
										<%} %>
								</tr>
							</table> <%
 }
 %>
						</td>
						<td width="10%" style="min-width: 10%;">
							<table class="borderlesstab innertab" width="20%">
								<%
								if (reportId.equals("local_Device-Uptime") || reportId.equals("local_State-Change")) {
								%>
								<td>
									<div class="dropdown" id="schicon">
										<img title="Schedule"  src="/imission/images/schedule_icon.png"></img>
										<!--<img src="/imission/images/export.ico" width="22" title="Export"/>-->
										<div class="dropdown-content">
											<a href="javascript:;" id="PDF" onclick="togglePopup('PDF')"><label
												style="font-weight: normal; font-size: 10px; color: red;">PDF</label></a>
											<a href="javascript:;" id="EXCEL"
												onclick="togglePopup('EXCEL')"><label
												style="font-weight: normal; font-size: 10px;">EXCEL</label></a>
										</div>
									</div>
								</td>
								<%}%>
								<td width="70%">
									<div id="expicon">
										<img  onclick="displayFormats()" title="Export"
											src="/imission/images/export_icon.png"></img> <img
											id="pdficonid" style="display: none;" title="PDF"
											src="/imission/images/pdf_icon.png"
											onclick="exportReport('PDF')"></img> 
											<%if(!reportId.equals("Data-Usage-Report")) {%>
											<img id="exceliconid"
											style="display: none;" title="Excel"
											src="/imission/images/excel_icon.png"
											onclick="exportReport('EXCEL')"></img>
											<%} %>
									</div>
								</td>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="content">
			<h2>
				<b><center>Schedule Parameters</b>
				<center>
			</h2>
			<%
			if (reportId.equals("local_Device-Uptime")) {
			%>
			<br>
			<br> <label for="Nodes" style="min-width: 125px;"></label>Nodes
			<label style="min-width: 35px;"></label>:<label
				style="min-width: 8px;"></label><select name="param_nodesel"
				id="param_nodesel" style="min-width: 170px; min-height: 25px;">
				<option value="all">All</option>
				<option value="up">Monitored</option>
				<option value="down">Down</option>
			</select><br>
			<br>
			<%
			}
			if (reportId.equals("local_State-Change")) {
			%>
			<label for="Type" style="min-width: 125px;"></label>Type <label
				style="min-width: 45px;"></label>:<label style="min-width: 8px;"></label><select
				name="param_nodesel" id="param_nodesel"
				style="min-width: 170px; min-height: 25px;">
				<option value="slnumber">Serial Number</option>
				<option value="ipaddress" <%if (choose.equals("ipaddress")) {%>
					selected <%}%>>Connected Ip</option>
				<option value="nodelabel" <%if (choose.equals("nodelabel")) {%>
					selected <%}%>>Node Name</option>
			</select><br>
			<br> <label for="Parameter" style="min-width: 125px;"></label>Parameter
			<label style="min-width: 12px;"></label>:<label
				style="min-width: 8px;"></label><input type="text" id="param_input"
				name="param_input" style="min-width: 170px; min-height: 25px;"
				onfocusout="isEmpty('param_input','Parameter')"></input> <br>
			<br>
			<%}%>
			<label for="Time Period" style="min-width: 125px;"></label>Time
			Period <label>:</label><label></label><select name="param_timeperiod"
				id="param_timeperiod" style="min-width: 170px; min-height: 25px;">
				<option value="today">Today</option>
				<option value="yesterday">Yesterday</option>
				<option value="lastweek">Last Week</option>
				<option value="lastmonth">Last Month</option>
				<option value="lastquarter">Last Quarter</option>
			</select><br>
			<br> <label for="format" style="min-width: 125px;"></label>Format
			<label style="min-width: 32px;"></label>:<label
				style="min-width: 8px;"></label><select name="param_format"
				id="param_format" style="min-width: 170px; min-height: 25px;">
				<option value="PDF">PDF</option>
				<option value="EXCEL">EXCEL</option>
			</select> <br>
			<br> <label for="Email" style="min-width: 125px;"></label>Email
			<label style="min-width: 40px;"></label>:<label
				style="min-width: 8px;"></label><input type="text" id="param_email"
				name="param_email" style="min-width: 170px; min-height: 25px;"
				onfocusout="ValidateEmail('param_email',true,'Email Address')"></input>
			<br>
			<br>
			<div align="center">
				<input type="button" value="Submit" class="btn btn-default"
					onclick="ScheduleReport()"></input> <input type="button"
					value="Cancel" class="btn btn-default"
					onclick="togglePopup('cancel')"></input>
			</div>
		</div>
		<div
			style="overflow-y: scroll; height: 62vh; background-color: white;">
			<table class="table table-bordered" id="tab" width="100%">
				<thead id="sticky">
					<tr>
						<%
						if (reportId.equals("local_Inventory-Report")) {
						%>
						<th><div valign="middle"
								onclick="setorderby('nodelabel','<%=orderby%>','<%=ordertype%>')">
								Node Name</div></th>
						<th><div valign="middle"
								onclick="setorderby('ipaddress','<%=orderby%>','<%=ordertype%>')">
								Connected Ip</div></th>
						<th><div valign="middle"
								onclick="setorderby('slnumber','<%=orderby%>','<%=ordertype%>')">
								Serial Number</div></th>
						<th><div valign="middle"
								onclick="setorderby('fwversion','<%=orderby%>','<%=ordertype%>')">
								Firmware Version</div></th>
						<th><div valign="middle"
								onclick="setorderby('location','<%=orderby%>','<%=ordertype%>')">
								Location</div></th>
						<th><div valign="middle"
								onclick="setorderby('modulename','<%=orderby%>','<%=ordertype%>')">
								Module Name</div></th>
						<th><div valign="middle"
								onclick="setorderby('revision','<%=orderby%>','<%=ordertype%>')">
								Module Revision</div></th>
						<th><div valign="middle"
								onclick="setorderby('createdtime','<%=orderby%>','<%=ordertype%>')">
								Discovered At</div></th>
						<th><div valign="middle"
								onclick="setorderby('status','<%=orderby%>','<%=ordertype%>')">
								Status</div></th>
						<%
						} else if (reportId.equals("local_Device-Uptime")) {
						%>
						<th><div valign="middle"
								onclick="setorderby('nodelabel','<%=orderby%>','<%=ordertype%>')">
								Node Name</div></th>
						<th><div valign="middle"
								onclick="setorderby('ipaddress','<%=orderby%>','<%=ordertype%>')">
								Connected Ip</div></th>
						<th><div valign="middle"
								onclick="setorderby('slnumber','<%=orderby%>','<%=ordertype%>')">
								Serial Number</div></th>
						<th><div valign="middle"
								onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
								Down%</div></th>
						<th><div valign="middle"
								onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
								Down Duration</div></th>
						<th><div valign="middle"
								onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
								Up%</div></th>
						<th><div valign="middle"
								onclick="setorderby('downper','<%=orderby%>','<%=ordertype%>')">
								Up Duration</div></th>
						<%
						} else if (reportId.equals("local_State-Change")) {
						if (chooseinput.trim().length() == 0) {
							orderby = "downtime";
							ordertype = "desc";
						}
						%>
						<th><div valign="middle"
								onclick="setorderby('downtime','<%=orderby%>','<%=ordertype%>')">
								Outage Time</div></th>
						<th><div valign="middle"
								onclick="setorderby('uptime','<%=orderby%>','<%=ordertype%>')">
								Recover Time</div></th>
						<th><div valign="middle">Persistent Time</div></th>
						<%}%>
				    </tr>
				</thead>
				<%
				Connection conn = null;
				Statement stmt = null;
				ResultSet rs = null;
				Session hibsession = null;
				String slnumstr = QueryGenerator.getSlNumberStr(loguser);
				String locstr = QueryGenerator.getLocationsStr(loguser);
				String merged_qry = "prefix.organization ='" + loguser.getOrganization().getName() + "'";
				boolean and_added = false;
				if(!loguser.getRole().equals(UserRole.SUPERADMIN))
				{
					if (slnumstr.length() > 0 ) {
						and_added = true;
						merged_qry += "and ( " + slnumstr;
					}
					if (locstr.length() > 0) {
						if (!and_added)
							merged_qry += "and ";
						else
							merged_qry += "or";
						merged_qry += locstr;
					}
					if (slnumstr.length() > 0 )
						merged_qry += ")";
				}
				try {
					hibsession = HibernateSession.getDBSession();
					conn = ((SessionImpl) hibsession).connection();
					stmt = conn.createStatement();
					String qry = "";
					if (reportId.equals("local_Inventory-Report")) {
						qry = "select nodelabel ,ipaddress, slnumber , fwversion,location, modulename, revision, createdtime, status from  Nodedetails"
						+ " where " + merged_qry.replace("prefix.", "") + " order by " + orderby + " " + ordertype;
						rs = stmt.executeQuery(qry);
						while (rs.next()) {
					nodata = false;
				%>
				<tbody id="rowdata">
					<tr>
						<td><%=rs.getString("nodelabel") == null ? "" : rs.getString("nodelabel")%>
						</td>
						<td><%=rs.getString("ipaddress") != null ?rs.getString("ipaddress"):""%>
						</td>
						<td><%=rs.getString("slnumber") == null ? "" : rs.getString("slnumber")%>
						</td>
						<td><%=rs.getString("fwversion") == null ? "" : rs.getString("fwversion")%>
						</td>
						<td><%=rs.getString("location") == null ? "" : rs.getString("location")%>
						</td>
						<td><%=rs.getString("modulename") == null ? "" : rs.getString("modulename")%>
						</td>
						<td><%=rs.getString("revision") == null ? "" : rs.getString("revision")%>
						</td>
						<td><%=rs.getString("createdtime") == null ? "" : rs.getString("createdtime")%>
						</td>
						<td><%=rs.getString("status") == null ? "" : rs.getString("status")%>
						</td>
					</tr>
				</tbody>
				<%
				}
				} else if (reportId.equals("local_Device-Uptime")) {
					Date date = new Date();
					String curdate_str = DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(date));
					todate = curdate_str.equals(todate) ? DateTimeUtil.getDateTimeStringIn24hFormat(date) : DateTimeUtil.getDateString(DateTimeUtil.getOnlyDate(DateTimeUtil.getNextDate(todate)));
				/* qry = "select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nout.slnumber as slnumber,"
						+ "EXTRACT(EPOCH FROM (to_timestamp('" + todate
						+ "','DD-MM-YYYY') + interval  '1 day'-(case when (nd.createdtime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY')) then (case when nd.createdtime > (to_timestamp('" + todate
						+ "','DD-MM-YYYY')+ interval  '1 day') then (to_timestamp('" + todate
						+ "','DD-MM-YYYY')+ interval  '1 day') else  nd.createdtime end) else to_timestamp ('" + fromdate
						+ "','DD-MM-YYYY') end))) as total_time_sec,"
						+ "sum(EXTRACT(EPOCH FROM (case when (nout.uptime is null or nout.uptime > to_timestamp('" + todate
						+ "','DD-MM-YYYY') + interval  '1 day') then to_timestamp('" + todate
						+ "','DD-MM-YYYY') + interval  '1 day' else nout.uptime end ) - (case when nout.downtime < to_timestamp('"
						+ fromdate + "','DD-MM-YYYY') then to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') else nout.downtime end))) as downper"
						+ " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where "
						+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + statustype + ") and nd." + choose + " like '%"
						+ chooseinput + "%' and nout.downtime < to_date('" + todate
						+ "','DD-MM-YYYY') + interval  '1 day' and (nout.uptime > to_date('" + fromdate
						+ "','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.loopbackip,nd.createdtime"
						+ " union select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"
						+ todate + "','DD-MM-YYYY') + interval  '1 day'-(case when (nd.createdtime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY')) then (case when nd.createdtime > (to_timestamp('" + todate
						+ "','DD-MM-YYYY')+ interval  '1 day') then (to_timestamp('" + todate
						+ "','DD-MM-YYYY')+ interval  '1 day') else  nd.createdtime end) else to_timestamp ('" + fromdate
						+ "','DD-MM-YYYY') end))) as total_time_sec,0 as downper" + " from nodedetails nd where "
						+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + statustype + ") and nd." + choose + " like  '%"
						+ chooseinput + "%'" + " and nd.slnumber not in(select slnumber from m2mnodeoutages where downtime < to_date('"
						+ todate + "','DD-MM-YYYY') + interval  '1 day' and (uptime > to_date('" + fromdate
						+ "','DD-MM-YYYY') or uptime is null))"
						+ " group by nd.slnumber,nd.nodelabel,nd.loopbackip,nd.createdtime order by " + orderby + " " + ordertype; */
				qry = "select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nout.slnumber as slnumber,"
						+ "EXTRACT(EPOCH FROM (to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS')-(case when (nd.createdtime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY')) then (case when nd.createdtime > (to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS')) then (to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS')) else  nd.createdtime end) else to_timestamp ('" + fromdate
						+ "','DD-MM-YYYY') end))) as total_time_sec,"
						+ "sum(EXTRACT(EPOCH FROM (case when (nout.uptime is null or nout.uptime > to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS')) then to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS') else nout.uptime end ) - (case when nout.downtime < to_timestamp('"
						+ fromdate + "','DD-MM-YYYY') then to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') else nout.downtime end))) as downper"
						+ " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where "
						+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + statustype + ") and nd." + choose + " like '%"
						+ chooseinput + "%' and nout.downtime < to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS') and (nout.uptime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime"
						+ " union select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"
						+ todate + "','DD-MM-YYYY HH24:MI:SS')-(case when (nd.createdtime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY')) then (case when nd.createdtime > (to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS')) then (to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS')) else  nd.createdtime end) else to_timestamp ('" + fromdate
						+ "','DD-MM-YYYY') end))) as total_time_sec,0 as downper" + " from nodedetails nd where "
						+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + statustype + ") and nd." + choose + " like  '%"
						+ chooseinput + "%'" + " and nd.slnumber not in(select slnumber from m2mnodeoutages where downtime < to_timestamp('"
						+ todate + "','DD-MM-YYYY HH24:MI:SS') and (uptime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') or uptime is null))"
						+ " group by nd.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime order by " + orderby + " " + ordertype;
				if (timeperiod.equals("today")) {
				SimpleDateFormat sdfs = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
				todate = sdfs.format(Calendar.getInstance().getTime());
				qry = "select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nout.slnumber as slnumber,"
						+ "EXTRACT(EPOCH FROM (to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS') -(case when (nd.createdtime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY')) then nd.createdtime else to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') end))) as total_time_sec,"
						+ "sum(EXTRACT(EPOCH FROM (case when (nout.uptime is null or nout.uptime > to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS')) then to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS') else nout.uptime end ) - (case when nout.downtime < to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') then to_timestamp('" + fromdate + "','DD-MM-YYYY') else nout.downtime end))) as downper"
						+ " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where "
						+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + statustype + ") and nd." + choose + " like '%"
						+ chooseinput + "%' and nout.downtime < to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS') and (nout.uptime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime"
						+ " union select nd.nodelabel as nodelabel,nd.ipaddress as ipaddress,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"
						+ todate + "','DD-MM-YYYY HH24:MI:SS')-(case when (nd.createdtime > to_timestamp('" + fromdate
						+ "','DD-MM-YYYY')) then nd.createdtime else to_timestamp('" + fromdate
						+ "','DD-MM-YYYY') end))) as total_time_sec,0 as downper" + " from nodedetails nd where "
						+ merged_qry.replace("prefix.", "nd.") + " and nd.status in (" + statustype + ") and nd." + choose + " like  '%"
						+ chooseinput + "%'"
						+ " and nd.slnumber not in(select slnumber from m2mnodeoutages where downtime < to_timestamp('" + todate
						+ "','DD-MM-YYYY HH24:MI:SS') and (uptime > to_timestamp('" + fromdate + "','DD-MM-YYYY') or uptime is null))"
						+ " group by nd.slnumber,nd.nodelabel,nd.ipaddress,nd.createdtime order by slnumber";

				/*qry = "select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nout.slnumber as slnumber,"+
				       "EXTRACT(EPOCH FROM (to_timestamp('"+todate+"','DD-MM-YYYY HH24:MI:SS') -to_timestamp('"+fromdate+"','DD-MM-YYYY'))) as total_time_sec,"+ 
				       "sum(EXTRACT(EPOCH FROM (case when (nout.uptime is null or nout.uptime > to_timestamp('"+todate+"','DD-MM-YYYY HH24:MI:SS')) then to_timestamp('"+todate+"','DD-MM-YYYY HH24:MI:SS') else nout.uptime end ) - (case when nout.downtime < to_timestamp('"+fromdate+"','DD-MM-YYYY') then to_timestamp('"+fromdate+"','DD-MM-YYYY') else nout.downtime end))) as tot_down_time_sec"+   
				       " from m2mnodeoutages nout inner join nodedetails nd on nd.slnumber = nout.slnumber where nd.status in ("+nodesel+") and nd."+choose+" like "+input+" and nout.downtime < to_timestamp('"+todate+"','DD-MM-YYYY HH24:MI:SS') and (nout.uptime > to_date('"+fromdate+"','DD-MM-YYYY') or nout.uptime is null) group by nout.slnumber,nd.nodelabel,nd.loopbackip"+ 
				       " union select nd.nodelabel as nodelabel,nd.loopbackip as loopbackip,nd.slnumber as slnumber ,EXTRACT(EPOCH FROM (to_timestamp('"+todate+"','DD-MM-YYYY HH24:MI:SS')-to_timestamp('"+fromdate+"','DD-MM-YYYY'))) as total_time_sec,0 as tot_down_time_sec"+
				       " from nodedetails nd where nd.status in ("+nodesel+") and nd."+choose+" like  "+input+
				       " and nd.slnumber not in(select slnumber from m2mnodeoutages where downtime < to_timestamp('"+todate+"','DD-MM-YYYY HH24:MI:SS') and (uptime > to_date('"+fromdate+"','DD-MM-YYYY') or uptime is null))"+
				       " group by nd.slnumber,nd.nodelabel,nd.loopbackip order by slnumber";*/

				}
				rs = stmt.executeQuery(qry);
				DecimalFormat df = new DecimalFormat("##.##");
				while (rs.next()) {
				nodata = false;
				double tot_sec = rs.getDouble("total_time_sec");
				double downsec = rs.getDouble("downper");
				double downperdou = tot_sec == 0.0 ? 0 : (downsec / tot_sec) * 100;
				double upperdou = tot_sec == 0.0 ? 0 : ((tot_sec - downsec) / tot_sec) * 100;
				String down_per = df.format(downperdou);
				String up_per = df.format(upperdou);
				String down_dur = (long) (downsec / (24 * 3600)) + " days " + (long) (downsec / 3600) % 24 + " hours "
						+ (long) (downsec / 60) % (60) + " min";
				String up_dur = (long) (tot_sec - downsec) / (24 * 3600) + " days " + ((long) (tot_sec - downsec) / 3600) % 24
						+ " hours " + ((long) (tot_sec - downsec) / 60) % (60) + " min";
				%>
				<tbody id="rowdata">
					<tr>
						<td width="14%"><%=rs.getString("nodelabel") == null ? "" : rs.getString("nodelabel")%>
						</td>
						<td width="14%"><%=rs.getString("ipaddress") == null ? "" : rs.getString("ipaddress")%>
						</td>
						<td width="14%"><%=rs.getString("slnumber") == null ? "" : rs.getString("slnumber")%>
						</td>
						<td width="14%">
							<div id="lightgreydiv">
								<div id="reddiv" style="width:<%=downperdou%>%;">
									<div
										style="position: absolute; left: 0; top: 0; text-align: center; width: 100%; color: #000000"><%=down_per%>%
										<div></div>
									</div>
						</td>
						<td width="14%"><%=down_dur%></td>
						<td width="14%">
							<div id="lightgreydiv">
								<div id="greendiv" style="width:<%=upperdou%>%;">
									<div
										style="position: absolute; left: 0; top: 0; text-align: center; width: 100%; color: #000000"><%=up_per%>%
										<div></div>
									</div>
						</td>
						<td width="14%"><%=up_dur%></td>
					</tr>
				</tbody>
				<%
				}
				} else if (reportId.equals("local_State-Change")) {
				String sql = "select mout.severity as severity, mout.slnumber as slnumber, mout.downtime as downtime,mout.uptime as uptime,age(mout.uptime,mout.downtime) as persisttime from m2mnodeoutages mout inner join nodedetails nd on nd.id = mout.nodeid";
				String newinput = "";
				if (chooseinput.trim().length() == 0)
					nodata = false;
				else
				sql += " where nd." + choose + " = '" + chooseinput + "'";

				sql += " and " + merged_qry.replace("prefix.", "nd.") + " and mout.downtime between to_date('" + fromdate
						+ "' ,'DD-MM-YYYY') and to_date('" + todate + "','DD-MM-YYYY') + interval  '1 day' order by " + orderby + " "
						+ ordertype;
			if (chooseinput.trim().length() != 0) {
				rs = stmt.executeQuery(sql);
				while (rs.next()) {
				nodata = false;
				%>
				<tr class="severity-<%=rs.getString("severity")%>">
					<td class="divider bright"><%=rs.getString("downtime") == null ? "" : rs.getString("downtime")%>
					</td>
					<td><%=rs.getString("uptime") == null ? "" : rs.getString("uptime")%>
					</td>
					<td><%=rs.getString("persisttime") == null ? "" : rs.getString("persisttime")%>
					</td>
				</tr>
				<%
				}}
				if (chooseinput.trim().length() == 0) {
				%>
				<script>
                updateChooseInput('<%=newinput%>','slnumber');
                </script>
				<%
				}
				}
				  else if (reportId.equals("Data-Usage-Report")) {
				  	   if(serialnum != null && type.equals("single")) {
							String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + serialnum;
							File jsonfile = new File(slnumpath + File.separator + "Status.json");
							DataUsageDao datadao = new DataUsageDao();
							DataUsage dataobj = datadao.getDataUsage("slnumber", serialnum);
				  	   %>
				  	  
					  <td colspan="3">
					  	<div id="singlediv">
						<div class="titleheader" align="center">Data Usage</div>
						<div class="duinfo">
				  		<span class="slnumclass" align="center" style="" >Serial Number : <%=serialnum %></span>
						<div class="titleheader" align="center">SIM1</div>
						<%if (jsonfile == null || dataobj == null) { %>
							<div id="sim1div" align="center" class="nodata" style="margin-top: 5%;font-size:20px;font-weight: bold;color:red"></div>
						<%} %>
						<table class="innertab" id="sim1charttable" width="100%">
						<tr>
						<td width="33%" style="max-width:33%;">
						<canvas id="sim1day" width="180%" height="140%"></canvas>
						</td >
						<td width="33%" style="max-width:33%">
						<canvas id="sim1week" width="180%" height="140%"></canvas>
						</td>
						<td width="34%" style="max-width:34%">
						<canvas id="sim1month" width="180%" height="140%"></canvas>
						</td>
						</tr>
						</table>
						<div class="titleheader toppaddiv" align="center" id="sim2charttable">SIM2</div>
						<%if (jsonfile == null || dataobj == null) { %>
							<div id="sim2div" align="center" class="nodata" style="margin-top: 5%;font-size:20px;font-weight: bold;color:red"></div>
						<%} %>
						<table class="innertab" id="sim2Charttable" width="100%">
						<tr>
						<td width="33%" style="max-width:33%">
						<canvas id="sim2day" width="180%" height="140%"></canvas>
						</td>
						<td width="33%" style="max-width:33%">
						<canvas id="sim2week" width="180%" height="140%"></canvas>
						</td>
						<td width="34%" style="max-width:34%">
						<canvas id="sim2month" width="180%" height="140%"></canvas>
						</td>
						</tr>
						</table>
						</div>
						</div>
				<% 
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
				   if(dataobj != null)
				   {
					   nodata = false;
					   sim1daydatevalue = dataobj.getS1daydate1()+","+dataobj.getS1daydate2()+","+dataobj.getS1daydate3()+","+dataobj.getS1daydate4()+","+dataobj.getS1daydate5()+","+dataobj.getS2daydate6()+","+dataobj.getS1daydate7();
					   sim1daydownvalue = dataobj.getS1daydownload1()+","+dataobj.getS1daydownload2()+","+dataobj.getS1daydownload3()+","+dataobj.getS1daydownload4()+","+dataobj.getS1daydownload5()+","+dataobj.getS1daydownload6()+","+dataobj.getS1daydownload7();
					   sim1dayupvalue = dataobj.getS1dayupload1()+","+dataobj.getS1dayupload2()+","+dataobj.getS1dayupload3()+","+dataobj.getS1dayupload4()+","+dataobj.getS1dayupload5()+","+dataobj.getS1dayupload6()+","+dataobj.getS1dayupload7();
					   
					   sim1weekdatevalue = dataobj.getS1weekdate1()+","+dataobj.getS1weekdate2()+","+dataobj.getS1weekdate3()+","+dataobj.getS1weekdate4()+","+dataobj.getS1weekdate5()+","+dataobj.getS1weekdate6()+","+dataobj.getS1weekdate7();
					   sim1weekdownvalue = dataobj.getS1weekdownload1()+","+dataobj.getS1weekdownload2()+","+dataobj.getS1weekdownload3()+","+dataobj.getS1weekdownload4()+","+dataobj.getS1weekdownload5()+","+dataobj.getS1weekdownload6()+","+dataobj.getS1weekdownload7();
					   sim1weekupvalue = dataobj.getS1weekupload1()+","+dataobj.getS1weekupload2()+","+dataobj.getS1weekupload3()+","+dataobj.getS1weekupload4()+","+dataobj.getS1weekupload5()+","+dataobj.getS1weekupload6()+","+dataobj.getS1weekupload7();
					   
					   sim1monthdatevalue = dataobj.getS1monthdate1()+","+dataobj.getS1monthdate2()+","+dataobj.getS1monthdate3()+","+dataobj.getS1monthdate4()+","+dataobj.getS1monthdate5()+","+dataobj.getS1monthdate6()+","+dataobj.getS1monthdate7();
					   sim1monthdownvalue = dataobj.getS1monthdownload1()+","+dataobj.getS1monthdownload2()+","+dataobj.getS1monthdownload3()+","+dataobj.getS1monthdownload4()+","+dataobj.getS1monthdownload5()+","+dataobj.getS1monthdownload6()+","+dataobj.getS1monthdownload7();
					   sim1monthupvalue = dataobj.getS1monthupload1()+","+dataobj.getS1monthupload2()+","+dataobj.getS1monthupload3()+","+dataobj.getS1monthupload4()+","+dataobj.getS1monthupload5()+","+dataobj.getS1dayupload6()+","+dataobj.getS1dayupload7();
					   
					   sim2daydatevalue = dataobj.getS2daydate1()+","+dataobj.getS2daydate2()+","+dataobj.getS2daydate3()+","+dataobj.getS2daydate4()+","+dataobj.getS2daydate5()+","+dataobj.getS2daydate6()+","+dataobj.getS2daydate7();
					   sim2daydownvalue = dataobj.getS2daydownload1()+","+dataobj.getS2daydownload2()+","+dataobj.getS2daydownload3()+","+dataobj.getS2daydownload4()+","+dataobj.getS2daydownload5()+","+dataobj.getS2daydownload6()+","+dataobj.getS2daydownload7();
					   sim2dayupvalue = dataobj.getS2dayupload1()+","+dataobj.getS2dayupload2()+","+dataobj.getS2dayupload3()+","+dataobj.getS2dayupload4()+","+dataobj.getS2dayupload5()+","+dataobj.getS2dayupload6()+","+dataobj.getS2dayupload7();
					   
					   sim2weekdatevalue = dataobj.getS2weekdate1()+","+dataobj.getS2weekdate2()+","+dataobj.getS2weekdate3()+","+dataobj.getS2weekdate4()+","+dataobj.getS2weekdate5()+","+dataobj.getS2weekdate6()+","+dataobj.getS2weekdate7();
					   sim2weekdownvalue = dataobj.getS2weekdownload1()+","+dataobj.getS2weekdownload2()+","+dataobj.getS2weekdownload3()+","+dataobj.getS2weekdownload4()+","+dataobj.getS2weekdownload5()+","+dataobj.getS2weekdownload6()+","+dataobj.getS2weekdownload7();
					   sim2weekupvalue = dataobj.getS2weekupload1()+","+dataobj.getS2weekupload2()+","+dataobj.getS2weekupload3()+","+dataobj.getS2weekupload4()+","+dataobj.getS2weekupload5()+","+dataobj.getS2weekupload6()+","+dataobj.getS2weekupload7();
					   
					   sim2monthdatevalue = dataobj.getS1monthdate1()+","+dataobj.getS1monthdate2()+","+dataobj.getS1monthdate3()+","+dataobj.getS1monthdate4()+","+dataobj.getS1monthdate5()+","+dataobj.getS1monthdate6()+","+dataobj.getS1monthdate7();
					   sim2monthdownvalue = dataobj.getS1monthdownload1()+","+dataobj.getS1monthdownload2()+","+dataobj.getS1monthdownload3()+","+dataobj.getS1monthdownload4()+","+dataobj.getS1monthdownload5()+","+dataobj.getS1monthdownload6()+","+dataobj.getS1monthdownload7();
					   sim2monthupvalue = dataobj.getS1monthupload1()+","+dataobj.getS1monthupload2()+","+dataobj.getS1monthupload3()+","+dataobj.getS1monthupload4()+","+dataobj.getS1monthupload5()+","+dataobj.getS1dayupload6()+","+dataobj.getS1dayupload7();
				   }
				%>
				<script type="text/javascript">
				barchart("sim1day","<%=sim1daydatevalue%>","<%=sim1dayupvalue%>","<%=sim1daydownvalue%>","Data Usage Daily(in KB)");
				barchart("sim1week","<%=sim1weekdatevalue%>","<%=sim1weekupvalue%>","<%=sim1weekdownvalue%>","Data Usage Weekly(in MB)");
				barchart("sim1month","<%=sim1monthdatevalue%>","<%=sim1monthupvalue%>","<%=sim1monthdownvalue%>","Data Usage Monthly(in MB)");
				barchart("sim2day","<%=sim2daydatevalue%>","<%=sim2dayupvalue%>","<%=sim2daydownvalue%>","Data Usage Daily(in KB)");
				barchart("sim2week","<%=sim2weekdatevalue%>","<%=sim2weekupvalue%>","<%=sim2weekdownvalue%>","Data Usage Weekly(in MB)");
				barchart("sim2month","<%=sim2monthdatevalue%>","<%=sim2monthupvalue%>","<%=sim2monthdownvalue%>","Data Usage Monthly(in MB)");
				</script>
				</td>
				</div>
				<%}
				  	   else if(type.equals("range")){
				  	   %>
				  		 <td colspan="3">
				  		<%
				  		DataUsageDao datausedao = new DataUsageDao();
				  		List<DataUsage> datalist = new ArrayList<DataUsage>();
				  		if(startrange != null && endrange != null)
				  			datalist = datausedao.getDataUsageList("slnumber", startrange,endrange,loguser);
				  		if(datalist.size()>0)
			  			{
			  			int j=1;%>
					  		<%for(DataUsage data : datalist)
					  		{
								String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + data.getSlnumber();
								File jsonfile = new File(slnumpath + File.separator + "Status.json");
								//DataUsage dataobj = datadao.getDataUsage("slnumber", selslnums);
				  			%>
				  		<div class="duinfo<%=j%>" style="margin-left:2.5%;border:1px solid #006884;width:95%;margin-bottom: 4px;">
				  		<%if(j==1) {%>
				  		<div class="titleheader" align="center" id="rangediv">Data Usage</div>
				  		<%} %>
				  		<span class="slnumclass" align="center" style="" >Serial Number : <%=data.getSlnumber() %></span>
						<div class="titleheader" align="center">SIM1</div>
						<%if (jsonfile == null || data == null) { %>
						<div id="sim1div" align="center" class="nodata" style="margin-top: 5%;font-size:20px;font-weight: bold;color:red"></div>
					<%} %>
						<table class="innertab" id="sim1charttable">
						<tr>
						<td width="33%" style="max-width:33%;">
						<canvas id="sim1day<%=j%>" width="120%" height="100%"></canvas>
						</td >
						<td width="33%" style="max-width:33%"> 
						<canvas id="sim1week<%=j%>" width="120%" height="100%"></canvas>
						</td>
						<td width="34%" style="max-width:34%">
						<canvas id="sim1month<%=j%>" width="120%" height="100%"></canvas>
						</td>
						</tr>
						</table>
						<div class="titleheader toppaddiv" align="center" id="sim2charttable">SIM2</div>
						<%if (jsonfile == null  || data == null) { %>
						<div id="sim2div" align="center" class="nodata" style="margin-top: 5%;font-size:20px;font-weight: bold;color:red"></div>
					<%} %>
						<table class="innertab" id="sim2Charttable">
						<tr>
						<td width="33%" style="max-width:33%">
						<canvas id="sim2day<%=j%>" width="120%" height="100%"></canvas>
						</td>
						<td width="33%" style="max-width:33%">
						<canvas id="sim2week<%=j%>" width="120%" height="100%"></canvas>
						</td>
						<td width="34%" style="max-width:34%">
						<canvas id="sim2month<%=j%>" width="120%" height="100%"></canvas>
						</td>
						</tr>
						</table>
						</div>
				  				<%
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
								
							   if(data != null)
							   {
								   nodata = false;
								   sim1daydatevalue = data.getS1daydate1()+","+data.getS1daydate2()+","+data.getS1daydate3()+","+data.getS1daydate4()+","+data.getS1daydate5()+","+data.getS2daydate6()+","+data.getS1daydate7();
								   sim1daydownvalue = data.getS1daydownload1()+","+data.getS1daydownload2()+","+data.getS1daydownload3()+","+data.getS1daydownload4()+","+data.getS1daydownload5()+","+data.getS1daydownload6()+","+data.getS1daydownload7();
								   sim1dayupvalue = data.getS1dayupload1()+","+data.getS1dayupload2()+","+data.getS1dayupload3()+","+data.getS1dayupload4()+","+data.getS1dayupload5()+","+data.getS1dayupload6()+","+data.getS1dayupload7();
								   
								   sim1weekdatevalue = data.getS1weekdate1()+","+data.getS1weekdate2()+","+data.getS1weekdate3()+","+data.getS1weekdate4()+","+data.getS1weekdate5()+","+data.getS1weekdate6()+","+data.getS1weekdate7();
								   sim1weekdownvalue = data.getS1weekdownload1()+","+data.getS1weekdownload2()+","+data.getS1weekdownload3()+","+data.getS1weekdownload4()+","+data.getS1weekdownload5()+","+data.getS1weekdownload6()+","+data.getS1weekdownload7();
								   sim1weekupvalue = data.getS1weekupload1()+","+data.getS1weekupload2()+","+data.getS1weekupload3()+","+data.getS1weekupload4()+","+data.getS1weekupload5()+","+data.getS1weekupload6()+","+data.getS1weekupload7();
								   
								   sim1monthdatevalue = data.getS1monthdate1()+","+data.getS1monthdate2()+","+data.getS1monthdate3()+","+data.getS1monthdate4()+","+data.getS1monthdate5()+","+data.getS1monthdate6()+","+data.getS1monthdate7();
								   sim1monthdownvalue = data.getS1monthdownload1()+","+data.getS1monthdownload2()+","+data.getS1monthdownload3()+","+data.getS1monthdownload4()+","+data.getS1monthdownload5()+","+data.getS1monthdownload6()+","+data.getS1monthdownload7();
								   sim1monthupvalue = data.getS1monthupload1()+","+data.getS1monthupload2()+","+data.getS1monthupload3()+","+data.getS1monthupload4()+","+data.getS1monthupload5()+","+data.getS1dayupload6()+","+data.getS1dayupload7();
								   
								   sim2daydatevalue = data.getS2daydate1()+","+data.getS2daydate2()+","+data.getS2daydate3()+","+data.getS2daydate4()+","+data.getS2daydate5()+","+data.getS2daydate6()+","+data.getS2daydate7();
								   sim2daydownvalue = data.getS2daydownload1()+","+data.getS2daydownload2()+","+data.getS2daydownload3()+","+data.getS2daydownload4()+","+data.getS2daydownload5()+","+data.getS2daydownload6()+","+data.getS2daydownload7();
								   sim2dayupvalue = data.getS2dayupload1()+","+data.getS2dayupload2()+","+data.getS2dayupload3()+","+data.getS2dayupload4()+","+data.getS2dayupload5()+","+data.getS2dayupload6()+","+data.getS2dayupload7();
								   
								   sim2weekdatevalue = data.getS2weekdate1()+","+data.getS2weekdate2()+","+data.getS2weekdate3()+","+data.getS2weekdate4()+","+data.getS2weekdate5()+","+data.getS2weekdate6()+","+data.getS2weekdate7();
								   sim2weekdownvalue = data.getS2weekdownload1()+","+data.getS2weekdownload2()+","+data.getS2weekdownload3()+","+data.getS2weekdownload4()+","+data.getS2weekdownload5()+","+data.getS2weekdownload6()+","+data.getS2weekdownload7();
								   sim2weekupvalue = data.getS2weekupload1()+","+data.getS2weekupload2()+","+data.getS2weekupload3()+","+data.getS2weekupload4()+","+data.getS2weekupload5()+","+data.getS2weekupload6()+","+data.getS2weekupload7();
								   
								   sim2monthdatevalue = data.getS1monthdate1()+","+data.getS1monthdate2()+","+data.getS1monthdate3()+","+data.getS1monthdate4()+","+data.getS1monthdate5()+","+data.getS1monthdate6()+","+data.getS1monthdate7();
								   sim2monthdownvalue = data.getS1monthdownload1()+","+data.getS1monthdownload2()+","+data.getS1monthdownload3()+","+data.getS1monthdownload4()+","+data.getS1monthdownload5()+","+data.getS1monthdownload6()+","+data.getS1monthdownload7();
								   sim2monthupvalue = data.getS1monthupload1()+","+data.getS1monthupload2()+","+data.getS1monthupload3()+","+data.getS1monthupload4()+","+data.getS1monthupload5()+","+data.getS1dayupload6()+","+data.getS1dayupload7();
							   }
				  			%>
							<script type="text/javascript">
							barchart("sim1day<%=j%>","<%=sim1daydatevalue%>","<%=sim1dayupvalue%>","<%=sim1daydownvalue%>","Data Usage Daily(in KB)");
							barchart("sim1week<%=j%>","<%=sim1weekdatevalue%>","<%=sim1weekupvalue%>","<%=sim1weekdownvalue%>","Data Usage Weekly(in MB)");
							barchart("sim1month<%=j%>","<%=sim1monthdatevalue%>","<%=sim1monthupvalue%>","<%=sim1monthdownvalue%>","Data Usage Monthly(in MB)");
							barchart("sim2day<%=j%>","<%=sim2daydatevalue%>","<%=sim2dayupvalue%>","<%=sim2daydownvalue%>","Data Usage Daily(in KB)");
							barchart("sim2week<%=j%>","<%=sim2weekdatevalue%>","<%=sim2weekupvalue%>","<%=sim2weekdownvalue%>","Data Usage Weekly(in MB)");
							barchart("sim2month<%=j%>","<%=sim2monthdatevalue%>","<%=sim2monthupvalue%>","<%=sim2monthdownvalue%>","Data Usage Monthly(in MB)");
							</script>
				  		<%j++;
				  		}%>
				  		
				  		</td>
				  	   <%}
				 } 
				  	   
				  	  else if(type.equals("all")){%>
			  		 <td colspan="3">
			  		<%
			  		DataUsageDao datadao = new DataUsageDao();
		  			List<DataUsage> datalist = datadao.getDataUsageList("slnumber", loguser);
			  		if(datalist.size()>0)
		  			{
		  			int j=1;
		  			
		  			%>
				  		<%for(DataUsage data : datalist)
				  		{
							String slnumpath = m2mprops.getProperty("tlsconfigspath") + File.separator + data.getSlnumber();
							File jsonfile = new File(slnumpath + File.separator + "Status.json");
							/* DataUsageDao datadao = new DataUsageDao();
							DataUsage dataobj = datadao.getDataUsage("slnumber", totslnums);
							
							*/ 
			  			%>
			  		<div class="duinfo<%=j%>" style="margin-left:2.5%;border:1px solid #006884;width:95%;margin-bottom: 4px;">
			  		<%if(j==1) {%>
			  			<div class="titleheader" align="center" id="alldiv">Data Usage</div>
			  		<%} %>
			  		<span class="slnumclass" align="center" style="" >Serial Number : <%=data.getSlnumber() %></span>
					<div class="titleheader" align="center">SIM1</div>
					<%if (jsonfile == null || data == null) { %>
						<div id="sim1div" align="center" class="nodata" style="margin-top: 5%;font-size:20px;font-weight: bold;color:red"></div>
					<%} %>
					<table class="innertab" id="sim1charttable">
					<tr>
					<td width="33%" style="max-width:33%;">
					<canvas id="sim1day<%=j%>" width="120% " height="100%"></canvas>
					</td>
					<td width="33%" style="max-width:33%">
					<canvas id="sim1week<%=j%>" width="120%" height="100%"></canvas>
					</td>
					<td width="34%" style="max-width:34%">
					<canvas id="sim1month<%=j%>" width="120%" height="100%"></canvas>
					</td>
					</tr>
					</table>
					<div class="titleheader toppaddiv" align="center" id="sim2charttable">SIM2</div>
					<%if (jsonfile == null || data == null) { %>
						<div id="sim2div" align="center" class="nodata" style="margin-top: 5%;font-size:20px;font-weight: bold;color:red"></div>
					<%} %>
					<table class="innertab" id="sim2Charttable">
					<tr>
					<td width="33%" style="max-width:33%">
					<canvas id="sim2day<%=j%>" width="120%" height="100%"></canvas>
					</td>
					<td width="33%" style="max-width:33%">
					<canvas id="sim2week<%=j%>" width="120%" height="100%"></canvas>
					</td>
					<td width="34%" style="max-width:34%">
					<canvas id="sim2month<%=j%>" width="120%" height="100%"></canvas>
					</td>
					</tr>
					</table>
					</div>
			  				<%
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
							
						   if(data != null)
						   {
							   nodata = false;
							   sim1daydatevalue = data.getS1daydate1()+","+data.getS1daydate2()+","+data.getS1daydate3()+","+data.getS1daydate4()+","+data.getS1daydate5()+","+data.getS2daydate6()+","+data.getS1daydate7();
							   sim1daydownvalue = data.getS1daydownload1()+","+data.getS1daydownload2()+","+data.getS1daydownload3()+","+data.getS1daydownload4()+","+data.getS1daydownload5()+","+data.getS1daydownload6()+","+data.getS1daydownload7();
							   sim1dayupvalue = data.getS1dayupload1()+","+data.getS1dayupload2()+","+data.getS1dayupload3()+","+data.getS1dayupload4()+","+data.getS1dayupload5()+","+data.getS1dayupload6()+","+data.getS1dayupload7();
							   
							   sim1weekdatevalue = data.getS1weekdate1()+","+data.getS1weekdate2()+","+data.getS1weekdate3()+","+data.getS1weekdate4()+","+data.getS1weekdate5()+","+data.getS1weekdate6()+","+data.getS1weekdate7();
							   sim1weekdownvalue = data.getS1weekdownload1()+","+data.getS1weekdownload2()+","+data.getS1weekdownload3()+","+data.getS1weekdownload4()+","+data.getS1weekdownload5()+","+data.getS1weekdownload6()+","+data.getS1weekdownload7();
							   sim1weekupvalue = data.getS1weekupload1()+","+data.getS1weekupload2()+","+data.getS1weekupload3()+","+data.getS1weekupload4()+","+data.getS1weekupload5()+","+data.getS1weekupload6()+","+data.getS1weekupload7();
							   
							   sim1monthdatevalue = data.getS1monthdate1()+","+data.getS1monthdate2()+","+data.getS1monthdate3()+","+data.getS1monthdate4()+","+data.getS1monthdate5()+","+data.getS1monthdate6()+","+data.getS1monthdate7();
							   sim1monthdownvalue = data.getS1monthdownload1()+","+data.getS1monthdownload2()+","+data.getS1monthdownload3()+","+data.getS1monthdownload4()+","+data.getS1monthdownload5()+","+data.getS1monthdownload6()+","+data.getS1monthdownload7();
							   sim1monthupvalue = data.getS1monthupload1()+","+data.getS1monthupload2()+","+data.getS1monthupload3()+","+data.getS1monthupload4()+","+data.getS1monthupload5()+","+data.getS1dayupload6()+","+data.getS1dayupload7();
							   
							   sim2daydatevalue = data.getS2daydate1()+","+data.getS2daydate2()+","+data.getS2daydate3()+","+data.getS2daydate4()+","+data.getS2daydate5()+","+data.getS2daydate6()+","+data.getS2daydate7();
							   sim2daydownvalue = data.getS2daydownload1()+","+data.getS2daydownload2()+","+data.getS2daydownload3()+","+data.getS2daydownload4()+","+data.getS2daydownload5()+","+data.getS2daydownload6()+","+data.getS2daydownload7();
							   sim2dayupvalue = data.getS2dayupload1()+","+data.getS2dayupload2()+","+data.getS2dayupload3()+","+data.getS2dayupload4()+","+data.getS2dayupload5()+","+data.getS2dayupload6()+","+data.getS2dayupload7();
							   
							   sim2weekdatevalue = data.getS2weekdate1()+","+data.getS2weekdate2()+","+data.getS2weekdate3()+","+data.getS2weekdate4()+","+data.getS2weekdate5()+","+data.getS2weekdate6()+","+data.getS2weekdate7();
							   sim2weekdownvalue = data.getS2weekdownload1()+","+data.getS2weekdownload2()+","+data.getS2weekdownload3()+","+data.getS2weekdownload4()+","+data.getS2weekdownload5()+","+data.getS2weekdownload6()+","+data.getS2weekdownload7();
							   sim2weekupvalue = data.getS2weekupload1()+","+data.getS2weekupload2()+","+data.getS2weekupload3()+","+data.getS2weekupload4()+","+data.getS2weekupload5()+","+data.getS2weekupload6()+","+data.getS2weekupload7();
							   
							   sim2monthdatevalue = data.getS1monthdate1()+","+data.getS1monthdate2()+","+data.getS1monthdate3()+","+data.getS1monthdate4()+","+data.getS1monthdate5()+","+data.getS1monthdate6()+","+data.getS1monthdate7();
							   sim2monthdownvalue = data.getS1monthdownload1()+","+data.getS1monthdownload2()+","+data.getS1monthdownload3()+","+data.getS1monthdownload4()+","+data.getS1monthdownload5()+","+data.getS1monthdownload6()+","+data.getS1monthdownload7();
							   sim2monthupvalue = data.getS1monthupload1()+","+data.getS1monthupload2()+","+data.getS1monthupload3()+","+data.getS1monthupload4()+","+data.getS1monthupload5()+","+data.getS1dayupload6()+","+data.getS1dayupload7();
						   }%>
						<script type="text/javascript">
						barchart("sim1day<%=j%>","<%=sim1daydatevalue%>","<%=sim1dayupvalue%>","<%=sim1daydownvalue%>","Data Usage Daily(in KB)");
						barchart("sim1week<%=j%>","<%=sim1weekdatevalue%>","<%=sim1weekupvalue%>","<%=sim1weekdownvalue%>","Data Usage Weekly(in MB)");
						barchart("sim1month<%=j%>","<%=sim1monthdatevalue%>","<%=sim1monthupvalue%>","<%=sim1monthdownvalue%>","Data Usage Monthly(in MB)");
						barchart("sim2day<%=j%>","<%=sim2daydatevalue%>","<%=sim2dayupvalue%>","<%=sim2daydownvalue%>","Data Usage Daily(in KB)");
						barchart("sim2week<%=j%>","<%=sim2weekdatevalue%>","<%=sim2weekupvalue%>","<%=sim2weekdownvalue%>","Data Usage Weekly(in MB)");
						barchart("sim2month<%=j%>","<%=sim2monthdatevalue%>","<%=sim2monthupvalue%>","<%=sim2monthdownvalue%>","Data Usage Monthly(in MB)");
						</script>
			  		<%j++;
			  		}%>
			  		</td>
			  	   <%} 
			  } 
			}
				} catch (Exception e) {
				e.printStackTrace();
				} finally {
				if(hibsession != null)
					hibsession.close();
				if (stmt != null)
				stmt.close();
				if (rs != null)
				rs.close();
				}
				%>
			</table>
		</div>
	</div>
	</div>
</form>

<script>
showOrHideInput('nodesel',false);
showOrHideInput('timeperiod',false);
showOrHideInput('type',false);
setDates('<%=fromdate%>','<%=todate1%>');
<%if (nodata) {%>
	showNoDataPopUp();
	document.getElementById("schicon").disabled  = true;
	document.getElementById("expicon").disabled  = true;
<%}%>
</script>
<%!public Vector<String> getdates(String period) {
		String fromdate = "";
		String todate = "";
		Calendar cal = Calendar.getInstance();
		Vector<String> datesvec = new Vector<String>();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		if (period.equals("today")) {
			fromdate = sdf.format(cal.getTime());
			todate = sdf.format(cal.getTime());
		} else if (period.equals("yesterday")) {
			cal.add(Calendar.DATE, -1);
			todate = sdf.format(cal.getTime());
			fromdate = sdf.format(cal.getTime());
		} else if (period.equals("lastweek")) {
			Date date = new Date();
			Calendar c = Calendar.getInstance();
			c.setTime(date);
			int i = c.get(Calendar.DAY_OF_WEEK) - c.getFirstDayOfWeek();
			c.add(Calendar.DATE, -i - 7);
			Date start = c.getTime();
			fromdate = sdf.format(start);
			c.add(Calendar.DATE, 6);
			Date end = c.getTime();
			todate = sdf.format(end);
		} else if (period.equals("lastmonth")) {
			Calendar aCalendar = Calendar.getInstance();
			aCalendar.add(Calendar.MONTH, -1);
			aCalendar.set(Calendar.DATE, 1);
			Date start = aCalendar.getTime();
			fromdate = sdf.format(start);
			aCalendar.set(Calendar.DATE, aCalendar.getActualMaximum(Calendar.DAY_OF_MONTH));
			Date end = aCalendar.getTime();
			todate = sdf.format(end);
		} else if (period.equals("lastquarter")) {
			Calendar stmth = Calendar.getInstance();
			Calendar endmth = Calendar.getInstance();
			int month = stmth.get(Calendar.MONTH) + 1;
			int mths = month % 3 == 0 ? 3 : month % 3;
			stmth.add(Calendar.MONTH, (-2 - mths));
			stmth.set(Calendar.DATE, 1);
			endmth.add(Calendar.MONTH, (-mths));
			endmth.set(Calendar.DATE, stmth.getActualMaximum(Calendar.DAY_OF_MONTH));
			fromdate = sdf.format(stmth.getTime());
			todate = sdf.format(endmth.getTime());
		}
		datesvec.add(fromdate);
		datesvec.add(todate);
		return datesvec;
	}%>
</html>
<jsp:include page="/bootstrap-footer.jsp" flush="false" />
