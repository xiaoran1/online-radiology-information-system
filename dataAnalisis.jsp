<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("go") != null)
        {			
			String sqlname = (String)session.getAttribute("SQLUSERID");
			String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
			
	        //get the user input from the login page
        	//String userName = (request.getParameter("USERID")).trim();
	        //String passwd   = (request.getParameter("PASSWD")).trim();
	        //session.setAttribute("USERID",userName);
        	//out.println("<p><CENTER>Your input User Name is "+userName+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input password is "+passwd+"</CENTER></p>");


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
	        
        	String sql = "select count(*) from pacs_images pp";
        			//"select password from users where user_name = '"+userName+"'";
        	//String type = "select class from users where user_name = '"+userName+"'";
        	
	        //out.println(sql);
        	try{
	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(sql);
        	}
	
	        catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

	        String basecase = "";
        	while(rset != null && rset.next())
	        	basecase = (rset.getString(1)).trim();
        		//out.println(basecase);
			out.println("<HTML><HEAD><TITLE>Data Analysis</TITLE></HEAD><BODY>");
			out.println("<div id='image' style='background: url(47.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
			out.println("<br><br><br><br><br><br><br><br><H1><CENTER>Data Analysis</CENTER></H1><CENTER><P></P>");
			out.println("<br><br><p><b>Total number of pictures:"+basecase+"</b></p>");
			out.println("<br><FORM ACTION='dataAnalysis1.html' METHOD='post' ><INPUT TYPE='submit' NAME='again' VALUE='Make Another analysis' style= 'width: 300; height: 30'></FORM>");
			out.println("<FORM ACTION='dataAnalysis1.html' METHOD='post' ><INPUT TYPE='submit' VALUE='BACK' style= 'width: 300; height: 30'></FORM>");
			out.println("<FORM ACTION='admin.html' METHOD='post' ><INPUT TYPE='submit' NAME='ad_back' VALUE='GO BACK TO ADMIN' style= 'width: 300; height: 30'><br><br><a href='userDocumentation.html' target='_blank'>Need help?</a></FORM></div></BODY></HTML>");
           	try{
                conn.close();
            }
            catch(Exception ex){
                 out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
            }
        }
  
%>



</BODY>
</HTML>
