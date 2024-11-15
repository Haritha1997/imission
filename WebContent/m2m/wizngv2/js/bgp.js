var iprows=1;

function chkIPV4()
{
	var altmsg="";
	for(x=0;x<3;x++)
	{
		if(x==0)
		{
			var obj=document.getElementById(txtBox1[x]);
			var val=obj.value.trim();
			var name=obj.name;
			if(!isNumber(val) || parseInt(val)<1 || parseInt(val)>25)
			{
				obj.style.outline = "thin solid red";
				obj.title = "Invalid " + name;
				altmsg += name +" is not Valid \n";
			}
			else
			{
				obj.style.outline = "initial";
				obj.title = "";
			}	
		}
		else if(x>0)
		{
			var obj1=document.getElementById(txtBox1[x]);
			var val1=obj1.value;
			var name1=obj1.name;
			if(!isNumber(val1)||(parseInt(val1)<0 || parseInt(val1)>65535))
			{
				obj1.style.outline = "thin solid red";
				obj1.title = "Invalid " + name;
				altmsg += name1 +" is not Valid \n";
			}
			else
			{
				obj1.style.outline = "initial";
				obj1.title = "";
			}
		}
	}
	for(x=3;x<txtBox1.length;x++)
	{
		var obj=document.getElementById(txtBox1[x]);
		var val=obj.value.trim();
		var name=obj.name;
		var ret=validateIP(txtBox1[x],true,'Inside IP');
		if (!ret) 
		{
			if(val == "") 
			altmsg += "Inside IP should not be empty.\n";
			else 
			altmsg += "Invalid IP (" + val + ").\n";
		}
	}
	if(altmsg=="")
		return true;
	else
	{
		//alert(altmsg);
		return false;
	}
}

function chkFunc()
{
	return chkIPV4();
}

function isNumber(n) 
{ 
	return /^[0-9]+$/.test(n);
}

function validateIP(id,checkempty,name) 
{
	var ipele = document.getElementById(id);
	var ipformat = /^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$/;
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
	else if (!ipaddr.match(ipformat) ||  ipaddr == "255.255.255.255" || ipaddr == "0.0.0.0") 
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
function isEmpty(id,name)
{
	var ele=document.getElementById(id);
	var val=ele.value;
	if(val == "")
	{
		ele.style.outline= "thin solid red";
		ele.title=name+" should be empty";
		return false;
	}
	else
	{
		ele.style.outline="initial";
		ele.title="";
		return true;
	}	
}
function validateRange(id,chkempty,name)
{	
	var obj = document.getElementById(id);
	var val = obj.value;
	var min = obj.min;
	var max = obj.max;
	if(chkempty && val.trim().length == 0)
		return false;		
	if((parseInt(val) < min) || (parseInt(val) > max))
	{
		return false;
	}
	return true;
}
function validateBGP() 
{
	var alertmsg = "";
	var rem_as = document.getElementById("rmt_as");
	var rem_as = document.getElementById("rmt_as");
	var rem_addrs = document.getElementById("rmt_addr");
	var rem_pur = document.getElementById("rmt_pur");
	var bgp_mhub = document.getElementById("bgp_hub");
	var descrn = document.getElementById("desc");
	var paswrd = document.getElementById("pwd");
	var valid=validateIP('rmt_as',true,'Remote As');
	
	if(!valid) {
		if (rem_as.value.trim() == "") 
			alertmsg += "Remote End Point IPAddress should not be empty\n";
		else 
			alertmsg += "Remote End Point IPAddress is not valid\n";
	}
	valid=validateIP('rmt_addr',true,'Remote Address');
	if(!valid) {
		if (rem_addrs.value.trim() == "") 
			alertmsg += "Remote End Point IPAddress should not be empty\n";
		else 
			alertmsg += "Remote End Point IPAddress is not valid\n";
	}
	valid = validateRange("rmt_pur",true,"Remote Pur");
	if (!valid) {
		if (rem_pur.value.trim() == "") 
			alertmsg += "MTU should not be empty\n";
		else 
			alertmsg += "MTU is not valid\n";
	}valid = validateRange("bgp_hub",true,"EBGP Multihub");
	if (!valid) {
		if (bgp_mhub.value.trim() == "") 
			alertmsg += "MTU should not be empty\n";
		else 
			alertmsg += "MTU is not valid\n";
	}				
}

