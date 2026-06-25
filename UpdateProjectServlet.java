package com.project.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.util.DBConnection;

@WebServlet("/UpdateProjectServlet")
@MultipartConfig
public class UpdateProjectServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");

        try (Connection con = DBConnection.getConnection()) {

            // 🔹 Update project details
            PreparedStatement ps = con.prepareStatement(
                "UPDATE projects SET title=?, description=? WHERE id=?"
            );
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, id);
            ps.executeUpdate();

            // 🔹 Insert new files
            for (Part part : request.getParts()) {

                if (part.getName().equals("images") && part.getSize() > 0) {

                    PreparedStatement psFile = con.prepareStatement(
                        "INSERT INTO project_files(project_id,file_type,file_name,file_data) VALUES(?,?,?,?)"
                    );
                    psFile.setInt(1, id);
                    psFile.setString(2, "image");
                    psFile.setString(3, part.getSubmittedFileName());
                    psFile.setBlob(4, part.getInputStream());
                    psFile.executeUpdate();
                }

                if (part.getName().equals("pdfs") && part.getSize() > 0) {

                    PreparedStatement psFile = con.prepareStatement(
                        "INSERT INTO project_files(project_id,file_type,file_name,file_data) VALUES(?,?,?,?)"
                    );
                    psFile.setInt(1, id);
                    psFile.setString(2, "pdf");
                    psFile.setString(3, part.getSubmittedFileName());
                    psFile.setBlob(4, part.getInputStream());
                    psFile.executeUpdate();
                }
            }

            response.sendRedirect("jsp/viewProjectDetail.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}