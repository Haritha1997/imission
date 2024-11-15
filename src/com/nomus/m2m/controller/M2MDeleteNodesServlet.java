package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.nomus.m2m.dao.M2MNodeOtagesDao;
import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.dao.OrganizationDataDao;
import com.nomus.m2m.main.SeverityNames;
import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.M2MNodeOtages;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.NumberTester;

@WebServlet("/m2m/m2mdeletenodes")
public class M2MDeleteNodesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public M2MDeleteNodesServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		User curuser = (User) request.getSession().getAttribute("loggedinuser");
		response.setContentType("text/html");
		NodedetailsDao ndao = new NodedetailsDao();
		M2MNodeOtagesDao alarmdao = new M2MNodeOtagesDao();
		//String update_qry = "update Nodedetails set status=? where id in (:idlist)";
		Enumeration<String> paramValues = request.getParameterNames();
		List<Integer> delidlist = new ArrayList<Integer>();
		List<M2MNodeOtages> alarmlist = new ArrayList<M2MNodeOtages>();
		List<NodeDetails> nodelist = new ArrayList<NodeDetails>();
		Map<String,String> crmap = new HashMap<String,String>(); 
		OrganizationDataDao orgdatadao = new OrganizationDataDao();
		List<OrganizationData> orgdatalist = new ArrayList<OrganizationData>();
		List<OrganizationData> updateorgdatalist = new ArrayList<OrganizationData>();
		while (paramValues.hasMoreElements()) {
			String param = paramValues.nextElement().trim();
			if(NumberTester.isInteger(param))
			{
				delidlist.add(Integer.parseInt(param));
				crmap.put(param+"comment", request.getParameter("comment"+param));
				crmap.put(param+"replacesl", request.getParameter("repslnum"+param));
			}
		}
		Hashtable< Integer, NodeDetails> nodeidtable = ndao.getNodesIdsTable(delidlist);
		Set<Integer> idset = nodeidtable.keySet(); 
		Date date = new Date();
		for(int nodeid : idset)
		{
			NodeDetails node = nodeidtable.get(nodeid);
			OrganizationData oldorgdata = orgdatadao.getOrganizationData(node.getSlnumber());
			M2MNodeOtages alarm = new M2MNodeOtages();
			alarm.setSlnumber(node.getSlnumber());
			alarm.setNodeid(nodeid);
			alarm.setSeverity(SeverityNames.WARNING);
			alarm.setDowntime(date);
			alarm.setUpdateTime(date);
			alarm.setAlarmInfo("Node is Deleted by "+curuser.getUsername());
			alarm.setUser(curuser);
			alarmlist.add(alarm);
			node.setStatus("deleted");
			node.setComment(crmap.get(nodeid+"comment"));
			node.setRepslnummber(crmap.get(nodeid+"replacesl"));
			nodelist.add(node);
			nodeidtable.put(nodeid, node);
			oldorgdata.setStatus(crmap.get(nodeid+"comment"));
			updateorgdatalist.add(oldorgdata);
			if(crmap.get(nodeid+"replacesl").trim().length()>0)
			{
				OrganizationData orgdata = new OrganizationData();
				LoadBatch batch = oldorgdata.getBatch();
				orgdata.setOrganization(node.getOrganization());
				orgdata.setSlnumber(crmap.get(nodeid+"replacesl"));
				orgdata.setValidUpto(batch.getValidUpTo());
				orgdata.setBatch(batch);
				orgdata.setStatus("");
				orgdatalist.add(orgdata);
			}
		}
		alarmdao.addM2MNodeOtagesList(alarmlist);
		ndao.updateNodedetailsMap(nodelist);
		//ndao.deleteNodes(delidlist,crmap);
		orgdatadao.updateOrganizationDataList(updateorgdatalist);
		if(orgdatalist.size()>0)
			orgdatadao.addOrganizationDataList(orgdatalist);
		
		response.sendRedirect("deletedNodes.jsp");
}

}
