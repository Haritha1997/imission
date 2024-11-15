package com.nomus.m2m.dao;


import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.nomus.m2m.pojo.BulkActivity;
import com.nomus.m2m.pojo.BulkActivityDetails;


public class BulkActivityDetDao {

	public BulkActivityDetDao()
	{

	}
	/* Method to CREATE an employee in the database */
	public Integer addBulkConfigDetails(BulkActivityDetails bcdet){
		Transaction tx = null;
		int rowid = 0;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			rowid = (Integer) session.save(bcdet);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return rowid;
	}

	public boolean UpdateBulkConfigDetails(BulkActivityDetails bcdet,Session session){
		boolean updated = true;
		//Session session = HibernateSession.getDBSession();
		try {
			//tx = session.beginTransaction();
			session.update(bcdet);
			// tx.commit();
		} catch (HibernateException e) {
			//if (tx!=null) tx.rollback();
			updated = false;
			e.printStackTrace(); 
		} finally {
			//session.close();
		}
		return updated;
	}
	public List<BulkActivityDetails> getBulkConfigDetailsList(String columnname, String value ){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<BulkActivityDetails> retlist = null;
		try {
			tx = session.beginTransaction();
			String hql = "FROM BulkActivityDetails bg where bg."+columnname+"=:value ORDER BY bg.configtime";
			Query<BulkActivityDetails> query = session.createQuery(hql);
			query.setParameter("value", value);
			retlist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return retlist;
	}
	public List<BulkActivityDetails> getBulkConfigDetailsList(String columnname, String value,Session session,String type ){
		//Session session = HibernateSession.getDBSession();
		//Transaction tx = null;
		List<BulkActivityDetails> retlist = null;
		try {
			// tx = session.beginTransaction();
			//criteria.setMaxResults();
			String hql = "FROM BulkActivityDetails bg where bg."+columnname+"=:value and bg.configtype=:type ORDER BY bg.configtime";
			Query<BulkActivityDetails> query = session.createQuery(hql);
			query.setParameter("value", value);
			query.setParameter("type", type);
			retlist = query.getResultList();
			// tx.commit();
		} catch (HibernateException e) {
			//if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			//session.close();
		}
		return retlist;
	}
	public List<BulkActivityDetails> getInProgresBCDList(BulkActivity bact, Session session) {
		// TODO Auto-generated method stub
		List<BulkActivityDetails> retlist = null;
		Query<BulkActivityDetails> query = session.createQuery("from BulkActivityDetails bcd where bcd.bulkActivity=:bact and bcd.status=:status");

		query.setParameter("bact", bact);
		query.setParameter("status", "InProgress");

		retlist = query.list();

		return retlist;
	}

}