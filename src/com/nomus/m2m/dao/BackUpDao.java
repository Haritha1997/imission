package com.nomus.m2m.dao;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.nomus.m2m.pojo.BackUp;


public class BackUpDao {
	public Integer addBackup(BackUp bkpobj){
		Transaction tx = null;
		int bkpid = -1;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			bkpid = (Integer) session.save(bkpobj);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return bkpid;
	}
	public boolean updateBackup(BackUp bkpobj)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		boolean done = false;
		try {
			tx = session.beginTransaction();
			session.update(bkpobj);
			tx.commit();
			done = true;
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}
		return done;
	}

	public List<BackUp> getBackupList()
	{
		List<BackUp> backuplist = new ArrayList<BackUp>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from BackUp order by id";
			Query query = session.createQuery(qry);
			backuplist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return backuplist;
	}
}


