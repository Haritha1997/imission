package com.nomus.m2m.view;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomus.m2m.dao.UserDao;
import com.nomus.m2m.pojo.User;
import com.nomus.staticmembers.UserRole;

/**
 * Servlet implementation class OrganizationTree
 */
@WebServlet("/organizationTree")
public class OrganizationTree extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public OrganizationTree() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserDao udao = new UserDao();
		List<User> userlist = udao.getAllUsersList(UserRole.SUPERADMIN);
		List<Organization> orglist = new ArrayList<Organization>();
		String oldorgname = null;
		Organization org = null;
		List<SuperAdmin> suadminlist = new ArrayList<SuperAdmin>();
		for(User superuser : userlist) 
		{
			if(oldorgname == null || !oldorgname.equals(superuser.getOrganization().getName()))
			{
				oldorgname = superuser.getOrganization().getName();
				if(org != null)
				{
					org.setUserlist(suadminlist);
					orglist.add(org);
				}
					org = new Organization();
				suadminlist = new ArrayList<SuperAdmin>();
				org.setName(oldorgname);
				org.setValidUpTo(superuser.getOrganization().getValidUpto());
			}
			SuperAdmin sa = new SuperAdmin();
			sa.setUser(superuser);
			List<Admin> adminlist = new ArrayList<Admin>();
			List<User> superchildlist = udao.getChildUsersList(superuser);
			for(User adminuser : superchildlist)
			{
					Admin admin = new Admin();
					admin.setUser(adminuser);
					List<ChildUser> adminchilds = new ArrayList<ChildUser>();
					if(adminuser.getRole().equals(UserRole.ADMIN))
					{
						List<User> adminclist = udao.getChildUsersList(adminuser);
						for(User child : adminclist)
						{
							ChildUser ch = new ChildUser();
							ch.setUser(child);
							adminchilds.add(ch);
						}
					}
					admin.setChildlist(adminchilds);
					adminlist.add(admin);
			}
			sa.setChildlist(adminlist);
			suadminlist.add(sa);
		}
		
		if(org != null)
		{
		orglist.add(org);
		org.setUserlist(suadminlist);
		}
		
		RequestDispatcher dispacher = request.getRequestDispatcher("orgtree.jsp");
		request.setAttribute("orglist", orglist);
		dispacher.forward(request, response);
		
		/*response.setContentType("text/HTML");
		PrintWriter pw = response.getWriter();
		pw.write("<html>");
		pw.write("<head>");
		pw.write(" <meta http-equiv=\"pragma\" content=\"no-cache\">");
		pw.write(" <link rel=\"stylesheet\" href=\"css/fontawesome.css\">");
		pw.write(" <link rel=\"stylesheet\" href=\"css/solid.css\">");
		pw.write(" <link rel=\"stylesheet\" href=\"css/v4-shims.css\">");
		pw.write(" <link rel=\"stylesheet\" type=\"text/css\" href=\"css/style.css\">");
		pw.write("<style>");
		pw.write(".btn {");
		pw.write("padding-top:0px;");
		pw.write("padding-bottom:0px;	");
		pw.write("width: 150px;");
		pw.write("padding-right:-5px;");
		pw.write("padding-left:-5px;");
		pw.write("}");
		pw.write("#line {");
		pw.write("width:200px;");
		pw.write("margin-bottom:4px;");
		pw.write("height: 2px;");
		pw.write("background:#c4dfc9;");
		pw.write("margin-right:-5px;");
		pw.write("margin-left:-5px;");
		pw.write("}");
		pw.write("</style>");
		
		pw.write("</head>");
		pw.write("<body>");
		pw.write("<div style=\"margin:50 0 0 50\">");
		
		
		for(Organization orgobj : orglist)
		{
			pw.write(org.getName());
			for(SuperAdmin sa : org.getUserlist())
			{
				pw.write("<p>"+sa.getUser().getUsername()+"  "+sa.getUser().getRole()+"</p>");
				for(Admin admin : sa.getChildlist())
				{
					pw.write("<p>"+admin.getUser().getUsername()+"  "+admin.getUser().getRole()+"</p>");
					for(ChildUser user : admin.getChildlist())
					{
						pw.write("<p>"+user.getUser().getUsername()+"  "+user.getUser().getRole()+"</p>");
					}
				}
			}
		}
		
		pw.write("<ul style=\"width:550px\" class=\"collapsible\">");
		//pw.write("<label class=\"btn btn-default\">"+user.getOrganization().getName()+"</label>");
		pw.write("<label id=\"line\"></label>");
		//pw.write("<label class=\"btn btn-default\">"+user.getUsername()+"("+user.getRole()+")"+"</label>");
		pw.write("</ul>");
		pw.write("<ul class=\"content\">");
		for(User usr:userlist)
		{
			pw.write("<li>"+usr+"</li>");
		}
		pw.write("</ul>");
		pw.write("</div>");
		
		pw.write("</body>");
		pw.write("</html>");*/
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
