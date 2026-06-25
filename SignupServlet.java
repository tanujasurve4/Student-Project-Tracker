package com.project.servlet;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Student fields
        String roll = request.getParameter("roll");
        String year = request.getParameter("year");
        String div = request.getParameter("div");
        String dept = request.getParameter("dept");

        // Teacher field
        String teacherDept = request.getParameter("teacherDept");

        try (Connection con = DBConnection.getConnection()) {

            // ✅ 1. Check duplicate email
            PreparedStatement check = con.prepareStatement(
                "SELECT id FROM users WHERE email=?"
            );
            check.setString(1, email);
            ResultSet rsCheck = check.executeQuery();

            if (rsCheck.next()) {
                response.sendRedirect("jsp/signup.jsp?error=email_exists");
                return;
            }

            // ✅ 2. Insert into USERS
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(email,password,role) VALUES(?,?,?)",
                Statement.RETURN_GENERATED_KEYS
            );

            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);

            int rows = ps.executeUpdate();

            if (rows == 0) {
                throw new Exception("User insert failed!");
            }

            // ✅ 3. Get generated user_id
            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            int userId = rs.getInt(1);

            // ✅ 4. Insert role-based data
            if ("student".equals(role)) {

                PreparedStatement ps2 = con.prepareStatement(
                    "INSERT INTO students(user_id,name,roll_no,year,division,department) VALUES(?,?,?,?,?,?)"
                );

                ps2.setInt(1, userId);
                ps2.setString(2, name);
                ps2.setString(3, roll);
                ps2.setString(4, year);
                ps2.setString(5, div);
                ps2.setString(6, dept);

                ps2.executeUpdate();

            } else if ("admin".equals(role)) {

                PreparedStatement ps2 = con.prepareStatement(
                    "INSERT INTO teachers(user_id,name,department) VALUES(?,?,?)"
                );

                ps2.setInt(1, userId);
                ps2.setString(2, name);
                ps2.setString(3, teacherDept); // ✅ FIXED

                ps2.executeUpdate();
            }

            // ✅ 5. Redirect to login
            response.sendRedirect("index.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/signup.jsp?error=server_error");
        }
    }
}