<HTML>
<HEAD>


<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("Submit") != null)
        {
	        //get the user input from the login page	
	    	String sqlname = (request.getParameter("SQLUSERID")).trim();
			String sqlpwd  = (request.getParameter("SQLPASSWD")).trim();
			
			//setAttribute for later use
			session.setAttribute("SQLUSERID",sqlname);
			session.setAttribute("SQLPASSWD",sqlpwd);
					
			//if user dont enter complete information, return bad response
			if((sqlname.equals("")) || (sqlpwd.equals(""))){
				out.println("<p><CENTER>Please provide your Oracle User Name and Password!<br>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='oracle_login.html'\""+", 2500);");
		    	out.println("</script></div>");
			}
			else{
		        //establish the connection to the underlying database
	        	Connection conn = null;
		
		        String driverName = "oracle.jdbc.driver.OracleDriver";
	            String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		
		        try{
			        //load and register the driver
	        		Class drvClass = Class.forName(driverName); 
		        	DriverManager.registerDriver((Driver) drvClass.newInstance());
	        	}
		        catch(Exception ex){
		        	out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
		
		        }
	
	        	try{
		        	//establish the connection 
			        conn = DriverManager.getConnection(dbstring,sqlname,sqlpwd);
	        		conn.setAutoCommit(false);
	        		conn.close();
	                out.println("<form method=post action=login.html>");
	    	        out.println("<p><CENTER>Your Login is Successful!<br>");
	    	        out.println("Click the button to continue.</p>");
	    	        out.println("<input type=submit name=admin value=Continue>");
	                out.println("</CENTER></form>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='login.html'\""+", 1000);");
			    	out.println("</script>");
		        }
	        	catch(Exception ex){
	        		//out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
			        out.println("<hr><center>" + (ex.getMessage()).substring(11) + "</center><hr>");;
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='oracle_login.html'\""+", 2500);");
			    	out.println("</script>");
	        	}
			}
        }


%>



</BODY>
</HTML>

