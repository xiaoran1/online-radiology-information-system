<HTML>
<HEAD>
<TITLE>Your Insert Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*"  import="java.text.SimpleDateFormat" import= "java.util.*"%>
<% 
	if(request.getParameter("newuser") != null)
        {			
			//get oracle account information
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    String skip =  (String)session.getAttribute("newuserskip");
		    
	        //get the user input from the login page
        	String userName = (request.getParameter("username")).trim();
	        String passwd   = (request.getParameter("password")).trim();
	        String classtype= (request.getParameter("Class")).trim();
	        session.setAttribute("Class",classtype);
	        Integer personID = null;
	        String personid = "";
	        
	        //check for skip
	        if(skip != null){
	        	//if user do not provide person ID, return bad response
		        if ((request.getParameter("personid") == "")){
		        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		        	out.println("<BR><BR>");
		        	out.println("<BR><p><CENTER><b>Insert Failed!</b></CENTER></p>");
		        	out.println("<BR><p><CENTER><b>Please provide your Person ID!</b></CENTER></p>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='newuser.html'\""+", 2500);");
			    	out.println("</script></div>");
		        }
		        else{
		        	//get the person ID from the web pages
	        		personid = (request.getParameter("personid"));
	        		personID= Integer.parseInt(personid);
	        		session.setAttribute("personid",personID);
		        }
	        }
	        else{
	        	//get person ID from the person which is just registed
		        personid = (String)session.getAttribute("personid");
		        personID= Integer.parseInt(personid);
	        }
       
			//get system date
	        SimpleDateFormat sy1=new SimpleDateFormat("dd-MMMM-yyyy");
	        java.util.Date myDate = new java.util.Date();
	        java.sql.Date sqlDate = new java.sql.Date(myDate.getTime());
	        
        	//out.println("<p><CENTER>Your input User Name is "+userName+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input password is "+passwd+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input Class is "+classtype+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input person ID is "+personID+"</CENTER></p>");

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
	
	        //Insert all user information to DB
        	PreparedStatement pstmt = null;
        	
	        //out.println(sql);
	        if (personID != null){
	        	try{	   	
		        	pstmt = conn.prepareStatement("INSERT INTO USERS (user_name, password, class, person_id, date_registered)"
		                      +"values(?, ?, ?, ?, ?)");
	
			        pstmt.setString(1, userName);
			    	pstmt.setString(2, passwd);
			    	pstmt.setString(3, classtype);
			    	pstmt.setInt(4, personID);
			    	pstmt.setDate(5, sqlDate );
			    	pstmt.executeQuery();
			    	
			    	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
			    	out.println("<BR><p><CENTER><b>Insert Successful!</b></CENTER></p>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='newdoctor.jsp'\""+", 1000);");
			    	out.println("</script></div>");
	        	}
	
		        catch(Exception ex){
		        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		        	out.println("<BR><p><CENTER>Insert Failed!</CENTER></p><br><br>");
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='newuser.html'\""+", 2500);");
			    	out.println("</script></div>");
			        out.println("</div>");
			        conn.rollback();
	            }
	        }
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

