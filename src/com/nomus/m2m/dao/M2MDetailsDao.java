package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.M2MDetails;

public class M2MDetailsDao {
	public boolean addM2MDetails(M2MDetails m2mdata) {
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.save(m2mdata);
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
	public boolean updateM2MDetails(M2MDetails m2mdata) {
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(m2mdata);
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
	public List<M2MDetails> getM2MDetailsList()
	{
		List<M2MDetails> m2mlist = new ArrayList<M2MDetails>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from M2MDetails order by id";
			Query query = session.createQuery(qry);
			m2mlist = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return m2mlist;
	}
	public M2MDetails getM2MDetails(int id)
	{
		Session session = HibernateSession.getDBSession();
		M2MDetails m2mdata=null;
		try {
			Query query =  session.createQuery("from M2MDetails where id=:id", M2MDetails.class);
			query.setParameter("id", id);
			try
			{
				m2mdata = (M2MDetails) query.getSingleResult();
			}
			catch (NoResultException  e) {
				// TODO: handle exception
			}
		} catch (HibernateException e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return m2mdata;
	}
}
