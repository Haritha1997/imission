package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.Organization;
import com.nomus.staticmembers.DateTimeUtil;

public class OrganizationDao {
	public static int datediff = 30;
	public OrganizationDao()
	{
	}
	public boolean addOrganization(Organization Organization)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.save(Organization);
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
	public boolean updateOrganization(Organization Organization)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(Organization);
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
	public Organization getOrganization(String Organizationname)
	{
 		Session session = HibernateSession.getDBSession();
		Organization Organization=null;
		try {
			Query query =  session.createQuery("from Organization where name=:Organizationname", Organization.class);
			query.setParameter("Organizationname", Organizationname);
			try
			{
				Organization = (Organization) query.getSingleResult();
			}
			catch (NoResultException  e) {
				// TODO: handle exception
				return null;
			}
		} catch (HibernateException e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return Organization;
	}
	public Organization getOrganization(int id)
	{
		Session session = HibernateSession.getDBSession();
		Organization Organization=null;
		try {
			Query query =  session.createQuery("from Organization where id=:id", Organization.class);
			query.setParameter("id", id);
			try
			{
				Organization = (Organization) query.getSingleResult();
			}
			catch (NoResultException  e) {
				// TODO: handle exception
			}
		} catch (HibernateException e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return Organization;
	}
	public boolean deleteOrganization(Organization Organization)  // dont use this method to delete organization
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.delete(Organization);
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
	public List<Organization> getOrganizationsList(String type)
	{
		List<Organization> OrganizationliList  = new ArrayList<Organization>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from Organization";
			if(!type.equals("all"))
			{
				qry += " where status='"+type+"'";
			}
			OrganizationliList = (List<Organization>)session.createQuery(qry).list();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return OrganizationliList;
	}
	public int getActiveOrganizationCount()
	{
		List<Organization> actOrganizationliList  = new ArrayList<Organization>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from Organization where status not in ('expired') or status is null";
			actOrganizationliList = (List<Organization>)session.createQuery(qry).list();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return actOrganizationliList.size();
	}
	public List<Organization> getOrganizationList()
	{
		List<Organization> orglist  = new ArrayList<Organization>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from Organization";
			orglist = (List<Organization>)session.createQuery(qry).list();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return orglist;
	}
	public List<Organization> getActOrgList()
	{
		List<Organization> actOrganizationliList  = new ArrayList<Organization>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from Organization where status not in ('expired') or status is null";
			actOrganizationliList = (List<Organization>)session.createQuery(qry).list();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return actOrganizationliList;
	}
	public int getInActiveOrganizationCount()
	{
		List<Organization> inactOrganizationliList  = new ArrayList<Organization>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from Organization where status in ('expired')";
			inactOrganizationliList = (List<Organization>)session.createQuery(qry).list();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return inactOrganizationliList.size();
	}
	public List<LoadBatch> getAboutToExpireBatchList(Organization org)
	{
		List<LoadBatch> abouttoexplist  = new ArrayList<LoadBatch>();
		Session session = HibernateSession.getDBSession();
		Date curdate = DateTimeUtil.getOnlyDate(new Date());
		Date fdate = DateTimeUtil.getFutureDate(curdate,30);
		try {
			session.beginTransaction();
			String qry ="from LoadBatch where validUpTo between :curdate and :fdate and  organization=:org";
			//String qry ="from LoadBatch where organization=:org";
			Query query = session.createQuery(qry,LoadBatch.class);

			query.setParameter("curdate",curdate); 
			query.setParameter("fdate",fdate);
			query.setParameter("org", org);
			abouttoexplist =query.getResultList();
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return abouttoexplist;
	}
	public List<LoadBatch> getBatchList(Organization org)
	{
		List<LoadBatch> batchlist  = new ArrayList<LoadBatch>();
		Session session = HibernateSession.getDBSession();
		try {
			session.beginTransaction();
			String qry ="from LoadBatch where organization=:org";
			//String qry ="from LoadBatch where organization=:org";
			Query query = session.createQuery(qry,LoadBatch.class);
			query.setParameter("org",org); 
			batchlist =query.getResultList();
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return batchlist;
	}
	public int getCurrentNodeCapacity() {
		// TODO Auto-generated method stub
		int cap = 0;
		Session session = HibernateSession.getDBSession();
		try {
			session.beginTransaction();
			String qry ="select count(nodesLimit) from  Organization";
			Query query = session.createQuery(qry,Long.class);
			cap = (int)(long)query.getSingleResult();
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return cap;
	}
	public int getCurrentNodeCapacity(Organization excludeOrg) {
		// TODO Auto-generated method stub
		int cap = 0;
		Session session = HibernateSession.getDBSession();
		try {
			session.beginTransaction();
			String qry ="select count(nodesLimit) from  Organization where id != "+excludeOrg.getId();
			Query query = session.createQuery(qry,Long.class);
			cap = (int)(long)query.getSingleResult();
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return cap;
	}
}
