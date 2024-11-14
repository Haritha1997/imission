<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script type="text/javascript">
function gotologin()
{
	if(self==top){
		  location.href="login.jsp";
		}else
		top.location="login.jsp";
	
}
</script>
<title>Insert title here</title>
</head>
<body onload="gotologin()">
	
</body>

</html>