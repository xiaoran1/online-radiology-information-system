<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 
	if (request.getParameter("ad_lg_submit") != null){
		
		//get oracle account
	    String sqlname   =  (String)session.getAttribute("SQLUSERID");
	    String sqlpwd    =  (String)session.getAttribute("SQLPASSWD");
	    
	    //get user input
	    String diagnosis = (request.getParameter("diagnosis"));
	    String Year      = (request.getParameter("Year"));
	    String Month     = (request.getParameter("Month"));
	    String Day       = (request.getParameter("Day"));
	    String year      = (request.getParameter("YEAR"));
	    String month     = (request.getParameter("MONTH"));
	    String day       = (request.getParameter("DAY"));

	    
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
    	Statement stmt1 = null;
        ResultSet rset1= null;
        
		String From= Day+"-"+Month+"-"+Year;
		String To= day+"-"+month+"-"+year;
        
        
		String getPersonalInfo="select p.first_name, p.last_name, p.address, p.phone from persons p where p.person_id = ";
        String listgener = "select p.person_id,min(rr.test_date), rr.diagnosis from persons p, radiology_record rr "
        		+"where p.person_id = rr.patient_id and rr.diagnosis = '"+diagnosis+"' and rr.test_date between '"+From+"' and '"+To+"' "
        		+"group by p.person_id, rr.diagnosis"; 
    	
        try{
    		stmt = conn.createStatement();
        	rset = stmt.executeQuery(listgener); 
    	}

        catch(Exception ex){
	        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
    	}
    	
        
        out.println("<HTML><HEAD><TITLE>Report Generating</TITLE></HEAD><BODY>");
        out.println("<div id='image' style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
        out.println("<br><br><br><br><br><br><br><br><H1><CENTER>Report Generating</CENTER></H1><CENTER>");
    	out.println("<table border=1>");
    	out.println("<tr>");
    	out.println("<th>First Name</th>");
    	out.println("<th>Last Name</th>");
    	out.println("<th>Address</th>");
    	out.println("<th>Phone</th>");
    	out.println("<th>First testing date</th>");
    	out.println("<th>Diagnosis</th>");
    	
    	String person_id="";
		String curr_pinfo = "";
    	while(rset != null && rset.next())
        {
    		curr_pinfo="";
    		person_id=(rset.getString(1));
    		//out.println("<center>"+person_id+"</center>");
    		curr_pinfo=getPersonalInfo+person_id;
    		//out.println("<center>"+curr_pinfo+"</center>");
	    	try{
	    		stmt1 = conn.createStatement();
	        	rset1 = stmt1.executeQuery(curr_pinfo); 
	    	}
	
	    	catch(Exception ex){
		  		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	      	}
	    	
	    	while(rset1 != null && rset1.next())
	        {
	
	          	out.println("<tr>");
	         	out.println("<td>"); 
	          	out.println((rset1.getString(1)));
	          	out.println("</td>");
	          	out.println("<td>"); 
	          	out.println((rset1.getString(2)));
	          	out.println("</td>");
	          	out.println("<td>");
	          	out.println((rset1.getString(3)));
	          	out.println("</td>");
	          	out.println("<td>");
	          	out.println((rset1.getString(4)));
	          	out.println("</td>");
	        }
         	out.println("<td>"); 
          	out.println((rset.getString(2)));
          	out.println("</td>");
          	out.println("<td>"); 
          	out.println((rset.getString(3)));
          	out.println("</td>");
	    	out.println("</tr>");
        } 
        out.println("</table>");
        out.println("<FORM ACTION='reportGenerating.html' METHOD='post' ><INPUT TYPE='submit' NAME='ad_back' VALUE='Back'>");
    	out.println("</FORM>");
    	out.println("</div></CENTER></BODY></HTML></FORM>");
        
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