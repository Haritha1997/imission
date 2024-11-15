

function validatenameandip(id, checkempty, name)
{
    var ipele = document.getElementById(id); 
	if (ipele.readOnly == true) 
	{ 
		ipele.style.outline = "initial"; 
		ipele.title = "";
		return true; 
	} 
	ipele.value = convertIp(ipele.value);
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
	var dnsformat= /^((([0-9]{1,3}\.){3}[0-9]{1,3})|(([a-zA-Z0-9]+(([\-]?[a-zA-Z0-9]+)*\.)+)*[a-zA-Z]{2,}))$/;
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
			ipele.title = ""; 
			return true; 
		} 
	}
	else if(isIPAddress(ipaddr))
	{
		if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" || ipaddr == "0.0.0.0") 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name; 
			return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; ipele.title = ""; 
			return true; 
		} 
	}
	else if(!ipaddr.match(dnsformat))
	{
		ipele.style.outline = "thin solid red"; 
		ipele.title = "Invalid " + name; 
		return false;
	}
	else 
	{ 
		ipele.style.outline = "initial"; ipele.title = ""; 
		return true; 
	} 
}		
function selectSourceCustom(id)
{
    var srcinfceselobj = document.getElementById(id);
	var srcintfce = srcinfceselobj.options[srcinfceselobj.selectedIndex].text;
	if(srcintfce == "Custom")
	{
		 srcinfceselobj.style.display = 'none';
		 var srcinfcetxtobj = document.getElementById("interface");
		 srcinfcetxtobj.style.display = 'inline';
		 srcinfcetxtobj.focus();
	}

}
function validOnshowSourceComboBox(id,name)
{
  if(validatenameandip(id,false,name))
  {
    showSourceComboBox(id);
  }
}
function showSourceComboBox(id)
{
  var srcinfcetxtobj = document.getElementById(id);
  var srcinfceselobj = document.getElementById('srcintfce');
  if(srcinfceselobj.length == 7)
		srcinfceselobj.remove(0);
  if(srcinfcetxtobj.value.trim() != "")
  {
      var newOption = document.createElement('option');
        newOption.value=srcinfcetxtobj.value.trim();
        newOption.innerHTML=srcinfcetxtobj.value.trim();	
		srcinfceselobj.add(newOption,0);	
  }
  srcinfcetxtobj.style.display = 'none';
  srcinfceselobj.style.display = 'inline';
  srcinfceselobj.selectedIndex = 0;
}
function deactivateTrack(id)
{
  var activate=document.getElementById(id);
  var trackip=document.getElementById("trackip");
  var srcintfceobj=document.getElementById("srcintfce");
  var srcintf=srcintfceobj.options[srcintfceobj.selectedIndex].text;
  var srccustom=document.getElementById("interface");
  var interval=document.getElementById("interval");
  var retries=document.getElementById("retries");
  if(!activate.checked)
  {
	  trackip.style.outline="initial";
	  interval.style.outline="initial";
	  retries.style.outline="initial";
	  if(srcintf=="Custom")
	  {
		 srccustom.style.outline="initial"; 
	  }
  }
}
/*function isIPAddress(address)
{
  var iparr = address.split(".");
  if(iparr.length != 4)
	  return false;
   for(var i=0;i<iparr.length;i++)
   {
	   for(var j =0;j<iparr[i].length;j++)
	   {
		   if(!Number.isInteger(parseInt(iparr[i].charAt(j))))
			   return false;
	   }
    }
   return true;
}
function convertIp(ipval)
{
	if(!isIPAddress(ipval))
		return ipval;
	try
	{
		var ipaddr = ipval.split(".");
		var ip_val =  parseInt(ipaddr[0])+"."+parseInt(ipaddr[1])+"."+parseInt(ipaddr[2])+"."+parseInt(ipaddr[3]);
		ip_val = ip_val.replaceAll('NaN','');
		return ip_val;
	}
	catch(e)
	{
		return ipval;
	}
}*/