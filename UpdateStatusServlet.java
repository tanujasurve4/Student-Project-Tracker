package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))){
            response.sendRedirect("../index.jsp");
            return;
        }

        String projectIdStr = request.getParameter("project_id");
        String status = request.getParameter("status");
        String ratingStr = request.getParameter("rating");

        if(projectIdStr == null || status == null || ratingStr == null){
            response.sendRedirect(request.getContextPath() + "/jsp/viewAllProjects.jsp");
            return;
        }

        try {
            int projectId = Integer.parseInt(projectIdStr);
            int rating = Integer.parseInt(ratingStr);

            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement(
                        "UPDATE projects SET status=?, rating=? WHERE id=?"
                );
                ps.setString(1, status);
                ps.setInt(2, rating);
                ps.setInt(3, projectId);
                ps.executeUpdate();
                ps.close();
            }

            // ✅ Redirect back to the same project detail page
            response.sendRedirect(request.getContextPath() + "/jsp/adminProjectDetail.jsp?id=" + projectId);

        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().println("Error updating status: " + e.getMessage());
        }
    }
}