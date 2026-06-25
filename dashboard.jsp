<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
    // ✅ SESSION CHECK
    if(session.getAttribute("user_id") == null || 
       !"student".equals(session.getAttribute("role"))){
        response.sendRedirect("../index.jsp");
        return;
    }

    Connection con = null;
    String name = (String) session.getAttribute("name");

    try {
        con = DBConnection.getConnection();
    } catch(Exception e){
        out.println("<div class='alert alert-danger'>DB Connection Error</div>");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Dashboard</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
body {
    background: linear-gradient(to right, #eef2f3, #dfe9f3);
}

/* Navbar */
.navbar {
    background: linear-gradient(to right, #4facfe, #00f2fe);
}
.navbar-brand {
    font-size: 28px;
    font-weight: bold;
    color: white !important;
}

/* Welcome */
.welcome-box {
    background: linear-gradient(to right, #4facfe, #00c6ff);
    color: white;
    padding: 20px;
    border-radius: 15px;
}

/* Cards */
.card-custom {
    border-radius: 20px;
    padding: 20px;
    transition: 0.3s;
    border: none;
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}
.card-custom:hover {
    transform: translateY(-5px);
}

/* Notice */
.notice-card {
    border-left: 6px solid #4facfe;
    background: white;
    padding: 15px;
    margin-bottom: 12px;
    border-radius: 12px;
}
</style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="navbar navbar-expand-lg">
<div class="container-fluid">
    <a class="navbar-brand">
        <i class="fas fa-project-diagram"></i> Student Project Tracker
    </a>

    <div>
        <span class="text-white me-3">
            <i class="fas fa-user"></i> <%= name %>
        </span>

        <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</div>
</nav>


<div class="container mt-4">

<!-- 🔹 Welcome -->
<div class="welcome-box mb-4">
    <h3>Welcome, <%= name %> 👋</h3>
    <p>Manage your projects and track progress 🚀</p>
</div>

<!-- 🔹 Actions -->
<div class="row">

    <div class="col-md-6 mb-3">
        <div class="card card-custom text-center">
            <i class="fas fa-plus-circle fa-2x text-primary mb-2"></i>
            <h5>Add Project</h5>
            <a href="<%=request.getContextPath()%>/jsp/addProject.jsp" class="btn btn-primary mt-2">
                Add
            </a>
        </div>
    </div>

    <div class="col-md-6 mb-3">
        <div class="card card-custom text-center">
            <i class="fas fa-folder-open fa-2x text-success mb-2"></i>
            <h5>View Projects</h5>
            <a href="<%=request.getContextPath()%>/jsp/viewProjects.jsp" class="btn btn-success mt-2">
                View
            </a>
        </div>
    </div>

</div>

<!-- 🔥 LATEST NOTICE -->
<h4 class="mt-4 mb-3">
    <i class="fas fa-bullhorn"></i> Latest Notice
</h4>

<%
PreparedStatement ps3 = null;
ResultSet rs3 = null;

try {

    // ✅ Only fetch the latest notice
    ps3 = con.prepareStatement(
        "SELECT n.title, n.message, n.created_at, t.name " +
        "FROM notices n LEFT JOIN teachers t ON n.teacher_id = t.id " +
        "ORDER BY n.created_at DESC " +
        "LIMIT 1"  // only the latest notice
    );

    rs3 = ps3.executeQuery();

    if(rs3.next()){  // Only one notice
%>

    <div class="notice-card">
        <h5><%= rs3.getString("title") %></h5>
        <p><%= rs3.getString("message") %></p>
        <small class="text-muted">
            Posted by: 
            <b><%= rs3.getString("name") != null ? rs3.getString("name") : "Admin" %></b> |
            <%= rs3.getTimestamp("created_at") %>
        </small>
    </div>

<%
    } else {
%>
    <div class="alert alert-info">No notices available</div>
<%
    }

} catch(Exception e){
%>
    <div class="alert alert-danger">
        Error loading notices: <%= e.getMessage() %>
    </div>
<%
} finally {
    try {
        if(rs3 != null) rs3.close();
        if(ps3 != null) ps3.close();
        if(con != null) con.close();
    } catch(Exception ex){}
}
%>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>