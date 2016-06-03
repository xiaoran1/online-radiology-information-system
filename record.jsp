<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 
			//get oracle account
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    String userName =(String)session.getAttribute("USERID");
		    //out.println("<p><CENTER>Your input User Name is "+userName+"</CENTER></p>");

        	
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
	

	        //select patient ID and name, doctor ID and name
        	Statement stmt = null;
	        ResultSet rset = null;
	        Statement stmt2 = null;
	        ResultSet rset2 = null;
	        Statement stmt3 = null;
	        ResultSet rset3 = null;
			
			ArrayList<Integer> pidList = new ArrayList<Integer>();
			ArrayList<Integer> didList = new ArrayList<Integer>();
			ArrayList<String> pnameList = new ArrayList<String>();
			ArrayList<String> dnameList = new ArrayList<String>();
			
        	String doctorlist  = "select distinct person_id from users where class = 'd'";
        	String patientlist = "select distinct person_id from users where class = 'p'";
        	String rid = "select person_id from users where user_name = '"+userName+"'";
        	Integer rID = null;
        	
        	//doctor ID list
        	try{
        		stmt = conn.createStatement();
	        	rset = stmt.executeQuery(doctorlist); 
        	}
	
	        catch(Exception ex){
	        	out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

        	while(rset != null && rset.next()){
        		Integer d= new Integer(rset.getInt(1));
        		didList.add(d);
        	}

        	//patient ID list
        	try{
        		stmt2 = conn.createStatement();
	        	rset2 = stmt2.executeQuery(patientlist); 
        	}
	
	        catch(Exception ex){
		        if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

        	while(rset2 != null && rset2.next()){
        		Integer p= new Integer(rset2.getInt(1));
        		pidList.add(p);
        	}    
        	
        	//radiologist ID
        	try{
        		stmt3 = conn.createStatement();
	        	rset3 = stmt3.executeQuery(rid); 
        	}
	
	        catch(Exception ex){
		        if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

        	while(rset3 != null && rset3.next()){
        		rID = new Integer(rset3.getInt(1));		
        	} 

        	//name of doctor, patient, and radiologist
           	int n;
           	int m;
           	int l;
           	String dname = "";
           	String pname = "";
           	String rname = "";
           	

           	//doctor name
           	n = didList.size();
           	
			for(int i = 0; i < n ; i++){
				dname = "select p.first_name, p.last_name from persons p where person_id = "+didList.get(i)+"";
				
	        	stmt = null;
		        rset = null;
		        String F = "";
		        String L = "";
		        String Name ="";
	        	try{
		        	stmt = conn.createStatement();
			        rset = stmt.executeQuery(dname);
	        	}
		
		        catch(Exception ex){
			        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}
	        	
				//put them into list
	        	while(rset != null && rset.next()){
	        		F = (rset.getString(1)).trim();
	        		L = (rset.getString(2)).trim();
	        		Name = F+" "+L;
	        		dnameList.add(Name);
	        	} 
			}
			
			//patient name
			m = pidList.size();
           	
			for(int i = 0; i < m ; i++){
				pname = "select p.first_name, p.last_name from persons p where person_id = "+pidList.get(i)+"";
	        	
	        	stmt2 = null;
		        rset2 = null;
		        String F = "";
		        String L = "";
		        String Name ="";
	        	try{
		        	stmt2 = conn.createStatement();
			        rset2 = stmt2.executeQuery(pname);
	        	}
		
		        catch(Exception ex){
			        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}
			
	        	//put them into list
	        	while(rset2 != null && rset2.next()){
	        		F = (rset2.getString(1)).trim();
	        		L = (rset2.getString(2)).trim();
	        		Name = F+" "+L;
	        		pnameList.add(Name);
	        	}
			}
			
			//radiologist name
			rname = "select p.first_name, p.last_name from persons p where person_id = "+rID+"";
        	
        	stmt3 = null;
	        rset3 = null;
	        String F = "";
	        String L = "";
	        String rName ="";
        	try{
	        	stmt3 = conn.createStatement();
		        rset3 = stmt3.executeQuery(rname);
        	}
	
	        catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
		
        	while(rset3 != null && rset3.next()){
        		F = (rset3.getString(1)).trim();
        		L = (rset3.getString(2)).trim();
        		rName = F+" "+L;
        	}
        	 	    
            try{
                conn.close();
        	}
        	catch(Exception ex){
                out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
            
        	//display the result	        
			out.println("<HTML><HEAD><TITLE>Uploading</TITLE></HEAD><BODY>");
			out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
			out.println("<br><br><br><br><br><br><br><br><H1><CENTER>UPloading</CENTER></H1><br><br>");
			out.println("<FORM ACTION='InsertRecord.jsp' METHOD='post'><CENTER>");
			out.println("<table>");			
			out.println("<tr><td>Patient ID & Name:</td><td colspan=2>");
			int q = pidList.size();
        	out.println("<select name='patientList'><option value='-1'>select a patient..</option>");
        	for(int i = 0; i < q; i++)
        		out.println("<option value="+pidList.get(i)+">"+pidList.get(i)+" "+pnameList.get(i)+"</option>");
        	out.println("</select></td></tr>"); 
        	
        	out.println("<tr><td>Doctor ID & Name:</td><td colspan=2>");
			int w = didList.size();
        	out.println("<select name='doctorList'><option value='-1'>select a doctor..</option>");
        	for(int i = 0; i < w; i++)
        		out.println("<option value="+didList.get(i)+">"+didList.get(i)+" "+dnameList.get(i)+"</option>");
        	out.println("</select></td></tr>"); 
        	out.println("<tr><td>Radiologist ID & Name:</td><td>");
        	out.println(""+rID+" "+rName+"</td></tr>");
        	out.println("<tr><td>Test Type:</td><td><input type=text name=testtype></td></tr>");
        	out.println("<tr><td>Diagnosis:</td><td><textarea style='resize:none' rows = 4 cols = 32 name=diagnosis maxlength=128></textarea></td></td>");
        	out.println("<tr><td>Description:</td><td><textarea style='resize:none' rows = 5 cols = 40 name=description maxlength=1024></textarea></td></tr>");
			out.println("<tr><td ALIGN=CENTER COLSPAN=2><br><brs><input type='submit' name='.submit' value='Next'></td></tr></table>");
			out.println("</FORM><br><br><br><FORM ACTION='radiologist.html' METHOD='post'><INPUT TYPE='submit' NAME='ra_back' VALUE='Back'>");
			out.println("<br><br><a href='userDocumentation.html' target='_blank'>Need help?</a></FORM></div></CENTER></BODY></HTML>");
			//out.println("<p><CENTER>Your rid is "+rID+"</CENTER></p>");
			//out.println("<p><CENTER>Your rec_ID is "+rec_id+"</CENTER></p>");
			session.setAttribute("rid",rID);
%>



</BODY>
</HTML>
