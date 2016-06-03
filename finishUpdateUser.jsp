<HTML>
<HEAD>
<TITLE>Your Insert Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*"%>
<% 
	if((request.getParameter("finishupdate") != null) || (request.getParameter("finishownupdate") != null))
        {			
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    String userNameB=(String)session.getAttribute("username");
		    String emailB   =(String)session.getAttribute("emailid");

	        //get the user input
		    String firstName = request.getParameter("firstname");;
		    String lastName = request.getParameter("lastname");
		    String address = request.getParameter("address");
		    String email = request.getParameter("emailid");
		    String phone = request.getParameter("mobileno");
		    String personid = request.getParameter("personid");
		    Integer personID= Integer.parseInt(personid);
		    String userName = request.getParameter("username");
		    String passwd = request.getParameter("password");
		    
	        String classtype = "";
	        Integer doctorID = null;
	        
	        if(request.getParameter("finishupdate") != null)
	        	classtype= (request.getParameter("Class")).trim();
	        else
	        	classtype =  (String)session.getAttribute("classtype");
	        String patientnew = "";
	        String doctornew = "";
	        Integer patientNew = null;
	        Integer doctorNew = null;
	        if(request.getParameter("finishupdate") != null){
			    if (classtype.equals("d")){
			    	patientnew= (request.getParameter("List")).trim();
			    	patientNew= Integer.parseInt(patientnew);
			    }
			    else{
			    	doctornew= (request.getParameter("List")).trim();
			    	doctorNew= Integer.parseInt(doctornew);
			    }
		       	String doctorid = (request.getParameter("id")).trim();
		        doctorID= Integer.parseInt(doctorid);
	        }
	       	//out.println("<p><CENTER> Doctor ID(doctorID) is "+doctorID+"</CENTER></p>");
	       	//out.println("<p><CENTER>Doctor ID is "+doctorID+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input first name is "+firstName+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input last name is "+lastName+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input person ID is "+personID+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input address is "+address+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input email is "+email+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input phone is "+phone+"</CENTER></p>");
        
        	//out.println("<p><CENTER>Your input User Name is "+userName+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input password is "+passwd+"</CENTER></p>");
        	//out.println("<p><CENTER>Your input Class is "+classtype+"</CENTER></p>");
			//out.println("<p><CENTER>Your input User NameB is "+userNameB+"</CENTER></p>");
			//out.println("<p><CENTER>Your input emailB is "+emailB+"</CENTER></p>");
			
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
        	PreparedStatement pstmt2 = null;
        	PreparedStatement pstmt3 = null;
        	ResultSet rset = null;
        	Integer flag = 0;
        	
        	//check to see if one person has two account with same class
        	try{
        		pstmt = conn.prepareStatement("select class from users where person_id = "+personID+" and user_name <> '"+userName+"'");
        		rset = pstmt.executeQuery();
        		while(rset.next()){
        			String type = rset.getString(1);
        			if (classtype.equals(type)){
        				flag = 1;
        			}
        		}
						//updat person info
	        			pstmt = conn.prepareStatement("UPDATE persons SET first_name = ?, last_name = ?, address = ?, email = ?, phone = ? where "
	        					+"person_id = "+personID+"");
	          			pstmt.setString(1, firstName);
	          			pstmt.setString(2, lastName);
	          			pstmt.setString(3, address);
	          			pstmt.setString(4, email );
	          			pstmt.setString(5, phone );
	    		    	pstmt.executeUpdate();
	    		    	
	    		    //update user info
	        		if (!flag.equals(1)){
						if(userNameB.equals(userName)){
			        		pstmt2 = conn.prepareStatement("UPDATE users SET password = ?, class = ? where "
			        				+"person_id = "+personID+" AND user_name = '"+userNameB+"'");
			      			pstmt2.setString(1, passwd);
			      			pstmt2.setString(2, classtype);
					    	pstmt2.executeUpdate();
						}
						else{
			        		pstmt2 = conn.prepareStatement("UPDATE users SET user_name = ?, password = ?, class = ? where "
			        				+"person_id = "+personID+" AND user_name = '"+userNameB+"'");
			      			pstmt2.setString(1, userName);
			      			pstmt2.setString(2, passwd);
			      			pstmt2.setString(3, classtype);
					    	pstmt2.executeUpdate();
						}
	        		}
		        	else{
		        		out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
				    	out.println("<BR><BR><BR><BR><BR><BR><BR>");
			        	out.println("<BR><p><CENTER><b>Update Failed!</b></CENTER></p><br><br>");
			        	out.println("<BR><p><CENTER><b>One Person cannot has two accounts with same class!</b></CENTER></p><br><br>");
			        	out.println("<script language=javascript type=text/javascript>");
			        	out.println("setTimeout("+"\"javascript:location.href='chooseUpdateUser.html'\""+", 2500);");
			        	out.println("</script></div>");
		        	}
	        		flag = 0;
	        		
	        		//update family_doctor info
					if(request.getParameter("finishupdate") != null){
						if (classtype.equals("d")){
							if((doctorID.equals(-1)) && (!(patientNew.equals(-1)))){
				        		pstmt3 = conn.prepareStatement("INSERT INTO family_doctor (doctor_id, patient_id)"
				        				  +"VALUES(?, ?)");
				      			pstmt3.setInt(1, personID);
				      			pstmt3.setInt(2, patientNew);
						    	pstmt3.executeQuery();
							}
							else if ((!(doctorID.equals(-1))) && (!(patientNew.equals(-1)))){
				        		pstmt3 = conn.prepareStatement("UPDATE family_doctor SET patient_id = ? where "
				        				+"patient_id = "+doctorID+" AND doctor_id = "+personID+"");
				      			pstmt3.setInt(1, patientNew);
						    	pstmt3.executeUpdate();
							}
							else if((!(doctorID.equals(-1))) && (patientNew.equals(-1))){
				        		pstmt3 = conn.prepareStatement("DELETE FROM family_doctor where "
										+"patient_id = '"+doctorID+"' AND doctor_id = "+personID+"");
						    	pstmt3.executeUpdate();
							}
						}
						else{		
							//None and not remove
							if((doctorID.equals(-1)) && (!(doctorNew.equals(-1)))){
				        		pstmt3 = conn.prepareStatement("INSERT INTO family_doctor (doctor_id, patient_id)"
				        				  +"VALUES(?, ?)");
				      			pstmt3.setInt(1, doctorNew);
				      			pstmt3.setInt(2, personID);
						    	pstmt3.executeQuery();
							}
							else if((!(doctorID.equals(-1))) && (!(doctorNew.equals(-1)))){
				        		pstmt3 = conn.prepareStatement("UPDATE family_doctor SET doctor_id = ? where "
				        				+"patient_id = "+personID+" AND doctor_id = "+doctorID+"");
				      			pstmt3.setInt(1, doctorNew);
						    	pstmt3.executeUpdate();
							}
							//not None and remove
							else if((!(doctorID.equals(-1))) && (doctorNew.equals(-1))){
				        		pstmt3 = conn.prepareStatement("DELETE FROM family_doctor where "
										+"patient_id = "+personID+" AND doctor_id = "+doctorID+"");
						    	pstmt3.executeUpdate();
							}
						}
					}
	        		//display results
			    	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
			    	out.println("<BR><BR><BR><BR><BR><BR><BR>");
			    	out.println("<BR><p><CENTER><b>Update Successful!</b></CENTER></p>");  
			    	out.println("<script language=javascript type=text/javascript>");
					if(request.getParameter("finishupdate") != null)
						out.println("setTimeout("+"\"javascript:location.href='chooseUpdateUser.html'\""+", 1000);");
					else{
						//String classtype =  (String)session.getAttribute("classtype");
						if (classtype.equals("a"))
							out.println("setTimeout("+"\"javascript:location.href='admin.html'\""+", 1000);");
						else if (classtype.equals("d"))
							out.println("setTimeout("+"\"javascript:location.href='doctor.html'\""+", 1000);");
						else if (classtype.equals("r"))
							out.println("setTimeout("+"\"javascript:location.href='radiologist.html'\""+", 1000);");
						else if (classtype.equals("p"))
							out.println("setTimeout("+"\"javascript:location.href='patient.html'\""+", 1000);");
					}
			    	out.println("</script></div>");
        	}
	        catch(Exception ex){
	        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		    	out.println("<BR><BR><BR><BR><BR><BR><BR>");
	        	out.println("<BR><p><CENTER><b>Update Failed!</b></CENTER></p><br><br>");
				out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
		    	out.println("<script language=javascript type=text/javascript>");
				if(request.getParameter("finishupdate") != null)
					out.println("setTimeout("+"\"javascript:location.href='chooseUpdateUser.html'\""+", 2500);");
				else{
					//String classtype =  (String)session.getAttribute("classtype");
					if (classtype.equals("a"))
						out.println("setTimeout("+"\"javascript:location.href='admin.html'\""+", 2500);");
					else if (classtype.equals("d"))
						out.println("setTimeout("+"\"javascript:location.href='doctor.html'\""+", 2500);");
					else if (classtype.equals("r"))
						out.println("setTimeout("+"\"javascript:location.href='radiologist.html'\""+", 2500);");
					else if (classtype.equals("p"))
						out.println("setTimeout("+"\"javascript:location.href='patient.html'\""+", 2500);");
				}
		    	out.println("</script></div>");
				out.println("</div>");
				conn.rollback();
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

