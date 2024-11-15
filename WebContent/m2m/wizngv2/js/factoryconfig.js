function validateMacIP(id, checkempty, name) 
{	
	var ipele = document.getElementById(id); 
	if (ipele.readOnly == true) 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = "";
		return true; 
	} 
	var ipformat = /^([0-9a-fA-F]{2}[:.-]?){5}[0-9a-fA-F]{2}$/;
	var ipaddr = ipele.value; 
	if (ipaddr == "") 
	{
		if (checkempty) 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = name + " should not be empty"; 
			return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = ""; return true; 
		} 
	} 
	else if (!ipaddr.match(ipformat)) 
	{ 
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name; 
		return false; 
	} 
	else 
	{
		ipele.style.outline = "initial"; 
		ipele.title = ""; 
		return true; 
	} 
} 
 function validateSerialNum(id, checkempty, name)
 {
	 var serialele = document.getElementById(id);
	 if(serialele.readOnly == true)
	 {
		 serialele.Style.outline = "initial";
		 serialele.title = "";
		 return true; 
	 }
	  var serialformat = /^([0-9]{3})-([0-9]{5})-([0-9]{2})$/;
	  var serialno = serialele.value;
	  if(serialno == "")
	  {
		  if(checkempty)
		  {
			serialele.style.outline = "thin solid red";
			serialele.title = name + " should not be empty"; 
			return false;   
		  }
		  else
		  {
			serialele.style.outline = "initial"; 
			serialele.title = ""; return true; 
			  
		  }
	}
	else if(!serialno.match(serialformat))
	{
		serialele.style.outline = "thin solid red"; 
		serialele.title = "Invalid " + name; 
		return false;	
	}
	else
	{
		serialele.style.outline = "initial"; 
		serialele.title = ""; 
		return true;
		
	}
 }
