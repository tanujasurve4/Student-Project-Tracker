package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.util.DBConnection;

@WebServlet("/DeleteNoticeServlet")
public class DeleteNoticeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try(Connection con = DBConnection.getConnection()){
            PreparedStatement ps = con.prepareStatement("DELETE FROM notices WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e){ e.printStackTrace(); }

        response.sendRedirect("jsp/viewAllNotices.jsp");
    }
}