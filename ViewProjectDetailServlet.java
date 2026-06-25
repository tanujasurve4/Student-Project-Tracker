package com.project.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.project.util.DBConnection;

@WebServlet("/ViewProjectDetailServlet")
public class ViewProjectDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String projectIdStr = request.getParameter("id");
        if(projectIdStr == null){
            out.println("<div class='alert alert-danger'>Project ID missing!</div>");
            return;
        }

        int projectId = Integer.parseInt(projectIdStr);

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("SELECT * FROM projects WHERE id=?");
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                String title = rs.getString("title");
                String desc = rs.getString("description");

                // Bootstrap Tabs
                out.println("<ul class='nav nav-tabs' id='projectTab' role='tablist'>");
                out.println("<li class='nav-item'><button class='nav-link active' id='overview-tab' data-bs-toggle='tab' data-bs-target='#overview'>Overview</button></li>");
                out.println("<li class='nav-item'><button class='nav-link' id='images-tab' data-bs-toggle='tab' data-bs-target='#images'>Images</button></li>");
                out.println("<li class='nav-item'><button class='nav-link' id='pdfs-tab' data-bs-toggle='tab' data-bs-target='#pdfs'>PDFs</button></li>");
                out.println("<li class='nav-item'><button class='nav-link' id='feedback-tab' data-bs-toggle='tab' data-bs-target='#feedback'>Feedback</button></li>");
                out.println("</ul>");

                out.println("<div class='tab-content mt-3'>");

                // Overview Tab
                out.println("<div class='tab-pane fade show active' id='overview'>");
                out.println("<h4 class='text-primary mb-2'>" + title + "</h4>");
                out.println("<p>" + desc + "</p>");
                out.println("</div>");

                // Images Tab
                out.println("<div class='tab-pane fade' id='images'>");
                out.println("<div class='d-flex flex-wrap'>");

                PreparedStatement psImg = con.prepareStatement(
                    "SELECT id, file_name FROM project_files WHERE project_id=? AND file_type='image'"
                );
                psImg.setInt(1, projectId);
                ResultSet rsImg = psImg.executeQuery();

                boolean hasImage = false;
                while(rsImg.next()){
                    hasImage = true;
                    int imgId = rsImg.getInt("id");
                    String fileName = rsImg.getString("file_name");

                    out.println("<img src='" + request.getContextPath() + "/ViewImageServlet?id=" + imgId + "' " +
                                "onclick=\"openModal('" + request.getContextPath() + "/ViewImageServlet?id=" + imgId + "', '" + fileName + "')\" " +
                                "class='me-2 mb-2' style='height:100px;width:100px;object-fit:cover;border-radius:6px;cursor:pointer;'>");
                }
                if(!hasImage){
                    out.println("<p class='text-muted'>No images uploaded</p>");
                }
                out.println("</div>");
                out.println("</div>");
                rsImg.close();
                psImg.close();

                // PDFs Tab
                out.println("<div class='tab-pane fade' id='pdfs'>");
                PreparedStatement psPdf = con.prepareStatement(
                    "SELECT id, file_name FROM project_files WHERE project_id=? AND file_type='pdf'"
                );
                psPdf.setInt(1, projectId);
                ResultSet rsPdf = psPdf.executeQuery();

                boolean hasPDF = false;
                while(rsPdf.next()){
                    hasPDF = true;
                    int pdfId = rsPdf.getInt("id");
                    String fileName = rsPdf.getString("file_name");

                    out.println("<div class='d-flex mb-2'>");
                    out.println("<a href='" + request.getContextPath() + "/ViewPDFServlet?id=" + pdfId + "' target='_blank' class='btn btn-sm btn-primary me-2'>View</a>");
                    out.println("<a href='" + request.getContextPath() + "/DownloadPDFServlet?id=" + pdfId + "' class='btn btn-sm btn-success me-2'>Download</a>");
                    out.println("<span class='align-self-center small'>" + fileName + "</span>");
                    out.println("</div>");
                }
                if(!hasPDF){
                    out.println("<p class='text-muted'>No PDFs uploaded</p>");
                }
                out.println("</div>");
                rsPdf.close();
                psPdf.close();

                // Feedback Tab
                out.println("<div class='tab-pane fade' id='feedback'>");
                PreparedStatement psC = con.prepareStatement(
                    "SELECT c.comment, t.name FROM comments c JOIN teachers t ON c.teacher_id=t.id WHERE c.project_id=?"
                );
                psC.setInt(1, projectId);
                ResultSet rsC = psC.executeQuery();

                boolean hasComments = false;
                while(rsC.next()){
                    hasComments = true;
                    out.println("<div class='alert alert-info p-2 mb-2'>");
                    out.println("<b><i class='fas fa-user'></i> " + rsC.getString("name") + ":</b><br>");
                    out.println(rsC.getString("comment"));
                    out.println("</div>");
                }
                if(!hasComments){
                    out.println("<p class='text-muted'>No feedback yet</p>");
                }
                out.println("</div>");
                rsC.close();
                psC.close();

                // Edit/Delete buttons (common)
                out.println("<div class='mt-3 d-flex justify-content-between'>");
                out.println("<a href='" + request.getContextPath() + "/jsp/updateProject.jsp?id=" + projectId + "' class='btn btn-warning btn-sm'>✏ Edit</a>");
                out.println("<a href='" + request.getContextPath() + "/DeleteProjectServlet?id=" + projectId + "' class='btn btn-danger btn-sm' onclick=\"return confirm('Delete this project?');\">🗑 Delete</a>");
                out.println("</div>");

                out.println("</div>"); // tab-content

            } else {
                out.println("<div class='alert alert-warning'>Project not found!</div>");
            }

            rs.close();
            ps.close();

        } catch(Exception e){
            out.println("<div class='alert alert-danger'>Error: "+e.getMessage()+"</div>");
        }
    }
}