<HTML>
<BODY>

<%@page import="java.sql.*" %>
<% 
		String classtype =  (String)session.getAttribute("classtype");
		out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		out.println("<script language=javascript type=text/javascript>");
		if (classtype.equals("a"))
			out.println("setTimeout("+"\"javascript:location.href='admin.html'\""+", 0);");
		else if (classtype.equals("d"))
			out.println("setTimeout("+"\"javascript:location.href='doctor.html'\""+", 0);");
		else if (classtype.equals("r"))
			out.println("setTimeout("+"\"javascript:location.href='radiologist.html'\""+", 0);");
		else if (classtype.equals("p"))
			out.println("setTimeout("+"\"javascript:location.href='patient.html'\""+", 0);");
		out.println("</script></div>");

%>



</BODY>
</HTML>

