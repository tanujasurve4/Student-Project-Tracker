package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.project.util.DBConnection;

@WebServlet("/DeleteFileServlet")
public class DeleteFileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if(userId == null){
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String fileIdStr = request.getParameter("id");
        if(fileIdStr == null){
            response.sendRedirect(request.getContextPath() + "/jsp/viewProjects.jsp");
            return;
        }

        int fileId = Integer.parseInt(fileIdStr);

        Connection con = null;
        PreparedStatement ps = null;

        try{
            con = DBConnection.getConnection();
            ps = con.prepareStatement("DELETE FROM project_files WHERE id=?");
            ps.setInt(1, fileId);
            ps.executeUpdate();
            ps.close();

            response.sendRedirect(request.getHeader("referer"));
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect(request.getHeader("referer") + "?msg=error");
        } finally{
            try{ if(ps != null) ps.close(); } catch(Exception e){}
            try{ if(con != null) con.close(); } catch(Exception e){}
        }
    }
}