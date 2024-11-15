package com.nomus.m2m.dao;


import javax.persistence.Query;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.Organization;

public class LoadBatchDao {

	public boolean isBatchExists(String batchname,Organization org)
	{
		boolean is_exists = false;
		Session session = HibernateSession.getDBSession();
		try {
			Query query = session.createQuery("from LoadBatch where batchName=:batchname and organization=:org");
			query.setParameter("batchname", batchname);
			query.setParameter("org", org);
			if(query.getResultList().size() > 0)
				is_exists = true;
		} catch (Exception e) {
			e.printStackTrace(); 
			return false;
		} finally {
			session.close();
		}   
		return is_exists;
	}
	
	public boolean addLoadBatch(LoadBatch batch)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.save(batch);
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
			return false;
		} finally {
			session.close();
		}   
		return true;
	}
	public boolean updateLoadBatch(LoadBatch batch)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(batch);
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
			return false;
		} finally {
			session.close();
		}   
		return true;
	}
	public LoadBatch getLoadBatch(int batchid)
	{
		Session session = HibernateSession.getDBSession();
		LoadBatch batchobj = null;
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			Query qry = session.createQuery("from LoadBatch where id=:id");
			qry.setParameter("id", batchid);
			batchobj = (LoadBatch) qry.getSingleResult();
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}   
		return batchobj;
	}
}
