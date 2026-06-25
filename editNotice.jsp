<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
if(session.getAttribute("teacher_id") == null){
    response.sendRedirect("../index.jsp");
    return;
}
String name = (String) session.getAttribute("name");

int noticeId = Integer.parseInt(request.getParameter("id"));
String title = "";
String message = "";

try(Connection con = DBConnection.getConnection()){
    PreparedStatement ps = con.prepareStatement("SELECT title, message FROM notices WHERE id=?");
    ps.setInt(1, noticeId);
    ResultSet rs = ps.executeQuery();
    if(rs.next()){
        title = rs.getString("title");
        message = rs.getString("message");
    }
} catch(Exception e){
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Notice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">

<h3 class="mb-4 text-center">✏ Edit Notice</h3>

<form action="<%=request.getContextPath()%>/UpdateNoticeServlet" method="post">
    <input type="hidden" name="id" value="<%= noticeId %>">
    <input type="text" name="title" class="form-control mb-2" placeholder="Title" value="<%= title %>" required>
    <textarea name="message" class="form-control mb-2" placeholder="Message" rows="5" required><%= message %></textarea>
    <button class="btn btn-success">Update Notice</button>
</form>

</body>
</html>