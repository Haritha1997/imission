	function showDivision(divname,sellist)
	{
		var divname_arr = ["ipconfigpage","dhcp_serverpage"];
		var lanconfiguration = document.getElementsByClassName("lanconfiguration");
		for(var j=0;j<lanconfiguration.length;j++)
			lanconfiguration[j].id="";
		if(sellist == null)
			lanconfiguration[0].id="hilightthis";
		sellist.id= "hilightthis";
		for(var i=0;i<divname_arr.length;i++)
		{
			if(divname == divname_arr[i])
			{
				document.getElementById(divname_arr[i]).style.display = "inline";
			}
			else
				document.getElementById(divname_arr[i]).style.display = "none";
		}
	}
	
	
	function validateIPv6(id, checkempty, name) 
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
		if(totalipaddr.includes("/"))
		{
			ipaddrarr = totalipaddr.split('/');
		}
		else
		{
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name; 
			return false;
		}
		if(ipaddrarr.length >2)
		{
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name;
			return false;
		}
		ipaddr = ipaddrarr[0];
		suffix = ipaddrarr[1];
		if(suffix.length==0)
		{
			ipele.style.outline = "thin solid red"; 
			ipele.title = "Invalid " + name;
			return false;
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
	
	
	/*************************************************/
	
	function validateIPv6gateway(id, checkempty, name) 
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
	/************************************/
	
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
	
	/*************************************************/
	
	
	
	
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
	function adjtabIPV4andSubnetFirstcolumn(tabname,setIPV4,setSubnet)
	{
		var table = document.getElementById(tabname);
		var rows = table.rows;
		var index = 0;
		if(tabname == "ipconfig")
			index = 2;
		for(var i=index;i<rows.length;i++)
		{
			if(i==index)
			{
				rows[i].cells[0].childNodes[0].innerHTML = setIPV4;
				rows[i].cells[0].childNodes[2].innerHTML = setSubnet;
		    }
			else
			{
				rows[i].cells[0].childNodes[0].innerHTML = "";
				rows[i].cells[0].childNodes[2].innerHTML = "";
			}
		}
	}
	function deleteRow(rowid)
	{
		var ele = document.getElementById("laniprow"+rowid);
		$('table#ipconfig tr#laniprow'+rowid).remove();
	}
	
	function IPV6avoidSpace(event)
	{
		var k = event ? event.which : window.event.keyCode;
		if (k == 32) 
		{
			alert("space is not allowed");
			return false;
		}
		else if( (!(k>64 && k<71)) &&(!(k>96 && k<103)) && (!(k>46 && k<59)) )
		{
			alert("Entered character not valid in IPV6");
			return false;
		}
		return true;
		
	}
		
	function addIPRowAndChangeIcon(rowid)
	{
		var table = document.getElementById("ipconfig");
		if(table.rows.length >=7)
		{
			alert("Max 5 Entries are allowed");
			return;
		}
		iprows++;
		var remove=document.getElementById("remove"+rowid);
		var add=document.getElementById("add"+rowid);
		if(add != null)
		add.style.display="none";
		if(remove != null)
		remove.style.display ="inline";
		$("#ipconfig").append("<tr id='laniprow"+iprows+"'><td><div>IPv4 Address</div><br/><div>Subnet Address</div></td><td><div><input type='text' class='text' id='lanip"+iprows+"' name='lanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block; position:relative; left:3px;' onfocusout=\"validateIP('lanip"+iprows+"',true,'IPv4 Address')\"></input></div><div style='margin-left:155px'><i class='fa fa-plus' id='add"+iprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addIPRowAndChangeIcon("+iprows+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'></i></div><div><input type='text' class='text' id='lansn"+iprows+"' name='lansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block; position:relative; left:3px;' onfocusout=\"validateSubnetMask('lansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");
	
		//$("#ipconfig").append("<tr id='laniprow"+iprows+"'><td><div>IPv4 Address</div><br/><div>Subnet Address</div></td><td><div><input type='text' class='text' id='lanip"+iprows+"' name='lanip"+iprows+"' onkeypress='return avoidSpace(event);' style='display:inline block;' maxlength='15' onfocusout=\"validateIPOnly('lanip"+iprows+"',true,'IPv4 Address')\"></input></div><div style='margin-left:155px'><i class='fa fa-plus' id='add"+iprows+"' style='font-size:10px; margin-left:5px;color:green;display:inline block' onclick='addIPRowAndChangeIcon("+iprows+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='remove"+iprows+"' onclick='deletetableRow("+iprows+")'></i></div><div><input type='text' class='text' id='lansn"+iprows+"' name='lansn"+iprows+"' onkeypress='return avoidSpace(event)' style='display:inline block' maxlength='15' onfocusout=\"validateSubnetMask('lansn"+iprows+"',true,'Subnet Address')\"></input><input hidden id='row"+iprows+"' value='"+iprows+"'></div></td></tr>");
	
		document.getElementById("laniprows").value = iprows;
		adjtabIPV4andSubnetFirstcolumn('ipconfig','IPv4 Address','Subnet Address');
	}
	
	function deletetableRow(row)
	{
		deleteRow(row);
		findLastRowAndDisplayRemoveIcon();
		adjtabIPV4andSubnetFirstcolumn('ipconfig','IPv4 Address','Subnet Address');
	}
	function findLastRowAndDisplayRemoveIcon()
	{
		var table = document.getElementById("ipconfig");
		var lastrow = table.rows[table.rows.length-1];
		var addobj = lastrow.cells[1].childNodes[1].childNodes[0];
		var removeobj = lastrow.cells[1].childNodes[1].childNodes[1];
		addobj.style.display="inline";
		if(table.rows.length > 3)
			removeobj.style.display="inline";
		else if(table.rows.length == 3)
		removeobj.style.display="none";
	}
	
	function fillIProw(rowid,ipaddress,subnet)
	{
		document.getElementById('lanip'+rowid).value=ipaddress;
		document.getElementById('lansn'+rowid).value=subnet;
	}
	//Custom DNS Server
	function adjtabCustomDNSFirstcolumn(tabname,setname)
	{
		var table = document.getElementById(tabname);
		var rows = table.rows;
		var index = 0;
		if(tabname == "ipconfig1")
			index = 4;
		for(var i=index;i<rows.length;i++)
		{
			if(i==index)
			{
				rows[i].cells[0].childNodes[0].innerHTML = setname;
		    }
			else
			{
				rows[i].cells[0].childNodes[0].innerHTML = "";
			}
		}
	}
	
	function deleteCustomDNSRow(rowid)
	{
		var ele = document.getElementById("cusdns"+rowid);
		$('table#ipconfig1 tr#cusdns'+rowid).remove();
		
	}
	function deleteCustomDNStableRow(row)
	{
		deleteCustomDNSRow(row);
		findCustomDNSLastRowAndDisplayRemoveIcon();
		adjtabCustomDNSFirstcolumn('ipconfig1','Custom DNS Server');
	}
	
	function addCustomDNSRowAndChangeIcon(rowid)
	{
	
		var table = document.getElementById("ipconfig1");
		if(table.rows.length >=9)
		{
			alert("Max 5 rows are allowed");
			return;
		}
		customdns++;
		var remove=document.getElementById("removedns"+rowid);
		var add=document.getElementById("adddns"+rowid);
		if(add != null)
		add.style.display="none";
		if(remove != null)
		remove.style.display ="inline";
		//$("#ipconfig1").append("<tr id='cusdns"+customdns+"'> <td><div>Custom DNS Server</div></td>   <td><div><input type='text' class='text' id='customdns"+customdns+"' name='customdns"+customdns+"' onkeypress='return avoidSpace(event);' style='display:inline block;' onfocusout=\"validateIP('cusdns"+customdns+"',true,'Custom DNS Server')\"></input>					<label class='add' id='adddns"+customdns+"' style='font-size:15px;'  onclick='addCustomDNSRowAndChangeIcon("+customdns+")'>+</label>	<label class='remove' style='display:inline; font-size:15px; color:red;' id='removedns"+customdns+"' onclick='deleteCustomDNStableRow("+customdns+")'>x</label>         			<input hidden id='row"+customdns+"' value='"+customdns+"'></div></td></tr>");
		//new
		/* new line for MouseClick and Validation of both IPv4 and IPV6 Custom DNS on 24/08/22*/
		//$("#ipconfig1").append("<tr id='cusdns"+customdns+"'><td><div>Custom DNS Server</div></td><td><div><input type='text' class='text' placeholder= 'EnterIPv4orIPV6Address'id='servers"+customdns+"' name='servers"+customdns+"'  onkeypress='return avoidSpace(event);' style='display:inline block;' onmouseover=\"setTitle(this)\"  onfocusout=\"validatedualIP('servers"+customdns+"',false,'Custom DNS Server',false)\"></input><label class='add' id='adddns"+customdns+"' style='font-size:15px;'  onclick='addCustomDNSRowAndChangeIcon("+customdns+")'>+</label><label class='remove' style='display:inline; font-size:15px;' id='removedns"+customdns+"' onclick='deleteCustomDNStableRow("+customdns+")'>x</label><input hidden id='row"+customdns+"' value='"+customdns+"'></div></td></tr>");
		$("#ipconfig1").append("<tr id='cusdns"+customdns+"'><td min-width=\"200\"><div>Custom DNS Server</div></td><td width=\"195\"><div><input type='text' class='text' style='position: relative; left: 3px;display:inline block' placeholder='EnterIPv4orIPV6Address' id='servers"+customdns+"' name='servers"+customdns+"' style='display:inline block;' onmouseover=\"setTitle(this)\" onkeypress='return avoidSpace(event);' onfocusout=\"validatedualIP('servers"+customdns+"',false,'Custom DNS Server',false)\"></input><i class='fa fa-plus' id='adddns"+customdns+"' style='font-size:10px; margin-left:7px;color:green;display:inline block'; onclick='addCustomDNSRowAndChangeIcon("+customdns+")'></i><i class='fa fa-close' style='display:inline;font-size:10px; margin-left:5px; color:red;' id='removedns"+customdns+"' onclick='deleteCustomDNStableRow("+customdns+")'></i><input hidden id='row"+customdns+"' value='"+customdns+"'></div></td></tr>");
	
		document.getElementById("dnsrows").value = customdns;
		adjtabCustomDNSFirstcolumn('ipconfig1','Custom DNS Server');
	}
	
	function findCustomDNSLastRowAndDisplayRemoveIcon()
	{
		var table = document.getElementById("ipconfig1");
		var lastrow = table.rows[table.rows.length-1];
		var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
		var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
		addobj.style.display="inline";
		if(table.rows.length > 5)
			removeobj.style.display="inline";
		else if(table.rows.length == 5)
		removeobj.style.display="none";
	}
	function fillCustomDNSRow(rowid,dnsserver)
	{
		
		document.getElementById('servers'+rowid).value=dnsserver;
		
	}
	function IPv6Assignment(id,txtval)
	{
	
	  var ipv6aslselobj=document.getElementById(id);
	  var ipv6asgnmnt=ipv6aslselobj.options[ipv6aslselobj.selectedIndex].text;
	  var ipv6asghnt=document.getElementById("ipv6hint");
	  var ipv6addrs=document.getElementById("ipv6address");
	  var ipv6gw=document.getElementById("ipv6gateway");
	  if(ipv6asgnmnt=="disable")
	  {
		  ipv6asghnt.style.display="none";
	      ipv6addrs.style.display="";
	      ipv6gw.style.display="";
	  }
	  else if(ipv6asgnmnt=="64")
	  {
		  
		 ipv6asghnt.style.display="";
	     ipv6addrs.style.display="none";
	     ipv6gw.style.display="none";	 
	  }
	  else if((ipv6asgnmnt=="custom"))
	  {
		    ipv6aslselobj.style.display = 'none';
			ipv6asghnt.style.display="";
	        ipv6addrs.style.display="none";
	        ipv6gw.style.display="none";
			var ipv6agmttxtobj = document.getElementById("ipv6asgmnt");
			ipv6agmttxtobj.style.display = 'inline';
			ipv6agmttxtobj.value = txtval;
			ipv6agmttxtobj.focus();
	   }
	}
	function validOnshowLanComboBox(id,name,id1)
	{
	  var ipv6addrs=document.getElementById("ipv6address");
	  var ipv6gw=document.getElementById("ipv6gateway");
	  var ipv6asghnt=document.getElementById("ipv6hint");
	  var ipv6agntxtobj = document.getElementById(id);
	  var ipv6agnselobj = document.getElementById('ipv6asl');
	  var ipv6agntxt=ipv6agntxtobj.value;
	  document.getElementById(id1).value=ipv6agntxtobj.value;
	  if(ipv6agntxtobj.value.trim() != "")
	  {
		  if(ipv6agntxtobj.value>64)
		  {
			  ipv6agntxtobj.style.outline="thin solid red";
			  ipv6agntxtobj.title = "invalid "+name;
			  return false;
		  }
		  else
		  {
		  	  ipv6agntxtobj.style.outline="initial";
			  ipv6agntxtobj.title = "";
			  return true;
		  }
	      
	  }
	  ipv6agntxtobj.style.display = 'none';
	  ipv6agnselobj.style.display = 'inline';
	  ipv6addrs.style.display="";
	  ipv6gw.style.display="";
	  ipv6asghnt.style.display="none";
	  ipv6agnselobj.selectedIndex = 0;
	 // (ipv6agnselobj.options[ipv6agnselobj.selectedIndex].text=="disable")?ipv6agnselobj.selectedIndex = 0:(ipv6agnselobj.options[ipv6agnselobj.selectedIndex].text=="64")?ipv6agnselobj.selectedIndex = 1:(ipv6agnselobj.options[ipv6agnselobj.selectedIndex].text=="custom")?ipv6agnselobj.selectedIndex = 2:ipv6agnselobj.selectedIndex=3;
	}
	function deactivatedhcp(id)
	{
		var dhcpactvn=document.getElementById(id);
	    var dhcptable1=document.getElementById("dhcpserver");
		if(!dhcpactvn.checked)
		{
			dhcptable1.style.display="none";
		}
		else
		{
			dhcptable1.style.display="";
		}
	}
	//Announced DNS Server
	function adjtabAncdDNSServerFirstcolumn(tabname,setname)
	{
		var table = document.getElementById(tabname);
		var rows = table.rows;
		var index = 0;
		if(tabname == "dhcpserver")
			index = 5;
		for(var i=index;i<rows.length;i++)
		{
			if(i==index)
			{
				rows[i].cells[0].childNodes[0].innerHTML = setname;
		    }
			else
			{
				rows[i].cells[0].childNodes[0].innerHTML = "";
			}
		}
	}
	function deleteAncdDNSServerRow(rowid)
	{
		var ele = document.getElementById("ancdns"+rowid);
		$('table#dhcpserver tr#ancdns'+rowid).remove();
		
	}
	function deleteAncdDNSServertableRow(row)
	{
		deleteAncdDNSServerRow(row);
		findAncdDNSServerLastRowAndDisplayRemoveIcon();
		adjtabAncdDNSServerFirstcolumn('dhcpserver','Announced DNS Servers');
	}
	function addAncdDNSServersRowAndChangeIcon(rowid)
	{
		var table = document.getElementById("dhcpserver");
		if(table.rows.length >=10)
		{
			
			alert("Max 5 rows are allowed");
			return;
		}
		ancdnsservers++;
		var remove=document.getElementById("removednsserver"+rowid);
		var add=document.getElementById("adddnsserver"+rowid);
		if(add != null)
		add.style.display="none";
		if(remove != null)
		remove.style.display ="inline";
		$("#dhcpserver").append("<tr id='ancdns"+ancdnsservers+"'><td><div>Announced DNS Servers</div></td><td><div><input type='text' class='text' id='ip6dns"+ancdnsservers+"' name='ip6dns"+ancdnsservers+"' onkeypress='return avoidSpace(event);' style='display:inline block;'onfocusout=\"validateIP('ip6dns"+ancdnsservers+"',true,'Announced DNS Servers')\"></input><label class='add' id='adddnsserver"+ancdnsservers+"' style='font-size:15px;'  onclick='addAncdDNSServersRowAndChangeIcon("+ancdnsservers+")'>+</label><label class='remove' style='display:inline; font-size:15px;' id='removednsserver"+ancdnsservers+"' onclick='deleteAncdDNSServertableRow("+ancdnsservers+")'>x</label><input hidden id='row"+ancdnsservers+"' value='"+ancdnsservers+"'></div></td></tr>");
		adjtabAncdDNSServerFirstcolumn('dhcpserver','Announced DNS Servers');
	}
	function findAncdDNSServerLastRowAndDisplayRemoveIcon()
	{
		var table = document.getElementById("dhcpserver");
		var lastrow = table.rows[table.rows.length-1];
		var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
		var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
		addobj.style.display="inline";
		if(table.rows.length > 6)
			removeobj.style.display="inline";
		else if(table.rows.length ==6)
		removeobj.style.display="none";
	}
	function fillAncdDNSServerRow(rowid,anouncednsservers)
	{
		document.getElementById('ip6dns'+rowid).value=anouncednsservers;
	}
	//Announced DNS Domain
	//deleted these functions bcz those are not required.......
	/*function adjtabAncdDNSDomainFirstcolumn(tabname,setname)
	{
		var table = document.getElementById(tabname);
		var rows = table.rows;
		var index = 0;
		if(tabname == "dhcpserver1")
			index = 0;
		for(var i=index;i<rows.length;i++)
		{
			if(i==index)
			{
				rows[i].cells[0].childNodes[0].innerHTML = setname;
		    }
			else
			{
				rows[i].cells[0].childNodes[0].innerHTML = "";
			}
		}
	}
	function deleteAncdDNSDomainRow(rowid)
	{
		var ele = document.getElementById("ancdnsdomain"+rowid);
		$('table#dhcpserver1 tr#ancdnsdomain'+rowid).remove();
		
	}
	function deleteAncdDNSDomaintableRow(row)
	{
		deleteAncdDNSDomainRow(row);
		findAncdDNSDomainsLastRowAndDisplayRemoveIcon();
		adjtabAncdDNSDomainFirstcolumn('dhcpserver1','Announced DNS Domains');
	}
	function addAncdDNSDomainsRowAndChangeIcon(rowid)
	{
		var table = document.getElementById("dhcpserver1");
		if(table.rows.length >=5)
		{
			alert("Max 5 rows are allowed");
			return;
		}
		ancdnsdomains++;
		var remove=document.getElementById("removednsdomains"+rowid);
		var add=document.getElementById("adddnsdomains"+rowid);
		if(add != null)
		add.style.display="none";
		if(remove != null)
		remove.style.display ="inline";
		$("#dhcpserver1").append("<tr id='ancdnsdomain"+ancdnsdomains+"'><td><div>Announced DNS Domains</div></td><td><div><input type='text' class='text' id='dnsdomains"+ancdnsdomains+"' name='dnsdomains"+ancdnsdomains+"' onkeypress='return avoidSpace(event);' style='display:inline block;margin-right:10px;'></input><label class='add' id='adddnsdomains"+ancdnsdomains+"' style='font-size:15px;'  onclick='addAncdDNSDomainsRowAndChangeIcon("+ancdnsdomains+")'>+</label><label class='remove' style='display:inline; font-size:15px; margin-right:5px;' id='removednsdomains"+ancdnsdomains+"' onclick='deleteAncdDNSDomaintableRow("+ancdnsdomains+")'>x</label><input hidden id='row"+ancdnsdomains+"' value='"+ancdnsdomains+"'></div></td></tr>");
		adjtabAncdDNSDomainFirstcolumn('dhcpserver1','Announced DNS Domains');
	}
	function findAncdDNSDomainsLastRowAndDisplayRemoveIcon()
	{
		var table = document.getElementById("dhcpserver1");
		var lastrow = table.rows[table.rows.length-1];
		var addobj = lastrow.cells[1].childNodes[0].childNodes[1];
		var removeobj = lastrow.cells[1].childNodes[0].childNodes[2];
		addobj.style.display="inline";
		if(table.rows.length > 1)
			removeobj.style.display="inline";
		else if(table.rows.length ==1)
		removeobj.style.display="none";
	}
	function fillAncdDNSDomainsRow(rowid,anouncednsdomains)
	{
		document.getElementById('dnsdomains'+rowid).value=anouncednsdomains;
	}*/
	function validateRtrAdvSvce(id)
	{
	  var rtradvsvce=document.getElementById(id).value;
	  var alwysancdfrtr=document.getElementById("ancdfrtr");
	  
	  //alert("rtradvsvce=====:\n"+rtradvsvce);
	  if(rtradvsvce=="2" || rtradvsvce=="3")
	  {
		  alwysancdfrtr.style.display="none";
	  }
	  else
	  {
	  	//alert("else\n");
	
		  alwysancdfrtr.style.display="";
	  }
	}
	function validatedhcpv6svce(id)
	{
		var dhcp6svce=document.getElementById(id).value;
		var dhcp6mode=document.getElementById("dhcpmode");
	  	//alert("dhcp6svce=====:\n",+dhcp6svce);
	
		if(dhcp6svce=="2" || dhcp6svce=="3")
		{
			//alert("if(dhcp6svce)\n");
			dhcp6mode.style.display="none";
		}
		else
		{
			//alert("else(dhcp6svce)\n");
			dhcp6mode.style.display="";
		}
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
			if(isCIDR && totalipaddr.trim()!="")
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
	/*function validateIP(id, checkempty, name) 
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
				ipele.title = ""; 
				return true; 
			} 
		} 
		else if (!ipaddr.match(ipformat) || ipaddr == "255.255.255.255" )
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
	}*/
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
