package com.nomus.m2m.dao;

import org.google.LicenseValidator;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

import com.nomus.m2m.pojo.BulkActivity;
import com.nomus.m2m.pojo.BulkActivityDetails;
import com.nomus.m2m.pojo.DataUsage;
import com.nomus.m2m.pojo.BackUp;
import com.nomus.m2m.pojo.Favourites;
import com.nomus.m2m.pojo.License;
import com.nomus.m2m.pojo.LoadBatch;
import com.nomus.m2m.pojo.M2MDetails;
import com.nomus.m2m.pojo.M2MNodeOtages;
import com.nomus.m2m.pojo.M2MSchReports;
import com.nomus.m2m.pojo.M2Mlogs;
import com.nomus.m2m.pojo.NodeDetails;
import com.nomus.m2m.pojo.Organization;
import com.nomus.m2m.pojo.OrganizationData;
import com.nomus.m2m.pojo.SlNumbersRange;
import com.nomus.m2m.pojo.User;
import com.nomus.m2m.pojo.UserArea;
import com.nomus.m2m.pojo.UserColumns;
import com.nomus.m2m.pojo.UserSlnumber;

public class HibernateSession {

	private static SessionFactory factory = null;
	private static SessionFactory getSessionFactory()
	{
		if(factory == null)
		{
			 try {
				 //StandardServiceRegistry ssr = new StandardServiceRegistryBuilder().configure("hibernate.cfg.xml").build();
		         //Metadata mdata = new MetadataSources(ssr).getMetadataBuilder().build();
				 //factory = mdata.getSessionFactoryBuilder().build();
					Configuration config = new Configuration().configure();
					setAdditionalProps(config);
					StandardServiceRegistry ssr = new StandardServiceRegistryBuilder().applySettings(config.getProperties()).build();
					addClassesToConfig(config);
					
					factory = config.buildSessionFactory(ssr);
		      } catch (Throwable ex) { 
		         System.err.println("Failed to create sessionFactory object." + ex);
		         throw ex;
		      }
		}
		return factory;
	}
	
	private static void setAdditionalProps(Configuration config) {
		// TODO Auto-generated method stub
		config.setProperty("hibernate.connection.username", "postgres");
		config.setProperty("hibernate.connection.password", LicenseValidator.getDBpasword());
	}

	private static void addClassesToConfig(Configuration config) {
		// TODO Auto-generated method stub
		config.addAnnotatedClass(NodeDetails.class);
		config.addAnnotatedClass(M2Mlogs.class);
		config.addAnnotatedClass(M2MNodeOtages.class);
		config.addAnnotatedClass(BulkActivity.class);
		config.addAnnotatedClass(BulkActivityDetails.class);
		config.addAnnotatedClass(M2MSchReports.class);
		config.addAnnotatedClass(Favourites.class);
		config.addAnnotatedClass(User.class);
		config.addAnnotatedClass(UserArea.class);
		config.addAnnotatedClass(UserSlnumber.class);
		config.addAnnotatedClass(Organization.class);
		config.addAnnotatedClass(OrganizationData.class);
		config.addAnnotatedClass(UserColumns.class);
		config.addAnnotatedClass(SlNumbersRange.class);
		config.addAnnotatedClass(LoadBatch.class);
		config.addAnnotatedClass(M2MDetails.class);
		config.addAnnotatedClass(DataUsage.class);
		config.addAnnotatedClass(License.class);
		config.addAnnotatedClass(BackUp.class);
	}

	public static Session getDBSession()
	{
		Session hdbsession = getSessionFactory().openSession();
		return hdbsession;
	}

	public static void closeSessionFactory() {
		// TODO Auto-generated method stub
		factory.close();
		factory = null;
	}
}
