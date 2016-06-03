<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("search1") != null)
        {			
			String sqlname = (String)session.getAttribute("SQLUSERID");
			String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
			
			String fname = (request.getParameter("fname")).trim();
			String lname = (request.getParameter("lname")).trim();
			String type1 = (request.getParameter("Type1")).trim();
	        String year1 = (request.getParameter("Year1")).trim();
	        String month1 = (request.getParameter("Month1")).trim();
	        String day1 = (request.getParameter("Day1")).trim();
	        String year2 = (request.getParameter("Year2")).trim();
	        String month2 = (request.getParameter("Month2")).trim();
	        String day2 = (request.getParameter("Day2")).trim();
	        
	        //session.setAttribute("USERID",userName);
	        out.println("<HTML><HEAD><TITLE>Data Analysis Result</TITLE></HEAD><BODY>");
	        out.println("<div id='image' style='background: url(47.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        
	        out.println("<BR><BR><BR><BR><BR><BR><BR><BR><BR>");
	        /*
        	out.println("<p><CENTER>Your input fname is "+fname+"</CENTER></p>");
        	out.println("<p><CENTER>Your input lname is "+lname+"</CENTER></p>");
        	out.println("<p><CENTER>Your input type is "+type1+"</CENTER></p>");
        	out.println("<p><CENTER>Your input starting date is "+day1+" - "+month1+" - "+year1+"</CENTER></p>");
        	out.println("<p><CENTER>Your input ending date is "+day2+" - "+month2+"-"+year2+"</CENTER></p>");*/
        	


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
        	String time1="";
        
			if(!year1.equals("NULL") && !month1.equals("NULL") && !day1.equals("NULL") && !year2.equals("NULL") && !month2.equals("NULL") && !month2.equals("NULL")){
				time1="T";
				//out.println("time selected");
			}
			else if (year1.equals("NULL") && month1.equals("NULL") && day1.equals("NULL") && !year2.equals("NULL") && !month2.equals("NULL") && !month2.equals("NULL")){
				time1="B";//alter
				//out.println("time of day givenB");
				day1=day2;
				month1=month2;
				year1=year2;
			}
			else if(!year1.equals("NULL") && !month1.equals("NULL") && !day1.equals("NULL") && year2.equals("NULL") && month2.equals("NULL") && month2.equals("NULL")){
				time1="A";
				//out.println("time of day givenA");
				day2=day1;
				month2=month2;
				year1=year1;
			}
			else{
				time1="F";
				//out.println("time not completely selected");
				}
	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
	        Statement stmt2 = null;
	        ResultSet rset2 = null;
	        String sql="";
	         //base case
	        if (fname=="" && lname=="" && type1=="" && time1=="F"){
	        	out.println("<p><CENTER>-----NUMBER OF ALL PICTURES:</CENTER></p>");
	        	sql = "select count(*) from pacs_images";
	        }
	        else if (fname=="" && lname!="" || fname!="" && lname==""){
	        	out.println("<p><CENTER>-----Please enter enter a complete name:</CENTER></p>");
	        	out.println("<p><CENTER>-----NUMBER OF ALL PICTURES:</CENTER></p>");
	        	sql = "select count(*) from pacs_images";
	        }
	      //********SINGLE***********
	        else if(fname!="" && lname!="" && type1=="" && time1=="F"){
	        	out.println("<p><CENTER>-----NUMBER OF PICTURES FOR THE PATIENT:</CENTER></p>");
	        	sql = "select count(*) from radiology_record rr,persons p,pacs_images pp "
	        	+"where rr.patient_id = p.person_id and pp.record_id = rr.record_id and p.first_name = '"+fname+"' and p.last_name = '"+lname+"'";
	        }
	        else if(fname=="" && lname=="" && type1!="" && time1=="F"){
	        	out.println("<p><CENTER>-----NUMBER OF PICTURES FOR THE TEST_TYPE:</CENTER></p>");
	        	sql = "select count(*) from radiology_record rr,pacs_images pp "
	        	+"where rr.test_type = '"+type1+"' and pp.record_id = rr.record_id";
	        }
	        else if(fname=="" && lname=="" && type1=="" && (time1=="T"||time1=="A"||time1=="B")){
	        	out.println("<p><CENTER>------NUMBER OF PICTURES FOR THE TIME PERIOD:</CENTER></p>");
	        	sql ="select count(*) from radiology_record rr,pacs_images pp where rr.test_date between '"+day1+" - "+month1+" - "+year1+"' and '"+day2+" - "+month2+"-"+year2+"' and pp.record_id = rr.record_id";               
	        }
	        //***********************DOUBLE***************
	        else if(fname!="" && lname!="" && type1!="" && time1=="F"){
	        	out.println("<p><CENTER>------NUMBER OF PICTURES FOR THE( PATIENT && TEST_TYPE):</CENTER></p>");
	        	sql = "select count(*) from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id and rr.test_type='"+type1+"' and p.first_name='"+fname+"'and p.last_name ='"+lname+"'";
	        }
	        else if(fname!="" && lname!="" && type1=="" && (time1=="T"||time1=="A"||time1=="B")){
	        	out.println("<p><CENTER>------NUMBER OF PICTURES FOR THE( PATIENT && TIME INTERVAL):</CENTER></p>");
	        	sql = "select count(*) from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id and p.first_name= '"+fname+"' and p.last_name ='"+lname+"' and rr.test_date between '"+day1+" - "+month1+" - "+year1+"' and '"+day2+" - "+month2+"-"+year2+"'";       
	        }
	        else if (fname=="" && lname=="" && type1!="" && (time1=="T"||time1=="A"||time1=="B")){
	        	out.println("<p><CENTER>------NUMBER OF PICTURES FOR THE( TEST_TYPE &&  TIME INTERVAL):</CENTER></p>");
	        	sql = "select count(*) from radiology_record rr,pacs_images pp where rr.test_type= '"+type1+"' and pp.record_id = rr.record_id and rr.test_date between '"+day1+" - "+month1+" - "+year1+"' and '"+day2+" - "+month2+"-"+year2+"'";
	        }
	        //--**************TRIPLE***********************
	        else if (fname!="" && lname!="" && type1!="" && (time1=="T"||time1=="A"||time1=="B")){
	        	out.println("<p><CENTER>------NUMBER OF PICTURES FOR THE( PATIENT &&  TEST_TYPE &&  TIME INTERVAL):</CENTER></p>");
	        	sql = "select count(*) from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id and rr.test_type='"+type1+"' and p.first_name='"+fname+"' and p.last_name ='"+lname+"' and rr.test_date between '"+day1+" - "+month1+" - "+year1+"' and '"+day2+" - "+month2+"-"+year2+"'";
	        }
	        else{
	        	out.println("<p><CENTER>-----Please enter an complete time interval or complete name</CENTER></p>");
	        }
	        
        	//out.println("sql is :");
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
        	
        	out.println("<p><CENTER>RESULT IS:" +basecase+ " PICTURES</p></CENTER>");	
        	out.println("<center><FORM ACTION='dataAnalisis1.jsp' METHOD='post' >");
        	out.println("<INPUT TYPE='submit' NAME='go1' VALUE='Prescribe another one' style= 'width: 300; height: 30'></FORM></center>");
			out.println("<center><FORM ACTION='admin.html' METHOD='post' ><INPUT TYPE='submit' NAME='ad_back' VALUE='GO BACK TO ADMIN' style= 'width: 300; height: 30'></FORM></center></div></BODY></HTML>");
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
