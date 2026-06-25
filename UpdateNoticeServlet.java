package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.project.util.DBConnection;

@WebServlet("/UpdateNoticeServlet")
public class UpdateNoticeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {

        // Get parameters from form
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String message = request.getParameter("message");

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "UPDATE notices SET title=?, message=? WHERE id=?"
            );
            ps.setString(1, title);
            ps.setString(2, message);
            ps.setInt(3, id);

            ps.executeUpdate();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect to the notice listing page
        response.sendRedirect("jsp/viewAllNotices.jsp");
    }
}