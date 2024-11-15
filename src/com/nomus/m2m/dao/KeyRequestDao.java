package com.nomus.m2m.dao;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.KeyRequest;

public class KeyRequestDao {
	public int addKeyRequest(KeyRequest key)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		int id = -1;
		try {
			tx = session.beginTransaction();
			session.save(key);
			id = key.getId();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
			
		} finally {
			session.close();
		}   
		return id;
	}
	public boolean updateKeyRequest(KeyRequest key) {
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(key);
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
	public KeyRequest getKeyRequest(String organizationname)
	{
		Session session = HibernateSession.getDBSession();
		KeyRequest req = null;
		try {
			Query query =  session.createQuery("from User where orgname=:orgname", KeyRequest.class);
			query.setParameter("orgname", organizationname);
			try
			{
				req = (KeyRequest) query.getSingleResult();
			}
			catch (NoResultException  e) {
				// TODO: handle exception
			}
		} catch (HibernateException e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return req;
	}
}
