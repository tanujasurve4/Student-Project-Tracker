package com.project.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {

            // ✅ 1. Check user
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=? AND role=?"
            );
            ps.setString(1, email.trim());
            ps.setString(2, password.trim());
            ps.setString(3, role.trim());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                int userId = rs.getInt("id");
                String name = "";

                HttpSession session = request.getSession();

                // ✅ STUDENT LOGIN
                if ("student".equals(role)) {

                    PreparedStatement ps2 = con.prepareStatement(
                        "SELECT name FROM students WHERE user_id=?"
                    );
                    ps2.setInt(1, userId);
                    ResultSet rs2 = ps2.executeQuery();

                    if (rs2.next()) {
                        name = rs2.getString("name");
                    } else {
                        session.setAttribute("error", "Student details not found!");
                        response.sendRedirect("index.jsp");
                        return;
                    }

                    session.setAttribute("user_id", userId);
                    session.setAttribute("name", name);
                    session.setAttribute("role", role);
                    session.setAttribute("message", "Login successful! Welcome " + name);

                    response.sendRedirect("jsp/dashboard.jsp");

                }
                // ✅ ADMIN LOGIN
                else if ("admin".equals(role)) {

                    PreparedStatement ps2 = con.prepareStatement(
                        "SELECT id, name FROM teachers WHERE user_id=?"
                    );
                    ps2.setInt(1, userId);
                    ResultSet rs2 = ps2.executeQuery();

                    if (rs2.next()) {
                        name = rs2.getString("name");
                        session.setAttribute("teacher_id", rs2.getInt("id"));
                    } else {
                        session.setAttribute("error", "Teacher details not found!");
                        response.sendRedirect("index.jsp");
                        return;
                    }

                    session.setAttribute("user_id", userId);
                    session.setAttribute("name", name);
                    session.setAttribute("role", role);
                    session.setAttribute("message", "Login successful! Welcome " + name);

                    response.sendRedirect("jsp/adminDashboard.jsp");
                }

            } else {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Invalid email or password!");
                response.sendRedirect("index.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Something went wrong! Try again.");
            response.sendRedirect("index.jsp");
        }
    }
}