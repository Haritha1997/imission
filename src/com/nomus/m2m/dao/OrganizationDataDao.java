package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.Symbols;
import com.nomus.staticmembers.UserRole;

public class OrganizationDataDao {
	public String addOrganizationData(List<OrganizationData> orgdatalist,HashMap<String, String> savedslhm,LoadBatch batch)
	{
		String status="";
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		session.save(batch);
		List<OrganizationData> tobesavelist = new ArrayList<OrganizationData>();
		if(savedslhm.containsKey("error"))
			return savedslhm.get("error");
		try {
			tx = session.beginTransaction();
			for(OrganizationData orgData : orgdatalist)
			{
				if(savedslhm.get(orgData.getSlnumber()) == null)
				{
					session.save(orgData);
					tobesavelist.add(orgData);
				}
				else
					status +=" The Serial Number "+orgData.getSlnumber()+" is already exists"+Symbols.NEWLINE;	
			}
			if(tobesavelist.size() == 0)
				tx.rollback();
			else
				tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
			return "Save Failed. Please Try Again.";
		} finally {
			session.close();
		}   
		if(status.length() == 0)
		{
			batch.setOrgdatalist(tobesavelist);
			status = "OrganizationData saved successfully.";
		}
		return status;
	}
	
	public HashMap<String, String> getSavedSlNumbers(List<String> slnumbers)
	
	{
		HashMap<String, String> savedslnumhm = new HashMap<String,String>();
		Session session = HibernateSession.getDBSession();
		try {
			Query query=session.createQuery("from OrganizationData where slnumber in (:slnums)");
			query.setParameter("slnums", slnumbers);
			List<OrganizationData> orgdatalist=query.getResultList();
			for(OrganizationData orgdata : orgdatalist)
				savedslnumhm.put(orgdata.getSlnumber(), orgdata.getSlnumber());
			
		} catch (Exception e) {
			e.printStackTrace();
			if(slnumbers.size()==0)
				savedslnumhm.put("error", "No Data Found/Invalid File");
			else
				savedslnumhm.put("error", "Invalid File");
				
		}
		finally {
			session.close();
		} 
		return savedslnumhm;
	}
	public OrganizationData getOrganizationData(String slnum)
	{
		Session session = HibernateSession.getDBSession();
		OrganizationData orgdata=null;
		try {
			String  qry = "from OrganizationData where slnumber='"+slnum+"'";
			Query query = session.createQuery(qry);
			List<OrganizationData> orgdatalist = query.getResultList();
			if(orgdatalist.size() > 0)
				orgdata = orgdatalist.get(0);
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		} 
		return orgdata;
	}
	public int getCurrentOrgDataSize(String organization)
	{
		int size = 0;
		Session session = HibernateSession.getDBSession();
		try {
			String  qry = "select count(id) from OrganizationData where organization=:org";
			Query query = session.createQuery(qry,Long.class);
			query.setParameter("org", organization);
			size =  (int)(long)query.getSingleResult();
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		} 
		return size;
	}
	public List<String> getUnDiscoveredSlNums(User user,List<String> slnumlist)
	{
		List<String> slnumberlist = new ArrayList<String>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try 
		{
			tx = session.beginTransaction();
			String qry = null;
			qry = "select slnumber from OrganizationData where organization=:org ";
			if(user.getRole().equals(UserRole.SUPERADMIN))
				qry +="and  slnumber not in (:slnumlist)";
			if(!user.getRole().equals(UserRole.MAINADMIN) && !user.getRole().equals(UserRole.SUPERADMIN))
				qry +="and (slnumber in (:slnumlist)) and slnumber not in (:snumlist)";
			qry += " order by slnumber";
			Query query = session.createQuery(qry);
			query.setParameter("org", user.getOrganization().getName());
			if(user.getRole().equals(UserRole.SUPERADMIN))
				query.setParameter("slnumlist", slnumlist.size()==0?"":slnumlist);
			if(!user.getRole().equals(UserRole.MAINADMIN) && !user.getRole().equals(UserRole.SUPERADMIN))
			{
				query.setParameter("slnumlist", user.getSlnumberlist());
				query.setParameter("snumlist", slnumlist.size()==0?"":slnumlist);
			}
			slnumberlist = query.getResultList();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{
			session.close();
		}
		return slnumberlist;
	}
	
	public List<String> getSlNumbers(LoadBatch batch)
	{
		List<String> slnumberlist = new ArrayList<String>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try 
		{
			tx = session.beginTransaction();
			String qry = null;
			qry = "select slnumber from OrganizationData where batch=:batch order by slnumber";
			Query query = session.createQuery(qry);
			query.setParameter("batch", batch);
			slnumberlist = query.getResultList();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally {
			session.close();
		}
		return slnumberlist;
	}
	public void addOrganizationDataList(List<OrganizationData> orgdatalist) {
		Transaction tx = null;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			int i=0;
			for(OrganizationData  orgdata : orgdatalist)
			{
				session.save(orgdata);
				i++;
				if(i%100==0)
				{
					session.flush();
					session.clear();
				}
			}
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
	}

	public void updateOrganizationDataList(List<OrganizationData> updateorgdatalist) {
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			//List<NodeDetails> nodedetlist = (List<NodeDetails>) nodeidtable.values();
			for(int i=0;i<updateorgdatalist.size();i++)
			{
				OrganizationData orgdata = updateorgdatalist.get(i);
				session.update(orgdata);
				if (i % 100 == 0) {//a batch size for safety
		            session.flush();
		            session.clear();
		        }
			}
			tx.commit();
		}catch (Exception e) {
			tx.rollback();
			e.printStackTrace();
		}
		finally {
			
			session.close();
		}
	}


	public void deleteOrganizationDataList(List<OrganizationData> orgdatalist) {
		// TODO Auto-generated method stub
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			//List<NodeDetails> nodedetlist = (List<NodeDetails>) nodeidtable.values();
			for(int i=0;i<orgdatalist.size();i++)
			{
				OrganizationData orgdata = orgdatalist.get(i);
				session.remove(orgdata);
				if (i % 100 == 0) {//a batch size for safety
		            session.flush();
		            session.clear();
		        }
			}
			tx.commit();
		}catch (Exception e) {
			tx.rollback();
			e.printStackTrace();
		}
		finally {
			
			session.close();
		}
	}
}
