	function avoidSpace(event) 
	{
		var k = event ? event.which : window.event.keyCode;
        var element = event.target;
        var inputType = element.type;

		if (k == 32) {
			alert("Space is not allowed.");
			return false;
		}   
        if (inputType == "number") {
            if(k<48 || k>57)
            {
                alert("Enter Number Only.");
                return false;
            }
        }
        return true;
	}
			
	function avoidEnter(event) 
	{
		var k = event ? event.which : window.event.keyCode;
		if (k == 13) 
		{
			alert("Enter is not allowed");
			return false;
		}
		return true;
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
	
	function validateIP(id, checkempty, name) 
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
		else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" ) 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name; return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = ""; 
			return true; 
		} 
	}
	
	function validateSubnetMask(id,checkempty,name) 
	{ 
		var ipele=document.getElementById(id); 
		if(ipele.readOnly == true) 
		{ 
			ipele.style.outline="initial"; 
			ipele.title=""; 
			return true; 
		} 
		ipele.value = convertIp(ipele.value);
		var ipformat=/^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0+)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/; 
		var ipaddr = ipele.value; 
		if(ipaddr=="") 
		{ 
			if(checkempty) 
			{ 
				ipele.style.outline ="thin solid red"; 
				ipele.title=name+" should not be empty"; 
				return false; 
			} 
			else 
			{ 
				ipele.style.outline="initial"; 
				ipele.title=""; 
				return true; 
			} 
		} 
		else if(!ipaddr.match(ipformat) || ipaddr == "0.0.0.0") 
		{ 
			ipele.style.outline="thin solid red"; 
			ipele.title="Invalid "+name; 
			return false; 
		} 
		else 
		{ 
			var netmask_arr = ipaddr.split(".");
			for(var i=0;i<netmask_arr.length;i++)
			{
				if(netmask_arr[i].length > 3)
				{
					ipele.style.outline="thin solid red"; 
					ipele.title="Invalid "+name; 
					return false; 
				}
			}
			ipele.style.outline ="initial"; ipele.title = ""; return true; 
		} 
	} 
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
	
	function validateIPByValue(ipaddr,checkempty)
	{ 	
		var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
		if (ipaddr == "") 
		{
			if (checkempty) 
				return false; 
			else 
				return true; 
		} 
		else if (!ipaddr.match(ipformat)) 
			return false;  
		else 
			return true;
	}
	
	function validateIPOrNetwork(id, checkempty, name)
	{
		var ipele = document.getElementById(id);
		var value = ipele.value;
		if (value == "") 
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
	
		if(value.includes("/"))
		{
			var ipsplitarr = value.split("\/");
			ipele.value = convertIp(ipsplitarr[0])+"/"+getPureVal(ipsplitarr[1]);
			ipsplitarr = ipele.value.split("\/");
			var proceed = validateIPByValue(ipsplitarr[0],checkempty);
			
			var valid = false;
			if(proceed && !isNaN(ipsplitarr[1]) && ipsplitarr[1].trim().length > 0)
			{
				if(ipsplitarr[1].length > 2)
					valid = false;
				else
				{
					var network = parseInt(ipsplitarr[1]);
					if(network >= 0 && network<=32)
						valid = true;
					else
						valid = false;
				}
			}
			if(valid)
			{
				ipele.style.outline = "initial"; 
				ipele.title = ""; 
				return true;
			}
			else
			{
				ipele.style.outline = "thin solid red";
				ipele.title = "Invalid " + name; 			
				return false;
			}
		}
		else
			return validateIP(id, checkempty, name);
	}
	
	function validatename(id,checkempty,name)
	{
	    var dnameobj = document.getElementById(id); 
		var nameformat = /^(?!:\/\/)([a-zA-Z0-9-]+\.){0,5}[a-zA-Z0-9-][a-zA-Z0-9-]+\.[a-zA-Z]{2,64}?$/gi; 
		var domainname = dnameobj.value; 
		if (domainname == "") 
		{
			if (checkempty) 
			{ 
				dnameobj.style.outline = "thin solid red"; 
				dnameobj.title = name + " should not be empty"; 
				return false; 
			} 
			else 
			{ 
				dnameobj.style.outline = "initial"; 
				dnameobj.title = ""; 
				return true; 
			} 
		} 
		else if (!domainname.match(nameformat)) 
		{ 
			dnameobj.style.outline = "thin solid red"; 
			dnameobj.title = "Invalid " + name; 
			return false; 
		} 
		else 
		{ 
			dnameobj.style.outline = "initial"; 
			dnameobj.title = ""; 
			return true; 
		} 
	}	
	
	function validateRange(id, checkempty, name) {
		var rele = document.getElementById(id);
		var val = rele.value;
		var max = Number(rele.max);
		var min = Number(rele.min);
		
		if (val.trim() == "") {
			if (checkempty) {
				rele.style.outline =  "thin solid red";
				rele.title = name+" should be integer in the range from "+min+" to "+max;
				return false;
			} else {
				rele.style.outline = "initial";
				rele.title = "";
				return true;
			}
		}
	
		if (!isNaN(val)) {			
			if (val >= min && val <= max) {
				rele.style.outline = "initial";
				rele.title = "";
				return true;
			} else {
				rele.style.outline =  "thin solid red";
				rele.title = name+" should be in the range from "+min+" to "+max;
				return false;
			}
		} else {
			rele.style.outline =  "thin solid red";
			rele.title = name+" should be integer in the range from "+min+" to "+max;
			return false;
		}
	}
	
	function showPassword(id)
	{
		document.getElementById(id).type="text";
	}
	function hidePassword(id)
	{
		document.getElementById(id).type="password";
	}
	function validateIPv6(id, checkempty, name,isCIDR) 
	{ 
		var ipele = document.getElementById(id); 
		if (ipele.readOnly == true) 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = "";
			return true; 
		} 
		var ipformat = /^(?:(?:[a-fA-F\d]{1,4}:){7}(?:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){6}(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){5}(?::(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,2}|:)|(?:[a-fA-F\d]{1,4}:){4}(?:(?::[a-fA-F\d]{1,4}){0,1}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,3}|:)|(?:[a-fA-F\d]{1,4}:){3}(?:(?::[a-fA-F\d]{1,4}){0,2}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,4}|:)|(?:[a-fA-F\d]{1,4}:){2}(?:(?::[a-fA-F\d]{1,4}){0,3}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,5}|:)|(?:[a-fA-F\d]{1,4}:){1}(?:(?::[a-fA-F\d]{1,4}){0,4}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,6}|:)|(?::(?:(?::[a-fA-F\d]{1,4}){0,5}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,7}|:)))(?:%[0-9a-zA-Z]{1,})?$/gm;
		//var suffix="[/]";
		
		var totalipaddr = ipele.value;
	
		var ipaddr="";
		var suffix="";
		var ipaddrarr=""
		
		if(totalipaddr.includes("/") && isCIDR)
		{
			ipaddrarr = totalipaddr.split('/');
		}
		else{
			if(!checkempty &&totalipaddr.trim()=="")
			{
				ipele.style.outline = "initial"; 
				ipele.title = ""; 
				return true; 
			}
			if(isCIDR)
			{
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name; 
			return false;
			}
		}
		if(ipaddrarr.length >2)
		{
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name;
			return false;
		}
		if(isCIDR)
		{
			ipaddr = ipaddrarr[0];
			suffix = ipaddrarr[1];
			if(suffix.length==0 || !isNumber(suffix) || parseInt(suffix) > 128)
			{
				ipele.style.outline = "thin solid red"; 
				ipele.title = "Invalid " + name;
				return false;
			}
		}
		else 
			ipaddr = totalipaddr;
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
	function validateipv6nameandip(id,checkempty,name)
	{
	    var ipele = document.getElementById(id); 
		if (ipele.readOnly == true) 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = "";
			return true; 
		} 
		var ipformat = /^(?:(?:[a-fA-F\d]{1,4}:){7}(?:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){6}(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){5}(?::(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,2}|:)|(?:[a-fA-F\d]{1,4}:){4}(?:(?::[a-fA-F\d]{1,4}){0,1}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,3}|:)|(?:[a-fA-F\d]{1,4}:){3}(?:(?::[a-fA-F\d]{1,4}){0,2}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,4}|:)|(?:[a-fA-F\d]{1,4}:){2}(?:(?::[a-fA-F\d]{1,4}){0,3}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,5}|:)|(?:[a-fA-F\d]{1,4}:){1}(?:(?::[a-fA-F\d]{1,4}){0,4}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,6}|:)|(?::(?:(?::[a-fA-F\d]{1,4}){0,5}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,7}|:)))(?:%[0-9a-zA-Z]{1,})?$/gm;
		var ipaddr = ipele.value; 
		var nameformat = /^(?!:\/\/)([a-zA-Z0-9-]+\.){0,5}[a-zA-Z0-9-][a-zA-Z0-9-]+\.[a-zA-Z]{2,64}?$/gi; 
	
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
		else if ( (!ipaddr.match(ipformat)) && (!ipaddr.match(nameformat)) ) 
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
	function IPv6gatewayvalidate(id, checkempty, name) 
	{ 
		var ipele = document.getElementById(id); 
		if (ipele.readOnly == true) 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = "";
			return true; 
		} 
		var ipformat = /^(?:(?:[a-fA-F\d]{1,4}:){7}(?:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){6}(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){5}(?::(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,2}|:)|(?:[a-fA-F\d]{1,4}:){4}(?:(?::[a-fA-F\d]{1,4}){0,1}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,3}|:)|(?:[a-fA-F\d]{1,4}:){3}(?:(?::[a-fA-F\d]{1,4}){0,2}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,4}|:)|(?:[a-fA-F\d]{1,4}:){2}(?:(?::[a-fA-F\d]{1,4}){0,3}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,5}|:)|(?:[a-fA-F\d]{1,4}:){1}(?:(?::[a-fA-F\d]{1,4}){0,4}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,6}|:)|(?::(?:(?::[a-fA-F\d]{1,4}){0,5}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,7}|:)))(?:%[0-9a-zA-Z]{1,})?$/gm;
		//var suffix="[/]";
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
	function getNetwork(ip,netmask)
	{
		var ip_arr = ip.split(".");
		var netmask_arr = netmask.split(".");
		var network = "";
		for(var i=0;i<ip_arr.length;i++)
		{
			network += ip_arr[i]&netmask_arr[i];
			if(i<ip_arr.length-1)
				network += ".";
		}
		return network;
	}
	function getMask(val)
	{
		var val = val.trim();
		switch(val)
		{
			case "0":
			return "0.0.0.0";
		   case "1":
		   	return "128.0.0.0"; 
		   case "2":
		   	return "192.0.0.0";
		   case "3":
		   	return "224.0.0.0"; 
		   case "4":
		   	return "240.0.0.0"; 
		   case "5":
		   	return "248.0.0.0"; 
		   case "6":
		   	return "252.0.0.0"; 
		   case "7":
		   	return "254.0.0.0"; 
		   case "8":
		   	return "255.0.0.0"; 
		   case "9":
		   	return "255.128.0.0"; 
		   case "10":
		   	return "255.192.0.0"; 
		   case "11":
		   	return "255.224.0.0"; 
		   case "12":
		   	return "255.240.0.0"; 
		   case "13":
		   	return "255.248.0.0";
		   case "14":
		   	return "255.252.0.0";
		   case "15":
		   	return "255.254.0.0";
		   case "16":
		   	return "255.255.0.0";
		   case "17":
		   	return "255.255.128.0";
		   case "18":
		   	return "255.255.192.0";
		   case "19":
		   	return "255.255.224.0";
		   case "20":
		   	return "255.255.240.0"; 
		   case "21":
		   	return "255.255.248.0"; 
		   case "22":
		   	return "255.255.252.0";
		   case "23":
		   	return "255.255.254.0"; 
		   case "24":
		   	return "255.255.255.0";
		   case "25":
		   	return "255.255.255.128"; 
		   case "26":
		   	return "255.255.255.192"; 
		   case "27":
		   	return "255.255.255.224"; 
		   case "28":
		   	return "255.255.255.240"; 
		   case "29":
		   	return "255.255.255.248"; 
		   case "30":
		   	return "255.255.255.252"; 
		   case "31":
		   	return "255.255.255.254"; 
		   case "32":
		   	return "255.255.255.255";	  
		}
		
	}
	function getBroadcast(network,netmask)
	{
		var net_arr = network.split(".");
		var netmask_arr = netmask.split(".");
		var inv_sub_arr=[255-netmask_arr[0],255-netmask_arr[1],255-netmask_arr[2],255-netmask_arr[3]];
		var broadcast="";
		for(var i=0;i<net_arr.length;i++)
		{
			broadcast += net_arr[i]|inv_sub_arr[i];
			if(i<net_arr.length-1)
				broadcast+=".";
		}
		return broadcast; 
	}
	function validateIPOnly(id, checkempty, name) 
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
		else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" ||ipaddr=="0.0.0.0") 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name; return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; ipele.title = "";
			return true; 
		} 
	}
	function validateIpWithAllRange(id,checkempty,name)
	{
		var ipele = document.getElementById(id); 
		if (ipele.readOnly == true) 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = "";
			return true; 
		} 
		var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/; 
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
		else if (!ipaddr.match(ipformat) || ipaddr =="0.0.0.0") 
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name; return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; ipele.title = ""; return true; 
		}
	}
	function isNumber(input)
	{
		var regex=/^[0-9]+$/;
	    if (input.match(regex))
	        return true;
	    else 
	    return false;    
	}
	function isGraterOrEquals(ipv4_1,ipv4_2)
	{
		var ret = false;
		if(ipv4_1 == ipv4_2)
			ret =  true;
		else
		{	
			var ip_arr1 = ipv4_1.split(".");
			var ip_arr2 = ipv4_2.split(".");
			for(var i=0;i<ip_arr1.length;i++)
			{
				for(var j=3;ip_arr1[i].length<3;j--)
					ip_arr1[i] = 0+ip_arr1[i];
			}
			for(var i=0;i<ip_arr2.length;i++)
			{
				for(var j=3;ip_arr2[i].length<3;j--)
						ip_arr2[i] = 0+ip_arr2[i];
			}
			if(parseInt(ip_arr1[0]+ip_arr1[1]+ip_arr1[2]+ip_arr1[3]) >= parseInt(ip_arr2[0]+ip_arr2[1]+ip_arr2[2]+ip_arr2[3]))
			 	ret =  true;
		}
		return ret;
	} 
	function validatedualIP(id,checkempty,name,isCIDR)
	{
		var valid = validateIPOnly(id,checkempty,name);
		if(!valid)
			valid =  validateIPv6(id,checkempty,name,isCIDR);
		return valid;
		
	}
	function isExcludedCharsExists(id)
	{
		var idobj = document.getElementById(id);
		var idval = idobj.value;
		if(idval.includes("\.") || idval.includes("\'") || idval.includes("\"") || idval.includes("\\") || idval.includes("=") || idval.includes("#") || idval.includes(":"))
		{
			idobj.style.outline = "thin solid red";
			return true;
		}
		else
		{
			idobj.style.outline = "initial";
			return false;
		}
	}
	function isExcludedCharsExistsUser(id)
	{
		var idobj = document.getElementById(id);
		var idval = idobj.value;
		if(idval.includes("\.") || idval.includes("\'") || idval.includes("\"") || idval.includes("\\") || idval.includes("\#"))
		{
			idobj.style.outline = "thin solid red";
			return true;
		}
		else
		{
			idobj.style.outline = "initial";
			return false;
		}
	}
	function isExcludedCharsExistsUsername(id)
	{
		var idobj = document.getElementById(id);
		var idval = idobj.value;
		if(idval.includes("\.") || idval.includes("\'") || idval.includes("\"") || idval.includes("\\") || idval.includes("\#") || idval.includes("\=") || idval.includes("\:"))
		{
			idobj.style.outline = "thin solid red";
			return true;
		}
		else
		{
			idobj.style.outline = "initial";
			return false;
		}
	}
	function isValidAlphaNumberic(id)
	{
		var idobj = document.getElementById(id);
		var val = idobj.value;
		var regex=/^([a-zA-Z0-9]+)$/;
		if(val.match(regex))
			{
			idobj.style.outline = "initial";
			return true;
			}
		idobj.style.outline = "thin solid red";
		return false;
	}
	function showErrorBorder(idobj,title)
	{
		idobj.style.outline = "thin solid red";
		idobj.title = title;
	}
	function removeErrorBorder(idobj)
	{
		idobj.style.outline = "initial";
		idobj.title = "";
	}
	function validateMacIP(id, checkempty, name) 
	{ 
		
		var macele = document.getElementById(id); 
		if (macele.readOnly == true) 
		{ 
			macele.style.outline = "initial"; 
			macele.title = "";
			return true; 
		} 
		var macformat = /^([0-9a-fA-F]{2}[:.-]?){5}[0-9a-fA-F]{2}$/;
		//var ipformat =  /^([0-9a-fA-F]{2}[:]){5}([0-9a-fA-F]{2})$/;
		var macaddr = macele.value; 
		if (macaddr == "") 
		{
			if (checkempty) 
			{ 
				macele.style.outline = "thin solid red"; 
				macele.title = name + " should not be empty"; 
				return false; 
			} 
			else 
			{ 
				macele.style.outline = "initial"; 
				macele.title = ""; return true; 
			} 
		} 
		else if (!macaddr.match(macformat) || macaddr == "00:00:00:00:00:00" 
			|| macaddr.toLowerCase()=="ff:ff:ff:ff:ff:ff" || macaddr.split(":").length != 6) //modified
		{ 
			macele.style.outline = "thin solid red"; 
			macele.title = "Invalid " + name; 
			return false; 
		} 
		else 
		{
			macele.style.outline = "initial"; 
			macele.title = ""; 
			return true; 
		} 
	} 
	function setTitle(obj)
	{
		obj.title = obj.value;
	}
	function isIPAddress(address)
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
	}
	function getPureVal(val)
	{
		if(isNaN(val))
		{
			return val;
		}
		try
		{
			if(val.trim().length==0)
				return val.trim();
			val=parseInt(val);
			return val;
		}
		catch(e)
		{
			return val;
		}
	}
	/*function validateStaticRouteIP(id, checkempty, name) 
	{ 
		var ipele = document.getElementById(id); 
		if (ipele.readOnly == true ) 
		{ 
			ipele.style.outline = "initial"; 
			ipele.title = "";
			return true; 
		} 
		var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)$/; 
		var ipaddr = ipele.value;
		if(ipaddr == "0.0.0.0")
		{
			ipele.style.outline = "initial"; 
			ipele.title = ""; 
			return true;
		}
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
		else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255")
		{ 
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name; return false; 
		} 
		else 
		{ 
			ipele.style.outline = "initial"; ipele.title = ""; return true; 
		} 
	}*/
	function validateSubnetMaskStaticRoute(id, checkempty, name)
	{
		var ipele=document.getElementById(id); 
		if(ipele.readOnly == true) 
		{ 
			ipele.style.outline="initial"; 
			ipele.title=""; 
			return true; 
		} 
		ipele.value = convertIp(ipele.value);
		var ipformat=/^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/; 
		var ipaddr = ipele.value; 
		if(ipaddr=="") 
		{ 
			if(checkempty) 
			{ 
				ipele.style.outline ="thin solid red"; 
				ipele.title=name+" should not be empty"; 
				return false; 
			} 
			else 
			{ 
				ipele.style.outline="initial"; 
				ipele.title=""; 
				return true; 
			} 
		} 
		else if(!ipaddr.match(ipformat)) 
		{ 
			ipele.style.outline="thin solid red"; 
			ipele.title="Invalid "+name; 
			return false; 
		} 
		else 
		{ 
			var netmask_arr = ipaddr.split(".");
			for(var i=0;i<netmask_arr.length;i++)
			{
				if(netmask_arr[i].length > 3)
				{
					ipele.style.outline="thin solid red"; 
					ipele.title="Invalid "+name; 
					return false; 
				}
			}
			ipele.style.outline ="initial"; ipele.title = ""; return true; 
		} 
	}
	//added new func by guru sir
	function validateLeaseTime(id, checkempty, name) 
	{ 
		var leasele = document.getElementById(id); 
		leaseval = leasele.value;
		if (leasele.readOnly == true) 
		{ 
			leasele.style.outline = "initial"; 
			leasele.title = "";
			return true; 
		} 			
		 
		if (leaseval == "") 
		{
			if (checkempty) 
			{ 
				leasele.style.outline = "thin solid red"; 
				leasele.title = name + " should not be empty"; 
				return false; 
			} 
			else 
			{ 
				leasele.style.outline = "initial"; 
				leasele.title = "";
				return true; 
			} 
		} 
		else 
		{
			 leaseval = leaseval.toLowerCase().trim();
			 if(leaseval.endsWith("h") && !leaseval.startsWith("h"))
			 {
				leaseval = leaseval.replace("h","");       
				if(isNaN(leaseval))
				{
					leasele.style.outline = "thin solid red"; 
					leasele.title = "Invalid " + name; 
					return false;
				}
				leaseval = parseInt(leaseval);
			    if(leaseval/24 >= 1000)
			    {
			    	leasele.style.outline = "thin solid red"; 
					leasele.title = "Invalid " + name; 
					return false;
			    }
			    
			 }
			 else if(leaseval.endsWith("m") && !leaseval.startsWith("m"))
			 {
				leaseval = leaseval.replace("m","");
				if(isNaN(leaseval))
				{
					leasele.style.outline = "thin solid red"; 
					leasele.title = "Invalid " + name; 
					return false;
				}
				leaseval = parseInt(leaseval);
			    if(leaseval/(24*60) >= 1000)
			    {
			    	leasele.style.outline = "thin solid red"; 
					leasele.title = "Invalid " + name; 
					return false;
			    }
			 	
			 }
			 else if(leaseval.endsWith("s") && !leaseval.startsWith("s"))
			 {

				leaseval = leaseval.replace("s","");
				if(isNaN(leaseval))
				{
					leasele.style.outline = "thin solid red"; 
					leasele.title = "Invalid " + name; 
					return false;
				}
				leaseval = parseInt(leaseval);
			    if(leaseval/(24*60*60) >= 1000)
			    {
			    	leasele.style.outline = "thin solid red"; 
					leasele.title = "Invalid " + name; 
					return false;
			    } 
			 }
			 else
			 {
		 	    leasele.style.outline = "thin solid red"; 
				leasele.title = "Invalid " + name; 
				return false;
			 }
			leasele.style.outline = "initial"; 
			leasele.title = ""; 
			return true;  
		}

	} 
	function validateCIDRNotation(id, checkempty, name)
	{
		
		var ipele = document.getElementById(id);
		var value = ipele.value;
		if (value == "") 
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

		if(value.includes("/"))
		{
			var ipsplitarr = value.split("\/");
			if(ipsplitarr.length != 2)
			{
				ipele.style.outline = "thin solid red";
				ipele.title = "Invalid CIDR format" + name; 			
				return false;
			}
			ipele.value = convertIp(ipsplitarr[0])+"/"+getPureVal(ipsplitarr[1]);
			ipsplitarr = ipele.value.split("\/");
			var proceed = validateIPByValue(ipsplitarr[0],checkempty);
			var valid = false;
			if(proceed && !isNaN(ipsplitarr[1]))
			{
				var network = ipsplitarr[1];
				//////////
				try
				{
					if(network.trim().length > 0 && parseInt(network) >= 0 && parseInt(network)<=32)
						valid = true;
					}
				catch(e)
				{
					return false;
				}
				/////////////
			}
			if(valid)
			{
				ipele.style.outline = "initial"; 
				ipele.title = ""; 
				return true;
			}
			else
			{
				ipele.style.outline = "thin solid red";
				ipele.title = "Invalid " + name; 			
				return false;
			}
		}
		else
		{
			ipele.style.outline = "thin solid red";
			ipele.title = "Invalid CIDR format" + name; 			
			return false;
		}
	}
	//added new function to check password strength
  function checkPwdStrength(inputid,paraid)
   {
      var pwdobj = document.getElementById(inputid);
      var paraobj = document.getElementById(paraid);
      var pwd = pwdobj.value;
      if(pwd.length === 0)
      {
         paraobj.innerHTML = "";
         return;
      }
       var matchedCase = new Array();
        //matchedCase.push("[!@#%_/><,&-=\$\^\*\.\+\?\\]");
        var specmatch = /[!@#$%^&*()_+\-=\[\]{}\\|,.<>\/?~]/;
        matchedCase.push("[A-Z]");      
        matchedCase.push("[0-9]");     
        matchedCase.push("[a-z]");
        matchedCase.push(specmatch);

        var ctr = 0;
        for (var i = 0; i < matchedCase.length; i++) {
            if (pwd.match(matchedCase[i])) {
                ctr++;
            }
            
        }
        var color = "";
        var strength = "";
        switch (ctr) {
            case 0:
            case 1:
            case 2:
                strength = "Weak";
                color = "red";
                break;
            case 3:
                strength = "Fair";
                color = "orange";
                break;
            case 4:
                strength = "Strong";
                color = "green";
                break;
        }
        paraobj.innerHTML = strength;
        paraobj.style.color = color;
        pwdobj.title = ' must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  ,  ' and  ;";
   }
function pwdCheck(id,pagename)
{
   var pwdobj = document.getElementById(id);

   var pwd = pwdobj.value;
   var uc = 0;
   var lc = 0;
   var num = 0;
   var spec = 0;
   var esp = 0;
  if(pagename.match("Snmp"))
	{
		var format = /[!@#$%^&*()_+\-=\[\]{}\\|,.<>\/~]/;
	var eformat = /[;:'"?]/;
	}
	else{
		var format = /[!@#$%^&*()_+\-=\[\]{}\\|,.<>\/?~]/;
		var eformat = /[;:'"]/;
	}
   for(var i=0;i<pwd.length;i++)
   {
      var ch = pwd.charAt(i);

      if(ch.match(/[a-z]/))
         lc++;
      else if(ch.match(/[A-Z]/))
         uc++;
      else if(ch.match(/[0-9]/))
         num++;
      else if(ch.match(format))
         spec ++;
      else if(ch.match(eformat))
         esp++;
      
   }
   if(lc>0&&uc>0&&num>0&&spec>0&&esp==0){
      pwdobj.style.outline='initial';
      return true;
   }
   if(pwd!="")
   		pwdobj.style.outline='thin solid red';
   else
   		pwdobj.style.outline='initial';
   if(pagename.match("Snmp"))
		pwdobj.title = ' must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , ' ,? and  ;";
   else
		pwdobj.title = ' must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , ' and  ;"; 
return false;
}
function validateSubnetMask(id,checkempty,name,acceptzero) 
{ 
	var ipele=document.getElementById(id); 
	if(ipele.readOnly == true) 
	{ 
		ipele.style.outline="initial"; 
		ipele.title=""; 
		return true; 
	}
	if(acceptzero && ipele.value.trim() == "0.0.0.0")
	{

		ipele.style.outline="initial"; 
		ipele.title=""; 
		return true;
	} 
	ipele.value = convertIp(ipele.value);
	var ipformat=/^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$/; 
	var ipaddr = ipele.value; 
	if(ipaddr=="") 
	{ 
		if(checkempty) 
		{ 
			ipele.style.outline ="thin solid red"; 
			ipele.title=name+" should not be empty"; 
			return false; 
		} 
		else 
		{ 
			ipele.style.outline="initial"; 
			ipele.title=""; 
			return true; 
		} 
	} 
	
	else if(!ipaddr.match(ipformat) || ipaddr == "0.0.0.0") 
	{ 
		ipele.style.outline="thin solid red"; 
		ipele.title="Invalid "+name; 
		return false; 
	} 
	else 
	{ 
		var netmask_arr = ipaddr.split(".");
		for(var i=0;i<netmask_arr.length;i++)
		{
			if(netmask_arr[i].length > 3)
			{
				ipele.style.outline="thin solid red"; 
				ipele.title="Invalid "+name; 
				return false; 
			}
		}
		ipele.style.outline ="initial"; ipele.title = ""; return true; 
	} 
} 
//added new fun pallavi 9Feb24

function validateSerialNum(id, checkempty, name)
{
	 var serialele = document.getElementById(id);
	var serialformat = /^(([0-9]{3})-([0-9]{5})-([0-9]{2})|([0-9]{3})-([0-9]{6})-([0-9]{2})|([0-9]{3})-([0-9]{7})-([0-9]{2}))$/;
	var serialno = serialele.value;
	if (serialno == "") {
		if (checkempty) {
			serialele.style.outline = "thin solid red";
			serialele.title = name + " should not be empty"; 
			return false;   
		} else {
			serialele.style.outline = "initial"; 
			serialele.title = ""; return true; 			  
		}
	} else if (!serialno.match(serialformat)) {
		serialele.style.outline = "thin solid red"; 
		serialele.title = "Invalid " + name; 
		return false;	
	} else {
		serialele.style.outline = "initial"; 
		serialele.title = ""; 
		return true;		
	}
}
//added by pallavi to show pwdinfo
function showOrHidePWDInfo(id) 
	{
		var dialog = document.getElementById(id);
		if(dialog.open)
		{
			dialog.close();
			dialog.style.display="none";
		}
		else
		{
			dialog.show();
			dialog.style.display="inline-block";
		}
		return dialog;
	}
	function isNetworkOVerlaped(ip1,subnet1,ip2,subnet2)
{
	netwk1 = getNetwork(ip1,subnet1);
	broadcast1=getBroadcast(netwk1,subnet1);
	
	netwk2 = getNetwork(ip2,subnet2);
	broadcast2=getBroadcast(netwk2,subnet2);
	
	
	if(netwk1==netwk2 && broadcast1==broadcast2)
		return true;
	return false;
}
function isValidDateFormat(dateString) {
	  // Regular expression to match DD-MM-YYYY format
	  var regex = /^\d{2}-\d{2}-\d{4}$/;
	  return regex.test(dateString);
	}