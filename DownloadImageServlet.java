package com.project.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.util.DBConnection;

@WebServlet("/DownloadImageServlet")
public class DownloadImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT file_name, file_data FROM project_files WHERE id=? AND file_type='image'"
            );
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String fileName = rs.getString("file_name");
                Blob blob = rs.getBlob("file_data");

                response.setContentType("image/jpeg");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

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