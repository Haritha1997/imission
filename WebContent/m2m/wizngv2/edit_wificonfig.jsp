<%@page import="com.nomus.staticmembers.M2MProperties"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.net.util.SubnetUtils"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page import="net.sf.json.JSONObject"%>
 <%
 		String ssname = request.getParameter("essid");
   		String slnumber=request.getParameter("slnumber");
 		String version=request.getParameter("version");
		String errorstr = request.getParameter("error");
		JSONObject wizjsonnode = null;
		JSONObject editwifidevobj=null;
		JSONArray editwifiobj=null;
		JSONObject editwifijsobj=null;
		JSONObject wifiobj=null;
		String encry="";
		String name="";
		/* String md=""; */
		String nwrk="";
		String key="";
		BufferedReader jsonfile = null;  
		   boolean enabled = false;
		   if(slnumber != null && slnumber.trim().length() > 0)
		   {
			   Properties m2mprops = M2MProperties.getM2MProperties();
			   String slnumpath = m2mprops.getProperty("tlsconfigspath")+File.separator+slnumber;
			   jsonfile = new BufferedReader(new FileReader(new File(slnumpath+File.separator+"Config.json")));
			   StringBuilder jsonbuf = new StringBuilder("");
			   String jsonString="";
			   try
			   {
				   while((jsonString = jsonfile.readLine())!= null)
			   		jsonbuf.append( jsonString );
					wizjsonnode= JSONObject.fromObject(jsonbuf.toString());
					editwifijsobj=wizjsonnode.containsKey("wireless")?wizjsonnode.getJSONObject("wireless"):new JSONObject();
			 		editwifidevobj=editwifijsobj.containsKey("wifi-device:radio0")?editwifijsobj.getJSONObject("wifi-device:radio0"):new JSONObject();
			 		editwifiobj=editwifijsobj.containsKey("wifi-iface")?editwifijsobj.getJSONArray("wifi-iface"):new JSONArray();
			 		for (int i = 0; i < editwifiobj.size();i++) {
			 		    wifiobj = editwifiobj.getJSONObject(i);
			 		   name=wifiobj.getString("ssid");
			 		   /* md=wifiobj.getString("mode"); */
			 		   nwrk=wifiobj.getString("network");
			 		   encry = wifiobj.getString("encryption");
			 		   if(!encry.equals("none"))
			 		   		key=wifiobj.getString("key");
			 		}
			 		System.out.println("nerk con"+nwrk.equals("lan"));
			   }
			   catch(Exception e)
			   {
				   e.printStackTrace();
			   }
			   finally
			   {
				   if(jsonfile != null)
					   jsonfile.close();
			   }
		   }
%>
<html>
   <head>
      <link rel="stylesheet" href="css/fontawesome.css">
      <link rel="stylesheet" href="css/solid.css">
      <link rel="stylesheet" href="css/v4-shims.css">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap.min.css">
      <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap-multiselect.css">
      <script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
      <script type="text/javascript" src="js/common.js"></script>
	  <script type="text/javascript" src="js/wificonfig.js"></script>
      <style>
      .caret {
	position: absolute;
	left: 90%;
	top: 40%;
	vertical-align: middle;
	border-top: 6px solid;
}

#act_icon {
	padding-right: 10;
	color: #7B68EE;
	cursor: pointer;
}

#new_icon {
	padding-right: 10;
	color: green;
	cursor: pointer;
}

html 
	{
		overflow-y: scroll;
	}
.Popup
	  {
	    text-align:left;
	    position: absolute;
	    left: 70%;
	    z-index:50;
	    width: 150px;
	    top:90%;
	    background-color: #DCDCDC;
	    border:2px solid black;
	    border-radius: 6%;
	  }
</style>
      <script type="text/javascript">
      function showOrHideOperFrqy() {
    	    var selobj = document.getElementById("oprfrcymode");
    	    var field1obj = document.getElementById("oprfrcywidthtr");
    	    if (selobj.value != "11g/n Mixed") 	
    	    	field1obj.style.display = "none";
    	    else 
    		field1obj.style.display = "";
    	}
    	function showOrhideEncryOptions(emptyval) {
    	    var selobj = document.getElementById("selencryption");
    	    var cipherobj = document.getElementById("cipher_sur");
    	    var userkeyobj = document.getElementById("userKeysslots");
    	    var keyobj = document.getElementById("key_wireless");
    	    if (selobj.value == "6") {
    	        cipherobj.style.display = "none";
    	        userkeyobj.style.display = "none";
    	        keyobj.style.display = "none";
    	    } 
    		else if ((selobj.value != "3") && (selobj.value != "4") && (selobj.value != "5")) {
    	        cipherobj.style.display = "none";
    	        userkeyobj.style.display = "";
    	        keyobj.style.display = "none";
    	    } else {
    	        cipherobj.style.display = "";
    	        userkeyobj.style.display = "none";
    	        keyobj.style.display = "";
    	    }
    	    if (emptyval) {
    	        var keyarr = ["key", "key1", "key2", "key3", "key4"];
    	        for (var i = 0; i < keyarr.length; i++) document.getElementById(keyarr[i]).value = "";
    	    }
    	    //setAutoKeyDefault();
    	}

    	function setChannel(modeid) {
    	    var modeval = document.getElementById("oprfrcymode").value;
    	    var chanobj = document.getElementById("oprfrcychannel");	
    	    if (modeval == "11g only" || modeval == "11g/n Mixed" ||modeval == "11b only") 
    			chanobj.value = '11';
    	}
    	function setAutoKeyDefault() {
    	    var encryval = document.getElementById("selencryption").value;
    	    var cipherobj = document.getElementById("cipher");
    	    var userkeyobj = document.getElementById("userkeyslot");
    	    if (encryval == "1" || encryval == "2") 
    			userkeyobj.value = '1';
    	    else 
    			cipherobj.value = '0';
    	}
    	function WifiConfig()
    	{
    	var altmsg="";
    	    var pswobj=document.getElementById("key").value;
    		var selobj = document.getElementById("selencryption");
    		var networkval = document.getElementById("network_check").value.trim();
    		var keycheckvalid = pwdCheck("key","Wifi");
    		if(selobj.value != "6")
    		{
    			if(pswobj.trim()=="")
    				altmsg+="Key Sholud not be Empty\n";
    			else if(pswobj.length<8)
    				altmsg+="Key Sholud be minimum 8 Characters\n";
    			else if(!keycheckvalid)
    				altmsg+='Key  must contain at least one number and one uppercase and lowercase letter and Use Special Characters except " , '+" :  , '  and  ;";
    		}
    		if(networkval=="")
    			altmsg+="Network Sholud not be Empty\n";
    		if (altmsg.trim().length == 0)
    	    	return true;
    	    else {
    	       alert(altmsg);
    	       return false;
    	    }	
    	}
    	function showOrHideKeyInfo(id) 
    	{
    		var dialog = document.getElementById('keyinfo');
    		if(dialog.open)
    			dialog.close();
    		else
    			dialog.show();
    		return dialog;
    	} 
    	</script>
    	   </head>
    	   <%String act="";
    	   if(editwifiobj.isEmpty())
    		   act="checked";
    	   %>
    	   <body>
    	       <form action="savedetails.jsp?page=edit_wificonfig&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit="return WifiConfig()">
    	         <br>
    	         <p class="style5" align="center">General Setup</p>
    	         <table class="borderlesstab nobackground" style="width:500px;margin-bottom:0px;margin-bottom:0px;" id="wificonfig" align="center">
    	            <tbody>
    	               <tr>
    	                  <th width="200px">Parameters</th>
    	                  <th width="200px">Configuration</th>
    	               </tr>
    	               <tr>
					<%if(editwifidevobj.containsKey("disabled"))
						act = editwifidevobj.getString("disabled").equals("0")?"checked":""; %>
    	                  <td>Activation</td>
    	                  <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="activation"<%=act%>  id="activation" style="vertical-align:middle"><span class="slider round"></span></label></td>
    	               </tr>
    	               <tr>
    	                  <td>ESSID</td>
    	                  <td><input type="text" class="text" id="essid" name="essid" value="<%=ssname%>" readonly=""></td>
    	               </tr>
    	               <!-- <tr>
    	                  <td colspan="2"><b>Operation Frequency</b></td>
    	               </tr> -->
    	               <tr>
    	                  <td>Mode</td>
    	                  <% String modeche =  editwifidevobj!=null? (!editwifidevobj.containsKey("hwmode")?"":editwifidevobj.getString("hwmode")):""; 
    	                  String htmode =  editwifidevobj!=null?(editwifidevobj.containsKey("htmode")&&modeche.equals("11g")?editwifidevobj.getString("htmode"):""):""; 
    	                  %>
    	                  <td>
    	                     <select class="text" id="oprfrcymode" name="oprfrcymode">
    	                        <option value="11b"<%if(modeche.equals("11b")){%>selected<%} %>>11b only</option>
    	                        <option value="11g" <%if(modeche.equals("11g")){%>selected<%} %>>11g only</option>
    	                        <option value="11g/n" <%if(modeche.equals("11g")&&htmode.equals("HT20")){%>selected<%} %>>11g/n Mixed</option>
    	                     </select>
    	                  </td>
    	               </tr>
    	              <%--  <tr id="oprfrcywidthtr" style="display: none;">
    	                   <td>Width</td>
    	                  <td>
    	                     <select class="text" id="oprfrcywidth" name="oprfrcywidth">
    	                        <option value="1" <%if(frywid.equals("1")){%>selected<%} %>>20MHZ</option>
    	                        <option value="2" selected="">40MHZ</option>
    	                     </select>
    	                  </td>
    	               </tr>  --%>
    	               <tr>
    	                  <td>Channel</td>
    	                   <% String chanel =  editwifidevobj!=null? (!editwifidevobj.containsKey("channel")?"":editwifidevobj.getString("channel")):""; 
                        %>
    	                  <td>
    	                     <select class="text" id="oprfrcychannel" name="oprfrcychannel">
    	                        <!--<option value="0" selected="">Auto</option>-->
    	                        <option value="1" <%if(chanel.equals("1")){%>selected<%} %>>1(2412 MHZ)</option>
    	                        <option value="2" <%if(chanel.equals("2")){%>selected<%} %>>2(2417 MHZ)</option>
    	                        <option value="3"<%if(chanel.equals("3")){%>selected<%} %> >3(2422 MHZ)</option>
    	                        <option value="4"<%if(chanel.equals("4")){%>selected<%} %>>4(2427 MHZ)</option>
    	                        <option value="5"<%if(chanel.equals("5")){%>selected<%} %>>5(2432 MHZ)</option>
    	                        <option value="6"<%if(chanel.equals("6")){%>selected<%} %>>6(2437 MHZ)</option>
    	                        <option value="7"<%if(chanel.equals("7")){%>selected<%} %>>7(2442 MHZ)</option>
    	                        <option value="8"<%if(chanel.equals("8")){%>selected<%} %>>8(2447 MHZ)</option>
    	                        <option value="9"<%if(chanel.equals("9")){%>selected<%} %>>9(2452 MHZ)</option>
    	                        <option value="10"<%if(chanel.equals("10")){%>selected<%} %>>10(2457 MHZ)</option>
    	                        <option value="11" <%if(chanel.equals("11")){%>selected<%} %>>11(2462 MHZ)</option>
    	                     </select>
    	                  </td>
    	               </tr>
    	               <tr>
    	                  <td>Transmit Power</td>
    	                   <% String txpwr =  editwifidevobj!=null? (!editwifidevobj.containsKey("txpower")?"":editwifidevobj.getString("txpower")):""; 
                        %>
    	                  <td>
    	                     <select class="text" id="trans_pow" name="trans_pow">
    	                        <option value="0"<%if(txpwr.equals("0")){%>selected<%} %>>0 dBm(1mW)</option>
    	                        <option value="4"<%if(txpwr.equals("4")){%>selected<%} %>>4 dBm(2mW)</option>
    	                        <option value="5"<%if(txpwr.equals("5")){%>selected<%} %>>5 dBm(3mW)</option>
    	                        <option value="7"<%if(txpwr.equals("7")){%>selected<%} %>>7 dBm(5mW)</option>
    	                        <option value="8"<%if(txpwr.equals("8")){%>selected<%} %>>8 dBm(6mW)</option>
    	                        <option value="9"<%if(txpwr.equals("9")){%>selected<%} %>>9 dBm(7mW)</option>
    	                        <option value="10"<%if(txpwr.equals("10")){%>selected<%} %>>10 dBm(10mW)</option>
    	                        <option value="11"<%if(txpwr.equals("11")){%>selected<%} %>>11 dBm(12mW)</option>
    	                        <option value="12"<%if(txpwr.equals("12")){%>selected<%} %>>12 dBm(15mW)</option>
    	                        <option value="13"<%if(txpwr.equals("13")){%>selected<%} %>>13 dBm(19mW)</option>
    	                        <option value="14"<%if(txpwr.equals("14")){%>selected<%} %>>14 dBm(25mW)</option>
    	                        <option value="15"<%if(txpwr.equals("15")){%>selected<%} %>>15 dBm(31mW)</option>
    	                        <option value="16"<%if(txpwr.equals("16")){%>selected<%} %>>16 dBm(39mW)</option>
    	                        <option value="17"<%if(txpwr.equals("17")){%>selected<%} %>>17 dBm(50mW)</option>
    	                        <option value="18"<%if(txpwr.equals("18")){%>selected<%} %>>18 dBm(63mW)</option>
    	                        <option value="19"<%if(txpwr.equals("19")){%>selected<%} %>>19 dBm(79mW)</option>
    	                        <option value="20" <%if(txpwr.equals("20")){%>selected<%} %>>20 dBm(100mW)</option>
    	                     </select>
    	                  </td>
    	               </tr>
    	              <%--  <tr>
    	                  <td>Mode</td>
    	                 <% md =  editwifiobj!=null&&wifiobj!=null?(wifiobj.getString("mode").equals("ap")?"checked":""):""; 
                        %>
    	                  <td><hidden   id="mode_check" name="mode_check" readonly=""><label>AccessPoint</label></td>
    	               </tr> --%>
    	               <tr>
    	                  <td>Network</td>
    	                  <td>
    	                  		<select class="text" id="network_check" name="network_check">
	    	                        <option value="lan" <%if(nwrk.equals("lan")){%>selected<%} %>>LAN</option>
    	                        </select>
    	                  </td>
    	               </tr>
    	            </tbody>
    	         </table>
    	         <br>
    	         <p class="style5" align="center">Wireless Security</p>
    	         <br>
    	         <table class="borderlesstab" style="width:500px;margin-bottom:0px;margin-bottom:0px;" id="wirelesssur" align="center">
    	            <tbody>
    	               <tr>
    	                  <th width="200px">Parameters</th>
    	                  <th width="300px">Configuration</th>
    	               </tr>
    	                <% encry =  editwifiobj!=null &&wifiobj!=null? (!wifiobj.containsKey("encryption")?"":wifiobj.getString("encryption")):"";
    	              String encryval="";
    	              String cipval="";
    	              String cipval1="";
    	              if(!encry.isEmpty()&&!encry.equals("none"))
    	              {
    	               String  encryarr[] = encry.split("\\+");
    	               encryval=encryarr[0];
    	               cipval=encryarr[1];
    	               if(encryarr.length>2)
    	                	cipval1=encryarr[2];
    	              }
    	               %> 
    	               <tr id="encry">
    	                  <td>Encryption</td>
    	                    <% String enval =  editwifiobj!=null &&wifiobj!=null? (!wifiobj.containsKey("encryption")?"":encryval):""; 
                        %>
    	                  <td>
    	                     <select class="text" id="selencryption" name="selencryption" onchange="showOrhideEncryOptions(true)">
    	                        <option value="6"<%if(enval.equals("none")){%>selected<%}%>>No Encryption</option>
    	                        <!--<option value="1">WEP OpenSystem</option>
    	                        <option value="2">WEP SharedKey</option>-->
    	                        <option value="3"<%if(enval.equals("psk")){%>selected<%}%>>WPA-PSK</option>
    	                        <option value="4"<%if(enval.equals("psk2")){%>selected<%}%>>WPA2-PSK</option>
    	                        <option value="5"<%if(enval.equals("psk-mixed")){%>selected<%}%>>WPA-PSK/WPA2-PSK mixed</option>
    	                     </select>
    	                  </td>
    	               </tr>
    	               <tr id="cipher_sur" style="display: none;">
    	                  <td>Cipher</td>
                       <% String ciphval =  editwifiobj!=null &&wifiobj!=null?(!wifiobj.containsKey("encryption")?"":cipval):"";
                        %>
    	                  <td>
    	                     <select class="text" id="cipher" name="cipher">
    	                        <!--<option value="0" selected="">Auto</option>-->
    	                        <option value="1"<%if(ciphval.equals("ccmp")){%>selected<%}%>>Force CCMP(AES)</option>
    	                        <option value="2"<%if(ciphval.equals("tkip")){%>selected<%}%>>Force TKIP</option>
    	                        <option value="3"<%if(cipval1.trim().length()>0){%>selected<%}%>>Force TKIP and Force CCMP(AES)</option>
    	                     </select>
    	                  </td>
    	               </tr>
    	               <tr id="key_wireless" style="display: none;">
    	                  <td>Key</td>
    	                   <% String keyval =  editwifiobj!=null&&wifiobj!=null?(!wifiobj.containsKey("key")?"":wifiobj.getString("key")):""; 
                        %>
    	                  <td width="200">
    	                  <input id="key" class="text" type="password" name="key" maxlength="32"value="<%=keyval%>" onkeyup="checkPwdStrength('key','pwdstr')" onfocusout="pwdCheck('key','Wifi')" onkeypress="return avoidSpace(event)"><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-key"></span>
    	                  <img  src="images/i_sym.jpg" alt="i" width="15" height="10" title="Info" id="keyshow" style="cursor:pointer" onclick="showOrHideKeyInfo('keyshow')"/>
							<dialog id="keyinfo" class="Popup" style="width:15%;border:1px dotted black;">  
								<p>Password must contain:</p><p>&#8226;Minimum 8 Characters</p><p>&#8226;One Numeric(0-9)</p><p>&#8226;One Uppercase Letter(A-Z)</p>
								<p>&#8226;One Lowercase Letter(a-z)</p><p>&#8226;One Special Character</p><p>&#8226;Excluded characters " ' : ? ;</p>
		                     </dialog>
		                     <p id="pwdstr"></p>
    	                  </td>
    	               </tr>
    	            </tbody>
    	         </table>
    	         <table class="borderlesstab" style="width:500px;margin-bottom:0px;margin-bottom:0px;" hidden id="userKeysslots" align="center">
    	            <tbody>
    	               <tr>
    	                  <td width="235px">User Key Slot</td>
    	                  <td>
    	                     <select class="text" id="userkeyslot" name="userkeyslot">
    	                        <option value="1" selected="">Key#1</option>
    	                        <option value="2">Key#2</option>
    	                        <option value="3">Key#3</option>
    	                        <option value="4"> Key#4</option>
    	                     </select>
    	                  </td>
    	               </tr>
    	               <tr>
    	                  <td>Key#1</td>
    	                  <td><input id="key1" class="text" type="password" name="key1" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-key1"></span></td>
    	               </tr>
    	               <tr>
    	                  <td>Key#2</td>
    	                  <td><input id="key2" class="text" type="password" name="key2" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-key2"></span></td>
    	               </tr>
    	               <tr>
    	                  <td>Key#3</td>
    	                  <td><input id="key3" class="text" type="password" name="key3" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-key3"></span></td>
    	               </tr>
    	               <tr>
    	                  <td>Key#4</td>
    	                  <td><input id="key4" class="text" type="password" name="key4" value=""><span toggle="#password-field" class="fa fa-fw fa-eye field_icon toggle-key4"></span></td>
    	               </tr>
    	            </tbody>
    	         </table>
    	         <div align="center"><input type="submit" name="Apply" value="Apply" style="display:inline block" class="button"></div>
    	      </form>
    	      <script>
    	      //showOrHideOperFrqy();
    	      showOrhideEncryOptions(false);</script>
    	   </body>
    	</html>
