package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/UpdateCommentServlet")
public class UpdateCommentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Get parameters safely
        String commentIdStr = request.getParameter("comment_id");
        String projectIdStr = request.getParameter("project_id");
        String comment = request.getParameter("comment");

        // ✅ Validation (VERY IMPORTANT)
        if (commentIdStr == null || projectIdStr == null || comment == null || comment.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/jsp/viewProjects.jsp?error=invalid");
            return;
        }

        int commentId = Integer.parseInt(commentIdStr);
        int projectId = Integer.parseInt(projectIdStr);

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "UPDATE comments SET comment=? WHERE id=?"
            );
            ps.setString(1, comment);
            ps.setInt(2, commentId);
            ps.executeUpdate();
            ps.close();

            // ✅ Redirect back to project detail page
            response.sendRedirect(request.getContextPath() + "/jsp/adminProjectDetail.jsp?id=" + projectId + "&msg=updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/adminProjectDetail.jsp?id=" + projectId + "&error=server");
        }
    }
}