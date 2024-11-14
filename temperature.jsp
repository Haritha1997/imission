<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

 
<html>
<head>
<style>
table .innertab,#devinfotab
{
border : 1px solid  #30D5C8;
background-color: #DDD;
}
th,td
{
padding:5px;
text-align:center;
}
.innertab td,.innertab th
{
	padding:5px;
}
.exceed
{
 background-color: #FF0900;
}
.normal
{
 background-color: #30D5C8;
}
.circle
{
	width:12px;
	height:12px;
	margin-left:45%;
 	border-radius: 25px;
}
</style>
</head>
</html>
<div align="center">
 <div class="titleheader"><h2 style="width:400px;color: #4169E1;background-color: #DDD">Secured Industrial Temperature Management</h2></div>
<table class="innertab" id="devinfotab" width="400px">
<tr style="background-color:#696969;color:white;align:center">
<th>Sno</th>
<th>Parameter</th>
<th>Location</th>
<th>Status</th>
</tr>

<tr>
<td>1</td>
<td>Temperature</td>
<td>Hyderabad</td>
<td><nav class="circle normal"> </nav></td>
</tr>

<tr>
<td>2</td>
<td>Temperature</td>
<td>Chennai</td>
<td><nav class="circle exceed"> </nav></td>
</tr>

<tr>
<td>3</td>
<td>Temperature</td>
<td>Delhi</td>
<td><nav class="circle normal"> </nav></td>
</tr>

<tr>
<td>4</td>
<td>Temperature</td>
<td>Banglore</td>
<td><nav class="circle normal"> </nav></td>
</tr>

<tr>
<td>5</td>
<td>Temperature</td>
<td>Kolkata</td>
<td><nav class="circle exceed"> </nav></td>
</tr>

</table>
</div>
 <jsp:include page="/bootstrap-footer.jsp" flush="false"/>