package com.project.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Blob;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.project.util.DBConnection;

@WebServlet("/DownloadPDFServlet")
public class DownloadPDFServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int fileId = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT file_name, file_data FROM project_files WHERE id=? AND file_type='pdf'"
            );
            ps.setInt(1, fileId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String fileName = rs.getString("file_name");
                Blob blob = rs.getBlob("file_data");

                response.setContentType("application/pdf");
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

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}