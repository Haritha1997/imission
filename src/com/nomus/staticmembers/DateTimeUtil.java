package com.nomus.staticmembers;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateTimeUtil {
	static SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	static SimpleDateFormat dtformat = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
	static SimpleDateFormat dtaformat = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss a");
	static SimpleDateFormat _24hdtformat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	public static Timestamp getNextTriggerTime(String period)
	{
		
		Calendar cal = Calendar.getInstance();
		try
		{
			cal.setTime(new SimpleDateFormat("dd-MM-yyyy").parse(sdf.format(cal.getTime())));
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		Timestamp ttime = new Timestamp(cal.getTimeInMillis());
		if(period.equals("today") || period.equals("yesterday"))
		{
			cal.add(Calendar.MINUTE, -5);
			if(period.equals("today"))
				cal.add(Calendar.DATE, 1);
			ttime = new Timestamp(cal.getTimeInMillis());
		}
		else if(period.equals("lastweek"))
		{
			cal.add(Calendar.DATE,1);
			ttime = new Timestamp(cal.getTimeInMillis());
		}
		else if(period.equals("lastmonth"))
		{
			cal.add(Calendar.DATE,1);
			ttime = new Timestamp(cal.getTimeInMillis());
		}
		else if(period.equals("lastquarter"))
		{
			cal.add(Calendar.DATE,1);
			ttime = new Timestamp(cal.getTimeInMillis());
		}
		return ttime;
	}
	
	public static String getSqlDateFormat(String datestr)
	 {
		 try
		 {
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-mm-dd");
				return sdf1.format(new SimpleDateFormat("dd-MM-yyyy").parse(datestr));
		 }
		 catch(Exception e)
		 {
			 return "";
		 }
	 }
	public static String dateToString(Date date)
	{
		try
		{
			return sdf.format(date);
		}
		catch(Exception e)
		{
			return "";
		}
	}
	public static Date getDate(String datestr) {
		// TODO Auto-generated method stub
		Date date = null;
		try {
			date = new SimpleDateFormat("dd-MM-yyyy").parse(datestr.trim());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date;
	}

	public static Date getNextDate(String datestr) {
		// TODO Auto-generated method stub
		Date date = null;
		try {
			date = new SimpleDateFormat("dd-MM-yyyy").parse(datestr.trim());
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.add(Calendar.DATE, 1);
			date = cal.getTime();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date;
	}
	public static Date getPreviousDate(String datestr) {
		// TODO Auto-generated method stub
		Date date = null;
		try {
			date = new SimpleDateFormat("dd-MM-yyyy").parse(datestr.trim());
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.add(Calendar.DATE, -1);
			date = cal.getTime();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date;
	}
	public static String getPersistentDTime(Date fromdate,Date todate)
	{
		if(todate == null || fromdate == null)
			return "";
		Calendar tocal=Calendar.getInstance(),fromcal = Calendar.getInstance();
		tocal.setTime(todate);
		fromcal.setTime(fromdate);
		long diff = tocal.getTimeInMillis()-fromcal.getTimeInMillis();
		long diffDay=diff/(24*60*60 * 1000);
		diff=diff-(diffDay*24*60*60 * 1000);
		long diffHours=diff/(60*60 * 1000);
		diff=diff-(diffHours*60*60 * 1000); 
		long diffMinutes = diff / (60 * 1000);
		diff=diff-(diffMinutes*60*1000);
		long diffSeconds = diff / 1000;
		diff=diff-(diffSeconds*1000);       
		return diffDay +" Days "+diffHours+" Hours "+diffMinutes+" Mins "+ diffSeconds+" Sec";
	}
	public static String getDateString(Date date)
	{
		return (date==null?"":new SimpleDateFormat("dd-MM-yyyy").format(date));
	}

	public static boolean isExpired(Date validUpto) {
		Date date = DateTimeUtil.getOnlyDate(new Date());
	    return validUpto.before(date);
	}
	public static Date getOnlyDate(Date date)
	{
		String datestr = sdf.format(date);
		try {
			date = new SimpleDateFormat("dd-MM-yyyy").parse(datestr);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date;
	}
	
	public static Date getPreviousDate(Date date)
	{
		return getPreviousDate(sdf.format(date));
	}
	
	
	  public static int getDaysDiff(Date date1 , Date date2) {
		  long diffinmillis = date2.getTime()- date1.getTime();
		  int diff = (int)Math.floor(diffinmillis/(1000*3600*24));
		  return diff;
	  }
	  public static int getDaysAfterPwdSet(Date lastpwdupdate) {
		  long diffinmillis = Calendar.getInstance().getTimeInMillis()- lastpwdupdate.getTime();
		  int diff = (int)Math.floor(diffinmillis/(1000*3600*24));
		  return diff;
	  }
	  public static Date ConvertToFullDate(String datestr,String format)
	  {
		  SimpleDateFormat sf = new SimpleDateFormat(format);
		  try {
			return sf.parse(datestr);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			return new Date();
		}
	  }
   
	public static Date getFutureDate(Date curdate, int days) {
		// TODO Auto-generated method stub
		Date date = null;
		try {
			Calendar cal = Calendar.getInstance();
			cal.setTime(curdate);
			cal.add(Calendar.DATE, days);
			date = cal.getTime();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return date;
	}
	public static Date addHours(Date date, int hours) {
	    Calendar calendar = Calendar.getInstance();
	    calendar.setTime(date);
	    calendar.add(Calendar.HOUR_OF_DAY, hours);
	    return calendar.getTime();
	}
	public static String getDateTimeStringWithAMPM(Date date)
	{
		return dtaformat.format(date);
	}
	public static String getDateTimeString(Date date)
	{
		return dtformat.format(date);
	}
	public static String getDateTimeStringIn24hFormat(Date date)
	{
		return _24hdtformat.format(date);
	}
	public static Date getTimeStampFormString(String datestr) {
		Date date = null;
		try {
			date =new SimpleDateFormat("dd-MM-yyyy HH:mm:ss.SSS").parse(datestr+".111");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return date;
	}
}
