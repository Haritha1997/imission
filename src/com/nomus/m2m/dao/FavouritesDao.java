package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.Favourites;



public class FavouritesDao {
   
   public FavouritesDao()
   {
   }
  
   /* Method to CREATE an employee in the database */
   public boolean addFavourites(List<Favourites> favlist){
      Transaction tx = null;
	int nodeid = 0;
      Session session = HibernateSession.getDBSession();
      try {
         tx = session.beginTransaction();
         for(Favourites fav : favlist)
         nodeid = (Integer) session.save(fav);
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
   
  public List<Favourites> getFavourites( ){
	  //System.out.println("columnname is : "+columnname+" value is : "+value);
	   Session session = HibernateSession.getDBSession();
      Transaction tx = null;
      List<Favourites> favlist = new ArrayList<Favourites>();
      try {
         tx = session.beginTransaction();
         favlist =  session.createQuery("from Favourites", Favourites.class).getResultList();
         tx.commit();
      } catch (HibernateException e) {
         if (tx!=null) tx.rollback();
         e.printStackTrace(); 
      } finally {
         session.close();
      }
      return favlist;
   }
}