package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.main.SeverityNames;
import com.nomus.m2m.pojo.BulkActivity;
import com.nomus.m2m.pojo.BulkActivityDetails;
import com.nomus.m2m.pojo.M2MNodeOtages;
import com.nomus.m2m.pojo.M2Mlogs;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.NodeStatus;
import com.nomus.staticmembers.UserRole;



public class NodedetailsDao {

	private static int CONFIG = 1;
	private static int EXPORT = 2;
	private static int REBOOT = 3;
	private static int UPGRADE = 4;
	private int task_timeout = 30;
	private int upgrade_timeout = 120;
	private static String YES_STR = "yes";
	private static String NO_STR = "no";
	private static int FAILED = 2;

	public NodedetailsDao()
	{
	}

	/* Method to CREATE an employee in the database */
	public Integer addNodeDetails(NodeDetails ndobj){
		Transaction tx = null;
		int nodeid = 0;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			nodeid = (Integer) session.save(ndobj);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodeid;
	}

	public NodeDetails getNodeDetails(String columnname, String value ){
		//System.out.println("columnname is : "+columnname+" value is : "+value);
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		NodeDetails ndobj = null;
		try {
			tx = session.beginTransaction();

			//Criteria criteria = session.createCriteria(NodeDetails.class);
			//criteria.setMaxResults(1);
			//ndobj = (NodeDetails)criteria.add(Restrictions.eq(columnname, value)).uniqueResult();
			Query query = session.createQuery("from NodeDetails where "+columnname+"='"+value+"'");
			query.setMaxResults(1);
			List<NodeDetails> nodelist = query.getResultList();
			if(nodelist.size() > 0)
				ndobj = nodelist.get(0);
			tx.commit();
		} 
		catch (NoResultException e) {
			if (tx!=null) tx.rollback();
		}
		catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return ndobj;
	}

	public void setNodesStatusOnStartup()
	{
		Session session = HibernateSession.getDBSession();

		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			Query query = session.createQuery("update NodeDetails set status=:status,downtime=:downtime,uptime=null where status=:st");
			query.setParameter("status", "down");
			query.setParameter("downtime", new Date());
			query.setParameter("st", "up");
			query.executeUpdate();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace();  
		} finally {
			session.close();
		}
	}
	public void updateNodeDetails(NodeDetails ndobj)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(ndobj);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}
	}
	public void updateNodeDetails(NodeDetails ndobj,String type,String status)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(ndobj);
			BulkActivityDetDao bcdcon = new BulkActivityDetDao();
			BulkActivityDao bccon = new BulkActivityDao();
			List<BulkActivityDetails> bdetlist = bcdcon.getBulkConfigDetailsList("slnumber", ndobj.getSlnumber(), session,type);
			for(BulkActivityDetails bcdet : bdetlist)
			{
				bcdet.setStatus(status);
				bcdet.setStatustime(Calendar.getInstance().getTime());
				bcdcon.UpdateBulkConfigDetails(bcdet, session);
				BulkActivity bc = bcdet.getBulkActivity();

				List<BulkActivityDetails> bcdlist = bcdcon.getInProgresBCDList(bcdet.getBulkActivity(), session);
				if(bcdlist == null || bcdlist.size() == 0)
				{
					bc.setStatus("Completed");
					bccon.UpdateBulkConfig(bc, session);
				}
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}
	}

	public List<NodeDetails> getNodeList(String columnname,String status){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = null;
		try {
			tx = session.beginTransaction();
			//Criteria criteria = session.createCriteria(NodeDetails.class);
			//criteria.add(Restrictions.eq(columnname, status));
			Query qry = session.createQuery("from NodeDetails where "+columnname+"=:val",NodeDetails.class);
			qry.setParameter("val", status);
			nodelist = qry.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}

	public List<NodeDetails> getAllNodeList(User user){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = null;
		try {
			tx = session.beginTransaction();
			String qry = "from NodeDetails where status != :st";
			qry = getCompleteQuery(user,qry,false);
			Query query = session.createQuery(qry);
			if(user.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}
			else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			{
				//query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}
			query.setParameter("st", "deleted");
			nodelist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}
	public List<NodeDetails> getNodeList(User user,String status,boolean getUnderArea){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = null;
		try {
			tx = session.beginTransaction();
			String qry = "from NodeDetails where status = :st";
			if(status.equals(NodeStatus.ALL))
				qry = "from NodeDetails where status != :st";
			qry = getCompleteQuery(user,qry,getUnderArea);
			Query query = session.createQuery(qry);
			if(user.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("slnumlist", user.getSlnumberlist());
				query.setParameter("arealist", user.getArealist());
			}
			else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			{
				if(getUnderArea)
					query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}
			if(status.equals(NodeStatus.ALL))
				query.setParameter("st", "deleted");
			else
				query.setParameter("st", status);
			nodelist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}
	public List<NodeDetails> getNodeList(User user,String status,boolean getUnderArea,String sortby,String sorttype){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = null;
		try {
			tx = session.beginTransaction();
			String qry = "from NodeDetails where status = :st";
			if(status.equals(NodeStatus.ALL))
				qry = "from NodeDetails where status != :st";
			qry = getNodeCompleteQuery(user,qry,getUnderArea);
			qry +=" order by "+sortby+" "+sorttype;
			Query query = session.createQuery(qry);
			if(user.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("slnumlist", user.getSlnumberlist());
				query.setParameter("arealist", user.getArealist());
			}
			else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			{
				if(getUnderArea)
					query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}
			if(status.equals(NodeStatus.ALL))
				query.setParameter("st", "deleted");
			else
				query.setParameter("st", status);
			nodelist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}
	public List<NodeDetails> getYesterdayNodeList(User user,String status,boolean getUnderArea){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = null;
		try {
			tx = session.beginTransaction();
			String qry = "from NodeDetails where status = :st";
			if(status.equals(NodeStatus.ALL))
				qry = "from NodeDetails where status != :st";
			qry += " and createdtime < :yesterday";
			qry = getCompleteQuery(user,qry,getUnderArea);
			Query query = session.createQuery(qry);
			if(user.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("slnumlist", user.getSlnumberlist());
				query.setParameter("arealist", user.getArealist());
			}
			else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			{
				if(getUnderArea)
					query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}
			if(status.equals(NodeStatus.ALL))
				query.setParameter("st", "deleted");
			else
				query.setParameter("st", status);
			query.setParameter("yesterday", DateTimeUtil.getOnlyDate(new Date()));
			nodelist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}
	public List<NodeDetails> getNodeList(List<String> slnumlist){
		if(slnumlist.size() == 0)
			return new ArrayList<NodeDetails>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = null;

		try {
			tx = session.beginTransaction();
			String qry = "from NodeDetails where slnumber in (:sllist) order by slnumber";
			Query query = session.createQuery(qry);

			query.setParameter("sllist", slnumlist);
			nodelist = query.getResultList();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}

	private String getCompleteQuery(User user, String qry,boolean getUnderArea) {
		// TODO Auto-generated method stub
		//Hibernate.initialize(user.getArealist());
		//Hibernate.initialize(user.getSlnumberlist());
		if(!user.getRole().equals(UserRole.MAINADMIN))
			qry +=" and organization = '"+user.getOrganization().getName()+"'";
		if(user.getRole().equals(UserRole.ADMIN))
		{
			qry +=" and (location in (:arealist) or slnumber in (:slnumlist))";
		}
		else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			if(getUnderArea)
				qry +=" and (location in (:arealist) or slnumber in (:slnumlist))";
			else
				qry +=" and (slnumber in (:slnumlist))";

		qry += " order by slnumber";
		return qry;
	}
	private String getNodeCompleteQuery(User user, String qry,boolean getUnderArea) {
		// TODO Auto-generated method stub
		//Hibernate.initialize(user.getArealist());
		//Hibernate.initialize(user.getSlnumberlist());
		if(!user.getRole().equals(UserRole.MAINADMIN))
			qry +=" and organization = '"+user.getOrganization().getName()+"'";
		if(user.getRole().equals(UserRole.ADMIN))
		{
			qry +=" and (location in (:arealist) or slnumber in (:slnumlist))";
		}
		else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			if(getUnderArea)
				qry +=" and (location in (:arealist) or slnumber in (:slnumlist))";
			else
				qry +=" and (slnumber in (:slnumlist))";
		return qry;
	}
	public List<String> getLocations(User user)
	{
		Session session = HibernateSession.getDBSession();
		List<String> loclist = new ArrayList<String>();
		Organization organization=user.getOrganization();
		Query query = null;
		try {
			if(user.getRole().equals(UserRole.MAINADMIN))
				query = session.createQuery("select location from NodeDetails group by location order by location",String.class);
			else if(user.getRole().equals(UserRole.SUPERADMIN))
			{
				query = session.createQuery("select location from NodeDetails where organization = :org group by location order by location",String.class);
				query.setParameter("org", organization.getName());
			}
			//else if(user.getRole().equals(UserRole.ADMIN))
			else
			{
				query = session.createQuery("select location from NodeDetails where organization = :org and location in (:loclist) group by location order by location",String.class);
				query.setParameter("loclist",user.getArealist());
				query.setParameter("org", organization.getName());
			}
			loclist=query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return loclist;
	}
	public boolean deleteNodes(List<Integer> delidlist,Map<String, String> crmap)
	{
		boolean deleted = true;
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry = "update NodeDetails set status='deleted' where id in(:idlist)";
			Query query = session.createQuery(qry);
			query.setParameter("idlist",delidlist);
			query.executeUpdate();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			deleted = false;
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return deleted;
	}

	public boolean recoverNodes(List<Integer> delidlist,User user)
	{
		boolean deleted = true;
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry = "update NodeDetails set status='down',downtime=:time where id in(:idlist) and status='deleted'";
			Query query = session.createQuery(qry);
			query.setParameter("idlist",delidlist);
			Date date = new Date();
			query.setParameter("time",date);
			query.executeUpdate();
			setRecoverNodesOutage(delidlist,date,user);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			deleted = false;
			e.printStackTrace(); 		
			} finally {
				session.close();
			}
		return deleted;
	}

	private void setRecoverNodesOutage(List<Integer> nodeidlist,Date date,User user) {
		// TODO Auto-generated method stub
		M2MNodeOtagesDao outagedao = new M2MNodeOtagesDao();
		Hashtable<Integer,NodeDetails> idnodetable = getNodesIdsTable(nodeidlist);
		for(int nodeid : nodeidlist)
		{
			M2MNodeOtages lastdeleted = outagedao.getLastDeleted(nodeid);
			if(lastdeleted != null && lastdeleted.getUptime() == null)
			{
				lastdeleted.setSeverity(SeverityNames.CLEARED);
				lastdeleted.setUptime(date);
				outagedao.updateM2MNodeOtage(lastdeleted);
				M2MNodeOtages outage  = new M2MNodeOtages();
				outage.setSlnumber(idnodetable.get(nodeid).getSlnumber());
				outage.setUpdateTime(date);
				outage.setSeverity(SeverityNames.NORMAL);
				outage.setAlarmInfo("Node is Recoverd by "+user.getUsername());
				outage.setUser(user);
				outagedao.addM2MNodeOtages(outage);
			}
			else
				continue;
			M2MNodeOtages lastoutage  = outagedao.getLastOutage(nodeid);
			if(lastoutage != null && lastoutage.getUptime() == null)
				continue;

			M2MNodeOtages outage  = new M2MNodeOtages();
			outage.setSlnumber(idnodetable.get(nodeid).getSlnumber());
			outage.setNodeid(nodeid);
			outage.setDowntime(date);
			outage.setUpdateTime(date);
			outage.setAlarmInfo("Node is Down");
			outage.setSeverity(SeverityNames.CRITICAL);
			outagedao.addM2MNodeOtages(outage);
		}
	}
	public Hashtable<Integer,NodeDetails> getNodesIdsTable(List<Integer> idlist)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = new ArrayList<NodeDetails>();
		Hashtable<Integer, NodeDetails> nodeidtab = new Hashtable<Integer,NodeDetails>();
		try {
			tx = session.beginTransaction();
			String qry = "from NodeDetails where id in (:idlist)";
			Query query = session.createQuery(qry);
			query.setParameter("idlist", idlist);
			nodelist = query.getResultList();
			for(NodeDetails node : nodelist)
				nodeidtab.put(node.getId(), node);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodeidtab;
	}

	public List<NodeDetails> getNodeList(String columnname, List<Integer> nodeidlist) {
		// TODO Auto-generated method stub
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<NodeDetails> nodelist = null;
		try {
			tx = session.beginTransaction();
			String qry = "from NodeDetails where "+columnname+" in (:idlist)";
			Query query = session.createQuery(qry);
			query.setParameter("idlist", nodeidlist);
			nodelist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}


	public void updateNodelist(List<NodeDetails> ndetlist) {
		// TODO Auto-generated method stub
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		int ct = 0;
		try {
			tx = session.beginTransaction();
			for(NodeDetails ndet : ndetlist)
			{
				session.update(ndet);
				if(++ct%50 == 0)
				{
					session.flush();
					session.clear();
				}
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
	}

	public List<String> getSlnumberList(User user,boolean getUnderArea){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<String> slnumlist = new ArrayList<String>();
		try {
			tx = session.beginTransaction();
			String qry = "select slnumber from NodeDetails where status not in ('deleted')";
			qry = getCompleteQuery(user,qry,getUnderArea);
			Query query = session.createQuery(qry);
			if(user.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("slnumlist", user.getSlnumberlist());
				query.setParameter("arealist", user.getArealist());
			}
			else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			{
				if(getUnderArea)
					query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}
			slnumlist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return slnumlist;
	}
	public List<String> getAllSlnumberList(User user,boolean getUnderArea){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<String> slnumlist = new ArrayList<String>();
		try {
			tx = session.beginTransaction();
			String qry = "select slnumber from NodeDetails where status is not null";
			qry = getCompleteQuery(user,qry,getUnderArea);
			Query query = session.createQuery(qry);
			if(user.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("slnumlist", user.getSlnumberlist());
				query.setParameter("arealist", user.getArealist());
			}
			else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			{
				if(getUnderArea)
					query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}
			slnumlist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return slnumlist;
	}

	public int getDownCount(User user,String daytype)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<String> slnumlist = new ArrayList<String>();
		try {
			tx = session.beginTransaction();
			String qry = "select slnumber from NodeDetails nd where status not in ('deleted')";
			
			if(daytype.equals("yesterday"))
				qry = "select distinct(slnumber) from NodeDetails nd inner join M2MNodeOtages no on no.nodeid = nd.id where status not in ('deleted')";
				
			Date date = DateTimeUtil.getOnlyDate(new Date());
			if(daytype.equals("today"))
				qry += " and (status ='down' or status = 'inactive')";
			else
			{
				qry += " and no.downtime < '"+date+"' and (no.uptime >= '"+date+"' or no.uptime is null)";
			}
			qry = getCompleteQuery(user,qry,true);
			qry = qry.replace("organization", "nd.organization").replace("location", "nd.location").replace("slnumber", "nd.slnumber");
			Query query = session.createQuery(qry);
			if(user.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("slnumlist", user.getSlnumberlist());
				query.setParameter("arealist", user.getArealist());
			}
			else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			{
				query.setParameter("arealist", user.getArealist());
				query.setParameter("slnumlist", user.getSlnumberlist());
			}

			slnumlist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}

		return slnumlist.size();
	}

	public Hashtable<String, Integer> getConfigStatusTable(User user,String type)
	{
		Hashtable<String,Integer> configtable = new Hashtable<String, Integer>();
		Date date = DateTimeUtil.getOnlyDate(new Date());

		String query1 = "select slnumber from NodeDetails where (export='yes' or sendconfig='yes') and configinittime > '"+date+"'" ;
		String query2 = "select slnumber from NodeDetails where (export='no' or sendconfig='no') and (exportstatus = 1 or sendconfigstatus = 1) and configinittime > '"+date+"'";
		String query3 =	"select slnumber from NodeDetails where (export='no' or sendconfig='no') and (exportstatus = 2 or sendconfigstatus = 2) and configinittime> '"+date+"'";
		if(type.equals("upgrade"))
		{
			query1 = "select slnumber from NodeDetails where upgrade='yes' and upgradeinittime > '"+date+"'" ;
			query2 = "select slnumber from NodeDetails where upgrade='no' and upgradestatus = 1 and upgradeinittime > '"+date+"'";
			query3 = "select slnumber from NodeDetails where upgrade='no' and upgradestatus = 2 and upgradeinittime > '"+date+"'";

		}
		else if(type.equals("reboot"))
		{
			query1 = "select slnumber from NodeDetails where reboot='yes' and rebootinittime > '"+date+"'" ;
			query2 = "select slnumber from NodeDetails where reboot='no' and rebootstatus = 1 and rebootinittime > '"+date+"'";
			query3 = "select slnumber from NodeDetails where reboot='no' and rebootstatus = 2 and rebootinittime > '"+date+"'";
		}
		String qryarr[] = {query1,query2,query3};
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<Integer> list = new ArrayList<Integer>();
		ArrayList<Integer> retlist = new ArrayList<Integer>();
		try {
			tx = session.beginTransaction();
			String qry = getCompleteQuery(user,"",true);
			for(String query : qryarr)
			{
				Query hquery = session.createQuery(query+qry.replace("order by slnumber", "group by slnumber order by slnumber"));
				if(user.getRole().equals(UserRole.ADMIN))
				{
					hquery.setParameter("slnumlist", user.getSlnumberlist());
					hquery.setParameter("arealist", user.getArealist());
				}
				else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
				{
					hquery.setParameter("arealist", user.getArealist());
					hquery.setParameter("slnumlist", user.getSlnumberlist());
				}

				list =  (ArrayList<Integer>) hquery.getResultList();
				retlist.add(list.size());
			}
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}	
		configtable.put("inprogress", retlist.get(0));
		configtable.put("success", retlist.get(1));
		configtable.put("failed", retlist.get(2));
		return configtable;
	}
	public void setTaskStatusFailed(NodeDetails nd)
	{
		M2Mlogs log = new M2Mlogs();
		long curtime = Calendar.getInstance().getTimeInMillis();
		/*
		 * props = PropertiesManager.getM2MProperties(); read_timeout =
		 * props.getProperty("readtimeout")==null?read_timeout:Integer.parseInt(props.
		 * getProperty("readtimeout").trim());
		 */
		M2MlogsDao logdao = new M2MlogsDao();
		//System.out.println(nd.getConfiginittime() +" "+nd.getSendconfig());
		if(nd.getConfiginittime() != null && nd.getSendconfig().equals(YES_STR) &&(curtime-nd.getConfiginittime().getTime())/(1000*60) >= task_timeout)
		{
			nd.setSendconfig(NO_STR);
			nd.setSendconfigstatus(FAILED);
			nd.setBulkedit(0);
			log.setSlnumber(nd.getSlnumber());
			log.setNodeid(nd.getId());
			log.setUpdatetime(Calendar.getInstance().getTime());
			log.setLoginfo("Configuration:Failed");
			log.setSeverity(SeverityNames.WARNING);
			logdao.addM2MLog(log);
			updateNodeDetails(nd,"Edit","Fail");
		}
		if(nd.getConfiginittime() != null && nd.getExport().equals(YES_STR) && nd.getBulkupdate()==0 &&(curtime-nd.getConfiginittime().getTime())/(1000*60) >= task_timeout)
		{
			nd.setExport(NO_STR);
			nd.setExportstatus(FAILED);

			log.setSlnumber(nd.getSlnumber());
			log.setNodeid(nd.getId());
			log.setUpdatetime(Calendar.getInstance().getTime());
			log.setLoginfo("Export-Config:Failed");
			log.setSeverity(SeverityNames.WARNING);
			logdao.addM2MLog(log);
			updateNodeDetails(nd,"Export","Fail");
		}
		else if(nd.getConfiginittime() != null && nd.getExport().equals(YES_STR) && nd.getBulkupdate()==1 &&(curtime-nd.getConfiginittime().getTime())/(1000*60) >= task_timeout) 
		{
			nd.setBulkupdate(0); 
			nd.setExport(NO_STR);
			nd.setExportstatus(FAILED); 
			log.setSlnumber(nd.getSlnumber());
			log.setNodeid(nd.getId());
			log.setUpdatetime(Calendar.getInstance().getTime());
			log.setLoginfo("Bulk-Config:Failed");
			log.setSeverity(SeverityNames.WARNING);
			logdao.addM2MLog(log); updateNodeDetails(nd,"Bulk-Config","Fail");

		}
		if(nd.getRebootinittime() != null && nd.getReboot().equals(YES_STR) &&(curtime-nd.getRebootinittime().getTime())/(1000*60) >= task_timeout)	
		{
			nd.setReboot(NO_STR);
			nd.setRebootstatus(FAILED);
			log.setSlnumber(nd.getSlnumber());
			log.setNodeid(nd.getId());
			log.setUpdatetime(Calendar.getInstance().getTime());
			log.setLoginfo("Reboot:Failed");
			log.setSeverity(SeverityNames.WARNING);
			logdao.addM2MLog(log);
			updateNodeDetails(nd,"Reboot","Fail");
		}
		if(nd.getUpgradeinittime() != null && nd.getUpgrade().equals(YES_STR) )	
		{
			if((nd.getUpgradestarttime() != null && (curtime-nd.getUpgradestarttime().getTime())/(1000*60) >=upgrade_timeout)
				|| nd.getStatus().equals(NodeStatus.DOWN) && (curtime - nd.getDowntime().getTime())/(1000*60) >= task_timeout)
			{
				nd.setUpgrade(NO_STR);
				nd.setUpgradestatus(FAILED);
				nd.setUpgradestarttime(null);
				log.setSlnumber(nd.getSlnumber());
				log.setNodeid(nd.getId());
				log.setUpdatetime(Calendar.getInstance().getTime());
				log.setLoginfo("Firmware-Upgrade:Failed");
				log.setSeverity(SeverityNames.WARNING);
				logdao.addM2MLog(log);
				updateNodeDetails(nd,"Upgrade","Fail");
			}
		}
		
	}
	
	public void setTaskStatusFailed(int timeout)
	{
		List<NodeDetails> confignodelist = getNodelist(CONFIG);
		List<NodeDetails> exportnodelist =getNodelist(EXPORT);
		List<NodeDetails> rebootnodelist = getNodelist(REBOOT);
		List<NodeDetails> upgradenodelist = getNodelist(UPGRADE);
		
		for(NodeDetails confnode : confignodelist)
			setTaskStatusFailed(confnode);
		for(NodeDetails exportnode : exportnodelist)
			setTaskStatusFailed(exportnode);
		for(NodeDetails rebnode : rebootnodelist)
			setTaskStatusFailed(rebnode);
		for(NodeDetails upgnode : upgradenodelist)
			setTaskStatusFailed(upgnode);
		
	}
	public void setTaskStatusFailed()
	{
		List<NodeDetails> confignodelist = getNodelist(CONFIG);
		List<NodeDetails> exportnodelist =getNodelist(EXPORT);
		List<NodeDetails> rebootnodelist = getNodelist(REBOOT);
		List<NodeDetails> upgradenodelist = getNodelist(UPGRADE);
		M2Mlogs log = new M2Mlogs();
		M2MlogsDao logdao = new M2MlogsDao();
		if(confignodelist != null)
		{
			for(NodeDetails confnode : confignodelist)
			{
				//if(confnode.getConfiginittime() != null && (curtime-confnode.getConfiginittime().getTime())/(1000*60) > read_timeout && confnode.getSendconfig().equals(YES_STR))
				if(confnode.getConfiginittime() != null && confnode.getSendconfig().equals(YES_STR))
				{
					confnode.setSendconfig(NO_STR);
					confnode.setSendconfigstatus(FAILED);
					confnode.setBulkedit(0);
					log.setSlnumber(confnode.getSlnumber());
					log.setNodeid(confnode.getId());
					log.setUpdatetime(Calendar.getInstance().getTime());
					log.setLoginfo("Configuration:Failed");
					log.setSeverity(SeverityNames.WARNING);
					logdao.addM2MLog(log);
					updateNodeDetails(confnode,"Edit","Fail");
				}
			}
		}
		if(exportnodelist != null)
		{
			for(NodeDetails expnode : exportnodelist)
			{
				//if(expnode.getConfiginittime() != null && (curtime-expnode.getConfiginittime().getTime())/(1000*60) > read_timeout && expnode.getExport().equals(YES_STR) && expnode.getBulkupdate()==0)
				if(expnode.getConfiginittime() != null && expnode.getExport().equals(YES_STR) && expnode.getBulkupdate()==0)
				{
					expnode.setExport(NO_STR);
					expnode.setExportstatus(FAILED);

					log.setSlnumber(expnode.getSlnumber());
					log.setNodeid(expnode.getId());
					log.setUpdatetime(Calendar.getInstance().getTime());
					log.setLoginfo("Export-Config:Failed");
					log.setSeverity(SeverityNames.WARNING);
					logdao.addM2MLog(log);
					updateNodeDetails(expnode,"Export","Fail");
				}

				//else if(expnode.getConfiginittime() != null && (curtime-expnode.getConfiginittime().getTime())/(1000*60) > read_timeout && expnode.getExport().equals(YES_STR) && expnode.getBulkupdate()==1) 
				else if(expnode.getConfiginittime() != null && expnode.getExport().equals(YES_STR) && expnode.getBulkupdate()==1) 
				{
					expnode.setBulkupdate(0); 
					expnode.setExport(NO_STR);
					expnode.setExportstatus(FAILED); 
					log.setSlnumber(expnode.getSlnumber());
					log.setNodeid(expnode.getId());
					log.setUpdatetime(Calendar.getInstance().getTime());
					log.setLoginfo("Bulk-Config:Failed");
					log.setSeverity(SeverityNames.WARNING);
					logdao.addM2MLog(log); 
					updateNodeDetails(expnode,"Bulk-Config","Fail");

				}

			}
		}
		if(rebootnodelist != null)
		{
			for(NodeDetails rebootnode : rebootnodelist)
			{
				//if(rebootnode.getRebootinittime() != null && (curtime-rebootnode.getRebootinittime().getTime())/(1000*60) > read_timeout && rebootnode.getReboot().equals(YES_STR))
				if(rebootnode.getRebootinittime() != null && rebootnode.getReboot().equals(YES_STR))	
				{
					rebootnode.setReboot(NO_STR);
					rebootnode.setRebootstatus(FAILED);
					log.setSlnumber(rebootnode.getSlnumber());
					log.setNodeid(rebootnode.getId());
					log.setUpdatetime(Calendar.getInstance().getTime());
					log.setLoginfo("Reboot:Failed");
					log.setSeverity(SeverityNames.WARNING);
					logdao.addM2MLog(log);
					updateNodeDetails(rebootnode,"Reboot","Fail");
				}
			}
		}
		if(upgradenodelist != null)
		{
			for(NodeDetails upgradenode : upgradenodelist)
			{
				//if(upgradenode.getUpgradeinittime() != null && (curtime-upgradenode.getUpgradeinittime().getTime())/(1000*60) > read_timeout && upgradenode.getUpgrade().equals(YES_STR))
				if(upgradenode.getUpgradeinittime() != null && upgradenode.getUpgrade().equals(YES_STR))	
				{
					upgradenode.setUpgrade(NO_STR);
					upgradenode.setUpgradestatus(FAILED);
					upgradenode.setUpgradestarttime(null);
					log.setSlnumber(upgradenode.getSlnumber());
					log.setNodeid(upgradenode.getId());
					log.setUpdatetime(Calendar.getInstance().getTime());
					log.setLoginfo("Firmware-Upgrade:Failed");
					log.setSeverity(SeverityNames.WARNING);
					logdao.addM2MLog(log);
					updateNodeDetails(upgradenode,"Upgrade","Fail");
				}
			}
		}
	}
	private List<NodeDetails> getNodelist(int type) {
		// TODO Auto-generated method stub
		List<NodeDetails> nodelist = new ArrayList<NodeDetails>();
		Session session = HibernateSession.getDBSession();
		try {
			String qry = "from NodeDetails where";
			switch(type)
			{
			case 1:
				qry += " sendconfig = 'yes'";
				break;
			case 2:
				qry += " export = 'yes'";
				break;
			case 3:
				qry +=" reboot = 'yes'";
				break;
			case 4:
				qry +=" upgrade = 'yes'";
				break;
			}
			Query query = session.createQuery(qry);
			nodelist = query.getResultList();
		} catch (Exception e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return nodelist;
	}

	public void updateNodedetailsMap(List<NodeDetails> nodelist) {
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			//List<NodeDetails> nodedetlist = (List<NodeDetails>) nodeidtable.values();
			for(int i=0;i<nodelist.size();i++)
			{
				NodeDetails node = nodelist.get(i);
				session.update(node);
				if (i % 100 == 0) {//a batch size for safety
		            session.flush();
		            session.clear();
		        }
			}
			tx.commit();
		}catch (Exception e) {
			tx.rollback();
			e.printStackTrace();
		}
		finally {
			
			session.close();
		}
	}

	public int getFwProgressCount() {
		// TODO Auto-generated method stub
		int count = 0;
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			Query query = session.createQuery("from NodeDetails where upgradestarttime is not null and status = 'up' ");
			//query.setParameter("time", null);
			List<NodeDetails> nodelist = query.getResultList();
			count = nodelist.size();
			tx.commit();
		} 
		catch (NoResultException e) {
			if (tx!=null) tx.rollback();
		}
		catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return count;
	}
}