package com.nomus.m2m.dao;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.persistence.Query;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.nomus.m2m.pojo.License;

public class LicDao {

	public License getLicenseDetails()
	{
		Transaction tx = null;
		License lic = null;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			Query query = session.createQuery("from License order by id",License.class);
			List<License> liclist = query.getResultList();
			if(liclist.size() > 0)
				lic = liclist.get(liclist.size()-1);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return lic;
	}

	public Integer addLicense(License lic){
		Transaction tx = null;
		int licid = 0;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			licid = (Integer) session.save(lic);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
		return licid;
	}

	public void updateLicense(License lic){
		Transaction tx = null;
		Session session = HibernateSession.getDBSession();
		try {
			tx = session.beginTransaction();
			session.update(lic);
			tx.commit();
		} catch (HibernateException e) {
			if (tx!=null) tx.rollback();
			e.printStackTrace(); 
		} finally {
			session.close();
		}
	}

	public void updateCurdate() {
		// TODO Auto-generated method stub
		try
		{
			License lic = getLicenseDetails();
			if(lic != null)
			{
				Date date = lic.getCurrentDate();
				if(date != null)
				{
					Calendar cal = Calendar.getInstance();
					Calendar cal1 = Calendar.getInstance();
					cal.setTime(date);
					cal.add(Calendar.MINUTE, 4);
					if(cal.compareTo(cal1) < 0)
						lic.setCurrentDate(cal1.getTime());
					else
						lic.setCurrentDate(cal.getTime());
						updateLicense(lic);
				}
			}
		}
		catch (Exception e) {
			// TODO: handle exception
		}
	}
}
