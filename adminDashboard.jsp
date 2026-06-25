<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
    // ✅ Admin session check
    if(session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))){
        response.sendRedirect("../index.jsp");
        return;
    }
    String name = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body { background: linear-gradient(to right, #eef2f3, #dfe9f3); }
        .navbar { background: linear-gradient(to right, #ff7e5f, #feb47b); }
        .card { border-radius: 15px; padding: 20px; box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .card h5 { font-weight: 600; }
        .table th, .table td { vertical-align: middle; }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark p-3">
    <div class="container-fluid">
        <a class="navbar-brand fs-4">
            <i class="fas fa-project-diagram"></i> Student Project Tracker
        </a>

        <div class="d-flex align-items-center">
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
    <h4 class="mb-4">Welcome, <%= name %> 👋</h4>

    <div class="row g-4">

        <!-- VIEW PROJECTS -->
        <div class="col-md-4">
            <div class="card text-center">
                <h5>📁 View All Projects</h5>
                <a href="<%=request.getContextPath()%>/jsp/viewAllProjects.jsp" class="btn btn-primary mt-3">
                    Open
                </a>
            </div>
        </div>

        <!-- ADD NOTICE -->
        <div class="col-md-4">
            <div class="card text-center">
                <h5>📢 Add Notice</h5>
                <a href="<%=request.getContextPath()%>/jsp/addNotice.jsp" class="btn btn-success mt-3">
                    Open
                </a>
            </div>
        </div>

        <!-- VIEW ALL NOTICES -->
        <div class="col-md-4">
            <div class="card text-center">
                <h5>📰 View All Notices</h5>
                <a href="<%=request.getContextPath()%>/jsp/viewAllNotices.jsp" class="btn btn-primary mt-3">
                    Open
                </a>
            </div>
        </div>

    </div>

    <!-- 🔥 CURRENT PROJECTS TABLE -->
    <div class="card mt-5">
        <h5 class="mb-3">🎯 Current Projects</h5>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Student Name</th>
                        <th>Project Name</th>
                        <th>Progress Status</th>
                        <th>Action</th> <!-- 4th column -->
                    </tr>
                </thead>
                <tbody>
                <%
                    try(Connection con = DBConnection.getConnection()){
                        String query = "SELECT s.user_id, s.name AS student_name, " +
                                       "p.id AS project_id, p.title AS project_name, p.status " +
                                       "FROM students s " +
                                       "JOIN projects p ON s.user_id = p.user_id " +
                                       "WHERE p.status IN ('Planned','In Progress','Completed') " +
                                       "ORDER BY s.name ASC";

                        PreparedStatement ps = con.prepareStatement(query);
                        ResultSet rs = ps.executeQuery();

                        int count = 1;
                        while(rs.next()){
                %>
                    <tr>
                        <td><%= count++ %></td>
                        <td><%= rs.getString("student_name") %></td>
                        <td><%= rs.getString("project_name") %></td>
                        <td><%= rs.getString("status") %></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/jsp/adminProjectDetail.jsp?id=<%=rs.getInt("project_id")%>" 
                               class="btn btn-sm btn-primary">View</a>
                        </td>
                    </tr>
                <%
                        }
                        rs.close();
                        ps.close();
                    }catch(Exception e){
                        out.println("<tr><td colspan='5' class='text-danger'>"+e.getMessage()+"</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>