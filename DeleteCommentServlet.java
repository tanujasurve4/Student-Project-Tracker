package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/DeleteCommentServlet")
public class DeleteCommentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int commentId = Integer.parseInt(request.getParameter("id"));
        int projectId = 0; // default

        try (Connection con = DBConnection.getConnection()) {

            // First get projectId for the comment
            PreparedStatement psGet = con.prepareStatement("SELECT project_id FROM comments WHERE id=?");
            psGet.setInt(1, commentId);
            ResultSet rs = psGet.executeQuery();
            if (rs.next()) {
                projectId = rs.getInt("project_id");
            }
            rs.close();
            psGet.close();

            // Delete comment
            PreparedStatement ps = con.prepareStatement("DELETE FROM comments WHERE id=?");
            ps.setInt(1, commentId);
            ps.executeUpdate();
            ps.close();

            // ✅ Redirect back to the project detail page
            response.sendRedirect(request.getContextPath() + "/jsp/adminProjectDetail.jsp?id=" + projectId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}