package com.nomus.m2m.controller;

import java.io.IOException;
import java.util.ArrayList;
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

import com.nomus.m2m.dao.NodedetailsDao;
import com.nomus.m2m.dao.OrganizationDataDao;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.NumberTester;


@WebServlet("/m2m/m2mrecovernodes")
public class M2MRecoverNodesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			User curuser = (User) request.getSession().getAttribute("loggedinuser");
			Enumeration<String> paramenm = request.getParameterNames();
			NodedetailsDao ndao = new NodedetailsDao();
			List<Integer> delidlist = new ArrayList<Integer>();
			List<NodeDetails> nodelist = new ArrayList<NodeDetails>();
			Map<String,String> crmap = new HashMap<String,String>(); 
			OrganizationDataDao orgdatadao = new OrganizationDataDao();
			List<OrganizationData> orgdatalist = new ArrayList<OrganizationData>();
			List<OrganizationData> updateorgdatalist = new ArrayList<OrganizationData>();
			while(paramenm.hasMoreElements())
            {
            	String nodeid = paramenm.nextElement().trim();
            	if(NumberTester.isInteger(nodeid))
    			{
            		delidlist.add(Integer.parseInt(nodeid));
            		crmap.put(nodeid+"comment", request.getParameter("comment"+nodeid));
    				crmap.put(nodeid+"replacesl", request.getParameter("repslnum"+nodeid));
    			}
            }
            Hashtable< Integer, NodeDetails> nodeidtable = ndao.getNodesIdsTable(delidlist);
    		Set<Integer> idset = nodeidtable.keySet(); 
    		for(int nodeid : idset)
    		{
    			NodeDetails node = nodeidtable.get(nodeid);
    			OrganizationData oldorgdata = orgdatadao.getOrganizationData(node.getSlnumber());
    			String repslnum = node.getRepslnummber();
    			node.setComment(crmap.get(nodeid+"comment"));
    			node.setRepslnummber(crmap.get(nodeid+"replacesl"));
    			nodelist.add(node);
    			nodeidtable.put(nodeid, node);
    			oldorgdata.setStatus(crmap.get(nodeid+"comment"));
    			updateorgdatalist.add(oldorgdata);
    			if(crmap.get(nodeid+"replacesl").trim().length()==0 && crmap.get(nodeid+"comment").trim().length()==0)
    			{
	    				OrganizationData orgdata = orgdatadao.getOrganizationData(repslnum);
	    				if(orgdata!=null)
	    					orgdatalist.add(orgdata);
    			}
    		}
    		//alarmdao.addM2MNodeOtagesList(alarmlist);
    		if(nodelist != null)
    			ndao.updateNodedetailsMap(nodelist);
    		//ndao.deleteNodes(delidlist,crmap);
    		if(updateorgdatalist != null)
    			orgdatadao.updateOrganizationDataList(updateorgdatalist);
    		if(orgdatalist.size()>0)
    			orgdatadao.deleteOrganizationDataList(orgdatalist);
			
			  if(delidlist.size() > 0) { 
				  ndao.recoverNodes(delidlist,curuser);
				  request.getSession().setAttribute("recoverMsg","Nodes Recovered Succefully");
			  }
			 
		}catch (Exception e) {
			//request.getSession().setAttribute("recoverMsg", "Error While Recover Nodes");
			e.printStackTrace();
		}
        response.sendRedirect("deletedNodes.jsp");
		
	}

}
