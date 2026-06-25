package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/AddNoticeServlet")
public class AddNoticeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String title = request.getParameter("title");
        String message = request.getParameter("message");

        HttpSession session = request.getSession();
        Integer teacherId = (Integer) session.getAttribute("teacher_id");

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO notices(title, message, teacher_id) VALUES (?, ?, ?)"
            );

            ps.setString(1, title);
            ps.setString(2, message);
            ps.setInt(3, teacherId);

            ps.executeUpdate();

            response.sendRedirect("jsp/adminDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}