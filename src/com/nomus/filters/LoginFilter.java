package com.nomus.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.google.LicenseValidator;

import com.nomus.m2m.dao.LicDao;
import com.nomus.m2m.pojo.License;
import com.nomus.staticmembers.DateTimeUtil;

/**
 * Servlet Filter implementation class LoginFilter
 */
@WebFilter(urlPatterns = {"/login.jsp"})
public class LoginFilter implements Filter {

    /**
     * Default constructor. 
     */
    public LoginFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

		LicDao ldao = new LicDao();
		License lic = ldao.getLicenseDetails();
		LicenseValidator validateobj = new LicenseValidator();
		try {
			if(lic != null && !validateobj.validateLodededLicense(lic.getOrgName(), lic.getLocation(), lic.getMacAddress(), DateTimeUtil.getDateString(lic.getValidUpTo()), lic.getLicGenDate(), lic.getKey(),lic.getNodeLimit()+""))
			{
				((HttpServletRequest)request).getSession().setAttribute("errmsg", "License Tampered");
				((HttpServletResponse)response).sendRedirect("licenseTampered.jsp");
			}
			else if(lic != null && lic.getStatus().equals("V"))
			{
				if(lic.getCurrentDate().compareTo(lic.getValidUpTo()) > 0)
				{
					lic.setStatus("E");
					ldao.updateLicense(lic);
					((HttpServletResponse)response).sendRedirect("licenseExpired.jsp");
				}
				else
				{
					if(DateTimeUtil.getDaysDiff(lic.getCurrentDate(), lic.getValidUpTo()) <= 45)
						((HttpServletRequest)request).getSession().setAttribute("expmsg", "iMission_RMS is Going to expire on "+DateTimeUtil.getDateString(lic.getValidUpTo()));
					chain.doFilter(request, response);
				}
			}
			else if(lic == null)
				((HttpServletResponse)response).sendRedirect("license.jsp");
			else
				((HttpServletResponse)response).sendRedirect("licenseExpired.jsp");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
