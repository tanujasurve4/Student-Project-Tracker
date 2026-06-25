package com.project.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.util.DBConnection;

@WebServlet("/ViewImageServlet")
public class ViewImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int fileId = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT file_data FROM project_files WHERE id=? AND file_type='image'"
            );
            ps.setInt(1, fileId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Blob blob = rs.getBlob("file_data");

                response.setContentType("image/jpeg");
                InputStream is = blob.getBinaryStream();
                OutputStream os = response.getOutputStream();

                byte[] buffer = new byte[4096];
                int bytes;
                while ((bytes = is.read(buffer)) != -1) {
                    os.write(buffer, 0, bytes);
                }

                is.close();
                os.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}