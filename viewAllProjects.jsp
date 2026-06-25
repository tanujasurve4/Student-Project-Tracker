<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
    String name = (String) session.getAttribute("name");

    // Admin check
    if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))){
        response.sendRedirect("../index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Projects</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body { background: #eef2f3; }
        .card { border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.1); transition:0.3s;}
        .card:hover { transform: translateY(-3px); }
        .card-title { min-height: 45px; }
        .card-text { min-height: 60px; }
    </style>
</head>
<body>
<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4" style="background: linear-gradient(90deg,#ff7e5f,#feb47b);">
    <div class="container-fluid">
        <a class="navbar-brand fs-5"><i class="fas fa-project-diagram"></i> Student Project Tracker</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3"><i class="fas fa-user"></i> <%= name %></span>
            <a href="<%=request.getContextPath()%>/jsp/adminDashboard.jsp" class="btn btn-light me-2"><i class="fas fa-arrow-left"></i> Back</a>
            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h3>📁 All Student Projects</h3>
    <div class="row">

<%
try (Connection con = DBConnection.getConnection();
     PreparedStatement ps = con.prepareStatement(
        "SELECT p.id, p.title, p.description, s.name AS student_name FROM projects p " +
        "JOIN students s ON p.user_id = s.user_id ORDER BY p.id DESC");
     ResultSet rs = ps.executeQuery()) {

    boolean hasProjects = false;
    while(rs.next()){
        hasProjects = true;
        int projectId = rs.getInt("id");
        String title = rs.getString("title");
        String studentName = rs.getString("student_name");
        String desc = rs.getString("description");
%>

        <div class="col-md-4 mb-4">
            <div class="card p-3">
                <h5 class="text-primary card-title"><%= title %></h5>
                <p><b>Student:</b> <%= studentName %></p>
                <p class="card-text"><%= desc != null && desc.length() > 80 ? desc.substring(0,80)+"..." : desc %></p>
                <a href="adminProjectDetail.jsp?id=<%=projectId%>" class="btn btn-info btn-sm">
                    <i class="fas fa-eye"></i> View Details
                </a>
            </div>
        </div>

<%
    } // end while

    if(!hasProjects){
%>
        <div class="col-12">
            <div class="alert alert-warning">No projects found.</div>
        </div>
<%
    }

} catch(Exception e){
%>
    <div class="alert alert-danger">Error: <%= e.getMessage() %></div>
<%
}
%>

    </div> <!-- row -->
</div> <!-- container -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>