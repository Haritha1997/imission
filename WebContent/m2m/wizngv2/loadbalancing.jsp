<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
 		String slnumber=request.getParameter("slnumber");
 		String version=request.getParameter("version");
		String errorstr = request.getParameter("error");  
		String showdiv = request.getParameter("showdiv");
		String intfacename = request.getParameter("intfacename")==null?
				"":request.getParameter("intfacename"); //to show the edit_inteface this interface name is useful
		int int_tab_edit_ind = -1;
		int int_ruletab_edit_ind = -1;
		JSONObject wizjsonnode = null;
		JSONObject mwan3obj=null;
		JSONObject globalsobj=null;
		JSONObject interobj=null;
		BufferedReader jsonfile = null;  
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
				mwan3obj=wizjsonnode.containsKey("mwan3")?wizjsonnode.getJSONObject("mwan3"):new JSONObject();
				globalsobj=mwan3obj.containsKey("globals:globals")?mwan3obj.getJSONObject("globals:globals"):new JSONObject();
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/fontawesome.css">
    <link rel="stylesheet" href="css/solid.css">
    <link rel="stylesheet" href="css/v4-shims.css">
    <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/multiselect/bootstrap-multiselect.css">
    <script src="js/jquery-2.1.1.min.js"></script>
    <script src="js/loadbalancing.js"></script>
    <script src="js/common.js"></script>
    <script type="text/javascript" src="js/multiselect/jquery1.12.4.min.js"></script>
    <script type="text/javascript" src="js/multiselect/bootstrap3.3.6.min.js"></script>
    <script type="text/javascript" src="js/multiselect/bootstrap-multiselect.js"></script> 
    <title>load balancing</title>
</head>
<style>
    .caret 
    { 
    position: absolute; 
    left: 90%; top: 40%;
    vertical-align: middle;
    border-top: 6px solid;
    }
    #act_icon 
    { 
    padding-right:10; 
    color:#7B68EE;
    cursor:pointer;
    }
    #new_icon 
    {
    padding-right:10;
    color:green; 
    cursor:pointer;
    }
    html 
    { 
    overflow-y: scroll;
    }
    .multiselect-container
    {
    width: 100% !important; 
    }
    button.multiselect
    {
    height: 25px; 
    margin: 0; padding: 0;
    } 
    .multiselect-container>.active>a,.multiselect-container>.active>a:hover,.multiselect-container>.active>a:focus { background-color: grey; width: 100%; }.multiselect-container>li.active>a>label,.multiselect-container>li.active>a:hover>label,.multiselect-container>li.active>a:focus>label {color: #ffffff; width: 100%; white-space: normal; }.multiselect-container>li>a>label {font-size: 12.5px; text-align: left; font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;padding-left: 25px; white-space: normal; } 
    #configtypediv li a
    {
    font-size:14px;
    } 
    a,
    a:hover { color: black; text-decoration: none; }
</style>
<script>
    var intfpulsbtn = 0;
    var rudesaddbtn =0;
    var rudesrembtn =0;
</script>
<body><br><br>
    <p class="style5" id="title" style="font-size:20px;" align="center">Load Balancing</p><br>
     <div id="configdiv">
        
        <form action="savedetails.jsp?page=loadbalancing&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit=" return Loadbalancing()">
            <table class="borderlesstab nobackground" style="width:600px;;margin-bottom:0px;" id="configtab" align="center">
                <input type="hidden" style="margin:0px;padding:0px" id="loadivconfpage" name="loadivconfpage" value="">
                <tbody>
                    <tr style="padding:0px;margin:0px;">
                        <td style="padding:0px;margin:0px;">
                           <ul id="configrtypediv">
                              <li><a class="casesense confglist" id="hilightthis" style="cursor:pointer" onclick="showDivision('globalconf','confglist')">Globals</a></li> 
                              <li><a class="casesense confglist" style="cursor:pointer" onclick="showDivision('interfaces_config','confglist')" id="">Interfaces</a></li>
                              <li><a class="casesense confglist" style="cursor:pointer" id="" onclick="showDivision('members_config','confglist')">Members</a></li>
                              <li><a class="casesense confglist" style="cursor:pointer" onclick="showDivision('policies_config','confglist')" id="">Policies</a></li>
                             <li><a class="casesense confglist" style="cursor:pointer" onclick="showDivision('rulesconf','confglist')" id="">Rules</a></li>
                           </ul>
                        </td>
                     </tr>
                </tbody>
            </table>
            <div id="globalconf">
                <table id="globatab" class="borderlesstab" style="width:600px;;" align="center">
                    <tbody>
                        <tr>
                            <th width="300px">Parameters</th>
                            <th width="300px">Configuration</th>
                         </tr>
                         <tr>
                            <td>Enabled</td>
                            <%String enable=globalsobj!=null?globalsobj.containsKey("enabled")?globalsobj.getString("enabled").equals("1")?"checked":"":"":"";%>
                            <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="globalact" id="globalact" <%=enable%> style="vertical-align:middle"><span class="slider round"></span></label></td>
                         </tr>
                    </tbody>
                </table><br><br><br>
                <div align="center" id="saveapplydiv">
                    <!-- <input type="submit" id="Apply" name="Apply" value="Apply" style="display:inline block" class="button"> -->
                    <input type="submit" id="Apply" name="Apply" value=" Apply" style="display:inline block" class="button">
                </div>
            </div>
        </form>

        <form action="savedetails.jsp?page=loadbalan_inter_config&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit=" return Loadbalancing()">
            <!-- interface page -->
            <div id="interfaces_config" style="margin:0px; display: none;" align="center">
                <input type="text" id="intconfigcount" name="intconfigcount" value="1" hidden="">
                <table  class="borderlesstab" style="width:600px;" id="Interfaces" align="center">
                    <tbody>
                        <tr>
                            <th style="text-align:center;" width="10px" align="center">S.No</th>
                            <th style="text-align:center;" width="100px" align="center">Interface Name</th>
                            <th style="text-align:center;" width="80px" align="center">Tracking Ip</th>
                            <th style="text-align:center;" width="140px" align="center">Tracking Reliability</th>
                            <th style="text-align:center;" width="30px" align="center">Enabled</th>
                            <th style="text-align:center;" width="140px" align="center">Action</th>
                         </tr>
                    </tbody>
                </table><br><br><br><br><br><br>
            </div>
        </form>
 <%
 // interfaces table division
	    int i=0;
	 	String name ="";
		String trackip = "";
		String act = "";
		String trackreal = "";
		String count=""; 
		String itimeout="";
		String interval="";
		String down="";
		String up="";
		String family="";
		String infaceval="";
		Iterator<String> keys =mwan3obj.keys();
	    while(keys.hasNext())
		{
			String ckey = keys.next();
			if(ckey.contains("interface:")){
			JSONObject interfaceobj = mwan3obj.getJSONObject(ckey);
			name= ckey.replace("interface:","");
			String trackipvals="";
			if(interfaceobj.containsKey("track_ip"))
			{
				JSONArray trackarr=interfaceobj.getJSONArray("track_ip");
				for (int j = 0; j < trackarr.size(); j++) {
					String ipvals = trackarr.getString(j).trim();
					if(trackipvals.isEmpty())
						trackipvals=trackipvals.concat(ipvals);
					else
						trackipvals=trackipvals.concat(" "+ipvals);
				}
			}
			trackip=trackipvals;
			act = interfaceobj.containsKey("enabled")?interfaceobj.getString("enabled").equals("1")?"checked":"":"";
			trackreal=interfaceobj.containsKey("reliability")?interfaceobj.getString("reliability"):"";
			count=interfaceobj.containsKey("count")?interfaceobj.getString("count"):"";	
			itimeout=interfaceobj.containsKey("timeout")?interfaceobj.getString("timeout"):"";
			interval=interfaceobj.containsKey("interval")?interfaceobj.getString("interval"):"";
			down=interfaceobj.containsKey("down")?interfaceobj.getString("down"):"";
			up=interfaceobj.containsKey("up")?interfaceobj.getString("up"):"";
			family=interfaceobj.containsKey("family")?interfaceobj.getString("family"):"";
			if(name.trim().equals(intfacename))
				int_tab_edit_ind = i+1;
			%>
			<script>
				addRow('Interfaces','<%=slnumber%>','<%=version%>');
				fillInterfacerow('<%=i+1%>','<%=name%>','<%=trackip%>','<%=trackreal%>','<%=act%>','<%=count%>','<%=itimeout%>','<%=interval%>','<%=down%>','<%=up%>','<%=family%>');
			</script>
			<%	
			i++;
			}
		}
	  %>
        <form action="savedetails.jsp?page=interfacetable&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit=" return validateInterfaces()">
            <div id="interfacetable" style="margin:0px; display: none;"  align="center">
                <input type="text" id="interfacetab_rwcnt" name="interfacetab_rwcnt" value="1" hidden="">
                <table class="borderlesstab" id="interfacepage" style="width:600px;" align="center">
                    <tbody>
                        <tr>
                            <th width="300px">Parameters</th>
                            <th width="300px">Configuration</th>
                        </tr>
                        <tr>
                            <td>Enabled</td>
                            <td><label class="switch" style="vertical-align:middle"><input type="checkbox" name="intract" id="intract" style="vertical-align:middle"><span class="slider round"></span></label></td>
                        </tr>
                        <tr>
                            <td>Interface Name</td>
                            <td><input type="text" name="intname" id="intname" class="text" readonly></td>
                        </tr>
                    </tbody>
                </table>
                <table class="borderlesstab" id="trackiptab" style="width:600px;" align="center">
                    <input type="hidden" id="trackcunt" name="trackcunt" value="3">
                </table>
                <table class="borderlesstab" id="interfacesubpage" style="width:600px;" align="center">
                    <tbody>
                        <tr>
                            <td  width="300px">Tracking Reliability</td>
                             <%String objtrackreal=interobj!=null?interobj.containsKey("reliability")?interobj.getString("reliability"):"":trackreal;%>
                            <td width="300px"><input type="number" min="1" max="2" value="<%=objtrackreal%>" name="trackreblity" id="trackreblity" class="text" onfocusout="validateRange('trackreblity',true,'Tracking Reliability')"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td>Ping Count</td>
                            <td><input type="number" min="1" max="5"  placeholder="1-5" name="pingcunt" id="pingcunt" class="text" onfocusout="validateRange('pingcunt',true,'Ping Count')"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td>Ping Timeout</td>
                            <td><input type="number" min="1" max="30"  placeholder="1-30" name="pingtiout" id="pingtiout" class="text" onfocusout="validateRange('pingtiout',true,'Ping Timeout')"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td>Ping Interval</td>
                            <td><input type="number" min="1" max="30" placeholder="1-30" name="pingintvl" id="pingintvl" class="text" onfocusout="validateRange('pingintvl',true,'Ping Interval')"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td>Interface Down</td>
                            <td><input type="number" min="1" max="5" placeholder="1-5" name="intrfdwn" id="intrfdwn" class="text" onfocusout="validateRange('intrfdwn',true,'Interface Down')"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td>Interface Up</td>
                            <td><input type="number" min="1" max="5"  placeholder="1-5" name="intrfup" id="intrfup" class="text" onfocusout="validateRange('intrfup',true,'Interface Up')"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td>Family</td>
                            <td><select name="family" id="family" class="text">
                                <option value="ipv4">Ipv4</option>
                                <option value="ipv6">Ipv6</option>
                            </select></td>
                        </tr>
                    </tbody>
                </table>
                <div align="center" id="saveapplydiv">
                    <input type="submit" id="Apply" name="Apply" value=" Apply" style="display:inline block" class="button">
                </div>
            </div>
        </form>
       
        <form  action="savedetails.jsp?page=members_config&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit=" return validateMembers()">
            <!-- member page -->
            <div id="members_config" style="margin:0px; display: none;" align="center">
                <input type="text" id="Memberscount" name="Memberscount" value="1" hidden="">
                <table class="borderlesstab" style="width:600px;" id="Members" align="center">
                    <tbody>
                        <tr>
                            <th style="text-align:center;" width="10px" align="center">S.No</th>
                            <th style="text-align:center;" width="100px" align="center">Member Name</th>
                            <th style="text-align:center;" width="150px" align="center">Interface Assigned</th>
                            <th style="text-align:center;" width="40px" align="center">Metric</th>
                            <th style="text-align:center;" width="40px" align="center">Weight</th>
                            <th style="text-align:center;" width="100px" align="center">Action</th>
                        </tr>
                    </tbody>
                </table><br><br><br><br>
                <table align="center" class="borderlesstab">
                    <tbody>
                        <tr align="center">
                            <td><label id="memlblname" name="memlblname">New Member Name</label></td>
                            <td><input type="text" class="text" id="memebeid" name="memebeid" style="margin-left:10px;" maxlength="15" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('memebeid','New Member Name')"></td><td>
                            <td><input type="button" id="menbadd" name="menbadd" value="Add" style="display:inline block" class="button1" onclick="CheckNamevalidAndDuplicates('memebeid','New Member Name','Members','Members',true,'<%=slnumber%>','<%=version%>');"></td>
                            <td></td>
                        </tr>
                        <tr style="background-color: white;">
                            <td colspan="4">
                                <p style="font-size:11px;font-family: verdana;margin-left:70px;">
                                    <span style="color:red;text-align:left;">
                                        <b>Note:</b>
                                    </span>
                                    Special characters are not allowed expect  '_'
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div align="center" id="saveapplydiv">
                    <input type="submit" id="Apply" name="Apply" value="Apply" style="display:inline block" class="button">
                </div>
            </div>
        </form>
<%
	    int m=0;
		Iterator<String> memkeys =mwan3obj.keys();
	    while(memkeys.hasNext())
		{
			String ckey = memkeys.next();
			if(ckey.contains("member:")){
			JSONObject memberobj = mwan3obj.getJSONObject(ckey);
			String memname = ckey.replace("member:","");
			String intface=memberobj.containsKey("interface")?memberobj.getString("interface"):"";
			String weight=memberobj.containsKey("weight")?memberobj.getString("weight"):"1";	
			String metric=memberobj.containsKey("metric")?memberobj.getString("metric"):"1";
			%>
			<script>
		    	addRow('Members','<%=slnumber%>','<%=version%>');
		    	fillmemberow('<%=m+1%>','<%=memname%>','<%=intface%>','<%=metric%>','<%=weight%>');
			</script>
			<%	
			m++;
			}
		}
	  %>
        <form action="savedetails.jsp?page=policies_config&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit=" return validatePolicy()">
            <!-- policies page -->
            <div id="policies_config" style="margin:0px; display: none;" align="center">
                <input type="text" id="policiesconfigcount" name="policiesconfigcount" value="1" hidden="">
                <table class="borderlesstab" style="width:600px;" id="Policies" align="center">
                    <tbody>
                        <tr>
                            <th style="text-align:center;" width="10px" align="center">S.No</th>
                            <th style="text-align:center;" width="100px" align="center">Policy Name</th>
                            <th style="text-align:center;" width="150px" align="center">Members Assigned</th>
                            <th style="text-align:center;" width="100px" align="center">Last Resort</th>
                            <th style="text-align:center;" width="100px" align="center">Action</th>
                        </tr>
                    </tbody>
                </table><br><br><br><br>
                 <table align="center" class="borderlesstab">
                    <tbody>
                        <tr align="center">
                            <td><label id="polilblname" name="polilblname">New Policy Name</label></td>
                            <td><input type="text" class="text" id="policeid" name="policeid" style="margin-left:10px;" maxlength="15" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('policeid','Policy Name')"></td><td>
                            <td><input type="button" id="poliadd" name="poliadd" value="Add" style="display:inline block" class="button1" onclick="CheckNamevalidAndDuplicates('policeid','Policy Name','Policies','Policies',true,'<%=slnumber%>','<%=version%>');"></td>
                            <td></td>
                        </tr>
                        <tr style="background-color: white;">
                            <td colspan="4">
                                <p style="font-size:11px;font-family: verdana;margin-left:70px;">
                                    <span style="color:red;text-align:left;">
                                        <b>Note:</b>
                                    </span>
                                    Special characters are not allowed expect  '_' 
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div align="center" id="saveapplydiv">
                    <input type="submit" id="Apply" name="Apply" value="Apply" style="display:inline block" class="button">
                </div>
            </div>
        </form>
        <%
	    int p=0;
		Iterator<String> polkeys =mwan3obj.keys();
	    while(polkeys.hasNext())
		{
			String ckey = polkeys.next();
			if(ckey.contains("policy:")){
			JSONObject policyobj = mwan3obj.getJSONObject(ckey);
			String polname = ckey.replace("policy:","");
			String lastresort=policyobj.containsKey("last_resort")?policyobj.getString("last_resort"):"";
			lastresort=lastresort.equals("unreachable")?"1":lastresort.equals("blackhole")?"2":"3";
			String memassen="";
			if(policyobj.containsKey("use_member"))
			{
				JSONArray usememarr=policyobj.getJSONArray("use_member");
				for(int u=0;u<usememarr.size();u++)
				{
					String vals = usememarr.getString(u).trim();
					if(memassen.isEmpty())
						memassen=memassen.concat(vals);
					else
						memassen=memassen.concat(","+vals);
				}
			}
					%>
			<script>
			   //alert("calling add row from jsp ");
			    addRow('Policies','<%=slnumber%>','<%=version%>');
			    fillpolicierow('<%=p+1%>','<%=polname%>','<%=memassen%>','<%=lastresort%>');
			</script>
			<%	
			p++;
			}
		}
	  %>
            <!-- rules page -->
        <form action="savedetails.jsp?page=rulesconf&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit=" return Loadbalancing()">
            <div id="rulesconf" style="margin:0px; display: none;" align="center">
                <input type="text" id="Rulescount" name="Rulescount" value="1" hidden="">
                <table class="borderlesstab" style="width:600px;" id="Rules" align="center">
                    <tbody>
                        <tr>
                            <th style="text-align:center;" width="10px" align="center">S.No</th>
                            <th style="text-align:center;" width="60px" align="center">Rule Name</th>
                            <th style="text-align:center;" width="100px" align="center">Policy Assigned</th>
                            <th style="text-align:center;" width="100px" align="center">Action</th>
                        </tr>
                    </tbody>
                </table><br><br><br><br><br><br>
                <table class="borderlesstab" id="rulesonfid" align="center">
                    <tbody>
                        <tr align="center">
                            <td><label id="rulelblname" name="rulelblname">New Instance Name</label></td>
                            <td><input type="text" class="text" id="ruleid" name="ruleid" style="margin-left:10px;" maxlength="32" onkeypress="return avoidSpace(event) && avoidEnter(event)" onfocusout="isEmpty('ruleid','New Instance Name')"></td><td>
                            <td><input type="button" class="button1" id="add" value="Add" style="margin-left:10px;" onclick="CheckNamevalidAndDuplicates('ruleid','Instance Name','Rules','Rules',true,'<%=slnumber%>','<%=version%>')"></td>
                        </tr>
                        <tr style="background-color: white;">
                            <td colspan="4">
                                <p style="font-size:11px;font-family: verdana;margin-left:70px;">
                                    <span style="color:red;text-align:left;">
                                        <b>Note:</b>
                                    </span>
                                        Special characters are not allowed expect  '_' 
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </form>
<%
	    int r=0;
     	String rulename ="";
     	String proto="";
     	String dest_ip="";
		String dest_port="";
		String sticky="";
		String rtimeout="";
		String poliassen="";
		List<String> oldpolicy = new ArrayList<String>();
		Iterator<String> ruleskeys =mwan3obj.keys();
	    while(ruleskeys.hasNext())
		{
			String ckey = ruleskeys.next();
			List<String> policynames =  new ArrayList<String>();
			Iterator<String> polasskeys =mwan3obj.keys();
		    while(polasskeys.hasNext())
			{
				String packey = polasskeys.next();
				if(packey.contains("policy:")){
				String polassname = packey.replace("policy:","");
				policynames.add(polassname);
				}
			}
			if(ckey.contains("rule:")){
			JSONObject ruleobj = mwan3obj.getJSONObject(ckey);
			rulename = ckey.replace("rule:","");
			proto=ruleobj.containsKey("proto")?ruleobj.getString("proto"):"all";
			dest_port=ruleobj.containsKey("dest_port")?ruleobj.getString("dest_port"):"";
			sticky=ruleobj.containsKey("sticky")?ruleobj.getString("sticky"):"No";
			sticky=sticky.equals("1")?"Yes":"No";
			if(sticky.equals("Yes"))
				rtimeout=ruleobj.containsKey("timeout")?ruleobj.getString("timeout"):"";
			else
				rtimeout="";
			poliassen=ruleobj.containsKey("use_policy")?ruleobj.getString("use_policy"):"";
			if (policynames.contains(poliassen))
			{
				policynames.remove(poliassen);
				oldpolicy=policynames;
			}
			dest_ip=ruleobj.containsKey("dest_ip")?ruleobj.getString("dest_ip"):"";
			String dest_ipvals="";
			if(dest_ip!="")
			{
				if(dest_ip.contains(","))
				{
					String[] dest_iparr=dest_ip.split(",");
					for(int k=0;k<dest_iparr.length;k++)
					{
						if(dest_ipvals.isEmpty())
							dest_ipvals=dest_iparr[k];
						else
							dest_ipvals=dest_ipvals.concat(" "+dest_iparr[k]);
					}
				}
				else
					dest_ipvals=ruleobj.getString("dest_ip");
			}
			if(rulename.trim().equals(intfacename))
				int_ruletab_edit_ind = r+1;
			%>
			<script>
			    addRow('Rules','<%=slnumber%>','<%=version%>');
			    fillrulesrow('<%=r+1%>','<%=rulename%>','<%=poliassen%>','<%=proto%>','<%=dest_ipvals%>','<%=sticky%>','<%=rtimeout%>','<%=dest_port%>');
			</script>
			<%	
			r++;
			}
			else
				 oldpolicy=policynames;
		}
	  %>
        <form action="savedetails.jsp?page=rulesdiv&slnumber=<%=slnumber%>&version=<%=version%>" method="post" onsubmit=" return validateRules()">
            <div id="rulesdiv" style="margin:0px; display: none;"  align="center">
                <table class="borderlesstab" id="rulestab" style="width:600px;" align="center">
                    <tbody>
                        <tr>
                            <th width="300px">Parameters</th>
                            <th width="300px">Configuration</th>
                        </tr>
                        <tr>
                            <td>Rules Name</td>
                            <td><input type="text" id="rulname" name="rulname" class="text" value=""></td>
                        </tr>
                        <tr>
                            <td>Protocol</td>
                            <td><select name="protocol" id="protocol" class="text" onchange="destporthide()">
                                <option value="all" <%if (proto.contains("all")) {%> selected <%}%>>All</option>
                                <option value="tcp" <%if (proto.contains("tcp")) {%> selected <%}%>>TCP</option>
                                <option value="udp" <%if (proto.contains("udp")) {%> selected <%}%>>UDP</option>
                                <option value="icmp" <%if (proto.contains("icmp")) {%> selected <%}%>>ICMP</option>
                            </select></td>
                        </tr>
                    </tbody>
                </table>
                <table class="borderlesstab" id="destaddrtab" style="width:600px;" align="center">
                    <input type="hidden" id="destcount" name="destcount" value="6">
                </table>
                <table class="borderlesstab" id="rulesubpage" style="width:600px;" align="center">
                    <tbody>
                        <tr id="dport_row">
                            <td width="300px">Destination Port</td>
                            <td width="300px"><input type="text" name="dport" id="dport" class="text" value="<%=dest_port%>"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td width="300px">Sticky</td>
                            <td width="300px"><select name="sticky" id="sticky" class="text" onchange="stickyhide()">
                                <option value="Yes" <%if (sticky.contains("Yes")) {%> selected <%}%>>Yes</option>
                                <option value="No" <%if (sticky.contains("No")) {%> selected <%}%>>No</option>
                            </select></td>
                        </tr>
                        <tr id="stickrow">
                            <td>Sticky Timeout</td>
                            <td><input type="number" min="1" max="3600" value="<%=rtimeout%>" name="stimeout" id="stimeout" class="text"  onkeypress="return avoidSpace(event)"></td>
                        </tr>
                        <tr>
                            <td>Policy Assigned</td>
                            <td><select name="poliassign" id="poliassign" class="text">
                                <option value="<%=poliassen%>"><%=poliassen%></option>
										<%
										for (String pname : oldpolicy) {
										if(!pname.equals(poliassen)){%>
										<option value="<%=pname%>"><%=pname%></option>
										<%
										}}
										%>
                            </select></td>
                        </tr>
                    </tbody>
                </table>
                <div align="center" id="saveapplydiv">
                    <input type="submit" id="Apply" name="Apply" value="Apply" style="display:inline block" class="button">
                </div>
            </div>
            <br><br><br>
        </form>
      
    </div>
</body>
<script>
    stickyhide();
    destporthide();
    addRulesRow(intfpulsbtn,"trackiptab");
    addRulesRow(rudesaddbtn,"destaddrtab");
</script>
<%
if(showdiv==null||showdiv.isEmpty())
 {%>
		<script>
		 showDivision('globalconf','confglist');
		</script>
<%
}else if(showdiv.equals("interfacetable"))
{ %>
	<script>
	 showDivision('interfacetable','confglist');
	 <%if(int_tab_edit_ind != -1){%>
	 	document.getElementById('iteditrw'+<%=int_tab_edit_ind%>).click();
	 <%}%>
	</script>
<%}else if(showdiv.equals("members_config"))
	{%>
	<script>
	 showDivision('members_config','confglist');
	</script>
<%}else if(showdiv.equals("policies_config"))
{%>
	<script>
	 showDivision('policies_config','confglist');
	</script>
<%}else if(showdiv.equals("rulesconf"))
{%>
	<script>
	 showDivision('rulesconf','confglist');
	</script>
<%}else
{%>
	<script>
	showDivision('rulesdiv','confglist');
	<%if(int_ruletab_edit_ind != -1){%>
 	document.getElementById('editrw'+<%=int_ruletab_edit_ind%>).click();
 	<%}%>
	</script>
<%
}
%>

</html>