package com.project.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.util.DBConnection;

@WebServlet("/AddProjectServlet")
@MultipartConfig
public class AddProjectServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");

        // Get image and PDF parts
        Part[] imageParts = request.getParts().stream()
                .filter(p -> p.getName().equals("images") && p.getSize() > 0)
                .toArray(Part[]::new);

        Part[] pdfParts = request.getParts().stream()
                .filter(p -> p.getName().equals("pdfs") && p.getSize() > 0)
                .toArray(Part[]::new);

        if (title.isEmpty() || description.isEmpty() || imageParts.length == 0 || pdfParts.length == 0) {
            response.sendRedirect(request.getContextPath() + "/jsp/addProject.jsp?error=empty");
            return;
        }

        Connection con = null;
        PreparedStatement psProject = null;
        PreparedStatement psFile = null;

        try {
            con = DBConnection.getConnection();

            // 1️⃣ Insert project
            psProject = con.prepareStatement(
                    "INSERT INTO projects(user_id, title, description) VALUES (?, ?, ?)",
                    PreparedStatement.RETURN_GENERATED_KEYS
            );
            psProject.setInt(1, userId);
            psProject.setString(2, title);
            psProject.setString(3, description);
            int res = psProject.executeUpdate();

            if (res > 0) {
                ResultSet rs = psProject.getGeneratedKeys();
                int projectId = 0;
                if (rs.next()) projectId = rs.getInt(1);

                // 2️⃣ Insert images and PDFs
                psFile = con.prepareStatement(
                    "INSERT INTO project_files(project_id, file_type, file_name, file_data) VALUES (?, ?, ?, ?)"
                );

                for (Part image : imageParts) {
                    InputStream is = image.getInputStream();
                    psFile.setInt(1, projectId);
                    psFile.setString(2, "image");
                    psFile.setString(3, image.getSubmittedFileName());
                    psFile.setBlob(4, is);
                    psFile.addBatch();
                }

                for (Part pdf : pdfParts) {
                    InputStream is = pdf.getInputStream();
                    psFile.setInt(1, projectId);
                    psFile.setString(2, "pdf");
                    psFile.setString(3, pdf.getSubmittedFileName());
                    psFile.setBlob(4, is);
                    psFile.addBatch();
                }

                psFile.executeBatch();

                // ✅ 🔥 FINAL CHANGE HERE
                response.sendRedirect(request.getContextPath() + "/jsp/viewProjects.jsp?msg=added");

            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/addProject.jsp?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/addProject.jsp?error=server");
        } finally {
            try { if(psProject != null) psProject.close(); } catch(Exception e) {}
            try { if(psFile != null) psFile.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
    }
}