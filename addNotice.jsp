<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>

<%
    // ✅ Session check
    if(session.getAttribute("teacher_id") == null){
        response.sendRedirect("../index.jsp");
        return;
    }
    String name = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Notice</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body { background: linear-gradient(to right, #eef2f3, #dfe9f3); }
        .navbar { background: linear-gradient(to right, #ff7e5f, #feb47b); }
        .form-container { max-width: 600px; margin: auto; padding: 30px; background: #fff; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark p-3 mb-4">
    <div class="container-fluid">
        <a class="navbar-brand fs-5">
            <i class="fas fa-project-diagram"></i> Student Project Tracker
        </a>

        <div class="d-flex align-items-center">
            <span class="text-white me-3">
                <i class="fas fa-user"></i> <%= name %>
            </span>

            <a href="<%=request.getContextPath()%>/jsp/adminDashboard.jsp" class="btn btn-light me-2">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn btn-light">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="form-container mt-5">
    <h3 class="mb-4 text-center">📢 Add Notice</h3>

    <form action="<%=request.getContextPath()%>/AddNoticeServlet" method="post">
        <input type="text" name="title" class="form-control mb-3" placeholder="Title" required>
        <textarea name="message" class="form-control mb-3" placeholder="Message" rows="5" required></textarea>
        <button class="btn btn-primary w-100"><i class="fas fa-paper-plane"></i> Post Notice</button>
    </form>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>