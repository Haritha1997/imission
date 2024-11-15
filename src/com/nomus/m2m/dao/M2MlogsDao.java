package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.nomus.m2m.pojo.M2Mlogs;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.DateTimeUtil;
import com.nomus.staticmembers.UserRole;


public class M2MlogsDao {

	public int totalEvents = 0;
	public M2MlogsDao()
	{

	}

	public int getTotalEvents() {
		return totalEvents;
	}

	public void setTotalEvents(int totalEvents) {
		this.totalEvents = totalEvents;
	}

	/* Method to CREATE an employee in the database */
	public Integer addM2MLog(M2Mlogs log){
		Transaction tx = null;
		int logid = 0;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			logid = (Integer) session.save(log);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return logid;
	}

	public M2Mlogs getM2MLog(String columnname, String value ){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		M2Mlogs log = null;
		try {
			tx = session.beginTransaction();
			// Criteria criteria = session.createCriteria(M2Mlogs.class);
			//criteria.setMaxResults(1);
			//log = (M2Mlogs)criteria.add(Restrictions.eq(columnname, value)).uniqueResult();
			Query<M2Mlogs> query = session.createQuery("from M2Mlogs where "+columnname+"='"+value+"'");
			query.setMaxResults(1);
			log = query.getSingleResult();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return log;
	}

	public List<M2Mlogs> getEventList(User curuser,HashMap<String, String> params)
	{
		Transaction tx = null;
		List<M2Mlogs> eventlist = new ArrayList<M2Mlogs>();
		Session session = HibernateSession.getDBSession();
		HashMap<String, Date> date_hm = new HashMap<String, Date>();
		try {
			tx = session.beginTransaction();
			Set<String> paramset = params.keySet();
			/*String qry = "from M2Mlogs where organization = :org";
			if(curuser.getRole().equals(UserRole.MAINADMIN))
				qry = "from M2Mlogs where id not in (-1) ";
			else if(curuser.getRole().equals(UserRole.ADMIN))
				qry += " and location in (:loc)";
			else if(curuser.getRole().equals(UserRole.SUPERVISOR) || curuser.getRole().equals(UserRole.MONITOR))
				qry += " and location in (:loc) or slnumber in (:slnumlist)";*/
			UserDao userdao = new UserDao();
			List<User> userlist =  userdao.getUsersListUnderCurrentUser(curuser);
				
			String qry = "from M2Mlogs where (slnumber in (:slnumlist)";
			String countqry =  "select count(id) from M2Mlogs where (slnumber in (:slnumlist)";
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
			{
				countqry += " or generatedBy in (:genlist))";
				qry += " or generatedBy in (:genlist))";
			}
			else if(curuser.getRole().equals(UserRole.ADMIN))
			{
				countqry += " or generatedTo = :generatedto or generatedTo in (:gentolist) or generatedBy = :generated or generatedBy in (:genlist))";
				qry += " or generatedTo = :generatedto or generatedTo in (:gentolist) or generatedBy = :generated or generatedBy in (:genlist))";
			}
			else if(curuser.getRole().equals(UserRole.SUPERVISOR) || curuser.getRole().equals(UserRole.MONITOR))
			{
				countqry += " or generatedTo = :generatedto or generatedBy = :generated)";
				qry += " or generatedTo = :generatedto or generatedBy = :generated)";
			}
			
			NodedetailsDao ndao = new NodedetailsDao();
			List<String> slnumlist = ndao.getSlnumberList(curuser,true);
			
			for(String key : paramset)
			{
				if(key.equals("fromdate") && params.get(key).length() > 0 )
				{
					countqry += " and updatetime >= :"+key;
					qry += " and updatetime >= :"+key;
					date_hm.put(key,DateTimeUtil.getDate(params.get(key)));
				}
				else if(key.equals("todate") && params.get(key).length() > 0)
				{
					countqry += " and updatetime <= :"+key;
					qry += " and updatetime <= :"+key;
					date_hm.put(key,DateTimeUtil.getNextDate(params.get(key)));
				}
				else if(key.equals("slnumber") && params.get(key).length() > 0)
				{
					countqry += " and slnumber ='"+params.get(key)+"'";
					qry += " and slnumber ='"+params.get(key)+"'";
				}
			}
			qry +=" order by "+params.get("sortby")+" "+params.get("sorttype")+",id desc";
			//qry += " order by "+params.get("sortby")+" "+params.get("sorttype");
			//System.out.println("query is : "+qry);
			Query query =  session.createQuery(qry);
			Query qty_query =  session.createQuery(countqry,Long.class);
			
			//Hibernate.initialize(curuser.getArealist());
			//Hibernate.initialize(curuser.getSlnumberlist());
			
			
			/*if(curuser.getRole().equals(UserRole.SUPERADMIN))
				query.setParameter("org", curuser.getOrganization().getName());
			else if(curuser.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("org", curuser.getOrganization().getName());
				query.setParameter("loc", curuser.getArealist()==null?new ArrayList<String>():curuser.getArealist());
			}
			else if(curuser.getRole().equals(UserRole.SUPERVISOR) || curuser.getRole().equals(UserRole.MONITOR))
			{
				query.setParameter("org", curuser.getOrganization().getName());
				query.setParameter("loc", curuser.getArealist()==null?new ArrayList<String>():curuser.getArealist());
				query.setParameter("slnumlist", curuser.getSlnumberlist()==null?new ArrayList<String>():curuser.getSlnumberlist());
			}*/
			
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
			{
				qty_query.setParameter("genlist", userlist);
				query.setParameter("genlist", userlist);
			}
			else if(curuser.getRole().equals(UserRole.ADMIN))
			{
				qty_query.setParameter("generated", curuser);
				qty_query.setParameter("gentolist", userlist);
				qty_query.setParameter("generatedto", curuser);
				qty_query.setParameter("genlist", userlist);
				
				query.setParameter("generated", curuser);
				query.setParameter("gentolist", userlist);
				query.setParameter("generatedto", curuser);
				query.setParameter("genlist", userlist);
			}
			else if(curuser.getRole().equals(UserRole.SUPERVISOR) || curuser.getRole().equals(UserRole.MONITOR))
			{
				qty_query.setParameter("generatedto", curuser);
				qty_query.setParameter("generated", curuser);
				
				query.setParameter("generatedto", curuser);
				query.setParameter("generated", curuser);
			}
			qty_query.setParameter("slnumlist", slnumlist.size() > 0 ?slnumlist:"''");
			query.setParameter("slnumlist", slnumlist.size() > 0 ?slnumlist:"''");
			for(String key : date_hm.keySet())
			{
				qty_query.setParameter(key, date_hm.get(key));
				query.setParameter(key, date_hm.get(key));
			}
			//setTotalEvents(query.getResultList().size());
			try
			{
				setTotalEvents((int)(long)qty_query.getSingleResult());
			}
			catch (Exception e) {
				// TODO: handle exception
				setTotalEvents(0);
			}
			query.setFirstResult(Integer.parseInt(params.get("limit"))*(Integer.parseInt(params.get("pageno"))-1));
			query.setMaxResults(Integer.parseInt(params.get("limit")));
			eventlist = query.list();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return eventlist;
	}

}