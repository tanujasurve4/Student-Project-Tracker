package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/DeleteProjectServlet")
public class DeleteProjectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Validate ID parameter
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("jsp/viewProjectDetail.jsp?error=InvalidID");
            return;
        }

        int id = Integer.parseInt(idParam);

        try (Connection con = DBConnection.getConnection()) {

            // 🔹 Step 1: Delete files
            PreparedStatement ps1 = con.prepareStatement(
                "DELETE FROM project_files WHERE project_id=?"
            );
            ps1.setInt(1, id);
            ps1.executeUpdate();

            // 🔹 Step 2: Delete project
            PreparedStatement ps2 = con.prepareStatement(
                "DELETE FROM projects WHERE id=?"
            );
            ps2.setInt(1, id);
            ps2.executeUpdate();

            // ✅ Redirect after success
            response.sendRedirect("jsp/viewProjectDetail.jsp?msg=Deleted");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/viewProjectDetail.jsp?error=SomethingWentWrong");
        }
    }
}