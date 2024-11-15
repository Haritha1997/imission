package com.nomus.m2m.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.UserRole;



public class UserDao {

	public UserDao()
	{
	}

	public int addUser(User user)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		int id = -1;
		try {
			tx = session.beginTransaction();
			session.save(user);
			id = user.getId();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
			
		} finally {
			session.close();
		}   
		return id;
	}
	public boolean updateUser(User user)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.update(user);
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
	public User getuser(String username, String password)
	{
		Session session = HibernateSession.getDBSession();
		User user=null;
		try {
			Query query =  session.createQuery("from User where username=:username and password=:password", User.class);
			query.setParameter("username", username);
			query.setParameter("password", password);
			try
			{
				user = (User) query.getSingleResult();
			}
			catch (NoResultException  e) {
				// TODO: handle exception
			}
		} catch (HibernateException e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return user;
	}
	public User getUserByUsername(String username)
	{
		Session session = HibernateSession.getDBSession();
		User user=null;
		List<User> userlist = new ArrayList<User>();
		try {
			Query query =  session.createQuery("from User where username=:username", User.class);
			query.setParameter("username", username);
			try
			{
				userlist = query.getResultList();
				if(userlist.size() > 0)
					user = userlist.get(0);
			}
			catch (NoResultException  e) {
				// TODO: handle exception
			}
		} catch (HibernateException e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return user;
	}
	public User getUser(int id)
	{
		Session session = HibernateSession.getDBSession();
		User user=null;
		try {
			Query query =  session.createQuery("from User where id=:id", User.class);
			query.setParameter("id", id);
			try
			{
				user = (User) query.getSingleResult();
			}
			catch (NoResultException  e) {
				// TODO: handle exception
			}
		} catch (HibernateException e) {
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return user;
	}
	public boolean deleteUser(User user)
	{
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.delete(user);
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
	public List<User> getUsersList(User curuser,String fetchtype)
	{
		List<User> userliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		String status = fetchtype.equals("inactive")?"in ('deleted'))":"not in ('deleted') or status is null)";
		try {
			tx = session.beginTransaction();
			String qry ="from User where (status "+status;
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
				qry += " and organization=:org";
			else if(curuser.getRole().equals(UserRole.ADMIN))
				qry += " and under=:user";
			else if(curuser.getRole().equals(UserRole.MAINADMIN))
			    qry +=" and role=:role";
			else
				qry += " and under=:user";
			
			Query query =  session.createQuery(qry);
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
				query.setParameter("org", curuser.getOrganization());
			else if(curuser.getRole().equals(UserRole.ADMIN))
				query.setParameter("user", curuser);
			else if(curuser.getRole().equals(UserRole.MAINADMIN))
				query.setParameter("role", UserRole.SUPERADMIN);
			else
				query.setParameter("user", curuser);
				
			userliList = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return userliList;
	}
	public List<User> getUsersListUnderCurrentUser(User curuser)   // not for Hyperadmin
	{
		List<User> userliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User where ";
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
				qry += " organization=:org";
			else if(curuser.getRole().equals(UserRole.ADMIN))
				qry += " under=:user";
			else if(curuser.getRole().equals(UserRole.MAINADMIN))
			    qry +="  role=:role";
			
			Query query =  session.createQuery(qry);
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
				query.setParameter("org", curuser.getOrganization());
			if(curuser.getRole().equals(UserRole.ADMIN))
				query.setParameter("user", curuser);
			else if(curuser.getRole().equals(UserRole.MAINADMIN))
				query.setParameter("role", UserRole.SUPERADMIN);
				
			userliList = query.getResultList();
			if(userliList.size() == 0)
				userliList.add(curuser);
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return userliList;
	}
	public List<User> getAllUsersList()
	{
		List<User> userliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User order by organization,id";
			userliList = session.createQuery(qry).getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return userliList;
	}
	public List<User> getAllUsersList(String role)
	{
		List<User> userliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User where role = '"+role+"'order by organization";
			userliList = session.createQuery(qry).getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return userliList;
	}
	public List<User> getChildUsersList(User user)
	{
		List<User> userliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User where under = '"+user.getId()+"'order by organization";
			userliList = session.createQuery(qry).getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return userliList;
	}
	public List<User> getAllUsersUnderOrg(Organization organization)
	{
		List<User> actuserliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			//String qry ="from User where status not in ('deleted') or status is null and organization = :org";
			String qry ="from User where status is not null and organization = :org";
			Query query= session.createQuery(qry);
			query.setParameter("org", organization);
			 actuserliList = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return actuserliList;
	}
	public List<User> getAllActSuperUsersList()
	{
		List<User> actuserliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User where status not in ('deleted') or status is null and role=:role order by organization,id";
			Query query = session.createQuery(qry);
			query.setParameter("role", UserRole.SUPERADMIN);
			actuserliList = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return actuserliList;
	}
	/*public List<User> getInactUsersUnderOrg(Organization organization)
	{
		List<User> inactuserliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User where status in ('deleted') and organization="+organization+" order by organization,id";
			inactuserliList = session.createQuery(qry).getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return inactuserliList;
	}*/
	public boolean isUserlimitReached(User curuser,String subuserrole,int underid)
	{
		boolean reached = false;
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		User underuser = underid==-1?null:getUser(underid);
		try {
			tx = session.beginTransaction();
			String qry ="from User where";
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
			{
				//qry += " organization=:org";
				if(subuserrole.equals(UserRole.ADMIN) || underuser == null)
					qry += " under=:user";
				else
					qry +=" under=:user and role=:subuserrole";
			}
			else if(curuser.getRole().equals(UserRole.ADMIN))
				qry += " under=:user and role=:subuserrole";
			else if(curuser.getRole().equals(UserRole.MAINADMIN))
			    qry +="  role=:role";
			qry += " and status !='deleted'";
			Query query =  session.createQuery(qry);
			if(curuser.getRole().equals(UserRole.SUPERADMIN))
			{
				if(subuserrole.equals(UserRole.ADMIN) || underuser == null)
					query.setParameter("user", curuser);
				else
				{
					query.setParameter("user", underuser);
					query.setParameter("subuserrole", subuserrole);;
				}
				
			}
			if(curuser.getRole().equals(UserRole.ADMIN))
			{
				query.setParameter("user", curuser);
				query.setParameter("subuserrole", subuserrole);
			}
			else if(curuser.getRole().equals(UserRole.MAINADMIN))
				query.setParameter("role", UserRole.SUPERADMIN);
			int limit = curuser.getOrganization().getUserlimit();
		
			if(curuser.getRole().equals(UserRole.ADMIN) || (underuser != null && !subuserrole.equals(UserRole.ADMIN)))
				limit = 10;
			if(query.getResultList().size() >= limit)
				reached = true;
			tx.commit();
		} catch (Exception e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return reached;
	
	}
	
	public List<User> getActiveAdminUsers(User user)
	{
		List<User> userliList  = new ArrayList<User>();
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User where under = '"+user.getId()+"' and role = :role and status not in (:status) order by organization";
			Query query = session.createQuery(qry);
			query.setParameter("role", UserRole.ADMIN);
			query.setParameter("status","deleted");
			userliList = query.getResultList();
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return userliList;
	}
	public User getUser(Organization org)
	{
		User user=null;
		Session session = HibernateSession.getDBSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			String qry ="from User where role = :role and organization = :org";
			Query query = session.createQuery(qry);
			query.setParameter("role", UserRole.SUPERADMIN);
			query.setParameter("org",org);
			List<User> userlist= query.getResultList();
			if(userlist.size() > 0)
				user = userlist.get(0);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
		} finally {
			session.close();
		}
		return user;
		
	}
}