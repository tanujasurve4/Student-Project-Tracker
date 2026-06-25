package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/AddCommentServlet")
public class AddCommentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer teacherId = (Integer) session.getAttribute("teacher_id"); // Admin/teacher ID
        int projectId = Integer.parseInt(request.getParameter("project_id"));
        String comment = request.getParameter("comment");

        if (teacherId == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO comments(project_id, teacher_id, comment) VALUES(?,?,?)"
            );
            ps.setInt(1, projectId);
            ps.setInt(2, teacherId);
            ps.setString(3, comment);
            ps.executeUpdate();
            ps.close();

            // ✅ Redirect back to same project detail page
            response.sendRedirect(request.getContextPath() + "/jsp/adminProjectDetail.jsp?id=" + projectId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}