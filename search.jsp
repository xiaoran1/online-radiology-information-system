<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>
<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>
<BODY>

<%@page import="java.sql.*" import="java.text.SimpleDateFormat" import= "java.util.*"%>
<%@page import = "java.io.*"%>
<%@page import = "javax.servlet.*"%>
<%@page import = "javax.servlet.http.*" %><% 

	if(request.getParameter("search") != null)
        {			
		    out.println("<center>");
		    
		    //get oracle account
			String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    String classtype =  (String)session.getAttribute("classtype");
		    String userName =(String)session.getAttribute("USERID");
		    
		    //get input information
		    String search_text = (request.getParameter("search_content")).trim();

		    String Year      = (request.getParameter("Year")).trim();
		    String Month     = (request.getParameter("Month")).trim();
		    String Day       = (request.getParameter("Day")).trim();
		    String year      = (request.getParameter("YEAR")).trim();
		    String month     = (request.getParameter("MONTH")).trim();
		    String day       = (request.getParameter("DAY")).trim();
		    Integer person_ID = null;
		    Integer patient_ID = null;
		    String From = "";
		    String To = "";
		    
		    //add the date string togeher and if use do not give valid info, return bad response
		    if ((!Year.equals("NULL")) && (!Month.equals("NULL")) && (!Day.equals("NULL")))
				From= Day+"-"+Month+"-"+Year;
		    if ((!year.equals("NULL")) && (!month.equals("NULL")) && (!day.equals("NULL")))
				To= day+"-"+month+"-"+year;		    
		    if ((!Year.equals("NULL")) && (Month.equals("NULL")) && (Day.equals("NULL")))
		    	From= "1-January-"+Year;
		    if ((!year.equals("NULL")) && (month.equals("NULL")) && (day.equals("NULL")))
		    	To= "31-December-"+year;
			if (((Year.equals("NULL")) && (!Month.equals("NULL")) && (!Day.equals("NULL"))) || 
				((Year.equals("NULL")) && (Month.equals("NULL")) && (!Day.equals("NULL")))  ||
				((year.equals("NULL")) && (!month.equals("NULL")) && (!day.equals("NULL"))) ||
				((year.equals("NULL")) && (month.equals("NULL")) && (!day.equals("NULL")))  ||
				((!Year.equals("NULL")) && (!Month.equals("NULL")) && (Day.equals("NULL"))) ||
				((!year.equals("NULL")) && (!month.equals("NULL")) && (day.equals("NULL")))){
		    	out.println("<br><br>");
		    	out.println("<p><h2>please provide valid time period!</h2></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='search.html'\""+", 2500);");
		    	out.println("</script>");
			}
			else{
				//if user do not provide search context, return bad response
			    if (search_text.equals("")){
			    	out.println("<br><br>");
			    	out.println("<p><h2>please provide search content!</h2></p>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='search.html'\""+", 2500);");
			    	out.println("</script>");
			    }
			    else{
			    	//list for storage
				    ArrayList<Integer> idList = new ArrayList<Integer>();   	
			        ArrayList<String> nameList = new ArrayList<String>();
			        ArrayList<String> diaList = new ArrayList<String>();
			        ArrayList<String> descList = new ArrayList<String>();
			        ArrayList<Integer> pidList = new ArrayList<Integer>();
			        ArrayList<Integer> namescore = new ArrayList<Integer>();
			        ArrayList<Integer> diascore = new ArrayList<Integer>();
			        ArrayList<Integer> descscore = new ArrayList<Integer>();
			        ArrayList<Integer> patientList = new ArrayList<Integer>();
			        
			        
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
		 			
		 			//select person ID of this account
		 			String rid = "select person_id from users where user_name = '"+userName+"'";
		 			
		        	try{
		        		stmt = conn.createStatement();
			        	rset = stmt.executeQuery(rid); 
		        	}
			
			        catch(Exception ex){
				        	out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
		        	}

		        	while(rset != null && rset.next()){
		        		person_ID = new Integer(rset.getInt(1));		
		        	}
		        	
		        	//select patient ID of this person, if he is a doctor
		        	String pID = "select patient_id from family_doctor where doctor_id = '"+person_ID+"'";
		        	if (classtype.equals("d")){
			        	try{
			        		stmt = conn.createStatement();
				        	rset = stmt.executeQuery(pID); 
			        	}
				
				        catch(Exception ex){
					        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
			        	}
	
			        	while(rset != null && rset.next()){
			        		patient_ID = new Integer(rset.getInt(1));	
			        		patientList.add(patient_ID);
			        	}
		        	}
		        	
		        	//select all persons and put their first name and last name together and insert result full name into new table called fullname
		        	try{
		        		String sql = "select * from persons";
		        		String nameTable = "CREATE TABLE fullname (person_id int,full_name varchar(48),FOREIGN KEY(person_id) REFERENCES persons,PRIMARY KEY(person_id))";
			        	stmt = conn.createStatement();
			        	stmt.executeQuery(nameTable);
				        rset = stmt.executeQuery(sql);
				        String Name = "";
				        Integer pid;
			        	while(rset != null && rset.next()){
				        	pid = rset.getInt(1);
			        		String F = rset.getString(2).trim();
			        		String L = rset.getString(3).trim();
			        		Name = F+" "+L;
			        		idList.add(pid);
			        		nameList.add(Name);
			        	}	
			        	int n = nameList.size();
			        	for(int i = 0; i< n; i++){
			        		pstmt = conn.prepareStatement("INSERT INTO fullname (person_id, full_name)"
			        				  +"VALUES(?, ?)");
			      			pstmt.setInt(1, idList.get(i));
			      			pstmt.setString(2, nameList.get(i));
					    	pstmt.executeQuery();
			        	}
			        	//creat index for patient names
			        	String myindex = "CREATE INDEX myindex5 ON fullname(full_name) INDEXTYPE IS CTXSYS.CONTEXT";
			        	stmt.executeQuery(myindex);
			        	
			        	//search the input search content from the table fullname
			        	PreparedStatement doSearch = null;
			        	Integer person_id = null;
			        	doSearch=conn.prepareStatement("SELECT distinct score(1), person_id, full_name FROM fullname WHERE contains(full_name, ?, 1) > 0 order by score(1) desc");
			        	doSearch.setString(1, search_text);
			        	ResultSet rset1 = doSearch.executeQuery();
			        	
			        	//search the input search content from the table radiology_record for diagnosis
			        	doSearch=conn.prepareStatement("SELECT distinct score(1), diagnosis FROM radiology_record WHERE contains(diagnosis, ?, 1) > 0 order by score(1) desc");
			        	doSearch.setString(1, search_text);
			        	ResultSet rset2 = doSearch.executeQuery();
			        	
			        	//search the input search content from the table radiology_record for description
			        	doSearch=conn.prepareStatement("SELECT distinct score(1), description FROM radiology_record WHERE contains(description, ?, 1) > 0 order by score(1) desc");
			        	doSearch.setString(1, search_text);
			        	ResultSet rset3 = doSearch.executeQuery();
			        	
			        	//add the result into list 
			        	while(rset1.next())
			              {
			        		pidList.add(rset1.getInt(2));
			        		namescore.add(rset1.getInt(1));
			              } 
			        	while(rset2.next())
			              {
			        		diaList.add(rset2.getString(2));
			        		diascore.add(rset2.getInt(1));
			              } 
		
			        	while(rset3.next())
			              {
			        		descList.add(rset3.getString(2));
			        		descscore.add(rset3.getInt(1));
			              } 
			        	out.println("</table>");
			        	
			        	//put all searched result into a new table called resultSet
		        		String resultTable = "CREATE TABLE resultSet (record_id varchar(48),patient_id varchar(48),doctor_id varchar(48),"
		        				+"radiologist_id varchar(48),test_type varchar(48),P_date date, t_date date," 
		        				+"diagnosis varchar(128), description varchar(1024),Rank int)";
			        	stmt = conn.createStatement();
			        	stmt.executeQuery(resultTable);
			        	
			        	ResultSet rset4 = null;
			        	ResultSet rset5 = null;
			        	ResultSet rset6 = null;
			        	Integer x = pidList.size();
			        	Integer y = diaList.size();
			        	Integer z = descList.size();
			        	Integer rank = null;
			        	Integer rank1 = null;
			        	Integer rank2 = null;
			        	Integer rank3 = null;
			        	
			        	SimpleDateFormat sy1=new SimpleDateFormat("yyyy-mm-dd");
			        	
			        	//select result by use name
						for(int i = 0; i < x; i++){
							rank1 = namescore.get(i) * 6;
							doSearch=conn.prepareStatement("SELECT * FROM radiology_record WHERE patient_id = "+pidList.get(i)+"");
							rset4 = doSearch.executeQuery();
							while(rset4.next()){
				                String A = rset4.getString(1);
				                String B = rset4.getString(2);
				                String C = rset4.getString(3);
				                String D = rset4.getString(4);
				                String E = rset4.getString(5);
				                String f1 = rset4.getString(6);
				                String g1 = rset4.getString(7);
				    	        java.util.Date f = (java.util.Date)sy1.parse(f1);
				    	        java.sql.Date F = new java.sql.Date(f.getTime());
				    	        java.util.Date g = (java.util.Date)sy1.parse(g1);
				    	        java.sql.Date G = new java.sql.Date(g.getTime()); 
				                String H = rset4.getString(8);
				                String I = rset4.getString(9);
				                Integer J = rank1;
				                
				                //insert into new table
				        		pstmt = conn.prepareStatement("INSERT INTO resultSet (record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank)"
				        				  +"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				      			pstmt.setString(1, A);
				      			pstmt.setString(2, B);
				      			pstmt.setString(3, C);
				      			pstmt.setString(4, D);
				      			pstmt.setString(5, E);
				      			pstmt.setDate(6, F);
				      			pstmt.setDate(7, G);
				      			pstmt.setString(8, H);
				      			pstmt.setString(9, I);
				      			pstmt.setInt(10, J);
						    	pstmt.executeQuery();
							}
						}
						//select result by use diagnosis
						for(int j = 0; j < y; j++){
							rank2 = diascore.get(j) * 3;
							doSearch=conn.prepareStatement("SELECT * FROM radiology_record WHERE diagnosis = '"+diaList.get(j)+"'");
							rset4 = doSearch.executeQuery();
							while(rset4.next()){
				                String A = rset4.getString(1);
				                String B = rset4.getString(2);
				                String C = rset4.getString(3);
				                String D = rset4.getString(4);
				                String E = rset4.getString(5);
				                String f1 = rset4.getString(6);
				                String g1 = rset4.getString(7);
				    	        java.util.Date f = (java.util.Date)sy1.parse(f1);
				    	        java.sql.Date F = new java.sql.Date(f.getTime());
				    	        java.util.Date g = (java.util.Date)sy1.parse(g1);
				    	        java.sql.Date G = new java.sql.Date(g.getTime());
				                String H = rset4.getString(8);
				                String I = rset4.getString(9);
				                Integer J = rank2;
				                
				                //insert into new table
				        		pstmt = conn.prepareStatement("INSERT INTO resultSet (record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank)"
				        				  +"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				      			pstmt.setString(1, A);
				      			pstmt.setString(2, B);
				      			pstmt.setString(3, C);
				      			pstmt.setString(4, D);
				      			pstmt.setString(5, E);
				      			pstmt.setDate(6, F);
				      			pstmt.setDate(7, G);
				      			pstmt.setString(8, H);
				      			pstmt.setString(9, I);
				      			pstmt.setInt(10, J);
						    	pstmt.executeQuery();
							}
						}
						
						//select result by use description
						for(int k = 0; k < z; k++){
							rank3 = descscore.get(k);
							doSearch=conn.prepareStatement("SELECT * FROM radiology_record WHERE description = '"+descList.get(k)+"'");
							rset4 = doSearch.executeQuery();
							while(rset4.next()){
				                String A = rset4.getString(1);
				                String B = rset4.getString(2);
				                String C = rset4.getString(3);
				                String D = rset4.getString(4);
				                String E = rset4.getString(5);
				                String f1 = rset4.getString(6);
				                String g1 = rset4.getString(7);
				    	        java.util.Date f = (java.util.Date)sy1.parse(f1);
				    	        java.sql.Date F = new java.sql.Date(f.getTime());
				    	        java.util.Date g = (java.util.Date)sy1.parse(g1);
				    	        java.sql.Date G = new java.sql.Date(g.getTime()); 
				                String H = rset4.getString(8);
				                String I = rset4.getString(9);
				                Integer J = rank3;
				                
				                //inset into new table
				        		pstmt = conn.prepareStatement("INSERT INTO resultSet (record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank)"
				        				  +"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				      			pstmt.setString(1, A);
				      			pstmt.setString(2, B);
				      			pstmt.setString(3, C);
				      			pstmt.setString(4, D);
				      			pstmt.setString(5, E);
				      			pstmt.setDate(6, F);
				      			pstmt.setDate(7, G);
				      			pstmt.setString(8, H);
				      			pstmt.setString(9, I);
				      			pstmt.setInt(10, J);
						    	pstmt.executeQuery();
							}
						}
						
						//print result
						out.println("<br><br><br><br><br><br>");
						out.println("<h2><b>Search Result</b></h2>");
		                out.println("<table border=1>");
		                out.println("<tr>");
		                out.println("<th>Record ID</th>");
		                out.println("<th>Patient ID</th>");
		                out.println("<th>Doctor ID</th>");
		                out.println("<th>Radiologist ID</th>");
		                out.println("<th>Test Type</th>");
		                out.println("<th>Prescribing Date</th>");
		                out.println("<th>Test Date</th>");
		                out.println("<th>Diagnosis</th>");
		                out.println("<th>Description</th>");
		                out.println("<th>Rank</th>");
		                out.println("<th>Medical Pictures</th>");
		                out.println("</tr>");
		                String recid = "";
		                
		                //select distinct record from new table
		      			doSearch=conn.prepareStatement("SELECT distinct record_id FROM resultSet");
		        		rset6 = doSearch.executeQuery();
		        		
		        		//add rank for same record
		        		while(rset6.next()){
			        		doSearch=conn.prepareStatement("SELECT sum(Rank) FROM resultSet where record_id = "+rset6.getString(1)+"");
			        		rset5 = doSearch.executeQuery();
			        		while(rset5.next()){
			        			doSearch=conn.prepareStatement("UPDATE resultSet SET Rank = ? where record_id = "+rset6.getString(1)+"");
			        			doSearch.setString(1, rset5.getString(1));
			        			doSearch.executeQuery();
			        		}
		        		}
		        		//if the user is a doctor, print result of his patients
		        		if (classtype.equals("d")){
		        			int size = patientList.size();
		        			for(int h = 0; h < size; h++){
				        		if ((!From.equals("")) && (!To.equals(""))){
				        				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet "
				        						+"where patient_id = "+patientList.get(h)+" and t_date between '"+From+"' and '"+To+"' order by Rank desc");
				        		}
				        		else{
				      				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet where patient_id = "+patientList.get(h)+" order by Rank desc");
				        		}
				        		rset4 = doSearch.executeQuery();
					        	while(rset4.next())
					              {
					        		recid = rset4.getString(1);
					                out.println("<tr>");
					                out.println("<td>"); 
					                out.println(rset4.getString(1));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(2));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(3));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(4));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(5));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(6));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(7));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(8));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(9));
					                out.println("</td>");
					                out.println("<td>"); 
					                out.println(rset4.getString(10));
					                out.println("</td>");
					                out.println("<td>"); 
									out.println("<a href=\"PictureBrowse?"+recid+"\" target='_blank'>Pictures</a>");								
					                out.println("</td>");
					                out.println("</tr>");
					              }
		        			}
		        		}
		        		else{
		        			//if the user is admin, print all result
			        		if (classtype.equals("a")){
				        		if ((!From.equals("")) && (!To.equals(""))){
				        				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet "
				        						+"where t_date between '"+From+"' and '"+To+"' order by Rank desc");
				        		}
				        		else{
				      				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet order by Rank desc");
				        		}
			        		}
		        			//if the user is radiologist, print results that he inserted
			        		else if (classtype.equals("r")){
				        		if ((!From.equals("")) && (!To.equals(""))){
				        				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet "
				        						+"where radiologist_id = "+person_ID+" and t_date between '"+From+"' and '"+To+"' order by Rank desc");
				        		}
				        		else{
				      				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet where radiologist_id = "+person_ID+" order by Rank desc");
				        		}
			        		}
		        			//if the user is patient, print result of his record
			        		else if (classtype.equals("p")){
				        		if ((!From.equals("")) && (!To.equals(""))){
				        				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet "
				        						+"where patient_id = "+person_ID+" and t_date between '"+From+"' and '"+To+"' order by Rank desc");
				        		}
				        		else{
				      				doSearch=conn.prepareStatement("SELECT distinct record_id,patient_id,doctor_id,radiologist_id,test_type,P_date,t_date,diagnosis, description, Rank FROM resultSet where patient_id = "+person_ID+" order by Rank desc");
				        		}
			        		}
			        		
		        			//print all informaion
			        		rset4 = doSearch.executeQuery();
				        	while(rset4.next())
				              {	
				        		recid = rset4.getString(1);
				                out.println("<tr>");
				                out.println("<td>"); 
				                out.println(rset4.getString(1));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(2));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(3));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(4));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(5));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(6));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(7));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(8));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(9));
				                out.println("</td>");
				                out.println("<td>"); 
				                out.println(rset4.getString(10));
				                out.println("</td>");
				                out.println("<td>"); 
								out.println("<a href=\"PictureBrowse?"+recid+"\" target='_blank'>Pictures</a>");								
				                out.println("</td>");
				                out.println("</tr>");
				              }
		        		}
			        	out.println("</table>");
			        	out.println("<BR>");
			        	out.println("<form action='search.html' METHOD='post'>");
			        	out.println("<input type='submit' name='search_back' value='Back'>");
			        	out.println("<br><br><a href='userDocumentation.html' target='_blank'>Need help?</a></form>");        		
		        		
		        	}
			        catch(Exception ex){
				        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
				    	out.println("<script language=javascript type=text/javascript>");
				    	out.println("setTimeout("+"\"javascript:location.href='search.html'\""+", 2500);");
				    	out.println("</script>");
				        out.println("</div>");
				        conn.rollback();
		            }
					
		        	//dorp tables before close connection
		            try{
							String droptable  = "DROP TABLE fullname";
							String droptable2 = "DROP TABLE resultSet";
							stmt.executeQuery(droptable);
							stmt.executeQuery(droptable2);
		                    conn.close();
		            }
		            catch(Exception ex){
		                    out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
			        
		        	}
			    }
		    }
        }
%>

</div>
</BODY>
</HTML>

