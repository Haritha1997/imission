package com.nomus.m2m.dao;


import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.nomus.m2m.pojo.BulkActivity;



public class BulkActivityDao {
   
   public BulkActivityDao()
   {
	  
   }
   /* Method to CREATE bulkconfig row in the database */
   public Integer addBulkConfig(BulkActivity bconfig){
      Transaction tx = null;
      int bconfigid = 0;
      Session session = HibernateSession.getDBSession();
      try {
         tx = session.beginTransaction();
         bconfigid = (Integer) session.save(bconfig);
         tx.commit();
      } catch (HibernateException e) {
         if (tx!=null) tx.rollback();
         e.printStackTrace(); 
      } finally {
         session.close();
      }
      return bconfigid;
   }
   public BulkActivity getbulkConfig(int id,Session session)
   {
	   String hql = "FROM BulkActivity bc where bc.configid="+id;
	Query<BulkActivity> query = session.createQuery(hql);
	   BulkActivity bc = query.getSingleResult();
	   return bc;
   }
   public boolean UpdateBulkConfig(BulkActivity bconfig, Session session){
	      //Transaction tx = null;
	      //Session session = HibernateSession.getDBSession();
	   boolean updated = true;
	      try {
	        // tx = session.beginTransaction();
	         session.update(bconfig);
	         //tx.commit();
	      } catch (HibernateException e) {
	         //if (tx!=null) tx.rollback();
	    	  updated = false;
	         e.printStackTrace(); 
	      } finally {
	         //session.close();
	      }
	      return updated;
	   }
   public List<BulkActivity> getBulkConfigList(String columnname, String value, Session session){
	  // Session session = HibernateSession.getDBSession();
      //Transaction tx = null;
      List<BulkActivity> retlist = new ArrayList<BulkActivity>();
      try {
         //tx = session.beginTransaction();
         //criteria.setMaxResults();
         String hql = "FROM BulkActivity bg  where bg."+columnname+"="+value+" ORDER BY bg.configtime";
		Query<BulkActivity> query = session.createQuery(hql);
         retlist = query.getResultList();
         //tx.commit();
      } catch (HibernateException e) {
        // if (tx!=null) tx.rollback();
         e.printStackTrace(); 
      } finally {
         session.close();
      }
      return retlist;
   }
   
   public List<BulkActivity> getAllBulkConfigList(){
	   Session session = HibernateSession.getDBSession();
      Transaction tx = null;
      List<BulkActivity> retlist = new ArrayList<BulkActivity>();
      try {
         tx = session.beginTransaction();
         String hql = "FROM BulkActivity bg ORDER BY bg.configtime";
		Query<BulkActivity> query = session.createQuery(hql);
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
   
}