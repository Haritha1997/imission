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
import javax.servlet.http.HttpSession;

/**
 * Servlet Filter implementation class SessionFilter
 */
@WebFilter(urlPatterns = {"*.jsp","/m2m/*","/report/*","/user/*","/account/*"})
public class SessionFilter implements Filter {

    /**
     * Default constructor. 
     */
    public SessionFilter() {
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
		// TODO Auto-generated method stub
		// place your code here
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse httpresponse = (HttpServletResponse) response;
		httpresponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
		httpresponse.setHeader("Pragma", "no-cache"); // HTTP 1.0.
		httpresponse.setDateHeader("Expires", 0);
		// pass the request along the filter chain
		HttpSession session = req.getSession(false);
		if(session != null && session.getAttribute("loggedinuser") != null || req.getRequestURL().toString().endsWith("login.jsp") 
				|| req.getRequestURL().toString().endsWith("imission/")
				|| req.getRequestURL().toString().endsWith("imission/m2m/LoginController")
				|| req.getRequestURL().toString().endsWith("/imission/resetpassword.jsp")
				|| req.getRequestURL().toString().endsWith("/imission/forgotpwd.jsp")
				|| req.getRequestURL().toString().endsWith("/imission/message.jsp")
				|| req.getRequestURL().toString().endsWith("/imission/linkexpired.jsp")
				|| req.getRequestURL().toString().endsWith("sessionexpire.jsp")
				|| req.getRequestURL().toString().endsWith("logoff.jsp")
				|| req.getRequestURL().toString().endsWith("licenseExpired.jsp")
				|| req.getRequestURL().toString().endsWith("licensedetails.jsp")
				|| req.getRequestURL().toString().endsWith("licenseTampered.jsp")
				|| req.getRequestURL().toString().endsWith("license.jsp")
				|| req.getRequestURL().toString().endsWith("UserController")
				|| req.getRequestURL().toString().endsWith("/imission/backup.jsp")
				|| req.getRequestURL().toString().endsWith("SaveBackUpsettings"))
			
			
			chain.doFilter(request, response);
		else
			((HttpServletResponse)response).sendRedirect("/imission/sessionexpire.jsp");
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}
}
