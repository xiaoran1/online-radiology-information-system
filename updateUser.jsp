<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 
	if ((request.getParameter("search") != null) || (request.getParameter("manage") != null))
        {			
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    String userName = "";
		    
	        //get the user input from the login page
	        if(request.getParameter("search") != null)
        		userName = (request.getParameter("search_content")).trim();
	        else
	        	userName = (String)session.getAttribute("USERID");
        	//out.println("<p><CENTER>The username is "+userName+"</CENTER></p>");
        	
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
		        if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
	

        	Statement stmt = null;
	        ResultSet rset = null;
	        Statement stmt2 = null;
	        ResultSet rset2 = null;
	        Statement stmt3 = null;
	        ResultSet rset3 = null;
	        Statement stmt4 = null;
	        ResultSet rset4 = null;
	        Statement stmt5 = null;
	        ResultSet rset5 = null;
	        Statement stmt6 = null;
	        ResultSet rset6 = null;
	        Statement stmt7 = null;
	        ResultSet rset7 = null;
	        
	    	String user = "select * from users where user_name = '"+userName+"'";
	    	String vaildate = "select count(*) from users where user_name = '"+userName+"'";
	    	
	        String firstName= ""; 
	        String lastName= ""; 
	        String address= ""; 
	        String email= ""; 
	        String phone= "";
			String personID= ""; 
			String password= ""; 
			String type= ""; 
			String date= "";
			Integer personid = null;
			String vaildnum = "";
			
			ArrayList<Integer> idList = new ArrayList<Integer>();
			ArrayList<Integer> pidList = new ArrayList<Integer>();
			ArrayList<Integer> didList = new ArrayList<Integer>();
			ArrayList<Integer> ppidList = new ArrayList<Integer>();
			ArrayList<String> nameList = new ArrayList<String>();
			ArrayList<String> dnameList = new ArrayList<String>();
			
			//check for existance of the user name
        	try{
	        	stmt7 = conn.createStatement();
		        rset7 = stmt7.executeQuery(vaildate);
        	}
	
	        catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
        	while(rset7 != null && rset7.next()){
        		vaildnum = (rset7.getString(1)).trim();
        	}
        	
        	//if not exist, return bad responses
        	if (vaildnum.equals("0")){
	        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        	out.println("<BR><p><CENTER>The User Name dose not exist!</CENTER></p><br><br>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='chooseUpdateUser.html'\""+", 1000);");
		    	out.println("</script></div>");
				out.println("</div>");
        	}
        	
        	//get all user info for this accout
        	try{
        		stmt2 = conn.createStatement();
	        	rset2 = stmt2.executeQuery(user); 
        	}
	
	        catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
        	while(rset2 != null && rset2.next()){
        		password = (rset2.getString(2));
        		type     = (rset2.getString(3));
        		personID = (rset2.getString(4));
        		date     = (rset2.getString(5));
        		personid= Integer.parseInt(personID);
        	}
        	
        	String person = "select * from persons where person_id = '"+personid+"'";
        	String doctor = "select distinct doctor_id from family_doctor where patient_id = '"+personid+"'";
        	String patient = "select distinct patient_id from family_doctor where doctor_id = '"+personid+"'";
        	String doctorlist = "select distinct person_id from users where class = 'd'";
        	String patientlist = "select distinct person_id from users where class = 'p'";
        	
			//get all person info for this account
        	try{
	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(person);
        	}
	
	        catch(Exception ex){
	        	out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
		
        	while(rset != null && rset.next()){
        		firstName = (rset.getString(2));       	    
        		lastName  = (rset.getString(3));
        		address   = (rset.getString(4));
        		email     = (rset.getString(5));
        		phone     = (rset.getString(6));
        	}       	
      
        	//get all doctors of this account
        	try{
        		stmt4 = conn.createStatement();
	        	rset4 = stmt4.executeQuery(doctor); 
        	}
	
	        catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

        	while(rset4 != null && rset4.next()){
        		Integer k= new Integer(rset4.getInt(1));
        		idList.add(k);
        	}
           
        	//get all doctor ID into list
        	try{
        		stmt3 = conn.createStatement();
	        	rset3 = stmt3.executeQuery(doctorlist); 
        	}
	
	        catch(Exception ex){
		        if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

        	while(rset3 != null && rset3.next()){
        		Integer J= new Integer(rset3.getInt(1));
        		didList.add(J);
        	}
        	
        	if (type.equals("d")){
        	
	        	//if this account is a doctor, get his patients
	        	try{
	        		stmt6 = conn.createStatement();
		        	rset6 = stmt6.executeQuery(patient); 
	        	}
		
		        catch(Exception ex){
			        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}
	      	
	        	while(rset6 != null && rset6.next()){
	        		Integer k= new Integer(rset6.getInt(1));
	        		pidList.add(k);
	        	}
	        	
	        	//get all paients and put them into list
	        	try{
	        		stmt5 = conn.createStatement();
		        	rset5 = stmt5.executeQuery(patientlist); 
	        	}
		
		        catch(Exception ex){
			        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}

	        	while(rset5 != null && rset5.next()){
	        		Integer J= new Integer(rset5.getInt(1));
	        		ppidList.add(J);
	        	}
        	}           
            if(request.getParameter("search") != null){ 
            	int n;
            	int m;
            	String dname = "";
            	String name = "";
            	
            	if (type.equals("d"))
            		n = ppidList.size();
            	else
            		n = didList.size();
            	
            	//get patient/doctor names
				for(int i = 0; i < n ; i++){
					if (type.equals("d"))
						dname = "select p.first_name, p.last_name from persons p where person_id = "+ppidList.get(i)+"";
					else
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
				
		        	while(rset != null && rset.next()){
		        		F = (rset.getString(1));
		        		L = (rset.getString(2));
		        		Name = F+" "+L;
		        		dnameList.add(Name);
		        	} 
				}
            	//get patient/doctor names
            	if (type.equals("d"))
            		m = pidList.size();
            	else
					m = idList.size();
            	
				for(int i = 0; i < m ; i++){
					if (type.equals("d"))
						name = "select p.first_name, p.last_name from persons p where person_id = "+pidList.get(i)+"";
					else
						name = "select p.first_name, p.last_name from persons p where person_id = "+idList.get(i)+"";
		        	
		        	stmt = null;
			        rset = null;
			        String F = "";
			        String L = "";
			        String Name ="";
		        	try{
			        	stmt = conn.createStatement();
				        rset = stmt.executeQuery(name);
		        	}
			
			        catch(Exception ex){
				        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
		        	}
				
		        	while(rset != null && rset.next()){
		        		F = (rset.getString(1));
		        		L = (rset.getString(2));
		        		Name = F+" "+L;
		        		nameList.add(Name);
		        	} 
				}  	
            }
            try{
                conn.close();
        	}
        	catch(Exception ex){
                out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
            
        	//display the result	        
			out.println("<html><head><script type='text/javascript' src='updateuser.js'></script></head>");
			out.println("<body><div style='background: url(10.jpg); width: 100%; height: 100%; background-size: 100%;'>");
			out.println("<form action='finishUpdateUser.jsp' name='updateUser' onsubmit='return(validate());'>");
			out.println("<table  cellpadding='2' align='center' cellspacing='2'>");
			out.println("<tr><td colspan=2><center><font size=4><b>User Infomation Update Form</b></font></center></td></tr>");
			out.println("<tr><td colspan=2><center>Account Infomation</center></td></tr>");
			out.println("<tr><td colspan=2><hr></td></tr>");
			if(request.getParameter("search") != null)
				out.println("<tr><td>User Name:</td><td><input type=text name='username' id='username' size='30' value='"+userName+"' maxlength=24></td></tr>");
			else
				out.println("<tr><td>User Name:</td><td><input type=text name='username' id='username' size='30' value='"+userName+"' maxlength=24 readonly></td></tr>");
			out.println("<tr><td>Password:</td><td><input type='password' name='password' id='password' size='30' value='"+password+"' maxlength=24></td></tr>");
			if(request.getParameter("search") != null){
				out.println("<tr><td>Class:</td><td><select name='Class'>");
				if (type.equals("a"))
					out.println("<option value='a' selected");
				else
					out.println("<option value='a'");
				if (type.equals("d"))
					out.println(">Administrator</option><option value='d' selected");
				else
					out.println(">Administrator</option><option value='d'");
				if (type.equals("r"))
					out.println(">Doctor</option><option value='r' selected");
				else
					out.println(">Doctor</option><option value='r'");
				if (type.equals("p"))
					out.println(">Radiologist</option><option value='p' selected");
				else
					out.println(">Radiologist</option><option value='p'");
				out.println(">Patient</option></select></td></tr>");
			}
			out.println("<tr><td colspan=2><hr></td></tr><tr><td colspan=2><center>personal Infomation</center></td></tr>");
			out.println("<tr><td colspan=2><hr></td></tr>");
			out.println("<tr><td>First Name:</td><td><input type=text name=firstname id='firstname' size='30' value='"+firstName+"' maxlength=24></td></tr>");
			out.println("<tr><td>Last Name:</td><td><input type='text' name='lastname' id='lastname' size='30' value='"+lastName+"' maxlength=24></td></tr>");
			out.println("<td>Person ID:</td><td><input type='text' name='personid' id='personid' size='30' value='"+personid+"' readonly></td></tr>");
			out.println("<td>Address:</td><td><input type='text' name='address' id='address' size='30' value='"+address+"' maxlength=128></td></tr>");
			out.println("<tr><td>Email:</td><td><input type='text' name='emailid' id='emailid' size='30' value='"+email+"' maxlength=128></td></tr>");
			out.println("<tr><td>Phone Number:</td><td><input type='text' name='mobileno' id='mobileno' size='30' value='"+phone+"' maxlength=10></td></tr>");
			out.println("<tr><td colspan=2><hr></td></tr><tr>");
			if(request.getParameter("search") != null){
				out.println("<tr><td colspan=2><center>Family Doctor</center></td></tr>");
				out.println("<tr><td colspan=2><hr></td></tr>");		
				if (type.equals("d")){
					out.println("<tr><td>Patient ID & Name:</td><td colspan=2>");
					int n = pidList.size();
					for(int i = 0; i < n ; i++)
						out.println("<input type='radio' name='id' value="+pidList.get(i)+">"+pidList.get(i)+" "+nameList.get(i)+"<br>");
					out.println("<input type='radio' name='id' value=-1 checked >None/add new");
		        	out.println("</td></tr>"); 
		        	out.println("<tr><td>New ID:</td><td colspan=2>");
		        	out.println("<select name='List'><option value='-1'>remove</option>");
		        	int m = ppidList.size();
		        	for(int i = 0; i < m; i++)
		        		out.println("<option value="+ppidList.get(i)+">"+ppidList.get(i)+" "+dnameList.get(i)+"</option>");
				}
				else{
					out.println("<tr><td>Doctor ID & Name:</td><td colspan=2>");
					int n = idList.size();
					for(int i = 0; i < n ; i++)
						out.println("<input type='radio' name='id' value="+idList.get(i)+">"+idList.get(i)+" "+nameList.get(i)+"<br>");
					out.println("<input type='radio' name='id' value=-1 checked >None/add new");
		        	out.println("</td></tr>"); 
		        	//out.println("<tr><td colspan=2>select the doctor you want to update.</td></tr>");
		        	out.println("<tr><td>Update to:</td><td colspan=2>");
		        	out.println("<select name='List'><option value='-1'>remove</option>");
		        	int m = didList.size();
		        	for(int i = 0; i < m; i++)
		        		out.println("<option value="+didList.get(i)+">"+didList.get(i)+" "+dnameList.get(i)+"</option>");
				}
	        	out.println("</select></td></tr>"); 
				out.println("<tr><td colspan=2><hr></td></tr>");
			}
			if(request.getParameter("search") != null){
				out.println("<tr><td colspan=2><center><input type='submit' name='finishupdate' value='Save Changes'></center></td></tr><br>");
				out.println("</table></form>");
				out.println("<form action='chooseUpdateUser.html'>");
			}
			else{
				out.println("<tr><td colspan=2><center><input type='submit' name='finishownupdate' value='Save Changes'></center></td></tr><br>");
				out.println("</table></form>");
				String classtype =  (String)session.getAttribute("classtype");
				if (classtype.equals("a"))
					out.println("<form action='admin.html'>");
				else if (classtype.equals("d"))
					out.println("<form action='doctor.html'>");
				else if (classtype.equals("r"))
					out.println("<form action='radiologist.html'>");
				else if (classtype.equals("p"))
					out.println("<form action='patient.html'>");
			}
			out.println("<center><input type='submit' name='updateback' value='back'><br><br><a href='userDocumentation.html'>Need help?</a></center></form></body></html>");
			session.setAttribute("username",userName);
			session.setAttribute("emailid",email);
        }

  
%>



</BODY>
</HTML>