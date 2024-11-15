package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.nomus.m2m.pojo.DataUsage;
import com.nomus.m2m.pojo.User;

public class DataUsageDao {
	public int addDataUsage(DataUsage data)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		int id = -1;
		try {
			tx = session.beginTransaction();
			session.save(data);
			id = data.getId();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
			
		} finally {
			session.close();
		}   
		return id;
	}
	public boolean updateDataUsage(DataUsage data)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(data);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
			return false;
		} finally {
			session.close();
		}   
		return true;
	}
	public DataUsage getDataUsage(String columnname, String value ){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		DataUsage ndobj = null;
		try {
			tx = session.beginTransaction();
			Query query = session.createQuery("from DataUsage where "+columnname+"='"+value+"'");
			query.setMaxResults(1);
			List<DataUsage> nodelist = query.getResultList();
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
	public List<DataUsage> getDataUsageList(String columnname,String startrange,String endrange,User user) {
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<DataUsage> datalist = new ArrayList<DataUsage>();
		try {
			tx = session.beginTransaction();
			String qrystring = "from DataUsage where "+columnname+" between '"+startrange+"' and '"+endrange+"' and "+
			                    columnname+" in :slnumlist order by slnumber";
			Query query = session.createQuery(qrystring);
			NodedetailsDao nddao = new NodedetailsDao();
			List<String> slnumlist = nddao.getSlnumberList(user,false);
			if(slnumlist.size()>0) {
				query.setParameter("slnumlist", slnumlist);
				datalist = query.getResultList();
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return datalist;
	}
	public List<DataUsage> getDataUsageList(String columnname,User user) {
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<DataUsage> datalist = new ArrayList<DataUsage>();
		try {
			tx = session.beginTransaction();
			String qrystring = "from DataUsage where "+columnname+" in :slnumlist order by slnumber";
			Query query = session.createQuery(qrystring);
			NodedetailsDao nddao = new NodedetailsDao();
			List<String> slnumlist = nddao.getSlnumberList(user,false);
			if(slnumlist.size() > 0)
			{	
				query.setParameter("slnumlist", slnumlist);
				datalist = query.getResultList();
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return datalist;
	}

}
