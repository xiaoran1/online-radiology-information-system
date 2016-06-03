<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 
	if (request.getParameter(".submit") != null)
        {			
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
			Integer rid      = (Integer)session.getAttribute("rid");
			
			//get the user input from the login page
			String patientId=  (request.getParameter("patientList")).trim();
			String doctorId =  (request.getParameter("doctorList")).trim();
	        Integer patientID =  Integer.parseInt(patientId);
	        Integer doctorID =   Integer.parseInt(doctorId);
	        String testType =  (request.getParameter("testtype")).trim();
	        String diagnosis=  (request.getParameter("diagnosis")).trim();
	        String description=(request.getParameter("description")).trim();
			int rec_id;
        	//out.println("<p><CENTER>The username is "+userName+"</CENTER></p>");
        	
        	java.util.Date myDate = new java.util.Date();
	        java.sql.Date sqlDate = new java.sql.Date(myDate.getTime());
	        
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
        	
        	PreparedStatement pstmt = null;
	        Statement stmt = null;
	        ResultSet rset = null;      
        	
	        //insert into radiology_record
        	try{
        		stmt = conn.createStatement();
	    	    rset = stmt.executeQuery("SELECT rec_id.nextval from dual");
	    	    rset.next();
	    	    rec_id = rset.getInt(1);
	    	    
	    	    session.setAttribute("rec_id",rec_id);
	    	    //out.println("<p><CENTER>rec_id: "+rec_id+"</CENTER></p>");
	    	    
        		pstmt = conn.prepareStatement("INSERT INTO radiology_record (record_id,patient_id,doctor_id,radiologist_id,test_type,prescribing_date,test_date,diagnosis,description)"
        				  +"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)");
      			pstmt.setInt(1, rec_id);
      			pstmt.setInt(2, patientID);
      			pstmt.setInt(3, doctorID);
      			pstmt.setInt(4, rid);
      			pstmt.setString(5, testType );
      			pstmt.setDate(6, sqlDate );
      			pstmt.setDate(7, sqlDate );
      			pstmt.setString(8, diagnosis);
      			pstmt.setString(9, description);
		    	pstmt.executeQuery();

		    	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		    	out.println("<BR><p><CENTER><b>Insert Successful!</b></CENTER></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='uploading.html'\""+", 1000);");
		    	out.println("</script></div>");
        	}

	        catch(Exception ex){
	        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        	out.println("<BR><p><CENTER>Insert Failed!</CENTER></p><br><br>");
		        if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='record.jsp'\""+", 2500);");
		    	out.println("</script>");
		        out.println("</div>");
		        conn.rollback();
            }
            try{
                conn.close();
        	}
       		catch(Exception ex){
                if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

        }

  
%>



</BODY>
</HTML>