<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
if(session.getAttribute("teacher_id") == null){
    response.sendRedirect("../index.jsp");
    return;
}
String name = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Notices</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4" 
     style="background: linear-gradient(90deg, #ff7e5f, #feb47b);">
    <div class="container-fluid">
        <a class="navbar-brand fs-5">
            <i class="fas fa-project-diagram"></i> Student Project Tracker
        </a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3"><i class="fas fa-user"></i> <%= name %></span>
            <a href="<%=request.getContextPath()%>/jsp/adminDashboard.jsp" class="btn btn-light me-2">
                <i class="fas fa-arrow-left"></i> Back
            </a>
            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h3>📰 All Notices</h3>
    <table class="table table-bordered mt-3">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Message</th>
                <th>Teacher</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
        try(Connection con = DBConnection.getConnection()){
            PreparedStatement ps = con.prepareStatement(
                "SELECT n.id, n.title, n.message, t.name, n.created_at " +
                "FROM notices n JOIN teachers t ON n.teacher_id = t.id ORDER BY n.id DESC"
            );
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("message") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td>
                    <a href="editNotice.jsp?id=<%=rs.getInt("id")%>" class="btn btn-sm btn-warning">
                        ✏ Edit
                    </a>
                    <a href="<%=request.getContextPath()%>/DeleteNoticeServlet?id=<%=rs.getInt("id")%>" 
                       class="btn btn-sm btn-danger" 
                       onclick="return confirm('Delete this notice?');">
                        🗑 Delete
                    </a>
                </td>
            </tr>
        <%
            }
            rs.close();
            ps.close();
        } catch(Exception e){
            out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
        }
        %>
        </tbody>
    </table>
</div>

</body>
</html>