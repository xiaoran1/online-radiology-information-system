<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("bSubmit") != null)
        {			
		
			//get oracle userName and password
			String sqlname = (String)session.getAttribute("SQLUSERID");
			String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
			
	        //get the user input from the login page
        	String userName = (request.getParameter("USERID"));
	        String passwd   = (request.getParameter("PASSWD"));
	        session.setAttribute("USERID",userName);
	        
        	//out.println("<p><CENTER>Your input User Name is "+userName+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input password is "+passwd+"</CENTER></p>");

        	//if user do not provide userName and password
			if (userName.equals("") && passwd.equals("")){
				out.println("<p><center>Please Enter your User Name and Password!</center></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='login.html'\""+", 2500);");
		    	out.println("</script>");
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
		        }
	        	catch(Exception ex){
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}
		
	
		        //select the user table from the underlying db and validate the user name and password
	        	Statement stmt = null;
		        ResultSet rset = null;
		        Statement stmt2 = null;
		        ResultSet rset2 = null;
		        
	        	String sql = "select password from users where user_name = '"+userName+"'";
	        	String type = "select class from users where user_name = '"+userName+"'";
	        	
		        //out.println(sql);
	        	try{
		        	stmt = conn.createStatement();
			        rset = stmt.executeQuery(sql);
	        	}
		
		        catch(Exception ex){
			        if ((ex.getMessage()).length() > 100)
		        		out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        		else
	        			out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}
	
		        String truepwd = "";
				String userClass = "";
				
	        	while(rset != null && rset.next())
		        	truepwd = rset.getString(1);
	        	
	
	        	try{
	        		stmt2 = conn.createStatement();
		        	rset2 = stmt.executeQuery(type); 
	        	}
		
		        catch(Exception ex){
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}
	      	
	        	while(rset2 != null && rset2.next())
		        	userClass = (rset2.getString(1)).trim();
	        		session.setAttribute("classtype",userClass);
	        		
	        	//display the result
		        if(passwd.equals(truepwd)){
			        out.println("<p><CENTER>Your Login is Successful!</p>");
			        out.println("Click the button to continue.");
			        
			        //transfer user to their class main page
	        		if (userClass.equals("a")){
	        			out.println("<form method=post action=admin.html>");
	        			out.println("<input type=submit name=admin value=Continue>");
	        			out.println("</CENTER></form>");
	    		    	out.println("<script language=javascript type=text/javascript>");
	    		    	out.println("setTimeout("+"\"javascript:location.href='admin.html'\""+", 1000);");
	    		    	out.println("</script>");
	        		}
	        		else if (userClass.equals("d")){
	        			out.println("<form method=post action=doctor.html>");
	        			out.println("<input type=submit name=admin value=Continue>");
	        			out.println("</CENTER></form>");
	    		    	out.println("<script language=javascript type=text/javascript>");
	    		    	out.println("setTimeout("+"\"javascript:location.href='doctor.html'\""+", 1000);");
	    		    	out.println("</script>");
	        		}
	        		else if (userClass.equals("r")){
	        			out.println("<form method=post action=radiologist.html>");
	        			out.println("<input type=submit name=admin value=Continue>");
	        			out.println("</CENTER></form>");
	    		    	out.println("<script language=javascript type=text/javascript>");
	    		    	out.println("setTimeout("+"\"javascript:location.href='radiologist.html'\""+", 1000);");
	    		    	out.println("</script>");
	        		}
	        		else if (userClass.equals("p")){
	        			out.println("<form method=post action=patient.html>");
	        			out.println("<input type=submit name=admin value=Continue>");
	        			out.println("</CENTER></form>");
	    		    	out.println("<script language=javascript type=text/javascript>");
	    		    	out.println("setTimeout("+"\"javascript:location.href='patient.html'\""+", 1000);");
	    		    	out.println("</script>");
	        		}
		        }
	
	        	   
	        	else{
		        	out.println("<p><CENTER><b>Either your userName or Your password is inValid!</b></CENTER></p>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='login.html'\""+", 2500);");
			    	out.println("</script>");
	        	}
			
	           	try{
	                conn.close();
	            }
	            catch(Exception ex){
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	            }
			}
        }
  
%>



</BODY>
</HTML>

