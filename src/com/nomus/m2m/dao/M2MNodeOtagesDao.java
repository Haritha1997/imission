package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.persister.entity.Queryable;
import org.hibernate.query.Query;

import com.nomus.m2m.main.SeverityNames;
import com.nomus.m2m.pojo.M2MNodeOtages;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.DateTimeUtil;



public class M2MNodeOtagesDao {
	NodedetailsDao ndcontroller;
	public int totalAlarms = 0;
	public M2MNodeOtagesDao()
	{
		ndcontroller = new NodedetailsDao();	   
	}

	public int getTotalAlarms() {
		return totalAlarms;
	}

	public void setTotalAlarms(int totalAlarms) {
		this.totalAlarms = totalAlarms;
	}

	/* Method to CREATE an employee in the database */
	public Integer addM2MNodeOtages(M2MNodeOtages log){
		Transaction tx = null;
		int logid = 0;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			logid = (Integer) session.save(log);
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return logid;
	}

	public M2MNodeOtages getM2MNodeOtages(String columnname, String value ){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		M2MNodeOtages outage = null;
		try {
			tx = session.beginTransaction();
			//Criteria criteria = session.createCriteria(M2MNodeOtages.class);
			//criteria.setMaxResults(1);
			//outage = (M2MNodeOtages)criteria.add(Restrictions.eq(columnname, value)).uniqueResult();
			Query<M2MNodeOtages> query = session.createQuery("from M2MNodeOtages where "+columnname+"='"+value+"'");
			query.setMaxResults(1);
			outage = query.getSingleResult();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return outage;
	}
	/*public void clearPastUnclearedAlarms(String slnumber)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<M2MNodeOtages> outagelist = new ArrayList<M2MNodeOtages>();
		try {
			tx = session.beginTransaction();
			Query query = session.createQuery("from M2MNodeOtages where severity in ('"+SeverityNames.MAJOR+"','"+SeverityNames.CRITICAL+"') and slnumber='"+slnumber+"' and uptime is null order by id desc");
			outagelist = (M2MNodeOtages) query.getSingleResult();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
	}*/
	public M2MNodeOtages getLastM2MNodeOtage(String columnname, String value){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		M2MNodeOtages outage = null;
		try {
			tx = session.beginTransaction();
			Query<M2MNodeOtages> query = session.createQuery("from M2MNodeOtages where severity in ('"+SeverityNames.CRITICAL+"') and "+columnname+"='"+value+"' and alarmInfo like 'Node is Down%' and uptime is null order by id desc");

			List<M2MNodeOtages> outagelist= query.getResultList();
			if(outagelist.size() > 0)
				outage = outagelist.get(0);
				tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return outage;
	}
	public M2MNodeOtages getLastM2MDioOtage(String columnname, String value, String dioname){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		M2MNodeOtages outage = null;
		try {
			tx = session.beginTransaction();
			Query<M2MNodeOtages> query = session.createQuery("from M2MNodeOtages where severity in ('"+SeverityNames.MAJOR+"') and "+columnname+"='"+value+"' and alarmInfo like '"+dioname+"%' and uptime is null order by id desc");
			outage = query.getSingleResult();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return outage;
	}
	public void updateM2MNodeOtage(M2MNodeOtages outage)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(outage);
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}
	}
	public boolean setAllUpNodesDown() {
		// TODO Auto-generated method stub
		try
		{
			List<NodeDetails> nodes = ndcontroller.getNodeList("status","up");
			M2MNodeOtagesDao outagedao = new M2MNodeOtagesDao();
			for(NodeDetails node : nodes)
			{
				M2MNodeOtages lastoutage  = outagedao.getLastOutage(node.getId());
				if(lastoutage != null && lastoutage.getUptime() == null)
					continue;
				M2MNodeOtages outage  = new M2MNodeOtages();
				outage.setSlnumber(node.getSlnumber());
				outage.setNodeid(node.getId());
				Date date = Calendar.getInstance().getTime();
				outage.setDowntime(date);
				outage.setUpdateTime(date);
				outage.setAlarmInfo("Node is Down");
				outage.setSeverity(SeverityNames.CRITICAL);
				addM2MNodeOtages(outage);
			}
			return true;
		}
		catch (Exception e) {
			// TODO: handle exception
			return false;
		}
	}
	public M2MNodeOtages getLastOutage(int nodeid) {
		// TODO Auto-generated method stub
		M2MNodeOtages outage = null;
		Transaction tx = null;
		List<M2MNodeOtages> alarmList = new ArrayList<M2MNodeOtages>();
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			String qry = "from  M2MNodeOtages where nodeid ="+nodeid+" and (severity ='"+SeverityNames.MAJOR+"' or severity ='"+SeverityNames.CRITICAL+"') and alarmInfo like 'Node is Down%' order by id desc";
			Query<M2MNodeOtages> query = session.createQuery(qry);
			query.setMaxResults(1);
			alarmList = query.list();
			if(alarmList.size() > 0)
				outage = alarmList.get(0);
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return outage;	
	}
	public M2MNodeOtages getLastDeleted(int nodeid) {
		// TODO Auto-generated method stub
		M2MNodeOtages outage = null;
		Transaction tx = null;
		List<M2MNodeOtages> alarmList = new ArrayList<M2MNodeOtages>();
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			String qry = "from  M2MNodeOtages where nodeid ="+nodeid+" and severity ='"+SeverityNames.WARNING+"' order by id desc";
			Query<M2MNodeOtages> query = session.createQuery(qry);
			query.setMaxResults(1);
			alarmList = query.list();
			if(alarmList.size() > 0)
				outage = alarmList.get(0);
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return outage;	
	}

	public List<M2MNodeOtages> getAlarmsList(User curuser,HashMap<String, String> params)
	{
		Transaction tx = null;
		List<M2MNodeOtages> alarmList = new ArrayList<M2MNodeOtages>();
		Session session = HibernateSession.getDBSession();
		HashMap<String, Date> date_hm = new HashMap<String, Date>();
		try {
			tx = session.beginTransaction();
			Set<String> paramset = params.keySet();
			String count_qry = "select count(id) from M2MNodeOtages where slnumber in (:slnumlist)";
			String qry = "from  M2MNodeOtages where slnumber in (:slnumlist)";
			NodedetailsDao ndao = new NodedetailsDao();
			List<String> slnumlist = ndao.getAllSlnumberList(curuser,true);
			for(String key : paramset)
			{
				if(key.equals("fromdate") && params.get(key).length() > 0 )
				{
					count_qry += " and (downtime >= :"+key+" or updateTime >= :"+key+")";
					qry += " and (downtime >= :"+key+" or updateTime >= :"+key+")";
					date_hm.put(key,DateTimeUtil.getDate(params.get(key)));
				}
				else if(key.equals("todate") && params.get(key).length() > 0 )
				{
					count_qry += " and (uptime <= :"+key+" or updateTime <= :"+key+")";
					qry += " and (uptime <= :"+key+" or updateTime <= :"+key+")";
					date_hm.put(key,DateTimeUtil.getNextDate(params.get(key)));
				}
				else if(key.equals("slnumber") && params.get(key).length() > 0 )
				{
					count_qry += " and slnumber ='"+params.get(key)+"'";
					qry += " and slnumber ='"+params.get(key)+"'";
				}
			}
			qry += " order by "+params.get("sortby")+" "+params.get("sorttype")+",id desc";
			Query query = session.createQuery(qry);
			Query qty_query = session.createQuery(count_qry,Long.class);
			if(slnumlist.size() == 0)
			{
				query.setParameter("slnumlist", "");
				qty_query.setParameter("slnumlist", "");
			}
			else
			{
				query.setParameter("slnumlist", slnumlist);
				qty_query.setParameter("slnumlist", slnumlist);
			}
			for(String key : date_hm.keySet())
			{
				qty_query.setParameter(key, date_hm.get(key));
				query.setParameter(key, date_hm.get(key));
			}
			setTotalAlarms((int)(long)qty_query.getSingleResult());
			query.setFirstResult(Integer.parseInt(params.get("limit"))*(Integer.parseInt(params.get("pageno"))-1));
			query.setMaxResults(Integer.parseInt(params.get("limit")));
			alarmList = query.list();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return alarmList;
	} 
	public List<M2MNodeOtages> getAlarmsList(User user)
	{
		HashMap<String, String> params = new HashMap<String, String>();
		params.put("limit", "20");
		params.put("pageno", "1");
		params.put("sortby", "updatetime");
		params.put("sorttype", "desc");

		return getAlarmsList(user,params);
	}
	public void addM2MNodeOtagesList(List<M2MNodeOtages> alarmlist) {
		// TODO Auto-generated method stub
		Transaction tx = null;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			int i=0;
			for(M2MNodeOtages  alarm : alarmlist)
			{
				session.save(alarm);
				i++;
				if(i%100==0)
				{
					session.flush();
					session.clear();
				}
			}
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
	}
	public M2MNodeOtages getLastDeviceAlaramOtage(String slnumber,String columnname,String alaraminfo){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		M2MNodeOtages outage = null;
		try {
			tx = session.beginTransaction();
			@SuppressWarnings("unchecked")
			Query<M2MNodeOtages> query = session.createQuery("from M2MNodeOtages where slnumber in ('"+slnumber+"')and severity in ('"+SeverityNames.MAJOR+"') and alarmInfo like '"+alaraminfo+"' order by updatetime desc");
			outage = query.setMaxResults(1).uniqueResult();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return outage;
	}

	public boolean isAlarmExists(M2MNodeOtages outage,Date updatetime) {
		// TODO Auto-generated method stub
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		boolean isexists=false;
		List<M2MNodeOtages>outagelist=null;
		try {
			tx = session.beginTransaction();
			@SuppressWarnings("unchecked")
			String qry="from M2MNodeOtages where slnumber in ('"+outage.getSlnumber()+"') "
					+ "and alarmInfo in ('"+outage.getAlarmInfo()+"') and updatetime =:alarmtime order by updatetime desc";
			Query<M2MNodeOtages> query = session.createQuery(qry);
			query.setParameter("alarmtime", updatetime);
			outagelist=query.getResultList();
			if(outagelist.size()>0)
				isexists=true;
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return isexists;
	}
}