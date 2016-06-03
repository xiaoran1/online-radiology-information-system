<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("go1") != null)
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
		        if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
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
			out.println("<br><br><br><br><br><br><br><br><H1><CENTER>Data Analysis</CENTER></H1><CENTER><P><CENTER>Please Select The Value for the Attributes</CENTER></P>");
			out.println("<br><FORM ACTION='afterdataAnalysis1.jsp' METHOD='post' >");
			out.println("<table><tr><td>First Name</td><td><input name ='fname' type = 'text'></td></tr><tr><td>Last Name</td><td><input name = 'lname' type = 'text' ></td></tr>");
			out.println("<tr><td>Type</td><td><input name='Type1' type ='text'></td></tr><tr><td>From:</td><td><select name='Year1'><option value='NULL'>Year</option>");
			out.println("<script language='JavaScript'>var i ;for(i=2014; i>=1700; i--){ document.write('<option value='+i+'><fond color=black>'+i+'</option>') ;}");
			out.println("</script></select><select name='Month1'><option value='NULL'>Month</option><option value='January'>January</option>");
			out.println("<option value='February'>February</option><option value='March' >March</option><option value='April'>April</option>");
			out.println("<option value='May'>May</option><option value='June'>June</option><option value='July'>July</option>");
			out.println("<option value='August'>August</option><option value='September'>September</option><option value='October'>October</option>");
			out.println("<option value='November'>November</option><option value='December'>December</option></select>");
			out.println("<select name='Day1'><option value='NULL'>Day</option>");
			out.println("<script language='JavaScript'>var i ;for(i=01; i<=31; i++){ document.write('<option value='+i+'><fond color=black>'+i+'</option>') ;}</script>");
			out.println("</select></td><tr><BR><td>To:</td><td><select name='Year2'><option value='NULL'>Year</option>");
			out.println("<script language='JavaScript'>var i ;for(i=2014; i>=1700; i--){ document.write('<option value='+i+'><fond color=black>'+i+'</option>') ;}</script>");
			out.println("</select><select name='Month2'><option value='NULL'>Month</option><option value='January'>January</option>");
			out.println("<option value='February'>February</option><option value='March' >March</option><option value='April'>April</option>");
			out.println("<option value='May'>May</option><option value='June'>June</option><option value='July'>July</option>");
			out.println("<option value='August'>August</option><option value='September'>September</option><option value='October'>October</option>");
			out.println("<option value='November'>November</option><option value='December'>December</option></select><select name='Day2'>");
			out.println("<option value='NULL'>Day</option><script language='JavaScript'>var i ;for(i=01; i<=31; i++){ document.write('<option value='+i+'><fond color=black>'+i+'</option>') ;}</script></select></td></tr></table>");
			out.println("<INPUT TYPE='submit' NAME='search1' VALUE='GO' style= 'width: 300; height: 30'></FORM>");
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
