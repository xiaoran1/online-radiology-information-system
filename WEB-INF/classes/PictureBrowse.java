import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import oracle.jdbc.driver.*;
import java.text.*;
import java.net.*;

/**
 *  A simple example to demonstrate how to use servlet to 
 *  query and display a list of pictures
 *
 *  @author  Li-Yan Yuan
 *
 */
public class PictureBrowse extends HttpServlet 
//implements SingleThreadModel 
{
    
    /**
     *  Generate and then send an HTML file that displays all the thermonail
     *  images of the photos.
     *
     *  Both the thermonail and images will be generated using another 
     *  servlet, called GetOnePic, with the photo_id as its query string
     *
     */
    public void doGet(HttpServletRequest request,
		      HttpServletResponse res)
	throws ServletException, IOException {

	//  send out the HTML file
	String rec_id  = request.getQueryString();
	res.setContentType("text/html");
	PrintWriter out = res.getWriter ();
	HttpSession session = request.getSession(true);
	String sqlname = (String)session.getAttribute("SQLUSERID");
	String sqlpwd =  (String)session.getAttribute("SQLPASSWD");

	out.println("<html>");
	out.println("<head>");
	out.println("<title> Photo List </title>");
	out.println("</head>");
	out.println("<body bgcolor=\"#666666\" text=\"#000000\" >");
	out.println("<center>");
	out.println("<table>");		
	/*
	 *   to execute the given query
	 */
	try {
	    String query = "select image_id from pacs_images "+
			"where record_id ="+ rec_id;

	    Connection conn = getConnected(sqlname,sqlpwd);
	    Statement stmt = conn.createStatement();
	    Statement stmt1 = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    ResultSet rset1 = stmt1.executeQuery(query);
	    String p_id = "";
	    if (rset1.next()){
		    out.println("<h3>Images for record " + rec_id);
		    out.println(":</h3>");
		    out.println("<p>Click Image to view Normal-size Image.");
		    out.println("Click Link below to view Full-size Image.</p>");
		    while (rset.next() ) {
			p_id = (rset.getObject(1)).toString();
		
			out.println("<tr>");
		       out.println("<a href=\"GetOnePic?normal"+p_id+"\">");
		       out.println("<img src=\"GetOnePic?"+p_id +
			           "\"></a></tr><br>");
		       out.println("<tr><a href=\"GetOnePic?big"+p_id+"\"> Full-Size Image</a>");
		       out.println("</tr><br><br><br>");
		    }
	    }
	    else{
	    	out.println("<br><br><h2><font color='white'>");
		out.println("There is no images for record " + rec_id);
		out.println("!</h2>");
	    }
	    stmt.close();
	    conn.close();
	} catch ( Exception ex ){ out.println( ex.toString() );}
    
	//out.println("<form action='search.jsp' method='post'>");
	//out.println("<input type='submit' name='picreturn' value='Return'>");
	//out.println("</form>");
	out.println("</table>");
	out.println("</body>");
	out.println("</html>");
    }
    
    /*
     *   Connect to the specified database
     */
    private Connection getConnected(String sqlname,String sqlpwd) throws Exception {

        /* one may replace the following for the specified database */
	String driverName = "oracle.jdbc.driver.OracleDriver";
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

	/*
	 *  to connect to the database
	 */
	Class drvClass = Class.forName(driverName); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,sqlname,sqlpwd) );
    }
}




