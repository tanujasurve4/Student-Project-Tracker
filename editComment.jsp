<%@ page import="java.sql.*,com.project.util.DBConnection" %>
<%@ page session="true" %>

<%
/* ================= SESSION CHECK ================= */
if(session.getAttribute("teacher_id") == null){
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
}

String name = (String) session.getAttribute("name");

/* ================= PARAMETER VALIDATION ================= */
String commentIdStr = request.getParameter("id");
String projectIdStr = request.getParameter("project_id");

if(commentIdStr == null || projectIdStr == null){
    response.sendRedirect(request.getContextPath() + "/jsp/viewProjects.jsp");
    return;
}

int commentId = Integer.parseInt(commentIdStr);
int projectId = Integer.parseInt(projectIdStr);

/* ================= FETCH COMMENT ================= */
String comment = null;

try(Connection con = DBConnection.getConnection()){
    PreparedStatement ps = con.prepareStatement(
        "SELECT comment FROM comments WHERE id=?"
    );
    ps.setInt(1, commentId);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        comment = rs.getString("comment");
    }

    rs.close();
    ps.close();
} catch(Exception e){
    out.println("<div class='alert alert-danger text-center'>Error: "+e.getMessage()+"</div>");
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Comment</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body { background: linear-gradient(to right, #eef2f3, #dfe9f3); }
        .navbar { background: linear-gradient(to right, #ff7e5f, #feb47b); }
        .form-container {
            max-width: 600px;
            margin: auto;
            padding: 30px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4">
    <div class="container-fluid">
        <a class="navbar-brand fs-5">
            <i class="fas fa-project-diagram"></i> Student Project Tracker
        </a>

        <div class="d-flex align-items-center">
            <span class="text-white me-3">
                <i class="fas fa-user"></i> <%= name %>
            </span>

            <a href="<%=request.getContextPath()%>/jsp/adminProjectDetail.jsp?id=<%=projectId%>" class="btn btn-light me-2">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<!-- ================= MAIN CONTENT ================= -->
<div class="container">

<% if(comment != null){ %>

    <!-- ✅ FORM -->
    <div class="form-container mt-5">
        <h3 class="mb-4 text-center">
            <i class="fas fa-pen"></i> Edit Comment
        </h3>

        <form action="<%=request.getContextPath()%>/UpdateCommentServlet" method="post">
            <input type="hidden" name="comment_id" value="<%=commentId%>">
            <input type="hidden" name="project_id" value="<%=projectId%>">

            <textarea name="comment" class="form-control mb-3" rows="5" required>
<%=comment%>
            </textarea>

            <button class="btn btn-success w-100">
                <i class="fas fa-save"></i> Update
            </button>
        </form>
    </div>

<% } else { %>

    <!-- ❌ IF COMMENT NOT FOUND -->
    <div class="alert alert-danger text-center mt-5">
        Comment not found or invalid ID!
    </div>

<% } %>

</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>