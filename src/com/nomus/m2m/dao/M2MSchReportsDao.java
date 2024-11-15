package com.nomus.m2m.dao;

import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;

import com.nomus.m2m.pojo.M2MSchReports;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.UserRole;



public class M2MSchReportsDao {

	public M2MSchReportsDao()
	{
	}
	public List<M2MSchReports> getM2MSchReports(){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<M2MSchReports> reportlist = null;
		try {
			tx = session.beginTransaction();

			Query query = session.createQuery("from M2MSchReports");
			reportlist = (List<M2MSchReports>)query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return reportlist;
		
	}
	public List<M2MSchReports> getM2MSchReports(User user){
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		List<M2MSchReports> reportlist = null;
		try {
			tx = session.beginTransaction();
			String qry = "from M2MSchReports where";
			qry = getActivityQuery(user,qry);
			Query query = session.createQuery(qry);
			reportlist = (List<M2MSchReports>)query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return reportlist;
		
	}

	private String getActivityQuery(User user, String qry) {
		if(!user.getRole().equals(UserRole.MAINADMIN))
			qry += " organization ='"+user.getOrganization().getName()+"'";
		if(user.getRole().equals(UserRole.ADMIN))
			qry += " and user ="+user.getId()+" or superior="+user.getId();
		else if(user.getRole().equals(UserRole.SUPERVISOR) || user.getRole().equals(UserRole.MONITOR))
			qry += " and user = "+user.getId();
		return qry;
	}
	public void updateReport(M2MSchReports report)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(report);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}
	}

	public void saveReport(M2MSchReports report)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.save(report);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}
	}


	public void deleteSchduleReports(String ids) {
		// TODO Auto-generated method stub
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry = "delete from m2mschreports where id in('" + ids + "')";
			NativeQuery nqry =  session.createNativeQuery(qry);
			nqry.executeUpdate();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close(); 
		}
	}

}